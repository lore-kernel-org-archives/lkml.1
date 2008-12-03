Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbYLCITb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYLCITb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYLCITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:19:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYLCITT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:19:19 -0500
Date: Wed, 3 Dec 2008 09:19:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
	output
Message-ID: <20081203081906.GH21006@elte.hu>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4935E226.3060906@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Frederic Weisbecker wrote:
> > Impact: better output of duration for long calls
> > 
> > The old duration output didn't exceeded 9999.999 us to fit the column
> > and the nanosecs were always 3 numbers. As Ingo suggested, it's better
> > to have the whole microseconds elapsed time and shift the nanosecs precision
> > if needed to fit the maximum 7 numbers. And usec need more number, the case
> > should be rare and important enough to break a bit the column alignment to
> > show it.
> > 
> > So, depending of the duration value, we now have these patterns:
> > 
> > u.nnn
> > uu.nnn
> > uuu.nnn
> > uuuu.nnn
> > uuuuu.nn
> > uuuuuu.n
> > uuuuuuuu.....

applied, thanks!

> An example of a trace after these two patches (with funcgraph-proc enabled):
> 
>  0)    cat-2796    |               |            put_prev_task_fair() {
>  0)    cat-2796    |   0.609 us    |              update_curr();
>  0)    cat-2796    |   1.842 us    |            }
>  0)    cat-2796    |               |            pick_next_task_fair() {
>  0)    cat-2796    |   0.526 us    |              wakeup_preempt_entity();
>  0)    cat-2796    |   0.797 us    |              set_next_entity();
>  0)    cat-2796    |   0.541 us    |              hrtick_start_fair();
>  0)    cat-2796    |   4.195 us    |            }
>  0)    cat-2796    |   1.263 us    |            _spin_trylock();
>  0)    cat-2796    |   0.624 us    |            _spin_unlock();
>  0)    cat-2796    |   0.789 us    |            _spin_trylock();
>  0)    cat-2796    |   0.617 us    |            _spin_unlock();
>  0)    cat-2796    |   0.579 us    |            native_load_sp0();
>  0)    cat-2796    |   0.722 us    |            native_load_tls();
>
>  ------------------------------------------
>  | 0)    cat-2796    =>   events/-9   
>  ------------------------------------------

small detail: i'd suggest to remove the newline before the context-switch 
box. That makes it appear visually to attach logically with the 
switch-out place, not the switch-in place:

>  0)    cat-2796    |   0.579 us    |            native_load_sp0();
>  0)    cat-2796    |   0.722 us    |            native_load_tls();
>  ------------------------------------------
>  | 0)    cat-2796    =>   events/-9   
>  ------------------------------------------
> 
>  0)   events/-9    |               |    finish_task_switch() {
>  0)   events/-9    |   0.789 us    |      _spin_unlock_irq();
>  0)   events/-9    |   2.309 us    |    }
>  0)   events/-9    | ! 269848.5 us |  }

which is what we want to express.

	Ingo
