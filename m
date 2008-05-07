Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbYEGHaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbYEGHaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764256AbYEGHac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:30:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47157 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763598AbYEGHa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:30:29 -0400
Date: Wed, 7 May 2008 09:30:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Spinlocks waiting with interrupts disabled / preempt disabled.
Message-ID: <20080507073017.GJ32195@elte.hu>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Lameter <clameter@sgi.com> wrote:

> @@ -132,10 +132,14 @@ unsigned long __lockfunc _write_lock_irq
>  {
>  	unsigned long flags;
>  
> +retry:
>  	local_irq_save(flags);
> -	preempt_disable();
> -	_raw_write_lock(lock);
> -	return flags;
> +	if (_write_trylock(lock))
> +		return flags;
> +	local_irq_restore(flags);
> +	while (!write_can_lock(lock))
> +		cpu_relax();
> +	goto retry;
>  }
>  EXPORT_SYMBOL(_write_lock_irqsave);

hm, this is done on a too high level and will turn off some debugging 
code. I.e. if we dont just loop long but truly deadlock here we wont 
call lib/spinlock_debug.c's _raw_write_lock() code that does some sanity 
checks in the debug case.

so how about doing this on a deeper level and adding a new 
__raw_write_lock_flags() primitive that would look at the flags value 
and could enable interrupts in the lowlevel code?

	Ingo
