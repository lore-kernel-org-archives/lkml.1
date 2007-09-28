Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXI1SQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXI1SQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXI1SQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:16:13 -0400
Received: from emailgw01.pnl.gov ([192.101.109.33]:46661 "EHLO
	emailgw01.pnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbXI1SQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:16:10 -0400
X-Greylist: delayed 3607 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 14:16:10 EDT
X-IronPort-AV: E=Sophos;i="4.21,210,1188802800"; 
   d="scan'208";a="50107275"
Date: Fri, 28 Sep 2007 10:16:01 -0700
From: Ken Schmidt <kenneth.schmidt@pnl.gov>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, kenneth.schmidt@pnl.gov
Subject: [patch 01/02] vfs: variant symlinks
Message-Id: <20070928101601.0ccc1b74.kenneth.schmidt@pnl.gov>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variant symlinks add the ability to embed variables in to the contents of symbolic links so their targets can change based on outside sources (user environment, uts, filesystems, etc.)

Signed-off-by: Ken Schmidt <kenneth.schmidt@pnl.gov>
---
diff -urN linux-2.6.22.5.orig/include/linux/variant.h linux-2.6.22.5/include/linux/variant.h
--- linux-2.6.22.5.orig/include/linux/variant.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22.5/include/linux/variant.h	2007-08-28 09:35:40.000000000 -0700
@@ -0,0 +1,10 @@
+#ifndef _LINUX_VARIANT_H
+#define _LINUX_VARIANT_H
+
+int variant_func_register(int ( *variant_func)(const char *, int, char *, int), int priority, char *name);
+void variant_func_unregister(int id);
+int do_variant_lookup(const char *path, char **newpath);
+
+extern int variant_links_enabled;
+
+#endif /* _LINUX_VARIANT_H */
diff -urN linux-2.6.22.5.orig/fs/Kconfig linux-2.6.22.5/fs/Kconfig
--- linux-2.6.22.5.orig/fs/Kconfig	2007-08-22 16:23:54.000000000 -0700
+++ linux-2.6.22.5/fs/Kconfig	2007-09-23 09:16:04.000000000 -0700
@@ -524,6 +524,14 @@
 
 	  If unsure, say Y.
 
+config VARIANT
+	bool "Variant symlink support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  If you say Y here, all filesystems will have the ability to
+	  dynamically redirect their symbolic link targets based on embedded
+	  variables. If unsure, say N
+
 config QUOTA
 	bool "Quota support"
 	help
diff -urN linux-2.6.22.5.orig/fs/Makefile linux-2.6.22.5/fs/Makefile
--- linux-2.6.22.5.orig/fs/Makefile	2007-08-22 16:23:54.000000000 -0700
+++ linux-2.6.22.5/fs/Makefile	2007-09-23 09:15:25.000000000 -0700
@@ -63,6 +63,8 @@
 
 obj-$(CONFIG_PROFILING)		+= dcookies.o
 obj-$(CONFIG_DLM)		+= dlm/
+
+obj-$(CONFIG_VARIANT)		+= variant/
  
 # Do not add any filesystems before this line
 obj-$(CONFIG_REISERFS_FS)	+= reiserfs/
diff -urN linux-2.6.22.5.orig/fs/variant/Makefile linux-2.6.22.5/fs/variant/Makefile
--- linux-2.6.22.5.orig/fs/variant/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22.5/fs/variant/Makefile	2007-09-23 09:17:04.000000000 -0700
@@ -0,0 +1,5 @@
+#
+# Makefile for the variant symlinks
+#
+
+obj-$(CONFIG_VARIANT) += variant.o
diff -urN linux-2.6.22.5.orig/fs/namei.c linux-2.6.22.5/fs/namei.c
--- linux-2.6.22.5.orig/fs/namei.c	2007-08-22 16:23:54.000000000 -0700
+++ linux-2.6.22.5/fs/namei.c	2007-09-23 07:15:52.000000000 -0700
@@ -31,6 +31,7 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/namei.h>
+#include <linux/variant.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
@@ -539,10 +540,25 @@
 static __always_inline int __vfs_follow_link(struct nameidata *nd, const char *link)
 {
 	int res = 0;
+#ifdef CONFIG_VARIANT
+	char *newlink = NULL;
+	int err;
+#endif
 	char *name;
 	if (IS_ERR(link))
 		goto fail;
 
+#ifdef CONFIG_VARIANT
+	if (variant_links_enabled && strchr(link, '$')) {
+		err = do_variant_lookup(link, &newlink);
+		if (err) {
+			path_release(nd);
+			return err;
+		}
+		link = newlink;
+	}
+#endif
+
 	if (*link == '/') {
 		path_release(nd);
 		if (!walk_init_root(link, nd))
@@ -551,6 +565,11 @@
 	}
 	res = link_path_walk(link, nd);
 out:
+#ifdef CONFIG_VARIANT
+	if (newlink == link)
+		kfree(newlink);
+#endif
+
 	if (nd->depth || res || nd->last_type!=LAST_NORM)
 		return res;
 	/*
--- linux-2.6.22.5.unpacked/fs/variant/variant.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22.5/fs/variant/variant.c	2007-09-24 04:26:57.000000000 -0700
@@ -0,0 +1,183 @@
+/*
+ *   Copyright (C) Pacific Northwest National Laboratory., 2007
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *   written by Kenneth P Schmidt (kenneth.schmidt <at> pnl.gov) for the
+ *   Department of Energy
+ */
+
+#include<linux/kernel.h>
+#include<linux/slab.h>
+#include<linux/string.h>
+#include<linux/limits.h>
+#include<linux/rwsem.h>
+#include<linux/module.h>
+#include<linux/variant.h>
+
+struct variant_func_module {
+	int id;
+
+	char *name;	/* name for possible reporting to user space (sysfs) */
+
+	/* priority lists the order for variable lookups. 0 - highest priority*/
+	int priority;
+
+	/*
+	 * the callback function for each registered module.
+	 * key points to the key in the original path
+	 * keylen is the length of the key
+	 * dest is the buffer to copy directly into
+	 * destlen is the length allowed to write into the dest buffer
+	 */
+	int ( *variant_lookup_func)(const char *key, int keylen, char *dest, int destlen);
+
+	struct list_head list;
+};
+
+static DECLARE_RWSEM(variant_module_rwsem);
+static LIST_HEAD(variant_func_list);
+static int variant_func_uniq;
+
+int variant_links_enabled = 1;
+
+int variant_func_register(int ( *variant_func)(const char *, int, char *, int), int priority, char *name)
+{
+	int retval;
+	int inserted = 0;
+	struct variant_func_module *new_module, *cur_module;
+	struct list_head *cur;
+
+	down_write(&variant_module_rwsem);
+	new_module = (struct variant_func_module *)kmalloc(
+					sizeof(struct variant_func_module),
+					GFP_KERNEL);
+	if (new_module) {
+		new_module->variant_lookup_func = variant_func;
+		retval = (new_module->id) = ++variant_func_uniq;
+		new_module->priority = priority;
+		new_module->name = (char *)kmalloc(strlen(name)+1, GFP_KERNEL);
+		strcpy(new_module->name, name);
+		list_for_each(cur, &variant_func_list) {
+			cur_module = list_entry(cur, struct variant_func_module, list);
+			if (cur_module->priority < priority) {
+				list_add_tail(&new_module->list, cur);
+				inserted = 1;
+			}
+		}
+		if (!inserted)
+			list_add_tail(&new_module->list, &variant_func_list);
+	} else {
+		retval = -1;
+	}
+	up_write(&variant_module_rwsem);
+	return retval;
+}
+EXPORT_SYMBOL(variant_func_register);
+
+void variant_func_unregister(int id)
+{
+	struct list_head *cur, *tmp;
+
+	down_write(&variant_module_rwsem);
+	list_for_each_safe(cur, tmp, &variant_func_list) {
+		if (list_entry(cur, struct variant_func_module, list)->id == id) {
+			list_del(cur);
+			kfree(list_entry(cur, struct variant_func_module, list));
+		}
+	}
+	up_write(&variant_module_rwsem);
+}
+EXPORT_SYMBOL(variant_func_unregister);
+
+static int variant_var_lookup(const char *key, int keylen, char *dest, int destlen)
+{
+	struct list_head *cur;
+	int modsize = 0;
+	struct variant_func_module *cur_module;
+
+	if (keylen == 0)
+		return 0;
+
+	down_read(&variant_module_rwsem);
+	list_for_each(cur, &variant_func_list) {
+		/*
+		 * call each modules' lookup function
+		 * until one of them returns something
+		 */
+		cur_module = list_entry(cur, struct variant_func_module, list);
+		modsize = (*(cur_module)->variant_lookup_func)(key, keylen, dest, destlen);
+		if (modsize != 0)
+			break;
+	}
+	up_read(&variant_module_rwsem);
+	return modsize;
+}
+
+/*make sure to free the returned string*/
+int do_variant_lookup(const char *path, char **newpath)
+{
+	const char *beg, *end, *cur;
+	char *tmppath;
+	int varsize;
+
+	*newpath = (char *)kmalloc(PATH_MAX, GFP_KERNEL);
+	if (*newpath == NULL) {
+		return -ENOMEM;
+	}
+
+	cur = beg = path;
+	tmppath = *newpath;
+	while ((cur = strchr(cur, '$'))) {
+		if ((cur[1] == '{') && (end = strchr(cur+2, '}'))) {
+
+			/*
+			 * Copy everything before the variable into our new
+			 * buffer, making sure we didn't already overrun it
+			 */
+			varsize = cur - beg;
+			if (varsize + (tmppath - *newpath) > PATH_MAX) {
+				kfree(*newpath);
+				return -ENAMETOOLONG;
+			}
+			strncpy(tmppath, beg, varsize);
+			tmppath += varsize;
+
+			varsize = variant_var_lookup(cur + 2, end - cur - 2, tmppath, PATH_MAX - (tmppath - *newpath));
+			/*
+			 * if zero was returned, then there was no variable
+			 * replacement. Leave the variable in the path
+			 */
+			if (varsize == 0) {
+				varsize = end - cur + 1;
+				if (varsize + (tmppath - *newpath) > PATH_MAX) {
+					kfree(*newpath);
+					return -ENAMETOOLONG;
+				}
+				strncpy(tmppath, cur, varsize);
+			}
+			tmppath += varsize;
+
+			cur = beg = end;
+			beg++;
+		}
+		cur++;
+	}
+	/* copy in the rest of the path */
+	strncpy(tmppath, beg, PATH_MAX - (tmppath - *newpath));
+	(*newpath)[PATH_MAX - 1] = '\0';
+	return 0;
+}
+
