Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYKPSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYKPSCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYKPSCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:02:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9534 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYKPSCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=i9k1asJD4KEl7q78z7aScgMRGeTcE1SqlRx75JtewU2jZUrPrFDX7nBPv9OsIjssWx
         B1uxs6XPLrDQOe1ChPghagJD3xpVwfWj4N3a0BMBlTuXAjJaUPKpbbtgT7FG6l1QCzQ6
         aGV6EOyuUbI2r7feeDU5Si6+6HoAwmeiCkZAo=
Date: Sun, 16 Nov 2008 19:01:44 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] udf: reduce stack usage of udf_load_pvoldesc
Message-ID: <20081116180140.GA6282@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate strings with kmalloc.

Checkstack output:
Before: udf_process_sequence:      712
After:  udf_process_sequence:      200

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |   36 +++++++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e25e701..dfe0277 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -902,14 +902,23 @@ static int udf_find_fileset(struct super_block *sb,
 static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 {
 	struct primaryVolDesc *pvoldesc;
-	struct ustr instr;
-	struct ustr outstr;
+	struct ustr *instr, *outstr;
 	struct buffer_head *bh;
 	uint16_t ident;
+	int ret = 1;
+
+	instr = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!instr)
+		return 1;
+
+	outstr = kmalloc(sizeof(struct ustr), GFP_NOFS);
+	if (!outstr)
+		goto out1;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
 	if (!bh)
-		return 1;
+		goto out2;
+
 	BUG_ON(ident != TAG_IDENT_PVD);
 
 	pvoldesc = (struct primaryVolDesc *)bh->b_data;
@@ -925,20 +934,25 @@ static int udf_load_pvoldesc(struct super_block *sb, sector_t block)
 #endif
 	}
 
-	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32))
-		if (udf_CS0toUTF8(&outstr, &instr)) {
-			strncpy(UDF_SB(sb)->s_volume_ident, outstr.u_name,
-				outstr.u_len > 31 ? 31 : outstr.u_len);
+	if (!udf_build_ustr(instr, pvoldesc->volIdent, 32))
+		if (udf_CS0toUTF8(outstr, instr)) {
+			strncpy(UDF_SB(sb)->s_volume_ident, outstr->u_name,
+				outstr->u_len > 31 ? 31 : outstr->u_len);
 			udf_debug("volIdent[] = '%s'\n",
 					UDF_SB(sb)->s_volume_ident);
 		}
 
-	if (!udf_build_ustr(&instr, pvoldesc->volSetIdent, 128))
-		if (udf_CS0toUTF8(&outstr, &instr))
-			udf_debug("volSetIdent[] = '%s'\n", outstr.u_name);
+	if (!udf_build_ustr(instr, pvoldesc->volSetIdent, 128))
+		if (udf_CS0toUTF8(outstr, instr))
+			udf_debug("volSetIdent[] = '%s'\n", outstr->u_name);
 
 	brelse(bh);
-	return 0;
+	ret = 0;
+out2:
+	kfree(outstr);
+out1:
+	kfree(instr);
+	return ret;
 }
 
 static int udf_load_metadata_files(struct super_block *sb, int partition)
-- 
1.5.6.4

