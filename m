Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYLVEc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYLVEc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 23:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYLVEcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 23:32:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:33932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbYLVEcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 23:32:18 -0500
Date: Mon, 22 Dec 2008 05:32:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       "lkml, " <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@au1.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: futex.c and fault handling
Message-ID: <20081222043208.GB13406@wotan.suse.de>
References: <494C1DE5.4040901@us.ibm.com> <20081219223720.GD13409@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219223720.GD13409@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 11:37:20PM +0100, Ingo Molnar wrote:
> 
> (extended the Cc: list with MM experts.)
> 
> * Darren Hart <dvhltc@us.ibm.com> wrote:
> 
> > I've been working in linux-tip core/futexes lately and have a need to be 
> > able to properly handle faults for r/w access to a uaddr.  I was 
> > planning on modeling this on the fault handling in futex_lock_pi which 
> > used both get_user() and futex_handle_fault() to get the pages.  
> > However, that used to be based on whether or not we held the mmap_sem.  
> > Now that we're using fast_gup throughout futex.c, and the mmap_sem 
> > locking has been pushed in tighter in get_futex_key(), I'm not sure if 
> > the fault handling is still correct - the comments are certainly 
> > incorrect since we no longer hold the mmap_sem when we hit 
> > uaddr_faulted: inside futex_lock_pi (and a few other places have similar 
> > comment vs. code dicrepancies):
> >
> > uaddr_faulted:
> > 	/*
> > 	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
> > 	 * atomically.  Therefore, if we continue to fault after get_user()
> > 	 * below, we need to handle the fault ourselves, while still holding
> > 	 * the mmap_sem.  This can occur if the uaddr is under contention as
> > 	 * we have to drop the mmap_sem in order to call get_user().
> > 	 */
> > 	queue_unlock(&q, hb);
> >
> > 	if (attempt++) {
> > 		ret = futex_handle_fault((unsigned long)uaddr, attempt);
> > 		if (ret)
> > 			goto out_put_key;
> > 		goto retry_unlocked;
> > 	}
> >
> > ---> previous versions dropped the mmap_sem here in preparation for get_user()
> >
> > 	ret = get_user(uval, uaddr);
> > 	if (!ret)
> > 		goto retry;
> >
> >
> > So is the code still correct without the holding of mmap_sem?  I suppose 
> > get_user() is still the more efficient path, and perhaps even more so 
> > now that we don't have to release mmap_sem and reacquire it later in 
> > order to call it.  If so, then I guess all that is needed is a comments 
> > patch, which I'd be happy to write up.

It would be really nice to have some arch hooks that can fault in user
addresses for read and/or write, and rip all this code out of futex.c

Even more fundamentally, I suspect the futex code might be able to be
implemented without holding mmap_sem or hb locks over the atomic op,
which would be nice. But that would be a much bigger job than simply
implementing fault_in_pages_writeable in a general manner.


