Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbYENR5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbYENR5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYENR5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:57:13 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50494 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753685AbYENR5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:57:12 -0400
Date: Wed, 14 May 2008 10:57:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <alpine.LFD.1.10.0805140807400.3019@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805141053350.15490@schroedinger.engr.sgi.com>
References: <6b384bb988786aa78ef0.1210170958@duo.random>
 <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org>
 <20080508003838.GA9878@sgi.com> <200805132206.47655.nickpiggin@yahoo.com.au>
 <20080513153238.GL19717@sgi.com> <20080514041122.GE24516@wotan.suse.de>
 <20080514112625.GY9878@sgi.com> <alpine.LFD.1.10.0805140807400.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Linus Torvalds wrote:

> One thing to realize is that most of the time (read: pretty much *always*) 
> when we have the problem of wanting to sleep inside a spinlock, the 
> solution is actually to just move the sleeping to outside the lock, and 
> then have something else that serializes things.

The problem is that the code in rmap.c try_to_umap() and friends loops 
over reverse maps after taking a spinlock. The mm_struct is only known 
after the rmap has been acccessed. This means *inside* the spinlock.

That is why I tried to convert the locks to scan the revese maps to 
semaphores. If that is done then one can indeed do the callouts outside of 
atomic contexts.

> Can it be done? I don't know. But I do know that I'm unlikely to accept a 
> noticeable slowdown in some very core code for a case that affects about 
> 0.00001% of the population. In other words, I think you *have* to do it.

With larger number of processor semaphores make a lot of sense since the 
holdoff times on spinlocks will increase. If we go to sleep then the 
processor can do something useful instead of hogging a cacheline.

A rw lock there can also increase concurrency during reclaim espcially if 
the anon_vma chains and the number of address spaces mapping a page is 
high.

