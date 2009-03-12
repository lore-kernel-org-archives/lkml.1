Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbZCLKOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbZCLKOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZCLKNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:13:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:36674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZCLKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:13:53 -0400
Subject: Re: [PATCH 5/6] futex: unlock before returning -EFAULT
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20090312075606.9856.88729.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
	 <20090312075606.9856.88729.stgit@Aeon>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 11:13:36 +0100
Message-Id: <1236852816.5090.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 00:56 -0700, Darren Hart wrote:
> futex_lock_pi can potentially return -EFAULT with the rt_mutex held.  This
> seems like the wrong thing to do as userspace should assume -EFAULT means the
> lock was not taken.  Even if it could figure this out, we'd be leaving the
> pi_state->owner in an inconsistent state.  This patch unlocks the rt_mutex
> prior to returning -EFAULT to userspace.

lockdep would complain, one is not to leave the kernel with locks held.

> Build and boot tested on a 4 way Intel x86_64 workstation.  Passes basic
> pthread_mutex and PI tests out of ltp/testcases/realtime.

You keep mentioning these tests.. makes me wonder how much of the futex
code paths they actually test. Got any coverage info on them?

> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
> 
>  kernel/futex.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6579912..c980a55 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1567,6 +1567,13 @@ retry_locked:
>  		}
>  	}
>  
> +	/*
> +	 * If fixup_pi_state_owner() faulted and was unable to handle the
> +	 * fault, unlock it and return the fault to userspace.
> +	 */
> +	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
> +		rt_mutex_unlock(&q.pi_state->pi_mutex);
> +
>  	/* Unqueue and drop the lock */
>  	unqueue_me_pi(&q);
>  
> 

