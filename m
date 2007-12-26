Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbXLZDKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbXLZDKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 22:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXLZDKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 22:10:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:43947 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbXLZDKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 22:10:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=yB69RWmjTYm0y9P8H6jkOKWua9AX3Y+vNbMd5XnDneKT/O9/Noy3EjzF4S4AjSlz4Dp1zaaGH7sbnzXu7KDNLEgg8fs75mEL+wLKbms6EhMWEd9dL7lc97IfCx0ZcCs+N7gZbVeC6QoOcaYkDVZZBC6/dnZTKHqD5bUe6Tu7+/I=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: <joel.becker@oracle.com>
Subject: [PATCH 2/2] configfs: file.c fix possible recursive locking
Date: Wed, 26 Dec 2007 12:09:57 +0900
Message-ID: <003001c8476c$ccbce270$47e7a8c0@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AchHbMp5otdCeRebS8mwsbCrj2uA/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 
---

Thanks.
Joonwoo

