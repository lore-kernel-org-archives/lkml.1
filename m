Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbXHRWeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbXHRWeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 18:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXHRWd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 18:33:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33060 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbXHRWd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 18:33:57 -0400
Date: Sat, 18 Aug 2007 15:33:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] exec: kill unsafe BUG_ON(sig->count) checks
Message-ID: <20070818223352.GG7628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070818173936.GA206@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818173936.GA206@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 09:39:36PM +0400, Oleg Nesterov wrote:
> de_thread:
> 
> 	if (atomic_read(&oldsighand->count) <= 1)
> 		BUG_ON(atomic_read(&sig->count) != 1);
> 
> This is not safe without the rmb() in between. The results of two correctly
> ordered __exit_signal()->atomic_dec_and_test()'s could be seen out of order
> on our CPU.
> 
> The same is true for the "thread_group_empty()" case, __unhash_process()'s
> changes could be seen before atomic_dec_and_test(&sig->count).
> 
> On some platforms (including i386) atomic_read() doesn't provide even the
> compiler barrier, in that case these checks are simply racy.
> 
> Remove these BUG_ON()'s. Alternatively, we can do something like
> 
> 	BUG_ON( ({ smp_rmb(); atomic_read(&sig->count) != 1; }) );

Good catches!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> --- t/fs/exec.c~1_BUG_ON	2007-08-18 17:36:58.000000000 +0400
> +++ t/fs/exec.c	2007-08-18 18:19:41.000000000 +0400
> @@ -784,7 +784,6 @@ static int de_thread(struct task_struct 
>  	 * and we can just re-use it all.
>  	 */
>  	if (atomic_read(&oldsighand->count) <= 1) {
> -		BUG_ON(atomic_read(&sig->count) != 1);
>  		signalfd_detach(tsk);
>  		exit_itimers(sig);
>  		return 0;
> @@ -929,8 +928,6 @@ no_thread_group:
>  	if (leader)
>  		release_task(leader);
> 
> -	BUG_ON(atomic_read(&sig->count) != 1);
> -
>  	if (atomic_read(&oldsighand->count) == 1) {
>  		/*
>  		 * Now that we nuked the rest of the thread group,
> 
