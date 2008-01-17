Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbYAQWkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbYAQWkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759812AbYAQWgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:40 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36240 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194AbYAQWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:36 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 30/30] configfs: file.c fix possible recursive locking
Date: Thu, 17 Jan 2008 14:35:56 -0800
Message-Id: <1200609356-17788-31-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonwoo Park <joonwpark81@gmail.com>

configfs_register_subsystem() with default_groups triggers recursive locking.
it seems that mutex_lock_nested is needed.

=============================================
[ INFO: possible recursive locking detected ]
2.6.24-rc6 #145
---------------------------------------------
swapper/1 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#3){--..}, at: [<c40c9a9e>] configfs_add_file+0x2e/0x70

but task is already holding lock:
 (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca985>] configfs_register_subsystem+0x55/0x130

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (&sb->s_type->i_mutex_key#3){--..}, at: [<c40ca985>] configfs_register_subsystem+0x55/0x130

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.24-rc6 #145
 [<c40053ba>] show_trace_log_lvl+0x1a/0x30
 [<c4005e82>] show_trace+0x12/0x20
 [<c400687e>] dump_stack+0x6e/0x80
 [<c404ec72>] __lock_acquire+0xe62/0x1120
 [<c404efb2>] lock_acquire+0x82/0xa0
 [<c43fda88>] mutex_lock_nested+0x98/0x2e0
 [<c40c9a9e>] configfs_add_file+0x2e/0x70
 [<c40c9b0c>] configfs_create_file+0x2c/0x40
 [<c40ca639>] configfs_attach_item+0x139/0x220
 [<c40ca734>] configfs_attach_group+0x14/0x140
 [<c40ca7e9>] configfs_attach_group+0xc9/0x140
 [<c40ca9f6>] configfs_register_subsystem+0xc6/0x130
 [<c45c8186>] init_netconsole+0x2b6/0x300
 [<c45a75f2>] kernel_init+0x142/0x320
 [<c4004fb3>] kernel_thread_helper+0x7/0x14
 =======================

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/configfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index a3658f9..397cb50 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -320,7 +320,7 @@ int configfs_add_file(struct dentry * dir, const struct configfs_attribute * att
 	umode_t mode = (attr->ca_mode & S_IALLUGO) | S_IFREG;
 	int error = 0;
 
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_NORMAL);
 	error = configfs_make_dirent(parent_sd, NULL, (void *) attr, mode, type);
 	mutex_unlock(&dir->d_inode->i_mutex);
 
-- 
1.5.3.6

