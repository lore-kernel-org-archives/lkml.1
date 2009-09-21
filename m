Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZIUBaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZIUBaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 21:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZIUBav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 21:30:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZIUBau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 21:30:50 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] vfs: new FROM_ACCESS flag
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org
Date: Sun, 20 Sep 2009 21:30:48 -0400
Message-ID: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new acc_mode flag is just to tell the security system this inode
permission check is from the access system call.  The security system can
use this information as it finds appropriete.  In particular SELinux plans to
use this flag to alter what we choose to audit and what we do not choose to
audit.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/open.c          |    2 +-
 include/linux/fs.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 1940498..ad9e17f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -495,7 +495,7 @@ SYSCALL_DEFINE3(faccessat, int, dfd, const char __user *, filename, int, mode)
 			goto out_path_release;
 	}
 
-	res = inode_permission(inode, mode | MAY_ACCESS);
+	res = inode_permission(inode, mode | MAY_ACCESS | FROM_ACCESS);
 	/* SuS v2 requires we report a read only fs too */
 	if (res || !(mode & S_IWOTH) || special_file(inode->i_mode))
 		goto out_path_release;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5df69f0..7ff00dc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -60,6 +60,11 @@ struct inodes_stat_t {
  */
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
+/*
+ * This flag is only set in the access() and accessat() syscalls and can
+ * be used by the security system as it deems reasonable.
+ */
+#define FROM_ACCESS 64
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond

