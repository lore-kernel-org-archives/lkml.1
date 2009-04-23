Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbZDWPNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbZDWPNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZDWPMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:12:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZDWPMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:12:50 -0400
Date: Thu, 23 Apr 2009 17:11:30 +0200
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
Message-ID: <20090423151130.GA21130@elte.hu>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu> <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 23 Apr 2009, Steven Rostedt wrote:
> > 
> > static inline void __native_flush_tlb_global(void)
> > {
> >         unsigned long flags;
> >         unsigned long cr4;
> > 
> >         /*
> >          * Read-modify-write to CR4 - protect it from preemption and
> >          * from interrupts. (Use the raw variant because this code can
> >          * be called from deep inside debugging code.)
> >          */
> >         raw_local_irq_save(flags);
> > 
> >         cr4 = read_cr4();
> >         /* clear PGE */
> >         write_cr4(cr4 & ~X86_CR4_PGE);
> >         /* write old PGE again and flush TLBs */
> >         write_cr4(cr4);
> > 
> >         raw_local_irq_restore(flags);
> > }
> > 
> > 
> > Each of those read_cr4 and write_cr4 can be traced. But I still do not see 
> > how this can cause corruption in the current task struct.
> > 
> > The TLB just caches the pages we are using, not the contents 
> > inside. I still do not see how this can corrupt a bit. Unless a 
> > register leaked :-/
> 
> Ah, this is a lockdep thing.
> 
> The raw_local_irq_save/restore in __native_flush_tlb_global does 
> not update hardirqs_enabled.
> 
> When we call into ftrace, when we cross page bounderies, we 
> disable interrupts using the normal local_irq_save/restore calls.
> 
> But when we restore, it detects that interrupts are not going to 
> be enabled, and keeps hardirqs_enabled off.

ah, so the problem is ftrace doing a function trace entry _in the 
middle_ of the raw-irqs section in __native_flush_tlb_global()? (due 
to the cr4 getting virtualized too)

Nasty, really nasty.

	Ingo
