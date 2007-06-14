Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXFNJ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXFNJ4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXFNJ4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:56:00 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:40475 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXFNJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:55:58 -0400
Message-ID: <4670EFE9.8090902@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:36:09 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 5/9] Memory and pathname management functions.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:36:09.0476 (UTC) FILETIME=[ACE99C40:01C7AE56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We limit the maximum length of any string data (such as domainname and pathnames)
to TOMOYO_MAX_PATHNAME_LEN (which is 4000) bytes to fit within a single page.

Userland programs can obtain the amount of RAM currently used by TOMOYO from /proc interface.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/tomoyo/include/realpath.h |   46 +++++
 security/tomoyo/realpath.c         |  445 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 491 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/tomoyo/include/realpath.h linux-2.6.21.5-tomoyo/security/tomoyo/include/realpath.h
--- linux-2.6.21.5/security/tomoyo/include/realpath.h	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/include/realpath.h	2007-06-05 00:00:00.000000000 +0900
@@ -0,0 +1,46 @@
+/*
+ * security/tomoyo/include/realpath.h
+ *
+ * Get the canonicalized absolute pathnames. The basis for TOMOYO.
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ *
+ */
+
+#ifndef _TOMOYO_REALPATH_H
+#define _TOMOYO_REALPATH_H
+
+struct path_info;
+
+/* Returns realpath(3) of the given pathname but ignores chroot'ed root. */
+int tomoyo_realpath_from_dentry2(struct dentry *dentry,
+                                 struct vfsmount *mnt,
+                                 char *newname,
+                                 int newname_len);
+
+/* Returns realpath(3) of the given pathname but ignores chroot'ed root. */
+/* These functions use tomoyo_alloc(), so caller must tomoyo_free() */
+/* if these functions didn't return NULL. */
+char *tomoyo_realpath(const char *pathname);
+char *tomoyo_realpath_nofollow(const char *pathname);
+char *tomoyo_realpath_from_dentry(struct dentry *dentry, struct vfsmount *mnt);
+
+/* Allocate memory for structures. */
+/* The RAM is chunked, so NEVER try to kfree() the returned pointer. */
+void *tomoyo_alloc_element(const unsigned int size);
+
+/* Get used RAM size for tomoyo_alloc_elements(). */
+unsigned int tomoyo_get_memory_used_for_elements(void);
+
+/* Keep the given name on the RAM. */
+/* The RAM is shared, so NEVER try to modify or kfree() the returned name. */
+const struct path_info *tomoyo_save_name(const char *name);
+
+/* Get used RAM size for tomoyo_save_name(). */
+unsigned int tomoyo_get_memory_used_for_save_name(void);
+
+unsigned int tomoyo_get_memory_used_for_dynamic(void);
+
+#endif
diff -ubBpErN linux-2.6.21.5/security/tomoyo/realpath.c linux-2.6.21.5-tomoyo/security/tomoyo/realpath.c
--- linux-2.6.21.5/security/tomoyo/realpath.c	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/realpath.c	2007-06-14 15:06:37.000000000 +0900
@@ -0,0 +1,445 @@
+/*
+ * security/tomoyo/realpath.c
+ *
+ * Get the canonicalized absolute pathnames.
+ * The basis for TOMOYO Linux.
+ *
+ * Copyright (C) 2005-2007  NTT DATA CORPORATION
+ *
+ * Version: 2.0   2007/06/05
+ */
+
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/utime.h>
+#include <linux/file.h>
+#include <linux/smp_lock.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <asm/uaccess.h>
+#include <asm/atomic.h>
+#include <linux/namei.h>
+#include <linux/mount.h>
+#include <linux/proc_fs.h>
+#include "realpath.h"
+#include "tomoyo.h"
+
+extern int sbin_init_started;
+
+/***** realpath handler *****/
+
+/*
+ * tomoyo_get_absolute_path - return the path of a dentry but ignores chroot'ed root.
+ * @dentry: dentry to report
+ * @vfsmnt: vfsmnt to which the dentry belongs
+ * @buffer: buffer to return value in
+ * @buflen: buffer length
+ *
+ * Caller holds the dcache_lock.
+ * Based on __d_path() in fs/dcache.c
+ *
+ * If dentry is a directory, trailing '/' is appended.
+ * Characters other than ' ' < c < 127 are converted to \ooo style octal string.
+ * Character \ is converted to \\ string.
+ */
+static int tomoyo_get_absolute_path(struct dentry *dentry,
+                                    struct vfsmount *vfsmnt,
+                                    char *buffer,
+                                    int buflen)
+{
+	char *start = buffer;
+	char *end = buffer + buflen;
+	int is_dir = (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode));
+
+	if (buflen < 256) goto out;
+
+	*--end = '\0';
+	buflen--;
+
+	for (;;) {
+		struct dentry *parent;
+
+		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
+			/* Global root? */
+			spin_lock(&vfsmount_lock);
+			if (vfsmnt->mnt_parent == vfsmnt) {
+				spin_unlock(&vfsmount_lock);
+				break;
+			}
+			dentry = vfsmnt->mnt_mountpoint;
+			vfsmnt = vfsmnt->mnt_parent;
+			spin_unlock(&vfsmount_lock);
+			continue;
+		}
+		if (is_dir) {
+			is_dir = 0;
+			*--end = '/';
+			buflen--;
+		}
+		parent = dentry->d_parent;
+		{
+			const char *sp = dentry->d_name.name;
+			const char *cp = sp + dentry->d_name.len - 1;
+			unsigned char c;
+
+			/* Exception: Use /proc/self/ rather than /proc/\$/ for current process. */
+			if (IS_ROOT(parent) && *sp > '0' && *sp <= '9' && parent->d_sb
+			    && parent->d_sb->s_magic == PROC_SUPER_MAGIC) {
+				char *ep;
+				const pid_t pid = (pid_t) simple_strtoul(sp, &ep, 10);
+				if (!*ep && pid == current->tgid) {
+					sp = "self";
+					cp = sp + 3;
+				}
+				if (!*ep && pid == current->pid) {
+					sp = "self";
+					cp = sp + 3;
+				}
+			}
+
+			while (sp <= cp) {
+				c = * (unsigned char *) cp;
+				if (c == '\\') {
+					buflen -= 2;
+					if (buflen < 0) goto out;
+					*--end = '\\';
+					*--end = '\\';
+				} else if (c > ' ' && c < 127) {
+					if (--buflen < 0) goto out;
+					*--end = (char) c;
+				} else {
+					buflen -= 4;
+					if (buflen < 0) goto out;
+					*--end = (c & 7) + '0';
+					*--end = ((c >> 3) & 7) + '0';
+					*--end = (c >> 6) + '0';
+					*--end = '\\';
+				}
+				cp--;
+			}
+			if (--buflen < 0) goto out;
+			*--end = '/';
+		}
+		dentry = parent;
+	}
+	if (*end == '/') {
+		buflen++;
+		end++;
+	}
+	{
+		const char *sp = dentry->d_name.name;
+		const char *cp = sp + dentry->d_name.len - 1;
+		unsigned char c;
+		while (sp <= cp) {
+			c = * (unsigned char *) cp;
+			if (c == '\\') {
+				buflen -= 2;
+				if (buflen < 0) goto out;
+				*--end = '\\';
+				*--end = '\\';
+			} else if (c > ' ' && c < 127) {
+				if (--buflen < 0) goto out;
+				*--end = (char) c;
+			} else {
+				buflen -= 4;
+				if (buflen < 0) goto out;
+				*--end = (c & 7) + '0';
+				*--end = ((c >> 3) & 7) + '0';
+				*--end = (c >> 6) + '0';
+				*--end = '\\';
+			}
+			cp--;
+		}
+	}
+	/* Move the pathname to the top of the buffer. */
+	memmove(start, end, strlen(end) + 1);
+	return 0;
+ out:
+	return -ENOMEM;
+}
+
+/* Returns realpath(3) of the given dentry but ignores chroot'ed root. */
+int tomoyo_realpath_from_dentry2(struct dentry *dentry,
+                                 struct vfsmount *mnt,
+                                 char *newname,
+                                 int newname_len)
+{
+	int error;
+	struct dentry *d_dentry;
+	struct vfsmount *d_mnt;
+	if (!dentry || !mnt || !newname || newname_len <= 0) return -EINVAL;
+	if (!current->fs) {
+		printk("%s: current->fs == NULL for pid=%d\n", __FUNCTION__, current->pid);
+		return -ENOENT;
+	}
+	d_dentry = dget(dentry);
+	d_mnt = mntget(mnt);
+	/***** CRITICAL SECTION START *****/
+	spin_lock(&dcache_lock);
+	error = tomoyo_get_absolute_path(d_dentry, d_mnt, newname, newname_len);
+	spin_unlock(&dcache_lock);
+	/***** CRITICAL SECTION END *****/
+	dput(d_dentry);
+	mntput(d_mnt);
+	return error;
+}
+
+/* Returns realpath(3) of the given pathname but ignores chroot'ed root. */
+/* These functions use tomoyo_alloc(), so caller must tomoyo_free() */
+/* if these functions didn't return NULL. */
+char *tomoyo_realpath_from_dentry(struct dentry *dentry, struct vfsmount *mnt)
+{
+	char *buf = tomoyo_alloc(TOMOYO_MAX_PATHNAME_LEN);
+	if (buf && tomoyo_realpath_from_dentry2(dentry, mnt, buf, TOMOYO_MAX_PATHNAME_LEN - 1) == 0)
+		return buf;
+	tomoyo_free(buf);
+	return NULL;
+}
+
+char *tomoyo_realpath(const char *pathname)
+{
+	struct nameidata nd;
+	if (pathname && path_lookup(pathname, LOOKUP_FOLLOW, &nd) == 0) {
+		char *buf = tomoyo_realpath_from_dentry(nd.dentry, nd.mnt);
+		path_release(&nd);
+		return buf;
+	}
+	return NULL;
+}
+
+char *tomoyo_realpath_nofollow(const char *pathname)
+{
+	struct nameidata nd;
+	if (pathname && path_lookup(pathname, 0, &nd) == 0) {
+		char *buf = tomoyo_realpath_from_dentry(nd.dentry, nd.mnt);
+		path_release(&nd);
+		return buf;
+	}
+	return NULL;
+}
+
+/***** Private memory allocator. *****/
+
+/*
+ * Round up an integer so that the returned pointers are appropriately aligned.
+ * FIXME: Are there more requirements that is needed for assigning value atomically?
+ */
+static inline unsigned int tomoyo_roundup(const unsigned int size) {
+	if (sizeof(void *) >= sizeof(long)) {
+		return ((size + sizeof(void *) - 1) / sizeof(void *)) * sizeof(void *);
+	} else {
+		return ((size + sizeof(long) - 1) / sizeof(long)) * sizeof(long);
+	}
+}
+
+static unsigned int allocated_memory_for_elements = 0;
+
+unsigned int tomoyo_get_memory_used_for_elements(void)
+{
+	return allocated_memory_for_elements;
+}
+
+/* Allocate memory for structures. */
+/* The RAM is chunked, so NEVER try to kfree() the returned pointer. */
+void *tomoyo_alloc_element(const unsigned int size)
+{
+	static DECLARE_MUTEX(lock);
+	static char *buf = NULL;
+	static unsigned int buf_used_len = PAGE_SIZE;
+	char *ptr = NULL;
+	const unsigned int word_aligned_size = tomoyo_roundup(size);
+	if (word_aligned_size > PAGE_SIZE) return NULL;
+	down(&lock);
+	if (buf_used_len + word_aligned_size > PAGE_SIZE) {
+		if ((ptr = kmalloc(PAGE_SIZE, GFP_KERNEL)) == NULL) {
+			printk("ERROR: Out of memory for tomoyo_alloc_element().\n");
+			if (!sbin_init_started) panic("MAC Initialization failed.\n");
+		} else {
+			memset(ptr, 0, PAGE_SIZE);
+			buf = ptr;
+			allocated_memory_for_elements += PAGE_SIZE;
+			buf_used_len = word_aligned_size;
+			ptr = buf;
+		}
+	} else if (word_aligned_size) {
+		int i;
+		ptr = buf + buf_used_len;
+		buf_used_len += word_aligned_size;
+		for (i = 0; i < word_aligned_size; i++) {
+			if (ptr[i]) {
+				printk(KERN_ERR "WARNING: Reserved memory was tainted! "
+				                "The system might go wrong.\n");
+				ptr[i] = '\0';
+			}
+		}
+	}
+	up(&lock);
+	return ptr;
+}
+
+/***** Shared memory allocator. *****/
+
+static unsigned int allocated_memory_for_savename = 0;
+
+unsigned int tomoyo_get_memory_used_for_save_name(void)
+{
+	return allocated_memory_for_savename;
+}
+
+#define MAX_HASH 256
+
+struct name_entry {
+	struct name_entry *next; /* Pointer to next record. NULL if none.             */
+	struct path_info entry;
+};
+
+struct free_memory_block_list {
+	struct free_memory_block_list *next; /* Pointer to next record. NULL if none. */
+	char *ptr;                           /* Pointer to a free area.               */
+	int len;                             /* Length of the area.                   */
+};
+
+/* Keep the given name on the RAM. */
+/* The RAM is shared, so NEVER try to modify or kfree() the returned name. */
+const struct path_info *tomoyo_save_name(const char *name)
+{
+	static struct free_memory_block_list fmb_list = { NULL, NULL, 0 };
+	static struct name_entry name_list[MAX_HASH]; /* The list of names. */
+	static DECLARE_MUTEX(lock);
+	struct name_entry *ptr, *prev = NULL;
+	unsigned int hash;
+	struct free_memory_block_list *fmb = &fmb_list;
+	int len;
+	static int first_call = 1;
+	if (!name) return NULL;
+	len = strlen(name) + 1;
+	if (len > TOMOYO_MAX_PATHNAME_LEN) {
+		printk("ERROR: Name too long for tomoyo_save_name().\n");
+		return NULL;
+	}
+	hash = full_name_hash((const unsigned char *) name, len - 1);
+	down(&lock);
+	if (first_call) {
+		int i;
+		first_call = 0;
+		memset(&name_list, 0, sizeof(name_list));
+		for (i = 0; i < MAX_HASH; i++) {
+			name_list[i].entry.name = "/";
+			tomoyo_fill_path_info(&name_list[i].entry);
+		}
+		if (TOMOYO_MAX_PATHNAME_LEN > PAGE_SIZE) panic("Bad size.");
+	}
+	ptr = &name_list[hash % MAX_HASH];
+	while (ptr) {
+		if (hash == ptr->entry.hash && strcmp(name, ptr->entry.name) == 0) goto out;
+		prev = ptr;
+		ptr = ptr->next;
+	}
+	while (len > fmb->len) {
+		if (fmb->next) {
+			fmb = fmb->next;
+		} else {
+			char *cp;
+			if ((cp = kmalloc(PAGE_SIZE, GFP_KERNEL)) == NULL ||
+			    (fmb->next = tomoyo_alloc_element(sizeof(*fmb))) == NULL) {
+				kfree(cp);
+				printk("ERROR: Out of memory for tomoyo_save_name().\n");
+				if (!sbin_init_started) panic("MAC Initialization failed.\n");
+				goto out; /* ptr == NULL */
+			}
+			memset(cp, 0, PAGE_SIZE);
+			allocated_memory_for_savename += PAGE_SIZE;
+			fmb = fmb->next;
+			fmb->ptr = cp;
+			fmb->len = PAGE_SIZE;
+		}
+	}
+	if ((ptr = tomoyo_alloc_element(sizeof(*ptr))) == NULL) goto out;
+	ptr->entry.name = fmb->ptr;
+	memmove(fmb->ptr, name, len);
+	tomoyo_fill_path_info(&ptr->entry);
+	fmb->ptr += len;
+	fmb->len -= len;
+	prev->next = ptr; /* prev != NULL because name_list is not empty. */
+	if (fmb->len == 0) {
+		struct free_memory_block_list *ptr = &fmb_list;
+		while (ptr->next != fmb)
+			ptr = ptr->next;
+		ptr->next = fmb->next;
+	}
+ out:
+	up(&lock);
+	return ptr ? &ptr->entry : NULL;
+}
+
+/***** Dynamic memory allocator. *****/
+
+struct cache_entry {
+	struct list_head list;
+	void *ptr;
+	int size;
+};
+
+static struct kmem_cache *ccs_cachep = NULL;
+
+void tomoyo_realpath_init(void)
+{
+	ccs_cachep = kmem_cache_create("ccs_cache", sizeof(struct cache_entry), 0, 0, NULL, NULL);
+	if (!ccs_cachep) panic("Can't create cache.\n");
+}
+
+static LIST_HEAD(cache_list);
+static spinlock_t cache_list_lock = SPIN_LOCK_UNLOCKED;
+static unsigned int dynamic_memory_size = 0;
+
+unsigned int tomoyo_get_memory_used_for_dynamic(void)
+{
+	return dynamic_memory_size;
+}
+
+void *tomoyo_alloc(const size_t size)
+{
+	void *ret = kmalloc(size, GFP_KERNEL);
+	if (ret) {
+		struct cache_entry *new_entry = kmem_cache_alloc(ccs_cachep, GFP_KERNEL);
+		if (!new_entry) {
+			kfree(ret);
+			ret = NULL;
+		} else {
+			INIT_LIST_HEAD(&new_entry->list);
+			new_entry->ptr = ret;
+			new_entry->size = size;
+			spin_lock(&cache_list_lock);
+			list_add_tail(&new_entry->list, &cache_list);
+			dynamic_memory_size += size;
+			spin_unlock(&cache_list_lock);
+			memset(ret, 0, size);
+		}
+	}
+	return ret;
+}
+
+void tomoyo_free(const void *p)
+{
+	struct list_head *v;
+	struct cache_entry *entry = NULL;
+	if (!p) return;
+	spin_lock(&cache_list_lock);
+	list_for_each(v, &cache_list) {
+		entry = list_entry(v, struct cache_entry, list);
+		if (entry->ptr != p) {
+			entry = NULL;
+			continue;
+		}
+		list_del(&entry->list);
+		dynamic_memory_size -= entry->size;
+		break;
+	}
+	spin_unlock(&cache_list_lock);
+	if (entry) {
+		kfree(p);
+		kmem_cache_free(ccs_cachep, entry);
+	} else {
+		printk("BUG: tomoyo_free() with invalid pointer.\n");
+	}
+}
---------------


