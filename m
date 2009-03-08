Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbZCHKdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbZCHKdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZCHKdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:33:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZCHKdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:33:12 -0400
Subject: Re: [git-pull -tip] x86:perf_counter cleanup
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236507232.28127.2.camel@localhost.localdomain>
References: <1236507232.28127.2.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 08 Mar 2009 11:32:39 +0100
Message-Id: <1236508359.22914.3643.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 15:43 +0530, Jaswinder Singh Rajput wrote:
>  
>  static struct pmc_x86_ops *pmc_amd_init(void)
>  {
> -       u64 old;
> -       int bits;
> -
>         nr_counters_generic = 4;
>         nr_counters_fixed = 0;
>         counter_value_mask = 0x0000FFFFFFFFFFFFULL;



I would rather we try something like the below:

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f585371..ccb4f79 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -957,12 +957,39 @@ static struct pmc_x86_ops *pmc_amd_init(void)
 	u64 old;
 	int bits;
 
+	pr_info("AMD Performance Monitoring support detected.\n");
+
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
-	counter_value_mask = 0x0000FFFFFFFFFFFFULL;
-	counter_value_bits = 48;
+	counter_value_mask = ~0ULL;
 
-	pr_info("AMD Performance Monitoring support detected.\n");
+	rdmsrl(MSR_K7_PERFCTR0, old);
+	wrmsrl(MSR_K7_PERFCTR0, counter_value_mask);
+
+	/*
+	 * Ensure the counter_value_mask write, is completed before
+	 * we try to read it back.
+	 */ 
+	mb();
+
+	/* read the truncated mask */
+	rdmsrl(MSR_K7_PERFCTR0, counter_value_mask);
+	wrmsrl(MSR_K7_PERFCTR0, old);
+
+	bits = 32 + fls(counter_value_mask >> 32);
+	if (bits == 32)
+		bits = fls((u32)counter_value_mask);
+	counter_value_bits = bits;
+
+	if (counter_value_bits != 48 ||
+	    counter_value_mask != ((1ULL << counter_value_bits) - 1)) {
+		printk(KERN_ERR "Bad cpu! speculated through full memory barrier!\n");
+		printk(KERN_ERR " ... old value: %llx\n", old);
+		printk(KERN_ERR " ... new value: %llx\n", counter_value_mask);
+
+		counter_value_bits = 48;
+		counter_value_mask = 0x0000FFFFFFFFFFFFULL;
+	}
 
 	return &pmc_amd_ops;
 }

