Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbYAYTnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbYAYTnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYAYTns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:43:48 -0500
Received: from ns.suse.de ([195.135.220.2]:47709 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbYAYTns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:43:48 -0500
Date: Fri, 25 Jan 2008 11:42:19 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080125194219.GA4596@suse.de>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 10:44:59AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 24 Jan 2008, Greg KH wrote:
> > 
> > Here are a pretty large number of kobject, documentation, and driver
> > core patches against your 2.6.24 git tree.
> 
> I've merged it all, but it causes lots of scary warnings:
> 
>  - from the purely broken ones:
> 
> 	ehci_hcd: no version for "struct_module" found: kernel tainted.

Ok, in looking at the code, this should also be showing up for you on a
"clean" 2.6.24 release, I didn't change anything in this code path.

That is what taints your kernel with the "F" flag.

>  - to the scary ones:
> 
> 	sysfs: duplicate filename 'ehci_hcd' can not be created
> 	WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> 	Pid: 610, comm: insmod Tainted: GF       2.6.24-gb47711bf #28
> 	
> 	Call Trace:
> 	 [<ffffffff802bd63c>] sysfs_add_one+0x54/0xbd
> 	 [<ffffffff802bdbc0>] create_dir+0x4f/0x87
> 	 [<ffffffff802bdc2d>] sysfs_create_dir+0x35/0x4a
> 	 [<ffffffff803154c8>] kobject_get+0x12/0x17
> 	 [<ffffffff80315607>] kobject_add_internal+0xd9/0x194
> 	 [<ffffffff8031579c>] kobject_add_varg+0x54/0x61
> 	 [<ffffffff80261efe>] __alloc_pages+0x66/0x2ee
> 	 [<ffffffff80315321>] kobject_init+0x42/0x82
> 	 [<ffffffff80315843>] kobject_init_and_add+0x9a/0xa7
> 	 [<ffffffff802722c0>] __vmalloc_area_node+0x111/0x135
> 	 [<ffffffff8025546b>] mod_sysfs_init+0x6e/0x83
> 	 [<ffffffff802561e8>] sys_init_module+0xa3d/0x1833
> 	 [<ffffffff8028ebd5>] dput+0x1c/0x10b
> 	 [<ffffffff8020b3be>] system_call+0x7e/0x83

This is the sysfs core telling you that someone did something stupid :)

Yes, that's new, but the "error" was always there, I just made the
warning more visible to get people to pay attention to it, and find the
real errors where this happens (and it has found them, which is a good
thing.)

But in this case, it doesn't look like the module loading code will
detect that we are trying to load a module that is already present until
the kobjects are set up here.  It's been this way for a long time :(

Rusty, any ideas of us adding a different check for "duplicate" modules
like this earlier in the load_module() function, so we don't spend so
much effort in building everything up when we don't need to?

I think it's down in the apply_relocate() function where we would
finally figure out that something bad is going on here, which seems a
bit late to me.

I guess we could just check the list of module names loaded when we try
to set up the kobject, that would be simple and easy.

Linus, does the patch below (built tested only) fix the above call trace
noise for you?  It shouldn't change the taint flag, that's a different
issue it seems.

thanks,

greg k-h

---------------------

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: module: bail out of loading duplicate modules early

This should fix the long calltrace when trying to load a module that has
been built into the kernel allready.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/kernel/module.c b/kernel/module.c
index dcb8a2c..3a76a4d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1210,6 +1210,7 @@ void module_remove_modinfo_attrs(struct module *mod)
 int mod_sysfs_init(struct module *mod)
 {
 	int err;
+	struct kobject *kobj;
 
 	if (!module_sysfs_initialized) {
 		printk(KERN_ERR "%s: module sysfs not initialized\n",
@@ -1217,6 +1218,15 @@ int mod_sysfs_init(struct module *mod)
 		err = -EINVAL;
 		goto out;
 	}
+
+	kobj = kset_find_obj(module_kset, mod->name);
+	if (kobj) {
+		printk(KERN_ERR "%s: module is already loaded\n", mod->name);
+		kobject_put(kobj);
+		err = -EINVAL;
+		goto out;
+	}
+
 	mod->mkobj.mod = mod;
 
 	memset(&mod->mkobj.kobj, 0, sizeof(mod->mkobj.kobj));
