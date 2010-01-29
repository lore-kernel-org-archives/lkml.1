Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575Ab0A2LEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0A2LEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 06:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551Ab0A2LEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 06:04:13 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab0A2LEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 06:04:12 -0500
Subject: Re: [tip:perf/core] bitops: Provide compile time
 HWEIGHT{8,16,32,64}
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100129020128.716af8fb.akpm@linux-foundation.org>
References: <20100122155535.797688466@chello.nl>
	 <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
	 <20100129020128.716af8fb.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 12:03:43 +0100
Message-ID: <1264763023.4283.2213.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 02:01 -0800, Andrew Morton wrote:
> On Fri, 29 Jan 2010 09:28:04 GMT tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > +#define HWEIGHT8(w)			\
> > +      (	(!!((w) & (1ULL << 0))) +	\
> > +	(!!((w) & (1ULL << 1))) +	\
> > +	(!!((w) & (1ULL << 2))) +	\
> > +	(!!((w) & (1ULL << 3))) +	\
> > +	(!!((w) & (1ULL << 4))) +	\
> > +	(!!((w) & (1ULL << 5))) +	\
> > +	(!!((w) & (1ULL << 6))) +	\
> > +	(!!((w) & (1ULL << 7)))	)
> > +
> > +#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
> > +#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
> > +#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
> 
> Would be nice if it had a comment explaining why it exists.  If people
> accidentally use this with non-constant arguments, the generated code
> will be pretty ghastly.

*sigh* and here I though it being placed right next to hweight_long()
which uses the arch hweightN() would be clue enough.

If people are so clueless, who says they'll read a comment.. but sure I
guess I can add one.

> Or add some barf-if-not-__constant_p() thing, perhaps.

I've actually sneaked one non-constant usage in, but since its in an
init path I didn't care to fix that, but I guess here goes:

---
Subject: bitops: Dummyify the compile-time hweight versions

Because it seems allowed to not think and write kernel code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -93,13 +93,16 @@ struct cpu_hw_events {
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
-#define EVENT_CONSTRAINT(c, n, m) {	\
+#define __EVENT_CONSTRAINT(c, n, m, w) {\
 	{ .idxmsk64[0] = (n) },		\
 	.code = (c),			\
 	.cmask = (m),			\
-	.weight = HWEIGHT64((u64)(n)),	\
+	.weight = (w),			\
 }
 
+#define EVENT_CONSTRAINT(c, n, m)	\
+	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
+
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVTSEL_MASK)
 
@@ -2646,7 +2649,8 @@ void __init init_hw_perf_events(void)
 	register_die_notifier(&perf_event_nmi_notifier);
 
 	unconstrained = (struct event_constraint)
-		EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1, 0);
+		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1, 
+				   0, x86_pmu.num_events);
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -45,19 +45,29 @@ static inline unsigned long hweight_long
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-#define HWEIGHT8(w)			\
-      (	(!!((w) & (1ULL << 0))) +	\
-	(!!((w) & (1ULL << 1))) +	\
-	(!!((w) & (1ULL << 2))) +	\
-	(!!((w) & (1ULL << 3))) +	\
-	(!!((w) & (1ULL << 4))) +	\
-	(!!((w) & (1ULL << 5))) +	\
-	(!!((w) & (1ULL << 6))) +	\
+/*
+ * Clearly slow versions of the hweightN() functions, their benefit is
+ * of course compile time evaluation of constant arguments.
+ */
+#define HWEIGHT8(w)					\
+      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
+	(!!((w) & (1ULL << 0))) +			\
+	(!!((w) & (1ULL << 1))) +			\
+	(!!((w) & (1ULL << 2))) +			\
+	(!!((w) & (1ULL << 3))) +			\
+	(!!((w) & (1ULL << 4))) +			\
+	(!!((w) & (1ULL << 5))) +			\
+	(!!((w) & (1ULL << 6))) +			\
 	(!!((w) & (1ULL << 7)))	)
 
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
+#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
+#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
+#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
+
+/*
+ * For us lazy bastards
+ */
+#define HWEIGHT(w)   HWEIGHT64((u64)(w))
 
 /**
  * rol32 - rotate a 32-bit value left


