Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYLCQk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYLCQk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYLCQkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:40:13 -0500
Received: from styx.suse.cz ([82.119.242.94]:45010 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751005AbYLCQkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:40:12 -0500
Date: Wed, 3 Dec 2008 17:40:10 +0100
From: Jan Kara <jack@suse.cz>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] udf: in scan_anchors() sector_t last[] is unsigned and
	cannot be negative.
Message-ID: <20081203164010.GA12803@duck.suse.cz>
References: <4935B249.6020906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4935B249.6020906@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 02-12-08 23:10:17, Roel Kluin wrote:
> sector_t last[] is unsigned and cannot be negative.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
  Hmm, I think it would be a violation of the UDF standard if a we got a
medium where these numbers would underflow and most of the cases would
be caught by the following test. But let's make the code clean. I've
written the following patch (which I think makes the underflow checks
much more obvious):

>From a1ea42b47466b642c65cc6c3ca1a5a5fc18498ba Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 3 Dec 2008 17:31:39 +0100
Subject: [PATCH] udf: Add checks to not underflow sector_t

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index b9dc6ad..3c2d35d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -731,13 +731,18 @@ static sector_t udf_scan_anchors(struct super_block *sb, sector_t lastblock)
 	sector_t last[6];
 	int i;
 	struct udf_sb_info *sbi = UDF_SB(sb);
-
-	last[0] = lastblock;
-	last[1] = last[0] - 1;
-	last[2] = last[0] + 1;
-	last[3] = last[0] - 2;
-	last[4] = last[0] - 150;
-	last[5] = last[0] - 152;
+	int last_count = 0;
+
+	last[last_count++] = lastblock;
+	if (lastblock >= 1)
+		last[last_count++] = lastblock - 1;
+	last[last_count++] = lastblock + 1;
+	if (lastblock >= 2)
+		last[last_count++] = lastblock - 2;
+	if (lastblock >= 150)
+		last[last_count++] = lastblock - 150;
+	if (lastblock >= 152)
+		last[last_count++] = lastblock - 152;
 
 	/*  according to spec, anchor is in either:
 	 *     block 256
@@ -745,7 +750,7 @@ static sector_t udf_scan_anchors(struct super_block *sb, sector_t lastblock)
 	 *     lastblock
 	 *  however, if the disc isn't closed, it could be 512 */
 
-	for (i = 0; i < ARRAY_SIZE(last); i++) {
+	for (i = 0; i < last_count; i++) {
 		if (last[i] >= sb->s_bdev->bd_inode->i_size >>
 				sb->s_blocksize_bits)
 			continue;
-- 
1.6.0.4

