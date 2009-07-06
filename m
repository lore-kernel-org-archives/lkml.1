Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZGFVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZGFVqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZGFVqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:46:06 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:38404 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbZGFVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:46:06 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: fs/super.c: lockdep annotate s_vfs_rename_mutex
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
From: Roland Dreier <roland@digitalvampire.org>
Date: Mon, 06 Jul 2009 14:45:50 -0700
Message-ID: <87prcdmqnl.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing a cross-directory rename on a stacked filesystem (such as eg
ecryptfs) triggers a lockdep false positive, since the vfs first does
lock_rename() and then calls into the top filesystem, which then does
lock_rename() again and calls into the lower filesystem.  This can't
actually deadlock, since the two filesystems have separate
s_vfs_rename_mutexes and the upper filesystem's mutex is always taken
before the lower filesystem's.  So teach lockdep this by putting each
filesystem's rename mutex into its own class.

This fixes lockdep warnings such as the following seen with ecryptfs
on top of ext4:

=============================================
[ INFO: possible recursive locking detected ]
2.6.31-2-generic #14~rbd3
---------------------------------------------
firefox-3.5/4162 is trying to acquire lock:
 (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0

but task is already holding lock:
 (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0

other info that might help us debug this:
3 locks held by firefox-3.5/4162:
 #0:  (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 #1:  (&sb->s_type->i_mutex_key#11/1){+.+.+.}, at: [<ffffffff81139d5a>] lock_rename+0x6a/0xf0
 #2:  (&sb->s_type->i_mutex_key#11/2){+.+.+.}, at: [<ffffffff81139d6f>] lock_rename+0x7f/0xf0

stack backtrace:
Pid: 4162, comm: firefox-3.5 Tainted: G         C 2.6.31-2-generic #14~rbd3
Call Trace:
 [<ffffffff8108ae74>] print_deadlock_bug+0xf4/0x100
 [<ffffffff8108ce26>] validate_chain+0x4c6/0x750
 [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
 [<ffffffff8108d585>] lock_acquire+0xa5/0x150
 [<ffffffff815526ad>] __mutex_lock_common+0x4d/0x3d0
 [<ffffffff81552b36>] mutex_lock_nested+0x46/0x60
 [<ffffffff81139d31>] lock_rename+0x41/0xf0
 [<ffffffff8120eb2a>] ecryptfs_rename+0xca/0x170
 [<ffffffff81139a9e>] vfs_rename_dir+0x13e/0x160
 [<ffffffff8113ac7e>] vfs_rename+0xee/0x290
 [<ffffffff8113d512>] sys_renameat+0x252/0x280
 [<ffffffff8113d55b>] sys_rename+0x1b/0x20
 [<ffffffff81013132>] system_call_fastpath+0x16/0x1b

Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Roland Dreier <roland@digitalvampire.org>
---
 fs/super.c         |    1 +
 include/linux/fs.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2761d3e..0a45b5a 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -98,6 +98,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		s->s_count = S_BIAS;
 		atomic_set(&s->s_active, 1);
 		mutex_init(&s->s_vfs_rename_mutex);
+		lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
 		mutex_init(&s->s_dquot.dqio_mutex);
 		mutex_init(&s->s_dquot.dqonoff_mutex);
 		init_rwsem(&s->s_dquot.dqptr_sem);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0872372..feaf9e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1750,6 +1750,7 @@ struct file_system_type {
 
 	struct lock_class_key s_lock_key;
 	struct lock_class_key s_umount_key;
+	struct lock_class_key s_vfs_rename_key;
 
 	struct lock_class_key i_lock_key;
 	struct lock_class_key i_mutex_key;
