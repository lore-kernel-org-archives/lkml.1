Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbZCYER0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbZCYER0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 00:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZCYEQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 00:16:58 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48509 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbZCYEQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 00:16:57 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 1/3] sysfs: make the sysfs_addrm_cxt->removed list FIFO
To: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 22:16:51 -0600
Message-ID: <20090325041651.15921.52451.stgit@bob.kio>
In-Reply-To: <20090325035707.15921.42150.stgit@bob.kio>
References: <20090325035707.15921.42150.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Add sysfs_addrm_cxt->removed_tail to make the ->removed list FIFO.
This will be used to implement care-free suicide.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 fs/sysfs/dir.c   |    7 +++++--
 fs/sysfs/sysfs.h |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 82d3b79..39320a5 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -369,6 +369,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 
 	memset(acxt, 0, sizeof(*acxt));
 	acxt->parent_sd = parent_sd;
+	acxt->removed_tail = &acxt->removed;
 
 	/* Lookup parent inode.  inode initialization is protected by
 	 * sysfs_mutex, so inode existence can be determined by
@@ -485,8 +486,10 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	sysfs_unlink_sibling(sd);
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
-	sd->s_sibling = acxt->removed;
-	acxt->removed = sd;
+	*acxt->removed_tail = sd;
+	/* keep them in FIFO order, suicide check depends on it */
+	acxt->removed_tail = &sd->s_sibling;
+	*acxt->removed_tail = NULL;
 
 	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
 		drop_nlink(acxt->parent_inode);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 93c6d6b..cb8ac65 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -81,7 +81,7 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 struct sysfs_addrm_cxt {
 	struct sysfs_dirent	*parent_sd;
 	struct inode		*parent_inode;
-	struct sysfs_dirent	*removed;
+	struct sysfs_dirent	*removed, **removed_tail;
 	int			cnt;
 };
 

