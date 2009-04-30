Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbZD3OQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbZD3OQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbZD3OQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:16:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758612AbZD3OQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:16:46 -0400
Date: Thu, 30 Apr 2009 16:14:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430141446.GD14696@elte.hu>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904300938220.22262@qirst.com>
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
> > it's all done, implemented and upstream already. You are a bit late
> > to the party ;-)
> 
> Just looked over it. Yep, now we just need to fix the things that 
> were messed up.

Could we please skip over the lengthy flamewar and bad-mouthing of 
other people's work and go straight to the constructive portion of 
the discussion? ;-)

The patch below makes the fallback/slowpath irq safe.

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
