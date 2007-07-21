Return-Path: <linux-kernel-owner+w=401wt.eu-S936294AbXGUMdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936294AbXGUMdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762420AbXGUMdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:33:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761875AbXGUMdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:33:12 -0400
Date: Sat, 21 Jul 2007 14:31:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pi-futex: set PF_EXITING without taking ->pi_lock
Message-ID: <20070721123159.GB1769@elte.hu>
References: <20070721115712.GA871@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721115712.GA871@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> It is a bit annoying that do_exit() takes ->pi_lock to set PF_EXITING.
> All we need is to synchronize with lookup_pi_state() which saw this task
> without PF_EXITING under ->pi_lock.
> 
> Change do_exit() to use spin_unlock_wait().
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Ingo Molnar <mingo@elte.hu>

> -	spin_lock_irq(&tsk->pi_lock);
> -	tsk->flags |= PF_EXITING;
> -	spin_unlock_irq(&tsk->pi_lock);
> +	smp_mb();
> +	spin_unlock_wait(&tsk->pi_lock);

hm, isnt spin_unlock_wait() an SMP barrier in itself? (if not then it 
should be.)

	Ingo
