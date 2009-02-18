Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZBRQ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZBRQ7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZBRQ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:58:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZBRQ6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:58:50 -0500
Date: Wed, 18 Feb 2009 17:58:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
	single ipi fallback for smp_call_function_many())
Message-ID: <20090218165808.GA9120@elte.hu>
References: <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de> <20090217192810.GA4980@redhat.com> <20090217213256.GJ6761@linux.vnet.ibm.com> <20090217214518.GA13189@redhat.com> <20090217223910.GM6761@linux.vnet.ibm.com> <20090218135212.GB23125@wotan.suse.de> <alpine.LFD.2.00.0902180744520.21686@localhost.localdomain> <20090218162116.GC29863@elte.hu> <alpine.LFD.2.00.0902180828430.21686@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902180828430.21686@localhost.localdomain>
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

> On Wed, 18 Feb 2009, Ingo Molnar wrote:
> > 
> > But ... WRMSR should already be serializing - it is documented 
> > as a serializing instruction.
> 
> Hmm. I was thinking about this some more, and I think I've 
> come up with an explanation.
> 
> "wrmsr" probably serializes _after_ doing the write. After 
> all, it's historically used for changing internal CPU state, 
> so you want to do the write, and then wait until the effects 
> of the write are "stable" in the core.
> 
> That would explain how x2apic can use both a serializing 
> instruction (wrmsr) and still effectively cause the IPI to 
> happen out of sequence: the IPI can reach the destination CPU 
> before the source CPU has flushed its store buffers, because 
> the IPI is actually sent before serializing the core.
> 
> But I would very strongly put this in the "x2apic code bug" 
> column. If this is a true issue (and your TLB patch does imply 
> it is), then we should just make sure that the x2apic IPI 
> calls always do a 'sfence' before they happen - regardless of 
> whether they are for TLB flushes or for generic kernel 
> cross-calls, or for anything else.

Yeah, that makes perfect sense. IPIs are an out of band 
signalling mechanism that do not listen to the normal cache 
coherency rules.

Moving the smp_mb() to the x2apic specific code will also speed 
up the normal mmio-mapped IPI sequence a bit. It should be an 
smp_wmb() i suspect - which turns it into an sfence.

	Ingo
