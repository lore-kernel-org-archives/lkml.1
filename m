Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZHULhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZHULhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZHULhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:37:53 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:52000 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbZHULhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:37:52 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:tracing/urgent] tracing: Fix too large stack usage in
 do_one_initcall()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org,
       catalin.marinas@arm.com, jens.axboe@oracle.com, fweisbec@gmail.com,
       stable@kernel.org, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20090821111450.GA32037@elte.hu>
References: <tip-4a683bf94b8a10e2bb0da07aec3ac0a55e5de61f@git.kernel.org>
	 <20090821111450.GA32037@elte.hu>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 13:37:33 +0200
Message-Id: <1250854653.7538.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 13:14 +0200, Ingo Molnar wrote:

> > There's a lot of fat functions on that stack trace, but
> > the largest of all is do_one_initcall(). This is due to
> > the boot trace entry variables being on the stack.
> > 
> > Fixing this is relatively easy, initcalls are fundamentally
> > serialized, so we can move the local variables to file scope.
> > 
> > Note that this large stack footprint was present for a
> > couple of months already - what pushed my system over
> > the edge was the addition of kmemleak to the call-chain:
> > 
> >   6)     3328      36   allocate_slab+0xb1/0x100
> >   7)     3292      36   new_slab+0x1c/0x160
> >   8)     3256      36   __slab_alloc+0x133/0x2b0
> >   9)     3220       4   kmem_cache_alloc+0x1bb/0x1d0
> >  10)     3216     108   create_object+0x28/0x250
> >  11)     3108      40   kmemleak_alloc+0x81/0xc0
> >  12)     3068      24   kmem_cache_alloc+0x162/0x1d0
> >  13)     3044      52   scsi_pool_alloc_command+0x29/0x70
> > 
> > This pushes the total to ~3800 bytes, only a tiny bit
> > more was needed to corrupt the on-kernel-stack thread_info.
> > 
> > The fix reduces the stack footprint from 572 bytes
> > to 28 bytes.
> 
> btw., it will just take two more features like kmemleak to trigger 
> hard to debug stack overflows again on 32-bit. We are right at the 
> edge and this situation is not really fixable in a reliable way 
> anymore.
> 
> So i think we should be more drastic and solve the real problem: we 
> should drop 4K stacks and 8K combo-stacks on 32-bit, and go 
> exclusively to 8K split stacks on 32-bit.
> 
> I.e. the stack size will be 'unified' too between 64-bit and 32-bit 
> to a certain degree: process stacks will be 8K on both 64-bit and 
> 32-bit x86, IRQ stacks will be separate. (on 64-bit we also have the 
> IST stacks for certain exceptions that further isolates things)
> 
> This will simplify the 32-bit situation quite a bit and removes a 
> contentious config option and makes the kernel more robust in 
> general. 8K combo stacks are not safe due to irq nesting and 4K 
> isolated stacks are not enough. 8K isolated stacks is the way to go.
> 
> Opinions?

I'm obviously all in favour of merging the i386 and x86_64 stack code.
Esp after having had to look at the i386 stuff recently.

Now I don't think that unifying all this requires the sizes to be the
same between them, because x86_64 typically has larger stack footprint
due to it being 64 bit. If we need to bump 32 bit stack sizes, then
we're likely to also need a bump in 64 bit as well at some point soon.


