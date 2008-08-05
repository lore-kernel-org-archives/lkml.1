Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbYHET7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbYHET7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbYHET71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:59:27 -0400
Received: from curtis.curtisfong.org ([66.43.110.51]:48566 "EHLO
	curtis.curtisfong.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564AbYHET70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:59:26 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 15:59:26 EDT
Date: Tue, 5 Aug 2008 12:52:32 -0700
From: Nye Liu <nyet@nyet.org>
To: linux-kernel@vger.kernel.org
Cc: nyet@nyet.org, nyet@mrv.com
Subject: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS
	cpio images
Message-ID: <20080805195232.GA5183@curtisfong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nye Liu <nyet@nyet.org>

When unpacking the cpio into the initramfs, mtimes are not preserved by
default. This patch adds an INITRAMFS_PRESERVE_MTIME option that allows
mtimes stored in the cpio image to be used when constructing the
initramfs. For embedded applications that run exclusively out of the
initramfs, this is invaluable.

Signed-off-by: Nye Liu <nyet@nyet.org>

---

diff --git a/init/initramfs.c b/init/initramfs.c
index 644fc01..0dd0a73 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -7,6 +7,12 @@
 #include <linux/string.h>
 #include <linux/syscalls.h>
 
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+#include <linux/utime.h>
+#include <linux/namei.h>
+#include <linux/list.h>
+#endif
+
 static __initdata char *message;
 static void __init error(char *x)
 {
@@ -72,6 +78,38 @@ static void __init free_hash(void)
 	}
 }
 
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+static __initdata LIST_HEAD(dir_list);
+struct dir_entry {
+	struct list_head list;
+	char *name;
+	struct utimbuf mtime;
+};
+
+static void __init dir_add(const char *name, struct utimbuf mtime)
+{
+	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
+	INIT_LIST_HEAD(&de->list);
+	de->name = kstrdup(name, GFP_KERNEL);
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
+		kfree(de->name);
+		kfree(de);
+	}
+}
+
+static __initdata struct utimbuf mtime;
+#endif
+
 /* cpio header parsing */
 
 static __initdata unsigned long ino, major, minor, nlink;
@@ -97,6 +135,9 @@ static void __init parse_header(char *s)
 	uid = parsed[2];
 	gid = parsed[3];
 	nlink = parsed[4];
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+	mtime.actime = mtime.modtime = parsed[5];
+#endif
 	body_len = parsed[6];
 	major = parsed[7];
 	minor = parsed[8];
@@ -130,6 +171,10 @@ static inline void __init eat(unsigned n)
 	count -= n;
 }
 
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+static __initdata char *vcollected;
+#endif
+
 static __initdata char *collected;
 static __initdata int remains;
 static __initdata char *collect;
@@ -271,6 +316,9 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+				vcollected = kstrdup(collected, GFP_KERNEL);
+#endif
 				state = CopyFile;
 			}
 		}
@@ -278,12 +326,18 @@ static int __init do_name(void)
 		sys_mkdir(collected, mode);
 		sys_chown(collected, uid, gid);
 		sys_chmod(collected, mode);
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+		dir_add(collected, mtime);
+#endif
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
 			sys_mknod(collected, mode, rdev);
 			sys_chown(collected, uid, gid);
 			sys_chmod(collected, mode);
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+			sys_utime(collected, &mtime);
+#endif
 		}
 	}
 	return 0;
@@ -294,6 +348,10 @@ static int __init do_copy(void)
 	if (count >= body_len) {
 		sys_write(wfd, victim, body_len);
 		sys_close(wfd);
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+		sys_utime(vcollected, &mtime);
+		kfree(vcollected);
+#endif
 		eat(body_len);
 		state = SkipIt;
 		return 0;
@@ -305,12 +363,48 @@ static int __init do_copy(void)
 	}
 }
 
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+static long __init sys_lutime(char __user * filename,
+	struct utimbuf __user * times)
+{
+	int error;
+	struct path path;
+	struct inode * inode;
+	struct iattr newattrs;
+
+	error = user_lpath(filename, &path);
+	if (error) return error;
+
+	inode = path.dentry->d_inode;
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
+	error = notify_change(path.dentry, &newattrs);
+	mutex_unlock(&inode->i_mutex);
+pput_and_out:
+	path_put(&path);
+	return error;
+}
+#endif
+
 static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
 	sys_symlink(collected + N_ALIGN(name_len), collected);
 	sys_lchown(collected, uid, gid);
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+	sys_lutime(collected, &mtime);
+#endif
 	state = SkipIt;
 	next_state = Reset;
 	return 0;
@@ -466,6 +560,9 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
 		buf += inptr;
 		len -= inptr;
 	}
+#ifdef CONFIG_INITRAMFS_PRESERVE_MTIME
+	dir_utime();
+#endif
 	kfree(window);
 	kfree(name_buf);
 	kfree(symlink_buf);
diff --git a/usr/Kconfig b/usr/Kconfig
index 86cecb5..f7d9f60 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -44,3 +44,13 @@ config INITRAMFS_ROOT_GID
 	  owned by group root in the initial ramdisk image.
 
 	  If you are not sure, leave it set to "0".
+
+config INITRAMFS_PRESERVE_MTIME
+	bool "Preserve mtimes from INITRAMFS image"
+	depends on BLK_DEV_INITRD
+	default n
+	help
+	  Preserve mtimes (last modified times) for all items stored in the
+	  initramfs image.
+
+	  If you are not sure, leave it set to "N"
