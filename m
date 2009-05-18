Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZERTRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZERTRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZERTRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:17:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbZERTRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:17:11 -0400
Date: Mon, 18 May 2009 12:16:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Jeff Garzik <jgarzik@pobox.com>, Alexander Viro <viro@ftp.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <20090518190320.GA20260@elte.hu>
Message-ID: <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
References: <20090518142707.GA24142@elte.hu> <alpine.LFD.2.01.0905180850110.3301@localhost.localdomain> <20090518164921.GA6903@elte.hu> <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu>
 <20090518190320.GA20260@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 May 2009, Ingo Molnar wrote:
> 
> Something like the patch below. It also fixes ->span[] which has a 
> similar problem.

Patch looks good to me.

> But ... i think this needs further clean-ups really. Either go fully 
> static, or go fully dynamic.

I do agree that it would probably be good to try to avoid this static 
allocation, and allocate these data structures dynamically. However, if we 
end up having to use two different allocators anyway (one for bootup, and 
one for regular uptimes), then I think that would be an overall loss 
(compared to just the simplicity of statically doing this in a couple of 
places), rather than an overall win.

> Would be nice if bootmem_alloc() was extended with such properties - 
> if SLAB is up (and bootmem is down) it would return 
> kmalloc(GFP_KERNEL) memory buffers.

I would rather say the other way around: no "bootmem_alloc()" at all, but 
just have a regular alloc() that ends up working like the "SMP 
alternatives" code, but instead of being about SMP, it would be about how 
early in the boot sequence it is.

That said, if there are just a couple of places like this that care, I 
don't think it's worth it. The static allocation isn't that horrible. I'd 
rather have a few ugly static allocations with comments about _why_ they 
look the way they do, than try to over-design things to look "clean".

Simplicity is a good thing - even if it can then end up meaning special 
cases like this.

That said, if we could move the kmalloc initialization up some more (and 
get at least the "boot node" data structures set up, and avoid any bootmem 
alloc issues _entirely_, then that would be good.

I hate that stupid bootmem allocator. I suspect we seriously over-use it, 
and that we _should_ be able to do the SL*B init earlier.

			Linus
