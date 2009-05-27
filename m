Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZE0Wdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZE0Wdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZE0Wdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:33:43 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:38270 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZE0Wdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:33:43 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Wed, 27 May 2009 17:33:37 -0500
User-Agent: KMail/1.9.9
Cc: peterz@infradead.org, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905230544.54657.lkml@morethan.org> <adar5ya5h4w.fsf@cisco.com>
In-Reply-To: <adar5ya5h4w.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271733.42266.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 27 2009, Roland Dreier wrote:
> 
>  > The only objective information is posted here:
>  > http://lkml.org/lkml/2009/5/20/342
> 
> Not sure if you've looked at this, but it's a lockdep trace that looks
> to be a valid lockdep report due to non-annotated code (I don't *think*
> it's a bug).  To summarize, there is the code path in
> kernel/irq/spurious.c that does:
>

I haven't looked at it - beyond my skill level.

Still trying to deal with a machine where the only symptom is a deadlock.
So I post these for someone else's eyes until I figure out the deadlock.

Mike
 
>     poll_spurious_irq_timer ->
>       poll_spurious_irqs()     [from timer, with hard IRQs on] ->
>       poll_all_shared_irqs()   [if we think an IRQ got stuck] ->
>       try_one_irq() ->
>       spin_lock(&desc->lock)   [as above -- hard IRQs on]
> 
> while kernel/irq/chip.c has:
> 
>     handle_level_irq()         [called with hard IRQs off] ->
>       spin_lock(&desc->lock)   [as above -- hard IRQs off]
> 
> and lockdep can't tell that the interrupt corresponding to desc has been
> disabled if we ever actually reach try_one_irq(), so there's no risk of
> the interrupt coming in and deadlocking while the try_one_irq() code
> holds desc->lock.
> 
> Unfortunately I don't know how to annotate this...
> 
> 


