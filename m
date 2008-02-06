Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbYBFAEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbYBFAEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbYBFAER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:04:17 -0500
Received: from relay1.sgi.com ([192.48.171.29]:55275 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757300AbYBFAEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:04:16 -0500
Date: Tue, 5 Feb 2008 16:04:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [PATCH] mmu notifiers #v5
In-Reply-To: <20080205234742.GI7441@v2.random>
Message-ID: <Pine.LNX.4.64.0802051555380.17243@schroedinger.engr.sgi.com>
References: <20080203021704.GC7185@v2.random>
 <Pine.LNX.4.64.0802041106370.9656@schroedinger.engr.sgi.com>
 <20080205052525.GD7441@v2.random> <Pine.LNX.4.64.0802042206200.6739@schroedinger.engr.sgi.com>
 <20080205180802.GE7441@v2.random> <Pine.LNX.4.64.0802051013440.11705@schroedinger.engr.sgi.com>
 <20080205205519.GF7441@v2.random> <Pine.LNX.4.64.0802051400200.14665@schroedinger.engr.sgi.com>
 <20080205222657.GG7441@v2.random> <Pine.LNX.4.64.0802051504450.16261@schroedinger.engr.sgi.com>
 <20080205234742.GI7441@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, Andrea Arcangeli wrote:

> > You can of course setup a 2M granularity lock to get the same granularity 
> > as the pte lock. That would even work for the cases where you have to page 
> > pin now.
> 
> If you set a 2M granularity lock, the _start callback would need to
> do:
> 
> 	for_each_2m_lock()
> 		mutex_lock()
> 
> so you'd run zillon of mutex_lock in a row, you're the one with the
> million of operations argument.

There is no requirement to do a linear search. No one in his right mind 
would implement a performance critical operation that way.
 
> > The size of the mmap is relevant if you have to perform callbacks on 
> > every mapped page that involved take mmu specific locks. That seems to be 
> > the case with this approach.
> 
> mmap should never trigger any range_start/_end callback unless it's
> overwriting an older mapping which is definitely not the interesting
> workload for those apps including kvm.

There is still at least the need for teardown on exit. And you need to 
consider the boundless creativity of user land programmers. You would not 
believe what I have seen....

> > Optimizing do_exit by taking a single lock to zap all external references 
> > instead of 1 mio callbacks somehow leads to slowdown?
> 
> It can if the application runs for more than a couple of seconds,
> i.e. not a fork flood in which you care about do_exit speed. Keep in
> mind if you had 1mio invalidate_pages callback it means you previously
> called follow_page 1 mio of times too...

That is another problem were we are also in need of solutions. I believe 
we have discussed that elsewhere.
