Return-Path: <linux-kernel-owner+w=401wt.eu-S934800AbZDHRGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800AbZDHRGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934751AbZDHRFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:05:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:38233 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934745AbZDHRFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:05:30 -0400
Date: Wed, 8 Apr 2009 17:03:30 GMT
From: Tejun Heo <tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com, cl@linux.com,
       lethal@linux-sh.org, npiggin@suse.de, tj@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, cl@linux.com, npiggin@suse.de, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D43CEA.3040609@kernel.org>
References: <49D43CEA.3040609@kernel.org>
Subject: [tip:core/percpu] percpu: don't put the first chunk in reverse-map rbtree
Message-ID: <tip-ae9e6bc9f74f8247cbca50a6a93c80e0d686fa19@git.kernel.org>
Git-Commit-ID: ae9e6bc9f74f8247cbca50a6a93c80e0d686fa19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 17:03:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae9e6bc9f74f8247cbca50a6a93c80e0d686fa19
Gitweb:     http://git.kernel.org/tip/ae9e6bc9f74f8247cbca50a6a93c80e0d686fa19
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 2 Apr 2009 13:19:54 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:31:30 +0200

percpu: don't put the first chunk in reverse-map rbtree

Impact: both first chunks don't use rbtree, no functional change

There can be two first chunks - reserved and dynamic with the former
one being optional.  Dynamic first chunk was linked on reverse-mapping
rbtree while the reserved one was mapped manually using the start
address and reserved offset limit.

This patch makes both first chunks to be looked up manually without
using the rbtree.  This is to help getting rid of the rbtree.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: rusty@rustcorp.com.au
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: rmk@arm.linux.org.uk
Cc: starvik@axis.com
Cc: ralf@linux-mips.org
Cc: davem@davemloft.net
Cc: cooloney@kernel.org
Cc: kyle@mcmartin.ca
Cc: matthew@wil.cx
Cc: grundler@parisc-linux.org
Cc: takata@linux-m32r.org
Cc: benh@kernel.crashing.org
Cc: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru
Cc: heiko.carstens@de.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux.com>
LKML-Reference: <49D43CEA.3040609@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
