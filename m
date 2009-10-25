Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZJYID5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZJYID5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 04:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZJYID4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 04:03:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZJYIDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 04:03:53 -0400
Subject: Re: [PATCH 1/3] sched: Enable wake balancing for the SMT/HT domain
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, lkml <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>,
       "suresh.b.siddha" <suresh.b.siddha@intel.com>
In-Reply-To: <20091024125853.35143117@infradead.org>
References: <20091024125853.35143117@infradead.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 09:03:41 +0100
Message-Id: <1256457821.7356.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-24 at 12:58 -0700, Arjan van de Ven wrote:
> Subject: sched: Enable wake balancing for the SMT/HT domain
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> Logical CPUs that are part of a hyperthreading/SMT set are equivalent
> in terms of where to execute a task; after all they share pretty much
> all resources including the L1 cache.
> 
> This means that if task A wakes up task B, we should really consider
> all logical CPUs in the SMT/HT set to run task B, not just the CPU that
> task A is running on; in case task A keeps running, task B now gets to 
> execute with no latency. In the case where task A then immediately goes
> to wait for a response from task B, nothing is lost due to the aforementioned
> equivalency.
> 
> This patch turns on the "balance on wakup" and turns of "affine wakeups"
> for the SMT/HT scheduler domain to get this lower latency behavior.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index fc0bf3e..3665dc2 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -95,8 +95,8 @@ int arch_update_cpu_topology(void);
>  				| 1*SD_BALANCE_NEWIDLE			\
>  				| 1*SD_BALANCE_EXEC			\
>  				| 1*SD_BALANCE_FORK			\
> -				| 0*SD_BALANCE_WAKE			\
> -				| 1*SD_WAKE_AFFINE			\
> +				| 1*SD_BALANCE_WAKE			\
> +				| 0*SD_WAKE_AFFINE			\
>  				| 1*SD_SHARE_CPUPOWER			\
>  				| 0*SD_POWERSAVINGS_BALANCE		\
>  				| 0*SD_SHARE_PKG_RESOURCES		\
> 

So you're poking at SD_SIBLING_INIT, right?

That seems to make sense. Now doing the same for a cache level domain
(MC is almost that) might also make sense.

