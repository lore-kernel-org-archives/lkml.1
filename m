Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbYH0Kle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbYH0Kle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYH0KlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:41:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:40009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYH0KlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:41:21 -0400
Subject: Re: [PATCH v2 3/6] sched: make double-lock-balance fair
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com
In-Reply-To: <20080827102646.GA5818@wotan.suse.de>
References: <20080826173131.16413.17862.stgit@dev.haskins.net>
	 <20080826173500.16413.40514.stgit@dev.haskins.net>
	 <1219825295.6462.54.camel@twins>  <20080827102646.GA5818@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 12:41:08 +0200
Message-Id: <1219833668.6462.72.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 12:26 +0200, Nick Piggin wrote:
> On Wed, Aug 27, 2008 at 10:21:35AM +0200, Peter Zijlstra wrote:

> > I suppose one could then write it like:
> > 
> >   if (spin_is_contended(&this_rq->lock) || !spin_trylock(&busiest->lock)) {
> >     spin_unlock(&this_rq->lock);
> >     double_rq_lock(this_rq, busiest);
> >   }
> > 
> > But, I'm not sure that's worth the effort at that point..
> 
> Yeah, that could work, but hmm it might cause 2 cache coherency transactions
> anyway even in the fastpath, so it might even be slower than just unlocking
> unconditionally and taking both locks :(

right,..

> > Anyway - I think all this is utterly defeated on CONFIG_PREEMPT by the
> > spin with IRQs enabled logic in kernel/spinlock.c.
> > 
> > Making this an -rt only patch...
> 
> Hmm, and also on x86 with ticket locks we don't spin with preempt or
> interrupts enabled any more (although we still do of course on other
> architectures)

Aah, we don't do CONFIG_GENERIC_LOCKBREAK anymore?

Does it make sense to make this _double_lock_balance() thing depend on
that too?

