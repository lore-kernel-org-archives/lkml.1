Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYBBLXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYBBLXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 06:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbYBBLXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 06:23:24 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47786 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754192AbYBBLXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 06:23:23 -0500
Date: Sat, 2 Feb 2008 12:23:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Paul.Clements@steeleye.com, nbd-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow NBD to be used locally
Message-ID: <20080202112336.GB5362@elf.ucw.cz>
References: <1201872332265-git-send-email-Laurent.Vivier@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201872332265-git-send-email-Laurent.Vivier@bull.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-01 14:25:32, Laurent Vivier wrote:
> This patch allows Network Block Device to be mounted locally.

What is local nbd good for? Use loop instead...

> It creates a kthread to avoid the deadlock described in NBD tools documentation.
> So, if nbd-client hangs waiting pages, the kblockd thread can continue its
> work and free pages.

Hmm, and if there are no other pages that can be freed? Unlikely, but
can happen AFAICT.

									Pavel



> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
> ---
>  drivers/block/nbd.c |  146 ++++++++++++++++++++++++++++++++++-----------------
>  include/linux/nbd.h |    4 +-
>  2 files changed, 100 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index b4c0888..de6685e 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -29,6 +29,7 @@
>  #include <linux/kernel.h>
>  #include <net/sock.h>
>  #include <linux/net.h>
> +#include <linux/kthread.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
> @@ -434,6 +435,87 @@ static void nbd_clear_que(struct nbd_device *lo)
>  }
>  
>  
> +static void nbd_handle_req(struct nbd_device *lo, struct request *req)
> +{
> +	if (!blk_fs_request(req))
> +		goto error_out;
> +
> +	nbd_cmd(req) = NBD_CMD_READ;
> +	if (rq_data_dir(req) == WRITE) {
> +		nbd_cmd(req) = NBD_CMD_WRITE;
> +		if (lo->flags & NBD_READ_ONLY) {
> +			printk(KERN_ERR "%s: Write on read-only\n",
> +					lo->disk->disk_name);
> +			goto error_out;
> +		}
> +	}
> +
> +	req->errors = 0;
> +
> +	mutex_lock(&lo->tx_lock);
> +	if (unlikely(!lo->sock)) {
> +		mutex_unlock(&lo->tx_lock);
> +		printk(KERN_ERR "%s: Attempted send on closed socket\n",
> +		       lo->disk->disk_name);
> +		req->errors++;
> +		nbd_end_request(req);
> +		return;
> +	}
> +
> +	lo->active_req = req;
> +
> +	if (nbd_send_req(lo, req) != 0) {
> +		printk(KERN_ERR "%s: Request send failed\n",
> +				lo->disk->disk_name);
> +		req->errors++;
> +		nbd_end_request(req);
> +	} else {
> +		spin_lock(&lo->queue_lock);
> +		list_add(&req->queuelist, &lo->queue_head);
> +		spin_unlock(&lo->queue_lock);
> +	}
> +
> +	lo->active_req = NULL;
> +	mutex_unlock(&lo->tx_lock);
> +	wake_up_all(&lo->active_wq);
> +
> +	return;
> +
> +error_out:
> +	req->errors++;
> +	nbd_end_request(req);
> +}
> +
> +static int nbd_thread(void *data)
> +{
> +	struct nbd_device *lo = data;
> +	struct request *req;
> +
> +	set_user_nice(current, -20);
> +	while (!kthread_should_stop() || !list_empty(&lo->waiting_queue)) {
> +		/* wait something to do */
> +		wait_event_interruptible(lo->waiting_wq,
> +					 kthread_should_stop() ||
> +					 !list_empty(&lo->waiting_queue));
> +
> +		/* extract request */
> +
> +		if (list_empty(&lo->waiting_queue))
> +			continue;
> +
> +		spin_lock_irq(&lo->queue_lock);
> +		req = list_entry(lo->waiting_queue.next, struct request,
> +				 queuelist);
> +		list_del_init(&req->queuelist);
> +		spin_unlock_irq(&lo->queue_lock);
> +
> +		/* handle request */
> +
> +		nbd_handle_req(lo, req);
> +	}
> +	return 0;
> +}
> +
>  /*
>   * We always wait for result of write, for now. It would be nice to make it optional
>   * in future
> @@ -449,65 +531,23 @@ static void do_nbd_request(struct request_queue * q)
>  		struct nbd_device *lo;
>  
>  		blkdev_dequeue_request(req);
> +
> +		spin_unlock_irq(q->queue_lock);
> +
>  		dprintk(DBG_BLKDEV, "%s: request %p: dequeued (flags=%x)\n",
>  				req->rq_disk->disk_name, req, req->cmd_type);
>  
> -		if (!blk_fs_request(req))
> -			goto error_out;
> -
>  		lo = req->rq_disk->private_data;
>  
>  		BUG_ON(lo->magic != LO_MAGIC);
>  
> -		nbd_cmd(req) = NBD_CMD_READ;
> -		if (rq_data_dir(req) == WRITE) {
> -			nbd_cmd(req) = NBD_CMD_WRITE;
> -			if (lo->flags & NBD_READ_ONLY) {
> -				printk(KERN_ERR "%s: Write on read-only\n",
> -						lo->disk->disk_name);
> -				goto error_out;
> -			}
> -		}
> +		spin_lock_irq(&lo->queue_lock);
> +		list_add_tail(&req->queuelist, &lo->waiting_queue);
> +		spin_unlock_irq(&lo->queue_lock);
>  
> -		req->errors = 0;
> -		spin_unlock_irq(q->queue_lock);
> -
> -		mutex_lock(&lo->tx_lock);
> -		if (unlikely(!lo->sock)) {
> -			mutex_unlock(&lo->tx_lock);
> -			printk(KERN_ERR "%s: Attempted send on closed socket\n",
> -			       lo->disk->disk_name);
> -			req->errors++;
> -			nbd_end_request(req);
> -			spin_lock_irq(q->queue_lock);
> -			continue;
> -		}
> -
> -		lo->active_req = req;
> -
> -		if (nbd_send_req(lo, req) != 0) {
> -			printk(KERN_ERR "%s: Request send failed\n",
> -					lo->disk->disk_name);
> -			req->errors++;
> -			nbd_end_request(req);
> -		} else {
> -			spin_lock(&lo->queue_lock);
> -			list_add(&req->queuelist, &lo->queue_head);
> -			spin_unlock(&lo->queue_lock);
> -		}
> -
> -		lo->active_req = NULL;
> -		mutex_unlock(&lo->tx_lock);
> -		wake_up_all(&lo->active_wq);
> +		wake_up(&lo->waiting_wq);
>  
>  		spin_lock_irq(q->queue_lock);
> -		continue;
> -
> -error_out:
> -		req->errors++;
> -		spin_unlock(q->queue_lock);
> -		nbd_end_request(req);
> -		spin_lock(q->queue_lock);
>  	}
>  }
>  
> @@ -517,6 +557,7 @@ static int nbd_ioctl(struct inode *inode, struct file *file,
>  	struct nbd_device *lo = inode->i_bdev->bd_disk->private_data;
>  	int error;
>  	struct request sreq ;
> +	struct task_struct *thread;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -599,7 +640,12 @@ static int nbd_ioctl(struct inode *inode, struct file *file,
>  	case NBD_DO_IT:
>  		if (!lo->file)
>  			return -EINVAL;
> +		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
> +		if (IS_ERR(thread))
> +			return PTR_ERR(thread);
> +		wake_up_process(thread);
>  		error = nbd_do_it(lo);
> +		kthread_stop(thread);
>  		if (error)
>  			return error;
>  		sock_shutdown(lo, 1);
> @@ -684,10 +730,12 @@ static int __init nbd_init(void)
>  		nbd_dev[i].file = NULL;
>  		nbd_dev[i].magic = LO_MAGIC;
>  		nbd_dev[i].flags = 0;
> +		INIT_LIST_HEAD(&nbd_dev[i].waiting_queue);
>  		spin_lock_init(&nbd_dev[i].queue_lock);
>  		INIT_LIST_HEAD(&nbd_dev[i].queue_head);
>  		mutex_init(&nbd_dev[i].tx_lock);
>  		init_waitqueue_head(&nbd_dev[i].active_wq);
> +		init_waitqueue_head(&nbd_dev[i].waiting_wq);
>  		nbd_dev[i].blksize = 1024;
>  		nbd_dev[i].bytesize = 0;
>  		disk->major = NBD_MAJOR;
> diff --git a/include/linux/nbd.h b/include/linux/nbd.h
> index cc2b472..94f40c9 100644
> --- a/include/linux/nbd.h
> +++ b/include/linux/nbd.h
> @@ -57,9 +57,11 @@ struct nbd_device {
>  	int magic;
>  
>  	spinlock_t queue_lock;
> -	struct list_head queue_head;/* Requests are added here...	*/
> +	struct list_head queue_head;	/* Requests waiting result */
>  	struct request *active_req;
>  	wait_queue_head_t active_wq;
> +	struct list_head waiting_queue;	/* Requests to be sent */
> +	wait_queue_head_t waiting_wq;
>  
>  	struct mutex tx_lock;
>  	struct gendisk *disk;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
