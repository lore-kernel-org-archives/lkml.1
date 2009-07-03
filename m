Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZGCNuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZGCNuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZGCNuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:50:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbZGCNuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:50:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] AFS: Export some AFS-specific information through xattrs
To: torvalds@osdl.org, hch@infradead.org, wang840925@gmail.com,
       viro@ZenIV.linux.org.uk
Cc: miklos@szeredi.hu, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Date: Fri, 03 Jul 2009 14:49:55 +0100
Message-ID: <20090703134955.31139.64160.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090703134950.31139.76720.stgit@warthog.procyon.org.uk>
References: <20090703134950.31139.76720.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export some AFS-specific information through xattrs with an "afs." prefix.
This allows some pioctls to be emulated in userspace.

This can be tested directly using the getfattr program:

	[root@andromeda ~]# getfattr -d -m - /afs
	getfattr: Removing leading '/' from absolute path names
	# file: afs
	security.selinux="system_u:object_r:nfs_t:s0\000"
	system.afs.cell="procyon.org.uk"
	system.afs.fid="20000000:00000001:00000001"

A tentative wrapper for partially implementing pioctl in userspace could look
like (this implementation is designed for LD_PRELOAD overloading of syscall()
for simplicity, but should be linked in properly):

/* Userspace version of pioctl
 *
 * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
 * Written by David Howells (dhowells@redhat.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public Licence
 * as published by the Free Software Foundation; either version
 * 2 of the Licence, or (at your option) any later version.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define syscall _X_syscall
#include <unistd.h>
#undef syscall
#include <syscall.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <sys/xattr.h>
#include <errno.h>
#include <dlfcn.h>
#define RTLD_NEXT      ((void *) -1l)

#define O_NOACCESS	00000003
#define O_NOFOLLOW	00400000	/* don't follow links */
#define O_NODE		04000000	/* open filesystem node, not device */

struct ViceIoctl {
	caddr_t		in;
	caddr_t		out;
	short		in_size;
	short		out_size;
};

#define _VICEIOCTL(nr)		_IOW('V', nr, struct ViceIoctl)
#define _CVICEIOCTL(nr)		_IOW('C', nr, struct ViceIoctl)
#define _OVICEIOCTL(nr)		_IOW('O', nr, struct ViceIoctl)

#define AFS_PIOCTL	0x14
#define VIOCGETFID	_VICEIOCTL(22)	/* get file ID */

#define AFS_XATTR_PREFIX "system.afs."

struct afs_fid {
	unsigned	vid;		/* volume ID */
	unsigned	vnode;		/* file index within volume */
	unsigned	unique;		/* unique ID number (file index version) */
};

static long (*libc_syscall)(int number, long a, long b, long c, long d, long e, long f);

/*
 * VIOCGETFID
 */
static int afs_viocgetfid(int fd, int cmd, struct ViceIoctl *args)
{
	struct afs_fid *fid = (void *) args->out;
	char buf[8*3];
	int ret;

	if (args->out_size < sizeof(struct afs_fid) || !args->out) {
		errno = EINVAL;
		return -1;
	}

	ret = fgetxattr(fd, AFS_XATTR_PREFIX "fid", buf, sizeof(buf) - 1);
	if (ret == -1)
		return ret;

	buf[23] = 0;
	if (sscanf(buf, "%x:%x:%x", &fid->vid, &fid->vnode, &fid->unique) != 3) {
		errno = EIO;
		return -1;
	}

	args->out_size = sizeof(struct afs_fid);
	return 0;
}

/*
 * the main pioctl switch
 */
static long pioctl(const char *path, int cmd, struct ViceIoctl *args,
		   int follow)
{
	long ret;
	int fd, ret2;

	printf("pioctl(%s,%x,%p,%d)\n", path, _IOC_NR(cmd), args, follow);

	if (args->in_size < 0 || args->out_size < 0)
		goto invalid_arg;

	/* handle pathless pioctls */
	switch (cmd) {
	default:
		if (!path) {
			errno = EINVAL;
			return -1;
		}
		break;
	}

	fd = open(path, O_NODE | O_NOACCESS | (follow ? 0 : O_NOFOLLOW), 0);
	if (fd == -1)
		return -1;

	switch (cmd) {
	case VIOCGETFID:
		ret = afs_viocgetfid(fd, cmd, args);
		break;
	default:
		errno = EOPNOTSUPP;
		ret = -1;
		break;
	}

	ret2 = close(fd);
	if (ret != -1 && ret2 == -1)
		ret = ret2;
	return ret;

invalid_arg:
	errno = EINVAL;
	return -1;
}

