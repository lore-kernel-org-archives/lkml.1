Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbZFURh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbZFURh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZFURhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:37:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbZFURhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:37:20 -0400
Date: Sun, 21 Jun 2009 10:37:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <alpine.LFD.2.00.0906211553150.2784@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906211031230.3119@localhost.localdomain>
References: <20090620173022.GA14145@elte.hu> <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain> <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain> <alpine.LFD.2.00.0906211553150.2784@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Jun 2009, Thomas Gleixner wrote:
> 
> Hmm. The main reason why we switched to get_user_pages_fast() in the
> futex code is to avoid mmap_sem contention which was observed as a
> real big performance problem especially with those horrible JavaVM
> applications.

Not relevant.

get_user_pages_fast() takes the mmap_sem for the case where it needs to 
fault things in too.

So assuming the _only_ reason this thing is called is because we failed 
earlier when doing the futex_atomic_op_inuser(), then you're basically 
guaranteed that the "fast" case of get_user_pages_fast() is never actually 
taken, since we already know that the page tables aren't amenable to an 
atomic access.

And as far as I can tell, that is indeed the only case where you use that 
'get_user_writeable()' thing. You've had futex_atomic_op_inuser() fail, 
and need to repeat. No?

> As a fallout of this we got rid of the private find_vma /
> handle_mm_fault magic (as above) in the futex code which mm folks
> frowned upon for quite a while. Unfortunately we got it wrong :(

Sure. But "get_user_pages_fast()" really is the wrong thing. You're not at 
all interested in the user pages. You're interested in making sure that 
the page is atomically writable, and nothing else. Right?

Which is why I said that "lock ; addl $0,(mem)" would be a _single_ 
instruction, and do everything that your "get_user_pages_fast()" hack 
would do. If the fault is unlikely, that would be a better operation. I 
just don't think the fault is unlikely, I suspect it happens every time.

			Linus
