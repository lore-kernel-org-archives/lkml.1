Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZGET1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZGET1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZGET1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:27:33 -0400
Received: from www.tglx.de ([62.245.132.106]:41029 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZGET1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:27:32 -0400
Date: Sun, 5 Jul 2009 21:26:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Slaby <jirislaby@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, Bernhard Walle <bernhard.walle@gmx.de>
Subject: Re: [PATCH 1/2] IRQ: fix performance regression on large IA64
 systems
In-Reply-To: <1246611709-9919-1-git-send-email-jirislaby@gmail.com>
Message-ID: <alpine.LFD.2.00.0907051810030.2771@localhost.localdomain>
References: <1246611709-9919-1-git-send-email-jirislaby@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009, Jiri Slaby wrote:
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
> Now the patch converts all calls of note_interrupt() to only_fixup=FALSE,
> except the call that has been removed by b60c1f6ffd.
> So that call is always done, but the body is only executed when either
> 'irqpoll' or 'irqfixup' are specified.
> 
> This is needed because __do_IRQ() calls note_interrupt() to record IRQ
> statistics. It ends up creating serious cache line contention,
> enough that a 1024p system live locks under the crushing weight of the
> timer tick.
> 
> The note_interrupt() call modifies fields in the irq_desc_t structure.
> For PER_CPU timer interrupts (on ia64 machines) this causes cacheline
> contention.
> 
> Systems with 1024 processors take an extremely long time to boot up, as
> most of the time is spent attempting to service timer interrupts.  With
> noirqdebug added to the boot line, the system boots in close to the normal
> amount of time.

Hmm. I'm not really happy about that patch. It's all about percpu
interrupts which happen to have the same irq number. I think the
correct thing to do is to use the handle_percpu_irq() handler and
modify handle_percpu_irq to call note_interrupt() only when the return
value of the action handler is IRQ_NONE. Otherwise we can leave
everything untouched.

Thanks,

	tglx


