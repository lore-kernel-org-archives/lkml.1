Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbZAZOn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbZAZOn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZAZOnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:43:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZAZOnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:43:19 -0500
Date: Mon, 26 Jan 2009 15:43:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435
	sub_preempt_count
Message-ID: <20090126144313.GC4445@elte.hu>
References: <4966897E.5020302@free.fr> <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com> <20090111024945.GC7077@elte.hu> <20090114020040.GA19806@wotan.suse.de> <f19298770901241633l736801f6r760ef54883ca9c87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770901241633l736801f6r760ef54883ca9c87@mail.gmail.com>
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


* Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:

> On Wed, Jan 14, 2009 at 05:00, Nick Piggin <npiggin@suse.de> wrote:
> > On Sun, Jan 11, 2009 at 03:49:45AM +0100, Ingo Molnar wrote:
> >>
> >> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> >>
> >> > One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
> >> > Added Ingo Molnar to CC.
> >>
> >> added Nick on Cc:. Nick, it's about:
> >>
> >> > commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
> >> > Author: Nick Piggin <nickpiggin@yahoo.com.au>
> >> > Date:   Tue Sep 30 20:50:27 2008 +1000
> >> >
> >> >    sched: improve preempt debugging
> >>
> >> causing a seemingly spurious warning.
> >
> > I don't know how it is spurious... Presumably the sequence _would_ have
> > caused preempt count to go negative if the bkl were not held...
> >
> > __do_softirq does a __local_bh_disable on entry, and it seems like the
> > _local_bh_enable on exit is what causes this warning. So something is
> > unbalanced somehow. Or is it some weird thing we do in early boot that
> > I am missing?
> >
> > Can you put in some printks around these functions in early boot to
> > get an idea of what preempt_count is doing?
> >
> 
> Hi again.
> 
> Finally got to debug this. The preempt count on the first __do_softirq entry
> ever is 0, as it is set in irq_ctx_init(). The interrupted swapper
> thread happens
> to be in the kernel_locked() state at the moment, so the warning.
> 
> I don't understand why the softirq preempt count is initialized to 0. 
> Should not it be SOFTIRQ_OFFSET instead?

hm, indeed. So this triggers on irqstacks, if an irq happens to hit the 
first time a softirq executes (ever)? After that point the preempt_count 
in the irq-stack ought to stay elevated.

	Ingo
