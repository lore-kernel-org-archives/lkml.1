Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbYDQPqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbYDQPqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934090AbYDQPp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:45:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49974 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933970AbYDQPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:45:56 -0400
Subject: Re: Semphore -> mutex in the device tree
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0804171117450.18040-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0804171117450.18040-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 17:45:53 +0200
Message-Id: <1208447153.7115.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 11:22 -0400, Alan Stern wrote:
> Peter:
> 
> The obstacle to converting the semaphore in struct device to a mutex 
> has been that its tree-oriented usage pattern isn't compatible with 
> lockdep.
> 
> In order to get around this and at least begin the conversion process,
> how about adding a provision for making some classes of mutex invisible
> to lockdep?  I know it doesn't solve the fundamental problem, but maybe
> it's a step in the right direction.

the device lock has two problems with lockdep:

 1) on suspend it takes more than MAX_LOCK_DEPTH (48) locks

 2) tree nesting


Lets start with the easy one first; would a similar solution to the
radix tree locking as found in -rt work?

http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/23-rc1-rt/radix-concurrent-lockdep.patch

That does mean you have to set an effective max depth to the tree, is
that a practical issue?

The harder part is 1), holding _that_ many locks. Would something
obscene like this work for you:


struct device_suspend {
	wait_queue_head_t	wait_queue;
	struct srcu_struct	srcu;
	int			suspend;
} dev_suspend_state;

void device_lock(struct device *dev)
{
again:
	srcu_read_lock(&dev_suspend_state.srcu);
	if (unlikely(rcu_dereference(dev_suspend_state.suspend))) {
		srcu_read_unlock(&dev_suspend_state.srcu);
		wait_event(&dev_suspend_state.wait_queue,
			   !dev_suspend_state.suspend);
		goto again;
	}
	mutex_lock(&dev->mutex);
}

void device_unlock(struct device *dev)
{
	mutex_unlock(&dev->mutex);
	srcu_read_unlock(&dev_suspend_state.srcu);
}


void device_suspend(void)
{
	rcu_assign_pointer(dev_suspend_state.suspend, 1);
	synchronize_srcu(&dev_suspend_state.srcu);
}

void device_resume(void)
{
	rcu_assign_pointer(dev_suspend_state.suspend, 0);
	wake_up_all(&dev_suspend_state.wait_queue);
}




