Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbZFOVB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbZFOVB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933513AbZFOVBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:01:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbZFOVBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:01:38 -0400
Date: Mon, 15 Jun 2009 23:01:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615210119.GD24554@elte.hu>
References: <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal> <4A36A1C7.6080005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A36A1C7.6080005@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> Mathieu Desnoyers wrote:
> >>>
> >> Writing control registers is serializing, so it's a lot more expensive
> >> than writing a normal register; my *guess* is that it will be on the
> >> order of 100-200 cycles.
> >>
> >> That is not based on any actual information.
> >>
> > 
> > Then how about just writing to the cr2 register *if* it has changed
> > while the NMI handler was running ?
> > 
> > if (unlikely(read_cr2() != saved_cr2)))
> > 	write_cr2(saved_cr2)
> > 
> > Mathieu
> > 
> 
> That works fine, obviously, and although it's probably overkill 
> it's also a trivially cheap optimization.

Writing cr2 costs 84 cycles so it's not overkill at all - it's a 
nice optimization!

Btw., we dont have to re-read it - we actually _know_ when we got a 
fault (the fault handler gives us back an error code).

So we can do this common optimization and avoid the cr2 write 
usually. We only need the cr2 read.

Hm, tempting ...

	Ingo
