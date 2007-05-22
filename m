Return-Path: <linux-kernel-owner+w=401wt.eu-S966464AbXEVRxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966464AbXEVRxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbXEVRx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:53:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:14870 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760221AbXEVRx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=DmpO2QOmHdUcUygo/rirCoN/mTKMG+gGelNklz4ZOmPrMHHKg9V56dc/4vkFm44kSgfl+Imvq0GQ65vTR3O9VDq/rQ2K8HyVIf3Ec6nPrKS5oM/XOjqRc97LDa+Pf8sDu2sc92dEXVDKpyaSKDIkgHSa/CF0AAX/8QlRErdG4WU=
Date: Tue, 22 May 2007 21:52:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UDF: possible usage of uninitialized variables
Message-ID: <20070522175223.GA8259@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A few variables could be used without being explicitly initialized.
Fixed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---


 balloc.c |    6 +++++-
 super.c  |    5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)


diff --git a/balloc.c b/balloc.c
index 4cec910..be37393 100644
--- a/balloc.c
+++ b/balloc.c
@@ -744,7 +744,11 @@ static int udf_table_new_block(struct super_block * sb,
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	uint32_t newblock = 0, adsize;
 	uint32_t elen, goal_elen = 0;
-	kernel_lb_addr eloc, goal_eloc;
+	kernel_lb_addr eloc;
+	kernel_lb_addr goal_eloc = {
+		.logicalBlockNum = 0,
+		.partitionReferenceNum = 0,
+	};
 	struct extent_position epos, goal_epos;
 	int8_t etype;
 
diff --git a/super.c b/super.c
index 9b8644a..068a99c 100644
--- a/super.c
+++ b/super.c
@@ -1358,7 +1358,10 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 			case UDF_VIRTUAL_MAP15:
 			case UDF_VIRTUAL_MAP20:
 			{
-				kernel_lb_addr ino;
+				kernel_lb_addr ino = {
+					.logicalBlockNum = 0,
+					.partitionReferenceNum = 0,
+				};
 
 				if (!UDF_SB_LASTBLOCK(sb))
 				{
