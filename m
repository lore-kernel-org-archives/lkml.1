Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZBXC4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZBXC4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 21:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZBXC4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 21:56:32 -0500
Received: from ozlabs.org ([203.10.76.45]:53770 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbZBXC4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 21:56:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Date: Tue, 24 Feb 2009 13:26:22 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com, mingo@elte.hu,
       tony.luck@intel.com
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <200902192221.52835.rusty@rustcorp.com.au> <499E1D01.2040408@kernel.org>
In-Reply-To: <499E1D01.2040408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241326.23605.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 13:31:21 Tejun Heo wrote:
> >    One question.  Are you thinking that to be defined by every SMP arch
> > long-term?
> 
> Yeap, definitely.

Excellent.  That opens some really nice stuff.

> > Because there are benefits in having &<percpuvar> == valid
> > percpuptr, such as passing them around as parameters.  If so, IA64
> > will want a dedicated per-cpu area for statics (tho it can probably
> > just map it somehow, but it has to be 64k).
> 
> Hmmm...  Don't have much idea about ia64 and its magic 64k.  Can it
> somehow be used for the first chunk?

Yes, but I think that chunk must not be handed out for dynamic allocations
but kept in reserve for modules.

IA64 uses a pinned TLB entry to map this cpu's 64k at __phys_per_cpu_start.
See __ia64_per_cpu_var() in arch/ia64/include/asm/percpu.h.  This means they
can also optimize cpu_local_* and read_cpuvar (or whatever it's called now).
IIUC IA64 needs this region internally, using it for percpu vars is a bonus.

> > These pseudo-constants seem like a really weird thing to do to me.
> 
> I explained this in the reply to Andrew's comment.  It's
> non-really-constant-but-should-be-considered-so-by-users thing.  Is it
> too weird?  Even if I add comment explaning it?

It's weird; I'd make them __read_mostly and be done with it.

> > rbtree might be overkill on first cut.  I'm bearing in mind that Christoph L
> > had a nice patch to use dynamic percpu allocation in the sl*b allocators;
> > which would mean this needs to only use get_free_page.
> 
> Hmmm... the reverse mapping can be piggy backed on vmalloc by adding a
> private pointer to the vm_struct but rbtree isn't too difficult to use
> so I just did it directly.  Nick, what do you think about adding
> private field to vm_struct and providing a reverse map function?

Naah, just walk the arrays to do the mapping.  Cuts a heap of code, and
we can optimize when someone complains :)

Walking arrays is cache friendly, too.

> As for the sl*b allocation thing, can you please explain in more
> detail or point me to the patches / threads?

lkml from 2008-05-30:

Message-Id: <20080530040021.800522644@sgi.com>:
Subject: [patch 32/41] cpu alloc: Use in slub
And:
Subject: [patch 33/41] cpu alloc: Remove slub fields
Subject: [patch 34/41] cpu alloc: Page allocator conversion

> Thanks.  :-)

Don't thank me: you're doing all the work!
Rusty.
