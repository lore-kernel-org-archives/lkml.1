Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZIJKar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZIJKar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZIJKaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:30:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbZIJK37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/15] GFS2: Clean up of extended attribute support
Date: Thu, 10 Sep 2009 12:28:03 +0100
Message-Id: <1252582087-10007-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-11-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-10-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-11-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been on my list for some time. We need to change the way
in which we handle extended attributes to allow faster file creation
times (by reducing the number of transactions required) and the
extended attribute code is the main obstacle to this.

In addition to that, the VFS provides a way to demultiplex the xattr
calls which we ought to be using, rather than rolling our own. This
patch changes the GFS2 code to use that VFS feature and as a result
the code shrinks by a couple of hundred lines or so, and becomes
easier to read.

I'm planning on doing further clean up work in this area, but this
patch is a good start. The cleaned up code also uses the more usual
"xattr" shorthand, I plan to eliminate the use of "eattr" eventually
and in the mean time it serves as a flag as to which bits of the code
have been updated.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/Makefile     |    2 +-
 fs/gfs2/acl.c        |  104 ++++++-------
 fs/gfs2/eaops.c      |  157 -------------------
 fs/gfs2/eaops.h      |   30 ----
 fs/gfs2/eattr.c      |  421 ++++++++++++++++++++++++++++----------------------
 fs/gfs2/eattr.h      |   52 ++-----
 fs/gfs2/file.c       |    1 -
 fs/gfs2/inode.c      |   12 +--
 fs/gfs2/ops_fstype.c |    1 +
 fs/gfs2/ops_inode.c  |   78 ++++-----
 fs/gfs2/super.h      |    1 +
 11 files changed, 333 insertions(+), 526 deletions(-)
 delete mode 100644 fs/gfs2/eaops.c
 delete mode 100644 fs/gfs2/eaops.h

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index 3da2f1f..2a4fd89 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,6 +1,6 @@
 EXTRA_CFLAGS := -I$(src)
 obj-$(CONFIG_GFS2_FS) += gfs2.o
-gfs2-y := acl.o bmap.o dir.o eaops.o eattr.o glock.o \
+gfs2-y := acl.o bmap.o dir.o eattr.o glock.o \
 	glops.o inode.o log.o lops.o main.o meta_io.o \
 	aops.o dentry.o export.o file.o \
 	ops_fstype.o ops_inode.o quota.o \
diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index fa881bd..f6777f1 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -19,7 +19,6 @@
 #include "gfs2.h"
 #include "incore.h"
 #include "acl.h"
-#include "eaops.h"
 #include "eattr.h"
 #include "glock.h"
 #include "inode.h"
@@ -31,8 +30,7 @@
 #define ACL_DEFAULT 0
 
 int gfs2_acl_validate_set(struct gfs2_inode *ip, int access,
-		      struct gfs2_ea_request *er,
-		      int *remove, mode_t *mode)
+			  struct gfs2_ea_request *er, int *remove, mode_t *mode)
 {
 	struct posix_acl *acl;
 	int error;
@@ -83,30 +81,20 @@ int gfs2_acl_validate_remove(struct gfs2_inode *ip, int access)
 	return 0;
 }
 
