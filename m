Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYAUKLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYAUKLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759843AbYAUKCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759761AbYAUKCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:35 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: "Ryan O'Hara" <rohara@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 27/58] [GFS2] remove unnecessary permission checks
Date: Mon, 21 Jan 2008 09:21:45 +0000
Message-Id: <12009073883125-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073862261-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
Message-Id: <406c292988bbf9cab8eb8b83e290c1f44151f76f.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan O'Hara <rohara@redhat.com>

Remove read/write permission() checks from xattr operations.
VFS layer is already handling permission for xattrs via the
xattr_permission() call, so there is no need for gfs2 to
check permissions. Futhermore, using permission() for SELinux
xattrs ops is incorrect.

Signed-off-by: Ryan O'Hara <rohara@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/eaops.c b/fs/gfs2/eaops.c
index aa8dbf3..ef91b6e 100644
--- a/fs/gfs2/eaops.c
+++ b/fs/gfs2/eaops.c
@@ -59,9 +59,6 @@ unsigned int gfs2_ea_name2type(const char *name, const char **truncated_name)
 static int user_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 {
 	struct inode *inode = &ip->i_inode;
-	int error = permission(inode, MAY_READ, NULL);
-	if (error)
-		return error;
 
 	return gfs2_ea_get_i(ip, er);
 }
@@ -70,14 +67,6 @@ static int user_eo_set(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 {
 	struct inode *inode = &ip->i_inode;
 
-	if (S_ISREG(inode->i_mode) ||
-	    (S_ISDIR(inode->i_mode) && !(inode->i_mode & S_ISVTX))) {
-		int error = permission(inode, MAY_WRITE, NULL);
-		if (error)
-			return error;
-	} else
-		return -EPERM;
-
 	return gfs2_ea_set_i(ip, er);
 }
 
@@ -85,14 +74,6 @@ static int user_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 {
 	struct inode *inode = &ip->i_inode;
 
-	if (S_ISREG(inode->i_mode) ||
-	    (S_ISDIR(inode->i_mode) && !(inode->i_mode & S_ISVTX))) {
-		int error = permission(inode, MAY_WRITE, NULL);
-		if (error)
-			return error;
-	} else
-		return -EPERM;
-
 	return gfs2_ea_remove_i(ip, er);
 }
 
@@ -108,8 +89,6 @@ static int system_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 	     GFS2_ACL_IS_DEFAULT(er->er_name, er->er_name_len)))
 		return -EOPNOTSUPP;
 
-
-
 	return gfs2_ea_get_i(ip, er);
 }
 
@@ -173,9 +152,6 @@ static int system_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 static int security_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 {
 	struct inode *inode = &ip->i_inode;
-	int error = permission(inode, MAY_READ, NULL);
-	if (error)
-		return error;
 
 	return gfs2_ea_get_i(ip, er);
 }
@@ -183,9 +159,6 @@ static int security_eo_get(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 static int security_eo_set(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 {
 	struct inode *inode = &ip->i_inode;
-	int error = permission(inode, MAY_WRITE, NULL);
-	if (error)
-		return error;
 
 	return gfs2_ea_set_i(ip, er);
 }
@@ -193,9 +166,6 @@ static int security_eo_set(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 static int security_eo_remove(struct gfs2_inode *ip, struct gfs2_ea_request *er)
 {
 	struct inode *inode = &ip->i_inode;
-	int error = permission(inode, MAY_WRITE, NULL);
-	if (error)
-		return error;
 
 	return gfs2_ea_remove_i(ip, er);
 }
-- 
1.5.1.2

