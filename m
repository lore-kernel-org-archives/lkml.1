Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbZDILSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbZDILSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 07:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbZDILS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 07:18:29 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55610 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZDILS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 07:18:28 -0400
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200904092018.GGD57377.FHJOLSMOFQOFVt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 9 Apr 2009 20:18:20 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it legal to use '\t' and '\n' in filesystem's name?
If legal, we should use \ooo escape for /proc/filesystems .

----------
[RFC PATCH] fs: register_filesystem: Don't allow '\t' and '\n'.

Registering a filesystem with broken name

  static struct file_system_type dummy_fs_type = {
          .name       = "a\tb\nc",
  };

results in broken output

  # cat /proc/filesystems
  nodev   sysfs
  nodev   rootfs
  nodev   bdev
  nodev   proc
  nodev   debugfs
  nodev   sockfs
  nodev   usbfs
  nodev   pipefs
  nodev   anon_inodefs
  nodev   tmpfs
  nodev   inotifyfs
  nodev   devpts
          ext3
          ext2
          cramfs
  nodev   ramfs
          vfat
          iso9660
  nodev   nfsd
  nodev   smbfs
  nodev   a       b
  c
  nodev   rpc_pipefs

Why not forbid '\t' and '\n'?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/filesystems.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- linux-2.6.30-rc1.orig/fs/filesystems.c
+++ linux-2.6.30-rc1/fs/filesystems.c
@@ -65,18 +65,21 @@ static struct file_system_type **find_fi
  *	structures and must not be freed until the file system has been
  *	unregistered.
  */
- 
-int register_filesystem(struct file_system_type * fs)
+
+int register_filesystem(struct file_system_type *fs)
 {
+	const char *fsname = fs->name;
 	int res = 0;
-	struct file_system_type ** p;
+	struct file_system_type **p;
 
-	BUG_ON(strchr(fs->name, '.'));
+	BUG_ON(strchr(fsname, '.'));
+	if (strchr(fsname, '\t') || strchr(fsname, '\n'))
+		return -EINVAL;
 	if (fs->next)
 		return -EBUSY;
 	INIT_LIST_HEAD(&fs->fs_supers);
 	write_lock(&file_systems_lock);
-	p = find_filesystem(fs->name, strlen(fs->name));
+	p = find_filesystem(fsname, strlen(fsname));
 	if (*p)
 		res = -EBUSY;
 	else
