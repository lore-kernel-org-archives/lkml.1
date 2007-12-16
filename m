Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbXLPCJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbXLPCJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbXLPCJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:09:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:38698 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbXLPCJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:09:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=LdyxuKY6sK8KbHanyfecyPKB1sFl3xQcY7zFtFPlx4kPv/Xbr4/sS45j13WJaw19CZTrUgKZom9TrWlt47B40bMrCDzxP7NkprVRPmEFZqus6OxcWrEPp7ETFo4rHLSAsja/uM6tSOyIhiTFrqDR9fyeOFWi8oW9dygU+E/8fyE=
Date: Sun, 16 Dec 2007 03:11:08 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: [PATCH 2/6] udf: improve readability of do_udf_readdir
Message-ID: <20071216021103.GC26986@joi>
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

