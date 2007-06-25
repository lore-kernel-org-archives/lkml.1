Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbXFYTfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbXFYTfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXFYTfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:35:11 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55129 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbXFYTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:35:09 -0400
Subject: [POSSIBLE BUG] use of tasklet_unlock in ipath_no_bufs_available
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Roland Dreier <rdreier@cisco.com>, mshefty@ichips.intel.com,
       halr@voltaire.com, openib-general@openib.org
Content-Type: text/plain
Date: Mon, 25 Jun 2007 15:33:14 -0400
Message-Id: <1182799994.5493.201.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As some of you know, lately I've been trying to get rid of tasklets. In
doing so, I've come across this usage of tasklet_unlock.

The only user of tasklet_unlock in the kernel outside of softirq.c is
ipath_no_bufs_available in drivers/inifiniband/hw/ipath/ipath_ruc.c

Here's the offending code:

void ipath_no_bufs_available(struct ipath_qp *qp, struct ipath_ibdev *dev)
{
	unsigned long flags;

	spin_lock_irqsave(&dev->pending_lock, flags);
	if (list_empty(&qp->piowait))
		list_add_tail(&qp->piowait, &dev->piowait);
	spin_unlock_irqrestore(&dev->pending_lock, flags);
	/*
	 * Note that as soon as want_buffer() is called and
	 * possibly before it returns, ipath_ib_piobufavail()
	 * could be called.  If we are still in the tasklet function,
	 * tasklet_hi_schedule() will not call us until the next time
	 * tasklet_hi_schedule() is called.
	 * We clear the tasklet flag now since we are committing to return
	 * from the tasklet function.
	 */
	clear_bit(IPATH_S_BUSY, &qp->s_flags);
	tasklet_unlock(&qp->s_task);
	want_buffer(dev->dd);
	dev->n_piowait++;
}


As the comment states, it looks like it's trying to prevent a race where
the want_buffer can allow for ipath_ib_piobufavail be called which would
schedule this tasklet again. But since the tasklet is running, it would
simply be skipped if it were to schedule on another CPU. And this would
mean that the tasklet would need to wait for it to be scheduled again
before doing the work.

  Is my above analysis correct?

Now for the BUG.

Lets say this situation does happen. Lets look at the code.

softirq.c: tasklet_hi_action

		if (tasklet_trylock(t)) {
			if (!atomic_read(&t->count)) {
				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
					BUG();
				t->func(t->data);
				tasklet_unlock(t);
				continue;
			}
			tasklet_unlock(t);
		}

The race being prevented is the failure of the tasklet_trylock running
on another CPU. The call to tasklet_unlock in ipath_no_bufs_available is
letting the other CPU succeed, and the comment suggests that this is OK
because this function will be exiting shortly. But what it doesn't take
into consideration is the above "tasklet_unlock" called again in
tasklet_hi_action.

So while the tasklet function is allowed to run on another CPU, we are
unlocking the tasklet on this CPU. So now this tasklet function is no
longer protected from being reentrant. There is now no guarantee that
the tasklet function would only be running on one CPU.

What's worse, we also add the chance of hitting the above BUG(). If the
tasklet gets scheduled again, takes an interrupt before doing the
tast_and_clear, another CPU runs the tasklet and clears the
TASKLET_STATE_SCHED, when the first instance comes back from the
interrupt, it will hit the BUG.

So, does all this make sense, or am I full of crap.  Still, I think
tasklet_unlock and tasklet_trylock should not be exported for anyone
else to use besides softirq.c and perhaps the ipath code needs to find a
better way around this.

-- Steve


