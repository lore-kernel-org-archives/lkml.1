Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYEGVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYEGVip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYEGVib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:38:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYEGVi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:38:28 -0400
Date: Wed, 7 May 2008 14:36:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
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
In-Reply-To: <20080507212650.GA8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Andrea Arcangeli wrote:
> 
> I think the spinlock->rwsem conversion is ok under config option, as
> you can see I complained myself to various of those patches and I'll
> take care they're in a mergeable state the moment I submit them. What
> XPMEM requires are different semantics for the methods, and we never
> had to do any blocking I/O during vmtruncate before, now we have to.

I really suspect we don't really have to, and that it would be better to 
just fix the code that does that.

> Please ignore all patches but mmu-notifier-core. I regularly forward
> _only_ mmu-notifier-core to Andrew, that's the only one that is in
> merge-ready status, everything else is just so XPMEM can test and we
> can keep discussing it to bring it in a mergeable state like
> mmu-notifier-core already is.

The thing is, I didn't like that one *either*. I thought it was the 
biggest turd in the series (and by "biggest", I literally mean "most lines 
of turd-ness" rather than necessarily "ugliest per se").

I literally think that mm_lock() is an unbelievable piece of utter and 
horrible CRAP.

There's simply no excuse for code like that.

If you want to avoid the deadlock from taking multiple locks in order, but 
there is really just a single operation that needs it, there's a really 
really simple solution.

And that solution is *not* to sort the whole damn f*cking list in a 
vmalloc'ed data structure prior to locking!

Damn.

No, the simple solution is to just make up a whole new upper-level lock, 
and get that lock *first*. You can then take all the multiple locks at a 
lower level in any order you damn well please. 

And yes, it's one more lock, and yes, it serializes stuff, but:

 - that code had better not be critical anyway, because if it was, then 
   the whole "vmalloc+sort+lock+vunmap" sh*t was wrong _anyway_

 - parallelism is overrated: it doesn't matter one effing _whit_ if 
   something is a hundred times more parallel, if it's also a hundred 
   times *SLOWER*.

So dang it, flush the whole damn series down the toilet and either forget 
the thing entirely, or re-do it sanely.

And here's an admission that I lied: it wasn't *all* clearly crap. I did 
like one part, namely list_del_init_rcu(), but that one should have been 
in a separate patch. I'll happily apply that one.

		Linus
