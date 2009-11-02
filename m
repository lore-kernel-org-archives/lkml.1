Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbZKBQq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbZKBQq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbZKBQq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:46:26 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:57732 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbZKBQqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:46:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SBIXrBCqBKYCcnnqEIovv+4VCyBscr2YrCrmW929rg4pQKSoos582aW+SkFzLQxQXo
         eW4h5cXeqHQEwSfW5YkWfO0PtLKwzYNzjx9/RHDfnh+y1vU/sa+ux0GiBjl1TjT3d6Jz
         43OgvjtNfKnJekoWvro7kliI4EPeszf8gT+Vo=
Date: Mon, 2 Nov 2009 19:46:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch][rfc] x86, mutex: non-atomic unlock (and a rant)
Message-ID: <20091102164626.GA10072@lenovo>
References: <20091102120739.GA20318@wotan.suse.de> <alpine.LFD.2.01.0911020710030.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911020710030.31845@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Linus Torvalds - Mon, Nov 02, 2009 at 07:20:08AM -0800]
| 
| On Mon, 2 Nov 2009, Nick Piggin wrote:
| > 
| > Non-atomic unlock for mutexs maybe? I do this by relying on cache
| > coherence on a cacheline basis for ordering rather than the memory
| > consistency of the x86. Linus I know you've told me this is an incorrect
| > assumption in the past, but I'm not so sure.
| 
| I'm sure.
| 
| This is simply buggy:
| 
| > +	atomic_set(&lock->count, 1);
| > +	barrier();
| > +	if (unlikely(lock->waiters))
| > +		fail_fn(lock);
| 
| because it doesn't matter one whit whether 'lock->count' and 
| 'lock->waiters' are in the same cacheline or not.
| 
| The cache coherency deals in cachelines, but the instruction re-ordering 
| logic does not. It's entirely possible that the CPU will turn this into
| 
| 	tmp = lock->waiters;
| 	...
| 	atomic_set(&lock->count, 1);
| 	if (tmp)
| 		fail_fn(lock);
| 
| and your "barrier()" did absolutely nothing.
...

If we write it as

	atomic_set(&lock->count, 1);
	some-serializing-op(); /* say cpuid() */
	if (unlikely(lock->waiters))
		fail_fn(lock);

This should do the trick, though this serializing operation
is always cost too much.

The other option could be that we put two mem-write operations
like
	int tmp;
	atomic_set(&lock->count, 1);
	tmp = lock->waiters;
	rmb();
	lock->waiters = tmp;
	if (unlikely(lock->waiters))
		fail_fn(lock);

Which should work faster then cpuid (and we have to be sure somehow
that gcc doesn't suppress this redundant operations).

	-- Cyrill
