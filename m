Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZGBAik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZGBAik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbZGBAid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:38:33 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:59850 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZGBAic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:38:32 -0400
X-IronPort-AV: E=Sophos;i="4.42,329,1243814400"; 
   d="scan'208";a="335868003"
From: Roland Dreier <rdreier@cisco.com>
To: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
       ecryptfs-devel@lists.launchpad.net, viro@zeniv.linux.org.uk,
       a.p.zijlstra@chello.nl, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Another lockdep issue reported with ecryptfs
Date: Wed, 01 Jul 2009 17:31:05 -0700
References: <adahbxwgwo6.fsf@cisco.com> <ada1vp0dmsf.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Message-ID: <adatz1v2a2c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jul 2009 00:38:35.0428 (UTC) FILETIME=[6EF00640:01C9FAAD]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >  =============================================
 >  [ INFO: possible recursive locking detected ]
 >  2.6.31-2-generic #14~rbd3
 >  ---------------------------------------------
 >  firefox-3.5/4162 is trying to acquire lock:
 >   (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >  
 >  but task is already holding lock:
 >   (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >  
 >  other info that might help us debug this:
 >  3 locks held by firefox-3.5/4162:
 >   #0:  (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >   #1:  (&sb->s_type->i_mutex_key#11/1){+.+.+.}, at: [<ffffffff81139d5a>] lock_rename+0x6a/0xf0
 >   #2:  (&sb->s_type->i_mutex_key#11/2){+.+.+.}, at: [<ffffffff81139d6f>] lock_rename+0x7f/0xf0
 >  
 >  stack backtrace:
 >  Pid: 4162, comm: firefox-3.5 Tainted: G         C 2.6.31-2-generic #14~rbd3
 >  Call Trace:
 >   [<ffffffff8108ae74>] print_deadlock_bug+0xf4/0x100
 >   [<ffffffff8108ce26>] validate_chain+0x4c6/0x750
 >   [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
 >   [<ffffffff8108d585>] lock_acquire+0xa5/0x150
 >   [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
 >   [<ffffffff815526ad>] __mutex_lock_common+0x4d/0x3d0
 >   [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
 >   [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
 >   [<ffffffff8120eaf9>] ? ecryptfs_rename+0x99/0x170
 >   [<ffffffff81552b36>] mutex_lock_nested+0x46/0x60
 >   [<ffffffff81139d31>] lock_rename+0x41/0xf0
 >   [<ffffffff8120eb2a>] ecryptfs_rename+0xca/0x170
 >   [<ffffffff81139a9e>] vfs_rename_dir+0x13e/0x160
 >   [<ffffffff8113ac7e>] vfs_rename+0xee/0x290
 >   [<ffffffff8113c212>] ? __lookup_hash+0x102/0x160
 >   [<ffffffff8113d512>] sys_renameat+0x252/0x280
 >   [<ffffffff81133eb4>] ? cp_new_stat+0xe4/0x100
 >   [<ffffffff8101316a>] ? sysret_check+0x2e/0x69
 >   [<ffffffff8108c34d>] ? trace_hardirqs_on_caller+0x14d/0x190
 >   [<ffffffff8113d55b>] sys_rename+0x1b/0x20
 >   [<ffffffff81013132>] system_call_fastpath+0x16/0x1b

The trace above is totally reproducible by doing a cross-directory
rename on an ecryptfs directory.

The issue seems to be that sys_renameat() does lock_rename() then calls
into the filesystem; if the filesystem is ecryptfs, then
ecryptfs_rename() again does lock_rename() on the lower filesystem, and
lockdep can't tell that the two s_vfs_rename_mutexes are different.  It
seems an annotation like the following is sufficient to fix this (it
does get rid of the lockdep trace in my simple tests); however I would
like to make sure I'm not misunderstanding the locking, hence the CC
list...

Thanks,
  Roland


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
