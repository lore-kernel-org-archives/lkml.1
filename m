Return-Path: <linux-kernel-owner+w=401wt.eu-S1762825AbYBTCL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762825AbYBTCL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYBTCLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:11:22 -0500
Received: from mga05.intel.com ([192.55.52.89]:22211 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756463AbYBTCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:11:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,379,1199692800"; 
   d="scan'208";a="521343338"
Subject: Re: Linux 2.6.25-rc2
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <1203467785.3248.42.camel@ymzhang>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <20080219061107.GA23229@elte.hu>
	 <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
	 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
	 <20080219140230.GA32236@Krystal>
	 <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
	 <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com>
	 <20080219145554.GE21176@elte.hu>  <47BAFB42.9000806@cs.helsinki.fi>
	 <1203467785.3248.42.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Wed, 20 Feb 2008 10:08:59 +0800
Message-Id: <1203473339.3248.45.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-20 at 08:36 +0800, Zhang, Yanmin wrote:
> On Tue, 2008-02-19 at 17:52 +0200, Pekka Enberg wrote:
> > Ingo Molnar wrote:
> > > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > > 
> > >>> Yes, this can happen. Are you saying it is not safe to be in the 
> > >>> lockless path when an IRQ triggers?
> > >> Hmm. The barrier() in slab_free() looks fishy. The comment says it's 
> > >> there to make sure we've retrieved c->freelist before c->page but then 
> > >> it uses a _compiler barrier_ which doesn't affect the CPU and the 
> > >> reads may still be re-ordered... Not sure if that matters here though.
> > > 
> > > find a fix patch for that below - most systems affected seem to be SMP 
> > > ones.
> > > 
> > > If this (or my other patch) indeed solves the problem i'd still favor a 
> > > full revert of the SLUB_FASTPATH (commit 1f84260c8ce3b1ce26d4), it looks 
> > > quite un-cooked and quite un-tested for multiple independent reasons.
> > > 
> > > Sigh, why do i again have to be the messenger who brings the bad news to 
> > > SLUB land, and again when poor Christoph went on vacation? :-/
> > > 
> > > 	Ingo
> > > 
> > > -------------------------->
> > > Subject: SLUB: barrier fix
> > > From: Ingo Molnar <mingo@elte.hu>
> > > 
> > > ---
> > >  mm/slub.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > Index: linux/mm/slub.c
> > > ===================================================================
> > > --- linux.orig/mm/slub.c
> > > +++ linux/mm/slub.c
> > > @@ -1862,7 +1862,7 @@ static __always_inline void slab_free(st
> > >  	debug_check_no_locks_freed(object, s->objsize);
> > >  	do {
> > >  		freelist = c->freelist;
> > > -		barrier();
> > > +		smp_mb();
> > >  		/*
> > >  		 * If the compiler would reorder the retrieval of c->page to
> > >  		 * come before c->freelist then an interrupt could
> > 
> > Torsten/Yamin, does this fix things for you? What about reverting commit 
> > 1f84260c8ce3b1ce26d4c1d6dedc2f33a3a29c0c ("SLUB: Alternate fast paths 
> > using cmpxchg_local")?
> I'm busy in another issue and will test it ASAP. Sorry.
I tested it on my 3 x86-64 machines. The small fix to use smp_mb to replace
barrier in slab_free doesn't work. Kernel still crashed at the same place.

I will test the reverting patch.

-yanmin


