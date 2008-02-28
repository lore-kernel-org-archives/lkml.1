Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbYB1Cnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbYB1Cnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 21:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYB1Cnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 21:43:43 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46252 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752756AbYB1Cnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 21:43:42 -0500
Date: Wed, 27 Feb 2008 18:43:39 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <20080227175726.ad6bda9d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802271836270.17162@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
 <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
 <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
 <20080219200852.GC11197@Krystal> <Pine.LNX.4.64.0802271532220.14380@schroedinger.engr.sgi.com>
 <20080227175726.ad6bda9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Andrew Morton wrote:

> Doing ++ on a u32 _is_ atomic wrt interrupts on x86 and probably lots of
> other architectures, so we're OK using unsigned there.  But on some other
> architectures ++ on u32 is not atomic wrt interrutps, so they should use
> atomic_t or some other arch-specific mechanism.
> 
> And guess what?  It's already all been done: local_t.

local_t requires the disabling of preempt to work right.

The real solution here is cpu_alloc / cpu_ops. Per cpu operations work on 
an offset relative to the start of the per process cpu data area in some 
register. An increment can then be atomic vs. interrupt because it does 
the calculation of the address and the inc in one instruction. F.e.

gs: inc [percpu_offset]

Processor may change before and after without ill effects. So no preempt 
since the instruction will always reference the %%gs register that points 
to the percpu area of the currently executing processor.
