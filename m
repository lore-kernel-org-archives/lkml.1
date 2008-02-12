Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbYBLXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbYBLXIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbYBLXIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:08:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902AbYBLXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=QOY8vSogTCypwFAND4Ki92IK1Hnla09nokhlS2vBfRu/8DwsExOKfLDpcOEEx0rwyk8JExlt1NUlpxIGRgUg9NGYoi17bQ22YMLWecin7hATT/qjI2qKS0vA5THOU7X/HJ5zUA44fXPUPt40YX1RigxPdXzGcTQ78gZhn6QAmXY=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH] gfs2: be*_add_cpu conversion
Date: Wed, 13 Feb 2008 00:06:10 +0100
Message-Id: <1202857582-15450-6-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
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
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/dir.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c347095..6f2e382 100644
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
@@ -1616,7 +1616,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 			dent->de_type = cpu_to_be16(type);
 			if (ip->i_di.di_flags & GFS2_DIF_EXHASH) {
 				leaf = (struct gfs2_leaf *)bh->b_data;
-				leaf->lf_entries = cpu_to_be16(be16_to_cpu(leaf->lf_entries) + 1);
+				be16_add_cpu(&leaf->lf_entries, 1);
 			}
 			brelse(bh);
 			error = gfs2_meta_inode_buffer(ip, &bh);
-- 
1.5.3.7

