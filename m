Return-Path: <linux-kernel-owner+w=401wt.eu-S1764878AbXLPCQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764878AbXLPCQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757729AbXLPCQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:16:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:46344 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbXLPCQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:16:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=L7tC6jSPPF8cIEvuQUNo2vazqE4rPwhG07G0hDA+npPCMH2gC9Lpf/EjVm1DxVsy+5mwqzdyHx+HOHK+CBekhZTD6JkksOkVcqbM0Hux2PQ2VVd9l6GdFGV6X3QI9IKcB2E6l1pC8/eRYLIU7DyApf/MUkPtsqb68NhE7HEs35E=
Date: Sun, 16 Dec 2007 03:17:45 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: [PATCH 6/6] udf: fix sparse warnings (shadowing & mismatch between
	declaration and definition)
Message-ID: <20071216021741.GG26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix warnings:
fs/udf/super.c:1320:24: warning: symbol 'bh' shadows an earlier one
fs/udf/super.c:1240:21: originally declared here
fs/udf/super.c:1583:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1418:6: originally declared here
fs/udf/super.c:1585:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1418:6: originally declared here
fs/udf/super.c:1658:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1648:6: originally declared here
fs/udf/super.c:1660:4: warning: symbol 'i' shadows an earlier one
fs/udf/super.c:1648:6: originally declared here
fs/udf/super.c:450:6: warning: symbol 'udf_write_super' was not declared. Should it be static?

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
---
 fs/udf/super.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4360c7a..9f82b5a 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -447,7 +447,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
 	return 1;
 }

-void udf_write_super(struct super_block *sb)
+static void udf_write_super(struct super_block *sb)
 {
 	lock_kernel();

@@ -1317,7 +1317,6 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
 					(UDF_SB_VAT(sb)->i_size - 36) >> 2;
 			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
-				struct buffer_head *bh = NULL;
 				uint32_t pos;

 				pos = udf_block_map(UDF_SB_VAT(sb), 0);
@@ -1415,7 +1414,7 @@ static void udf_close_lvid(struct super_block *sb)
  */
 static int udf_fill_super(struct super_block *sb, void *options, int silent)
 {
-	int i;
+	int idx;
 	struct inode *inode = NULL;
 	struct udf_options uopt;
 	kernel_lb_addr rootdir, fileset;
@@ -1584,8 +1583,8 @@ error_out:
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
-			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+			for (idx = 0; idx < 4; idx++)
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[idx]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
@@ -1645,7 +1644,7 @@ void udf_warning(struct super_block *sb, const char *function,
  */
 static void udf_put_super(struct super_block *sb)
 {
-	int i;
+	int idx;

 	if (UDF_SB_VAT(sb))
 		iput(UDF_SB_VAT(sb));
@@ -1659,8 +1658,8 @@ static void udf_put_super(struct super_block *sb)
 		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
 			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
 		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
-			for (i = 0; i < 4; i++)
-				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
+			for (idx = 0; idx < 4; idx++)
+				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[idx]);
 		}
 	}
 #ifdef CONFIG_UDF_NLS
--
1.5.3.4

