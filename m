Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbZLKWdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbZLKWdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbZLKWd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:33:27 -0500
Received: from kroah.org ([198.145.64.141]:32818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762708AbZLKWZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/27] sysfs: Update s_iattr on link and unlink.
Date: Fri, 11 Dec 2009 14:24:40 -0800
Message-Id: <1260570289-6997-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Currently sysfs updates the timestamps on the vfs directory
inode when we create or remove a directory entry but doesn't
update the cached copy on the sysfs_dirent, fix that oversight.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 9ee130b..36ee6d8 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -464,6 +464,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  */
 int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	struct sysfs_inode_attrs *ps_iattr;
+
 	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
 		return -EEXIST;
 
@@ -476,6 +478,13 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 
 	sysfs_link_sibling(sd);
 
+	/* Update timestamps on the parent */
+	ps_iattr = acxt->parent_sd->s_iattr;
+	if (ps_iattr) {
+		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
+		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
+	}
+
 	return 0;
 }
 
@@ -554,10 +563,19 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	struct sysfs_inode_attrs *ps_iattr;
+
 	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
 
 	sysfs_unlink_sibling(sd);
 
+	/* Update timestamps on the parent */
+	ps_iattr = acxt->parent_sd->s_iattr;
+	if (ps_iattr) {
+		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
+		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
+	}
+
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
 	sd->s_sibling = acxt->removed;
 	acxt->removed = sd;
-- 
1.6.5.5

