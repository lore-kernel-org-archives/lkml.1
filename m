Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYJGRwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYJGRwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbYJGRwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:52:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731AbYJGRwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:52:09 -0400
Date: Tue, 7 Oct 2008 10:50:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
 arch
Message-Id: <20081007105056.16d9e785.akpm@linux-foundation.org>
In-Reply-To: <200810080327.44530.nickpiggin@yahoo.com.au>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
	<6.0.0.20.2.20081007183452.0f052210@172.19.0.2>
	<20081007102942.GE20740@one.firstfloor.org>
	<200810080327.44530.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008 03:27:44 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 07 October 2008 21:29, Andi Kleen wrote:
> > > Maybe cmpxchg8b is good for i486 or later x86, but i386 or other
> > > architectures that do not have similar instruction needs some locking
> > > primitive. I think lazy
> >
> > We have a cmpxchg emulation on 386. That works because only UP 386s are
> > supported, so it can be done in software.
> >
> > > seqlock is one option for making file->f_pos access atomic.
> >
> > The question is if it's the right option. At least all the common
> > operations on fds (read/write) are all writers, not readers.
> 
> Common operations are read, do something, write. So seqlocks then cost
> one atomic operation, a couple of memory barriers (all noops on x86),
> and some predictable branches etc.
> 
> cmpxchg based would require 2 lock ; cmpxchg8b on 32-bit. Fairly heavy.
> Also I don't think we have generic accessors to do this, so I think
> that is for another project.
> 
> Anyway, I think importantly this creates some usable accessors for the
> f_pos problem. I think we actually need to touch a _lot_ of code to
> cover all f_pos accesses in the kernel, but I guess this gets the ball
> rolling.

Aneesh is proposing using using seqlocks to make percpu_counter.count
atomic on 32-bit.

This patch uses seqlocks to make file.f_pos atomic on 32-bit.

I think we should come up with a common atomic 64-bit type.  We already
partly have that: atomic64_t.  But for reasons which I don't recall,
atomic64_t is 64-bit-only at present.

If we generalise atomic64_t to all architectures then we can use it in
both the above applications and surely in other places in the future.

> So.. is everyone agreed that corrupting f_pos is a bad thing? (serious
> question) If so, then we should get something like this merged sooner
> rather than later.

- two threads/processes sharing the same fd

- both appending the same fd

- both hit the small race window right around the time when the file
  flips over a multiple of 4G.

It's pretty damn improbable, and I think we can afford to spend the
time to get this right in 2.6.29.

