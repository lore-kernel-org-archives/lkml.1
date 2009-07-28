Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZG1P7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZG1P7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZG1P7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:59:36 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49848 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbZG1P7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:59:35 -0400
Date: Tue, 28 Jul 2009 17:53:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/9] fs/btrfs: correct error-handling code
Message-ID: <Pine.LNX.4.64.0907281753260.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

find_zlib_workspace returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = find_zlib_workspace(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/zlib.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index ecfbce8..3e2b90e 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -208,7 +208,7 @@ int btrfs_zlib_compress_pages(struct address_space *mapping,
 	*total_in = 0;
 
 	workspace = find_zlib_workspace();
-	if (!workspace)
+	if (IS_ERR(workspace))
 		return -1;
 
 	if (Z_OK != zlib_deflateInit(&workspace->def_strm, 3)) {
@@ -366,7 +366,7 @@ int btrfs_zlib_decompress_biovec(struct page **pages_in,
 	char *kaddr;
 
 	workspace = find_zlib_workspace();
-	if (!workspace)
+	if (IS_ERR(workspace))
 		return -ENOMEM;
 
 	data_in = kmap(pages_in[page_in_index]);
@@ -547,9 +547,9 @@ int btrfs_zlib_decompress(unsigned char *data_in,
 		return -ENOMEM;
 
 	workspace = find_zlib_workspace();
-	if (!workspace)
+	if (IS_ERR(workspace))
 		return -ENOMEM;
 
 	workspace->inf_strm.next_in = data_in;
