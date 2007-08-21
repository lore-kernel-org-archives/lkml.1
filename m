Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXHUTs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXHUTs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbXHUTsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:48:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbXHUTst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:48:49 -0400
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de, akpm@linux-foundation.org
Subject: [patch] fix the max path calculation in radix-tree.c
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
From: Jeff Moyer <jmoyer@redhat.com>
Date: Tue, 21 Aug 2007 15:48:42 -0400
Message-ID: <x49d4xgy8h1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A while back, Nick Piggin introduced a patch to reduce the node memory
usage for small files (commit cfd9b7df4abd3257c9e381b0e445817b26a51c0c):

-#define RADIX_TREE_MAP_SHIFT	6
+#define RADIX_TREE_MAP_SHIFT	(CONFIG_BASE_SMALL ? 4 : 6)

Unfortunately, he didn't take into account the fact that the
calculation of the maximum path was based on an assumption of having
to round up:

#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)

So, if CONFIG_BASE_SMALL is set, you will end up with a
RADIX_TREE_MAX_PATH that is one greater than necessary.  The practical
upshot of this is just a bit of wasted memory (one long in the
height_to_maxindex array, an extra pre-allocated radix tree node per
cpu, and extra stack usage in a couple of functions), but it seems
worth getting right.

It's also worth noting that I never build with CONFIG_BASE_SMALL.
What I did to test this was duplicate the code in a small user-space
program and check the results of the calculations for max path and the
contents of the height_to_maxindex array.

Cheers.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 514efb2..67c908f 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -60,7 +60,8 @@ struct radix_tree_path {
 };
 
 #define RADIX_TREE_INDEX_BITS  (8 /* CHAR_BIT */ * sizeof(unsigned long))
-#define RADIX_TREE_MAX_PATH (RADIX_TREE_INDEX_BITS/RADIX_TREE_MAP_SHIFT + 2)
+#define RADIX_TREE_MAX_PATH (DIV_ROUND_UP(RADIX_TREE_INDEX_BITS, \
+					  RADIX_TREE_MAP_SHIFT) + 1)
 
 static unsigned long height_to_maxindex[RADIX_TREE_MAX_PATH] __read_mostly;
 
