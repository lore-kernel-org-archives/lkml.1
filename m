Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZC0MnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZC0MnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZC0Mm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:42:58 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:39868 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZC0Mm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:42:57 -0400
Date: Fri, 27 Mar 2009 13:42:52 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] btrfs: fix __ucmpdi2 compile bug on 32 bit builds
Message-ID: <20090327134252.0f24773b@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

We get this on 32 builds:

fs/built-in.o: In function `extent_fiemap':
(.text+0x1019f2): undefined reference to `__ucmpdi2'

Happens because of a switch statement with a 64 bit argument.
Convert this to an if statement to fix this.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/btrfs/extent_io.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/btrfs/extent_io.c
===================================================================
--- linux-2.6.orig/fs/btrfs/extent_io.c
+++ linux-2.6/fs/btrfs/extent_io.c
@@ -2884,25 +2884,19 @@ int extent_fiemap(struct inode *inode, s
 		disko = 0;
 		flags = 0;
 
-		switch (em->block_start) {
-		case EXTENT_MAP_LAST_BYTE:
+		if (em->block_start == EXTENT_MAP_LAST_BYTE) {
 			end = 1;
 			flags |= FIEMAP_EXTENT_LAST;
-			break;
-		case EXTENT_MAP_HOLE:
+		} else if (em->block_start == EXTENT_MAP_HOLE) {
 			flags |= FIEMAP_EXTENT_UNWRITTEN;
-			break;
-		case EXTENT_MAP_INLINE:
+		} else if (em->block_start == EXTENT_MAP_INLINE) {
 			flags |= (FIEMAP_EXTENT_DATA_INLINE |
 				  FIEMAP_EXTENT_NOT_ALIGNED);
-			break;
-		case EXTENT_MAP_DELALLOC:
+		} else if (em->block_start == EXTENT_MAP_DELALLOC) {
 			flags |= (FIEMAP_EXTENT_DELALLOC |
 				  FIEMAP_EXTENT_UNKNOWN);
-			break;
-		default:
+		} else {
 			disko = em->block_start;
-			break;
 		}
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			flags |= FIEMAP_EXTENT_ENCODED;
