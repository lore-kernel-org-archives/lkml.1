Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZG0QS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZG0QS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZG0QS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:18:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44209 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbZG0QSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:18:24 -0400
Date: Mon, 27 Jul 2009 18:15:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/12] fs/btrfs: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271814490.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dir has already been tested.  It seems that this test should be on the
recently returned value inode.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/tree-log.c                 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c139222..d91b0de 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -797,7 +797,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 		return -ENOENT;
 
 	inode = read_one_inode(root, key->objectid);
-	BUG_ON(!dir);
+	BUG_ON(!inode);
 
 	ref_ptr = btrfs_item_ptr_offset(eb, slot);
 	ref_end = ref_ptr + btrfs_item_size_nr(eb, slot);
