Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbZFLJWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbZFLJWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763168AbZFLJW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:22:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53594 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZFLJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:22:28 -0400
Date: Fri, 12 Jun 2009 12:22:29 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, npiggin@suse.de, mingo@elte.hu
Subject: [PATCH] powerpc: don't pass GFP_WAIT to kmalloc() from *_maybe_bootmem()
Message-ID: <Pine.LNX.4.64.0906121215090.30411@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As slab is initialized much earlier now, we must not pass GFP_WAIT to kmalloc()
from *_maybe_bootmem() functions; otherwise slab allocators will enable
interrupts.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Ben, while we're discussing the slab side of things, can we go ahead and 
merge this one? It should fix plenty of cases for powerpc.

 arch/powerpc/lib/alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/alloc.c b/arch/powerpc/lib/alloc.c
index f53e09c..56b35e3 100644
--- a/arch/powerpc/lib/alloc.c
+++ b/arch/powerpc/lib/alloc.c
@@ -9,7 +9,7 @@
 void * __init_refok alloc_maybe_bootmem(size_t size, gfp_t mask)
 {
 	if (mem_init_done)
-		return kmalloc(size, mask);
+		return kmalloc(size, mask & ~__GFP_WAIT);
 	else
 		return alloc_bootmem(size);
 }
@@ -19,7 +19,7 @@ void * __init_refok zalloc_maybe_bootmem(size_t size, gfp_t mask)
 	void *p;
 
 	if (mem_init_done)
-		p = kzalloc(size, mask);
+		p = kzalloc(size, mask & ~__GFP_WAIT);
 	else {
 		p = alloc_bootmem(size);
 		if (p)
-- 
1.6.0.4

