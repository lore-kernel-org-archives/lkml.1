Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXLUPzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXLUPzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 10:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbXLUPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 10:55:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:30474 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbXLUPzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 10:55:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cH5DF8EAqLWPSPtQeJ1csojaAhJY71F7SOc1/rqeRdQZ5UYqkMM39+XoOrxPeOFEOu6UlZcy3DWziTIAbkmSc8pW/D2WqsAbOorerYLgsQvUbZp//IReGJurqrlQQR02sK2hxRIguNItDDxWsQ54JJn14ZUBm1ZunQVZ39y6sqc=
Date: Fri, 21 Dec 2007 16:56:43 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/5] udf: improve readability of do_udf_readdir
Message-ID: <20071221155639.GB8575@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make reading do_udf_readdir easier by adding new variable

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 174d2fc..c26e281 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -57,6 +57,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 	int i, num;
 	unsigned int dt_type;
 	struct extent_position epos = { NULL, 0, {0, 0} };
+	unsigned char bits;

 	if (nf_pos >= size)
 		return 0;
@@ -65,12 +66,14 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 		nf_pos = (udf_ext0_offset(dir) >> 2);

 	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
+	bits = dir->i_sb->s_blocksize_bits;
+
 	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
 		fibh.sbh = fibh.ebh = NULL;
-	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
+	} else if (inode_bmap(dir, nf_pos >> (bits - 2),
 			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
 		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
+		if ((++offset << bits) < elen) {
 			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
 				epos.offset -= sizeof(short_ad);
 			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
@@ -84,10 +87,10 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
 			return -EIO;
 		}

-		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
-			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
-			if (i + offset > (elen >> dir->i_sb->s_blocksize_bits))
-				i = (elen >> dir->i_sb->s_blocksize_bits) - offset;
+		if (!(offset & ((16 >> (bits - 9)) - 1))) {
+			i = 16 >> (bits - 9);
+			if (i + offset > (elen >> bits))
+				i = (elen >> bits) - offset;
 			for (num = 0; i > 0; i--) {
 				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
 				tmp = udf_tgetblk(dir->i_sb, block);
--
1.5.3.4

