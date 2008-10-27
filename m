Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYJ0NCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYJ0NCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYJ0NCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:02:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34239 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYJ0NCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:02:40 -0400
Date: Mon, 27 Oct 2008 14:02:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of
	call_function_data
Message-ID: <20081027130225.GA25323@elte.hu>
References: <49015358.9050308@ct.jp.nec.com> <200810242215.19440.rusty@rustcorp.com.au> <20081027125512.GD12461@elte.hu> <20081027125904.GA24347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027125904.GA24347@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > If there's any chance for this in v2.6.28 then only if we disable 
> > the dynamic API branch altogether [CONFIG_MAXCPUS] and keep that 
> > for v2.6.29. This means we'd bring in the API changes which should 
> > have trivial impact only - and none of the riskier changes.
> 
> in any case, i've started testing tip/cpus4096-v2 again on x86 - the 
> problem with d4de5a above was the only outstanding known issue, 
> right?

plus there are also the fixlets below.

	Ingo

-------------->
>From a14b735fb7a82bb6561449dda4067365af7ee95c Mon Sep 17 00:00:00 2001
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 23 Oct 2008 14:35:31 -0700
Subject: [PATCH] cpumask: fixlets

[ from Mike ]

Here are the only changes I could find from Rusty's last patches that
apply to tip/cpus4096-v2.

* Fix NR_CPUS reference in arch/powerpc/platforms/cell/spu_base.c

* modify arch/x86/Kconfig so CONFIG_NR_CPUS is always defined.  Also it
  does not prompt if MAXSMP is set.

* change include/linux/threads.h so CONFIG_NR_CPUS is defined for those
  arch's that do not define it.

Signed-of-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-of-by: Mike Travis <travis@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/platforms/cell/spu_base.c |    9 ++++++---
 arch/x86/Kconfig                       |    2 +-
 include/linux/threads.h                |   16 ++++++++--------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index a5bdb89..a876904 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -111,10 +111,13 @@ void spu_flush_all_slbs(struct mm_struct *mm)
  */
 static inline void mm_needs_global_tlbie(struct mm_struct *mm)
 {
-	int nr = (NR_CPUS > 1) ? NR_CPUS : NR_CPUS + 1;
-
 	/* Global TLBIE broadcast required with SPEs. */
-	__cpus_setall(&mm->cpu_vm_mask, nr);
+	if (NR_CPUS > 1)
+		cpumask_setall(&mm->cpu_vm_mask);
+	else {
+		cpumask_set_cpu(0, &mm->cpu_vm_mask);
+		cpumask_set_cpu(1, &mm->cpu_vm_mask);
+	}
 }
 
 void spu_associate_mm(struct spu *spu, struct mm_struct *mm)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d574cd6..a901f59 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -585,9 +585,9 @@ config MAXSMP
 	  If unsure, say N.
 
 config NR_CPUS
-	depends on SMP
  	int "Maximum number of CPUs" if SMP && !MAXSMP
  	range 2 512 if SMP && !MAXSMP
+	default "1" if !SMP
 	default "4096" if MAXSMP
  	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
 	default "8"
diff --git a/include/linux/threads.h b/include/linux/threads.h
index 38d1a5d..052b12b 100644
--- a/include/linux/threads.h
+++ b/include/linux/threads.h
@@ -8,17 +8,17 @@
  */
 
 /*
- * Maximum supported processors that can run under SMP.  This value is
- * set via configure setting.  The maximum is equal to the size of the
- * bitmasks used on that platform, i.e. 32 or 64.  Setting this smaller
- * saves quite a bit of memory.
+ * Maximum supported processors.  Setting this smaller saves quite a
+ * bit of memory.  Use nr_cpu_ids instead of this except for static bitmaps.
  */
-#ifdef CONFIG_SMP
-#define NR_CPUS		CONFIG_NR_CPUS
-#else
-#define NR_CPUS		1
+#ifndef CONFIG_NR_CPUS
+/* FIXME: This should be fixed in the arch's Kconfig */
+#define CONFIG_NR_CPUS	1
 #endif
 
+/* Places which use this should consider cpumask_var_t. */
+#define NR_CPUS		CONFIG_NR_CPUS
+
 #define MIN_THREADS_LEFT_FOR_ROOT 4
 
 /*
