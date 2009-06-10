Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbZFJR5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbZFJR5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZFJR5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:57:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39870 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZFJR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:57:21 -0400
Date: Wed, 10 Jun 2009 20:57:21 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
cc: cl@linux-foundation.com, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, mpm@selenic.com, npiggin@suse.de,
       yinghai@kernel.org
Subject: [PATCH 1/3] bootmem: use slab if bootmem is no longer available
Message-ID: <Pine.LNX.4.64.0906102056530.28361@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As a preparation for initializing the slab allocator early, make sure the
bootmem allocator does not crash and burn if someone calls it after slab is up;
otherwise we'd need a flag day for switching to early slab.

Cc: Christoph Lameter <cl@linux-foundation.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/bootmem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index daf9271..457269c 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -532,6 +532,9 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 					unsigned long size, unsigned long align,
 					unsigned long goal, unsigned long limit)
 {
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
+
 #ifdef CONFIG_HAVE_ARCH_BOOTMEM
 	bootmem_data_t *p_bdata;
 
-- 
1.6.0.4

