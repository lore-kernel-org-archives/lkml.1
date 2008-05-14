Return-Path: <linux-kernel-owner+w=401wt.eu-S1762913AbYENPTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762913AbYENPTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYENPTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:19:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbYENPTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:19:44 -0400
Date: Wed, 14 May 2008 08:18:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
cc: Nick Piggin <npiggin@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
In-Reply-To: <20080514112625.GY9878@sgi.com>
Message-ID: <alpine.LFD.1.10.0805140807400.3019@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080508003838.GA9878@sgi.com> <200805132206.47655.nickpiggin@yahoo.com.au> <20080513153238.GL19717@sgi.com> <20080514041122.GE24516@wotan.suse.de>
 <20080514112625.GY9878@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 May 2008, Robin Holt wrote:
> 
> Are you suggesting the sending side would not need to sleep or the
> receiving side?

One thing to realize is that most of the time (read: pretty much *always*) 
when we have the problem of wanting to sleep inside a spinlock, the 
solution is actually to just move the sleeping to outside the lock, and 
then have something else that serializes things.

That way, the core code (protected by the spinlock, and in all the hot 
paths) doesn't sleep, but the special case code (that wants to sleep) can 
have some other model of serialization that allows sleeping, and that 
includes as a small part the spinlocked region.

I do not know how XPMEM actually works, or how you use it, but it 
seriously sounds like that is how things *should* work. And yes, that 
probably means that the mmu-notifiers as they are now are simply not 
workable: they'd need to be moved up so that they are inside the mmap 
semaphore but not the spinlocks.

Can it be done? I don't know. But I do know that I'm unlikely to accept a 
noticeable slowdown in some very core code for a case that affects about 
0.00001% of the population. In other words, I think you *have* to do it.

			Linus
