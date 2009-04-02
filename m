Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZDBEXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZDBEXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZDBEXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:23:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:51808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZDBEXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:23:14 -0400
Message-ID: <49D43CEA.3040609@kernel.org>
Date: Thu, 02 Apr 2009 13:19:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 1/2 x86#core/percpu] percpu: don't put the first chunk in
 reverse-map rbtree
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase> <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0903311208110.17960@qirst.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 04:19:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: both first chunks don't use rbtree, no functional change

There can be two first chunks - reserved and dynamic with the former
one being optional.  Dynamic first chunk was linked on reverse-mapping
rbtree while the reserved one was mapped manually using the start
address and reserved offset limit.

This patch makes both first chunks to be looked up manually without
using the rbtree.  This is to help getting rid of the rbtree.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
---
 mm/percpu.c |   41 ++++++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 1aa5d8f..bf1bf1f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -110,9 +110,21 @@ static size_t pcpu_chunk_struct_size __read_mostly;
 void *pcpu_base_addr __read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
-/* optional reserved chunk, only accessible for reserved allocations */
+/*
+ * The first chunk which always exists.  Note that unlike other
+ * chunks, this one can be allocated and mapped in several different
+ * ways and thus often doesn't live in the vmalloc area.
+ */
+static struct pcpu_chunk *pcpu_first_chunk;
+
+/*
+ * Optional reserved chunk.  This chunk reserves part of the first
+ * chunk and serves it for reserved allocations.  The amount of
+ * reserved offset is in pcpu_reserved_chunk_limit.  When reserved
+ * area doesn't exist, the following variables contain NULL and 0
+ * respectively.
+ */
 static struct pcpu_chunk *pcpu_reserved_chunk;
-/* offset limit of the reserved chunk */
 static int pcpu_reserved_chunk_limit;
 
 /*
@@ -297,15 +309,16 @@ static struct rb_node **pcpu_chunk_rb_search(void *addr,
  */
 static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 {
+	void *first_start = pcpu_first_chunk->vm->addr;
 	struct rb_node *n, *parent;
 	struct pcpu_chunk *chunk;
 
-	/* is it in the reserved chunk? */
-	if (pcpu_reserved_chunk) {
-		void *start = pcpu_reserved_chunk->vm->addr;
-
-		if (addr >= start && addr < start + pcpu_reserved_chunk_limit)
+	/* is it in the first chunk? */
+	if (addr >= first_start && addr < first_start + pcpu_chunk_size) {
+		/* is it in the reserved area? */
+		if (addr < first_start + pcpu_reserved_chunk_limit)
 			return pcpu_reserved_chunk;
+		return pcpu_first_chunk;
 	}
 
 	/* nah... search the regular ones */
@@ -1147,7 +1160,8 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 
 	if (reserved_size) {
 		schunk->free_size = reserved_size;
-		pcpu_reserved_chunk = schunk;	/* not for dynamic alloc */
+		pcpu_reserved_chunk = schunk;
+		pcpu_reserved_chunk_limit = static_size + reserved_size;
 	} else {
 		schunk->free_size = dyn_size;
 		dyn_size = 0;			/* dynamic area covered */
@@ -1158,8 +1172,6 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	if (schunk->free_size)
 		schunk->map[schunk->map_used++] = schunk->free_size;
 
-	pcpu_reserved_chunk_limit = static_size + schunk->free_size;
-
 	/* init dynamic chunk if necessary */
 	if (dyn_size) {
 		dchunk = alloc_bootmem(sizeof(struct pcpu_chunk));
@@ -1226,13 +1238,8 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	}
 
 	/* link the first chunk in */
-	if (!dchunk) {
-		pcpu_chunk_relocate(schunk, -1);
-		pcpu_chunk_addr_insert(schunk);
-	} else {
-		pcpu_chunk_relocate(dchunk, -1);
-		pcpu_chunk_addr_insert(dchunk);
-	}
+	pcpu_first_chunk = dchunk ?: schunk;
+	pcpu_chunk_relocate(pcpu_first_chunk, -1);
 
 	/* we're done */
 	pcpu_base_addr = (void *)pcpu_chunk_addr(schunk, 0, 0);
-- 
1.6.0.2

