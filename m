Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbZEMLCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbZEMLCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbZEMLCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:02:35 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:44063 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622AbZEMLCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:02:34 -0400
Date: Wed, 13 May 2009 13:02:33 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: tom.leiming@gmail.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] kernel:async function call:introduce async_run
Message-ID: <20090513130233.082eeee5@gondolin>
In-Reply-To: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
References: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 08:33:49 +0800,
tom.leiming@gmail.com wrote:

> From: Ming Lei <tom.leiming@gmail.com>
> 
> In fact, some async function call does not need to check, async_run
> is right for this kind of function call. Also, async_run is very
> suitable to used to start a thread in atomic context to do somthing,
> for now there is no such kind of kernel api, eg. kthread_run
> can not be started in atomic context.

Could you rework your explanation a bit? If I understand correctly, you
want to introduce a way to queue an async thread for those callers that
don't want to synchronize on cookies.

> 
> This patch is againt my another patch:
>    kernel/async.c:introduce async_schedule*_atomic
> please review.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  include/linux/async.h |    1 +
>  kernel/async.c        |   24 +++++++++++++++++++++++-
>  2 files changed, 24 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/async.h b/include/linux/async.h
> index ede9849..5390572 100644
> --- a/include/linux/async.h
> +++ b/include/linux/async.h
> @@ -16,6 +16,7 @@
>  typedef u64 async_cookie_t;
>  typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
> 
> +extern void async_run(async_func_ptr *ptr, void *data);
>  extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
>  extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
>  					    struct list_head *list);
> diff --git a/kernel/async.c b/kernel/async.c
> index 6bf565b..9cc4670 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -60,6 +60,7 @@ asynchronous and synchronous parts of the kernel.
> 
>  static async_cookie_t next_cookie = 1;
> 
> +#define MAX_COOKIE	(~0)
>  #define MAX_THREADS	256
>  #define MAX_WORK	32768
> 
> @@ -207,7 +208,10 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
>  	entry->running = running;
> 
>  	spin_lock_irqsave(&async_lock, flags);
> -	newcookie = entry->cookie = next_cookie++;
> +	if (atomic == 1)
> +		newcookie = entry->cookie = next_cookie++;
> +	else
> +		newcookie = entry->cookie = MAX_COOKIE;

This confuses me. Why do you change the behaviour for atomic == 0?

>  	list_add_tail(&entry->list, &async_pending);
>  	atomic_inc(&entry_count);
>  	spin_unlock_irqrestore(&async_lock, flags);
> @@ -216,6 +220,24 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
>  }
> 
>  /**
> + * async_run - schedule a function for asynchronous execution
> + * @ptr: function to execute asynchronously
> + * @data: data pointer to pass to the function
> + *
> + * Note:we do not allocate a cookie for this kind of aysnchronous
> + * function to decrease the wait time of async_synchronize_full().

But async_synchronize_full() still waits for list_empty(&async_running)
- so what does this buy us?

> + * In fact, some function does not need to check, async_run is right
> + * for this kind of function call. Also, async_run is very suitable to
> + * start a thread to do somthing in atomic context,for now there is no such
> + * kind of kernel api, eg. kthread_run can not be run in atomic context.

Hm...
"The purpose of this function is to offer a simple way to schedule an
asynchronous thread, especially from an atomic context."
Would that describe async_run() better?

Doesn't this function need a return code since queueing the async work
can fail?

> + */
> +void async_run(async_func_ptr *ptr, void *data)
> +{
> +	__async_schedule(ptr, data, &async_running, 2);

I don't like the overloading of the "atomic" value - if I causually
looked at the declaration of __async_schedule(), I'd think it would be
a kind of boolean value...

> +}
> +EXPORT_SYMBOL_GPL(async_run);
> +
> +/**
>   * async_schedule - schedule a function for asynchronous execution
>   * @ptr: function to execute asynchronously
>   * @data: data pointer to pass to the function


