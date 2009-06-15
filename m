Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbZFOKq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbZFOKq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZFOKqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:46:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:36417 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbZFOKqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:46:46 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <20090615102737.GA20461@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <1245059859.23207.16.camel@penberg-laptop>
	 <20090615102737.GA20461@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 20:45:27 +1000
Message-Id: <1245062727.12400.23.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 12:27 +0200, Nick Piggin wrote:
> 
> > So from code shuffling point of view, it's better to support
> GFP_KERNEL
> > (almost) everywhere rather than require special annotations.
> 
> Nor this. We require special allocation annotations *everywhere*
> according to context. Why is using GFP_KERNEL for unsleeping
> allocations a good thing if we have GFP_ATOMIC etc?

GFP_ATOMIC is a good point in fact. We -could- make it unnecessary since
we can pretty much tell nowadays whether we are in atomic context or
not.

So where do we put the line ? The subtle differences here are, imho:

 - It's good to discourage allocations in atomic contexts. So requiring
GFP_ATOMIC to some extent helps making people think twice about they are
doing.

 - Code that requires GFP_ATOMIC is generally code that knows pretty
well in which context it's running, because most of the time, it's the
same piece of code or subsystem that is -causing- the context to be
atomic (because it's an interrupt handler or because it used a
spinlock). The case of boot time is subtely different. We have a whole
bunch of things that will be called both at boot time and later, without
necessarily knowing where they have been called from. IE. The call
traces are longer if you want in the typical boot context than in the
typical atomic context.

It all boils down to a fine line to be found here between the two
options, and my gut feeling is that we should keep GFP_ATOMIC explicit,
but avoid the need to provide an explicit API for boot time allocations.

> We could also mask off __GFP_WAIT from allocations when we take
> a spinlock or enter an interrupt, right?

We -could-. Whether we want to is to be debated. Also the overhead of
doing so would be higher I believe.

> Init code doesn't deserve to be more lazy than anybody else, and
> part of the reason why such a core piece of code is so crufty
> is exactly because people have been lazy there.

I think the main problem isn't necessarily init code per se, but the
pile of -common- code that can be called both at init time and later.

Cheers,
Ben.


