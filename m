Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXCFTUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXCFTUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXCFTUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:20:16 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:1217 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbXCFTUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:20:13 -0500
X-AuditID: d80ac287-a2c32bb000002978-5e-45edbeec314b 
Date: Tue, 6 Mar 2007 19:20:11 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Oliver Neukum <oliver@neukum.name>
cc: Maneesh Soni <maneesh@in.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: 2.6.21-rc suspend regression: sysfs deadlock
Message-ID: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 06 Mar 2007 19:20:09.0107 (UTC) FILETIME=[7462CE30:01C76024]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resume from RAM on a ThinkPad T43p is now happy with Thomas' periodic
tick fix - the most unusable aspect of that for me had been how slow
repeat keys were to start repeating, but that's all fine now.

But suspend to RAM still hanging, unless I "chmod a-x /usr/sbin/docker"
on SuSE 10.2: docker undock tries to unregister /sys/block/sr0 and hangs:

60x60         D B0415080     0 10778  10771                     (NOTLB)
       e8227e04 00000086 e80c60b0 b0415080 ef3f5454 b041dc20 ef3f5430 00000001 
       e80c60b0 72af360e 00000085 00001941 e80c61bc e8227e00 b01606bf ef47d3c0 
       ed07c1dc ed07c1e4 00000246 e8227e30 b02f6ef0 e80c60b0 00000001 e80c60b0 
Call Trace:
 [<b02f6ef0>] __down+0xaa/0xb8
 [<b02f6de6>] __down_failed+0xa/0x10
 [<b0180529>] sysfs_drop_dentry+0xa2/0xda
 [<b01819b3>] __sysfs_remove_dir+0x6d/0xf8
 [<b0181a53>] sysfs_remove_dir+0x15/0x20
 [<b01d49a9>] kobject_del+0x16/0x22
 [<b0230041>] device_del+0x1c9/0x1e2
 [<b025705a>] __scsi_remove_device+0x43/0x7a
 [<b02570b0>] scsi_remove_device+0x1f/0x2b
 [<b0256a44>] sdev_store_delete+0x16/0x1b
 [<b022f0a0>] dev_attr_store+0x32/0x34
 [<b0180931>] flush_write_buffer+0x37/0x3d
 [<b0180995>] sysfs_write_file+0x5e/0x82
 [<b01507f5>] vfs_write+0xa7/0x150
 [<b0150950>] sys_write+0x47/0x6b
 [<b0103d56>] sysenter_past_esp+0x5f/0x85
              /usr/lib/dockutils/hooks/thinkpad/60x60 undock
              /usr/lib/dockutils/dockhandler undock
              /usr/sbin/docker undock
              /etc/pm/hooks/23dock suspend

This comes from Oliver's commit 94bebf4d1b8e7719f0f3944c037a21cfd99a4af7
Driver core: fix race in sysfs between sysfs_remove_file() and read()/write()
in 2.6.21-rc1.  It looks to me like sysfs_write_file downs buffer->sem
while calling flush_write_buffer, and flushing that particular write
buffer entails downing buffer->sem in orphan_all_buffers.

Suspend no longer deadlocks with the following silly patch, but I expect
this either pokes a small hole in your scheme, or renders it pointless.
Maybe that commit needs to be reverted, or maybe you can see how to fix
it up for -rc3.

Thanks,
Hugh

--- 2.6.21-rc2-git5/fs/sysfs/inode.c	2007-02-28 08:30:26.000000000 +0000
+++ linux/fs/sysfs/inode.c	2007-03-06 18:03:13.000000000 +0000
@@ -227,11 +227,8 @@ static inline void orphan_all_buffers(st
 
 	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
 	if (node->i_private) {
-		list_for_each_entry(buf, &set->associates, associates) {
-			down(&buf->sem);
+		list_for_each_entry(buf, &set->associates, associates)
 			buf->orphaned = 1;
-			up(&buf->sem);
-		}
 	}
 	mutex_unlock(&node->i_mutex);
 }
