Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZCLDsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZCLDsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZCLDrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:47:53 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:35478 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbZCLDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:47:52 -0400
To: torvalds@linux-foundation.org
Subject: [GIT-PULL] More squashfs fixes for 2.6.29 (try 2)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       phillip@lougher.demon.co.uk
Message-Id: <E1LhbtX-0001hu-2A@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Thu, 12 Mar 2009 03:47:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This is a revised patch that fixes the bugged "fix oops when reading
fsfuzzer corrupted filesystems patch".  I've replaced the original
dumb check (and admitted it was dumb this time), changed the
Z_NO_FLUSH flag to the more correct Z_SYNC_FLUSH and made the error
messages more understandable to non-technical users.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git 

Thanks

Phillip

commit 363911d027d1de1c6df79eb3f487f5476b9619f4
Author: Phillip Lougher <phillip@lougher.demon.co.uk>
Date:   Thu Mar 12 03:23:48 2009 +0000

Squashfs: Valid filesystems are flagged as bad by the corrupted fs patch

The corrupted filesystem patch added a check against zlib trying to
output too much data in the presence of data corruption.  This check
triggered if zlib_inflate asked to be called again (Z_OK) with
avail_out == 0 and no more output buffers available.  This check proves
to be rather dumb, as it incorrectly catches the case where zlib has
generated all the output, but there are still input bytes to be processed.

This patch does a number of things.  It removes the original check and
replaces it with code to not move to the next output buffer if there
are no more output buffers available, relying on zlib to error if it
wants an extra output buffer in the case of data corruption.  It
also replaces the Z_NO_FLUSH flag with the more correct Z_SYNC_FLUSH
flag, and makes the error messages more understandable to
non-technical users.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
Reported-by: Stefan Lippers-Hollmann <s.L-H@gmx.de>
---
 fs/squashfs/block.c |   21 ++++-----------------
 1 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 321728f..2a79603 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -184,15 +184,7 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
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
+			if (msblk->stream.avail_out == 0 && page < pages) {
 				msblk->stream.next_out = buffer[page++];
 				msblk->stream.avail_out = PAGE_CACHE_SIZE;
 			}
@@ -209,25 +201,20 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 				zlib_init = 1;
 			}
 
-			zlib_err = zlib_inflate(&msblk->stream, Z_NO_FLUSH);
+			zlib_err = zlib_inflate(&msblk->stream, Z_SYNC_FLUSH);
 
 			if (msblk->stream.avail_in == 0 && k < b)
 				put_bh(bh[k++]);
 		} while (zlib_err == Z_OK);
 
 		if (zlib_err != Z_STREAM_END) {
-			ERROR("zlib_inflate returned unexpected result"
-				" 0x%x, srclength %d, avail_in %d,"
-				" avail_out %d\n", zlib_err, srclength,
-				msblk->stream.avail_in,
-				msblk->stream.avail_out);
+			ERROR("zlib_inflate error, data probably corrupt\n");
 			goto release_mutex;
 		}
 
 		zlib_err = zlib_inflateEnd(&msblk->stream);
 		if (zlib_err != Z_OK) {
-			ERROR("zlib_inflateEnd returned unexpected result 0x%x,"
-				" srclength %d\n", zlib_err, srclength);
+			ERROR("zlib_inflate error, data probably corrupt\n");
 			goto release_mutex;
 		}
 		length = msblk->stream.total_out;
-- 
1.5.6.3

