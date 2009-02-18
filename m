Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZBRQYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZBRQYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBRQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:23:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50354 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbZBRQXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:23:49 -0500
Date: Wed, 18 Feb 2009 17:23:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
Message-ID: <20090218162321.GA32743@elte.hu>
References: <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de> <alpine.LFD.2.00.0902180812500.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902180812500.21686@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 18 Feb 2009, Nick Piggin wrote:
> > > 
> > > x2apic register reads/writes don't have serializing semantics, as
> > > opposed to uncached xapic accesses, which are inherently serializing.
> > > 
> > > With this patch, we need to fix the corresponding x2apic IPI operations.
> > > I will take a look at it.
> > 
> > You're saying the problem is in generic_exec_single because I've
> > removed the smp_mb that inadvertently also serialises memory with
> > the x2apic on x86?
> 
> I think Suresh is wrong on this.
> 
> The x2apic is using "wrmsr" to write events, and that's a 
> serializing instruction.
> 
> I really don't know of any way to get unordered information 
> out of a x86 core, except for playing games with WC memory, 
> and WC memory would not be appropriate for something like an 
> interrupt controller.
> 
> Of course, it's possible that Intel made the x2apic MSR's 
> magic, and that they don't serialize, but that's very much 
> against some very explicit Intel documentation. wrmsr is one 
> of the (few) instructions that is mentioned all ove the 
> documentation as being serializing.

heh, i just went through all those codepaths to figure out the 
SMP ordering semantics. I didnt find anything but the MSR write, 
so maybe the MSR writes did get weakened on certain CPUs.

Serializing is a serious performance penalty - and it would not 
be totally out of question to optimize xAPIC MSR accesses. If 
that's the case it's not quite nice to not document it though.

	Ingo
