Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYFJRmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYFJRmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYFJRmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:42:18 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36890 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755911AbYFJRmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:42:16 -0400
Date: Tue, 10 Jun 2008 10:42:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu
 operations
In-Reply-To: <200806021200.41652.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0806101034480.17131@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <200805301708.51284.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0805301055270.14564@schroedinger.engr.sgi.com>
 <200806021200.41652.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Rusty Russell wrote:

> > Believe me I have tried to use local_t repeatedly for vm statistics etc.
> > It always fails on that issue.
> 
> Frankly, I am finding it increasingly easy to believe that you failed.  But 
> you are blaming the wrong thing.
> 
> There are three implementations of local_t which are obvious.  The best is for 
> architectures which can locate and increment a per-cpu var in one instruction 
> (eg. x86).  Otherwise, using atomic_t/atomic64_t for local_t provides a 
> general solution.  The other general solution would involve 
> local_irq_disable()/increment/local_irq_enable().
> 
> My (fading) hope is that this idiocy is an abberation,

1. The x86 implementation does not exist because the segment register has 
   so far not been available on x86_64. So you could not do the solution.
   You need the zero basing. Then you can use per_xxx_add in cpu_inc.

2. The general solution created overhead that is often not needed. If we
   would have done vm event counters with local_t then we would have
   atomic overhead for each increment on f.e. IA64. That was not
   acceptable. cpu_alloc never falls back to atomic operations.

3. local_t is based on the atomic logic. But percpu handling is 
   fundamentally different in that accesses without the special macros
   are okay provided you are in a non preemptible or irq context!
   A local_t declaration makes such accesses impossible.

4. The modeling of local_t on atomic_t limits it to 32bit! There is no
   way to use this with pointers or 64 bit entities. Adding that would 
   duplicate the API for each type added.
