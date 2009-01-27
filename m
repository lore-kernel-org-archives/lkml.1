Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbZA0Mq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbZA0Mq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 07:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZA0Mqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 07:46:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbZA0Mqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 07:46:47 -0500
Date: Tue, 27 Jan 2009 13:46:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ed Swierk <eswierk@aristanetworks.com>, rml@tech9.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix BUG: using smp_processor_id() in preemptible code
	in print_fatal_signal()
Message-ID: <20090127124618.GA23121@elte.hu>
References: <1233010818.14510.11.camel@localhost.localdomain> <20090126231555.GB6556@elte.hu> <1233012811.14510.18.camel@localhost.localdomain> <20090126233732.GA23128@elte.hu> <20090127004124.GA10632@redhat.com> <1233020040.14510.121.camel@localhost.localdomain> <20090127030237.GA14108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127030237.GA14108@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/26, Ed Swierk wrote:
> >
> > On Tue, 2009-01-27 at 01:41 +0100, Oleg Nesterov wrote:
> > > Ed, Ingo, but isn't it better to just use raw_smp_processor_id() in
> > > __show_regs() ? This is only debug info, the printed CPU doesn't
> > > have the "exact" meaning.
> >
> > I guess it doesn't really matter which CPU the signal handling thread 
> > happened to be running on, but are there other situations where 
> > show_regs() is always expected to print the correct CPU (and if not, 
> > why bother printing the CPU at all)?  Disabling preemption here seems 
> > the safest approach and doesn't add much overhead.
> 
> OK.
> 
> > > And, without the comment, it is not easy to see why print_fatal_signal()
> > > disables preeemption before show_regs().
> >
> > Agreed; here's an updated patch.
> 
> Actually, now I think show_regs() has other reasons to run with the 
> preemption disabled, __show_regs() does read_crX()/etc, I guess it is 
> better to stay on the same CPU throughout.
> 
> So, Ed, I am sorry for noise.

another reason why it's good to run it with preemption disabled is that 
whatever context does show_regs() ought to be non-preemptible as it deals 
with CPU local details.

In the fatal-signals case we indeed have a "it does not really matter" 
boundary case, but in most of the other uses we want to be non-preemptible 
in debug contexts, and want a constant reminder in terms of 
smp_processor_id() warnings if that expectation is not met.

	Ingo
