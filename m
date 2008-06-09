Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYFISom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYFISom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYFISob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:44:31 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52502 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750728AbYFISoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:44:30 -0400
Date: Mon, 9 Jun 2008 11:44:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
In-Reply-To: <4848CC22.6090109@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0806091136410.30727@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org>
 <4846AFCF.30500@sgi.com> <4848CC22.6090109@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Eric Dumazet wrote:

> Please forgive me if I beat a dead horse, but this percpu stuff
> should find its way.

Definitely and its very complex so any more eyes on this are appreciated.

> I wonder why you absolutely want to have only one chunk holding
> all percpu variables, static(vmlinux) & static(modules)
> & dynamically allocated.
> 
> Its *not* possible to put an arbitrary limit to this global zone.
> You'll allways find somebody to break this limit. This is the point
> we must solve, before coding anything.

The problem is that offsets relative to %gs or %fs are limited by the 
small memory model that is chosen. We cannot have an offset large than 
2GB. So we must have a linear address range and cannot use separate chunks 
of memory. If we do not use the segment register then we cannot do atomic 
(wrt interrupt) cpu ops.

> Have you considered using a list of fixed size chunks, each chunk
> having its own bitmap ?

Mike has done so and then I had to tell him what I just told you.

> On x86_64 && NUMA we could use 2 Mbytes chunks, while
> on x86_32 or non NUMA we should probably use 64 Kbytes.

Right that is what cpu_alloc v2 did. It created a virtual mapping and 
populated it on demand with 2MB PMD entries.

> I understand you want to offset percpu data to 0, but for
> static percpu data. (pda being included in, to share %gs)
> 
> For dynamically allocated percpu variables (including modules
> ".data.percpu"), nothing forces you to have low offsets,
> relative to %gs/%fs register. Access to these variables
> will be register indirect based anyway (eg %gs:(%rax) )

The relative to 0 stuff comes in at the x86_64 level because we want to 
unify pda and percpu accesses. pda access have been relative to 0 and in 
particular the stack canary in glibc directly accesses the pda at a 
certain offset. So we must be zero based in order to preserve 
compatibility with glibc. 

> Chunk 0 would use normal memory (no vmap TLB cost), only next ones need vmalloc().

Normal memory uses 2MB tlbs. There is no overhead therefore by mapping the 
percpu areas using 2MB tlbs. So we do not need to be that complicated.

What v2 did was allocate an area n * MAX_VIRT_PER_CPU_SIZE in vmalloc 
space and then it dynamically populated 2MB segments as needed. The MAX 
size was 128MB or so.

We could either do the same on i386 or use 4kb mappings (then we can 
directly use the vmalloc functionality). But then there would be 
additional TLB overhead.

We have similar 2MB virtual mapping tricks for the virtual memmap. 
Basically we can copy the functions and customize them for the virtual per 
cpu areas (Mike is hopefully listening and reading the V2 patch ....)

