Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZAXIQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZAXIQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 03:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbZAXIQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 03:16:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbZAXIQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 03:16:04 -0500
Date: Sat, 24 Jan 2009 00:15:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090124001537.7cfde78e.akpm@linux-foundation.org>
In-Reply-To: <20090116191108.533053000@polaris-admin.engr.sgi.com>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<20090116191108.533053000@polaris-admin.engr.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 11:11:10 -0800 Mike Travis <travis@sgi.com> wrote:

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> Impact: remove potential clashes with generic kevent workqueue
> 
> Annoyingly, some places we want to use work_on_cpu are already in
> workqueues.  As per Ingo's suggestion, we create a different workqueue
> for work_on_cpu.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  kernel/workqueue.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> --- linux-2.6-for-ingo.orig/kernel/workqueue.c
> +++ linux-2.6-for-ingo/kernel/workqueue.c
> @@ -971,6 +971,8 @@ undo:
>  }
>  
>  #ifdef CONFIG_SMP
> +static struct workqueue_struct *work_on_cpu_wq __read_mostly;

Pity the poor reader who comes along trying to work out why this exists.

>  struct work_for_cpu {
>  	struct work_struct work;
>  	long (*fn)(void *);
> @@ -1001,7 +1003,7 @@ long work_on_cpu(unsigned int cpu, long 
>  	INIT_WORK(&wfc.work, do_work_for_cpu);
>  	wfc.fn = fn;
>  	wfc.arg = arg;
> -	schedule_work_on(cpu, &wfc.work);
> +	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
>  	flush_work(&wfc.work);
>  
>  	return wfc.ret;
> @@ -1019,4 +1021,8 @@ void __init init_workqueues(void)
>  	hotcpu_notifier(workqueue_cpu_callback, 0);
>  	keventd_wq = create_workqueue("events");
>  	BUG_ON(!keventd_wq);
> +#ifdef CONFIG_SMP
> +	work_on_cpu_wq = create_workqueue("work_on_cpu");
> +	BUG_ON(!work_on_cpu_wq);
> +#endif

Yet another kernel thread for each CPU.  All because of some dung way
down in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c.

Is there no other way?
