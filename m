Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYAFEEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYAFEEs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 23:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYAFEEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 23:04:36 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2614 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752864AbYAFEEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 23:04:36 -0500
Date: Sat, 5 Jan 2008 23:04:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801052258.52272.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801052249060.8784-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:

> On Saturday, 5 of January 2008, Alan Stern wrote:
> > On Sat, 5 Jan 2008, Rafael J. Wysocki wrote:

> > > Still, even doing that is not enough, since someone can call
> > > destroy_suspended_device() from a .suspend() routine and then the device
> > > will end up on a wrong list just as well.
> > 
> > That should never happen.  The whole idea of destroy_suspended_device()
> > is that the device couldn't be resumed and in fact should be
> > unregistered because it is no longer working or no longer present.  A
> > suspend routine won't detect this sort of thing since it doesn't try to
> > resume the device.
> > 
> > But it wouldn't hurt to mention in the kerneldoc that 
> > destroy_suspended_device() is meant to be called only during a system 
> > resume.
> 
> Hmm.  Please have a look at the appended patch.
> 
> I have removed the warning from device_del() and used list_empty() to detect
> removed devices in the .suspend() routines.  Is that viable?

It's not good.

The warning in device_del() is vital.  It's what will tell people where
the problem is when a deadlock occurs during system resume because some
driver has mistakenly tried to unregister a device at the wrong time.  
It would have pointed immediately to the msr driver in the case of the
bug Andrew found, for instance.

If you can figure out a way to disable the warning in device_del() for 
just the one device being unregistered by 
device_pm_destroy_suspended(), I suppose that would be okay.

Alan Stern



