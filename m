Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYDBI1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYDBI1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYDBI1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:27:14 -0400
Received: from rhineheart.priorweb.be ([213.193.229.215]:37898 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751792AbYDBI1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:27:13 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 04:27:12 EDT
Message-ID: <47F341CB.7050406@joow.be>
Date: Wed, 02 Apr 2008 10:20:27 +0200
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH upate] iso transmit cycle skip patch
References: <47E18163.1080200@joow.be> <tkrat.0d0791eae8f1fc6c@s5r6.in-berlin.de>
In-Reply-To: <tkrat.0d0791eae8f1fc6c@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Scanned: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

I have to admit that I didn't write the patch with the idea of mainline 
inclusion in mind, but merely as a proof of concept. Therefore I'd like 
to check it again to ensure that it is ok for worldwide distribution ;).

However I'm swamped with work at the moment and can't do this before 2nd 
half of next week.

Greets,

Pieter

Stefan Richter wrote:
> Date: Wed, 19 Mar 2008 22:10:59 +0100
> From: Pieter Palmers <pieterp@joow.be>
> Subject: ieee1394: rawiso: requeue packet for transmission after skipped cycle
> 
> As it seems, some host controllers have issues that can cause them to 
> skip cycles now and then when using large packets. I suspect that this 
> is due to DMA not succeeding in time. If the transmit fifo can't contain 
> more than one packet (big packets), the DMA should provide a new packet 
> each cycle (125us). I am under the impression that my current PCI 
> express test system can't guarantee this.
> 
> In any case, the patch tries to provide a workaround as follows:
> The DMA program descriptors are modified such that when an error occurs, 
> the DMA engine retries the descriptor the next cycle instead of 
> stalling. This way no data is lost. The side effect of this is that 
> packets are sent with one cycle delay. This however might not be that 
> much of a problem for certain protocols (e.g. AM824). If they use 
> padding packets for e.g. rate matching they can drop one of those to 
> resync the streams.
> 
> The amount of skips between two userspace wakeups is counted. This 
> number is then propagated to userspace through the upper 16 bits of the 
> 'dropped' parameter. This allows unmodified userspace applications due 
> to the following:
> 1) libraw simply passes this dropped parameter to the user application
> 2) the meaning of the dropped parameter is: if it's nonzero, something 
> bad has happened. The actual value of the parameter at this moment does 
> not have a specific meaning.
> 
> A libraw client can then retrieve the number of skipped cycles and 
> account for them if needed.
> ---
> 
> Update by Stefan R:  Changed patch title (is it OK?) and whitespace.
> 
> Pieter, please reply with a Signed-off-by line if the update is OK for
> commit.  See linux/Documentation/SubmittingPatches for implications of
> the sign-off.
> 
>  drivers/ieee1394/iso.h      |    2 ++
>  drivers/ieee1394/ohci1394.c |   34 ++++++++++++++++++++++++++++++++++
>  drivers/ieee1394/raw1394.c  |    7 ++++++-
>  3 files changed, 42 insertions(+), 1 deletion(-)
> 
> Index: linux/drivers/ieee1394/iso.h
> ===================================================================
> --- linux.orig/drivers/ieee1394/iso.h
> +++ linux/drivers/ieee1394/iso.h
> @@ -123,6 +123,8 @@ struct hpsb_iso {
>  
>  	/* how many times the buffer has overflowed or underflowed */
>  	atomic_t overflows;
> +	/* how many cycles were skipped for a given context */
> +	atomic_t skips;
>  
>  	/* Current number of bytes lost in discarded packets */
>  	int bytes_discarded;
> Index: linux/drivers/ieee1394/ohci1394.c
> ===================================================================
> --- linux.orig/drivers/ieee1394/ohci1394.c
> +++ linux/drivers/ieee1394/ohci1394.c
> @@ -1723,6 +1723,8 @@ struct ohci_iso_xmit {
>  	struct dma_prog_region prog;
>  	struct ohci1394_iso_tasklet task;
>  	int task_active;
> +	int last_cycle;
> +	atomic_t skips;
>  
>  	u32 ContextControlSet;
>  	u32 ContextControlClear;
> @@ -1759,6 +1761,8 @@ static int ohci_iso_xmit_init(struct hps
>  	iso->hostdata = xmit;
>  	xmit->ohci = iso->host->hostdata;
>  	xmit->task_active = 0;
> +	xmit->last_cycle = -1;
> +	atomic_set(&iso->skips, 0);
>  
>  	dma_prog_region_init(&xmit->prog);
>  
> @@ -1856,6 +1860,26 @@ static void ohci_iso_xmit_task(unsigned 
>  		/* parse cycle */
>  		cycle = le32_to_cpu(cmd->output_last.status) & 0x1FFF;
>  
> +		if (xmit->last_cycle > -1) {
> +			int cycle_diff = cycle - xmit->last_cycle;
> +			int skip;
> +
> +			/* unwrap */
> +			if (cycle_diff < 0) {
> +				cycle_diff += 8000;
> +				if (cycle_diff < 0)
> +					PRINT(KERN_ERR, "bogus cycle diff %d\n",
> +					      cycle_diff);
> +			}
> +
> +			skip = cycle_diff - 1;
> +			if (skip > 0) {
> +				DBGMSG("skipped %d cycles without packet loss", skip);
> +				atomic_add(skip, &iso->skips);
> +			}
> +		}
> +		xmit->last_cycle = cycle;
> +
>  		/* tell the subsystem the packet has gone out */
>  		hpsb_iso_packet_sent(iso, cycle, event != 0x11);
>  
> @@ -1943,6 +1967,16 @@ static int ohci_iso_xmit_queue(struct hp
>  	prev->output_last.branchAddress = cpu_to_le32(
>  		dma_prog_region_offset_to_bus(&xmit->prog, sizeof(struct iso_xmit_cmd) * next_i) | 3);
>  
> +	/*
> +	 * Link the skip address to this descriptor itself. This causes a
> +	 * context to skip a cycle whenever lost cycles or FIFO overruns occur,
> +	 * without dropping the data at that point the application should then
> +	 * decide whether this is an error condition or not. Some protocols
> +	 * can deal with this by dropping some rate-matching padding packets.
> +	 */
> +	next->output_more_immediate.branchAddress =
> +			prev->output_last.branchAddress;
> +
>  	/* disable interrupt, unless required by the IRQ interval */
>  	if (prev_i % iso->irq_interval) {
>  		prev->output_last.control &= cpu_to_le32(~(3 << 20)); /* no interrupt */
> Index: linux/drivers/ieee1394/raw1394.c
> ===================================================================
> --- linux.orig/drivers/ieee1394/raw1394.c
> +++ linux/drivers/ieee1394/raw1394.c
> @@ -2356,13 +2356,16 @@ static void rawiso_activity_cb(struct hp
>  static void raw1394_iso_fill_status(struct hpsb_iso *iso,
>  				    struct raw1394_iso_status *stat)
>  {
> +	int overflows = atomic_read(&iso->overflows);
> +	int skips = atomic_read(&iso->skips);
> +
>  	stat->config.data_buf_size = iso->buf_size;
>  	stat->config.buf_packets = iso->buf_packets;
>  	stat->config.channel = iso->channel;
>  	stat->config.speed = iso->speed;
>  	stat->config.irq_interval = iso->irq_interval;
>  	stat->n_packets = hpsb_iso_n_ready(iso);
> -	stat->overflows = atomic_read(&iso->overflows);
> +	stat->overflows = ((skips & 0xFFFF) << 16) | ((overflows & 0xFFFF));
>  	stat->xmit_cycle = iso->xmit_cycle;
>  }
>  
> @@ -2437,6 +2440,8 @@ static int raw1394_iso_get_status(struct
>  
>  	/* reset overflow counter */
>  	atomic_set(&iso->overflows, 0);
> +	/* reset skip counter */
> +	atomic_set(&iso->skips, 0);
>  
>  	return 0;
>  }
> 

