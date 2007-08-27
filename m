Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXH0TTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXH0TTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXH0TTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:19:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:5044 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbXH0TTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:19:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,313,1183359600"; 
   d="scan'208";a="268610536"
Date: Mon, 27 Aug 2007 12:19:05 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
Message-ID: <20070827191905.GE1894@linux-os.sc.intel.com>
References: <20070816010150.GG10033@linux-os.sc.intel.com> <20070823115416.GA31027@elte.hu> <20070823121341.GA5775@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823121341.GA5775@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 02:13:41PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > [...] So how about the patch below instead?
> 
> the right patch attached.
> 
> -------------------------------->
> Subject: sched: fix broken SMT/MC optimizations
> From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
> 
> On a four package system with HT - HT load balancing optimizations were
> broken.  For example, if two tasks end up running on two logical threads
> of one of the packages, scheduler is not able to pull one of the tasks
> to a completely idle package.
> 
> In this scenario, for nice-0 tasks, imbalance calculated by scheduler
> will be 512 and find_busiest_queue() will return 0 (as each cpu's load
> is 1024 > imbalance and has only one task running).
> 
> Similarly MC scheduler optimizations also get fixed with this patch.
> 
> [ mingo@elte.hu: restored fair balancing by increasing the fuzz and
>                  adding it back to the power decision, without the /2
>                  factor. ]
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  include/linux/sched.h |    2 +-
>  kernel/sched.c        |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/include/linux/sched.h
> ===================================================================
> --- linux.orig/include/linux/sched.h
> +++ linux/include/linux/sched.h
> @@ -681,7 +681,7 @@ enum cpu_idle_type {
>  #define SCHED_LOAD_SHIFT	10
>  #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)
>  
> -#define SCHED_LOAD_SCALE_FUZZ	(SCHED_LOAD_SCALE >> 1)
> +#define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
>  
>  #ifdef CONFIG_SMP
>  #define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */
> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -2517,7 +2517,7 @@ group_next:
>  	 * a think about bumping its value to force at least one task to be
>  	 * moved
>  	 */
> -	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task/2) {
> +	if (*imbalance + SCHED_LOAD_SCALE_FUZZ < busiest_load_per_task) {

Ingo, this is still broken. This condition is always false for nice-0 tasks..

thanks,
suresh
