Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYGVImA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYGVImA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYGVIlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:41:50 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58420 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYGVIlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:41:50 -0400
Date: Tue, 22 Jul 2008 12:45:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akinobu.mita@gmail.com
Subject: Re: + workqueue-proper-error-unwinding-in-cpu-hotplug-error-path.patch added to -mm tree
Message-ID: <20080722084526.GA165@tv-sign.ru>
References: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807220826.m6M8Q4I6018588@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Andrew Morton wrote:
> 
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> Add proper error unwinding in error path in CPU_UP_PREPARE notifier.

Could you clarify?

> --- a/kernel/workqueue.c~workqueue-proper-error-unwinding-in-cpu-hotplug-error-path
> +++ a/kernel/workqueue.c
> @@ -928,6 +928,15 @@ static int __devinit workqueue_cpu_callb
>  				break;
>  			printk(KERN_ERR "workqueue [%s] for %i failed\n",
>  				wq->name, cpu);
> +
> +			list_for_each_entry_continue_reverse(wq, &workqueues,
> +							list) {
> +				cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> +				start_workqueue_thread(cwq, -1);
> +				cleanup_workqueue_thread(cwq);
> +			}
> +			cpu_clear(cpu, cpu_populated_map);
> +
>  			return NOTIFY_BAD;

If CPU_UP_PREPARE fails, _cpu_up() sends CPU_UP_CANCELED, and afaics
workqueue_cpu_callback() correctly cleanups cwq->thread's.

Oleg.

