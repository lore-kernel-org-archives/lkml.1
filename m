Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbYALMDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbYALMDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 07:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYALMD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 07:03:29 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59025 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761349AbYALMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 07:03:27 -0500
Date: Sat, 12 Jan 2008 17:33:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Balaji Rao <balajirrao@gmail.com>
Cc: linux-kernel@vger.kernel.org, amit.shah@qumranet.com,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       venkatesh.pallipadi@intel.com, clemens@ladisch.de, tglx@linutronix.de,
       mingo@elte.hu, hpa@zytor.com
Subject: Re: [PATCH] Assign IRQs to HPET Timers
Message-ID: <20080112120312.GE25388@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Balaji Rao <balajirrao@gmail.com>,
	linux-kernel@vger.kernel.org, amit.shah@qumranet.com,
	dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
	venkatesh.pallipadi@intel.com, clemens@ladisch.de,
	tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com
References: <200801120036.11982.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200801120036.11982.balajirrao@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balaji Rao <balajirrao@gmail.com> [2008-01-12 00:36:11]:

> Assign an IRQ to HPET Timer devices when interrupt enable is requested.
> This now makes the HPET userspace API work.
>

A more detailed changelog will better help understand the nature and
origin of the problem and how to reproduce it.
 
> drivers/char/hpet.c  |   31 +++++++++++++++++++++++++++++--
> include/linux/hpet.h |    2 +-
> 2 files changed, 30 insertions(+), 3 deletions(-)
> 
> Signed-off-by: Balaji Rao R <balajirrao@gmail.com>
> 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 4c16778..92bd889 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -390,7 +390,8 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
>  	struct hpets *hpetp;
>  	int irq;
>  	unsigned long g, v, t, m;
> -	unsigned long flags, isr;
> +	unsigned long flags, isr, irq_bitmap;
> +	u64 hpet_config;
> 
>  	timer = devp->hd_timer;
>  	hpet = devp->hd_hpet;
> @@ -412,7 +413,29 @@ static int hpet_ioctl_ieon(struct hpet_dev *devp)
>  		devp->hd_flags |= HPET_SHARED_IRQ;
>  	spin_unlock_irq(&hpet_lock);
> 
> -	irq = devp->hd_hdwirq;
> +	/* Assign an IRQ to the timer */
> +	hpet_config = readq(&timer->hpet_config);
> +	irq_bitmap =
> +		(hpet_config & Tn_INT_ROUTE_CAP_MASK) >> Tn_INT_ROUTE_CAP_SHIFT;

Should we check if the interrupts are being delivered via FSB, prior
to doing this?

> +	if (!irq_bitmap)
> +		irq = 0;	/* No IRQ Assignable */
> +	else {
> +		irq = find_first_bit(&irq_bitmap, 32);

> +		do {
> +			hpet_config |= irq << Tn_INT_ROUTE_CNF_SHIFT;
> +			writeq(hpet_config, &timer->hpet_config);
> +
> +			/* Check whether we wrote a valid IRQ
> +			 * number by reading back the field
> +			 */
> +			hpet_config = readq(&timer->hpet_config);
> +			if (irq == (hpet_config & Tn_INT_ROUTE_CNF_MASK)
> +					>> Tn_INT_ROUTE_CNF_SHIFT) {
> +				devp->hd_hdwirq = irq;
> +				break;	/* Success */
> +			}
> +		} while ((irq = (find_next_bit(&irq_bitmap, 32, irq))));
> +	}

Shouldn't we do this at hpet_alloc() time?


> 
>  	if (irq) {
>  		unsigned long irq_flags;
> @@ -509,6 +532,10 @@ hpet_ioctl_common(struct hpet_dev *devp, int cmd, unsigned long arg, int kernel)
>  			break;
>  		v = readq(&timer->hpet_config);
>  		v &= ~Tn_INT_ENB_CNF_MASK;
> +
> +		/* Zero out the IRQ field*/
> +		v &= ~Tn_INT_ROUTE_CNF_MASK;
> +
>  		writeq(v, &timer->hpet_config);
>  		if (devp->hd_irq) {
>  			free_irq(devp->hd_irq, devp);
> diff --git a/include/linux/hpet.h b/include/linux/hpet.h
> index 707f7cb..e3c0b2a 100644
> --- a/include/linux/hpet.h
> +++ b/include/linux/hpet.h
> @@ -64,7 +64,7 @@ struct hpet {
>   */
> 
>  #define	Tn_INT_ROUTE_CAP_MASK		(0xffffffff00000000ULL)
> -#define	Tn_INI_ROUTE_CAP_SHIFT		(32UL)
> +#define	Tn_INT_ROUTE_CAP_SHIFT		(32UL)
>  #define	Tn_FSB_INT_DELCAP_MASK		(0x8000UL)
>  #define	Tn_FSB_INT_DELCAP_SHIFT		(15)
>  #define	Tn_FSB_EN_CNF_MASK		(0x4000UL)

The patch looks good overall!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