-static int acl_get(struct gfs2_inode *ip, int access, struct posix_acl **acl,
-		   struct gfs2_ea_location *el, char **data, unsigned int *len)
+static int acl_get(struct gfs2_inode *ip, const char *name,
+		   struct posix_acl **acl, struct gfs2_ea_location *el,
+		   char **datap, unsigned int *lenp)
 {
-	struct gfs2_ea_request er;
-	struct gfs2_ea_location el_this;
+	char *data;
+	unsigned int len;
 	int error;
 
+	el->el_bh = NULL;
+
 	if (!ip->i_eattr)
 		return 0;
 
-	memset(&er, 0, sizeof(struct gfs2_ea_request));
-	if (access) {
-		er.er_name = GFS2_POSIX_ACL_ACCESS;
-		er.er_name_len = GFS2_POSIX_ACL_ACCESS_LEN;
-	} else {
-		er.er_name = GFS2_POSIX_ACL_DEFAULT;
-		er.er_name_len = GFS2_POSIX_ACL_DEFAULT_LEN;
-	}
-	er.er_type = GFS2_EATYPE_SYS;
-
-	if (!el)
-		el = &el_this;
-
-	error = gfs2_ea_find(ip, &er, el);
+	error = gfs2_ea_find(ip, GFS2_EATYPE_SYS, name, el);
 	if (error)
 		return error;
 	if (!el->el_ea)
@@ -114,32 +102,31 @@ static int acl_get(struct gfs2_inode *ip, int access, struct posix_acl **acl,
 	if (!GFS2_EA_DATA_LEN(el->el_ea))
 		goto out;
 
-	er.er_data_len = GFS2_EA_DATA_LEN(el->el_ea);
-	er.er_data = kmalloc(er.er_data_len, GFP_NOFS);
+	len = GFS2_EA_DATA_LEN(el->el_ea);
+	data = kmalloc(len, GFP_NOFS);
 	error = -ENOMEM;
-	if (!er.er_data)
+	if (!data)
 		goto out;
 
-	error = gfs2_ea_get_copy(ip, el, er.er_data);
-	if (error)
+	error = gfs2_ea_get_copy(ip, el, data, len);
+	if (error < 0)
 		goto out_kfree;
+	error = 0;
 
 	if (acl) {
-		*acl = posix_acl_from_xattr(er.er_data, er.er_data_len);
+		*acl = posix_acl_from_xattr(data, len);
 		if (IS_ERR(*acl))
 			error = PTR_ERR(*acl);
 	}
 
 out_kfree:
-	if (error || !data)
-		kfree(er.er_data);
-	else {
-		*data = er.er_data;
-		*len = er.er_data_len;
+	if (error || !datap) {
+		kfree(data);
+	} else {
+		*datap = data;
+		*lenp = len;
 	}
 out:
-	if (error || el == &el_this)
-		brelse(el->el_bh);
 	return error;
 }
 
@@ -153,10 +140,12 @@ out:
 
 int gfs2_check_acl(struct inode *inode, int mask)
 {
+	struct gfs2_ea_location el;
 	struct posix_acl *acl = NULL;
 	int error;
 
-	error = acl_get(GFS2_I(inode), ACL_ACCESS, &acl, NULL, NULL, NULL);
+	error = acl_get(GFS2_I(inode), GFS2_POSIX_ACL_ACCESS, &acl, &el, NULL, NULL);
+	brelse(el.el_bh);
 	if (error)
 		return error;
 
@@ -196,10 +185,12 @@ static int munge_mode(struct gfs2_inode *ip, mode_t mode)
 
 int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
 {
+	struct gfs2_ea_location el;
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct posix_acl *acl = NULL, *clone;
-	struct gfs2_ea_request er;
 	mode_t mode = ip->i_inode.i_mode;
+	char *data = NULL;
+	unsigned int len;
 	int error;
 
 	if (!sdp->sd_args.ar_posix_acl)
@@ -207,11 +198,8 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
 	if (S_ISLNK(ip->i_inode.i_mode))
 		return 0;
 
-	memset(&er, 0, sizeof(struct gfs2_ea_request));
-	er.er_type = GFS2_EATYPE_SYS;
-
-	error = acl_get(dip, ACL_DEFAULT, &acl, NULL,
-			&er.er_data, &er.er_data_len);
+	error = acl_get(dip, GFS2_POSIX_ACL_DEFAULT, &acl, &el, &data, &len);
+	brelse(el.el_bh);
 	if (error)
 		return error;
 	if (!acl) {
@@ -229,9 +217,8 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
 	acl = clone;
 
 	if (S_ISDIR(ip->i_inode.i_mode)) {
-		er.er_name = GFS2_POSIX_ACL_DEFAULT;
-		er.er_name_len = GFS2_POSIX_ACL_DEFAULT_LEN;
-		error = gfs2_system_eaops.eo_set(ip, &er);
+		error = gfs2_xattr_set(&ip->i_inode, GFS2_EATYPE_SYS,
+				       GFS2_POSIX_ACL_DEFAULT, data, len, 0);
 		if (error)
 			goto out;
 	}
@@ -239,21 +226,19 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
 	error = posix_acl_create_masq(acl, &mode);
 	if (error < 0)
 		goto out;
-	if (error > 0) {
-		er.er_name = GFS2_POSIX_ACL_ACCESS;
-		er.er_name_len = GFS2_POSIX_ACL_ACCESS_LEN;
-		posix_acl_to_xattr(acl, er.er_data, er.er_data_len);
-		er.er_mode = mode;
-		er.er_flags = GFS2_ERF_MODE;
-		error = gfs2_system_eaops.eo_set(ip, &er);
-		if (error)
-			goto out;
-	} else
-		munge_mode(ip, mode);
+	if (error == 0)
+		goto munge;
 
+	posix_acl_to_xattr(acl, data, len);
+	error = gfs2_xattr_set(&ip->i_inode, GFS2_EATYPE_SYS,
+			       GFS2_POSIX_ACL_ACCESS, data, len, 0);
+	if (error)
+		goto out;
+munge:
+	error = munge_mode(ip, mode);
 out:
 	posix_acl_release(acl);
-	kfree(er.er_data);
+	kfree(data);
 	return error;
 }
 
@@ -265,9 +250,9 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 	unsigned int len;
 	int error;
 
-	error = acl_get(ip, ACL_ACCESS, &acl, &el, &data, &len);
+	error = acl_get(ip, GFS2_POSIX_ACL_ACCESS, &acl, &el, &data, &len);
 	if (error)
-		return error;
+		goto out_brelse;
 	if (!acl)
 		return gfs2_setattr_simple(ip, attr);
 
@@ -286,8 +271,9 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 
 out:
 	posix_acl_release(acl);
-	brelse(el.el_bh);
 	kfree(data);
+out_brelse:
+	brelse(el.el_bh);
 	return error;
 }
 
diff --git a/fs/gfs2/eaops.c b/fs/gfs2/eaops.c
deleted file mode 100644
index dee9b03..0000000
--- a/fs/gfs2/eaops.c
+++ /dev/null
@@ -1,157 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/capability.h>
-#include <linux/xattr.h>
-#include <linux/gfs2_ondisk.h>
-#include <asm/uaccess.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "acl.h"
-#include "eaops.h"
-#include "eattr.h"
-#include "util.h"
-
-/**
- * gfs2_ea_name2type - get the type of the ea, and truncate type from the name
- * @namep: ea name, possibly with type appended
- *
- * Returns: GFS2_EATYPE_XXX
- */
-
-unsigned int gfs2_ea_name2type(const char *name, const char **truncated_name)
-{
-	unsigned int type;
-
-	if (strncmp(name, "system.", 7) == 0) {
-		type = GFS2_EATYPE_SYS;
-		if (truncated_name)
-			*truncated_name = name + sizeof("system.") - 1;
-	} else if (strncmp(name, "user.", 5) == 0) {
-		type = GFS2_EATYPE_USR;
-		if (truncated_name)
-			*truncated_name = name + sizeof("user.") - 1;
-	} else if (strncmp(name, "security.", 9) == 0) {
-		type = GFS2_EATYPE_SECURITY;
-		if (truncated_name)
-			*truncated_name = name + sizeof("security.") - 1;
-	} else {
-		type = GFS2_EATYPE_UNUSED;
-		if (truncated_name)
-			*truncated_name = NULL;
-	}
-
-	return type;
-}
-
-static int system_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	if (!GFS2_ACL_IS_ACCESS(er->er_name, er->er_name_len) &&
-	    !GFS2_ACL_IS_DEFAULT(er->er_name, er->er_name_len) &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (GFS2_SB(&ip->i_inode)->sd_args.ar_posix_acl == 0 &&
-	    (GFS2_ACL_IS_ACCESS(er->er_name, er->er_name_len) ||
-	     GFS2_ACL_IS_DEFAULT(er->er_name, er->er_name_len)))
-		return -EOPNOTSUPP;
-
-	return gfs2_ea_get_i(ip, er);
-}
-
-static int system_eo_set(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	int remove = 0;
-	int error;
-
-	if (GFS2_ACL_IS_ACCESS(er->er_name, er->er_name_len)) {
-		if (!(er->er_flags & GFS2_ERF_MODE)) {
-			er->er_mode = ip->i_inode.i_mode;
-			er->er_flags |= GFS2_ERF_MODE;
-		}
-		error = gfs2_acl_validate_set(ip, 1, er,
-					      &remove, &er->er_mode);
-		if (error)
-			return error;
-		error = gfs2_ea_set_i(ip, er);
-		if (error)
-			return error;
-		if (remove)
-			gfs2_ea_remove_i(ip, er);
-		return 0;
-
-	} else if (GFS2_ACL_IS_DEFAULT(er->er_name, er->er_name_len)) {
-		error = gfs2_acl_validate_set(ip, 0, er,
-					      &remove, NULL);
-		if (error)
-			return error;
-		if (!remove)
-			error = gfs2_ea_set_i(ip, er);
-		else {
-			error = gfs2_ea_remove_i(ip, er);
-			if (error == -ENODATA)
-				error = 0;
-		}
-		return error;
-	}
-
-	return -EPERM;
-}
-
-static int system_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	if (GFS2_ACL_IS_ACCESS(er->er_name, er->er_name_len)) {
-		int error = gfs2_acl_validate_remove(ip, 1);
-		if (error)
-			return error;
-
-	} else if (GFS2_ACL_IS_DEFAULT(er->er_name, er->er_name_len)) {
-		int error = gfs2_acl_validate_remove(ip, 0);
-		if (error)
-			return error;
-
-	} else
-		return -EPERM;
-
-	return gfs2_ea_remove_i(ip, er);
-}
-
-static const struct gfs2_eattr_operations gfs2_user_eaops = {
-	.eo_get = gfs2_ea_get_i,
-	.eo_set = gfs2_ea_set_i,
-	.eo_remove = gfs2_ea_remove_i,
-	.eo_name = "user",
-};
-
-const struct gfs2_eattr_operations gfs2_system_eaops = {
-	.eo_get = system_eo_get,
-	.eo_set = system_eo_set,
-	.eo_remove = system_eo_remove,
-	.eo_name = "system",
-};
-
-static const struct gfs2_eattr_operations gfs2_security_eaops = {
-	.eo_get = gfs2_ea_get_i,
-	.eo_set = gfs2_ea_set_i,
-	.eo_remove = gfs2_ea_remove_i,
-	.eo_name = "security",
-};
-
-const struct gfs2_eattr_operations *gfs2_ea_ops[] = {
-	NULL,
-	&gfs2_user_eaops,
-	&gfs2_system_eaops,
-	&gfs2_security_eaops,
-};
-
diff --git a/fs/gfs2/eaops.h b/fs/gfs2/eaops.h
deleted file mode 100644
index da2f7fb..0000000
--- a/fs/gfs2/eaops.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __EAOPS_DOT_H__
-#define __EAOPS_DOT_H__
-
-struct gfs2_ea_request;
-struct gfs2_inode;
-
-struct gfs2_eattr_operations {
-	int (*eo_get) (struct gfs2_inode *ip, struct gfs2_ea_request *er);
-	int (*eo_set) (struct gfs2_inode *ip, struct gfs2_ea_request *er);
-	int (*eo_remove) (struct gfs2_inode *ip, struct gfs2_ea_request *er);
-	char *eo_name;
-};
-
-unsigned int gfs2_ea_name2type(const char *name, const char **truncated_name);
-
-extern const struct gfs2_eattr_operations gfs2_system_eaops;
-
-extern const struct gfs2_eattr_operations *gfs2_ea_ops[];
-
-#endif /* __EAOPS_DOT_H__ */
-
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 07ea952..d9a9e26 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -18,7 +18,6 @@
 #include "gfs2.h"
 #include "incore.h"
 #include "acl.h"
-#include "eaops.h"
 #include "eattr.h"
 #include "glock.h"
 #include "inode.h"
@@ -38,26 +37,32 @@
  * Returns: 1 if the EA should be stuffed
  */
 
-static int ea_calc_size(struct gfs2_sbd *sdp, struct gfs2_ea_request *er,
+static int ea_calc_size(struct gfs2_sbd *sdp, unsigned int nsize, size_t dsize,
 			unsigned int *size)
 {
-	*size = GFS2_EAREQ_SIZE_STUFFED(er);
-	if (*size <= sdp->sd_jbsize)
+	unsigned int jbsize = sdp->sd_jbsize;
+
+	/* Stuffed */
+	*size = ALIGN(sizeof(struct gfs2_ea_header) + nsize + dsize, 8);
+
+	if (*size <= jbsize)
 		return 1;
 
-	*size = GFS2_EAREQ_SIZE_UNSTUFFED(sdp, er);
+	/* Unstuffed */
+	*size = ALIGN(sizeof(struct gfs2_ea_header) + nsize +
+		      (sizeof(__be64) * DIV_ROUND_UP(dsize, jbsize)), 8);
 
 	return 0;
 }
 
-static int ea_check_size(struct gfs2_sbd *sdp, struct gfs2_ea_request *er)
+static int ea_check_size(struct gfs2_sbd *sdp, unsigned int nsize, size_t dsize)
 {
 	unsigned int size;
 
-	if (er->er_data_len > GFS2_EA_MAX_DATA_LEN)
+	if (dsize > GFS2_EA_MAX_DATA_LEN)
 		return -ERANGE;
 
-	ea_calc_size(sdp, er, &size);
+	ea_calc_size(sdp, nsize, dsize, &size);
 
 	/* This can only happen with 512 byte blocks */
 	if (size > sdp->sd_jbsize)
@@ -151,7 +156,9 @@ out:
 }
 
 struct ea_find {
-	struct gfs2_ea_request *ef_er;
+	int type;
+	const char *name;
+	size_t namel;
 	struct gfs2_ea_location *ef_el;
 };
 
@@ -160,14 +167,13 @@ static int ea_find_i(struct gfs2_inode *ip, struct buffer_head *bh,
 		     void *private)
 {
 	struct ea_find *ef = private;
-	struct gfs2_ea_request *er = ef->ef_er;
 
 	if (ea->ea_type == GFS2_EATYPE_UNUSED)
 		return 0;
 
-	if (ea->ea_type == er->er_type) {
-		if (ea->ea_name_len == er->er_name_len &&
-		    !memcmp(GFS2_EA2NAME(ea), er->er_name, ea->ea_name_len)) {
+	if (ea->ea_type == ef->type) {
+		if (ea->ea_name_len == ef->namel &&
+		    !memcmp(GFS2_EA2NAME(ea), ef->name, ea->ea_name_len)) {
 			struct gfs2_ea_location *el = ef->ef_el;
 			get_bh(bh);
 			el->el_bh = bh;
@@ -180,13 +186,15 @@ static int ea_find_i(struct gfs2_inode *ip, struct buffer_head *bh,
 	return 0;
 }
 
-int gfs2_ea_find(struct gfs2_inode *ip, struct gfs2_ea_request *er,
+int gfs2_ea_find(struct gfs2_inode *ip, int type, const char *name,
 		 struct gfs2_ea_location *el)
 {
 	struct ea_find ef;
 	int error;
 
-	ef.ef_er = er;
+	ef.type = type;
+	ef.name = name;
+	ef.namel = strlen(name);
 	ef.ef_el = el;
 
 	memset(el, 0, sizeof(struct gfs2_ea_location));
@@ -344,6 +352,20 @@ struct ea_list {
 	unsigned int ei_size;
 };
 
+static inline unsigned int gfs2_ea_strlen(struct gfs2_ea_header *ea)
+{
+	switch (ea->ea_type) {
+	case GFS2_EATYPE_USR:
+		return 5 + ea->ea_name_len + 1;
+	case GFS2_EATYPE_SYS:
+		return 7 + ea->ea_name_len + 1;
+	case GFS2_EATYPE_SECURITY:
+		return 9 + ea->ea_name_len + 1;
+	default:
+		return 0;
+	}
+}
+
 static int ea_list_i(struct gfs2_inode *ip, struct buffer_head *bh,
 		     struct gfs2_ea_header *ea, struct gfs2_ea_header *prev,
 		     void *private)
@@ -392,21 +414,25 @@ static int ea_list_i(struct gfs2_inode *ip, struct buffer_head *bh,
 }
 
 /**
- * gfs2_ea_list -
- * @ip:
- * @er:
+ * gfs2_listxattr - List gfs2 extended attributes
+ * @dentry: The dentry whose inode we are interested in
+ * @buffer: The buffer to write the results
+ * @size: The size of the buffer
  *
  * Returns: actual size of data on success, -errno on error
  */
 
-int gfs2_ea_list(struct gfs2_inode *ip, struct gfs2_ea_request *er)
+ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size)
 {
+	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
+	struct gfs2_ea_request er;
 	struct gfs2_holder i_gh;
 	int error;
 
-	if (!er->er_data || !er->er_data_len) {
-		er->er_data = NULL;
-		er->er_data_len = 0;
+	memset(&er, 0, sizeof(struct gfs2_ea_request));
+	if (size) {
+		er.er_data = buffer;
+		er.er_data_len = size;
 	}
 
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
@@ -414,7 +440,7 @@ int gfs2_ea_list(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 		return error;
 
 	if (ip->i_eattr) {
-		struct ea_list ei = { .ei_er = er, .ei_size = 0 };
+		struct ea_list ei = { .ei_er = &er, .ei_size = 0 };
 
 		error = ea_foreach(ip, ea_list_i, &ei);
 		if (!error)
@@ -491,84 +517,61 @@ out:
 }
 
 int gfs2_ea_get_copy(struct gfs2_inode *ip, struct gfs2_ea_location *el,
-		     char *data)
+		     char *data, size_t size)
 {
+	int ret;
+	size_t len = GFS2_EA_DATA_LEN(el->el_ea);
+	if (len > size)
+		return -ERANGE;
+
 	if (GFS2_EA_IS_STUFFED(el->el_ea)) {
-		memcpy(data, GFS2_EA2DATA(el->el_ea), GFS2_EA_DATA_LEN(el->el_ea));
-		return 0;
-	} else
-		return ea_get_unstuffed(ip, el->el_ea, data);
+		memcpy(data, GFS2_EA2DATA(el->el_ea), len);
+		return len;
+	}
+	ret = ea_get_unstuffed(ip, el->el_ea, data);
+	if (ret < 0)
+		return ret;
+	return len;
 }
 
 /**
- * gfs2_ea_get_i -
- * @ip: The GFS2 inode
- * @er: The request structure
+ * gfs2_xattr_get - Get a GFS2 extended attribute
+ * @inode: The inode
+ * @type: The type of extended attribute
+ * @name: The name of the extended attribute
+ * @buffer: The buffer to write the result into
+ * @size: The size of the buffer
  *
  * Returns: actual size of data on success, -errno on error
  */
 
-int gfs2_ea_get_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
+int gfs2_xattr_get(struct inode *inode, int type, const char *name,
+		   void *buffer, size_t size)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_ea_location el;
 	int error;
 
 	if (!ip->i_eattr)
 		return -ENODATA;
+	if (strlen(name) > GFS2_EA_MAX_NAME_LEN)
+		return -EINVAL;
 
-	error = gfs2_ea_find(ip, er, &el);
+	error = gfs2_ea_find(ip, type, name, &el);
 	if (error)
 		return error;
 	if (!el.el_ea)
 		return -ENODATA;
-
-	if (er->er_data_len) {
-		if (GFS2_EA_DATA_LEN(el.el_ea) > er->er_data_len)
-			error =  -ERANGE;
-		else
-			error = gfs2_ea_get_copy(ip, &el, er->er_data);
-	}
-	if (!error)
+	if (size) 
+		error = gfs2_ea_get_copy(ip, &el, buffer, size);
+	else
 		error = GFS2_EA_DATA_LEN(el.el_ea);
-
 	brelse(el.el_bh);
 
 	return error;
 }
 
 /**
- * gfs2_ea_get -
- * @ip: The GFS2 inode
- * @er: The request structure
- *
- * Returns: actual size of data on success, -errno on error
- */
-
-int gfs2_ea_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	struct gfs2_holder i_gh;
-	int error;
-
-	if (!er->er_name_len ||
-	    er->er_name_len > GFS2_EA_MAX_NAME_LEN)
-		return -EINVAL;
-	if (!er->er_data || !er->er_data_len) {
-		er->er_data = NULL;
-		er->er_data_len = 0;
-	}
-
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
-	if (error)
-		return error;
-
-	error = gfs2_ea_ops[er->er_type]->eo_get(ip, er);
-
-	gfs2_glock_dq_uninit(&i_gh);
-
-	return error;
-}
-
-/**
  * ea_alloc_blk - allocates a new block for extended attributes.
  * @ip: A pointer to the inode that's getting extended attributes
  * @bhp: Pointer to pointer to a struct buffer_head
@@ -713,12 +716,6 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
-		if (er->er_flags & GFS2_ERF_MODE) {
-			gfs2_assert_withdraw(GFS2_SB(&ip->i_inode),
-					    (ip->i_inode.i_mode & S_IFMT) ==
-					    (er->er_mode & S_IFMT));
-			ip->i_inode.i_mode = er->er_mode;
-		}
 		ip->i_inode.i_ctime = CURRENT_TIME;
 		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 		gfs2_dinode_out(ip, dibh->b_data);
@@ -762,15 +759,23 @@ static int ea_init_i(struct gfs2_inode *ip, struct gfs2_ea_request *er,
  * Returns: errno
  */
 
-static int ea_init(struct gfs2_inode *ip, struct gfs2_ea_request *er)
+static int ea_init(struct gfs2_inode *ip, int type, const char *name,
+		   const void *data, size_t size)
 {
+	struct gfs2_ea_request er;
 	unsigned int jbsize = GFS2_SB(&ip->i_inode)->sd_jbsize;
 	unsigned int blks = 1;
 
-	if (GFS2_EAREQ_SIZE_STUFFED(er) > jbsize)
-		blks += DIV_ROUND_UP(er->er_data_len, jbsize);
+	er.er_type = type;
+	er.er_name = name;
+	er.er_name_len = strlen(name);
+	er.er_data = (void *)data;
+	er.er_data_len = size;
+
+	if (GFS2_EAREQ_SIZE_STUFFED(&er) > jbsize)
+		blks += DIV_ROUND_UP(er.er_data_len, jbsize);
 
-	return ea_alloc_skeleton(ip, er, blks, ea_init_i, NULL);
+	return ea_alloc_skeleton(ip, &er, blks, ea_init_i, NULL);
 }
 
 static struct gfs2_ea_header *ea_split_ea(struct gfs2_ea_header *ea)
@@ -848,12 +853,6 @@ static int ea_set_simple_noalloc(struct gfs2_inode *ip, struct buffer_head *bh,
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error)
 		goto out;
-
-	if (er->er_flags & GFS2_ERF_MODE) {
-		gfs2_assert_withdraw(GFS2_SB(&ip->i_inode),
-			(ip->i_inode.i_mode & S_IFMT) == (er->er_mode & S_IFMT));
-		ip->i_inode.i_mode = er->er_mode;
-	}
 	ip->i_inode.i_ctime = CURRENT_TIME;
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
@@ -894,7 +893,8 @@ static int ea_set_simple(struct gfs2_inode *ip, struct buffer_head *bh,
 	int stuffed;
 	int error;
 
-	stuffed = ea_calc_size(GFS2_SB(&ip->i_inode), es->es_er, &size);
+	stuffed = ea_calc_size(GFS2_SB(&ip->i_inode), es->es_er->er_name_len,
+			       es->es_er->er_data_len, &size);
 
 	if (ea->ea_type == GFS2_EATYPE_UNUSED) {
 		if (GFS2_EA_REC_LEN(ea) < size)
@@ -1005,15 +1005,22 @@ out:
 	return error;
 }
 
-static int ea_set_i(struct gfs2_inode *ip, struct gfs2_ea_request *er,
-		    struct gfs2_ea_location *el)
+static int ea_set_i(struct gfs2_inode *ip, int type, const char *name,
+		    const void *value, size_t size, struct gfs2_ea_location *el)
 {
+	struct gfs2_ea_request er;
 	struct ea_set es;
 	unsigned int blks = 2;
 	int error;
 
+	er.er_type = type;
+	er.er_name = name;
+	er.er_data = (void *)value;
+	er.er_name_len = strlen(name);
+	er.er_data_len = size;
+
 	memset(&es, 0, sizeof(struct ea_set));
-	es.es_er = er;
+	es.es_er = &er;
 	es.es_el = el;
 
 	error = ea_foreach(ip, ea_set_simple, &es);
@@ -1024,10 +1031,10 @@ static int ea_set_i(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 
 	if (!(ip->i_diskflags & GFS2_DIF_EA_INDIRECT))
 		blks++;
-	if (GFS2_EAREQ_SIZE_STUFFED(er) > GFS2_SB(&ip->i_inode)->sd_jbsize)
-		blks += DIV_ROUND_UP(er->er_data_len, GFS2_SB(&ip->i_inode)->sd_jbsize);
+	if (GFS2_EAREQ_SIZE_STUFFED(&er) > GFS2_SB(&ip->i_inode)->sd_jbsize)
+		blks += DIV_ROUND_UP(er.er_data_len, GFS2_SB(&ip->i_inode)->sd_jbsize);
 
-	return ea_alloc_skeleton(ip, er, blks, ea_set_block, el);
+	return ea_alloc_skeleton(ip, &er, blks, ea_set_block, el);
 }
 
 static int ea_set_remove_unstuffed(struct gfs2_inode *ip,
@@ -1042,74 +1049,6 @@ static int ea_set_remove_unstuffed(struct gfs2_inode *ip,
 	return ea_remove_unstuffed(ip, el->el_bh, el->el_ea, el->el_prev,0);
 }
 
-int gfs2_ea_set_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	struct gfs2_ea_location el;
-	int error;
-
-	if (!ip->i_eattr) {
-		if (er->er_flags & XATTR_REPLACE)
-			return -ENODATA;
-		return ea_init(ip, er);
-	}
-
-	error = gfs2_ea_find(ip, er, &el);
-	if (error)
-		return error;
-
-	if (el.el_ea) {
-		if (ip->i_diskflags & GFS2_DIF_APPENDONLY) {
-			brelse(el.el_bh);
-			return -EPERM;
-		}
-
-		error = -EEXIST;
-		if (!(er->er_flags & XATTR_CREATE)) {
-			int unstuffed = !GFS2_EA_IS_STUFFED(el.el_ea);
-			error = ea_set_i(ip, er, &el);
-			if (!error && unstuffed)
-				ea_set_remove_unstuffed(ip, &el);
-		}
-
-		brelse(el.el_bh);
-	} else {
-		error = -ENODATA;
-		if (!(er->er_flags & XATTR_REPLACE))
-			error = ea_set_i(ip, er, NULL);
-	}
-
-	return error;
-}
-
-int gfs2_ea_set(struct gfs2_inode *ip, struct gfs2_ea_request *er)
-{
-	struct gfs2_holder i_gh;
-	int error;
-
-	if (!er->er_name_len || er->er_name_len > GFS2_EA_MAX_NAME_LEN)
-		return -EINVAL;
-	if (!er->er_data || !er->er_data_len) {
-		er->er_data = NULL;
-		er->er_data_len = 0;
-	}
-	error = ea_check_size(GFS2_SB(&ip->i_inode), er);
-	if (error)
-		return error;
-
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &i_gh);
-	if (error)
-		return error;
-
-	if (IS_IMMUTABLE(&ip->i_inode))
-		error = -EPERM;
-	else
-		error = gfs2_ea_ops[er->er_type]->eo_set(ip, er);
-
-	gfs2_glock_dq_uninit(&i_gh);
-
-	return error;
-}
-
 static int ea_remove_stuffed(struct gfs2_inode *ip, struct gfs2_ea_location *el)
 {
 	struct gfs2_ea_header *ea = el->el_ea;
@@ -1131,8 +1070,9 @@ static int ea_remove_stuffed(struct gfs2_inode *ip, struct gfs2_ea_location *el)
 
 		if (GFS2_EA_IS_LAST(ea))
 			prev->ea_flags |= GFS2_EAFLAG_LAST;
-	} else
+	} else {
 		ea->ea_type = GFS2_EATYPE_UNUSED;
+	}
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
@@ -1147,15 +1087,29 @@ static int ea_remove_stuffed(struct gfs2_inode *ip, struct gfs2_ea_location *el)
 	return error;
 }
 
-int gfs2_ea_remove_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
+/**
+ * gfs2_xattr_remove - Remove a GFS2 extended attribute
+ * @inode: The inode
+ * @type: The type of the extended attribute
+ * @name: The name of the extended attribute
+ *
+ * This is not called directly by the VFS since we use the (common)
+ * scheme of making a "set with NULL data" mean a remove request. Note
+ * that this is different from a set with zero length data.
+ *
+ * Returns: 0, or errno on failure
+ */
+
+static int gfs2_xattr_remove(struct inode *inode, int type, const char *name)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_ea_location el;
 	int error;
 
 	if (!ip->i_eattr)
 		return -ENODATA;
 
-	error = gfs2_ea_find(ip, er, &el);
+	error = gfs2_ea_find(ip, type, name, &el);
 	if (error)
 		return error;
 	if (!el.el_ea)
@@ -1164,8 +1118,7 @@ int gfs2_ea_remove_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	if (GFS2_EA_IS_STUFFED(el.el_ea))
 		error = ea_remove_stuffed(ip, &el);
 	else
-		error = ea_remove_unstuffed(ip, el.el_bh, el.el_ea, el.el_prev,
-					    0);
+		error = ea_remove_unstuffed(ip, el.el_bh, el.el_ea, el.el_prev, 0);
 
 	brelse(el.el_bh);
 
@@ -1173,31 +1126,70 @@ int gfs2_ea_remove_i(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 }
 
 /**
- * gfs2_ea_remove - sets (or creates or replaces) an extended attribute
- * @ip: pointer to the inode of the target file
- * @er: request information
+ * gfs2_xattr_set - Set (or remove) a GFS2 extended attribute
+ * @inode: The inode
+ * @type: The type of the extended attribute
+ * @name: The name of the extended attribute
+ * @value: The value of the extended attribute (NULL for remove)
+ * @size: The size of the @value argument
+ * @flags: Create or Replace
  *
- * Returns: errno
+ * See gfs2_xattr_remove() for details of the removal of xattrs.
+ *
+ * Returns: 0 or errno on failure
  */
 
-int gfs2_ea_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
+int gfs2_xattr_set(struct inode *inode, int type, const char *name,
+		   const void *value, size_t size, int flags)
 {
-	struct gfs2_holder i_gh;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_ea_location el;
+	unsigned int namel = strlen(name);
 	int error;
 
-	if (!er->er_name_len || er->er_name_len > GFS2_EA_MAX_NAME_LEN)
-		return -EINVAL;
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+		return -EPERM;
+	if (namel > GFS2_EA_MAX_NAME_LEN)
+		return -ERANGE;
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &i_gh);
+	if (value == NULL)
+		return gfs2_xattr_remove(inode, type, name);
+
+	if (ea_check_size(sdp, namel, size))
+		return -ERANGE;
+
+	if (!ip->i_eattr) {
+		if (flags & XATTR_REPLACE)
+			return -ENODATA;
+		return ea_init(ip, type, name, value, size);
+	}
+
+	error = gfs2_ea_find(ip, type, name, &el);
 	if (error)
 		return error;
 
-	if (IS_IMMUTABLE(&ip->i_inode) || IS_APPEND(&ip->i_inode))
-		error = -EPERM;
-	else
-		error = gfs2_ea_ops[er->er_type]->eo_remove(ip, er);
+	if (el.el_ea) {
+		if (ip->i_diskflags & GFS2_DIF_APPENDONLY) {
+			brelse(el.el_bh);
+			return -EPERM;
+		}
 
-	gfs2_glock_dq_uninit(&i_gh);
+		error = -EEXIST;
+		if (!(flags & XATTR_CREATE)) {
+			int unstuffed = !GFS2_EA_IS_STUFFED(el.el_ea);
+			error = ea_set_i(ip, type, name, value, size, &el);
+			if (!error && unstuffed)
+				ea_set_remove_unstuffed(ip, &el);
+		}
+
+		brelse(el.el_bh);
+		return error;
+	}
+
+	error = -ENODATA;
+	if (!(flags & XATTR_REPLACE))
+		error = ea_set_i(ip, type, name, value, size, NULL);
 
 	return error;
 }
@@ -1503,3 +1495,64 @@ out_alloc:
 	return error;
 }
 
+static int gfs2_xattr_user_get(struct inode *inode, const char *name,
+			       void *buffer, size_t size)
+{
+	return gfs2_xattr_get(inode, GFS2_EATYPE_USR, name, buffer, size);
+}
+
+static int gfs2_xattr_user_set(struct inode *inode, const char *name,
+			       const void *value, size_t size, int flags)
+{
+	return gfs2_xattr_set(inode, GFS2_EATYPE_USR, name, value, size, flags);
+}
+
+static int gfs2_xattr_system_get(struct inode *inode, const char *name,
+				 void *buffer, size_t size)
+{
+	return gfs2_xattr_get(inode, GFS2_EATYPE_SYS, name, buffer, size);
+}
+
+static int gfs2_xattr_system_set(struct inode *inode, const char *name,
+				 const void *value, size_t size, int flags)
+{
+	return gfs2_xattr_set(inode, GFS2_EATYPE_SYS, name, value, size, flags);
+}
+
+static int gfs2_xattr_security_get(struct inode *inode, const char *name,
+				   void *buffer, size_t size)
+{
+	return gfs2_xattr_get(inode, GFS2_EATYPE_SECURITY, name, buffer, size);
+}
+
+static int gfs2_xattr_security_set(struct inode *inode, const char *name,
+				   const void *value, size_t size, int flags)
+{
+	return gfs2_xattr_set(inode, GFS2_EATYPE_SECURITY, name, value, size, flags);
+}
+
+static struct xattr_handler gfs2_xattr_user_handler = {
+	.prefix = XATTR_USER_PREFIX,
+	.get    = gfs2_xattr_user_get,
+	.set    = gfs2_xattr_user_set,
+};
+
+static struct xattr_handler gfs2_xattr_security_handler = {
+	.prefix = XATTR_SECURITY_PREFIX,
+	.get    = gfs2_xattr_security_get,
+	.set    = gfs2_xattr_security_set,
+};
+
+static struct xattr_handler gfs2_xattr_system_handler = {
+	.prefix = XATTR_SYSTEM_PREFIX,
+	.get    = gfs2_xattr_system_get,
+	.set    = gfs2_xattr_system_set,
+};
+
+struct xattr_handler *gfs2_xattr_handlers[] = {
+	&gfs2_xattr_user_handler,
+	&gfs2_xattr_security_handler,
+	&gfs2_xattr_system_handler,
+	NULL,
+};
+
diff --git a/fs/gfs2/eattr.h b/fs/gfs2/eattr.h
index c82dbe0..4040a18 100644
--- a/fs/gfs2/eattr.h
+++ b/fs/gfs2/eattr.h
@@ -27,10 +27,6 @@ ALIGN(sizeof(struct gfs2_ea_header) + (ea)->ea_name_len + \
 #define GFS2_EAREQ_SIZE_STUFFED(er) \
 ALIGN(sizeof(struct gfs2_ea_header) + (er)->er_name_len + (er)->er_data_len, 8)
 
-#define GFS2_EAREQ_SIZE_UNSTUFFED(sdp, er) \
-ALIGN(sizeof(struct gfs2_ea_header) + (er)->er_name_len + \
-      sizeof(__be64) * DIV_ROUND_UP((er)->er_data_len, (sdp)->sd_jbsize), 8)
-
 #define GFS2_EA2NAME(ea) ((char *)((struct gfs2_ea_header *)(ea) + 1))
 #define GFS2_EA2DATA(ea) (GFS2_EA2NAME(ea) + (ea)->ea_name_len)
 
@@ -43,16 +39,12 @@ ALIGN(sizeof(struct gfs2_ea_header) + (er)->er_name_len + \
 #define GFS2_EA_BH2FIRST(bh) \
 ((struct gfs2_ea_header *)((bh)->b_data + sizeof(struct gfs2_meta_header)))
 
-#define GFS2_ERF_MODE 0x80000000
-
 struct gfs2_ea_request {
 	const char *er_name;
 	char *er_data;
 	unsigned int er_name_len;
 	unsigned int er_data_len;
 	unsigned int er_type; /* GFS2_EATYPE_... */
-	int er_flags;
-	mode_t er_mode;
 };
 
 struct gfs2_ea_location {
@@ -61,40 +53,20 @@ struct gfs2_ea_location {
 	struct gfs2_ea_header *el_prev;
 };
 
-int gfs2_ea_get_i(struct gfs2_inode *ip, struct gfs2_ea_request *er);
-int gfs2_ea_set_i(struct gfs2_inode *ip, struct gfs2_ea_request *er);
-int gfs2_ea_remove_i(struct gfs2_inode *ip, struct gfs2_ea_request *er);
-
-int gfs2_ea_list(struct gfs2_inode *ip, struct gfs2_ea_request *er);
-int gfs2_ea_get(struct gfs2_inode *ip, struct gfs2_ea_request *er);
-int gfs2_ea_set(struct gfs2_inode *ip, struct gfs2_ea_request *er);
-int gfs2_ea_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er);
-
-int gfs2_ea_dealloc(struct gfs2_inode *ip);
+extern int gfs2_xattr_get(struct inode *inode, int type, const char *name,
+			  void *buffer, size_t size);
+extern int gfs2_xattr_set(struct inode *inode, int type, const char *name,
+			  const void *value, size_t size, int flags);
+extern ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size);
+extern int gfs2_ea_dealloc(struct gfs2_inode *ip);
 
 /* Exported to acl.c */
 
-int gfs2_ea_find(struct gfs2_inode *ip,
-		 struct gfs2_ea_request *er,
-		 struct gfs2_ea_location *el);
-int gfs2_ea_get_copy(struct gfs2_inode *ip,
-		     struct gfs2_ea_location *el,
-		     char *data);
-int gfs2_ea_acl_chmod(struct gfs2_inode *ip, struct gfs2_ea_location *el,
-		      struct iattr *attr, char *data);
-
-static inline unsigned int gfs2_ea_strlen(struct gfs2_ea_header *ea)
-{
-	switch (ea->ea_type) {
-	case GFS2_EATYPE_USR:
-		return 5 + ea->ea_name_len + 1;
-	case GFS2_EATYPE_SYS:
-		return 7 + ea->ea_name_len + 1;
-	case GFS2_EATYPE_SECURITY:
-		return 9 + ea->ea_name_len + 1;
-	default:
-		return 0;
-	}
-}
+extern int gfs2_ea_find(struct gfs2_inode *ip, int type, const char *name,
+			struct gfs2_ea_location *el);
+extern int gfs2_ea_get_copy(struct gfs2_inode *ip, struct gfs2_ea_location *el,
+			    char *data, size_t size);
+extern int gfs2_ea_acl_chmod(struct gfs2_inode *ip, struct gfs2_ea_location *el,
+			     struct iattr *attr, char *data);
 
 #endif /* __EATTR_DOT_H__ */
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 73318a3..166f38f 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -38,7 +38,6 @@
 #include "rgrp.h"
 #include "trans.h"
 #include "util.h"
-#include "eaops.h"
 
 /**
  * gfs2_llseek - seek to a location in a file
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index f9b4fe8..f936d2d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -924,7 +924,6 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip)
 	size_t len;
 	void *value;
 	char *name;
-	struct gfs2_ea_request er;
 
 	err = security_inode_init_security(&ip->i_inode, &dip->i_inode,
 					   &name, &value, &len);
@@ -935,16 +934,7 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip)
 		return err;
 	}
 
-	memset(&er, 0, sizeof(struct gfs2_ea_request));
-
-	er.er_type = GFS2_EATYPE_SECURITY;
-	er.er_name = name;
-	er.er_data = value;
-	er.er_name_len = strlen(name);
-	er.er_data_len = len;
-
-	err = gfs2_ea_set_i(ip, &er);
-
+	err = gfs2_xattr_set(&ip->i_inode, GFS2_EATYPE_SECURITY, name, value, len, 0);
 	kfree(value);
 	kfree(name);
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 165518a..1ec69e6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1186,6 +1186,7 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = GFS2_MAGIC;
 	sb->s_op = &gfs2_super_ops;
 	sb->s_export_op = &gfs2_export_ops;
+	sb->s_xattr = gfs2_xattr_handlers;
 	sb->s_time_gran = 1;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index ce551f8..1ee0c26 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -26,7 +26,6 @@
 #include "acl.h"
 #include "bmap.h"
 #include "dir.h"
-#include "eaops.h"
 #include "eattr.h"
 #include "glock.h"
 #include "inode.h"
@@ -1302,60 +1301,53 @@ static int gfs2_setxattr(struct dentry *dentry, const char *name,
 			 const void *data, size_t size, int flags)
 {
 	struct inode *inode = dentry->d_inode;
-	struct gfs2_ea_request er;
-
-	memset(&er, 0, sizeof(struct gfs2_ea_request));
-	er.er_type = gfs2_ea_name2type(name, &er.er_name);
-	if (er.er_type == GFS2_EATYPE_UNUSED)
-		return -EOPNOTSUPP;
-	er.er_data = (char *)data;
-	er.er_name_len = strlen(er.er_name);
-	er.er_data_len = size;
-	er.er_flags = flags;
-
-	gfs2_assert_warn(GFS2_SB(inode), !(er.er_flags & GFS2_ERF_MODE));
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
 
-	return gfs2_ea_set(GFS2_I(inode), &er);
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret == 0) {
+		ret = generic_setxattr(dentry, name, data, size, flags);
+		gfs2_glock_dq(&gh);
+	}
+	gfs2_holder_uninit(&gh);
+	return ret;
 }
 
 static ssize_t gfs2_getxattr(struct dentry *dentry, const char *name,
 			     void *data, size_t size)
 {
-	struct gfs2_ea_request er;
-
-	memset(&er, 0, sizeof(struct gfs2_ea_request));
-	er.er_type = gfs2_ea_name2type(name, &er.er_name);
-	if (er.er_type == GFS2_EATYPE_UNUSED)
-		return -EOPNOTSUPP;
-	er.er_data = data;
-	er.er_name_len = strlen(er.er_name);
-	er.er_data_len = size;
-
-	return gfs2_ea_get(GFS2_I(dentry->d_inode), &er);
-}
-
-static ssize_t gfs2_listxattr(struct dentry *dentry, char *buffer, size_t size)
-{
-	struct gfs2_ea_request er;
-
-	memset(&er, 0, sizeof(struct gfs2_ea_request));
-	er.er_data = (size) ? buffer : NULL;
-	er.er_data_len = size;
+	struct inode *inode = dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
 
-	return gfs2_ea_list(GFS2_I(dentry->d_inode), &er);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret == 0) {
+		ret = generic_getxattr(dentry, name, data, size);
+		gfs2_glock_dq(&gh);
+	}
+	gfs2_holder_uninit(&gh);
+	return ret;
 }
 
 static int gfs2_removexattr(struct dentry *dentry, const char *name)
 {
-	struct gfs2_ea_request er;
-
-	memset(&er, 0, sizeof(struct gfs2_ea_request));
-	er.er_type = gfs2_ea_name2type(name, &er.er_name);
-	if (er.er_type == GFS2_EATYPE_UNUSED)
-		return -EOPNOTSUPP;
-	er.er_name_len = strlen(er.er_name);
+	struct inode *inode = dentry->d_inode;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder gh;
+	int ret;
 
-	return gfs2_ea_remove(GFS2_I(dentry->d_inode), &er);
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	ret = gfs2_glock_nq(&gh);
+	if (ret == 0) {
+		ret = generic_removexattr(dentry, name);
+		gfs2_glock_dq(&gh);
+	}
+	gfs2_holder_uninit(&gh);
+	return ret;
 }
 
 static int gfs2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index 911c954..235db36 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -54,6 +54,7 @@ extern struct file_system_type gfs2meta_fs_type;
 extern const struct export_operations gfs2_export_ops;
 extern const struct super_operations gfs2_super_ops;
 extern const struct dentry_operations gfs2_dops;
+extern struct xattr_handler *gfs2_xattr_handlers[];
 
 #endif /* __SUPER_DOT_H__ */
 
-- 
1.6.2.5

