Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYCIG2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYCIG2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 01:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYCIG2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 01:28:01 -0500
Received: from mx1.suse.de ([195.135.220.2]:54026 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYCIG2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 01:28:01 -0500
Date: Sat, 8 Mar 2008 22:33:08 -0800
From: Greg KH <gregkh@suse.de>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark kobjects as unitialized
Message-ID: <20080309063308.GA5297@suse.de>
References: <200803062223.18857.balajirrao@gmail.com> <200803062320.50296.balajirrao@gmail.com> <20080306180559.GA14934@suse.de> <200803090337.16253.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803090337.16253.balajirrao@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 03:37:16AM +0530, Balaji Rao wrote:
> On Thursday 06 March 2008 11:35:59 pm Greg KH wrote:
> > On Thu, Mar 06, 2008 at 11:20:50PM +0530, Balaji Rao wrote:
> > > On Thursday 06 March 2008 10:35:14 pm Greg KH wrote:
> > > <snip>
> > > > Where exactly in the code does that happen?  kobjects should not be
> > > > "reused" as that implies that they are static, and not dynamically
> > > > allocated, right?
> > > >
> > > > Which kobject is this?
> > > Yes, its static. Here's the code from virt/kvm_main.c:1269
> > > 
> > > static struct sys_device kvm_sysdev = {
> > >         .id = 0,
> > >         .cls = &kvm_sysdev_class,
> > > };
> > > 
> > > this sys_device is being registered/unregistered when kvm-intel is 
> > > loaded/unloaded.
> > 
> > Ah, ok.  I'll add this patch then.
> > 
> > > > Ugh, is this the sys_device stuff?  I hate that code...
> > > >
> > > Yes it is! But, why do you hate it ?
> > 
> > For reasons like this :)
> > 
> > kobjects should not be static.  the sysdevice stuff was a hack when it
> > was originally created and never touched since the mid 2.5 days.  It
> > needs to be fixed up a lot, and is on my TODO list, slowly getting
> > closer to the top...
> Hi,
> 
> This patch does not fix it all! The problem is in fact more involved. I also get these BUG reports when I reload kvm-intel.
> 
> BUG kmalloc-8: Object already free
> [  74.696570] -----------------------------------------------------------------------------
> [   74.696596] 
> [   74.697310] INFO: Allocated in strndup_user+0x30/0x62 age=587 cpu=2 pid=1439
> [   74.697845] INFO: Freed in kobject_set_name_vargs+0x29/0x32 age=559 cpu=3 pid=1439
> [   74.698008] INFO: Slab 0xc16f93a0 used=10 fp=0xf7c9d2d8 flags=0x10000c3
> [   74.698008] INFO: Object 0xf7c9d1f8 @offset=504 fp=0xf7c9d578
> 
> This happens because, sysdev_class_register assigns a name to the
> kobject, and kfrees the old name if any. The poisoned 'name' object
> persists in case of statically allocated kobjects and as its passed to
> kfree again when re registered, we get the above warning.
> 
> So, AFAICS the best way to solve this is by fixing the kobject users
> (kvm, oprofile etc.) to use dynamic kobjects instead of static ones or
> memset the kobject to zero before passing it to sysdev_register.

I like the memset idea, how about this patch instead?

thanks,

greg k-h

--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -133,6 +133,7 @@ int sysdev_class_register(struct sysdev_
 	pr_debug("Registering sysdev class '%s'\n",
 		 kobject_name(&cls->kset.kobj));
 	INIT_LIST_HEAD(&cls->drivers);
+	memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
