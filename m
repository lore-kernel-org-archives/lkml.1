Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYJ1REs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYJ1REs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYJ1REk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:04:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:35948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ1REj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:04:39 -0400
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200810271426.27110.david-b@pacbell.net>
References: <200810271426.27110.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 18:04:02 +0100
Message-Id: <1225213442.15763.20.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 14:26 -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Lockdep reported a problem in the at91_mci driver ... in this case, the
> issue is with lockdep, not with the driver.  A trimmed stack dump, from
> trying to boot with root on MMC, shows:
> 
>   WARNING: at kernel/lockdep.c:2195 trace_hardirqs_on_caller+0xf4/0x170()
>   Modules linked in:
>   [<c005bc98>] (trace_hardirqs_on+0x0/0x18) from [<c0213bf4>] (_spin_unlock_irq+0x2c/0x3c)
>   [<c0213bc8>] (_spin_unlock_irq+0x0/0x3c) from [<c0029a88>] (flush_dcache_page+0x114/0x144)
>   [<c0029974>] (flush_dcache_page+0x0/0x144) from [<c019b034>] (at91_mci_irq+0x150/0x414)
>   [<c019aee4>] (at91_mci_irq+0x0/0x414) from [<c0066c5c>] (handle_IRQ_event+0x2c/0x6c)
>   [<c0066c30>] (handle_IRQ_event+0x0/0x6c) from [<c0068a60>] (handle_level_irq+0x108/0x124)
>   [<c0068958>] (handle_level_irq+0x0/0x124) from [<c0022064>] (__exception_text_start+0x64/0x90)
> 
> When __flush_dcache_aliases() returns -- inlined into flush_dcache_page(),
> above -- it re-enables IRQs ... since that evidently may only be called with
> IRQs enabled.  That's OK since the (unshared) IRQ handler doesn't ask for IRQs
> to be disabled.   Except ... that lockdep went and disabled them, then went on
> to complains about the breakage *it* caused!
> 
> Workaround: depend on LOCKDEP=n ... and for paranoia, disable IRQF_SHARED
> for this interrupt.  (At the hardware level, this is dedicated to MCI, so
> there's never a need for multiple handlers.)

In all previous such cases it was deemed the IRQ handler should deal
with whatever it gets.

