Return-Path: <linux-kernel-owner+w=401wt.eu-S1764169AbZD3ONj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764169AbZD3ONj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764134AbZD3OMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:12:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763377AbZD3OMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:12:47 -0400
Date: Thu, 30 Apr 2009 16:10:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Andrew Morton <akpm@linux-foundation.org>, thomas.pi@arcor.dea,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430141050.GC14696@elte.hu>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904300926530.22262@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> > > I see however that it's only guaranteed to be atomic wrt preemption.
> >
> > That's really only true for the non-x86 fallback defines. If we so
> > decide, we could make the fallbacks in asm-generic/percpu.h irq-safe
> 
> The fallbacks have different semantics and therefore we cannot 
> rely on irq safeness in the core code when using the x86 cpu ops.

Well it's irq and preempt safe on x86.

It's preempt-safe on other architectures - but the fallback is not 
irq-safe on other architectures. That is remedied easily via the 
patch below. (Note: totally untested)

	Ingo

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1581ff2..6b3984a 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -139,17 +139,23 @@ static inline void free_percpu(void *p)
 #ifndef percpu_read
 # define percpu_read(var)						\
   ({									\
+	unsigned long flags;						\
 	typeof(per_cpu_var(var)) __tmp_var__;				\
-	__tmp_var__ = get_cpu_var(var);					\
-	put_cpu_var(var);						\
+									\
+	local_irq_save(flags);						\
+	__tmp_var__ = __get_cpu_var(var);				\
+	local_irq_restore(flags);					\
 	__tmp_var__;							\
   })
 #endif
 
 #define __percpu_generic_to_op(var, val, op)				\
 do {									\
-	get_cpu_var(var) op val;					\
-	put_cpu_var(var);						\
+	unsigned long flags;						\
+									\
+	local_irq_save(flags);						\
+	op val;								\
+	local_irq_restore(flags);					\
 } while (0)
 
 #ifndef percpu_write
