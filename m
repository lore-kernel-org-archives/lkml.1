Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZKLNja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZKLNja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZKLNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:39:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbZKLNj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:39:27 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, bcrl@kvack.org,
       zach.brown@oracle.com
Subject: Re: [PATCH]aio: remove unused field
References: <20091112075247.GA17960@sli10-desk.sh.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Nov 2009 08:39:22 -0500
In-Reply-To: <20091112075247.GA17960@sli10-desk.sh.intel.com> (Shaohua Li's
	message of "Thu, 12 Nov 2009 15:52:47 +0800")
Message-ID: <x49iqdfsvzp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> Don't know the reason, but it appears ki_wait field of iocb never gets used.

This looks like it should be rolled into Zach's patch series to get rid
of the retry based aio scheme.

Cheers,
Jeff

> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 02a2c93..5ec1e70 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -697,10 +697,8 @@ static ssize_t aio_run_iocb(struct kiocb *iocb)
>  	 */
>  	ret = retry(iocb);
>  
> -	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
> -		BUG_ON(!list_empty(&iocb->ki_wait.task_list));
> +	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED)
>  		aio_complete(iocb, ret, 0);
> -	}
>  out:
>  	spin_lock_irq(&ctx->ctx_lock);
>  
> @@ -852,13 +850,6 @@ static void try_queue_kicked_iocb(struct kiocb *iocb)
>  	unsigned long flags;
>  	int run = 0;
>  
> -	/* We're supposed to be the only path putting the iocb back on the run
> -	 * list.  If we find that the iocb is *back* on a wait queue already
> -	 * than retry has happened before we could queue the iocb.  This also
> -	 * means that the retry could have completed and freed our iocb, no
> -	 * good. */
> -	BUG_ON((!list_empty(&iocb->ki_wait.task_list)));
> -
>  	spin_lock_irqsave(&ctx->ctx_lock, flags);
>  	/* set this inside the lock so that we can't race with aio_run_iocb()
>  	 * testing it and putting the iocb on the run list under the lock */
> @@ -1506,31 +1497,6 @@ static ssize_t aio_setup_iocb(struct kiocb *kiocb)
>  	return 0;
>  }
>  
> -/*
> - * aio_wake_function:
> - * 	wait queue callback function for aio notification,
> - * 	Simply triggers a retry of the operation via kick_iocb.
> - *
> - * 	This callback is specified in the wait queue entry in
> - *	a kiocb.
> - *
> - * Note:
> - * This routine is executed with the wait queue lock held.
> - * Since kick_iocb acquires iocb->ctx->ctx_lock, it nests
> - * the ioctx lock inside the wait queue lock. This is safe
> - * because this callback isn't used for wait queues which
> - * are nested inside ioctx lock (i.e. ctx->wait)
> - */
> -static int aio_wake_function(wait_queue_t *wait, unsigned mode,
> -			     int sync, void *key)
> -{
> -	struct kiocb *iocb = container_of(wait, struct kiocb, ki_wait);
> -
> -	list_del_init(&wait->task_list);
> -	kick_iocb(iocb);
> -	return 1;
> -}
> -
>  static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  			 struct iocb *iocb)
>  {
> @@ -1592,8 +1558,6 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
>  	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
>  	req->ki_opcode = iocb->aio_lio_opcode;
> -	init_waitqueue_func_entry(&req->ki_wait, aio_wake_function);
> -	INIT_LIST_HEAD(&req->ki_wait.task_list);
>  
>  	ret = aio_setup_iocb(req);
>  
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index aea219d..811dbb3 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -102,7 +102,6 @@ struct kiocb {
>  	} ki_obj;
>  
>  	__u64			ki_user_data;	/* user's data for completion */
> -	wait_queue_t		ki_wait;
>  	loff_t			ki_pos;
>  
>  	void			*private;
> @@ -140,7 +139,6 @@ struct kiocb {
>  		(x)->ki_dtor = NULL;			\
>  		(x)->ki_obj.tsk = tsk;			\
>  		(x)->ki_user_data = 0;                  \
> -		init_wait((&(x)->ki_wait));             \
>  	} while (0)
>  
>  #define AIO_RING_MAGIC			0xa10a10a1
> @@ -223,8 +221,6 @@ struct mm_struct;
>  static inline void exit_aio(struct mm_struct *mm) { }
>  #endif /* CONFIG_AIO */
>  
> -#define io_wait_to_kiocb(wait) container_of(wait, struct kiocb, ki_wait)
> -
>  static inline struct kiocb *list_kiocb(struct list_head *h)
>  {
>  	return list_entry(h, struct kiocb, ki_list);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
