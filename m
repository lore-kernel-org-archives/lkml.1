Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZCNOCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZCNOCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZCNOCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:02:32 -0400
Received: from THUNK.ORG ([69.25.196.29]:51188 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbZCNOCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:02:31 -0400
To: linux-kernel@vger.kernel.org
Subject: Lockdep problem involving sysfs_mutex in ext4 in linux-next
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1LiURX-0000jG-Lx@closure.thunk.org>
Date: Sat, 14 Mar 2009 10:02:27 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm occasionally seeing a circular locking dependency in linux-next when
I unmount an ext4 filesystem, apparently involving sysfs_mutex in
sysfs_addrm_start(), and I have no idea what's going on.  Some help from
kobject experts would be greatly appreciated.  I assume I must be doing
something wrong.  I took the basic pattern from btrfs, but I suspect I
may have broken some of the kobject lifetime rules when I adapted what I
needed for ext4.

It doesn't happen all the time, and it seems to be caused by how I'm
releasing the ext4's sysfs kobject.  In ext4_put_super():

	kobject_put(&sbi->s_kobj);
	wait_for_completion(&sbi->s_kobj_unregister);

The circular locking dependency is:

[32667.071746] =======================================================
[32667.071751] [ INFO: possible circular locking dependency detected ]
[32667.071755] 2.6.29-rc7-00043-gafbc462 #11
[32667.071758] -------------------------------------------------------
[32667.071762] umount/2310 is trying to acquire lock:
[32667.071764]  (sysfs_mutex){--..}, at: [<c01f7130>] sysfs_addrm_start+0x28/0x9a
[32667.071778] 
[32667.071779] but task is already holding lock:
[32667.071782]  (&type->s_lock_key#5){--..}, at: [<c01b752b>] lock_super+0x26/0x28

And the stack trace is:

[32667.072279]  [<c01f7130>] ? sysfs_addrm_start+0x28/0x9a
[32667.072284]  [<c04c60ca>] __mutex_lock_common+0xdc/0x33a
[32667.072289]  [<c01f7130>] ? sysfs_addrm_start+0x28/0x9a
[32667.072294]  [<c04c63cf>] mutex_lock_nested+0x33/0x3b
[32667.072300]  [<c01f7130>] ? sysfs_addrm_start+0x28/0x9a
[32667.072304]  [<c01f7130>] sysfs_addrm_start+0x28/0x9a
[32667.072309]  [<c01f75ba>] sysfs_remove_dir+0x77/0xab
[32667.072314]  [<c02d5b2f>] kobject_del+0xf/0x2c
[32667.072319]  [<c02d5c80>] kobject_release+0x134/0x1cb
[32667.072323]  [<c02d5b4c>] ? kobject_release+0x0/0x1cb
[32667.072328]  [<c02d69e4>] kref_put+0x3c/0x4a
[32667.072333]  [<c02d5ac8>] kobject_put+0x37/0x3c
[32667.072337]  [<c021cd89>] ext4_put_super+0xab/0x215
[32667.072342]  [<c01b7fed>] generic_shutdown_super+0x62/0xe3
[32667.072346]  [<c01b8090>] kill_block_super+0x22/0x36
[32667.072352]  [<c01e6f52>] ? vfs_quota_off+0x0/0x17
[32667.072357]  [<c01b815b>] deactivate_super+0x5c/0x6f
[32667.072361]  [<c01c8c34>] mntput_no_expire+0xd4/0x106
[32667.072366]  [<c01c9138>] sys_umount+0x2a1/0x2c6
[32667.072370]  [<c01c916f>] sys_oldumount+0x12/0x14
[32667.072375]  [<c0117ff6>] syscall_call+0x7/0xb
[32667.072380]  [<c0110000>] ? x86_decode_insn+0x349/0xbc9

Can anybody tell me what I did wrong?   Thanks!!

						- Ted
