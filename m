Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbYCZMdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbYCZMdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758181AbYCZMc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:32:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52770 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023AbYCZMc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:32:56 -0400
Date: Wed, 26 Mar 2008 06:32:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: What if a TLB flush needed to sleep?
Message-ID: <20080326123239.GG16721@parisc-linux.org>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 01:49:54PM -0700, Luck, Tony wrote:
> 1) Is holding a spin lock a problem for any other arch when
> doing a TLB flush (I'm particularly thinking of those that
> need to use IPI shootdown for the purge)?

parisc certainly has that problem too.  It won't happen very often, but
it will do an on_each_cpu() and wait for the outcome once in a while.

> 2) Is it feasible to rearrange the MM code so that we don't
> hold any locks while doing a TLB flush?  Or should I implement
> some sort of spin_only_semaphore?

down_spin() is trivial to implement without knowing the details of the
semaphore code:

void down_spin(struct semaphore *sem)
{
	while (down_trylock(sem))
		cpu_relax();
}

Of course, someone who wrote it could do better ;-)

void down_spin(struct semaphore *sem)
{
	unsigned long flags;
	int count;

	spin_lock_irqsave(&sem->lock, flags);
	count = sem->count - 1;
	if (likely(count >= 0))
		sem->count = count;
	else
		__down_spin(sem);
	spin_unlock_irqrestore(&sem->lock, flags);
}

void __down_spin(struct semaphore *sem)
{
	struct semaphore_waiter waiter;

	list_add_tail(&waiter.list, &sem->wait_list);
	waiter.task = current;
	waiter.up = 0;

	spin_unlock_irq(&sem->lock);
	while (!waiter.up)
		cpu_relax();
	spin_lock_irq(&sem->lock);
}

This more complex implementation is better because:
 - It queues properly (see also down_timeout)
 - It spins on a stack-local variable, not on a global structure

Having done all that ... I bet parisc and ia64 aren't the only two
architectures which can sleep in their tlb flush handlers.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
