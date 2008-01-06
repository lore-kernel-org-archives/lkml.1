Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYAFNRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYAFNRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYAFNRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:17:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbYAFNRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:17:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Sun, 6 Jan 2008 14:19:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801052249060.8784-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801052249060.8784-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061419.52277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of January 2008, Alan Stern wrote:
> On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:
> 
> > On Saturday, 5 of January 2008, Alan Stern wrote:
> > > On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:
> 
> > > > Still, even doing that is not enough, since someone can call
> > > > destroy_suspended_device() from a .suspend() routine and then the device
> > > > will end up on a wrong list just as well.
> > > 
> > > That should never happen.  The whole idea of destroy_suspended_device()
> > > is that the device couldn't be resumed and in fact should be
> > > unregistered because it is no longer working or no longer present.  A
> > > suspend routine won't detect this sort of thing since it doesn't try to
> > > resume the device.
> > > 
> > > But it wouldn't hurt to mention in the kerneldoc that 
> > > destroy_suspended_device() is meant to be called only during a system 
> > > resume.
> > 
> > Hmm.  Please have a look at the appended patch.
> > 
> > I have removed the warning from device_del() and used list_empty() to detect
> > removed devices in the .suspend() routines.  Is that viable?
> 
> It's not good.
> 
> The warning in device_del() is vital.  It's what will tell people where
> the problem is when a deadlock occurs during system resume because some
> driver has mistakenly tried to unregister a device at the wrong time.  
> It would have pointed immediately to the msr driver in the case of the
> bug Andrew found, for instance.
> 
> If you can figure out a way to disable the warning in device_del() for 
> just the one device being unregistered by 
> device_pm_destroy_suspended(),

Something like this, perhaps:

@@ -905,6 +915,18 @@ void device_del(struct device * dev)
 	struct device * parent = dev->parent;
 	struct class_interface *class_intf;
 
+	if (down_trylock(&dev->sem)) {
+		if (pm_sleep_lock()) {
+			dev_warn(dev, "Illegal %s during suspend\n",
+				__FUNCTION__);
+			dump_stack();
+		} else {
+			pm_sleep_unlock();
+		}
+	} else {
+		up(&dev->sem);
+	}
+
 	if (parent)
 		klist_del(&dev->knode_parent);
 	if (MAJOR(dev->devt))

> I suppose that would be okay. 

Rafael
