Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYFJDSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYFJDSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 23:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYFJDS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 23:18:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33570 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753940AbYFJDS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 23:18:26 -0400
Date: Mon, 9 Jun 2008 20:18:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <200806101256.31615.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0806092012240.13024@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <200806100927.48597.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0806091651390.9749@schroedinger.engr.sgi.com>
 <200806101256.31615.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Rusty Russell wrote:

> > Right that is what the cpu alloc patches do. So you could implement
> > cpu_local_inc on top of some of the cpu alloc patches.
> 
> Or you could just implement it today as a standalone patch.

You need at least the zero basing to enable the use of the segment 
register on x86_64.

> > But then the whole point of local_t is gone. Why not use atomic_t in the
> > first place?
> 
> Because some archs can do better.

The argument does not make any sense. First you want to use atomic_t then 
not?

> > > By definition if the caller cared, they would have had premption
> > > disabled.
> >
> > There are numerous instances where the caller does not care about
> > preemption. Its just important that one per cpu counter is increment in
> > the least intrusive way. See f.e. the VM event counters.
> 
> Yes, and that's exactly the point.  The VM event counters are exactly a case 
> where you should have used cpu_local_inc.

I tried it and did not give any benefit except first failing due to bugs 
because local_t did not disable preempt6... This led to Andi fixing 
local_t.

But with the preempt disabling I could not discern what the benefit 
would be.

CPU_INC does not require disabling of preempt and the cpu alloc patches 
shorten the code sequence to increment a VM counter significantly.

Here is the header from the patch. How would cpu_local_inc be able to do 
better unless you adopt this patchset and add a shim layer?

Subject: VM statistics: Use CPU ops

The use of CPU ops here avoids the offset calculations that we used to 
have to do with per cpu operations. The result of this patch is that event 
counters are coded with a single instruction the following way:

        incq   %gs:offset(%rip)

Without these patches this was:

        mov    %gs:0x8,%rdx
        mov    %eax,0x38(%rsp)
        mov    xxx(%rip),%eax
        mov    %eax,0x48(%rsp)
        mov    varoffset,%rax
        incq   0x110(%rax,%rdx,1)