static long afs(long function, long b, long c, long d, long e, long f)
{
	if (function == AFS_PIOCTL) {
		return pioctl((const char *) b,
			      (int) c,
			      (struct ViceIoctl *) d,
			      (int) e);
	} else {
		printf("afs(%ld,%lx)\n", function, b);
		errno = ENOSYS;
		return -1;
	}
}

long syscall(int number, long a, long b, long c, long d, long e, long f)
{
	long ret;

	if (!libc_syscall) {
		libc_syscall = dlsym(RTLD_NEXT, "syscall");
		if (!libc_syscall) {
			fprintf(stderr, "Cannot get syscall\n");
			abort();
		}
	}

	ret = libc_syscall(number, a, b, c, d, e, f);
	if (ret != -1)
		return ret;

	if (errno == ENOSYS && number == SYS_afs_syscall)
		return afs(a, b, c, d, e, f);

	return -1;
}

This can be tested like this:

	gcc -gstabs+ -fpic -Wall   -c -o pioctl.o pioctl.c
	gcc  -shared -o libpioctl.so pioctl.o -ldl -lc
	[root@andromeda ~]# LD_PRELOAD=/tmp/libpioctl.so fs getfid /afs
	pioctl(/afs,16,0x7fffdadc6560,1)
	File /afs (1.0.0) contained in volume 1

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/Makefile     |    3 +
 fs/afs/dir.c        |    2 +
 fs/afs/file.c       |    2 +
 fs/afs/inode.c      |    8 +++
 fs/afs/internal.h   |    5 ++
 fs/afs/mntpt.c      |    2 +
 fs/afs/security.c   |   18 ++++--
 fs/afs/xattr.c      |  162 +++++++++++++++++++++++++++++++++++++++++++++++++++
 security/security.c |    1 
 9 files changed, 197 insertions(+), 6 deletions(-)
 create mode 100644 fs/afs/xattr.c


diff --git a/fs/afs/Makefile b/fs/afs/Makefile
index 4f64b95..095c541 100644
--- a/fs/afs/Makefile
+++ b/fs/afs/Makefile
@@ -27,6 +27,7 @@ kafs-objs := \
 	vlocation.o \
 	vnode.o \
 	volume.o \
