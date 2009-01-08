Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZAHDqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZAHDqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZAHDqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:46:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZAHDqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:46:34 -0500
Message-ID: <496576E7.1@cn.fujitsu.com>
Date: Thu, 08 Jan 2009 11:45:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
References: <49617D2E.8050502@cn.fujitsu.com>
In-Reply-To: <49617D2E.8050502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-fsdevel@vger.kernel.org

> The cause is after alloc_super() and then retry, an old entry in list
> fs_supers is found, so grab_super(old) is called, but both functions
> hold s_umount lock:
> 

Hi Al Viro,

I hacked into the kernel with the patch below (I think It's ok for me
to comment out bdev->bd_mount_sem for testing):

========================
--- a/fs/super.c
+++ b/fs/super.c
@@ -338,6 +338,7 @@ struct super_block *sget(struct file_system_type *type,
 	struct super_block *s = NULL;
 	struct super_block *old;
 	int err;
+	static int count;
 
 retry:
 	spin_lock(&sb_lock);
@@ -354,6 +355,10 @@ retry:
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
+		if (!strcmp(type->name, "ext3")) {
+			if (count++ % 2 == 0)
+				msleep(150);
+		}
 		s = alloc_super(type);
 		if (!s)
 			return ERR_PTR(-ENOMEM);
@@ -770,9 +775,9 @@ int get_sb_bdev(struct file_system_type *fs_type,
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	down(&bdev->bd_mount_sem);
+//	down(&bdev->bd_mount_sem);
 	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
-	up(&bdev->bd_mount_sem);
+//	up(&bdev->bd_mount_sem);
 	if (IS_ERR(s))
 		goto error_s;
======================== 

And ran 2 threads:
	for ((; ;))  # thread 1
	{
		mount -t ext3 /dev/sda9 /mnt1
		umount /mnt1
	}

	for ((; ;))  # thread 2
	{
		mount -t ext3 /dev/sda9 /mnt2
		umount /mnt2
	}

And I got the same lockdep warning immediately, so I think it's
VFS's issue.

=============================================
[ INFO: possible recursive locking detected ]
2.6.28-mc #497
---------------------------------------------
mount/3103 is trying to acquire lock:
 (&type->s_umount_key#15){----}, at: [<c04a2a56>] sget+0x58/0x33d

but task is already holding lock:
 (&type->s_umount_key#15){----}, at: [<c04a2c01>] sget+0x203/0x33d

other info that might help us debug this:
1 lock held by mount/3103:
 #0:  (&type->s_umount_key#15){----}, at: [<c04a2c01>] sget+0x203/0x33d

stack backtrace:
Pid: 3103, comm: mount Not tainted 2.6.28-mc #497
Call Trace:
 [<c044e01a>] validate_chain+0x4c6/0xbbd
 [<c043679c>] ? lock_timer_base+0x24/0x43
 [<c044ed87>] __lock_acquire+0x676/0x700
 [<c044ee6e>] lock_acquire+0x5d/0x7a
 [<c04a2a56>] ? sget+0x58/0x33d
 [<c06223d8>] down_write+0x34/0x50
 [<c04a2a56>] ? sget+0x58/0x33d
 [<c04a2a56>] sget+0x58/0x33d
 [<c04a26f8>] ? set_bdev_super+0x0/0x17
 [<c04a270f>] ? test_bdev_super+0x0/0x16
 [<c04a3510>] get_sb_bdev+0x52/0x125
 [<c04b3d00>] ? alloc_vfsmnt+0x71/0xe8
 [<c0488e9a>] ? kstrdup+0x31/0x53
 [<f80ac930>] ext3_get_sb+0x18/0x1a [ext3]
 [<f80adef0>] ? ext3_fill_super+0x0/0x1438 [ext3]
 [<c04a3195>] vfs_kern_mount+0x40/0x7b
 [<c04a321e>] do_kern_mount+0x37/0xbf
 [<c04b4786>] do_mount+0x5dc/0x633
 [<c04b311e>] ? copy_mount_options+0x2c/0x111
 [<c04b4846>] sys_mount+0x69/0xa0
 [<c0403351>] sysenter_do_call+0x12/0x31

> struct super_block *sget(...)
> {
> 	...
> retry:
> 	spin_lock(&sb_lock);
> 	if (test) {
> 		list_for_each_entry(old, &type->fs_supers, s_instances) {
> 			if (!test(old, data))
> 				continue;
> 			if (!grab_super(old))  <--- 2nd: down_write(&old->s_umount);
> 				goto retry;
> 			if (s)
> 				destroy_super(s);
> 			return old;
> 		}
> 	}
> 	if (!s) {
> 		spin_unlock(&sb_lock);
> 		s = alloc_super(type);   <--- 1th: down_write(&s->s_umount)
> 		if (!s)
> 			return ERR_PTR(-ENOMEM);
> 		goto retry;
> 	}
> 	...
> }
> 
> It seems like a false positive, and seems like VFS but not cgroup needs
> to be fixed ?
> 
> And I noticed this commit:
> 
> commit 897c6ff9568bcb102ffc6b465ebe1def0cba829d
> Author: Arjan van de Ven <arjan@infradead.org>
> Date:   Mon Jul 3 00:25:28 2006 -0700
> 
>     [PATCH] lockdep: annotate sb ->s_umount
> 
>     The s_umount rwsem needs to be classified as per-superblock since it's
>     perfectly legit to keep multiple of those recursively in the VFS locking
>     rules.
> 
>     Has no effect on non-lockdep kernels.
> 
> The changelog said s_umount needs to be classified as per-sb, but actually
> it made it as per-filesystem. And there is no way to mark all instances
> of a given lock as distinct.
