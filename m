Return-Path: <linux-kernel-owner+w=401wt.eu-S1161397AbXDWTTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161397AbXDWTTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161469AbXDWTTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:19:46 -0400
Received: from mail.screens.ru ([213.234.233.54]:50811 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161397AbXDWTTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:19:45 -0400
Date: Mon, 23 Apr 2007 23:19:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gautham Shenoy <ego.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] CPU hotplug with frozen tasks
Message-ID: <20070423191942.GA301@tv-sign.ru>
References: <200704061732.32712.rjw@sisk.pl> <200704160027.58425.rjw@sisk.pl> <c03d1bd00704160250g158de0feqa0c7acd18673969f@mail.gmail.com> <200704162327.59758.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704162327.59758.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Rafael J. Wysocki wrote:
>
> Appended is the updated version of the patch (in addition to the changes
> mentioned above I've eliminated the magic constant 0x0008 from cpu.c by
> changing the new definitions in notifier.h).

Most sub-systems doesn't care about CPU_TASKS_FROZEN bit. Take for example
workqueue.c,

> --- linux-2.6.21-rc7.orig/kernel/workqueue.c	2007-04-16 23:05:17.000000000 +0200
> +++ linux-2.6.21-rc7/kernel/workqueue.c	2007-04-16 23:05:45.000000000 +0200
> @@ -757,6 +757,7 @@ static int __devinit workqueue_cpu_callb
>  
>  	switch (action) {
>  	case CPU_UP_PREPARE:
> +	case CPU_UP_PREPARE_FROZEN:
>  		mutex_lock(&workqueue_mutex);
>  		/* Create a new workqueue thread for it. */
>  		list_for_each_entry(wq, &workqueues, list) {
> @@ -768,6 +769,7 @@ static int __devinit workqueue_cpu_callb
>  		break;
>  
>  	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
>  		/* Kick off worker threads. */
>  		list_for_each_entry(wq, &workqueues, list) {
>  			struct cpu_workqueue_struct *cwq;
> @@ -780,6 +782,7 @@ static int __devinit workqueue_cpu_callb
>  		break;
>  
>  	case CPU_UP_CANCELED:
> +	case CPU_UP_CANCELED_FROZEN:
>  		list_for_each_entry(wq, &workqueues, list) {
>  			if (!per_cpu_ptr(wq->cpu_wq, hotcpu)->thread)
>  				continue;
> @@ -792,14 +795,17 @@ static int __devinit workqueue_cpu_callb
>  		break;
>  
>  	case CPU_DOWN_PREPARE:
> +	case CPU_DOWN_PREPARE_FROZEN:
>  		mutex_lock(&workqueue_mutex);
>  		break;
>  
>  	case CPU_DOWN_FAILED:
> +	case CPU_DOWN_FAILED_FROZEN:
>  		mutex_unlock(&workqueue_mutex);
>  		break;
>  
>  	case CPU_DEAD:
> +	case CPU_DEAD_FROZEN:
>  		list_for_each_entry(wq, &workqueues, list)
>  			cleanup_workqueue_thread(wq, hotcpu);
>  		list_for_each_entry(wq, &workqueues, list)

I think it is better to add

	action &= ~CPU_TASKS_FROZEN;

at the head of workqueue_cpu_callback() instead. I think this way
you can make this patch a lot simpler and smaller.

Oleg.

