Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYDUBUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYDUBUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYDUBUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:20:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48179 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753702AbYDUBUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:20:10 -0400
Date: Mon, 21 Apr 2008 09:18:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Message-ID: <20080421011855.GA6243@gondor.apana.org.au>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

On Sun, Apr 20, 2008 at 02:31:48PM -0700, Linus Torvalds wrote:
>
> Talking about RCU I also think that whoever did those "rcu_dereference()" 
> macros in <linux/list.h> was insane. It's totally pointless to do 
> "rcu_dereference()" on a local variable. It simply *cannot* make sense. 
> Herbert, Paul, you guys should look at it.

Since I made the macros look this way I'm obliged to defend it :)

>  #define list_for_each_rcu(pos, head) \
> -	for (pos = (head)->next; \
> -		prefetch(rcu_dereference(pos)->next), pos != (head); \
> -        	pos = pos->next)
> +	for (pos = rcu_dereference((head)->next); \
> +		prefetch(pos->next), pos != (head); \
> +        	pos = rcu_dereference(pos->next))

Semantically there should be no difference between the two versions.
The purpose of rcu_dereference is really similar to smp_rmb, i.e.,
it adds a (conditional) read barrier between what has been read so
far (including its argument), and what will be read subsequently.

So if we expand out the current code it would look like

	fetch (head)->next
	store into pos
again:
	smp_read_barrier_depends()
	prefetch(pos->next)
	pos != (head)

	...loop body...

	fetch pos->next
	store into pos
	goto again

Yours looks like

	fetch (head)->next
	smp_read_barrier_depends()
	store into pos
again:
	prefetch(pos->next)
	pos != (head)

	...loop body...

	fetch pos->next
	smp_read_barrier_depends()
	store into pos
	goto again

As the objective here is to insert a barrier before dereferencing
pos (e.g., reading pos->next or using it in the loop body), these
two should be identical.

But I do concede that your version looks clearer, and has the
benefit that should prefetch ever be optimised out with no side-
effects, yours would still be correct while the current one will
lose the barrier completely.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
