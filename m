Return-Path: <linux-kernel-owner+w=401wt.eu-S934715AbZKYNcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715AbZKYNcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934714AbZKYNcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:32:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964825AbZKYN2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:16 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/30] GFS2: Add cached ACLs support
Date: Wed, 25 Nov 2009 14:22:33 +0000
Message-Id: <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other patches in this series have been building towards
being able to support cached ACLs like other filesystems. The
only real difference with GFS2 is that we have to invalidate
the cache when we drop a glock, but that is dealt with in earlier
patches.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/acl.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index bd0fce9..3eb1ea8 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -48,6 +48,10 @@ static struct posix_acl *gfs2_acl_get(struct gfs2_inode *ip, int type)
 	if (!ip->i_eattr)
 		return NULL;
 
+	acl = get_cached_acl(&ip->i_inode, type);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
 	name = gfs2_acl_name(type);
 	if (name == NULL)
 		return ERR_PTR(-EINVAL);
@@ -123,6 +127,8 @@ static int gfs2_acl_set(struct inode *inode, int type, struct posix_acl *acl)
 	if (error < 0)
 		goto out;
 	error = gfs2_xattr_set(inode, GFS2_EATYPE_SYS, name, data, len, 0);
+	if (!error)
+		set_cached_acl(inode, type, acl);
 out:
 	kfree(data);
 	return error;
@@ -209,6 +215,7 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 		posix_acl_to_xattr(acl, data, len);
 		error = gfs2_xattr_acl_chmod(ip, attr, data);
 		kfree(data);
+		set_cached_acl(&ip->i_inode, ACL_TYPE_ACCESS, acl);
 	}
 
 out:
@@ -228,15 +235,25 @@ static int gfs2_acl_type(const char *name)
 static int gfs2_xattr_system_get(struct inode *inode, const char *name,
 				 void *buffer, size_t size)
 {
+	struct posix_acl *acl;
 	int type;
+	int error;
 
 	type = gfs2_acl_type(name);
 	if (type < 0)
 		return type;
 
-	return gfs2_xattr_get(inode, GFS2_EATYPE_SYS, name, buffer, size);
-}
+	acl = gfs2_acl_get(GFS2_I(inode), type);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	if (acl == NULL)
+		return -ENODATA;
 
+	error = posix_acl_to_xattr(acl, buffer, size);
+	posix_acl_release(acl);
+
+	return error;
+}
 
 static int gfs2_xattr_system_set(struct inode *inode, const char *name,
 				 const void *value, size_t size, int flags)
@@ -303,6 +320,12 @@ static int gfs2_xattr_system_set(struct inode *inode, const char *name,
 
 set_acl:
 	error = gfs2_xattr_set(inode, GFS2_EATYPE_SYS, name, value, size, 0);
+	if (!error) {
+		if (acl)
+			set_cached_acl(inode, type, acl);
+		else
+			forget_cached_acl(inode, type);
+	}
 out_release:
 	posix_acl_release(acl);
 out:
-- 
1.6.2.5

