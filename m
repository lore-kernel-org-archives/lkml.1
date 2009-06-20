Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbZFTU1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbZFTU1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZFTU12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:27:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbZFTU11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:27:27 -0400
Date: Sat, 20 Jun 2009 22:27:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20090620202720.GA7411@elte.hu>
References: <20090620173022.GA14145@elte.hu> <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain> <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

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

We'll sort this out tomorrow, sorry about this.

( The other embarrasing bit is that i flagged this commit as bad
  nine days ago - during review i noticed the same bad pattern of a 
  pointless get-put cycle ... but the commit stuck around and forgot 
  about it. Sloppy. )

	Ingo
