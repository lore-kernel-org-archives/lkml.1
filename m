Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbXKMPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbXKMPZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXKMPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:25:34 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:37916 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493AbXKMPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:25:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALZQOUdMROHU/2dsb2JhbACBWw
Date: Tue, 13 Nov 2007 10:25:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add markers into semaphore primitives
Message-ID: <20071113152530.GA21915@Krystal>
References: <1194915156.913.4.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1194915156.913.4.camel@lc4eb748232119.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:23:58 up 9 days, 20:29,  3 users,  load average: 0.40, 0.71,
	0.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* David J. Wilder (dwilder@us.ibm.com) wrote:
> This patch adds several markers around semaphore primitives.
> Along with a tracing application this patch can be useful for measuring
> kernel semaphore usage and contention.
> 

Yup, looks good. I'll take it into my instrumentation patchset.

I'll soon submit the markers-over-immediate values. The performance
tests should be done upon this optimized version.

Mathieu

> Signed-off-by: Mike Mason <mmlnx@us.ibm.com>
> Signed-off-by: David Wilder <dwilder@us.ibm.com>
> ---
>  lib/semaphore-sleepers.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/semaphore-sleepers.c b/lib/semaphore-sleepers.c
> index 1281805..5343a96 100644
> --- a/lib/semaphore-sleepers.c
> +++ b/lib/semaphore-sleepers.c
> @@ -15,6 +15,7 @@
>  #include <linux/sched.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
> +#include <linux/marker.h>
>  #include <asm/semaphore.h>
>  
>  /*
> @@ -50,6 +51,7 @@
>  
>  fastcall void __up(struct semaphore *sem)
>  {
> +	trace_mark(sem_up, "%p", sem);
>  	wake_up(&sem->wait);
>  }
>  
> @@ -59,6 +61,7 @@ fastcall void __sched __down(struct semaphore * sem)
>  	DECLARE_WAITQUEUE(wait, tsk);
>  	unsigned long flags;
>  
> +	trace_mark(sem_down, "%p", sem);
>  	tsk->state = TASK_UNINTERRUPTIBLE;
>  	spin_lock_irqsave(&sem->wait.lock, flags);
>  	add_wait_queue_exclusive_locked(&sem->wait, &wait);
> @@ -73,12 +76,14 @@ fastcall void __sched __down(struct semaphore * sem)
>  		 * the wait_queue_head.
>  		 */
>  		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
> +			trace_mark(sem_down_resume, "%p", sem);
>  			sem->sleepers = 0;
>  			break;
>  		}
>  		sem->sleepers = 1;	/* us - see -1 above */
>  		spin_unlock_irqrestore(&sem->wait.lock, flags);
>  
> +		trace_mark(sem_down_sched, "%p", sem);
>  		schedule();
>  
>  		spin_lock_irqsave(&sem->wait.lock, flags);
> @@ -97,6 +102,7 @@ fastcall int __sched __down_interruptible(struct semaphore * sem)
>  	DECLARE_WAITQUEUE(wait, tsk);
>  	unsigned long flags;
>  
> +	trace_mark(sem_down_intr, "%p", sem);
>  	tsk->state = TASK_INTERRUPTIBLE;
>  	spin_lock_irqsave(&sem->wait.lock, flags);
>  	add_wait_queue_exclusive_locked(&sem->wait, &wait);
> @@ -113,6 +119,7 @@ fastcall int __sched __down_interruptible(struct semaphore * sem)
>  		 * and exit.
>  		 */
>  		if (signal_pending(current)) {
> +			trace_mark(sem_down_intr_fail, "%p", sem);
>  			retval = -EINTR;
>  			sem->sleepers = 0;
>  			atomic_add(sleepers, &sem->count);
> @@ -126,12 +133,14 @@ fastcall int __sched __down_interruptible(struct semaphore * sem)
>  		 * still hoping to get the semaphore.
>  		 */
>  		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
> +			trace_mark(sem_down_intr_resume, "%p", sem);
>  			sem->sleepers = 0;
>  			break;
>  		}
>  		sem->sleepers = 1;	/* us - see -1 above */
>  		spin_unlock_irqrestore(&sem->wait.lock, flags);
>  
> +		trace_mark(sem_down_intr_sched, "%p", sem);
>  		schedule();
>  
>  		spin_lock_irqsave(&sem->wait.lock, flags);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
