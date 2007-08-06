Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbXHFHbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbXHFHbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXHFHbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:31:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbXHFHbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:31:36 -0400
Date: Mon, 6 Aug 2007 09:30:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] pi-futex: set PF_EXITING without taking ->pi_lock
Message-ID: <20070806073040.GJ5359@elte.hu>
References: <20070721115712.GA871@tv-sign.ru> <20070721123159.GB1769@elte.hu> <20070721141814.GA1013@tv-sign.ru> <20070721150547.GA23560@elte.hu> <20070721163947.GA1129@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721163947.GA1129@tv-sign.ru>
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

> Question: should we make spinlock_t barrier-safe?
> 
> Suppose that the task "p" does
> 
> 	current->state = TASK_INTERRUPIBLE;
> 	mb();
> 
> 	if (CONDITION)
> 		break;
> 
> 	schedule();
> 
> and another CPU does
> 
> 	CONDITION = 1;
> 	try_to_wake_up(p);
> 
> 
> This is commonly used, but not correct _in theory_. If wake_up() happens
> when p->array != NULL, we have
> 
> 	CONDITION = 1;			// [1]
> 	spin_lock(rq->lock);
> 	task->state = TASK_RUNNING;	// [2]
> 
> and we can miss an event. Because in theory [1] may leak into the critical
> section, and could be re-ordered with [2].
> 
> Another problem is that try_to_wake_up() first checks task->state and does
> nothing if it is TASK_RUNNING, so we need a full mb(), not just wmb().
> 
> Should we change spin_lock(), or introduce smp_mb_before_spinlock(), or I
> missed something?
> 
> NOTE: I do not pretend to know what kind of barrier spin_lock() provides
> in practice, but according to the documentation lock() is only a one-way
> barrier.

i think your worry is legitimate.

spin_lock() provides a full barrier on most platforms (certainly so on 
x86). But ... ia64 might have it as a one-way barrier?

	Ingo
