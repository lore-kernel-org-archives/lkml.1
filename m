Return-Path: <linux-kernel-owner+w=401wt.eu-S1423063AbXCBNMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423063AbXCBNMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 08:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXCBNMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 08:12:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41794 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933350AbXCBNMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 08:12:34 -0500
Date: Fri, 2 Mar 2007 14:04:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Christian Borntraeger <cborntra@de.ibm.com>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] timer/hrtimer: take per cpu locks in sane order
Message-ID: <20070302130433.GA4391@elte.hu>
References: <20070227153051.GD7911@osiris.boeblingen.de.ibm.com> <20070302125848.GA8226@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302125848.GA8226@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> -	spin_lock(&new_base->lock);
> -	spin_lock(&old_base->lock);
> +	/*
> +	 * If we take a lock from a different cpu, make sure we have always
> +	 * the same locking order. That is the lock that belongs to the cpu
> +	 * with the lowest number is taken first.
> +	 */
> +	lock1 = smp_processor_id() < cpu ? &new_base->lock : &old_base->lock;
> +	lock2 = smp_processor_id() < cpu ? &old_base->lock : &new_base->lock;
> +	spin_lock(lock1);
> +	spin_lock(lock2);

looks good to me. Wouldnt this be cleaner via double_lock_timer() - 
similar to how double_rq_lock() works in kernel/sched.c - instead of 
open-coding it?

	Ingo
