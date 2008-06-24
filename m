Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbYFXI1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbYFXI1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbYFXI1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:27:15 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:45791 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076AbYFXI1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:27:12 -0400
Date: Tue, 24 Jun 2008 10:27:10 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 14/14] mm: Eliminate NULL test and memset after alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241026490.26777@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

 mm/sparse.c |    2 --
 1 file changed, 2 deletions(-)

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/mm/sparse.c b/mm/sparse.c
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -324,8 +324,6 @@ void __init sparse_init(void)
 	 */
 	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
 	usemap_map = alloc_bootmem(size);
-	if (!usemap_map)
-		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
