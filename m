Return-Path: <linux-kernel-owner+w=401wt.eu-S1161499AbXBHAdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161499AbXBHAdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423054AbXBHAck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:32:40 -0500
Received: from mx1.suse.de ([195.135.220.2]:56415 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422896AbXBHAc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:29 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Frederik Deweerdt <frederik.deweerdt@gmail.com>,
       Andrew Morton <akpm@osdl.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/28] sysfs: suppress lockdep warnings
Date: Wed,  7 Feb 2007 16:30:06 -0800
Message-Id: <11708946802786-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946762594-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederik Deweerdt <deweerdt@free.fr>

Lockdep issues the following warning:
[    9.064000] =============================================
[    9.064000] [ INFO: possible recursive locking detected ]
[    9.064000] 2.6.20-rc3-mm1 #3
[    9.064000] ---------------------------------------------
[    9.064000] init/1 is trying to acquire lock:
[    9.064000]  (&sysfs_inode_imutex_key){--..}, at: [<c03e6afc>] mutex_lock+0x1c/0x1f
[    9.064000]
[    9.064000] but task is already holding lock:
[    9.064000]  (&sysfs_inode_imutex_key){--..}, at: [<c03e6afc>] mutex_lock+0x1c/0x1f
[    9.065000]
[    9.065000] other info that might help us debug this:
[    9.065000] 2 locks held by init/1:
[    9.065000]  #0:  (tty_mutex){--..}, at: [<c03e6afc>] mutex_lock+0x1c/0x1f
[    9.065000]  #1:  (&sysfs_inode_imutex_key){--..}, at: [<c03e6afc>] mutex_lock+0x1c/0x1f
[    9.065000]
[    9.065000] stack backtrace:
[    9.065000]  [<c010390d>] show_trace_log_lvl+0x1a/0x30
[    9.066000]  [<c0103935>] show_trace+0x12/0x14
[    9.066000]  [<c0103a2f>] dump_stack+0x16/0x18
[    9.066000]  [<c0138cb8>] print_deadlock_bug+0xb9/0xc3
[    9.066000]  [<c0138d17>] check_deadlock+0x55/0x5a
[    9.066000]  [<c013a953>] __lock_acquire+0x371/0xbf0
[    9.066000]  [<c013b7a9>] lock_acquire+0x69/0x83
[    9.066000]  [<c03e6b7e>] __mutex_lock_slowpath+0x75/0x2d1
[    9.066000]  [<c03e6afc>] mutex_lock+0x1c/0x1f
[    9.066000]  [<c01b249c>] sysfs_drop_dentry+0xb1/0x133
[    9.066000]  [<c01b25d1>] sysfs_hash_and_remove+0xb3/0x142
[    9.066000]  [<c01b30ed>] sysfs_remove_file+0xd/0x10
[    9.067000]  [<c02849e0>] device_remove_file+0x23/0x2e
[    9.067000]  [<c02850b2>] device_del+0x188/0x1e6
[    9.067000]  [<c028511b>] device_unregister+0xb/0x15
[    9.067000]  [<c0285318>] device_destroy+0x9c/0xa9
[    9.067000]  [<c0261431>] vcs_remove_sysfs+0x1c/0x3b
[    9.067000]  [<c0267a08>] con_close+0x5e/0x6b
[    9.067000]  [<c02598f2>] release_dev+0x4c4/0x6e5
[    9.067000]  [<c0259faa>] tty_release+0x12/0x1c
[    9.067000]  [<c0174872>] __fput+0x177/0x1a0
[    9.067000]  [<c01746f5>] fput+0x3b/0x41
[    9.068000]  [<c0172ee1>] filp_close+0x36/0x65
[    9.068000]  [<c0172f73>] sys_close+0x63/0xa4
[    9.068000]  [<c0102a96>] sysenter_past_esp+0x5f/0x99
[    9.068000]  =======================

This is due to sysfs_hash_and_remove() holding dir->d_inode->i_mutex
before calling sysfs_drop_dentry() which calls orphan_all_buffers()
which in turn takes node->i_mutex.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 1a81ebc..dbd820f 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -215,7 +215,7 @@ static inline void orphan_all_buffers(struct inode *node)
 	struct sysfs_buffer_collection *set = node->i_private;
 	struct sysfs_buffer *buf;
 
-	mutex_lock(&node->i_mutex);
+	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
 	if (node->i_private) {
 		list_for_each_entry(buf, &set->associates, associates) {
 			down(&buf->sem);
@@ -272,7 +272,7 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 		return -ENOENT;
 
 	parent_sd = dir->d_fsdata;
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (!sd->s_element)
 			continue;
-- 
1.4.4.4

