Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXDAJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXDAJFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 05:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbXDAJFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 05:05:40 -0400
Received: from www.osadl.org ([213.239.205.134]:50034 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932247AbXDAJFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 05:05:39 -0400
Subject: Re: [patch 6/13] signal/timer/event fds v9 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.16816.1175371772.6>
References: <send-serie.davidel@xmailserver.org.16816.1175371772.6>
Content-Type: text/plain
Date: Sun, 01 Apr 2007 11:05:41 +0200
Message-Id: <1175418341.28263.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 13:09 -0700, Davide Libenzi wrote:
> +/*
> + * This gets called when the timer event triggers. We increment the
> + * tick count and wake the possible waiters. If the timer in a
> + * sequential one (->tintv.tv64 != 0), we re-arm it with hrtimer_forward().
> + */
> +static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
> +{
> +	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
> +	enum hrtimer_restart rval = HRTIMER_NORESTART;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +	ctx->ticks++;
> +	wake_up_locked(&ctx->wqh);
> +	if (ctx->tintv.tv64 != 0) {
> +		hrtimer_forward(htmr, hrtimer_cb_get_time(htmr), ctx->tintv);
> +		rval = HRTIMER_RESTART;
> +	}
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	return rval;
> +}

For periodic timers we probably want to know also about missed ticks,
i.e. when the timer was delayed.

I changed recently the rearm handling code of itimers to prevent DoS
attacks. See commit 8bfd9a7a229b5f3d3eda5d7d45c2eebec5b4ba16. The posix
timer code has a similar mechanism.

Probably we should do the same here. That means that we defer the
restart of the timer to the process context.

	tglx

static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
{
       struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
       unsigned long flags;

       spin_lock_irqsave(&ctx->lock, flags);
       ctx->expired = 1;
       wake_up_locked(&ctx->wqh);
       spin_unlock_irqrestore(&ctx->lock, flags);

       return HRTIMER_NORESTART;
}

static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
                           loff_t *ppos)
{
       struct timerfd_ctx *ctx = file->private_data;
       ssize_t res;
       u32 ticks = 0;
       DECLARE_WAITQUEUE(wait, current);

       if (count < sizeof(ticks))
               return -EINVAL;
       spin_lock_irq(&ctx->lock);
       res = -EAGAIN;
       if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
               __add_wait_queue(&ctx->wqh, &wait);
               for (res = 0;;) {
                       set_current_state(TASK_INTERRUPTIBLE);
                       if (ctx->expired) {
                               res = 0;
                               break;
                       }
                       if (signal_pending(current)) {
                               res = -ERESTARTSYS;
                               break;
                       }
                       spin_unlock_irq(&ctx->lock);
                       schedule();
                       spin_lock_irq(&ctx->lock);
               }
               __remove_wait_queue(&ctx->wqh, &wait);
               __set_current_state(TASK_RUNNING);
       }
       if (ctx->expired) {
               	ctx->expired = 0;
		if (ctx->tintv.tv64 != 0) {
			ticks = hrtimer_forward(&ctx->tmr, ktime_get(),
						ctx->tintv);
			hrtimer_restart(&ctx->tmr);
		} else
			ticks = 1;
	}
       spin_unlock_irq(&ctx->lock);
       if (ticks)
               res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
       return res;
}


