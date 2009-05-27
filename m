Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbZE0FwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbZE0FwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZE0FwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:52:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbZE0FwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:52:12 -0400
Date: Tue, 26 May 2009 22:51:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'IOMMU'" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH] Time out for possible dead loops during queued
 invalidation wait
Message-Id: <20090526225146.2faeeb05.akpm@linux-foundation.org>
In-Reply-To: <20090520174259.GA10646@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com>
	<20090327212321.070229000@intel.com>
	<20090416001957.GA1527@linux-os.sc.intel.com>
	<1240135508.3589.75.camel@macbook.infradead.org>
	<A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com>
	<20090520174259.GA10646@linux-os.sc.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009 10:42:59 -0700 Fenghua Yu <fenghua.yu@intel.com> wrote:
>
> Subject: [PATCH] Time out for possible dead loops during queued invalidation wait

nits:

Please ensure that each patch title identifies the subsystem which is
being altered.  Because someone who reads this title has no clue what
part of the kernel is affected unless they dive in and read the actual
patch.  Suitable title prefixes for this one would be "dmar: " or
"drivers/pci/dmar.c: ".

The usual term for a timeout is "timeout", not "time out".

The term "dead loop" is unclear.  The reader might think that it refers
to a never-executed loop, as in "dead code".  A better term is
"infinite loop".

So I ended up with the title

	"drivers/pci/dmar.c: timeout for possible infinite loops during queued invalidation wait"

Welcome to my life :(

> Two loops in qi_submit_sync() do not have time out. If hardware can not finish
> the queued invalidation for some reason, the loops could end up in dead loops
> without any hint for what is going on. I add time out for the loops and report
> warning when time out happens.
>  
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

ok...

>  dmar.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+)
> 
> diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
> index fa3a113..95baacd 100644
> --- a/drivers/pci/dmar.c
> +++ b/drivers/pci/dmar.c
> @@ -637,6 +637,7 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
>  	struct qi_desc *hw, wait_desc;
>  	int wait_index, index;
>  	unsigned long flags;
> +	cycles_t start_time;

It seems strange to me that the driver chose to implement a ten second
timeout using such a high resolution thing as cycles_t.  Why not use
plain old jiffies?  The advantages are:

- jiffies can be read very efficiently

- there's more kernel support for manipulating jiffies-based values.

For example,

>  	if (!qi)
>  		return 0;
> @@ -644,8 +645,13 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
>  	hw = qi->desc;
>  
>  	spin_lock_irqsave(&qi->q_lock, flags);
> +	start_time = get_cycles();
>  	while (qi->free_cnt < 3) {
>  		spin_unlock_irqrestore(&qi->q_lock, flags);
> +		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time)) {

if we were using jiffies, this nasty thing could just use time_after().

But that's all outside the scope of your patch.


I'd find it more readable if the above were coded as

	if (get_cycles() - start_time >= DMAR_OPERATION_TIMEOUT)

but maybe that's just me.

> +			WARN(1, "No space in invalidation queue.\n");
> +			return -ENOSPC;

ENOSPC means "your disk filled up".  I think it makes no sense to use
that error code in this context, even though it kinda sounds the same.

> +		}
>  		cpu_relax();
>  		spin_lock_irqsave(&qi->q_lock, flags);
>  	}
> @@ -675,6 +681,7 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
>  	 */
>  	writel(qi->free_head << 4, iommu->reg + DMAR_IQT_REG);
>  
> +	start_time = get_cycles();
>  	while (qi->desc_status[wait_index] != QI_DONE) {
>  		/*
>  		 * We will leave the interrupts disabled, to prevent interrupt
> @@ -687,6 +694,11 @@ int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu)
>  		if (rc)
>  			goto out;
>  
> +		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start_time)) {
> +			WARN(1, "Queued invalidation can not complete.\n");
> +			goto out;

As `rc' now contains zero, this will cause the function to incorrectly
return the "success" code, even though it is known that it did not
succeed.

> +		}
> +
>  		spin_unlock(&qi->q_lock);
>  		cpu_relax();
>  		spin_lock(&qi->q_lock);
