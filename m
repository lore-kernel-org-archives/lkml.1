Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYLHWV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYLHWV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYLHWVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:21:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYLHWVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:21:17 -0500
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org
In-Reply-To: <20081208221241.GA2501@mit.edu>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
	 <493BCF60.1080409@cosmosbay.com>
	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>
	 <493C0F40.7040304@cosmosbay.com>
	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	 <20081208221241.GA2501@mit.edu>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 23:20:35 +0100
Message-Id: <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 17:12 -0500, Theodore Tso wrote:
> On Sun, Dec 07, 2008 at 08:52:50PM -0800, Andrew Morton wrote:
> > 
> > The first patch which was added (pre-2.6.27) was "percpu_counter: new
> > function percpu_counter_sum_and_set".  This added the broken-by-design
> > percpu_counter_sum_and_set() function, **and used it in ext4**.
> > 
> 
> Mea culpa, I was the one who reviewed Mingming's patch, and missed
> this.  Part of the problem was that percpu_counter.c isn't well
> documented, and I so saw the spinlock, but didn't realize it only
> protected reference counter, and not the per-cpu array.  I should have
> read through code more thoroughly before approving the patch.
> 
> I suppose if we wanted we could add a rw spinlock which mediates
> access to a "foreign" cpu counter (i.e., percpu_counter_add gets a
> shared lock, and percpu_counter_set needs an exclusive lock) but it's
> probably not worth it.

rwlocks are utter suck and should be banished from the kernel - adding
one would destroy the whole purpose of the code.

> Actually, if all popular architectures had a hardware-implemented
> atomic_t, I wonder how much ext4 really needs the percpu counter,
> especially given ext4's multiblock allocator; with ext3, given that
> each block allocation required taking a per-filesystem spin lock,
> optimizing away that spinlock was far more important for improving
> ext3's scalability.  But with the multiblock allocator, it may that
> we're going through a lot more effort than what is truly necessary.

atomic_t is pretty good on all archs, but you get to keep the cacheline
ping-pong.

