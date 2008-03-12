Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbYCLU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbYCLU1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYCLU1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:27:13 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:51019 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751936AbYCLU1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:27:12 -0400
Date: Thu, 13 Mar 2008 01:56:58 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1/2] lockdep: fix recursive read lock validation
Message-ID: <20080312202658.GA7856@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080312120920.929901000@chello.nl> <20080312121323.697634000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080312121323.697634000@chello.nl>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 01:09:21PM +0100, Peter Zijlstra wrote:
> __lock_acquire( .read = 2 )
>   hlock->read = read; /* [1] */
>   validate_chain()
>     ret = check_deadlock(); /* returns 2 when recursive */
> 
>     if (ret == 2)
>       hlock->read = 2; /* but it was already 2 from [1] */
> 
>     check_prevs_add()
>       if (hlock->read != 2)
>         /* add to dependency chain */
> 
> So it will never add a recursive read lock to the dependency chain. Fix this
> by setting hlock->read to 1 when its the first recursive lock instance.
> 
> This means that the following sequence is now invalid, whereas previously
> it was considered valid:
> 
>   rlock(a); rlock(b); runlock(b); runlock(a)
>   rlock(b); rlock(a);
> 
> It really is invalid when considered against write locks.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Gautham R Shenoy <ego@in.ibm.com>

Tested-by: Gautham R Shenoy <ego@in.ibm.com>

> ---
>  kernel/lockdep.c       |    9 ++++-----
>  lib/locking-selftest.c |   12 ++++++------
>  2 files changed, 10 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6-2/kernel/lockdep.c
> ===================================================================
> --- linux-2.6-2.orig/kernel/lockdep.c
> +++ linux-2.6-2/kernel/lockdep.c
> @@ -1557,12 +1557,11 @@ static int validate_chain(struct task_st
>  		if (!ret)
>  			return 0;
>  		/*
> -		 * Mark recursive read, as we jump over it when
> -		 * building dependencies (just like we jump over
> -		 * trylock entries):
> +		 * If we are the first recursive read, don't jump over our
> +		 * dependency.
>  		 */
> -		if (ret == 2)
> -			hlock->read = 2;
> +		if (hlock->read == 2 && ret != 2)
> +			hlock->read = 1;
>  		/*
>  		 * Add dependency only if this lock is not the head
>  		 * of the chain, and if it's not a secondary read-lock:
> Index: linux-2.6-2/lib/locking-selftest.c
> ===================================================================
> --- linux-2.6-2.orig/lib/locking-selftest.c
> +++ linux-2.6-2/lib/locking-selftest.c
> @@ -1135,12 +1135,12 @@ void locking_selftest(void)
>  	debug_locks_silent = !debug_locks_verbose;
> 
>  	DO_TESTCASE_6R("A-A deadlock", AA);
> -	DO_TESTCASE_6R("A-B-B-A deadlock", ABBA);
> -	DO_TESTCASE_6R("A-B-B-C-C-A deadlock", ABBCCA);
> -	DO_TESTCASE_6R("A-B-C-A-B-C deadlock", ABCABC);
> -	DO_TESTCASE_6R("A-B-B-C-C-D-D-A deadlock", ABBCCDDA);
> -	DO_TESTCASE_6R("A-B-C-D-B-D-D-A deadlock", ABCDBDDA);
> -	DO_TESTCASE_6R("A-B-C-D-B-C-D-A deadlock", ABCDBCDA);
> +	DO_TESTCASE_6("A-B-B-A deadlock", ABBA);
> +	DO_TESTCASE_6("A-B-B-C-C-A deadlock", ABBCCA);
> +	DO_TESTCASE_6("A-B-C-A-B-C deadlock", ABCABC);
> +	DO_TESTCASE_6("A-B-B-C-C-D-D-A deadlock", ABBCCDDA);
> +	DO_TESTCASE_6("A-B-C-D-B-D-D-A deadlock", ABCDBDDA);
> +	DO_TESTCASE_6("A-B-C-D-B-C-D-A deadlock", ABCDBCDA);
>  	DO_TESTCASE_6("double unlock", double_unlock);
>  	DO_TESTCASE_6("initialize held", init_held);
>  	DO_TESTCASE_6_SUCCESS("bad unlock order", bad_unlock_order);
> 
> --

-- 
Thanks and Regards
gautham
