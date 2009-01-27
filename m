Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZA0WnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZA0WnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZA0WnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:43:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019AbZA0WnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:43:05 -0500
Date: Tue, 27 Jan 2009 14:42:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: mingo@elte.hu, menage@google.com, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the
 unallowed node when memory spread is set
Message-Id: <20090127144233.18cf9b3f.akpm@linux-foundation.org>
In-Reply-To: <4976D77C.3020107@cn.fujitsu.com>
References: <4976D77C.3020107@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 16:06:20 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> The task still allocated the page caches on old node after modifying its
> cpuset's mems when 'memory_spread_page' was set, it is caused by the old
> mem_allowed_list of the task, the current kernel doesn't updates it unless some
> function invokes cpuset_update_task_memory_state(), it is too late sometimes.
> We must update the mem_allowed_list of the tasks in time.
> 
> Slab has the same problem.
> 
> We fixes the bug by updating tasks' mem_allowed_list and spread flag after
> its cpuset's mems or spread flag is changed.
> 
>
> ...
>
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -242,6 +242,7 @@ int kthreadd(void *unused)
>  	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
>  	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
>  
> +	current->mems_allowed = node_possible_map;
>  	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;

Why this change?  kthreadd() is called from rest_init(), before anyone
has had a chance to alter ->mems_allowed?


I queued the patch pending your response to Paul's questions, thanks.
