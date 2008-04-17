Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbYDQJs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbYDQJs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933569AbYDQJ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbYDQJ0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:18 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 31/48] [GFS2] be*_add_cpu conversion
Date: Thu, 17 Apr 2008 09:39:07 +0100
Message-Id: <12084216323165-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216301107-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

replace all:
big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
					expression_in_cpu_byteorder);
with:
	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
generated with semantic patch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 862aa32..34dc8df 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1021,13 +1021,13 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 
 			new->de_inum = dent->de_inum; /* No endian worries */
 			new->de_type = dent->de_type; /* No endian worries */
-			nleaf->lf_entries = cpu_to_be16(be16_to_cpu(nleaf->lf_entries)+1);
+			be16_add_cpu(&nleaf->lf_entries, 1);
 
 			dirent_del(dip, obh, prev, dent);
 
 			if (!oleaf->lf_entries)
 				gfs2_consist_inode(dip);
-			oleaf->lf_entries = cpu_to_be16(be16_to_cpu(oleaf->lf_entries)-1);
+			be16_add_cpu(&oleaf->lf_entries, -1);
 
 			if (!prev)
 				prev = dent;
@@ -1614,7 +1614,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			dent->de_type = cpu_to_be16(type);
 			if (ip->i_di.di_flags & GFS2_DIF_EXHASH) {
 				leaf = (struct gfs2_leaf *)bh->b_data;
-				leaf->lf_entries = cpu_to_be16(be16_to_cpu(leaf->lf_entries) + 1);
+				be16_add_cpu(&leaf->lf_entries, 1);
 			}
 			brelse(bh);
 			error = gfs2_meta_inode_buffer(ip, &bh);
-- 
1.5.1.2

