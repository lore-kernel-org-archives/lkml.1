Return-Path: <linux-kernel-owner+w=401wt.eu-S1765408AbXGXIGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765408AbXGXIGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbXGXIFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:05:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56195 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXGXIFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:05:45 -0400
Date: Tue, 24 Jul 2007 10:05:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070724080534.GC18740@elte.hu>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com> <20070629150759.GC2771@ff.dom.local> <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcin Ślusarz <marcin.slusarz@gmail.com> wrote:

> Ok, I've bisected this problem and found that this patch broke my NIC:
> 
> 76d2160147f43f982dfe881404cfde9fd0a9da21 is first bad commit
> commit 76d2160147f43f982dfe881404cfde9fd0a9da21
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Feb 16 01:28:24 2007 -0800
> 
>    [PATCH] genirq: do not mask interrupts by default

thanks for tracking it down! Could you try the patch below (ontop an 
otherwise unmodified kernel)? This tests the theory whether the problem 
is related to the disable_irq_nosync() call in the ne2k driver's xmit 
path. Does this solve the hangs too?

	Ingo

Index: linux/kernel/irq/manage.c
===================================================================
--- linux.orig/kernel/irq/manage.c
+++ linux/kernel/irq/manage.c
@@ -102,7 +102,19 @@ void disable_irq_nosync(unsigned int irq
 	spin_lock_irqsave(&desc->lock, flags);
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		/*
+		 * the _nosync variant of irq-disable suggests that the
+		 * caller is not worried about concurrency but about the
+		 * ordering of the irq flow itself. (such as hardware
+		 * getting confused about certain, normally valid irq
+		 * handling sequences.) So if the default disable handler
+		 * is in place then try the more conservative masking
+		 * instead:
+		 */
+		if (desc->chip->disable == default_disable && desc->chip->mask)
+			desc->chip->mask(irq);
+		else
+			desc->chip->disable(irq);
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
