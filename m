Return-Path: <linux-kernel-owner+w=401wt.eu-S1760674AbXEWH1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbXEWH1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXEWH0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:26:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37379 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbXEWH0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:26:52 -0400
Date: Wed, 23 May 2007 09:26:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
Message-ID: <20070523072609.GC6859@elte.hu>
References: <20070507144351.GA12302@ms2.inr.ac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507144351.GA12302@ms2.inr.ac.ru>
User-Agent: Mutt/1.4.2.2i
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


* Alexey Kuznetsov <kuznet@ms2.inr.ac.ru> wrote:

> Hello!
> 
> 1. New entries can be added to tsk->pi_state_list after task completed
>    exit_pi_state_list(). The result is memory leakage and deadlocks.
> 
> 2. handle_mm_fault() is called under spinlock. The result is obvious.
> 
> 3. State machine is broken. Kernel thinks it owns futex after
>    it released all the locks. Ergo, it corrupts futex. The result is that
>    two processes think they took a futex.
> 
> All the bugs are trivially reproduced when running glibc's tst-robustpi7
> test long enough.
> 
> The patch is not quite good (RFC!), because:
> 
> 1. There is one case, when I did not figure out how to handle
>    page fault correctly. I would do it releasing taken rtmutex
>    and hb->lock and retrying futex from the very beginning.
>    It is quite ugly. Probably, state machine can be fixed somehow.
> 
> 2. Before this patch I had one unexplained oops inside rtmutex
>    in plist_del. I did _not_ fix this, but it does not want to reproduce.
>    Probably, more strong locking did some race window too narrow.

thanks for the fixes - they look all good and we'll check it in -rt. 
We'll try to find a solution for the remaining problem too. Could your
#2 crash be explained via any of the bugs you fixed? (i.e. memory
corruption?) I'd exclude genuine rtmutex.c breakage for now because 
that's the basis of all locking in -rt - but maybe the futex interfacing 
upsets something ...

	Ingo
