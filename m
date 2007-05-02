Return-Path: <linux-kernel-owner+w=401wt.eu-S1766954AbXEBVNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766954AbXEBVNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767022AbXEBVNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:13:48 -0400
Received: from www.osadl.org ([213.239.205.134]:50675 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766954AbXEBVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:13:46 -0400
Subject: Re: [patch 09/22] pollfs: pollable hrtimers
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davi Arnaut <davi@haxent.com.br>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070502053426.030750000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053426.030750000@haxent.com.br>
Content-Type: text/plain
Date: Wed, 02 May 2007 23:16:07 +0200
Message-Id: <1178140567.2340.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 02:22 -0300, Davi Arnaut wrote:
> plain text document attachment (pollfs-timer.patch)
> Per file descriptor high-resolution timers. A classic unix file interface for
> the POSIX timer_(create|settime|gettime|delete) family of functions.
> 
> Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

Nacked-by-me.

Aside of the fact, that it is a bad clone of the timerfd code, it is
simply broken and untested.

> +
> +struct hrtimerspec {
> +	int flags;
> +	clockid_t clock;
> +	struct itimerspec expr;
> +};

How exactly knows userspace what a struct hrtimerspec is ? Is the c file
exported as a header ?

> +static ssize_t read(struct pfs_timer *evs, struct itimerspec __user *uspec)
> +{
> +	int ret = -EAGAIN;
> +	ktime_t remaining = {};
> +	unsigned long overruns = 0;
> +	struct itimerspec spec = {};
> +	struct hrtimer *timer = &evs->timer;
> +
> +	spin_lock_irq(&evs->lock);
> +
> +	if (!evs->overruns)
> +		goto out_unlock;
> +
> +	if (hrtimer_active(timer))
> +		remaining = hrtimer_get_remaining(timer);
> +	else if (evs->interval.tv64 > 0)
> +		overruns = hrtimer_forward(timer, hrtimer_cb_get_time(timer),
> +					   evs->interval);

Where is the logic here ? 

If no overrun, return remaining time = 0

If active, return the real remaining time. This path is never hit, as
the timer is nowhere restarted.

If not active, return remanining time = 0. How does the caller know how
many events are missed ? 

> +	ret = -EOVERFLOW;
> +	if (overruns > (ULONG_MAX - evs->overruns))
> +		goto out_unlock;
> +	else
> +		evs->overruns += overruns;

Interesting feature. evs->overruns is adding up forever and then limited
to ULONG_MAX

> +static enum hrtimer_restart timer_fn(struct hrtimer *timer)
> +{
> +	struct pfs_timer *evs = container_of(timer, struct pfs_timer, timer);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&evs->lock, flags);
> +	/* timer tick, interval has elapsed */
> +	if (!evs->overruns++)
> +		wake_up_all(&evs->wait);

Cool. Waiters, which came after the first event are stuck. Simply
because there is no second event.

> +static ssize_t write(struct pfs_timer *evs,
> +		     const struct hrtimerspec __user *uspec)
> +{
> +	struct hrtimerspec spec;

See first comment !

> +	if (copy_from_user(&spec, uspec, sizeof(spec)))
> +		return -EFAULT;
> +
> +	if (spec_invalid(&spec))
> +		return -EINVAL;
> +
> +	rearm_timer(evs, &spec);
> +
> +	return 0;
> +}
> +
> +static int poll(struct pfs_timer *evs)
> +{
> +	int ret;
> +
> +	ret = evs->overruns ? POLLIN : 0;
> +
> +	return ret;
> +}

Creative lockless programming style with 4 lines overhead and a
guaranteed return POLLIN after the first timer event. This is really
cute as it covers the missing timer restart and guarantees 100% CPU load
for ever. Hmm, maybe it's correct: polling should loop for ever,
shouldn't it ?

> +static const struct pfs_operations timer_ops = {
> +	.read = PFS_READ(read, struct pfs_timer, struct itimerspec),
> +	.write = PFS_WRITE(write, struct pfs_timer, struct hrtimerspec),
> +	.poll = PFS_POLL(poll, struct pfs_timer),
> +	.release = PFS_RELEASE(release, struct pfs_timer),
> +	.rsize = sizeof(struct itimerspec),
> +	.wsize = sizeof(struct hrtimerspec),

See first comment !

	tglx



