Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0CCXuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:50:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757Ab0CCXuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:50:16 -0500
Date: Wed, 3 Mar 2010 15:50:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and mems_allowed
Message-Id: <20100303155004.5f9e793e.akpm@linux-foundation.org>
In-Reply-To: <4B8E3F77.6070201@cn.fujitsu.com>
References: <4B8E3F77.6070201@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 18:52:39 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> if MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed or mems_allowed in
> task->mempolicy are not atomic operations, and the kernel page allocator gets an empty
> mems_allowed when updating task->mems_allowed or mems_allowed in task->mempolicy. So we
> use a rwlock to protect them to fix this probelm.

Boy, that is one big ugly patch.  Is there no other way of doing this?

>
> ...
>
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -51,6 +51,7 @@ enum {
>   */
>  #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
>  #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
> +#define MPOL_F_TASK    (1 << 2)	/* identify tasks' policies */

What's this?  It wasn't mentioned in the changelog - I suspect it
should have been?

>
> ...
>
> +int cpuset_mems_allowed_intersects(struct task_struct *tsk1,
> +				   struct task_struct *tsk2)
>  {
> -	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
> +	unsigned long flags1, flags2;
> +	int retval;
> +
> +	read_mem_lock_irqsave(tsk1, flags1);
> +	read_mem_lock_irqsave(tsk2, flags2);
> +	retval = nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
> +	read_mem_unlock_irqrestore(tsk2, flags2);
> +	read_mem_unlock_irqrestore(tsk1, flags1);

I suspect this is deadlockable in sufficiently arcane circumstances:
one task takes the locks in a,b order, another task takes them in b,a
order and a third task gets in at the right time and does a
write_lock().  Probably that's not possible for some reason, dunno.  The usual
way of solving this is to always take the locks in
sorted-by-ascending-virtual-address order.


