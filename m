Return-Path: <linux-kernel-owner+w=401wt.eu-S1762364AbZLKEwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762364AbZLKEwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbZLKEgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:08 -0500
Received: from kroah.org ([198.145.64.141]:52878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759145AbZLKEfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:41 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:30 2009
Message-Id: <20091211042730.000017969@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [10/90] ext4: reject too-large filesystems on 32-bit kernels
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0010-ext4-reject-too-large-filesystems-on-32-bit-kernels.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit bf43d84b185e2ff54598f8c58a5a8e63148b6e90)

ext4 will happily mount a > 16T filesystem on a 32-bit box, but
this is not safe; writes to the block device will wrap past 16T
and the page cache can't index past 16T (232 index * 4k pages).

Adding another test to the existing "too many sectors" test
should do the trick.

Add a comment, a relevant return value, and fix the reference
to the CONFIG_LBD(AF) option as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2550,12 +2550,19 @@ static int ext4_fill_super(struct super_
 		goto failed_mount;
 	}
 
-	if (ext4_blocks_count(es) >
-		    (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
+	/*
+	 * Test whether we have more sectors than will fit in sector_t,
+	 * and whether the max offset is addressable by the page cache.
+	 */
+	if ((ext4_blocks_count(es) >
+	     (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) ||
+	    (ext4_blocks_count(es) >
+	     (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - sb->s_blocksize_bits))) {
 		ext4_msg(sb, KERN_ERR, "filesystem"
-			" too large to mount safely");
+			 " too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)
 			ext4_msg(sb, KERN_WARNING, "CONFIG_LBDAF not enabled");
+		ret = -EFBIG;
 		goto failed_mount;
 	}
 


