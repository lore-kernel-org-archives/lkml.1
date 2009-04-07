Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZDGMQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZDGMQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZDGMQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:16:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60348 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZDGMQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:16:26 -0400
Date: Tue, 7 Apr 2009 14:14:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
Message-ID: <20090407121457.GC11641@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org> <20090407053739.GA10500@elte.hu> <1239083045.22733.383.camel@macbook.infradead.org> <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu> <1239084280.22733.404.camel@macbook.infradead.org> <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu> <20090407090229.GA2467@elte.hu> <1239104035.22733.443.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239104035.22733.443.camel@macbook.infradead.org>
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


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2009-04-07 at 11:02 +0200, Ingo Molnar wrote:
> > for_each_active_iommu() and for_each_iommu() uses some tricky
> > C that is weird and borderline valid but does not allow the
> > macro evaluation trick used by the branch tracer/profiler:
> > 
> >    drivers/pci/intr_remapping.c:680:28: error: macro "if" passed 2
> > arguments, but takes just 1
> > 
> > Switch it to a braced group statement.
> 
> It doesn't even need the braces -- just putting simple parens 
> around the comma-expression would have sufficed (that was Andrew's 
> attempt).
> 
> But it's a workaround, not a fix -- if we're going to #define if() 
> then we should damn well make it transparent, and not have to work 
> around breakage in arbitrary places.

Well, i consider it a feature that it flags weird if (x, y) 
constructs: and yes, these iterators you introduced, while they are 
legit C, definitely count as 'weird'. If regular code was doing it, 
not a loop abstraction, i'd call it non-obvious and borderline 
broken straight away.

We should _never ever_ put comma statements into if () constructs 
without a _really_ good reason - and if yes, we can flag that we 
know what we are doing, via extra parentheses.

> Hence the patch I sent to Linus last night, which fixes it in the 
> _right_ place:
> 	http://marc.info/?l=linux-kernel&m=123907505308502&w=2

I dont think that's the right fix for the reason above - all the 
places where the branch-profiler 'broke' the build before were 
genuinely weird pieces of code that needed fixing.

	Ingo
