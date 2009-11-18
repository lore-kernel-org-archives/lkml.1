Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZKRJnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZKRJnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbZKRJnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:43:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51380 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756818AbZKRJnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:43:14 -0500
Message-ID: <4B03C1A7.4070305@cn.fujitsu.com>
Date: Wed, 18 Nov 2009 17:43:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/2] lockdep: Don't only check recursive read locks once
 in a sequence
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com> <1258506398-5151-3-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1258506398-5151-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Say we have the following locks:
> A (rwlock, Aw: writelock, Ar: recursive read lock)
> B (normal lock)
> 
> and the following sequences:
> Ar -> B -> Ar
> Aw -> B
> 
> This won't be detected as a lock inversion

"""
read-preference <==> read-recursive ability  (rwlock)
otherwise ==> read-recursive disability      (rwsem)
"""

If "B -> Ar" is always after "Ar", it's NOT a really
lock inversion because rwlock is read-preference, we
can ignore all "Ar" which are after "B".

If sometimes "B -> Ar" is not after "Ar",
then we have these sequences:
B -> Ar
Aw -> B

Lockdep can detects it now(without this patch applied).

Maybe I have misunderstood your patch.

> because in the sequence
> of locks held by the current task, if we have a same class acquired
> as read-recursive several times, only the first one will be checked
> in the tree (although all of them are checked for deadlocks in the
> current held sequence).
> 
> Fix it by always adding recursive read locks in the dependency tree.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ming Lei <tom.leiming@gmail.com>
> ---
>  kernel/lockdep.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index a6f7440..13d1d54 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -1949,9 +1949,9 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
>  			hlock->read = 2;
>  		/*
>  		 * Add dependency only if this lock is not the head
> -		 * of the chain, and if it's not a secondary read-lock:
> +		 * of the chain.
>  		 */
> -		if (!chain_head && ret != 2)
> +		if (!chain_head)
>  			if (!check_prevs_add(curr, hlock))
>  				return 0;
>  		graph_unlock();

