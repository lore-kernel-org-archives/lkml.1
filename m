Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbXHVM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbXHVM4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbXHVM4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:56:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:35238 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758333AbXHVM4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:56:37 -0400
Date: Wed, 22 Aug 2007 15:15:08 +0200
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] Fix possible NULL pointer dereference in udf_table_free_blocks()
Message-ID: <20070822131508.GC2868@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  fix possible NULL pointer dereference in UDF block freeing code. The description in the
header of the patch has more details. Andrew, please apply. Thanks.

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--Yylu36WmvOXNoKYn
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="udf-2.6.23-rc3-NULL_dereference.diff"

Fix possible NULL pointer dereference when freeing blocks in case table of
free space is used. Also fix handling of the case when we need to move
extent from one block to another one to make space for indirect extent.
BTW: Nobody seem to have ever used this code.

Signed-off-by: Jan Kara <jack@suse.cz>
 
diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc3/fs/udf/balloc.c linux-2.6.23-rc3-1-udf_fix/fs/udf/balloc.c
--- linux-2.6.23-rc3/fs/udf/balloc.c	2007-08-21 14:11:44.000000000 +0200
+++ linux-2.6.23-rc3-1-udf_fix/fs/udf/balloc.c	2007-08-21 14:28:31.000000000 +0200
@@ -540,26 +540,24 @@ static void udf_table_free_blocks(struct
 			if (epos.offset + adsize > sb->s_blocksize) {
 				loffset = epos.offset;
 				aed->lengthAllocDescs = cpu_to_le32(adsize);
-				sptr = UDF_I_DATA(inode) + epos.offset -
-					udf_file_entry_alloc_offset(inode) +
-					UDF_I_LENEATTR(inode) - adsize;
+				sptr = UDF_I_DATA(table) + epos.offset - adsize;
 				dptr = epos.bh->b_data + sizeof(struct allocExtDesc);
 				memcpy(dptr, sptr, adsize);
 				epos.offset = sizeof(struct allocExtDesc) + adsize;
 			} else {
 				loffset = epos.offset + adsize;
 				aed->lengthAllocDescs = cpu_to_le32(0);
-				sptr = oepos.bh->b_data + epos.offset;
-				epos.offset = sizeof(struct allocExtDesc);
-
 				if (oepos.bh) {
+					sptr = oepos.bh->b_data + epos.offset;
 					aed = (struct allocExtDesc *)oepos.bh->b_data;
 					aed->lengthAllocDescs =
 						cpu_to_le32(le32_to_cpu(aed->lengthAllocDescs) + adsize);
 				} else {
+					sptr = UDF_I_DATA(table) + epos.offset;
 					UDF_I_LENALLOC(table) += adsize;
 					mark_inode_dirty(table);
 				}
+				epos.offset = sizeof(struct allocExtDesc);
 			}
 			if (UDF_SB_UDFREV(sb) >= 0x0200)
 				udf_new_tag(epos.bh->b_data, TAG_IDENT_AED, 3, 1,

--Yylu36WmvOXNoKYn--
