Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbZKDPkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbZKDPkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZKDPkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:40:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53591 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZKDPkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:40:17 -0500
Date: Wed, 4 Nov 2009 16:40:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC,PATCH] mutex: mutex_is_owner() helper
Message-ID: <20091104154015.GA32567@elte.hu>
References: <4AF19D06.3060401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF19D06.3060401@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> mutex_is_locked() is called most of the time to check if mutex is locked by current
> thread. But it's a lazy check, because mutex might be locked by another thread.
> 
> Adds a new mutex_is_owned_by() helper, that can check ownership if CONFIG_SMP or
> CONFIG_DEBUG_MUTEXES are set.
> 
> Returns are 
>  0 if mutex is unlocked.
>  1 if locked
> -1 if not locked by designated thread.
> 
> Last return value is possible only if CONFIG_SMP=y or CONFIG_DEBUG_MUTEXES=y
> 
> Example of use :
> 
> int rtnl_is_locked(void)
> {
> 	return mutex_is_locked(&rtnl_mutex);
> }
> ->
> int rtnl_is_locked(void)
> {
> 	return mutex_is_owned_by(&rtnl_mutex, current_thread_info()) == 1;
> }

To make sure this does not extend mutexes to be used a recursive 
mutexes, mind naming it more clearly, like debug_mutex_is_owned(), and 
adding a comment that says that this shouldnt be taken?

Also, it's somewhat imprecise: on !SMP && !DEBUG_MUTEXES we might return 
a false '1'. Which happens to work for the rtnl usecase - but might not 
in other cases.

	Ingo
