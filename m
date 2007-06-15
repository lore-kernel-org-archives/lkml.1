Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXFOQbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXFOQbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXFOQa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:30:56 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:43362 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbXFOQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:30:55 -0400
Date: Fri, 15 Jun 2007 13:28:41 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v17
Message-ID: <20070615132841.5ee01f4d@localhost>
In-Reply-To: <20070614224908.GA9412@elte.hu>
References: <20070614224908.GA9412@elte.hu>
Organization: Mandriva
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.11; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 15 Jun 2007 00:49:08 +0200
Ingo Molnar <mingo@elte.hu> escreveu:

| 
| i'm pleased to announce release -v17 of the CFS scheduler patchset.
|  
| The rolled-up CFS patch against v2.6.22-rc4, v2.6.22-rc4-mm2, v2.6.21.5 
| or v2.6.20.13 can be downloaded from the usual place:
| 
|    http://people.redhat.com/mingo/cfs-scheduler/

 Hmm, I'm getting this while compiling:

"""
  LD      .tmp_vmlinux1
kernel/built-in.o: In function `rq_clock':
/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: undefined reference to `cpu_of'
/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: undefined reference to `cpu_of'
/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: undefined reference to `cpu_of'
/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: undefined reference to `cpu_of'
/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: undefined reference to `cpu_of'
kernel/built-in.o:/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321: more undefined references to `cpu_of' follow
make: *** [.tmp_vmlinux1] Error 1
"""

 The code in question is really strange:

#ifdef CONFIG_SMP
...
static inline int cpu_of(struct rq *rq)
#ifdef CONFIG_SMP
	return rq->cpu;
#else
	return 0;
#endif
}
...
#endif

 Patch follows, only compile tested, hope it helps.

------

[PATCH]: Fix undefined reference to `cpu_of'
    
cpu_of() is defined inside a CONFIG_SMP #ifdef/#endif but called
by !CONFIG_SMP code.

This patch fixes that by creating a !CONFIG_SMP version of cpu_of().

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

diff --git a/kernel/sched.c b/kernel/sched.c
index abe6fab..be63f73 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -259,13 +259,9 @@ static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
 	return reciprocal_divide(load, sg->reciprocal_cpu_power);
 }
 
-static inline int cpu_of(struct rq *rq)
+static inline int cpu_of(const struct rq *rq)
 {
-#ifdef CONFIG_SMP
 	return rq->cpu;
-#else
-	return 0;
-#endif
 }
 
 /*
@@ -277,7 +273,13 @@ static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
 	sg->__cpu_power += val;
 	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
 }
-#endif
+#else /* !CONFIG_SMP */
+static inline int cpu_of(const struct rq *rq)
+{
+	return 0;
+}
+#endif /* CONFIG_SMP */
+
 /*
  * Per-runqueue clock, as finegrained as the platform can give us:
  */


-- 
Luiz Fernando N. Capitulino
