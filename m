Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYE3SAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYE3SAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYE3SAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:00:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33088 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754700AbYE3SAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:00:41 -0400
Date: Fri, 30 May 2008 11:00:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <200805301708.51284.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0805301055270.14564@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080529223825.bf744d37.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0805292309520.12457@schroedinger.engr.sgi.com>
 <200805301708.51284.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2008, Rusty Russell wrote:

> > No its not! In order to increment a per cpu value you need to calculate
> > the per cpu pointer address in the current per cpu segment.
> 
> Christoph, you just missed it, that's all.  Look at cpu_local_read et al in 
> include/asm-i386/local.h (ie. before the x86 mergers chose the lowest common 
> denominator one).

There is no doubt that local_t does perform an atomic vs. interrupt inc 
for example. But its not usable. Because you need to determine the address 
of the local_t belonging to the current processor first. As soon as you 
have loaded a processor specific address you can no longer be preempted 
because that may change the processor and then the wrong address may be 
increment (and then we have a race again since now we are incrementing 
counters belonging to other processors). So local_t at mininum requires 
disabling preempt.
 
Believe me I have tried to use local_t repeatedly for vm statistics etc. 
It always fails on that issue. See f.e. the patch that converts vmstat to 
cpu alloc and compare with my initial local_t based implementation 2 years 
ago that bombed out because I assumed that local_t would work right.

cpu ops does both

1. The determination of the address of the object belonging to the local 
processor.

and

2. The RMW

in one instruction. That avoids having to disable preemption or interrupts 
and it shortens the instructions significantly.

