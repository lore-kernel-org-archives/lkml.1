Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYKZG2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYKZG2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYKZG16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:27:58 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:41905 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbYKZG15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:27:57 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 25 Nov 2008 22:27:38 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tejun Heo <htejun@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] poll: allow f_op->poll to sleep, take#5
In-Reply-To: <492CD358.2020603@gmail.com>
Message-ID: <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com>
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Tejun Heo wrote:

> +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
> +{
> +	struct poll_wqueues *pwq = wait->private;
> +	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
> +
> +	/*
> +	 * Wake up functions have full barrier semantics, no need for
> +	 * barrier here.
> +	 */
> +	pwq->triggered = 1;
> +
> +	/*
> +	 * Perform the default wake up operation using a dummy
> +	 * waitqueue.
> +	 *
> +	 * TODO: This is hacky but there currently is no interface to
> +	 * pass in @sync.  @sync is scheduled to be removed and once
> +	 * that happens, wake_up_process() can be used directly.
> +	 */
> +	return default_wake_function(&dummy_wait, mode, sync, key);
> +}
> +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> +			  ktime_t *expires, unsigned long slack)
> +{
> +	int rc = -EINTR;
> +
> +	set_current_state(state);
> +	if (!pwq->triggered)
> +		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
> +	__set_current_state(TASK_RUNNING);
> +
> +	/*
> +	 * Prepare for the next iteration.  ->poll() might not have
> +	 * enough barrier semantics from the second round as waits are
> +	 * registered only during the first one.  Use set_mb().
> +	 */
> +	set_mb(pwq->triggered, 0);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(poll_schedule_timeout);

Look, pollwake() does:

w1) WR triggered (1)
w2) WMB
w3) WR task->state (RUNNING)

While poll_schedule_timeout() does:

s1) WR task->state (TASK_INTERRUPTIBLE)
s2) MB
s3) RD triggered
s4) IF0 => RD task->state (if !RUNNING -> sleep)


The only risk is that w3 preceed s1, so that we go to sleep even though a 
wakeup has been issued. But if w3 is visible, w1 is visible too, that 
means that 'triggered' is visible in s3 (there's a MB in s2). So we skip 
the schedule_hrtimeout_range(). So IMO you need no barriers on 'triggered'.
If you feel you need barriers, do you mind explaning a sequence of events 
that makes a barrier-free version break?



- Davide


