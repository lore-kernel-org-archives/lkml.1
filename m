Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZGUK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZGUK2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZGUK2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:37048 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbZGUK2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:00 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/20] percpu: add @align to pcpu_fc_alloc_fn_t
Date: Tue, 21 Jul 2009 19:26:07 +0900
Message-Id: <1248171979-29166-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_fc_alloc_fn_t is about to see more interesting usage, add @align
parameter.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |    4 ++--
 include/linux/percpu.h         |    3 ++-
 mm/percpu.c                    |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index b0e7ac4..7cc5303 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -126,9 +126,9 @@ static void * __init pcpu_alloc_bootmem(unsigned int cpu, unsigned long size,
 /*
  * Helpers for first chunk memory allocation
  */
-static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size)
+static void * __init pcpu_fc_alloc(unsigned int cpu, size_t size, size_t align)
 {
-	return pcpu_alloc_bootmem(cpu, size, size);
+	return pcpu_alloc_bootmem(cpu, size, align);
 }
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 0cfdd14..d385dbc 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -71,7 +71,8 @@ extern const char *pcpu_fc_names[PCPU_FC_NR];
 
 extern enum pcpu_fc pcpu_chosen_fc;
 
-typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size);
+typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size,
+				     size_t align);
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
diff --git a/mm/percpu.c b/mm/percpu.c
index 3177cf6..cfdc03e 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1578,7 +1578,7 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 		for (i = 0; i < unit_pages; i++) {
 			void *ptr;
 
-			ptr = alloc_fn(cpu, PAGE_SIZE);
+			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
 			if (!ptr) {
 				pr_warning("PERCPU: failed to allocate %s page "
 					   "for cpu%u\n", psize_str, cpu);
@@ -1888,7 +1888,7 @@ ssize_t __init pcpu_lpage_first_chunk(size_t reserved_size, size_t dyn_size,
 				goto found;
 		continue;
 	found:
-		ptr = alloc_fn(cpu, lpage_size);
+		ptr = alloc_fn(cpu, lpage_size, lpage_size);
 		if (!ptr) {
 			pr_warning("PERCPU: failed to allocate large page "
 				   "for cpu%u\n", cpu);
-- 
1.6.0.2

