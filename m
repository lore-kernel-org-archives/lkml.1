Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZCKT0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZCKT0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZCKTZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:25:51 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:52442 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165AbZCKTZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:25:50 -0400
To: torvalds@linux-foundation.org
Subject: [GIT-PULL] More Squashfs fixes for 2.6.29?
Cc: akpm@linux-foundation.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org, phillip@lougher.demon.co.uk, s.L-H@gmx.de
Message-Id: <E1LhU3m-0001f1-Cw@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 11 Mar 2009 19:25:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs commit. It fixes an important
mistake in a previous patch which flags some valid filesystems as corrupted.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git 

Thanks

Phillip

commit 7dacdd0d86a70564cd56e49cd9432d68e0a58916
Author: Phillip Lougher <phillip@lougher.demon.co.uk>
Date:   Wed Mar 11 17:55:28 2009 +0000

Squashfs: Valid filesystems are flagged as bad by the corrupted fs patch

The problem arises due to an unexpected corner-case with zlib which the
corrupted filesystems patch didn't address.  Very occasionally zlib
exits needing a couple of extra bytes of input (up to 6 seen bytes in the
test filesystems), but with avail_out == 0 and no more output buffer
space available.  This situation was incorrectly flagged as an output buffer
overrun by the corrupted filesystems patch.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Reported-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Tested-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 fs/squashfs/block.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 321728f..b85173f 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -166,6 +166,22 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 
 		bytes = length;
 		do {
+			if (msblk->stream.avail_out == 0) {
+				if (page < pages) {
+					msblk->stream.next_out = buffer[page++];
+					msblk->stream.avail_out =
+								PAGE_CACHE_SIZE;
+				} else if (msblk->stream.avail_in > 0
+								|| bytes == 0) {
+					ERROR("zlib_inflate tried to "
+						"decompress too much data, "
+						"expected %d bytes.  Zlib "
+						"data probably corrupt\n",
+						srclength);
+					goto release_mutex;
+				}
+			}
+
 			if (msblk->stream.avail_in == 0 && k < b) {
 				avail = min(bytes, msblk->devblksize - offset);
 				bytes -= avail;
@@ -184,19 +200,6 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 				offset = 0;
 			}
 
-			if (msblk->stream.avail_out == 0) {
-				if (page == pages) {
-					ERROR("zlib_inflate tried to "
-						"decompress too much data, "
-						"expected %d bytes.  Zlib "
-						"data probably corrupt\n",
-						srclength);
-					goto release_mutex;
-				}
-				msblk->stream.next_out = buffer[page++];
-				msblk->stream.avail_out = PAGE_CACHE_SIZE;
-			}
-
 			if (!zlib_init) {
 				zlib_err = zlib_inflateInit(&msblk->stream);
 				if (zlib_err != Z_OK) {
-- 
1.5.6.3

