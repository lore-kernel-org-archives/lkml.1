Return-Path: <linux-kernel-owner+w=401wt.eu-S968370AbXFHHco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968370AbXFHHco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938236AbXFHHV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:21:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938232AbXFHHV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:21:57 -0400
Date: Fri, 8 Jun 2007 09:20:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/4] rt-mutex: Fix stale return value
Message-ID: <20070608072050.GD30226@elte.hu>
References: <20070607235106.387346000@linutronix.de> <20070607235801.429050000@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607235801.429050000@linutronix.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> -			if (unlikely(!waiter.task))
> +			if (unlikely(!waiter.task)) {
> +				/*
> +				 * Reset the return value. We might
> +				 * have returned with -EDEADLK and the
> +				 * owner released the lock while we
> +				 * were walking the pi chain.
> +				 */
> +				ret = 0;
>  				continue;
> -
> +			}

ok - i guess the reason here that we never triggered it in -rt is that 
-EDEADLK is a really rare case that only occurs with pi-futexes (and 
even then, only with buggy userspace or with intentional testcases). 
Plus, lockdep caught most/all of the in-kernel deadlocks before this 
mechanism could catch it.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
