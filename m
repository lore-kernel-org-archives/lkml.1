Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXDIUlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXDIUlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXDIUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:41:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59481 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965576AbXDIUlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:41:13 -0400
Date: Mon, 9 Apr 2007 13:40:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [patch] sched: align rq to cacheline boundary
Message-Id: <20070409134057.2d249f0c.akpm@linux-foundation.org>
In-Reply-To: <20070409180853.GC3948@linux-os.sc.intel.com>
References: <20070409180853.GC3948@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 11:08:53 -0700
"Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:

> Align the per cpu runqueue to the cacheline boundary. This will minimize the
> number of cachelines touched during remote wakeup.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index b9a6837..eca33c5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -278,7 +278,7 @@ struct rq {
>  	struct lock_class_key rq_lock_key;
>  };
>  
> -static DEFINE_PER_CPU(struct rq, runqueues);
> +static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;

Remember that this can consume up to (linesize-4 * NR_CPUS) bytes, which is
rather a lot.

Remember also that the linesize on VSMP is 4k.

And that putting a gap in the per-cpu memory like this will reduce its
overall cache-friendliness.

Need more convincing, please.
