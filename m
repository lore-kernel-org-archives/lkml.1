Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbYDJWJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbYDJWJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 18:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbYDJWI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 18:08:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54584 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759136AbYDJWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 18:08:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47FE8FC8.8000007@s5r6.in-berlin.de>
Date: Fri, 11 Apr 2008 00:08:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Bernhard Kaindl <bk@suse.de>
Subject: Re: [PATCH linux1394-2.6.git] firewire: fw-ohci: add option for remote
 debugging - amendment
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <47FCF50E.9090703@s5r6.in-berlin.de> <20080410065227.GB30066@elte.hu> <20080410174418.ebfe76c3.sfr@canb.auug.org.au> <tkrat.991b1750a56cf2e9@s5r6.in-berlin.de> <20080410095112.GB12543@elte.hu> <tkrat.88330c779367ee9d@s5r6.in-berlin.de>
In-Reply-To: <tkrat.88330c779367ee9d@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>   - Open the physical DMA filter in the top half of the IRQ handler
>     and flush the necessary MMIO writes.  This is to open the filter
>     as soon as possible after bus reset.
...
> --- linux.orig/drivers/firewire/fw-ohci.c
> +++ linux/drivers/firewire/fw-ohci.c
> @@ -1309,11 +1309,6 @@ static void bus_reset_tasklet(unsigned l
>  		reg_write(ohci, OHCI1394_ConfigROMhdr, ohci->next_header);
>  	}
>  
> -#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
> -	reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
> -	reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
> -#endif
> -
>  	spin_unlock_irqrestore(&ohci->lock, flags);
>  
>  	if (free_rom)
> @@ -1341,8 +1336,14 @@ static irqreturn_t irq_handler(int irq, 
>  	reg_write(ohci, OHCI1394_IntEventClear, event & ~OHCI1394_busReset);
>  	log_irqs(event);
>  
> -	if (event & OHCI1394_selfIDComplete)
> +	if (event & OHCI1394_selfIDComplete) {
> +#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
> +		reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
> +		reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
> +		flush_writes(ohci);
> +#endif
>  		tasklet_schedule(&ohci->bus_reset_tasklet);
> +	}
>  

I retract this part of the patch.  Writes to PhyReqFilter have no effect 
as long as intEvent.busReset isn't cleared.  This happens in the bottom 
half of the bus reset handler (bus_reset_tasklet).

The rest of the patch stays valid.
-- 
Stefan Richter
-=====-==--- -=-- -=-==
http://arcgraph.de/sr/
