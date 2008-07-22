Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYGVJzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYGVJzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYGVJzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:55:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:41337 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYGVJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PNi/+e6KIH6mwZBq+dqlX2X4iV+mXihCaP+UGeJxOmnbAvYEfEijf1171nVBWlGruf
         qerMht6/cKc6NEzruEqaIoWChwGWvbgB05ZoNU3wAYlxB4TFrgy0bgNQvjoe0aAyN0VO
         sxmMjil80EVSiKcwxHmR2FhSSxCG2Xsq+1Wbs=
Date: Tue, 22 Jul 2008 18:55:39 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: +
	workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch
	added to -mm tree
Message-ID: <20080722095539.GA6188@localhost.localdomain>
References: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org> <20080722084526.GA165@tv-sign.ru> <20080722085938.GA5857@localhost.localdomain> <20080722091636.GA241@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722091636.GA241@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 01:16:36PM +0400, Oleg Nesterov wrote:
> Thanks Akinobu!

You are welcome!

> Can't we simplify the fix? I don't like the fact that the CPU_UP_CANCELED
> logic is duplicated.
> 
> What do you think about the patch below?

Yes, it is no duplication. But the goto usage in this patch looks bit
tricky to me.  Maybe it is better to factor out the list_for_each() block.

> 
> Oleg.
> 
> --- 26-rc2/kernel/workqueue.c~WQ_CPU_UP_PREPARE	2008-07-12 19:40:57.000000000 +0400
> +++ 26-rc2/kernel/workqueue.c	2008-07-22 13:15:16.000000000 +0400
> @@ -911,6 +911,7 @@ static int __devinit workqueue_cpu_callb
>  	unsigned int cpu = (unsigned long)hcpu;
>  	struct cpu_workqueue_struct *cwq;
>  	struct workqueue_struct *wq;
> +	int ret = NOTIFY_OK;
>  
>  	action &= ~CPU_TASKS_FROZEN;
>  
> @@ -919,6 +920,7 @@ static int __devinit workqueue_cpu_callb
>  		cpu_set(cpu, cpu_populated_map);
>  	}
>  
> +cancel:
>  	list_for_each_entry(wq, &workqueues, list) {
>  		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
>  
> @@ -928,7 +930,9 @@ static int __devinit workqueue_cpu_callb
>  				break;
>  			printk(KERN_ERR "workqueue [%s] for %i failed\n",
>  				wq->name, cpu);
> -			return NOTIFY_BAD;
> +			action = CPU_UP_CANCELED;
> +			ret = NOTIFY_BAD;
> +			goto cancel;
>  
>  		case CPU_ONLINE:
>  			start_workqueue_thread(cwq, cpu);
> @@ -948,7 +952,7 @@ static int __devinit workqueue_cpu_callb
>  		cpu_clear(cpu, cpu_populated_map);
>  	}
>  
> -	return NOTIFY_OK;
> +	return ret;
>  }
>  
>  void __init init_workqueues(void)
> 
