Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZBNJ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZBNJ4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 04:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZBNJ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 04:56:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:51001 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZBNJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 04:56:21 -0500
Subject: Re: [PATCH] mm: disable preemption in apply_to_pte_range
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4995ACD5.9000201@goop.org>
References: <4994BCF0.30005@goop.org>	<4994C052.9060907@goop.org>
	 <20090212165539.5ce51468.akpm@linux-foundation.org>
	 <4994CF35.60507@goop.org> <1234525710.6519.17.camel@twins>
	 <4995ACD5.9000201@goop.org>
Content-Type: text/plain
Date: Sat, 14 Feb 2009 10:56:01 +0100
Message-Id: <1234605361.4698.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 09:24 -0800, Jeremy Fitzhardinge wrote:
> Peter Zijlstra wrote:
> >> The specific rules are that 
> >> arch_enter_lazy_mmu_mode()/arch_leave_lazy_mmu_mode() require you to be 
> >> holding the appropriate pte locks for the ptes you're updating, so 
> >> preemption is naturally disabled in that case.
> >>     
> >
> > Right, except on -rt where the pte lock is a mutex.
> >   
> 
> Hm, that's interesting.  The requirement isn't really "no preemption", 
> its "must not migrate to another cpu".  Is there a better way to express 
> that?

Not really, in the past something like migrate_disable() has been
proposed, however that's problematic in that it can generate latencies
that are _very_ hard to track down, so we've always resisted that and
found other ways.

> >> This all goes a bit strange with init_mm's non-requirement for taking 
> >> pte locks.  The caller has to arrange for some kind of serialization on 
> >> updating the range in question, and that could be a mutex.  Explicitly 
> >> disabling preemption in enter_lazy_mmu_mode would make sense for this 
> >> case, but it would be redundant for the common case of batched updates 
> >> to usermode ptes.
> >>     
> >
> > I really utterly hate how you just plonk preempt_disable() in there
> > unconditionally and without very clear comments on how and why.
> >   
> 
> Well, there's the commit comment.  They're important, right?  That's why 
> we spend time writing good commit comments?  So they get read?  ;)

Andrew taught me that indeed, but still when looking at the code its
good to have some text there explaining things too.

