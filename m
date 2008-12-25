Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbYLYFdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbYLYFdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 00:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYLYFd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 00:33:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60283 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbYLYFd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 00:33:27 -0500
Message-ID: <49531ADF.1080700@cn.fujitsu.com>
Date: Thu, 25 Dec 2008 13:32:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] vfs: remove duplicate code in get_fs_type()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

save 14 bytes:

   text    data     bss     dec     hex filename
   1354      32       4    1390     56e fs/filesystems.o.before
   text    data     bss     dec     hex filename
   1340      32       4    1376     560 fs/filesystems.o

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/filesystems.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index d0e20ce..d488dcd 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -253,24 +253,27 @@ static int __init proc_filesystems_init(void)
 module_init(proc_filesystems_init);
 #endif
 
-struct file_system_type *get_fs_type(const char *name)
+static struct file_system_type *__get_fs_type(const char *name, int len)
 {
 	struct file_system_type *fs;
-	const char *dot = strchr(name, '.');
-	unsigned len = dot ? dot - name : strlen(name);
 
 	read_lock(&file_systems_lock);
 	fs = *(find_filesystem(name, len));
 	if (fs && !try_module_get(fs->owner))
 		fs = NULL;
 	read_unlock(&file_systems_lock);
-	if (!fs && (request_module("%.*s", len, name) == 0)) {
-		read_lock(&file_systems_lock);
-		fs = *(find_filesystem(name, len));
-		if (fs && !try_module_get(fs->owner))
-			fs = NULL;
-		read_unlock(&file_systems_lock);
-	}
+	return fs;
+}
+
+struct file_system_type *get_fs_type(const char *name)
+{
+	struct file_system_type *fs;
+	const char *dot = strchr(name, '.');
+	int len = dot ? dot - name : strlen(name);
+
+	fs = __get_fs_type(name, len);
+	if (!fs && (request_module("%.*s", len, name) == 0))
+		fs = __get_fs_type(name, len);
 
 	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
 		put_filesystem(fs);
-- 
1.5.4.rc3


