Return-Path: <linux-kernel-owner+w=401wt.eu-S1761973AbYF0TtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973AbYF0TtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYF0TtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:49:15 -0400
Received: from webmail.chats.mrv.com ([66.43.110.3]:24691 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752592AbYF0TtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:49:13 -0400
Date: Fri, 27 Jun 2008 12:49:01 -0700
From: Nye Liu <nyet@mrv.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] INITRAMFS: propogate mtime from cpio'd directory tree
Message-ID: <20080627194901.GA16341@mrv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 27 Jun 2008 19:50:42.0596 (UTC) FILETIME=[15194640:01C8D88F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nye Liu <nyet@mrv.com>

Propogate mtime from cpio'd initramfs directory tree (including soft
links and directories). For those of us running embedded systems, it is
good to know what the original modification times of the files in the
ramfs was. Copies mtime into atime, but does not modify ctime. Could
easily be modified to only modify mtime, or additionally modify ctime.

Signed-off-by: Nye Liu <nyet@mrv.com>

---

diff --git a/init/initramfs.c b/init/initramfs.c
index 8eeeccb..1f984e4 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -7,6 +7,10 @@
 #include <linux/string.h>
 #include <linux/syscalls.h>
 
+#include <linux/utime.h>
+#include <linux/namei.h>
+#include <linux/list.h>
+
 static __initdata char *message;
 static void __init error(char *x)
 {
@@ -24,6 +28,14 @@ static void __init free(void *where)
 	kfree(where);
 }
 
+static char * __init strdup(const char *s)
+{
+	int l = strlen(s)+1;
+	char *p = malloc(l);
+	memcpy(p,s,l);
+	return p;
+}
+
 /* link hash */
 
 #define N_ALIGN(len) ((((len) + 1) & ~3) + 2)
@@ -82,9 +94,38 @@ static void __init free_hash(void)
 	}
 }
 
+static __initdata LIST_HEAD(dir_list);
+struct dir_entry {
+	struct list_head list;
+	char *name;
+	struct utimbuf mtime;
+};
+
+static void __init dir_add(const char *name, struct utimbuf mtime)
+{
+	struct dir_entry *de = malloc(sizeof(struct dir_entry));
+	INIT_LIST_HEAD(&de->list);
+	de->name = strdup(name);
+	de->mtime = mtime;
+	list_add(&de->list, &dir_list);
+}
+
+static void __init dir_utime(void)
+{
+	struct list_head *e, *tmp;
+	list_for_each_safe(e, tmp, &dir_list) {
+		struct dir_entry *de = list_entry(e, struct dir_entry, list);
+		list_del(e);
+		sys_utime(de->name, &de->mtime);
+		free(de->name);
+		free(de);
+	}
+}
+
 /* cpio header parsing */
 
 static __initdata unsigned long ino, major, minor, nlink;
+static __initdata struct utimbuf mtime;
 static __initdata mode_t mode;
 static __initdata unsigned long body_len, name_len;
 static __initdata uid_t uid;
@@ -107,6 +148,7 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
+	mtime.actime = mtime.modtime = parsed[5];
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
@@ -140,7 +182,7 @@ static inline void __init eat(unsigned n)
 	count -= n;
 }
 
-static __initdata char *collected;
+static __initdata char *collected, *vcollected;
 static __initdata int remains;
 static __initdata char *collect;
 
@@ -281,6 +323,7 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
+				vcollected = strdup(collected);
 				state = CopyFile;
 			}
 		}
@@ -288,12 +331,14 @@ static int __init do_name(void)
 		sys_mkdir(collected, mode);
 		sys_chown(collected, uid, gid);
 		sys_chmod(collected, mode);
+		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
 			sys_mknod(collected, mode, rdev);
 			sys_chown(collected, uid, gid);
 			sys_chmod(collected, mode);
+			sys_utime(collected, &mtime);
 		}
 	}
 	return 0;
@@ -304,6 +349,8 @@ static int __init do_copy(void)
 	if (count >= body_len) {
 		sys_write(wfd, victim, body_len);
 		sys_close(wfd);
+		sys_utime(vcollected, &mtime);
+		free(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
@@ -315,12 +362,43 @@ static int __init do_copy(void)
 	}
 }
 
+static long __init sys_lutime(char __user * filename, struct utimbuf __user * times)
+{
+	int error;
+	struct nameidata nd;
+	struct inode * inode;
+	struct iattr newattrs;
+
+	error = user_path_walk_link(filename, &nd);
+	if (error) return error;
+
+	inode = nd.path.dentry->d_inode;
+
+	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
+	error = 0;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		goto pput_and_out;
+
+	newattrs.ia_atime.tv_sec = times->actime;
+	newattrs.ia_atime.tv_nsec = 0;
+	newattrs.ia_mtime.tv_sec = times->modtime;
+	newattrs.ia_mtime.tv_nsec = 0;
+	newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
+	mutex_lock(&inode->i_mutex);
+	error = notify_change(nd.path.dentry, &newattrs);
+	mutex_unlock(&inode->i_mutex);
+pput_and_out:
+	path_put(&nd.path);
+	return error;
+}
+
 static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
 	sys_symlink(collected + N_ALIGN(name_len), collected);
 	sys_lchown(collected, uid, gid);
+	sys_lutime(collected, &mtime);
 	state = SkipIt;
 	next_state = Reset;
 	return 0;
@@ -484,6 +562,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 		buf += inptr;
 		len -= inptr;
 	}
+	dir_utime();
 	kfree(window);
 	kfree(name_buf);
 	kfree(symlink_buf);


-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