-	write.o
+	write.o \
+	xattr.o
 
 obj-$(CONFIG_AFS_FS)  := kafs.o
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9bd7577..5272872 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -60,6 +60,8 @@ const struct inode_operations afs_dir_inode_operations = {
 	.permission	= afs_permission,
 	.getattr	= afs_getattr,
 	.setattr	= afs_setattr,
+	.getxattr	= afs_getxattr,
+	.listxattr	= afs_listxattr,
 };
 
 static const struct dentry_operations afs_fs_dentry_operations = {
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 0149dab..1586496 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -45,6 +45,8 @@ const struct inode_operations afs_file_inode_operations = {
 	.getattr	= afs_getattr,
 	.setattr	= afs_setattr,
 	.permission	= afs_permission,
+	.getxattr	= afs_getxattr,
+	.listxattr	= afs_listxattr,
 };
 
 const struct address_space_operations afs_fs_aops = {
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index c048f06..8fe6192 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -27,6 +27,14 @@ struct afs_iget_data {
 	struct afs_volume	*volume;	/* volume on which resides */
 };
 
+const struct inode_operations afs_symlink_inode_operations = {
+	.readlink	= generic_readlink,
+	.follow_link	= page_follow_link_light,
+	.put_link	= page_put_link,
+	.getxattr	= afs_getxattr,
+	.listxattr	= afs_listxattr,
+};
+
 /*
  * map the AFS file status to the inode member variables
  */
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 59049b0..5a815e8 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -741,6 +741,11 @@ extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
 extern int afs_writeback_all(struct afs_vnode *);
 extern int afs_fsync(struct file *, struct dentry *, int);
 
+/*
+ * xattr.c
+ */
+extern ssize_t afs_listxattr(struct dentry *, char *, size_t);
+extern ssize_t afs_getxattr(struct dentry *, const char *, void *, size_t);
 
 /*****************************************************************************/
 /*
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index c52be53..994f75d 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -37,6 +37,8 @@ const struct inode_operations afs_mntpt_inode_operations = {
 	.follow_link	= afs_mntpt_follow_link,
 	.readlink	= page_readlink,
 	.getattr	= afs_getattr,
+	.getxattr	= afs_getxattr,
+	.listxattr	= afs_listxattr,
 };
 
 static LIST_HEAD(afs_vfsmounts);
diff --git a/fs/afs/security.c b/fs/afs/security.c
index 3ef5043..6c9e011 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -291,7 +291,7 @@ int afs_permission(struct inode *inode, int mask)
 	struct key *key;
 	int ret;
 
-	_enter("{{%x:%u},%lx},%x,",
+	kenter("{{%x:%u},%lx},%x,",
 	       vnode->fid.vid, vnode->fid.vnode, vnode->flags, mask);
 
 	key = afs_request_key(vnode->volume->cell);
@@ -315,7 +315,7 @@ int afs_permission(struct inode *inode, int mask)
 		goto error;
 
 	/* interpret the access mask */
-	_debug("REQ %x ACC %x on %s",
+	kdebug("REQ %x ACC %x on %s",
 	       mask, access, S_ISDIR(inode->i_mode) ? "dir" : "file");
 
 	if (S_ISDIR(inode->i_mode)) {
@@ -330,8 +330,11 @@ int afs_permission(struct inode *inode, int mask)
 					AFS_ACE_INSERT | /* create, mkdir, symlink, rename to */
 					AFS_ACE_WRITE))) /* chmod */
 				goto permission_denied;
+		} else if (mask & MAY_OPEN) {
 		} else {
-			BUG();
+			printk(KERN_WARNING "AFS: Unhandled perm mask %x\n",
+			       mask);
+			goto permission_denied;
 		}
 	} else {
 		if (!(access & AFS_ACE_LOOKUP))
@@ -342,18 +345,23 @@ int afs_permission(struct inode *inode, int mask)
 		} else if (mask & MAY_WRITE) {
 			if (!(access & AFS_ACE_WRITE))
 				goto permission_denied;
+		} else if (mask & MAY_OPEN) {
+		} else {
+			printk(KERN_WARNING "AFS: Unhandled perm mask %x\n",
+			       mask);
+			goto permission_denied;
 		}
 	}
 
 	key_put(key);
 	ret = generic_permission(inode, mask, NULL);
-	_leave(" = %d", ret);
+	kleave(" = %d", ret);
 	return ret;
 
 permission_denied:
 	ret = -EACCES;
 error:
 	key_put(key);
-	_leave(" = %d", ret);
+	kleave(" = %d [error]", ret);
 	return ret;
 }
diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
new file mode 100644
index 0000000..6e9d832
--- /dev/null
+++ b/fs/afs/xattr.c
@@ -0,0 +1,162 @@
+/* AFS extended attribute support
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/xattr.h>
+#include <linux/security.h>
+#include "internal.h"
+
+static const char afs_xattr_prefix[] = XATTR_SYSTEM_PREFIX "afs.";
+
+typedef ssize_t (*afs_xattr_get_t)(struct afs_vnode *vnode, struct key *key,
+				   void *value, size_t size);
+
+struct afs_xattr {
+	const char	*name;
+	afs_xattr_get_t	get;
+};
+
+/*
+ * Get the AFS file identifier of a file
+ */
+static ssize_t afs_xattr_get_fid(struct afs_vnode *vnode, struct key *key,
+				 void *value, size_t size)
+{
+	ssize_t ret;
+
+	_enter("");
+
+	ret = snprintf(value, size, "%08x:%08x:%08x",
+		       vnode->fid.vid, vnode->fid.vnode, vnode->fid.unique);
+
+	_leave(" = %zd", ret);
+	return ret;
+}
+
+/*
+ * Get the AFS cell name of a file
+ */
+static ssize_t afs_xattr_get_cell(struct afs_vnode *vnode, struct key *key,
+				  void *value, size_t size)
+{
+	ssize_t ret;
+
+	_enter("");
+
+	ret = snprintf(value, size, "%s", vnode->volume->vlocation->cell->name);
+
+	_leave(" = %zd", ret);
+	return ret;
+}
+
+/*
+ * ordered list of AFS attributes
+ */
+static const struct afs_xattr afs_xattrs[] = {
+	{ "cell",	afs_xattr_get_cell },
+	{ "fid",	afs_xattr_get_fid },
+	{ NULL }
+};
+
+/*
+ * list extended attributes for an AFS file
+ */
+ssize_t afs_listxattr(struct dentry *dentry, char *list, size_t size)
+{
+	const struct afs_xattr *p;
+	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
+	struct key *key;
+	ssize_t total, nlen, len, plen, ret;
+	char *to = list;
+
+	_enter(",%p,%zu", list, size);
+
+	key = afs_request_key(vnode->volume->cell);
+	if (IS_ERR(key)) {
+		ret = PTR_ERR(key);
+		_leave(" = %ld [no key]", ret);
+		return ret;
+	}
+
+	/* list the AFS attributes */
+	_debug("afs attr");
+	plen = sizeof(afs_xattr_prefix);
+	total = 0;
+	for (p = afs_xattrs; p->name; p++) {
+		nlen = strlen(p->name);
+		len = nlen + sizeof(afs_xattr_prefix);
+		total += len;
+		if (len <= size && list) {
+			size -= len;
+			memcpy(to, afs_xattr_prefix, plen - 1);
+			to += plen - 1;
+			memcpy(to, p->name, nlen + 1);
+			to += nlen + 1;
+		}
+	}
+
+	/* TODO: tag on user attributes when they become available */
+	_debug("user attr");
+
+	/* tag on the security subsys's attributes */
+	_debug("sec attr");
+	len = security_inode_listsecurity(dentry->d_inode, to, size);
+	if (IS_ERR_VALUE(len))
+		total = len;
+	else
+		total += len;
+
+	key_put(key);
+	_leave(" = %zd [%zd]", total, to - list);
+	return total;
+}
+
+/*
+ * get extended attributes for an AFS file
+ */
+ssize_t afs_getxattr(struct dentry *dentry, const char *name,
+		     void *value, size_t size)
+{
+	const struct afs_xattr *p;
+	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
+	struct key *key;
+	ssize_t ret;
+
+	_enter(",%s,,%zu", name, size);
+
+	key = afs_request_key(vnode->volume->cell);
+	if (IS_ERR(key)) {
+		ret = PTR_ERR(key);
+		_leave(" = %ld [no key]", ret);
+		return ret;
+	}
+
+	/* get AFS attributes */
+	if (memcmp(name, afs_xattr_prefix, sizeof(afs_xattr_prefix) - 1) == 0) {
+		name += sizeof(afs_xattr_prefix) - 1;
+
+		for (p = afs_xattrs; p->name; p++) {
+			if (strcmp(name, p->name) == 0) {
+				ret = p->get(vnode, key, value, size);
+				goto out;
+			}
+		}
+		goto noattr;
+	}
+
+	/* TODO: get user attributes when they become available */
+
+noattr:
+	ret = -ENODATA;
+out:
+	key_put(key);
+	_leave(" = %zd", ret);
+	return ret;
+}
diff --git a/security/security.c b/security/security.c
index dc7674f..fe6b812 100644
--- a/security/security.c
+++ b/security/security.c
@@ -609,6 +609,7 @@ int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer
 		return 0;
 	return security_ops->inode_listsecurity(inode, buffer, buffer_size);
 }
+EXPORT_SYMBOL(security_inode_listsecurity);
 
 void security_inode_getsecid(const struct inode *inode, u32 *secid)
 {

