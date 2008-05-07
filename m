Return-Path: <linux-kernel-owner+w=401wt.eu-S1762432AbYEGGvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762432AbYEGGvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYEGGuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:50:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:11899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbYEGGum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:50:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,446,1204531200"; 
   d="scan'208";a="325327061"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080506173900.GA9014@elte.hu>
References: <1210052904.3453.30.camel@ymzhang>
	 <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org>
	 <20080506162332.GI19219@parisc-linux.org>
	 <20080506102153.5484c6ac.akpm@linux-foundation.org>
	 <20080506173900.GA9014@elte.hu>
Content-Type: text/plain
Date: Wed, 07 May 2008 14:49:29 +0800
Message-Id: <1210142969.3453.69.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 19:39 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Finally: how come we regressed by swapping the semaphore 
> > implementation anyway?  We went from one sleeping lock implementation 
> > to another - I'd have expected performance to be pretty much the same.
> i.e. we'll always keep yet another task in flight. This can mask wakeup 
> latencies especially when it takes time.
> 
> The patch (hack) below tries to emulate this weirdness - it 'kicks' 
> another task as well and keeps it busy. Most of the time this just 
> causes extra scheduling, but if AIM7 is _just_ saturating the number of 
> CPUs, it might make a difference. Yanmin, does the patch below make any 
> difference to the AIM7 results?
I tested it on my 8-core stoakley and the result is 12% worse than the one of
pure 2.6.26-rc1.

-yanmin

> 
> ( it would be useful data to get a meaningful context switch trace from 
>   the whole regressed workload, and compare it to a context switch trace 
>   with the revert added. )
> 
> 	Ingo
> 
> ---
>  kernel/semaphore.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> Index: linux/kernel/semaphore.c
> ===================================================================
> --- linux.orig/kernel/semaphore.c
> +++ linux/kernel/semaphore.c
> @@ -261,4 +261,14 @@ static noinline void __sched __up(struct
>  	list_del(&waiter->list);
>  	waiter->up = 1;
>  	wake_up_process(waiter->task);
> +
> +	if (likely(list_empty(&sem->wait_list)))
> +		return;
> +	/*
> +	 * Opportunistically wake up another task as well but do not
> +	 * remove it from the list:
> +	 */
> +	waiter = list_first_entry(&sem->wait_list,
> +				  struct semaphore_waiter, list);
> +	wake_up_process(waiter->task);
>  }

