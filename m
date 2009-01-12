Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZALJ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZALJ2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZALJ1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:27:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZALJ1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:27:48 -0500
Date: Mon, 12 Jan 2009 10:27:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Travis <travis@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: include apicnum.h in acpidef.h
Message-ID: <20090112092735.GB1822@elte.hu>
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112092613.GA1822@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> like:
> 
> In file included from /home/mingo/tip/arch/x86/include/asm/i387.h:16,
>                  from 
> /home/mingo/tip/arch/x86/include/asm/suspend_32.h:10,
>                  from /home/mingo/tip/arch/x86/include/asm/suspend.h:2,
>                  from include/linux/suspend.h:5,
>                  from arch/x86/kernel/asm-offsets_32.c:11,
>                  from arch/x86/kernel/asm-offsets.c:2:
> include/linux/hardirq.h:41:27: error:  ':' without preceding '?'
> In file included from arch/x86/kernel/asm-offsets_32.c:24,
>                  from arch/x86/kernel/asm-offsets.c:2:
> include/linux/lguest.h:60:1: error: unterminated argument list invoking 
> macro "BITS_TO_LONGS"
> In file included from arch/x86/kernel/asm-offsets_32.c:25,
>                  from arch/x86/kernel/asm-offsets.c:2:
> arch/x86/kernel/../../../drivers/lguest/lg.h:236:1: error: unterminated 
> argument list invoking macro "BITS_TO_LONGS"
> 
> so i've reverted it again. config attached.

(Below are the two commits that i reverted - please reuse the improved 
changelogs when resubmitting it.)

	Ingo

----------->
>From af95e2305842d3192ab782abb8ceedc1a2b82d39 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Sun, 11 Jan 2009 21:42:13 -0800
Subject: [PATCH] x86: include apicnum.h in acpidef.h

Impact: clean up

MAX_IO_APICS and MAX_LOCAL_APIC is already defined in apicnum.h, no
need to duplicate it in apicdef.h.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apicdef.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 63134e3..85b50a0 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -132,12 +132,7 @@
 #define APIC_BASE_MSR	0x800
 #define X2APIC_ENABLE	(1UL << 10)
 
-#ifdef CONFIG_X86_32
-# define MAX_IO_APICS 64
-#else
-# define MAX_IO_APICS 128
-# define MAX_LOCAL_APIC 32768
-#endif
+#include <asm/apicnum.h>
 
 /*
  * All x86-64 systems are xAPIC compatible.

>From adf320a657d774d8bdf58b8ffc81670238824c9c Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Sun, 11 Jan 2009 21:43:49 -0800
Subject: [PATCH] x86: use nr_cpus in max_nr_irqs()

Impact: save RAM with large NR_CPUS, get smaller nr_irqs

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 602361a..5b285ca 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -117,8 +117,8 @@
 
 /* defined as a macro so nr_irqs = max_nr_irqs(nr_cpu_ids) can be used */
 # define max_nr_irqs(nr_cpus)				\
-	((8 * nr_cpus) > (32 * MAX_IO_APICS) ?		\
-		(NR_VECTORS + (8 * NR_CPUS)) :		\
+	((8 * (nr_cpus)) > (32 * MAX_IO_APICS) ?		\
+		(NR_VECTORS + (8 * (nr_cpus)) :		\
 		(NR_VECTORS + (32 * MAX_IO_APICS)))	\
 
 # define NR_IRQS max_nr_irqs(NR_CPUS)
