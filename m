Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbZGFKwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbZGFKwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 06:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZGFKwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 06:52:06 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:63428 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664AbZGFKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 06:52:05 -0400
Subject: [RFC PATCH 3/3] kmemleak: Remove alloc_bootmem annotations introduced
	in the past
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 06 Jul 2009 11:52:01 +0100
Message-ID: <20090706105200.16051.4972.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2009 10:52:01.0440 (UTC) FILETIME=[CAAEC200:01C9FE27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmemleak_alloc() calls were added in some places where alloc_bootmem was
called. Since now kmemleak tracks bootmem allocations, these explicit
calls should be run.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/pid.c    |    7 -------
 mm/page_alloc.c |   14 +++-----------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 5fa1db4..31310b5 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -36,7 +36,6 @@
 #include <linux/pid_namespace.h>
 #include <linux/init_task.h>
 #include <linux/syscalls.h>
-#include <linux/kmemleak.h>
 
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
@@ -513,12 +512,6 @@ void __init pidhash_init(void)
 	pid_hash = alloc_bootmem(pidhash_size *	sizeof(*(pid_hash)));
 	if (!pid_hash)
 		panic("Could not alloc pidhash!\n");
-	/*
-	 * pid_hash contains references to allocated struct pid objects and it
-	 * must be scanned by kmemleak to avoid false positives.
-	 */
-	kmemleak_alloc(pid_hash, pidhash_size *	sizeof(*(pid_hash)), 0,
-		       GFP_KERNEL);
 	for (i = 0; i < pidhash_size; i++)
 		INIT_HLIST_HEAD(&pid_hash[i]);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e0f2cdf..202ef6b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4745,8 +4745,10 @@ void *__init alloc_large_system_hash(const char *tablename,
 			 * some pages at the end of hash table which
 			 * alloc_pages_exact() automatically does
 			 */
-			if (get_order(size) < MAX_ORDER)
+			if (get_order(size) < MAX_ORDER) {
 				table = alloc_pages_exact(size, GFP_ATOMIC);
+				kmemleak_alloc(table, size, 1, GFP_ATOMIC);
+			}
 		}
 	} while (!table && size > PAGE_SIZE && --log2qty);
 
@@ -4764,16 +4766,6 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (_hash_mask)
 		*_hash_mask = (1 << log2qty) - 1;
 
-	/*
-	 * If hashdist is set, the table allocation is done with __vmalloc()
-	 * which invokes the kmemleak_alloc() callback. This function may also
-	 * be called before the slab and kmemleak are initialised when
-	 * kmemleak simply buffers the request to be executed later
-	 * (GFP_ATOMIC flag ignored in this case).
-	 */
-	if (!hashdist)
-		kmemleak_alloc(table, size, 1, GFP_ATOMIC);
-
 	return table;
 }
 

