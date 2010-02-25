Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab0BYCiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:38:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:40287 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758809Ab0BYCiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:38:50 -0500
Message-ID: <4B85E245.5030001@kernel.org>
Date: Wed, 24 Feb 2010 18:36:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] early_res: add free_early_partial
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	 <1265793639-15071-17-git-send-email-yinghai@kernel.org>	 <20100215010833.15f9e09a.sfr@canb.auug.org.au>	 <4B7B4378.1070206@kernel.org> <1267052387.12790.10.camel@laptop> <4B85B65E.503@kernel.org> <4B85B724.9050304@kernel.org> <4B85DB79.4010708@kernel.org>
In-Reply-To: <4B85DB79.4010708@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



to free partial for pcpu_setup...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup_percpu.c |    6 ++++
 include/linux/early_res.h      |    1 
 kernel/early_res.c             |   55 +++++++++++++++++++++++++++++++++++++++++
 mm/percpu.c                    |    3 --
 4 files changed, 62 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -137,7 +137,13 @@ static void * __init pcpu_fc_alloc(unsig
 
 static void __init pcpu_fc_free(void *ptr, size_t size)
 {
+#ifdef CONFIG_NO_BOOTMEM
+	u64 start = __pa(ptr);
+	u64 end = start + size;
+	free_early_partial(start, end);
+#else
 	free_bootmem(__pa(ptr), size);
+#endif
 }
 
 static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
Index: linux-2.6/include/linux/early_res.h
===================================================================
--- linux-2.6.orig/include/linux/early_res.h
+++ linux-2.6/include/linux/early_res.h
@@ -5,6 +5,7 @@
 extern void reserve_early(u64 start, u64 end, char *name);
 extern void reserve_early_overlap_ok(u64 start, u64 end, char *name);
 extern void free_early(u64 start, u64 end);
+void free_early_partial(u64 start, u64 end);
 extern void early_res_to_bootmem(u64 start, u64 end);
 
 void reserve_early_without_check(u64 start, u64 end, char *name);
Index: linux-2.6/kernel/early_res.c
===================================================================
--- linux-2.6.orig/kernel/early_res.c
+++ linux-2.6/kernel/early_res.c
@@ -61,6 +61,40 @@ static void __init drop_range(int i)
 	early_res_count--;
 }
 
+static void __init drop_range_partial(int i, u64 start, u64 end)
+{
+	u64 common_start, common_end;
+	u64 old_start, old_end;
+
+	old_start = early_res[i].start;
+	old_end = early_res[i].end;
+	common_start = max(old_start, start);
+	common_end = min(old_end, end);
+
+	/* no overlap ? */
+	if (common_start >= common_end)
+		return;
+
+	if (old_start < common_start) {
+		/* make head segment */
+		early_res[i].end = common_start;
+		if (old_end > common_end) {
+			/* add another for left over on tail */
+			reserve_early_without_check(common_end, old_end,
+					 early_res[i].name);
+		}
+		return;
+	} else {
+		if (old_end > common_end) {
+			/* reuse the entry for tail left */
+			early_res[i].start = common_end;
+			return;
+		}
+		/* all covered */
+		drop_range(i);
+	}
+}
+
 /*
  * Split any existing ranges that:
  *  1) are marked 'overlap_ok', and
@@ -284,6 +318,27 @@ void __init free_early(u64 start, u64 en
 	drop_range(i);
 }
 
+void __init free_early_partial(u64 start, u64 end)
+{
+	struct early_res *r;
+	int i;
+
+try_next:
+	i = find_overlapped_early(start, end);
+	if (i >= max_early_res)
+		return;
+
+	r = &early_res[i];
+	/* hole ? */
+	if (r->end >= end && r->start <= start) {
+		drop_range_partial(i, start, end);
+		return;
+	}
+
+	drop_range_partial(i, start, end);
+	goto try_next;
+}
+
 #ifdef CONFIG_NO_BOOTMEM
 static void __init subtract_early_res(struct range *range, int az)
 {
Index: linux-2.6/mm/percpu.c
===================================================================
--- linux-2.6.orig/mm/percpu.c
+++ linux-2.6/mm/percpu.c
@@ -1929,10 +1929,7 @@ int __init pcpu_embed_first_chunk(size_t
 			}
 			/* copy and return the unused part */
 			memcpy(ptr, __per_cpu_load, ai->static_size);
-#ifndef CONFIG_NO_BOOTMEM
-			/* fix partial free ! */
 			free_fn(ptr + size_sum, ai->unit_size - size_sum);
-#endif
 		}
 	}
 
