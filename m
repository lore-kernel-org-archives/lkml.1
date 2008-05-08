Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbYEHA5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbYEHA5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYEHA5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:57:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYEHA52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:57:28 -0400
Date: Wed, 7 May 2008 17:55:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
In-Reply-To: <20080508003838.GA9878@sgi.com>
Message-ID: <alpine.LFD.1.10.0805071743460.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080508003838.GA9878@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Robin Holt wrote:
> 
> In order to invalidate the remote page table entries, we need to message
> (uses XPC) to the remote side.  The remote side needs to acquire the
> importing process's mmap_sem and call zap_page_range().  Between the
> messaging and the acquiring a sleeping lock, I would argue this will
> require sleeping locks in the path prior to the mmu_notifier invalidate_*
> callouts().

You simply will *have* to do it without locally holding all the MM 
spinlocks. Because quite frankly, slowing down all the normal VM stuff for 
some really esoteric hardware simply isn't acceptable. We just don't do 
it.

So what is it that actually triggers one of these events?

The most obvious solution is to just queue the affected pages while 
holding the spinlocks (perhaps locking them locally), and then handling 
all the stuff that can block after releasing things. That's how we 
normally do these things, and it works beautifully, without making 
everything slower.

Sometimes we go to extremes, and actually break the locks are restart 
(ugh), and it gets ugly, but even that tends to be preferable to using the 
wrong locking.

The thing is, spinlocks really kick ass. Yes, they restrict what you can 
do within them, but if 99.99% of all work is non-blocking, then the really 
odd rare blocking case is the one that needs to accomodate, not the rest.

				Linus
