Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYLSWiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYLSWiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYLSWhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:37:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbYLSWhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:37:52 -0500
Date: Fri, 19 Dec 2008 23:37:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@au1.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: futex.c and fault handling
Message-ID: <20081219223720.GD13409@elte.hu>
References: <494C1DE5.4040901@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494C1DE5.4040901@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(extended the Cc: list with MM experts.)

* Darren Hart <dvhltc@us.ibm.com> wrote:

> I've been working in linux-tip core/futexes lately and have a need to be 
> able to properly handle faults for r/w access to a uaddr.  I was 
> planning on modeling this on the fault handling in futex_lock_pi which 
> used both get_user() and futex_handle_fault() to get the pages.  
> However, that used to be based on whether or not we held the mmap_sem.  
> Now that we're using fast_gup throughout futex.c, and the mmap_sem 
> locking has been pushed in tighter in get_futex_key(), I'm not sure if 
> the fault handling is still correct - the comments are certainly 
> incorrect since we no longer hold the mmap_sem when we hit 
> uaddr_faulted: inside futex_lock_pi (and a few other places have similar 
> comment vs. code dicrepancies):
>
> uaddr_faulted:
> 	/*
> 	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
> 	 * atomically.  Therefore, if we continue to fault after get_user()
> 	 * below, we need to handle the fault ourselves, while still holding
> 	 * the mmap_sem.  This can occur if the uaddr is under contention as
> 	 * we have to drop the mmap_sem in order to call get_user().
> 	 */
> 	queue_unlock(&q, hb);
>
> 	if (attempt++) {
> 		ret = futex_handle_fault((unsigned long)uaddr, attempt);
> 		if (ret)
> 			goto out_put_key;
> 		goto retry_unlocked;
> 	}
>
> ---> previous versions dropped the mmap_sem here in preparation for get_user()
>
> 	ret = get_user(uval, uaddr);
> 	if (!ret)
> 		goto retry;
>
>
> So is the code still correct without the holding of mmap_sem?  I suppose 
> get_user() is still the more efficient path, and perhaps even more so 
> now that we don't have to release mmap_sem and reacquire it later in 
> order to call it.  If so, then I guess all that is needed is a comments 
> patch, which I'd be happy to write up.
>
> Thanks,
>
> -- 
> Darren Hart
> IBM Linux Technology Center
> Real-Time Linux Team
