Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZGDK1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZGDK1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZGDK1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:27:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZGDK1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:27:08 -0400
Date: Sat, 4 Jul 2009 12:26:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       yinghai@kernel.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bernhard.walle@gmx.de>
Subject: Re: [PATCH 1/2] IRQ: fix performance regression on large IA64
	systems
Message-ID: <20090704102637.GA32257@elte.hu>
References: <1246611709-9919-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246611709-9919-1-git-send-email-jirislaby@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Commit b60c1f6ffd88850079ae419aa933ab0eddbd5535
> (drop note_interrupt() for per-CPU for proper scaling) removed call to
> note_interrupt() in __do_IRQ(). Commit
> d85a60d85ea5b7c597508c1510c88e657773d378
> (Add IRQF_IRQPOLL flag (common code)) added it again, because it's needed
> for irqpoll.
> 
> This patch now introduces a new parameter 'only_fixup' for 
> note_interrupt(). This parameter determines two cases:
> 
>   TRUE  => The function should be only executed when irqfixup is set.
>            Either 'irqpoll' or 'irqfixup' directly set that.
> 
>   FALSE => Just the behaviour as note_interrupt() always had.
> 
> Now the patch converts all calls of note_interrupt() to 
> only_fixup=FALSE, except the call that has been removed by 
> b60c1f6ffd. So that call is always done, but the body is only 
> executed when either 'irqpoll' or 'irqfixup' are specified.
> 
> This is needed because __do_IRQ() calls note_interrupt() to record 
> IRQ statistics. It ends up creating serious cache line contention, 
> enough that a 1024p system live locks under the crushing weight of 
> the timer tick.
> 
> The note_interrupt() call modifies fields in the irq_desc_t 
> structure. For PER_CPU timer interrupts (on ia64 machines) this 
> causes cacheline contention.
> 
> Systems with 1024 processors take an extremely long time to boot 
> up, as most of the time is spent attempting to service timer 
> interrupts.  With noirqdebug added to the boot line, the system 
> boots in close to the normal amount of time.

What would be the effect/cost of enabling this by default? Seems 
desirable and eventually we'll hit those problems with regular 
systems too ...

	Ingo
