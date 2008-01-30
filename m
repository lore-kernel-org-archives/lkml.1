Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbYA3VTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbYA3VTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbYA3VHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:07:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:26008 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYA3VHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:07:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=BvT2F2CXC8Aj4BWiGZw5V3J41pWe8LNQBwkXTE6OTP2kIQeDEi3ORETVLKdGOnL8auRtud1ZKAN8G+Df87B88OqeKLTgmcbPeyJhsIX6bS1Ed9gCT3Orz1gggk35PaAMiDEyKlum6O/iN+TZmv3XPEjT18IRq/6hq28R/3+xi/U=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 08/10] udf: simplify __udf_read_inode
Date: Wed, 30 Jan 2008 22:03:58 +0100
Message-Id: <1201727040-6769-9-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- move all brelse(ibh) after main if, because it's called
  on every path except one where ibh is null
- move variables to the most inner blocks

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c |   52 +++++++++++++++++++++++-----------------------------
 1 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 68db2ea..c2d0477 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1116,42 +1116,36 @@ static void __udf_read_inode(struct inode *inode)
 	fe = (struct fileEntry *)bh->b_data;
 
 	if (fe->icbTag.strategyType == cpu_to_le16(4096)) {
-		struct buffer_head *ibh = NULL, *nbh = NULL;
-		struct indirectEntry *ie;
+		struct buffer_head *ibh;
 
 		ibh = udf_read_ptagged(inode->i_sb, iinfo->i_location, 1,
 					&ident);
-		if (ident == TAG_IDENT_IE) {
-			if (ibh) {
-				kernel_lb_addr loc;
-				ie = (struct indirectEntry *)ibh->b_data;
-
-				loc = lelb_to_cpu(ie->indirectICB.extLocation);
-
-				if (ie->indirectICB.extLength &&
-				    (nbh = udf_read_ptagged(inode->i_sb, loc, 0,
-							    &ident))) {
-					if (ident == TAG_IDENT_FE ||
-					    ident == TAG_IDENT_EFE) {
-						memcpy(&iinfo->i_location,
-						       &loc,
-						       sizeof(kernel_lb_addr));
-						brelse(bh);
-						brelse(ibh);
-						brelse(nbh);
-						__udf_read_inode(inode);
-						return;
-					} else {
-						brelse(nbh);
-						brelse(ibh);
-					}
-				} else {
+		if (ident == TAG_IDENT_IE && ibh) {
+			struct buffer_head *nbh = NULL;
+			kernel_lb_addr loc;
+			struct indirectEntry *ie;
+
+			ie = (struct indirectEntry *)ibh->b_data;
+			loc = lelb_to_cpu(ie->indirectICB.extLocation);
+
+			if (ie->indirectICB.extLength &&
+				(nbh = udf_read_ptagged(inode->i_sb, loc, 0,
+							&ident))) {
+				if (ident == TAG_IDENT_FE ||
+					ident == TAG_IDENT_EFE) {
+					memcpy(&iinfo->i_location,
+						&loc,
+						sizeof(kernel_lb_addr));
+					brelse(bh);
 					brelse(ibh);
+					brelse(nbh);
+					__udf_read_inode(inode);
+					return;
 				}
+				brelse(nbh);
 			}
-		} else {
-			brelse(ibh);
 		}
+		brelse(ibh);
 	} else if (fe->icbTag.strategyType != cpu_to_le16(4)) {
 		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
 		       le16_to_cpu(fe->icbTag.strategyType));
-- 
1.5.3.7

