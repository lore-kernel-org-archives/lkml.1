Return-Path: <linux-kernel-owner+w=401wt.eu-S1761218AbZJMUfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218AbZJMUfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760943AbZJMUfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:35:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZJMUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:35:39 -0400
Date: Tue, 13 Oct 2009 13:34:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ben Woodard <bwoodard@llnl.gov>,
       David Howells <dhowells@redhat.com>,
       Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v4] rwsem: fix rwsem_is_locked() bugs
Message-Id: <20091013133419.3c8f5f21.akpm@linux-foundation.org>
In-Reply-To: <20091008092632.7101.62229.sendpatchset@localhost.localdomain>
References: <20091008092632.7101.62229.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009 05:23:53 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> --- a/include/linux/rwsem-spinlock.h
> +++ b/include/linux/rwsem-spinlock.h
> @@ -71,7 +71,13 @@ extern void __downgrade_write(struct rw_semaphore *sem);
>  
>  static inline int rwsem_is_locked(struct rw_semaphore *sem)
>  {
> -	return (sem->activity != 0);
> +	int ret = 1;
> +
> +	if (spin_trylock_irq(&sem->wait_lock)) {
> +		ret = (sem->activity != 0);
> +		spin_unlock_irq(&sem->wait_lock);
> +	}
> +	return ret;
>  }

a) probably to large to be inlined

b) the function will now cause bugs if called under
   local_irq_disable().  That wasn't the case before.  Fixable via
   spin_lock_irqsave().

In the present kernel there don't appear to be any irqs-off callers. 
There may of course be some out-of-tree ones which will get bitten by
this semantic change.

If we decide to leave this new rule in place then we should add a
WARN_ON(irqs_disabled()) to prevent hitting people with a nasty, subtle
bug.

Methinks that _irqsave() is better.
