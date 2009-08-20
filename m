Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZHTK2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZHTK2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZHTK2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:28:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbZHTK2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:28:10 -0400
Date: Thu, 20 Aug 2009 12:28:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
Message-ID: <20090820102800.GD29093@elte.hu>
References: <20090819091823.916851355@chello.nl> <20090819092023.980284148@chello.nl> <19083.61914.571806.395197@cargo.ozlabs.ibm.com> <1250686586.8282.12.camel@twins> <7c86c4470908200313l112a8ff6q836d618d7ce6fcc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470908200313l112a8ff6q836d618d7ce6fcc8@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> On Wed, Aug 19, 2009 at 2:56 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> > On Wed, 2009-08-19 at 22:36 +1000, Paul Mackerras wrote:
> >> Peter Zijlstra writes:
> >>
> >> > Provide the ability to configure a counter to send 
> >> > its output to another (already existing) counter's 
> >> > output stream.
> >>
> >> What sort of thing might this be useful for?
> >
> > Some people complained that its tedious to mmap() for 
> > every counter and would like to share the mmap() 
> > output buffer between counters.
> >
> 
> > This saves on address space and mlock budget and I 
> > guess fd management logic.
>
> Interesting to see, you seem to have changed your mind 
> on this. I recall pointing this out in my early 
> comments.

Btw., did we strongly oppose the notion? The mmap output 
buffers were always multi-event in essence - just by 
virtue of the automatic events such as task creation, 
mmap, etc.

> But anyway, here are some more comments:
> 
>    - how does this work with the remapped counts?
>      Probably only see the count for the target, i.e., 
>      output, event

if you want to recover the momentary index for RDPC you 
need to mmap the counter(s) you are interested in, to get 
to the header->index value.

So you can create these counters with 1 pages only (one 
is the header) - and then remap the output to the primary 
counter's output buffer.

>    - if samples from multiple events end up in the same 
>      buffer, how do I tell them apart, i.e., how do I 
>      know sample X came from event A, sample X from 
>      event B? This may be useful to detect patterns.

Via PERF_SAMPLE_ID. That saves the counter ID into the 
event so it can be demultiplexed later on.

	Ingo
