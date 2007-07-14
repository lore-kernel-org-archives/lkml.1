Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbXGNRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbXGNRiZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbXGNRiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:38:19 -0400
Received: from mail.screens.ru ([213.234.233.54]:60786 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656AbXGNRiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:38:18 -0400
Date: Sat, 14 Jul 2007 21:39:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 5/5] slub: -rt port
Message-ID: <20070714173950.GA806@tv-sign.ru>
References: <20070714175733.194012000@chello.nl> <20070714175840.424675000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714175840.424675000@chello.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Peter Zijlstra wrote:
>
> +static void flush_all(struct kmem_cache *s)
> +{
> +	int cpu;
> +	struct workqueue_struct *wq = flush_slab_workqueue;
> +
> +	mutex_lock(&flush_slab_mutex);
> +	for_each_online_cpu(cpu) {
> +		struct slab_work_struct *sw = &per_cpu(slab_works, cpu);
> +
> +		INIT_WORK(&sw->work, flush_cpu_slab_wq);
> +		sw->s = s;
> +		queue_work_cpu(wq, &sw->work, cpu);
> +	}
> +	flush_workqueue(wq);
> +	mutex_unlock(&flush_slab_mutex);
> +}

I suspect this is not cpu-hotplug safe. flush_slab_mutex doesn't protect
from cpu_down(). This means that slab_work_struct could be scheduled on
the already dead CPU. flush_workqueue(wq) will hang in that case.

Oleg.

