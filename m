Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZG3GsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZG3GsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 02:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZG3GsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 02:48:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZG3GsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 02:48:07 -0400
Subject: Re: [PATCH 3/3 -mm] generic-ipi: fix the race between
 generic_smp_call_function_*() and hotplug_cfd()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, mingo@elte.hu,
       jens.axboe@oracle.com, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090729163120.2e27be41.akpm@linux-foundation.org>
References: <4A6983D8.8090805@cn.fujitsu.com>
	 <4A6FFFE9.5070204@cn.fujitsu.com> <4A7000FF.6040402@cn.fujitsu.com>
	 <20090729163120.2e27be41.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Jul 2009 08:50:57 +0200
Message-Id: <1248936657.6987.3095.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 16:31 -0700, Andrew Morton wrote:

> -void generic_smp_call_function_interrupt(void)
> +static void
> +__generic_smp_call_function_interrupt(int cpu, int run_callbacks)
>  {
>  	struct call_function_data *data;
> -	int cpu = smp_processor_id();
>  
>  	/*
>  	 * Ensure entry is visible on call_function_queue after we have
> @@ -169,12 +165,18 @@ void generic_smp_call_function_interrupt

> +static void
> +__generic_smp_call_function_single_interrupt(int cpu, int run_callbacks)
>  {
> -	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
> +	struct call_single_queue *q = &per_cpu(call_single_queue, cpu);
>  	unsigned int data_flags;
>  	LIST_HEAD(list);
>  

It introduces this run_callbacks thing to two functions, but nothing
actually uses that... makes me suspicious there's something missing.


> case CPU_DEAD_FROZEN:
> +               local_irq_save(flags);
> +               __generic_smp_call_function_interrupt(cpu, 0);
> +               __generic_smp_call_function_single_interrupt(cpu, 0);
> +               local_irq_restore(flags);

Doing the callbacks from a different cpu than they were queued on seems
like a fine way to mess things up.
