Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbZFMVLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbZFMVLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763000AbZFMVLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:11:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34560 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759716AbZFMVLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:11:30 -0400
Date: Sat, 13 Jun 2009 22:56:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
Message-ID: <20090613205611.GA21498@elte.hu>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com> <alpine.LFD.2.01.0906131312470.3237@localhost.localdomain> <alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906131323270.3237@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 13 Jun 2009, Linus Torvalds wrote:
> > 
> > On Sat, 13 Jun 2009, Paul Mackerras wrote:
> > >
> > > Linus, Andrew: OK if this goes in via the powerpc tree?
> > 
> > Ok by me.
> 
> Btw, do 32-bit architectures really necessarily want 64-bit 
> performance counters?
> 
> I realize that 32-bit counters will overflow pretty easily, but I 
> do wonder about the performance impact of doing things like hashed 
> spinlocks for 64-bit counters. Maybe the downsides of 64-bit perf 
> counters on such architectures might outweight the upsides?

We account all sorts of non-hw bits via atomic64_t as well - for 
example time related counters in nanoseconds - which wrap 32 bits at 
4 seconds.

There's also security/stability relevant bits:

        counter->id             = atomic64_inc_return(&perf_counter_id);

We dont really want that ID to wrap ever - it could create a leaking 
of one PMU context into another. (We could rewrite it by putting a 
global lock around it, but still - this is a convenient primitive.)

In select places we might be able to reduce the use of atomic64_t 
(that might make performance sense anyway) - but to get rid of all 
of them would be quite painful. We initially started with a 32-bit 
implementation and it was quite painful with fast-paced units.

So since Paul has already coded the wrappers up ... i'd really 
prefer that, unless there's really compelling reasons not to do it.

	Ingo
