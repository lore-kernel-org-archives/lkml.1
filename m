Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbXH0SSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbXH0SSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbXH0SSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:18:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040AbXH0SSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:18:09 -0400
Date: Mon, 27 Aug 2007 11:18:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bogus hotplug cpu warning
Message-Id: <20070827111802.8d0a675b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708271604440.21853@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271604440.21853@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 16:06:19 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> Fix bogus DEBUG_PREEMPT warning on x86_64, when cpu brought online after
> bootup: current_is_keventd is right to note its use of smp_processor_id
> is preempt-safe, but should use raw_smp_processor_id to avoid the warning.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> --- 2.6.23-rc3-git10/kernel/workqueue.c	2007-07-26 19:49:58.000000000 +0100
> +++ linux/kernel/workqueue.c	2007-08-26 18:59:16.000000000 +0100
> @@ -635,7 +635,7 @@ int keventd_up(void)
>  int current_is_keventd(void)
>  {
>  	struct cpu_workqueue_struct *cwq;
> -	int cpu = smp_processor_id();	/* preempt-safe: keventd is per-cpu */
> +	int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
>  	int ret = 0;
>  
>  	BUG_ON(!keventd_wq);

But lib/smp_processor_id.c:debug_smp_processor_id() does

	/*
	 * Kernel threads bound to a single CPU can safely use
	 * smp_processor_id():
	 */
	this_mask = cpumask_of_cpu(this_cpu);

	if (cpus_equal(current->cpus_allowed, this_mask))
		goto out;

So I assume that this warning was triggering because some non-keventd,
non-pinned task is calling current_is_keventd()?


So I agree with the patch, but not with its description.
