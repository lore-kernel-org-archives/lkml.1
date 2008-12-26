Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbYLZSTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbYLZSTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYLZSSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:18:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57947 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYLZSSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:18:53 -0500
Date: Fri, 26 Dec 2008 19:17:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Yinghai Lu <yinghai@kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081226181733.GA24439@elte.hu>
References: <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226152804.GB5100@linux.vnet.ibm.com> <20081226153318.GA4514@elte.hu> <20081226170452.GC5100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081226170452.GC5100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> > how about the patch below, does that work too? (after removing 
> > Yinghai's patch)
> 
> Hi Ingo,
> 
> 	Kernel crashes with the same trace, after the applying the patch.

okay, thanks - does the below cleaner variant of Yinghai's patch solve the 
problem too?

	Ingo

-------------------->
>From 9c93fc72ec95dc97d65b840978f9d605f4e5823a Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Fri, 26 Dec 2008 02:05:47 -0800
Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions

Impact: fix panic on null pointer with sparseirq

Some GCC versions seem to inline the weak global function,
when that function is empty.

Work it around, by putting a barrier into the function.

Signed-off-by: Yinghai <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c         |    9 +++++++++
 kernel/irq/handle.c |    3 ++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index c1f999a..841d2b2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -531,20 +531,29 @@ static void __init boot_cpu_init(void)
 	cpu_set(cpu, cpu_possible_map);
 }
 
+/*
+ * The barriers are needed to keep a GCC bug from optimizing
+ * away these weak functions:
+ */
+
 void __init __weak smp_setup_processor_id(void)
 {
+	barrier();
 }
 
 void __init __weak thread_info_cache_init(void)
 {
+	barrier();
 }
 
 void __init __weak arch_early_irq_init(void)
 {
+	barrier();
 }
 
 void __init __weak early_irq_init(void)
 {
+	barrier();
 	arch_early_irq_init();
 }
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 06b05a4..a6d16a4 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -86,8 +86,9 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
-void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
+void __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
+	barrier();
 }
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
