Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXFOTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXFOTem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXFOTef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:34:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40550 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbXFOTee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:34:34 -0400
Date: Fri, 15 Jun 2007 21:33:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton@gmail.com>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v17
Message-ID: <20070615193356.GA24881@elte.hu>
References: <20070614224908.GA9412@elte.hu> <20070615132841.5ee01f4d@localhost> <200706151947.14266.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706151947.14266.mboton@gmail.com>
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


* Miguel Botón <mboton@gmail.com> wrote:

> I patched kernel 2.6.21.5 with CFS v17 and I didn't experience this 
> problem (I checked that piece of code and I didn't see something 
> wrong). Looks like it only appears in kernel 2.6.22-rc4.

yeah - it affected the .22 patches, the .21 and .20 patches compiled and 
worked under !CONFIG_SMP too. I updated the .22 patches with the fix 
below.

	Ingo

-------------->
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
