Return-Path: <linux-kernel-owner+w=401wt.eu-S1765604AbXJZRGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765604AbXJZRGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbXJZRFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:05:55 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63183 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbXJZRFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:05:54 -0400
Message-ID: <47221E6F.1090607@lwfinger.net>
Date: Fri, 26 Oct 2007 12:05:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On my openSUSE 10.3 x86_64 system running v2.6.24-rc1-281-g22d2aa1, I get the sysfs rename messages.

Using Greg's patch, nothing changed. The log results are:

sysfs: duplicate filename 'eth1' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

Call Trace:
 [<ffffffff802d1180>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d20e1>] sysfs_create_link+0xd3/0x12e
 [<ffffffff80363855>] device_rename+0x17a/0x1db
 [<ffffffff80393a5d>] dev_change_name+0x101/0x1fe
 [<ffffffff80393d5e>] dev_ifsioc+0x204/0x2bf
 [<ffffffff80394352>] dev_ioctl+0x539/0x644
 [<ffffffff80252e12>] __lock_acquire+0xd26/0xd47
 [<ffffffff8028fab9>] fd_install+0x30/0x68
 [<ffffffff80386ca2>] sock_ioctl+0x204/0x212
 [<ffffffff8029d666>] do_ioctl+0x2a/0x77
 [<ffffffff8029d904>] vfs_ioctl+0x251/0x26e
 [<ffffffff803eff8b>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8029d963>] sys_ioctl+0x42/0x67
 [<ffffffff8020c15e>] system_call+0x7e/0x83

net eth1: device_rename: sysfs_create_symlink failed (-17)
udev: renamed network interface wlan0 to eth1
===========================================================

Kay's patch shows the following BUG, as well as the rename message:

BUG: sleeping function called from invalid context at kernel/mutex.c:207
in_atomic():1, irqs_disabled():0
2 locks held by udevd/1965:
 #0:  (rtnl_mutex){--..}, at: [<ffffffff8039c6f4>] rtnl_lock+0x12/0x14
 #1:  (&dev_base_lock){-.--}, at: [<ffffffff80393a1b>] dev_change_name+0xff/0x1f0

Call Trace:
 [<ffffffff80250854>] debug_show_held_locks+0x22/0x24
 [<ffffffff8022d10c>] __might_sleep+0x10a/0x10c
 [<ffffffff803ef006>] mutex_lock_nested+0x28/0x2e1
 [<ffffffff802f387d>] kobject_rename+0x6b/0xea
 [<ffffffff802d19b9>] sysfs_rename_dir+0x2d/0x178
 [<ffffffff802f387d>] kobject_rename+0x6b/0xea
 [<ffffffff802f38b0>] kobject_rename+0x9e/0xea
 [<ffffffff80363760>] device_rename+0xc5/0x1db
 [<ffffffff80393a26>] dev_change_name+0x10a/0x1f0
 [<ffffffff80393d10>] dev_ifsioc+0x204/0x2bf
 [<ffffffff80394304>] dev_ioctl+0x539/0x644
 [<ffffffff80252e12>] __lock_acquire+0xd26/0xd47
 [<ffffffff8028fab9>] fd_install+0x30/0x68
 [<ffffffff80386c62>] sock_ioctl+0x204/0x212
 [<ffffffff8029d666>] do_ioctl+0x2a/0x77
 [<ffffffff8029d904>] vfs_ioctl+0x251/0x26e
 [<ffffffff803eff3b>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8029d963>] sys_ioctl+0x42/0x67
 [<ffffffff8020c15e>] system_call+0x7e/0x83

WARNING: at kernel/mutex.c:135 __mutex_lock_common()

Call Trace:
 [<ffffffff8022d10c>] __might_sleep+0x10a/0x10c
 [<ffffffff803ef062>] mutex_lock_nested+0x84/0x2e1
 [<ffffffff802f387d>] kobject_rename+0x6b/0xea
 [<ffffffff802d19b9>] sysfs_rename_dir+0x2d/0x178
 [<ffffffff802f387d>] kobject_rename+0x6b/0xea
 [<ffffffff802f38b0>] kobject_rename+0x9e/0xea
 [<ffffffff80363760>] device_rename+0xc5/0x1db
 [<ffffffff80393a26>] dev_change_name+0x10a/0x1f0
 [<ffffffff80393d10>] dev_ifsioc+0x204/0x2bf
 [<ffffffff80394304>] dev_ioctl+0x539/0x644
 [<ffffffff80252e12>] __lock_acquire+0xd26/0xd47
 [<ffffffff8028fab9>] fd_install+0x30/0x68
 [<ffffffff80386c62>] sock_ioctl+0x204/0x212
 [<ffffffff8029d666>] do_ioctl+0x2a/0x77
 [<ffffffff8029d904>] vfs_ioctl+0x251/0x26e
 [<ffffffff803eff3b>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8029d963>] sys_ioctl+0x42/0x67
 [<ffffffff8020c15e>] system_call+0x7e/0x83

sysfs: duplicate filename 'eth1' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

Call Trace:
 [<ffffffff802d1180>] sysfs_add_one+0x5c/0xc9
 [<ffffffff802d20e1>] sysfs_create_link+0xd3/0x12e
 [<ffffffff80363815>] device_rename+0x17a/0x1db
 [<ffffffff80393a26>] dev_change_name+0x10a/0x1f0
 [<ffffffff80393d10>] dev_ifsioc+0x204/0x2bf
 [<ffffffff80394304>] dev_ioctl+0x539/0x644
 [<ffffffff80252e12>] __lock_acquire+0xd26/0xd47
 [<ffffffff8028fab9>] fd_install+0x30/0x68
 [<ffffffff80386c62>] sock_ioctl+0x204/0x212
 [<ffffffff8029d666>] do_ioctl+0x2a/0x77
 [<ffffffff8029d904>] vfs_ioctl+0x251/0x26e
 [<ffffffff803eff3b>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8029d963>] sys_ioctl+0x42/0x67
 [<ffffffff8020c15e>] system_call+0x7e/0x83

net eth1: device_rename: sysfs_create_symlink failed (-17)

=============================================================


The following patch logs the problem with a minimum of log output.

Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -418,12 +418,8 @@ void sysfs_addrm_start(struct sysfs_addr
  */
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
-	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
-		printk(KERN_WARNING "sysfs: duplicate filename '%s' "
-		       "can not be created\n", sd->s_name);
-		WARN_ON(1);
+	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
 		return -EEXIST;
-	}

 	sd->s_parent = sysfs_get(acxt->parent_sd);




Larry
