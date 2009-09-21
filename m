Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZIUHp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZIUHp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZIUHpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:45:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38578 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZIUHpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:45:54 -0400
Date: Mon, 21 Sep 2009 09:45:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] perf_counter/powerpc: Fix compilation after
	perf_counter_overflow change
Message-ID: <20090921074538.GA24535@elte.hu>
References: <19127.8400.376239.586120@drongo.ozlabs.ibm.com> <928CFBE8E7CB0040959E56B4EA41A77EC69BA5E0@irsmsx504.ger.corp.intel.com> <20090921073043.GB24467@elte.hu> <20090921073848.GA4649@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921073848.GA4649@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Mon, Sep 21, 2009 at 09:30:43AM +0200, Ingo Molnar wrote:
> > 
> > * Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> > 
> > > >-----Original Message-----
> > > >From: Paul Mackerras [mailto:paulus@samba.org]
> > > >Sent: Monday, September 21, 2009 8:45 AM
> > > 
> > > 
> > > >Markus, please take care in future to mention it in the changelog if
> > > >your patches touch definitions used by other architectures.  If you
> > > >could go so far as to use grep a bit more and fix up other
> > > >architectures' callsites for the things you're changing, that would be
> > > >very much appreciated.  Thanks.
> > > 
> > > I'm sorry I missed that.
> > > 
> > > There's one more place in arch/sparc/.
> > > The below patch should fix it, but I have no means to test it.
> > 
> > You also missed a third thing:
> > 
> > +static inline int
> > +perf_output_begin(struct perf_output_handle *handle, struct perf_counter *c,
> > +                 unsigned int size, int nmi, int sample)               { }
> > 
> > an 'int' function returning void ...
> > 
> > Plus all the !PERF_COUNTERS branch of empty inlines is pointless - these 
> > facilities are used by perfcounters code only. I fixed that too.
> 
> Hi Ingo,
> 
> did you fix all of these warnings for !PERF_COUNTERS?
> 
> include/linux/perf_counter.h: In function 'perf_output_begin':
> include/linux/perf_counter.h:854: warning: no return statement in function returning non-void
> include/linux/perf_counter.h: At top level:
> include/linux/perf_counter.h:863: warning: 'struct perf_sample_data' declared inside parameter list
> include/linux/perf_counter.h:863: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/perf_counter.h:868: warning: 'struct perf_sample_data' declared inside parameter list

Yes. The full commit is below.

	Ingo

---------------->
>From cd74c86bdf705f824d494a2bbda393d1d562b40a Mon Sep 17 00:00:00 2001
From: Paul Mackerras <paulus@samba.org>
Date: Mon, 21 Sep 2009 16:44:32 +1000
Subject: [PATCH] perf_counter, powerpc, sparc: Fix compilation after perf_counter_overflow() change

Commit 5622f295 ("x86, perf_counter, bts: Optimize BTS overflow
handling") removed the regs field from struct perf_sample_data and
added a regs parameter to perf_counter_overflow().  This breaks the
build on powerpc (and Sparc) as reported by Sachin Sant:

  arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
  arch/powerpc/kernel/perf_counter.c:1165: error: unknown field 'regs' specified in initializer

This adjusts arch/powerpc/kernel/perf_counter.c to correspond with the
new struct perf_sample_data and perf_counter_overflow().

[ v2: also fix Sparc, Markus Metzger <markus.t.metzger@intel.com> ]

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Markus Metzger <markus.t.metzger@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <19127.8400.376239.586120@drongo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_counter.c |    3 +--
 arch/sparc/kernel/perf_counter.c   |    3 +--
 include/linux/perf_counter.h       |   17 -----------------
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 7ceefaf..5ccf9bc 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1162,7 +1162,6 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 	 */
 	if (record) {
 		struct perf_sample_data data = {
-			.regs	= regs,
 			.addr	= 0,
 			.period	= counter->hw.last_period,
 		};
@@ -1170,7 +1169,7 @@ static void record_and_restart(struct perf_counter *counter, unsigned long val,
 		if (counter->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
 
-		if (perf_counter_overflow(counter, nmi, &data)) {
+		if (perf_counter_overflow(counter, nmi, &data, regs)) {
 			/*
 			 * Interrupts are coming too fast - throttle them
 			 * by setting the counter to 0, so it will be
diff --git a/arch/sparc/kernel/perf_counter.c b/arch/sparc/kernel/perf_counter.c
index 09de403..b1265ce 100644
--- a/arch/sparc/kernel/perf_counter.c
+++ b/arch/sparc/kernel/perf_counter.c
@@ -493,7 +493,6 @@ static int __kprobes perf_counter_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -513,7 +512,7 @@ static int __kprobes perf_counter_nmi_handler(struct notifier_block *self,
 		if (!sparc_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			sparc_pmu_disable_counter(hwc, idx);
 	}
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index bd34100..740caad 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -849,23 +849,6 @@ static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
 
-static inline int
-perf_output_begin(struct perf_output_handle *handle, struct perf_counter *c,
-		  unsigned int size, int nmi, int sample)		{ }
-static inline void perf_output_end(struct perf_output_handle *handle)	{ }
-static inline void
-perf_output_copy(struct perf_output_handle *handle,
-		 const void *buf, unsigned int len)			{ }
-static inline void
-perf_output_sample(struct perf_output_handle *handle,
-		   struct perf_event_header *header,
-		   struct perf_sample_data *data,
-		   struct perf_counter *counter)			{ }
-static inline void
-perf_prepare_sample(struct perf_event_header *header,
-		    struct perf_sample_data *data,
-		    struct perf_counter *counter,
-		    struct pt_regs *regs)				{ }
 #endif
 
 #define perf_output_put(handle, x) \
