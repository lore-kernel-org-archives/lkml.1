Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYANI15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYANI15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYANI1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:27:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:50930 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751381AbYANI1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:27:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+rchVx36irjrFVaCECXMxwmcQVt0hjkrn5ZsQ6fz
	wc5TjZpOlq9R0Z
Subject: Re: 2.6.24-rc7-rt1
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com>
References: <1200250801.9190.7.camel@localhost.localdomain>
	 <200801132143.34889.m.kozlowski@tuxland.pl>
	 <Pine.LNX.4.58.0801131552350.10093@gandalf.stny.rr.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 14 Jan 2008 09:27:40 +0100
Message-Id: <1200299260.4665.17.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-13 at 15:54 -0500, Steven Rostedt wrote:

> OK, -rt2 will take a bit more beating from me before I release it, so it
> might take some time to get it out (expect it out on Monday).

Ah, that reminds me (tests, yup) I still need the patchlet below to
resume from ram without black screen of death.  No idea why my P4 box
seems to be the only box in the rt galaxy affected.  (haven't poked at
it since the holidays)

Index: linux-2.6.24.git-rt1/kernel/sched_rt.c
===================================================================
--- linux-2.6.24.git-rt1.orig/kernel/sched_rt.c
+++ linux-2.6.24.git-rt1/kernel/sched_rt.c
@@ -33,6 +33,9 @@ static inline void rt_clear_overload(str
 
 static void update_rt_migration(struct rq *rq)
 {
+	if (unlikely(num_online_cpus() == 1))
+		return;
+
 	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1)) {
 		if (!rq->rt.overloaded) {
 			rt_set_overload(rq);
@@ -105,8 +108,10 @@ static inline void dec_rt_tasks(struct t
 		} /* otherwise leave rq->highest prio alone */
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
-	if (p->nr_cpus_allowed > 1)
+	if (p->nr_cpus_allowed > 1) {
+		BUG_ON(!rq->rt.rt_nr_migratory);
 		rq->rt.rt_nr_migratory--;
+	}
 
 	if (rq->rt.highest_prio != highest_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);


btw, CONFIG_INTEL_IOATDMA compile booboo

  CC      drivers/dma/ioat_dma.o
drivers/dma/ioat_dma.c: In function ‘ioat1_tx_submit’:
drivers/dma/ioat_dma.c:300: error: too few arguments to function ‘__list_splice’
make[2]: *** [drivers/dma/ioat_dma.o] Error 1


