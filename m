Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbZBMNAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbZBMNAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZBMNAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:00:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:37090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZBMNAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:00:23 -0500
Subject: Re: irq-disabled vs vmap vs text_poke
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: akpm <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090213125505.GE18462@wotan.suse.de>
References: <1234529407.6519.28.camel@twins>
	 <20090213125505.GE18462@wotan.suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Feb 2009 14:02:18 +0100
Message-Id: <1234530138.6519.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 13:55 +0100, Nick Piggin wrote:
> On Fri, Feb 13, 2009 at 01:50:07PM +0100, Peter Zijlstra wrote:
> > Hi,
> > 
> > Ingo got the following splat:

<snip splat>

> > Which points to vunmap() being called with interrupts disabled.
> > 
> > Which made me look at the vmap/vunmap calls, and they appear to not be
> > irq-safe, therefore this would be a bug in text_poke().
> > 
> > [ that is, vmap() can end up calling get_vm_area_caller() which in turn
> >   calls __get_vm_area_node() with GFP_KERNEL, ergo, don't do this from
> >   an atomic context. ]
> > 
> > Now text_poke() uses local_irq_save/restore(), which conveys that it can
> > be called with IRQs disabled, which is exactly what happens in the trace
> > above, however we just established that vmap/vunmap() are not irq-safe.
> > 
> > Anybody got an idea on how to fix this?
> 
> Oh, I thought the consensus was not to use vmap for this?

Seems like a sensible consensus, still that means text_poke() needs some
TLC.

> With a bit of work, we can make vunmap irq-safe with the lazy vunmapping
> infrastructure (vmap could also be irq-safe, but would be subject to
> spurious failures due to being unable to flush lazy vunmaps.

*nod*

> I think I got a mostly working patch cobbled together sitting here
> somewhere. I was waiting for some _really_ good use case before spending
> more time on it. I would prefer if at all possible to do vmap operations
> in sleepable, process context.

Agreed, I think we want to fix text_poke() and make the vmap/vunmap()
ops yell louder at violations of these rules.

I'm just totally clueless wrt text_poke() hence this email ;-)
