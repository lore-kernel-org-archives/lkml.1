Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYE3FSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYE3FSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYE3FR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:17:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47452 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751132AbYE3FR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:17:56 -0400
Date: Thu, 29 May 2008 22:17:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <20080529215844.609a3ac8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805292214280.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080530040011.727424512@sgi.com>
 <20080529215844.609a3ac8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> > 	local_irq_save(flags);
> > 	/* Calculate address of per processor area */
> > 	p = CPU_PTR(stat, smp_processor_id());
> > 	p->counter++;
> > 	local_irq_restore(flags);
> 
> eh?  That's what local_t is for?

No that is what local_t exactly cannot do.

> > The segment can be replaced by a single atomic CPU operation:
> > 
> > 	CPU_INC(stat->counter);
> 
> hm, I guess this _has_ to be implemented as a macro.  ho hum.  But
> please: "cpu_inc"?

A lowercase macro?

> > The existing methods in use in the kernel cannot utilize the power of
> > these atomic instructions. local_t is not really addressing the issue
> > since the offset calculation performed before the atomic operation. The
> > operation is therefor not atomic. Disabling interrupt or preemption is
> > required in order to use local_t.
> 
> Your terminology is totally confusing here.
> 
> To me, an "atomic operation" is one which is atomic wrt other CPUs:
> atomic_t, for example.
> 
> Here we're talking about atomic-wrt-this-cpu-only, yes?

Right.
 
> > local_t is also very specific to the x86 processor.
> 
> And alpha, m32r, mips and powerpc, methinks.  Probably others, but
> people just haven't got around to it.

No local_t does not do the relocation of the address to the correct percpu 
area. It requies disabling of interrupts etc. Its not atomic (wrt 
interrupts) because of that.
 
> I think I'll need to come back another time to understand all that ;)
> 
> Thanks for writing it up carefully.

Well this stuff is so large in scope that I have difficulties keeping 
everything straight.

> I wonder if all this stuff should be in a new header file.
> 
> We could get lazy and include that header from percpu.h if needed.

But then its related to percpu operations and relies extensively on the 
various percpu.h files in asm-generic and asm-arch and include/linux

