Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbYFXIYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbYFXIYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758719AbYFXIY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:24:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44024 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454AbYFXIY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:24:27 -0400
Date: Tue, 24 Jun 2008 10:24:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux390@de.ibm.com, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/14] arch/s390: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241023580.26777@ask.diku.dk>
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

 arch/s390/kernel/topology.c |    2 --
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

diff -u -p a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -313,8 +313,6 @@ void __init s390_init_cpu_topology(void)
 		machine_has_topology_irq = 1;
 
 	tl_info = alloc_bootmem_pages(PAGE_SIZE);
-	if (!tl_info)
-		goto error;
 	info = tl_info;
 	stsi(info, 15, 1, 2);
 
