Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbZFUR5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbZFUR5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 13:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZFUR5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 13:57:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbZFUR5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 13:57:45 -0400
Date: Sun, 21 Jun 2009 10:57:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <alpine.LFD.2.01.0906211031230.3119@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906211049060.3119@localhost.localdomain>
References: <20090620173022.GA14145@elte.hu> <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain> <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain> <alpine.LFD.2.00.0906211553150.2784@localhost.localdomain>
 <alpine.LFD.2.01.0906211031230.3119@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Jun 2009, Linus Torvalds wrote:
> 
> And as far as I can tell, that is indeed the only case where you use that 
> 'get_user_writeable()' thing. You've had futex_atomic_op_inuser() fail, 
> and need to repeat. No?

I just checked. Yes, this code is _only_ entered when an atomic op 
returned EFAULT. IOW, we absolutely know that the page tables are not set 
up for writability, and thus that the "fast" case will never ever trigger.

(Ok, in theory you could have some other thread writing to that page at 
the same time and handle the page fault and making it writable, but in 
practice that's not really relevant).

So just doing a "make_sure_its_writable()" and using handle_fault() is the 
right thing to do. Because it's what get_user_fast() would have done too, 
except it would have gone through first the fast case, and failed, then 
the slow case, and failed the lookup there, and then the slow case would 
have done that handle_mm_fault() in the end anyway.

In fact, since you're not actually interested in the page, you _could_ 
just do

	get_user_pages(tsk, mm, uaddr, 4, 1, 0, NULL, NULL);

where a NULL "pages" pointer already tells get_user_pages() that you're 
not interested.

That's at least cleaner than doing a "gup_fast()" (which isn't fast), and 
then freeing the page that you weren't even interested in.

		Linus
