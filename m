Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbXHXSSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbXHXSSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932338AbXHXSSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:18:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:18232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765798AbXHXSSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:18:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="283478594"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 -mm 5/7] I/OAT: Add support for MSI and MSI-X
Date: Fri, 24 Aug 2007 11:18:13 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02EB53A4@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070824104837.341fbc12.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 -mm 5/7] I/OAT: Add support for MSI and MSI-X
thread-index: Acfmd8UIcEIGkf6cQMSHJvLcFX5DpwAAccUg
References: <20070824001335.16997.79665.stgit@localhost.localdomain><20070824001517.16997.72496.stgit@localhost.localdomain> <20070824104837.341fbc12.randy.dunlap@oracle.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>
X-OriginalArrivalTime: 24 Aug 2007 18:18:14.0026 (UTC) FILETIME=[22A9AEA0:01C7E67B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap [mailto:randy.dunlap@oracle.com] 
>
>On Thu, 23 Aug 2007 17:15:17 -0700 Shannon Nelson wrote:
>
>> Add support for MSI and MSI-X interrupt handling, including 
>the ability
>> to choose the desired interrupt method.
>> 
>> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
>> Acked-by: David S. Miller <davem@davemloft.net>
>> ---
>> 
>>  drivers/dma/ioat_dma.c          |  353 
>++++++++++++++++++++++++++++++++-------
>>  drivers/dma/ioatdma.h           |   12 +
>>  drivers/dma/ioatdma_registers.h |    6 +
>>  3 files changed, 305 insertions(+), 66 deletions(-)
>> 
>> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
>> index 9012176..0909fee 100644
>> --- a/drivers/dma/ioat_dma.c
>> +++ b/drivers/dma/ioat_dma.c
>> @@ -47,6 +47,71 @@
>>  static void ioat_dma_start_null_desc(struct ioat_dma_chan 
>*ioat_chan);
>>  static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan 
>*ioat_chan);
>>  
>> +#define for_each_bit(bit, addr, size) \
>> +	for ((bit) = find_first_bit((addr), (size)); \
>> +	     (bit) < (size); \
>> +	     (bit) = find_next_bit((addr), (size), (bit) + 1))
>
>Any reason that this macro shouldn't be added to
>include/linux/bitops.h instead of here?  I'd prefer/expect such
>general-purpose macros to live somewhere else.

Sure, I can do this.  Davem had a similar comment earlier.

>
>
>> @@ -276,6 +352,34 @@ static void 
>ioat_dma_free_chan_resources(struct dma_chan *chan)
>>  			in_use_descs - 1);
>>  
>>  	ioat_chan->last_completion = ioat_chan->completion_addr = 0;
>> +	ioat_chan->pending = 0;
>> +}
>> +/**
>> + * ioat_dma_get_next_descriptor - return the next available 
>descriptor from
>> + *				  the chain
>
>Unfortunately, function name + short description in kernel-doc must be
>on one line (only).  If you want to add more text/description, put it
>after the parameters (like you have done :).

Got it.

>
>> + * @ioat_chan: IOAT DMA channel handle
>
>We normally use one
> *
>line between the parameters and following text.

Okay

>
>> + * Gets the next descriptor from the chain, and must be 
>called with the
>> + * channel's desc_lock held.  Allocates more descriptors if 
>the channel
>> + * has run out.
>> + */
>> +static struct ioat_desc_sw *ioat_dma_get_next_descriptor(
>> +						struct 
>ioat_dma_chan *ioat_chan)
>> +{
>> +	struct ioat_desc_sw *new = NULL;
>> +
>> +	if (!list_empty(&ioat_chan->free_desc)) {
>> +		new = to_ioat_desc(ioat_chan->free_desc.next);
>> +		list_del(&new->node);
>> +	} else {
>> +		/* try to get another desc */
>> +		new = ioat_dma_alloc_descriptor(ioat_chan, GFP_ATOMIC);
>> +		/* will this ever happen? */
>> +		/* TODO add upper limit on these */
>> +		BUG_ON(!new);
>> +	}
>> +
>> +	prefetch(new->hw);
>> +	return new;
>>  }
>>  
>>  static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
>> @@ -639,6 +711,162 @@ out:
>>  	return err;
>>  }
>>  
>> +static char ioat_interrupt_style[32] = "msix";
>> +module_param_string(ioat_interrupt_style, ioat_interrupt_style,
>> +		    sizeof(ioat_interrupt_style), 0644);
>> +MODULE_PARM_DESC(ioat_interrupt_style,
>> +		 "set ioat interrupt style: msix (default), "
>> +		 "msix-single-vector, msi, intx)");
>> +
>> +/**
>> + * ioat_dma_setup_interrupts - setup interrupt handler, 
>choosing btwn msix,
>> + *                             msi, and legacy
>
>Same one-line nit.  legacy == intx, I suppose.

Got it.

>
>
>> + * @device: ioat device
>> + */
>> +int ioat_dma_setup_interrupts(struct ioatdma_device *device)
>> +{
>> +	struct ioat_dma_chan *ioat_chan;
>> +	int err, i, j, msixcnt;
>> +	u8 intrctrl = 0;
>> +
>> +	if (!strcmp(ioat_interrupt_style, "msix"))
>> +		goto msix;
>> +	else if (!strcmp(ioat_interrupt_style, "msix-single-vector"))
>> +		goto msix_single_vector;
>> +	else if (!strcmp(ioat_interrupt_style, "msi"))
>> +		goto msi;
>> +	else if (!strcmp(ioat_interrupt_style, "intx"))
>> +		goto intx;
>
>The "else"s aren't needed.

Hmmm - yep.

>
>> +
>> +msix:
>
>...
>
>---
>~Randy
>*** Remember to use Documentation/SubmitChecklist when testing 
>your code ***
>

Thanks,
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
