Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZCRMNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZCRMNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbZCRMNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:13:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56485 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbZCRMNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:13:08 -0400
Date: Wed, 18 Mar 2009 13:12:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perfcounters: abstract wakeup flag setting in core to
	fix powerpc build
Message-ID: <20090318121246.GA4587@elte.hu>
References: <18878.10058.953388.356531@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18878.10058.953388.356531@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Impact: build fix for powerpc
> 
> Commit bd753921015e7905 ("perf_counter: software counter event
> infrastructure") introduced a use of TIF_PERF_COUNTERS into the core
> perfcounter code.  This breaks the build on powerpc because we use
> a flag in a per-cpu area to signal wakeups on powerpc rather than
> a thread_info flag, because the thread_info flags have to be
> manipulated with atomic operations and are thus slower than per-cpu
> flags.
> 
> This fixes the by changing the core to use an abstracted
> set_perf_counter_pending() function, which is defined on x86 to set
> the TIF_PERF_COUNTERS flag and on powerpc to set the per-cpu flag
> (paca->perf_counter_pending).  It changes the previous powerpc
> definition of set_perf_counter_pending to not take an argument and
> adds a clear_perf_counter_pending, so as to simplify the definition
> on x86.
> 
> On x86, set_perf_counter_pending() is defined as a macro.  Defining
> it as a static inline in arch/x86/include/asm/perf_counters.h causes
> compile failures because <asm/perf_counters.h> gets included early in
> <linux/sched.h>, and the definitions of set_tsk_thread_flag etc. are
> therefore not available in <asm/perf_counters.h>.  (On powerpc this
> problem is avoided by defining set_perf_counter_pending etc. in
> <asm/hw_irq.h>.)
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> This is in the master branch of my perfcounters.git repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master
> 
>  arch/powerpc/include/asm/hw_irq.h   |   14 +++++++++++---
>  arch/powerpc/kernel/irq.c           |   11 +++--------
>  arch/powerpc/kernel/perf_counter.c  |    3 +--
>  arch/x86/include/asm/perf_counter.h |    3 +++
>  kernel/perf_counter.c               |    2 +-
>  5 files changed, 19 insertions(+), 14 deletions(-)

Pulled, thanks Paul!

	Ingo
