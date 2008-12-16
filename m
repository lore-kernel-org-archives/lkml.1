Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYLPLUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYLPLUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYLPLUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:20:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYLPLUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:20:34 -0500
Date: Tue, 16 Dec 2008 12:20:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
Subject: Re: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class
	in CONFIG_LOCKDEP
Message-ID: <20081216112019.GE4299@elte.hu>
References: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081216003428.43d37b6b.akpm@linux-foundation.org> <20081216101827.GB27481@elte.hu> <20081216102340.GA1003@elte.hu> <2f11576a0812160315g3dea988ayfadba2117e172a2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0812160315g3dea988ayfadba2117e172a2c@mail.gmail.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi!
> 
> >> > No, lockdep.h (which we forgot to include) already handles that:
> >> >
> >> > # define lockdep_set_class(lock, key)               do { (void)(key); } while (0)
> >> >
> >> > the problem is that the code which references irq_desc_lock_class is
> >> > inside #ifdef CONFIG_SPARSE_IRQ, so this is a better fix:
> >>
> >> agreed that this is the better fix - applied to tip/irq/sparseirq,
> >> thanks!
> >
> > actually, this breaks the build on !SPARSEIRQ because we will use that 
> > class in the non-sparseirq case. So we've converted a build warning to 
> > a build failure ;-)
> 
> Please give me your .config and tell me your arch. my ia64 box (ia64 is 
> !SPARSEIRQ) can build the akpm patch.

The expected build failure is obvious from reading the code:

 #ifdef CONFIG_TRACE_IRQFLAGS
 void early_init_irq_lock_class(void)
 {
 #ifndef CONFIG_SPARSE_IRQ
         struct irq_desc *desc;
         int i;

         for_each_irq_desc(i, desc) {
                 if (!desc)
                         continue;

                 lockdep_set_class(&desc->lock, &irq_desc_lock_class);

Note that it's an #ifndef sparseirq, not an #ifdef sparseirq condition.

	Ingo
