Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYJUQsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYJUQsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 12:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYJUQrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 12:47:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:56111 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbYJUQru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 12:47:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,458,1220252400"; 
   d="scan'208";a="453925638"
Message-ID: <48FE07AE.4010203@linux.intel.com>
Date: Tue, 21 Oct 2008 18:47:42 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Andy Henroid <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com> <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com> <20081011083347.GA31918@elte.hu> <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:

> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
> index bc8c6e3..f8396ca 100644
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c
> @@ -171,6 +171,9 @@ static int ioat_dma_enumerate_channels(struct ioatdma_device *device)
>  	xfercap_scale = readb(device->reg_base + IOAT_XFERCAP_OFFSET);
>  	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
>  
> +#if CONFIG_I7300_IDLE_IOAT_CHANNEL
> +	device->common.chancnt--;
> +#endif

I still think this lone decrement looks fishy. Can there please be some
explanation how it exactly relates to the i7300 idle driver, where the
matching increment is, etc.?

> +config I7300_IDLE
> +	tristate "Intel chipset idle power saving driver"

It would be probably good to mention the word memory here.

> +	select I7300_IDLE_IOAT_CHANNEL
> +	depends on X86_64
> +	help
> +	  Enable idle power savings with certain Intel server chipsets.

And here too.

> +	  The chipset must have I/O AT support, such as the Intel 7300.
> +	  The power savings depends on the type and quantity of DRAM devices.


> +static int debug;
> +module_param_named(debug, debug, uint, 0644);
> +MODULE_PARM_DESC(debug, "Enable debug printks in this driver");

> +#define dprintk(fmt, arg...) \
> +	do { if (debug) printk(KERN_INFO I7300_PRINT fmt, ##arg); } while (0)

2.6.28 just got a new dynamic printk facility, which could be used.

> +
> +/*
> + * Value to set THRTLOW to when initiating throttling
> + *  0 = No throttling
> + *  1 = Throttle when > 4 activations per eval window (Maximum throttling)
> + *  2 = Throttle when > 8 activations
> + *  168 = Throttle when > 168 activations (Minimum throttling)
> + */
> +#define MAX_THRTLWLIMIT		168
> +static uint i7300_idle_thrtlowlm = 1;
> +module_param_named(thrtlwlimit, i7300_idle_thrtlowlm, uint, 0644);

Just imagining how someone would pronounce this parameter @) Will they
get damages when their tongue ends up in a knot?

> +static cpumask_t idle_cpumask;

Would it make sense to cache align this field? I could imagine
it false sharing with some frequently written variable could be quite
bad.

> +	writeb(IOAT_CHANCMD_RESET, ioat_chanbase + IOAT1_CHANCMD_OFFSET);
> +	writeb(IOAT_CHANCMD_START, ioat_chanbase + IOAT1_CHANCMD_OFFSET);
> +
> +	udelay(1000);
> +
> +	chan_sts = readq(ioat_chanbase + IOAT1_CHANSTS_OFFSET) &
> +			IOAT_CHANSTS_DMA_TRANSFER_STATUS;

Wouldn't it be better to poll here instead of udelay?

> +	/* Wait for a while for the channel to halt before releasing */
> +	for (i = 0; i < 10; i++) {
> +		writeb(IOAT_CHANCMD_RESET,
> +		       ioat_chanbase + IOAT1_CHANCMD_OFFSET);
> +
> +		chan_sts = readq(ioat_chanbase + IOAT1_CHANSTS_OFFSET) &
> +			IOAT_CHANSTS_DMA_TRANSFER_STATUS;
> +
> +		if (chan_sts != IOAT_CHANSTS_DMA_TRANSFER_STATUS_ACTIVE) {
> +			writew(0, ioat_chanbase + IOAT_CHANCTRL_OFFSET);
> +			break;
> +		}
> +		udelay(1000);

Same here.


> +	spin_lock_irqsave(&i7300_idle_lock, flags);

This lock still scares me. In the worst case with very frequent
idle frequencies this could bounce around a lot.

It would be better to only invoke it less frequently,
i.e. when the driver determines there is a long idle
time coming up.

> +/* Check for known platforms with I/O-AT */
> +static int __init i7300_idle_platform_probe(void)
> +{
> +	int i;
> +
> +	fbd_dev = pci_get_bus_and_slot(MEMCTL_BUS, MEMCTL_DEVFN)

Is there a specific reason you cannot match this by pci vendor/devid
like all standard drivers do?

If there is a good reason add a comment.

;
> +static void __exit i7300_idle_exit(void)
> +{
> +	idle_notifier_unregister(&i7300_idle_nb);

I still think this needs some kind of idle synchronization.

-Andi
