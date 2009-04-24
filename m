Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZDXIgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZDXIgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZDXIgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:36:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZDXIgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:36:06 -0400
Date: Fri, 24 Apr 2009 10:34:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
Message-ID: <20090424083444.GJ24912@elte.hu>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu> <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com>
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

> 
> On Thu, 23 Apr 2009, Ingo Molnar wrote:
> 
> > > 
> > > Here's the situation:
> > > 
> > > We've added selftests for the event tracer. What this basically does is 
> > > enables each event one at a time and runs tests. The tests include 
> > > creating a kernel thread, executing workqueues and grabbing locks.
> > > 
> > > We also have PROVE_LOCKING (LOCKDEP) enabled, that keeps track of 
> > > interrupts being enabled. When they are, we set a flag in the task struct 
> > > "hardirqs_enabled". When they are disabled, this flag is cleared.
> > > 
> > > When we fork a process, a test is made to see if the flag is set for the 
> > > new process and if it is not, a warning is printed (as is done in the 
> > > above dump).
> > > 
> > > I investigated this and found that the flag is mysteriously being set and 
> > > cleared for no apparent reason. The flag is in the task struct and nothing 
> > > should be touching it. In fact, it is a full int, not even a bit in a 
> > > flags variable.
> > > 
> > > I had a test that would print the flag and irqs_disabled() in copy_process 
> > > before the warning and it showed that the flag was cleared but irqs was 
> > > enabled. The funny part is, I if the test triggered, I printed the flag 
> > > again, and the second print it was set again!!
> > > 
> > > 	if (!p->hardirqs_enabled) {
> > > 		printk("irqs:%d flag:%d\n", irqs_disabled(),
> > > 			p->hardirqs_enabled);
> > > 		printk("try again: %d\n", p->hardirqs_enabled);
> > > 	}
> > > 
> > > The first print showed that it was cleared, the second showed it was set 
> > > again??
> > 
> > function tracer was active? So somewhere there we corrupted this 
> > state? It's unlikely that printk itself did this.
> 
> The problem always arises at the same spot. I'm not saying printk was the 
> culprit, I'm saying that printk actually "fixed" the issue. Which can be a 
> sign of a corrupted register somewhere.
> 
> I currently tracked it down to something in "prep_new_page". It is 
> hard to debug because as I add tests into the code, it makes the 
> race window smaller, and I need to run multiple boots to trigger 
> the code. But when I do trigger it (and I try to trigger it a few 
> times) it always happens at the same spot.
> 
> Note, everytime I catch the issue, the printk again "fixes" the 
> problem
> :-/

btw., you could perhaps use early_printk() - which is a lot less 
intrusive. It has no locking nor any irq-flags manipulation. (for 
the serial bits at least)

	Ingo
