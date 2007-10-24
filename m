Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbXJXX4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbXJXX4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbXJXX4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:56:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbXJXX4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:56:20 -0400
Date: Wed, 24 Oct 2007 16:52:31 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Miller <davem@davemloft.net>, jens.axboe@oracle.com, rjw@sisk.pl,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Message-ID: <20071024235231.GA6160@kroah.com>
References: <20071016204238.GA1093@kroah.com> <20071016205053.GI9942@kernel.dk> <20071016213730.GB21815@kroah.com> <20071016.153248.95506316.davem@davemloft.net> <20071016232350.GB24827@kroah.com> <1192616214.4300.16.camel@lov.site> <20071024234348.GA4909@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024234348.GA4909@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 04:43:48PM -0700, Greg KH wrote:
> On Wed, Oct 17, 2007 at 12:16:54PM +0200, Kay Sievers wrote:
> > On Tue, 2007-10-16 at 16:23 -0700, Greg KH wrote:
> > > On Tue, Oct 16, 2007 at 03:32:48PM -0700, David Miller wrote:
> > > > From: Greg KH <greg@kroah.com>
> > > > Date: Tue, 16 Oct 2007 14:37:30 -0700
> > > > 
> > > > > Kay, are we doing something wrong in userspace when renaming wireless
> > > > > devices such that we can overlap names?
> > 
> > Not udev, but SUSE 10.2's network renaming. It uses udev and calls
> > ifrename in the same code path. 10.3 uses the unified version from the
> > udev tree.
> > 
> > > > It does it for all network devices, I see this ugly message on every
> > > > single system I have from Fedora foo to RHEL foo to ubuntu foo to
> > > > debian foo.
> > > >
> > > > udev simply applies the MAC address to device name rules blindly, it
> > > > doesn't check if the device already has the desired name already
> > 
> > There is a check for the same name in udev for long.
> > 
> > > Ugh :(
> > > 
> > > > It's been like this forever, and since userland has been doing it for
> > > > so long, you can't warn on this there is too much established
> > > > practice.  Expecting people to install "fixed" udev is not an
> > > > acceptable answer, the warning is a regression and therefore you'll
> > > > have to remove the kernel warning for this case and live with this
> > > > issue essentially forever.
> > 
> > We should probably just add the check to kobject_rename() and print a
> > simple warning and then do nothing. Or just do the check in the network
> > ioctl, if we really don't want to see this.
> 
> I agree that perhaps kobject_rename() should check for this.  Let me go
> see if I can get that to work...

Can someone try this patch, and see what happens when they try to rename
an object to something that is already existing?

thanks,

greg k-h


---
 lib/kobject.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -366,6 +366,19 @@ int kobject_rename(struct kobject * kobj
 	if (!kobj->parent)
 		return -EINVAL;
 
+	/* see if this name is already in use */
+	if (kobj->kset) {
+		struct kobject *temp_kobj;
+		temp_kobj = kset_find_obj(kobj->kset, new_name);
+		if (temp_kobj) {
+			printk(KERN_WARNING "kobject '%s' can not be renamed "
+			       "to '%s' as '%s' is already in existance.\n",
+			       kobject_name(kobj), new_name, new_name);
+			kobject_put(temp_kobj);
+			return -EINVAL;
+		}
+	}
+
 	devpath = kobject_get_path(kobj, GFP_KERNEL);
 	if (!devpath) {
 		error = -ENOMEM;
