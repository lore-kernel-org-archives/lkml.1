Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbXAWA1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbXAWA1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932582AbXAWA1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:27:39 -0500
Received: from mx1.suse.de ([195.135.220.2]:35481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbXAWA1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:27:25 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:27:01 +1100
Message-Id: <1070123002701.29489@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 004 of 4] md: Avoid reading past the end of a bitmap file.
References: <20070123112437.29357.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In most cases we check the size of the bitmap file before
reading data from it.  However when reading the superblock,
we always read the first PAGE_SIZE bytes, which might not 
always be appropriate.  So limit that read to the size of the
file if appropriate.

Also, we get the count of available bytes wrong in one place,
so that too can read past the end of the file.

Cc:  "yang yin" <yinyang801120@gmail.com>

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-01-23 11:13:43.000000000 +1100
+++ ./drivers/md/bitmap.c	2007-01-23 11:24:09.000000000 +1100
@@ -479,9 +479,12 @@ static int bitmap_read_sb(struct bitmap 
 	int err = -EINVAL;
 
 	/* page 0 is the superblock, read it... */
-	if (bitmap->file)
-		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, PAGE_SIZE);
-	else {
+	if (bitmap->file) {
+		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
+		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
+
+		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, bytes);
+	} else {
 		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset, 0);
 	}
 	if (IS_ERR(bitmap->sb_page)) {
@@ -877,7 +880,8 @@ static int bitmap_init_from_disk(struct 
 			int count;
 			/* unmap the old page, we're done with it */
 			if (index == num_pages-1)
-				count = bytes - index * PAGE_SIZE;
+				count = bytes + sizeof(bitmap_super_t)
+					- index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
 			if (index == 0) {
