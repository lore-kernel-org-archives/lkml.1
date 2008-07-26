Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbYGZP1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbYGZP1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYGZP1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:27:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40535 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYGZP1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:27:24 -0400
Date: Sat, 26 Jul 2008 17:26:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: single CPU tracers use CPU clock
Message-ID: <20080726152650.GA7823@elte.hu>
References: <20080725220040.911370182@goodmis.org> <20080725220334.781928198@goodmis.org> <20080726124058.GD20713@elte.hu> <Pine.LNX.4.58.0807260905500.12953@gandalf.stny.rr.com> <20080726132118.GA30903@elte.hu> <Pine.LNX.4.58.0807261034590.13726@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807261034590.13726@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > other tracers care too - for example to have the right chronology of 
> > trace events. The scheduler cares too. What kind of worst-case 
> > cross-CPU effects have you observed?
> 
> 1:            bash-3498  [01]  5459.824565:      0:140:R   +  7971:120:R
> 2:          <idle>-0     [00]  5459.824836:      0:140:R ==>  7971:120:R
> 3:            bash-3498  [01]  5459.824984:   3498:120:S ==>     0:140:R
> 4:          <idle>-0     [01]  5459.825342:      0:140:R ==>  7971:120:R
> 5:              ls-7971  [00]  5459.825380:   7971:120:R   +     3:  0:S
> 6:              ls-7971  [00]  5459.825384:   7971:120:R ==>     3:  0:R
> 7:     migration/0-3     [00]  5459.825401:      3:  0:S ==>     0:140:R
> 8:              ls-7971  [01]  5459.825565:   7971:120:R   +   598:115:S
> 
> The above was from my tutorial at OLS. I added the annotated numbers 
> at the beginning of the line. This is the sched_switch tracer.

so it's off by 60 usecs. That matters to the chronology of SMP events, 
and to the irqsoff and preemptoff tracers - if we update the clock 
incorrectly - i.e. if we modify the clock across CPUs so that a running 
CPU can see an 'involuntary' jump in local time.

that should be fixed then - and all tracers (and the scheduler) will 
improve - instead of having this special-case.

	Ingo
