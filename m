Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZDNRQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZDNRQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDNRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:15:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZDNRPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:15:50 -0400
Date: Tue, 14 Apr 2009 19:12:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
	default percpu allocator
Message-ID: <20090414171242.GA4241@elte.hu>
References: <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <alpine.DEB.1.10.0904012216370.32656@qirst.com> <20090402034223.GA25791@elte.hu> <alpine.DEB.1.10.0904020948570.31756@qirst.com> <20090408162651.GA14449@elte.hu> <alpine.DEB.1.10.0904131409510.13756@qirst.com> <20090414140416.GE27163@elte.hu> <alpine.DEB.1.10.0904141233420.15948@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904141233420.15948@qirst.com>
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


* Christoph Lameter <cl@linux.com> wrote:

> On Tue, 14 Apr 2009, Ingo Molnar wrote:
> 
> > The thing is, i spent well in excess of an hour analyzing your
> > patch, counting cachelines, looking at effects and interactions,
> > thinking about the various implications. I came up with a good deal
> > of factoids, a handful of suggestions and a few summary paragraphs:
> >
> >   http://marc.info/?l=linux-kernel&m=123862536011780&w=2
> 
> Good work.
> 
> > A proper reply to that work would be one of several responses:
> >
> 
> ...
> 
> >
> >   3) agree with the factoids and disagree with my opinion.
> 
> Yep I thought that what I did...

Ok, thanks ... since i never saw a reply from you on that 
mail so i couldnt assume you did so.

There's really 3 key observations in that mail - let me sum 
them up in order of importance.

1)

I'm wondering what your take on the bss+data suggestion is. 
To me it appears it's tempting to merge them into a single 
per .o section: it clearly wins us locality of reference.

It seems so obvious to do to me on a modern SMP kernel - has 
anyone tried that in the past?

Instead of:

  .data1 .data2 .data3   .... .bss1 .bss2 .bss3

we'd have:

  .databss1 .databss2 .databss3

This is clearly better compressed, and the layout is easier 
to control in the .c file. We could also do tricks to 
further compress data here: we could put variables right 
after their __aligned__ locks - while currently they are in 
the .bss wasting a full cache-line.

In the example i analyzed it would reduce the cache 
footprint by one cacheline. This would apply to most .o's so 
the combined effect on cache locality would be significant.

[ Another (sub-)advantage would be that it 'linearizes' and 
  hence properly colors the per .o module variable layout. 
  With an artificially split .data1 .bss1 the offset between 
  them is random, and it's harder to control the cache port
  positions of closely related variables. ]

2)

Aligning (the now merged) data+bss per .o section on 
cacheline boundary [up to 64 byte cacheline sizes or so] 
sounds tempting as well - it eliminates accidental "tail 
bites the next head" type of cross-object-file interactions. 

The price is an estimated 3% blow-up in combined .data+bss 
size. A suspect a patch and measurements would settle this 
pretty neatly.

3)

The free_percpu() collateral-damage argument i made was 
pretty speculative (and artificial as well - the allocation 
of percpu resources is very global in nature so a 
kfree(NULL)-alike fastpath is harder to imagine) - i tried 
at all costs demonstrate my point based on that narrow 
example alone.

Thanks,

	Ingo
