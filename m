Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYLHWNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYLHWNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbYLHWM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:12:58 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51039 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752021AbYLHWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:12:57 -0500
Date: Mon, 8 Dec 2008 17:12:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Message-ID: <20081208221241.GA2501@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org> <493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org> <493C0F40.7040304@cosmosbay.com> <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 08:52:50PM -0800, Andrew Morton wrote:
> 
> The first patch which was added (pre-2.6.27) was "percpu_counter: new
> function percpu_counter_sum_and_set".  This added the broken-by-design
> percpu_counter_sum_and_set() function, **and used it in ext4**.
> 

Mea culpa, I was the one who reviewed Mingming's patch, and missed
this.  Part of the problem was that percpu_counter.c isn't well
documented, and I so saw the spinlock, but didn't realize it only
protected reference counter, and not the per-cpu array.  I should have
read through code more thoroughly before approving the patch.

I suppose if we wanted we could add a rw spinlock which mediates
access to a "foreign" cpu counter (i.e., percpu_counter_add gets a
shared lock, and percpu_counter_set needs an exclusive lock) but it's
probably not worth it.

Actually, if all popular architectures had a hardware-implemented
atomic_t, I wonder how much ext4 really needs the percpu counter,
especially given ext4's multiblock allocator; with ext3, given that
each block allocation required taking a per-filesystem spin lock,
optimizing away that spinlock was far more important for improving
ext3's scalability.  But with the multiblock allocator, it may that
we're going through a lot more effort than what is truly necessary.

						- Ted
