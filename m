Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbYETQvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbYETQvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbYETQuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:50:24 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:43573 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762510AbYETQuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:50:22 -0400
Message-Id: <20080520164318.941457704@kerlabs.com>
References: <20080520163320.025971210@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Tue, 20 May 2008 18:33:23 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [RFC][PATCH 3/3] configfs: Silence lockdep when destroying default groups
Content-Disposition: inline; filename=configfs-silence-lockdep-with-default-group-destruction.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When destroying a config_group having default groups, lockdep raises a warning
because multiple locks of class I_MUTEX_NORMAL are taken in
configfs_detach_prep() (the first one being in vfs_rmdir()). However this
recursive locking is another instance of I_MUTEX_PARENT -> I_MUTEX_CHILD
dependency, which was already checked correct when creating the config_group,
and which lockdep cannot handle cleanly because of the variable depth.

This patch silences lockdep when destroying default groups by simply hiding the
inode mutex locks from lockdep in configfs_detach_prep(),
configfs_detach_rollback(), and detach_groups().

=============================================
[ INFO: possible recursive locking detected ]
2.6.26-rc3 #5
---------------------------------------------
rmdir/1499 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89

but task is already holding lock:
 (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296513>] vfs_rmdir+0x49/0xac

other info that might help us debug this:
2 locks held by rmdir/1499:
 #0:  (&sb->s_type->i_mutex_key#3/1){--..}, at: [<ffffffff80298138>] do_rmdir+0x82/0x108
 #1:  (&sb->s_type->i_mutex_key#11){--..}, at: [<ffffffff80296513>] vfs_rmdir+0x49/0xac

stack backtrace:
Pid: 1499, comm: rmdir Not tainted 2.6.26-rc3 #5

Call Trace:
 [<ffffffff8024afe9>] __lock_acquire+0x8d2/0xc78
 [<ffffffff80266399>] filemap_fault+0x1cf/0x332
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff8024b762>] lock_acquire+0x51/0x6c
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff80248331>] debug_mutex_lock_common+0x16/0x23
 [<ffffffff805d6244>] mutex_lock_nested+0xcd/0x23b
 [<ffffffff802d2529>] configfs_detach_prep+0x54/0x89
 [<ffffffff802d3656>] configfs_rmdir+0xb8/0x1c3
 [<ffffffff80296535>] vfs_rmdir+0x6b/0xac
 [<ffffffff8029816d>] do_rmdir+0xb7/0x108
 [<ffffffff8024a2a2>] trace_hardirqs_on+0xef/0x113
 [<ffffffff805d7364>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b0cb>] system_call_after_swapgs+0x7b/0x80


Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)


Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-05-20 18:19:41.000000000 +0200
+++ b/fs/configfs/dir.c	2008-05-20 18:19:45.000000000 +0200
@@ -352,7 +352,12 @@ static int configfs_detach_prep(struct d
 		if (sd->s_type & CONFIGFS_NOT_PINNED)
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
+			/* Hide this mutex from lockdep for the same reasons as in
+			 * populate_groups()
+			 */
+			lockdep_off();
 			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
+			lockdep_on();
 			/* Mark that we've taken i_mutex */
 			sd->s_type |= CONFIGFS_USET_DROPPING;
 
@@ -388,7 +393,12 @@ static void configfs_detach_rollback(str
 
 			if (sd->s_type & CONFIGFS_USET_DROPPING) {
 				sd->s_type &= ~CONFIGFS_USET_DROPPING;
+				/* This mutex was hidden from lockdep in
+				 * configfs_detach_prep()
+				 */
+				lockdep_off();
 				mutex_unlock(&sd->s_dentry->d_inode->i_mutex);
+				lockdep_on();
 			}
 		}
 	}
@@ -475,8 +485,14 @@ static void detach_groups(struct config_
 		 * has taken our i_mutex for us.  Drop it.
 		 * From mkdir/register cleanup, there is no sem held.
 		 */
-		if (sd->s_type & CONFIGFS_USET_DROPPING)
+		if (sd->s_type & CONFIGFS_USET_DROPPING) {
+			/* This mutex was hidden from lockdep in
+			 * configfs_detach_prep()
+			 */
+			lockdep_off();
 			mutex_unlock(&child->d_inode->i_mutex);
+			lockdep_on();
+		}
 
 		d_delete(child);
 		dput(child);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

