Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZFURNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZFURNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZFURMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:12:55 -0400
Received: from www.tglx.de ([62.245.132.106]:44645 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZFURMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:12:55 -0400
Date: Sun, 21 Jun 2009 19:12:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906211553150.2784@localhost.localdomain>
References: <20090620173022.GA14145@elte.hu> <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain> <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009, Linus Torvalds wrote:
> On Sat, 20 Jun 2009, Linus Torvalds wrote:
> > 
> > On x86, the natural way to do what you want done is ONE SINGLE 
> > INSTRUCTION! As far as I can tell, the above crazy function is 100% 
> > equivalent to this:
> > 
> > 	asm __inline__("lock ; addl $0,%0":"+m" (*uaddr): :"memory", "cc");
> > 
> > which really makes me think that using "get_user_pages_fast()" for it is 
> > some truly crazy crap.
> 
> We could also take the opposite approach - knowing that this is called 
> only when the page doesn't exist, and just doing
> 
> 	down_read(mmap_sem)
> 	vma = find_vma(..)
> 	ret = VM_FAULT_ERROR;
> 	if (vma && vma->vm_start <= address)
> 		ret = handle_mm_fault(mm, vma, address, 1);
> 	up_read(mmap_sem);
> 	return (ret & VM_FAULT_ERROR) ? -EFAULT : 0;
> 
> or something like that. Again, that looks saner than using 
> get_user_pages() for this and then dropping the page.

Hmm. The main reason why we switched to get_user_pages_fast() in the
futex code is to avoid mmap_sem contention which was observed as a
real big performance problem especially with those horrible JavaVM
applications.

As a fallout of this we got rid of the private find_vma /
handle_mm_fault magic (as above) in the futex code which mm folks
frowned upon for quite a while. Unfortunately we got it wrong :(

I agree that in the fault path we might go back to the mmap_sem
version, but I want to avoid it when possible. At least we need to run
some of those horrible JavaVM apps to see whether it matters or not.

OTOH, I really wonder whether we can simplify the whole logic when we
keep the page reference for the atomic access to the user space
address, but I still have doubts about the life time rules of all
this. Also I need to find out how this would affect the fast path
optimization of private futexes where we avoid the lookup in the first
place.

Thanks,

	tglx
