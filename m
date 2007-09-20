Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbXITIdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbXITIdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbXITIbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:31:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:12629 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbXITIbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=BXmEnnVAfxSUKIfc2XupvEfROIBRfeLtz+gh+7y/WkyyV1dP72fjIMLKxALz8u/OX9IFevsWNPHINkY0gCQK4hoUZlu7Euq2+Xy2r1OVQidvyMiCVvDF5aZaqZrvMr6yJ+h56oPX2ZvIYOyxpaCDSsGR0SI/tMyrWPePkH4JZfU=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 3/8] sysfs: chain symlinks to their targets
In-Reply-To: <11902770971822-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:31:38 +0900
Message-Id: <11902770981121-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add sd->s_dir.links and sd->s_link.next and chain symlinks to their
targets.  This will be used to implement auto-removal and auto-rename
of symlinks.

Symlinks created with kobject-based sysfs_create_symlink() won't be
chained to keep backward compatibility.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |   26 ++++++++++++++++++++++++--
 fs/sysfs/symlink.c |    3 +++
 fs/sysfs/sysfs.h   |    4 ++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b042a2e..bb9e87e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -495,7 +495,8 @@ static struct inode *sysfs_addrm_get_parent_inode(struct sysfs_addrm_cxt *acxt,
  *
  *	Get @parent and set sd->s_parent to it and increment nlink of
  *	parent inode if @sd is a directory and link into the children
- *	list of the parent.
+ *	list of the parent.  If LINK_CHAINED flag is set, @sd is also
+ *	chained into the parent's s_dir.links list.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -522,6 +523,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *parent,
 
 	sysfs_link_sibling(sd);
 
+	if (sd->s_flags & SYSFS_FLAG_LINK_CHAINED) {
+		sd->s_link.next = sd->s_link.target->s_dir.links;
+		sd->s_link.target->s_dir.links = sd;
+	}
+
 	if (parent_inode) {
 		parent_inode->i_ctime = parent_inode->i_mtime = CURRENT_TIME;
 		if (sysfs_type(sd) == SYSFS_DIR)
@@ -537,7 +543,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *parent,
  *	@sd: sysfs_dirent to be added
  *
  *	Mark @sd removed and drop nlink of parent inode if @sd is a
- *	directory.  @sd is unlinked from the children list.
+ *	directory.  @sd is unlinked from the children list and the
+ *	s_dir.links list if applicable.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -554,6 +561,21 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 
 	parent_inode = sysfs_addrm_get_parent_inode(acxt, sd->s_parent);
 
+	if (sd->s_flags & SYSFS_FLAG_LINK_CHAINED) {
+		struct sysfs_dirent *target = sd->s_link.target;
+		struct sysfs_dirent **p;
+		int removed = 0;
+
+		for (p = &target->s_dir.links; *p; p = &(*p)->s_link.next) {
+			if (*p == sd) {
+				*p = sd->s_link.next;
+				removed = 1;
+				break;
+			}
+		}
+		BUG_ON(!removed);
+	}
+
 	sysfs_unlink_sibling(sd);
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 296fef5..53cc8a6 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -231,6 +231,9 @@ struct sysfs_dirent *__sysfs_add_link(struct sysfs_dirent *parent,
 		goto err;
 
 	if (format) {
+		/* chain into the target's links list */
+		flags |= SYSFS_FLAG_LINK_CHAINED;
+
 		/* SYSFS_COPY_NAME means 'copy the format string' */
 		rc = -ENOMEM;
 		if (mode & SYSFS_COPY_NAME) {
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 9167032..f704279 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -5,10 +5,13 @@ struct sysfs_elem_dir {
 	void			*data;
 	/* children list starts here and goes through sd->s_sibling */
 	struct sysfs_dirent	*children;
+	/* symlinks list starts here and goes through sd->s_link.next */
+	struct sysfs_dirent	*links;
 };
 
 struct sysfs_elem_link {
 	struct sysfs_dirent	*target;
+	struct sysfs_dirent	*next;
 	const char		*name_fmt;
 };
 
@@ -64,6 +67,7 @@ struct sysfs_dirent {
 #define SYSFS_FLAG_REMOVED		0x0200
 #define SYSFS_FLAG_NAME_COPIED		0x0400
 #define SYSFS_FLAG_LINK_NAME_FMT_COPIED	0x0800
+#define SYSFS_FLAG_LINK_CHAINED		0x1000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
-- 
1.5.0.3


