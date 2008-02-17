Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYBQXqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYBQXqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYBQXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:46:35 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:51387 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbYBQXqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:46:34 -0500
Date: Mon, 18 Feb 2008 02:45:56 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: shrink cpu_populated_map when CPU dies
Message-ID: <20080217234556.GA655@tv-sign.ru>
References: <20080216172259.GA18524@tv-sign.ru> <20080217202739.GA2994@ami.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217202739.GA2994@ami.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Jarek Poplawski wrote:
> 
> This patch looks OK to me.

Thanks for looking at this!

> But while reading this I got some doubts
> in nearby places, so BTW 2 small questions:
> 
> 1) ... workqueue_cpu_callback(...)
> {
> 	...
>         list_for_each_entry(wq, &workqueues, list) {
>                 cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> 
>                 switch (action) {
>                 case CPU_UP_PREPARE:
> 		...
> 
> It looks like not all CPU_ cases are served here: shouldn't
> list_for_each_entry() be omitted for them?

Yes, but this is harmless. cpu-hotplug callbacks are not time-critical,
and cpu_down/cpu_up happens not often, and LIST_HEAD(workqueues) is not
very long, so ...

> 2) ... __create_workqueue_key(...)
> {
> 	...
>         if (singlethread) {
> 		...
>         } else {
>                 get_online_cpus();
>                 spin_lock(&workqueue_lock);
>                 list_add(&wq->list, &workqueues);
> 
> Shouldn't this list_add() be done after all these inits below?
> 
>                 spin_unlock(&workqueue_lock);
> 
>                 for_each_possible_cpu(cpu) {
>                         cwq = init_cpu_workqueue(wq, cpu);
> 			...
>                 }
> 		...

This doesn't matter. Please note that get_online_cpus() blocks
cpu_up/cpu_down, they take cpu_hotplug_begin().

Oleg.

