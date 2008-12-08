Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYLHQS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYLHQS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYLHQSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:18:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38373 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbYLHQSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:18:18 -0500
Date: Mon, 8 Dec 2008 17:18:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, oliver@hartkopp.net
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
Message-ID: <20081208161807.GA7755@elte.hu>
References: <1227613431.4259.1537.camel@twins> <1228385830.5092.43.camel@twins> <1228752782.6939.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1228752782.6939.2.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2008-12-04 at 11:17 +0100, Peter Zijlstra wrote:
> > On Tue, 2008-11-25 at 12:43 +0100, Peter Zijlstra wrote:
> > > Hi,
> > > 
> > > This is an attempt at removing some of the hrtimer complexity by
> > > reducing the number of callback modes to 1.
> > > 
> > > This means that all hrtimer callback functions will be ran from HARD-irq
> > > context.
> > > 
> > > I went through all the 30 odd hrtimer callback functions in the kernel
> > > and saw only one that I'm not quite sure of, which is the one in
> > > net/can/bcm.c - hence I'm CC-ing the folks responsible for that code.
> > > 
> > > Furthermore, the hrtimer core now calls callbacks directly with IRQs
> > > disabled in case you try to enqueue an expired timer. If this timer is a
> > > periodic timer (which should use hrtimer_forward() to advance its time)
> > > then it might be possible to end up in an inf. recursive loop due to the
> > > fact that hrtimer_forward() doesn't round up to the next timer
> > > granularity, and therefore keeps on calling the callback - obviously
> > > this needs a fix.
> > > 
> > > Aside from that, this seems to compile and actually boot on my dual core
> > > test box - although I'm sure there are some bugs in, me not hitting any
> > > makes me certain :-)
> > > 
> > > Not-Quite-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > Ingo, this addition fixes the hotplug issue on my machine
> 
> And because we're all human...
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/hrtimer.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)

applied, thanks!

Sidenote: this fix was brought to us by watching new warnings in 
tip/master, where this new one popped up:

 kernel/hrtimer.c: In function ‘hrtimer_cpu_notify’:
 kernel/hrtimer.c:1574: warning: unused variable ‘dcpu’

trying to map dcpu then highlighted the bug.

	Ingo
