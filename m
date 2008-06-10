Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYFJQNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYFJQNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYFJQNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:13:14 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44145 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbYFJQNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:13:13 -0400
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
From: Catalin Marinas <catalin.marinas@arm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <1213112683.3440.20.camel@localhost.localdomain>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
	 <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
	 <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
	 <1213112683.3440.20.camel@localhost.localdomain>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 10 Jun 2008 17:04:47 +0100
Message-Id: <1213113887.24701.119.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 16:04:48.0428 (UTC) FILETIME=[B5299EC0:01C8CB13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 10:44 -0500, James Bottomley wrote:
> On Tue, 2008-06-10 at 15:51 +0100, Catalin Marinas wrote:
> > I was thinking whether this condition can be removed and allow the
> > smp_call_function*() to be called with IRQs disabled. At a quick look,
> > it seems to be possible if the csd_flag_wait() function calls the IPI
> > handlers directly when the IRQs are disabled (see the patch below).
[...]
> > Please let me know what you think or whether deadlocks are still
> > possible (or any other solution apart from hardware fixes :-)). Thanks.
> 
> I don't see how your proposal fixes the deadlocks.  The problem is that
> on a lot of arch's IPIs are normal interrupts.  If interrupts are
> disabled, you don't see them.

ARM uses normal interrupts for IPIs as well.

> The deadlock scenario is CPU1 enters smp_call_function() with IRQ's
> disabled as CPU2 does the same thing and spins on the call_lock.  Now
> CPU1 is waiting for an ack for its IPI to CPU2, but CPU2 will never see
> the IPI until it enables interrupts.

I can see in the generic IPI patches that the call_function_lock is only
held for list_add_tail_rcu and not while waiting for the other CPU to
complete (both arch_send_call_function_ipi and csd_flag_wait are outside
the locking region).

The patch I posted polls for an incoming IPI in the csd_flag_wait()
function if the interrupts are disabled so that it clears the wait flag
even if it doesn't get the IPI. The disadvantage might be a spurious IPI
(but I can leave with this). If interrupts are enabled, there is no
drawback, apart from a call to irq_disabled().

> One way to mitigate the effects of this is to enable interrupts if the
> architecture code finds the call_lock (x86 implementation) held against
> it, then re-disable before trying to get the lock again.  But really, in
> order to make smp_call_function work in interrupt disabled sections, the
> interrupt handler has to be modified to bar all non-IPI interrupts until
> the critical section is over (otherwise there's no point allowing it
> with disabled interrupts because an smp_call_function becomes a de facto
> interrupt enable again).  If you really want to see how something like
> this works, the voyager code has it (because interrupt disabling in the
> VIC is expensive).  But it's quite a lot of code ...

I still think it can be less complicated that this. I'll look at Paul's
post to get some ideas. As I said, I need this functionality on current
ARM SMP systems, even if it means implementing it separately.

Thanks.

-- 
Catalin

