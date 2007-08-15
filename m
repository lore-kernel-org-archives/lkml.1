Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbXHOOjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbXHOOjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbXHOOi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:38:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33025 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758264AbXHOOi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:38:57 -0400
Date: Wed, 15 Aug 2007 10:38:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florin Iucha <florin@iucha.net>
cc: Tejun Heo <htejun@gmail.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
 v2.6.23-rc3-50-g28e8351
In-Reply-To: <20070815133147.GA7124@iucha.net>
Message-ID: <Pine.LNX.4.44L0.0708151033270.3895-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Florin Iucha wrote:

> Today my USB keyboard stopped working in the middle of composing and
> e-mail.  I unplugged it and plugged it back, with no success.  I
> logged in remotely and found this lovely message:
> 
> [ 1301.567351] usb 1-4: USB disconnect, address 3
> [ 1301.567356] usb 1-4.2: USB disconnect, address 5
> [ 1301.567599] sysfs_remove_bin_file: bad dentry or inode or no such file: "descriptors"
> [ 1301.567604] 
> [ 1301.567605] Call Trace:
> [ 1301.567614]  [<ffffffff802b89a6>] sysfs_remove_bin_file+0x39/0x3d
> [ 1301.567619]  [<ffffffff803f1d24>] device_remove_bin_file+0x15/0x17
> [ 1301.567623]  [<ffffffff8045ea0d>] usb_remove_sysfs_dev_files+0x89/0x9d
> [ 1301.567627]  [<ffffffff804625cc>] generic_disconnect+0x2e/0x32
> [ 1301.567630]  [<ffffffff8045b58d>] usb_unbind_device+0x15/0x19
> [ 1301.567634]  [<ffffffff803f4161>] __device_release_driver+0x93/0xb3
> [ 1301.567637]  [<ffffffff803f45af>] device_release_driver+0x31/0x49
> [ 1301.567640]  [<ffffffff803f39f1>] bus_remove_device+0x76/0x87
> [ 1301.567644]  [<ffffffff803f2014>] device_del+0x216/0x297
> [ 1301.567648]  [<ffffffff80455c8f>] usb_disconnect+0xc8/0x151
> [ 1301.567651]  [<ffffffff80455c56>] usb_disconnect+0x8f/0x151
> [ 1301.567655]  [<ffffffff804564c8>] hub_thread+0x442/0xc47
> [ 1301.567659]  [<ffffffff80553cdb>] _spin_unlock_irq+0x9/0xc
> [ 1301.567664]  [<ffffffff80244ad7>] autoremove_wake_function+0x0/0x38
> [ 1301.567668]  [<ffffffff80456086>] hub_thread+0x0/0xc47
> [ 1301.567671]  [<ffffffff802449cb>] kthread+0x49/0x76
> [ 1301.567674]  [<ffffffff8020c618>] child_rip+0xa/0x12
> [ 1301.567679]  [<ffffffff80244982>] kthread+0x0/0x76
> [ 1301.567682]  [<ffffffff8020c60e>] child_rip+0x0/0x12

I think we can simply remove the error message.  There's no obvious 
reason why sysfs_remove_bin_file() should complain about attempts to 
remove a nonexistent file; sysfs_remove_file() doesn't.

This patch will get rid of the annoying error messages.  It won't do 
anything about your keyboard's tendency to spontaneously stop working, 
alas.

Alan Stern


Index: usb-2.6/fs/sysfs/bin.c
===================================================================
--- usb-2.6.orig/fs/sysfs/bin.c
+++ usb-2.6/fs/sysfs/bin.c
@@ -248,12 +248,7 @@ int sysfs_create_bin_file(struct kobject
 
 void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 {
-	if (sysfs_hash_and_remove(kobj->sd, attr->attr.name) < 0) {
-		printk(KERN_ERR "%s: "
-			"bad dentry or inode or no such file: \"%s\"\n",
-			__FUNCTION__, attr->attr.name);
-		dump_stack();
-	}
+	sysfs_hash_and_remove(kobj->sd, attr->attr.name);
 }
 
 EXPORT_SYMBOL_GPL(sysfs_create_bin_file);

