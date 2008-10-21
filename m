Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYJUWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYJUWPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYJUWPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:15:37 -0400
Received: from ozlabs.org ([203.10.76.45]:53776 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYJUWPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:15:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH/RFC v2 2/6] workqueue: introduce create_rt_workqueue
Date: Wed, 22 Oct 2008 09:15:27 +1100
User-Agent: KMail/1.9.10
Cc: jens.axboe@oracle.com, mingo@elte.hu, akpm@linux-foundation.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
References: <20081013215007.634620563@de.ibm.com> <20081013215130.891702049@de.ibm.com>
In-Reply-To: <20081013215130.891702049@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810220915.28083.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 October 2008 08:50:09 Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> create_rt_workqueue will create a real time prioritized workqueue.
> This is needed for the conversion of stop_machine to a workqueue based
> implementation.
> This patch adds yet another parameter to __create_workqueue_key to tell
> it that we want an rt workqueue.
> However it looks like we rather should have something like "int type"
> instead of singlethread, freezable and rt.

Ingo didn't ack this, but he didn't nack it either and it's a straightforward 
transformation.  If we want to enum the type we can always do it later.

I'll push this now as part of my stop_machine and module series.

Thanks!
Rusty.


>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/linux/workqueue.h |   18 ++++++++++--------
>  kernel/workqueue.c        |    7 ++++++-
>  2 files changed, 16 insertions(+), 9 deletions(-)
>
> Index: linux-2.6/include/linux/workqueue.h
> ===================================================================
> --- linux-2.6.orig/include/linux/workqueue.h
> +++ linux-2.6/include/linux/workqueue.h
> @@ -149,11 +149,11 @@ struct execute_work {
>
>  extern struct workqueue_struct *
>  __create_workqueue_key(const char *name, int singlethread,
> -		       int freezeable, struct lock_class_key *key,
> +		       int freezeable, int rt, struct lock_class_key *key,
>  		       const char *lock_name);
>
>  #ifdef CONFIG_LOCKDEP
> -#define __create_workqueue(name, singlethread, freezeable)	\
> +#define __create_workqueue(name, singlethread, freezeable, rt)	\
>  ({								\
>  	static struct lock_class_key __key;			\
>  	const char *__lock_name;				\
> @@ -164,17 +164,19 @@ __create_workqueue_key(const char *name,
>  		__lock_name = #name;				\
>  								\
>  	__create_workqueue_key((name), (singlethread),		\
> -			       (freezeable), &__key,		\
> +			       (freezeable), (rt), &__key,	\
>  			       __lock_name);			\
>  })
>  #else
> -#define __create_workqueue(name, singlethread, freezeable)	\
> -	__create_workqueue_key((name), (singlethread), (freezeable), NULL, NULL)
> +#define __create_workqueue(name, singlethread, freezeable, rt)	\
> +	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
> +			       NULL, NULL)
>  #endif
>
> -#define create_workqueue(name) __create_workqueue((name), 0, 0)
> -#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
> -#define create_singlethread_workqueue(name) __create_workqueue((name), 1,
> 0) +#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
> +#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
> +#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1,
> 0) +#define create_singlethread_workqueue(name) __create_workqueue((name),
> 1, 0, 0)
>
>  extern void destroy_workqueue(struct workqueue_struct *wq);
>
> Index: linux-2.6/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.orig/kernel/workqueue.c
> +++ linux-2.6/kernel/workqueue.c
> @@ -62,6 +62,7 @@ struct workqueue_struct {
>  	const char *name;
>  	int singlethread;
>  	int freezeable;		/* Freeze threads during suspend */
> +	int rt;
>  #ifdef CONFIG_LOCKDEP
>  	struct lockdep_map lockdep_map;
>  #endif
> @@ -766,6 +767,7 @@ init_cpu_workqueue(struct workqueue_stru
>
>  static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int
> cpu) {
> +	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>  	struct workqueue_struct *wq = cwq->wq;
>  	const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
>  	struct task_struct *p;
> @@ -781,7 +783,8 @@ static int create_workqueue_thread(struc
>  	 */
>  	if (IS_ERR(p))
>  		return PTR_ERR(p);
> -
> +	if (cwq->wq->rt)
> +		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
>  	cwq->thread = p;
>
>  	return 0;
> @@ -801,6 +804,7 @@ static void start_workqueue_thread(struc
>  struct workqueue_struct *__create_workqueue_key(const char *name,
>  						int singlethread,
>  						int freezeable,
> +						int rt,
>  						struct lock_class_key *key,
>  						const char *lock_name)
>  {
> @@ -822,6 +826,7 @@ struct workqueue_struct *__create_workqu
>  	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
>  	wq->singlethread = singlethread;
>  	wq->freezeable = freezeable;
> +	wq->rt = rt;
>  	INIT_LIST_HEAD(&wq->list);
>
>  	if (singlethread) {


