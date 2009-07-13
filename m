Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZGMJPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZGMJPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZGMJPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:15:09 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:13149 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZGMJPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:15:08 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RESEND PATCH 01/11] kernel:lockdep:print the shortest
 dependency chain if finding a circle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ming Lei <tom.leiming@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20090713070110.GA28499@elte.hu>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
	 <20090711213028.GC6641@nowhere>
	 <d82e647a0907111942o1cf22batb204c38bfbd43c03@mail.gmail.com>
	 <20090713070110.GA28499@elte.hu>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 11:14:58 +0200
Message-Id: <1247476498.7529.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 09:01 +0200, Ingo Molnar wrote:
> 
> It's a nice byproduct, beyond the primary advantage of not being a 
> stack based recursion check.
> 
> I think this patch-set is great, and there's just one more step 
> needed to make it round: it would be nice to remove the limitation 
> of maximum number of locks held per task. (MAX_LOCK_DEPTH)
> 
> The way we could do it is to split out this bit of struct task:
> 
> #ifdef CONFIG_LOCKDEP
> # define MAX_LOCK_DEPTH 48UL
>         u64 curr_chain_key;
>         int lockdep_depth;
>         unsigned int lockdep_recursion;
>         struct held_lock held_locks[MAX_LOCK_DEPTH];
>         gfp_t lockdep_reclaim_gfp;
> #endif
> 
> into a separate 'struct lockdep_state' structure, and allocate it 
> dynamically during fork with a initial pre-set size of say 64 locks 
> depth. If we hit that limit, we'd double the allocation threshold, 
> which would cause a larger structure to be allocated for all newly 
> allocated tasks.

Right, except allocating stuff while in the middle of lockdep is very
hard since it involves taking more locks :-)

I've tried it several times but never quite managed it in a way that I
felt comfortable with.

It would require having a reserve and serializing over that reserve.

