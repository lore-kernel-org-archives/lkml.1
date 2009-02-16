Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZBPM06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZBPM06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZBPM0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:26:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36048 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZBPM0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:26:48 -0500
Date: Mon, 16 Feb 2009 13:26:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216122632.GA3158@elte.hu>
References: <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu> <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu> <20090216084223.GA2641@localhost.localdomain> <20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hc2u61e9.fsf@free.fr>
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


* Damien Wyart <damien.wyart@free.fr> wrote:

> * Ingo Molnar <mingo@elte.hu> [090216 10:50]:
> > hm, we need a trace with both abstime and process information included:
> 
> >   echo funcgraph-proc     > trace_options
> >   echo funcgraph-abstime  > trace_options
> 
> > Also, at 140 msecs the duration is a bit short - could you please make a 
> > 1-2 seconds capture? You can do that by increasing the number in 
> > buffer_size_kb 10-fold:
> 
> >    echo 14100 > buffer_size_kb 
> 
> Ok, I've redone a trace with these options enabled. The file is here:
> http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_ksoftirqd_pb_abstime_proc.txt.gz

ok, here's the new annotated trace:

  799.555279 |   1)  ksoftir-2324  |               |  do_softirq() {
  799.555279 |   1)  ksoftir-2324  |               |    __do_softirq() {
  799.555280 |   1)  ksoftir-2324  |               |      /* #1 softirq pending: 00000100 */
  799.555281 |   1)  ksoftir-2324  |               |      /* #2 softirq pending: 00000000 */
  799.555282 |   1)  ksoftir-2324  |               |      rcu_process_callbacks() {
  799.555282 |   1)  ksoftir-2324  |               |        __rcu_process_callbacks() {
  799.555283 |   1)  ksoftir-2324  |   0.479 us    |          force_quiescent_state();
  799.555284 |   1)  ksoftir-2324  |   1.576 us    |        }
  799.555284 |   1)  ksoftir-2324  |               |        __rcu_process_callbacks() {
  799.555285 |   1)  ksoftir-2324  |               |          force_quiescent_state() {
  799.555286 |   1)  ksoftir-2324  |               |          cpu_quiet() {
  799.555286 |   1)  ksoftir-2324  |   0.518 us    |            _spin_lock_irqsave();
  799.555287 |   1)  ksoftir-2324  |   0.506 us    |            _spin_unlock_irqrestore();
  799.555288 |   1)  ksoftir-2324  |   2.563 us    |          }
  799.555289 |   1)  ksoftir-2324  |   4.624 us    |        }
  799.555289 |   1)  ksoftir-2324  |   7.836 us    |      }
  799.555290 |   1)  ksoftir-2324  |   0.495 us    |      _local_bh_enable();
  799.555291 |   1)  ksoftir-2324  | + 11.550 us   |    }
  799.555291 |   1)  ksoftir-2324  | + 12.713 us   |  }
  799.555292 |   1)  ksoftir-2324  |   0.524 us    |  _cond_resched();

We do get 0x100 which is 1 << RCU_SOFTIRQ, i.e. the RCU softirq. Paul, 
this indeed seems to be a CONFIG_TREE_RCU=y bug.

What is weird is that RCU_SOFTIRQ gets set again and again - but there's 
no raise_softirq() calls. Could you please do a two-CPU trace too via:

   echo 3 > /debug/tracing/tracing_cpumask

So that we can see what's happening on the other CPU?

Also, could you please apply the debug patch below (or update to the 
very latest -tip tree), so that we get trace entries of softirq triggers 
too?

Thanks,

	Ingo

-------------->

>From 6876d5d56716427f9bbe3af7e4e9c06cb760ae0c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 16 Feb 2009 13:23:36 +0100
Subject: [PATCH] softirq: debug #2

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/interrupt.h |    3 ++-
 kernel/softirq.c          |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e7bcfd7..cc1f529 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -271,7 +271,8 @@ asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
-#define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
+#define ___raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
+extern void __raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 110cad0..431cb4f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -302,6 +302,13 @@ void irq_exit(void)
 	preempt_enable_no_resched();
 }
 
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	ftrace_printk("nr: %d\n", nr);
+	or_softirq_pending(1UL << nr);
+}
+EXPORT_SYMBOL_GPL(__raise_softirq_irqoff);
+
 /*
  * This function must run with irqs disabled!
  */
