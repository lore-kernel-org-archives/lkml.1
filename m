Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYFBDes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYFBDes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 23:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYFBDeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 23:34:37 -0400
Received: from ozlabs.org ([203.10.76.45]:33554 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbYFBDeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 23:34:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Mon, 2 Jun 2008 12:00:41 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <200805301708.51284.rusty@rustcorp.com.au> <Pine.LNX.4.64.0805301055270.14564@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0805301055270.14564@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021200.41652.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2008 04:00:40 Christoph Lameter wrote:
> On Fri, 30 May 2008, Rusty Russell wrote:
> > > No its not! In order to increment a per cpu value you need to calculate
> > > the per cpu pointer address in the current per cpu segment.
> >
> > Christoph, you just missed it, that's all.  Look at cpu_local_read et al
> > in include/asm-i386/local.h (ie. before the x86 mergers chose the lowest
> > common denominator one).
>
> There is no doubt that local_t does perform an atomic vs. interrupt inc
> for example. But its not usable. Because you need to determine the address
> of the local_t belonging to the current processor first.

Christoph!

STOP typing, and START reading.

cpu_local_inc() does all this: it takes the name of a local_t var, and is 
expected to increment this cpu's version of that.  You ripped this out and 
called it CPU_INC().

Do not make me explain it a third time.

> As soon as you 
> have loaded a processor specific address you can no longer be preempted
> because that may change the processor and then the wrong address may be
> increment (and then we have a race again since now we are incrementing
> counters belonging to other processors). So local_t at mininum requires
> disabling preempt.

Think for a moment.  What are the chances that I didn't understand this when I 
wrote the multiple implementations of local_t?

You are wasting my time explaining the obvious, and wasting your own.

> Believe me I have tried to use local_t repeatedly for vm statistics etc.
> It always fails on that issue.

Frankly, I am finding it increasingly easy to believe that you failed.  But 
you are blaming the wrong thing.

There are three implementations of local_t which are obvious.  The best is for 
architectures which can locate and increment a per-cpu var in one instruction 
(eg. x86).  Otherwise, using atomic_t/atomic64_t for local_t provides a 
general solution.  The other general solution would involve 
local_irq_disable()/increment/local_irq_enable().

My (fading) hope is that this idiocy is an abberation,
Rusty.
