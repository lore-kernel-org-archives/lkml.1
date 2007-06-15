Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbXFOTbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbXFOTbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXFOTbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:31:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbXFOTbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:31:12 -0400
Date: Fri, 15 Jun 2007 21:30:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v17
Message-ID: <20070615193028.GA22187@elte.hu>
References: <20070614224908.GA9412@elte.hu> <20070615132841.5ee01f4d@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615132841.5ee01f4d@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br> wrote:

>  Hmm, I'm getting this while compiling:
> 
> """
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `rq_clock':
> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: undefined reference to `cpu_of'
> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: undefined reference to `cpu_of'

oops :-) That was due to !CONFIG_SMP.

>  Patch follows, only compile tested, hope it helps.

Thanks! I fixed it in a slightly different way: moved the cpu_of() thing 
outside of the #ifdef CONFIG_SMP section, as per the patch below. I've 
updated the -v17 patches with this minimal fix and have verified that 
the !CONFIG_SMP kernel boots and works fine.

	Ingo

--------------->
Index: linux-cfs-2.6.22-rc4.q/kernel/sched.c
===================================================================
--- linux-cfs-2.6.22-rc4.q.orig/kernel/sched.c
+++ linux-cfs-2.6.22-rc4.q/kernel/sched.c
@@ -248,6 +249,15 @@ static unsigned int static_prio_timeslic
 		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
 }
 
+static inline int cpu_of(struct rq *rq)
+{
+#ifdef CONFIG_SMP
+	return rq->cpu;
+#else
+	return 0;
+#endif
+}
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -258,15 +268,6 @@ static inline u32 sg_div_cpu_power(const
 	return reciprocal_divide(load, sg->reciprocal_cpu_power);
 }
 
-static inline int cpu_of(struct rq *rq)
-{
-#ifdef CONFIG_SMP
-	return rq->cpu;
-#else
-	return 0;
-#endif
-}
-
 /*
  * Each time a sched group cpu_power is changed,
  * we must compute its reciprocal value
