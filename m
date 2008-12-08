Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYLHWo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYLHWo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYLHWoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:44:44 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48685 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYLHWom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:44:42 -0500
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
From: Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-ext4@vger.kernel.org
In-Reply-To: <20081208221241.GA2501@mit.edu>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
	 <493BCF60.1080409@cosmosbay.com>
	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>
	 <493C0F40.7040304@cosmosbay.com>
	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	 <20081208221241.GA2501@mit.edu>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Mon, 08 Dec 2008 14:44:39 -0800
Message-Id: <1228776279.6372.18.camel@mingming-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2008-12-08一的 17:12 -0500，Theodore Tso写道：
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
> 
> Actually, if all popular architectures had a hardware-implemented
> atomic_t, I wonder how much ext4 really needs the percpu counter,
> especially given ext4's multiblock allocator;

Delayed allocation will makes multiple block allocation possible for
buffered IO.  

However, we still need to check the percpu counter on write_begin() time
for every single possible block allocation (this is to make sure fs is
not overbooked), unless write_begin() could cluster the write requests
and maps multiple blocks in a single shot. So in reality in ext4 the
free blocks percpu_counter check and the s_dirty_blocks (percpu counter
too, for delayed blocks) only takes 1 block at a time:(


Mingming

