Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbZCYMfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbZCYMfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756712AbZCYMff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:35:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZCYMfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:35:34 -0400
Date: Wed, 25 Mar 2009 13:35:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/6] perf_counter: kerneltop: mmap_pages argument
Message-ID: <20090325123514.GB28639@elte.hu>
References: <20090325113021.781490788@chello.nl> <20090325113317.104545398@chello.nl> <20090325121811.GC11571@elte.hu> <1237984033.7972.865.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237984033.7972.865.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2009-03-25 at 13:18 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > provide a knob to set the number of mmap data pages.
> > 
> > > +	" -m pages  --mmap_pages=<pages> # number of mmap data pages\n"
> > 
> > Btw., we really want this to be auto-tuning to a large degree. If 
> > the kernel observes missed events, it should create a 
> > PERF_EVENT_OVERFLOW==0x3 record, with the number of missed events - 
> > or something like that.
> 
> Well, who's to say we ever see that overflow record if we're 
> having trouble tracking the output as is?

it would overwrite the last (new) record - so it's deterministic and 
the tail does not consume the head - just bites itself a bit.

But it would still be somewhat racy, if user-space _just_ managed to 
process those records ...

> How important is it for people to have accurate overflow 
> information other than the current -- we can't keep up -- kind?

it's somewhat important and could pave the way for the kernel to 
react to overflow more intelligently (via iterim buffering or 
whatever future mechanism).

It's also a general quality of implementation principle for kernel 
code: if we want to hide information we want to hide it from 
_user-space_, not the kernel. Hiding information from the kernel 
almost always causes trouble down the line.

> One possible solution is making the control page writable and 
> writing the userspace read position to it, then the kernel can, on 
> perf_output_begin() detect the overflow and count the number of 
> overwritten events.
> 
> This overflow count could then be published back into the control 
> page.

Ok, that's a nice idea - it keeps the amount of dirty cachelines 
minimal.

> TBH I'm not much of a fan, making all these pages writable just 
> opens a whole can of worms, and that accurate overflow tracking 
> will put more code in the output path.

What can of worms can you see there? (It would not be COW-ed - if 
you share those pages without knowing that they are shared then 
confused user-space will have to keep broken pieces of iteself.)

> Also, when mixing streams (events,mmap) is a single: you missed 
> 'n' events still good?

How would such mixing work? Multiple counters streaming into the 
same mmap area?

	Ingo
