Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYHSB2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYHSB2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 21:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYHSB2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 21:28:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbYHSB2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 21:28:32 -0400
Date: Tue, 19 Aug 2008 03:28:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
Message-ID: <20080819012816.GA7897@elte.hu>
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819004531.GI9914@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> nice stuff!
> 
> I suspect the extra cost might be worth it for two reasons: 1) we 
> could optimize the cross-call implementation further 2) on systems 
> where TLB flushes actually matter, the ability to overlap multiple TLB 
> flushes to the same single CPU might improve workloads.
> 
> FYI, i've created a new -tip topic for your patches, tip/x86/tlbflush. 
> It's based on tip/irq/sparseirq (there are a good deal of dependencies 
> with that topic).

i threw it into -tip testing for a while - triggered the lockdep warning 
on 64-bit below.

	Ingo

------------>
checking TSC synchronization [CPU#0 -> CPU#1]: passed.

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-rc3-tip #1
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&call_function_queues[i].lock){....}, at: [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e

but task is already holding lock:
 (&call_function_queues[i].lock){....}, at: [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (&call_function_queues[i].lock){....}, at: [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.27-rc3-tip #1
Call Trace:
 [<ffffffff802665c2>] validate_chain+0x53e/0xc26
 [<ffffffff80263814>] ? trace_hardirqs_off_caller+0x21/0xa4
 [<ffffffff802638a4>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff802673d6>] __lock_acquire+0x72c/0x795
 [<ffffffff802674cc>] lock_acquire+0x8d/0xba
 [<ffffffff8026cbba>] ? ipi_call_lock_irq+0x25/0x2e
 [<ffffffff808aa83c>] _spin_lock_irq+0x44/0x74
 [<ffffffff8026cbba>] ? ipi_call_lock_irq+0x25/0x2e
 [<ffffffff8026cbba>] ipi_call_lock_irq+0x25/0x2e
 [<ffffffff808a4acf>] start_secondary+0x127/0x18e
Brought up 2 CPUs
Total of 2 processors activated (11733.31 BogoMIPS).
