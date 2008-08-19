Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYHSBRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYHSBRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYHSBRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:17:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44034 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbYHSBRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:17:14 -0400
Date: Tue, 19 Aug 2008 03:16:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: rename irq_desc() to to_irq_desc() - fix #3
Message-ID: <20080819011656.GC14821@elte.hu>
References: <1219092290-30154-1-git-send-email-yhlu.kernel@gmail.com> <1219092290-30154-2-git-send-email-yhlu.kernel@gmail.com> <1219092290-30154-3-git-send-email-yhlu.kernel@gmail.com> <20080819001126.GB9914@elte.hu> <20080819003856.GA5486@elte.hu> <86802c440808181748m62544821pd0c4a3eb4bed60bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808181748m62544821pd0c4a3eb4bed60bb@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > -       kstat_this_cpu.irqs[irq]++;
> > +       kstat_irqs_this_cpu(&irq_desc[irq])++;
> >
> >  out:
> >        unspinning_lock(xl);
> >
> 
> should be
> 
> kstat_irqs_this_cpu(to_irq_desc(irq))++;
> 
> otherwise when CONFIG_HAVE_SPARSE_IRQ is set, it will fail.
> 
> when sparse_irq is set, only have irq_descX list...

ok, fixed it - updated patch below. Build testing just triggered it as 
well.

	Ingo

----------->
>From ba0540e8ae86abbe55b643e230ce276984fbb650 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 19 Aug 2008 02:33:39 +0200
Subject: [PATCH] irq: build fix

fix:

 arch/x86/xen/spinlock.c: In function 'xen_spin_lock_slow':
 arch/x86/xen/spinlock.c:90: error: 'struct kernel_stat' has no member named 'irqs'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/spinlock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 8dc4d31..bfb1707 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -87,7 +87,7 @@ static noinline int xen_spin_lock_slow(struct raw_spinlock *lock)
 
 	/* block until irq becomes pending */
 	xen_poll_irq(irq);
-	kstat_this_cpu.irqs[irq]++;
+	kstat_irqs_this_cpu(to_irq_desc(irq))++;
 
 out:
 	unspinning_lock(xl);
