Return-Path: <linux-kernel-owner+w=401wt.eu-S1762687AbXHXQre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687AbXHXQre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbXHXQrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:47:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:24512 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbXHXQrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="121325803"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 -mm 4/7] I/OAT: Split PCI startup from DMA handling code
Date: Fri, 24 Aug 2007 09:47:11 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02EB51E1@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070823230811.f9a0c5e8.randy.dunlap@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 -mm 4/7] I/OAT: Split PCI startup from DMA handling code
thread-index: AcfmFVkkX78UBHitTG6RYXFykrW/LwAWKccw
References: <20070824001335.16997.79665.stgit@localhost.localdomain><20070824001512.16997.29302.stgit@localhost.localdomain> <20070823230811.f9a0c5e8.randy.dunlap@oracle.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <davem@davemloft.net>
X-OriginalArrivalTime: 24 Aug 2007 16:47:12.0278 (UTC) FILETIME=[6B351360:01C7E66E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap [mailto:randy.dunlap@oracle.com] 
>
>On Thu, 23 Aug 2007 17:15:12 -0700 Shannon Nelson wrote:
>
>> Split the general PCI startup from the DMA handling code in order to
>> prepare for adding support for DCA services and future 
>versions of the
>> ioatdma device.
>> 
>> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
>> Acked-by: David S. Miller <davem@davemloft.net>
>> ---
>> 
>>  drivers/dma/Makefile     |    2 
>>  drivers/dma/ioat.c       |  186 
>++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/dma/ioat_dma.c   |  196 
>+++++++++++-----------------------------------
>>  drivers/dma/ioatdma.h    |   16 +++-
>>  drivers/dma/ioatdma_hw.h |    2 
>>  5 files changed, 245 insertions(+), 157 deletions(-)
>
>> diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
>> index 9a4d154..9012176 100644
>> --- a/drivers/dma/ioat_dma.c
>> +++ b/drivers/dma/ioat_dma.c
>
>> -	printk(KERN_INFO " "
>> -		"ioatdma: Intel(R) I/OAT DMA Engine 
>initialization failed\n");
>> -
>> -	return err;
>> +	iounmap(iobase);
>> +	printk(KERN_ERR " "
>> +	       "ioatdma: Intel(R) I/OAT DMA Engine 
>initialization failed\n");
>
>Drop the " " after KERN_ERR...

Yes, is dumb, but is addressed in the next patch in the series.

>
>> +	return NULL;
>>  }
>
>> diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
>> index bf4dad7..26aff08 100644
>> --- a/drivers/dma/ioatdma.h
>> +++ b/drivers/dma/ioatdma.h
>> @@ -31,7 +31,7 @@
>>  #define IOAT_LOW_COMPLETION_MASK	0xffffffc0
>>  
>>  /**
>> - * struct ioat_device - internal representation of a IOAT device
>> + * struct ioatdma_device - internal representation of a IOAT device
>>   * @pdev: PCI-Express device
>>   * @reg_base: MMIO register space base address
>>   * @dma_pool: for allocating DMA descriptors
>> @@ -39,14 +39,14 @@
>>   * @msi: Message Signaled Interrupt number
>>   */
>>  
>> -struct ioat_device {
>> +struct ioatdma_device {
>>  	struct pci_dev *pdev;
>>  	void __iomem *reg_base;
>>  	struct pci_pool *dma_pool;
>>  	struct pci_pool *completion_pool;
>>  
>>  	struct dma_device common;
>> -	u8 msi;
>> +	u8 version;
>
>This field name change needs a corresponding change in the
>struct's kernel-doc above here.

Oops, missed that one - thanks.

>
>>  };
>>  
>>  /**
>
>> @@ -117,4 +117,12 @@ struct ioat_desc_sw {
>>  	struct dma_async_tx_descriptor async_tx;
>>  };
>>  
>> +#if defined(CONFIG_INTEL_IOATDMA) || 
>defined(CONFIG_INTEL_IOATDMA_MODULE)
>> +struct ioatdma_device *ioat_dma_probe(struct pci_dev *, 
>void __iomem *);
>
>Please use parameter variable names in function prototypes (above;
>most places already have them).

Yep, I'll get it.

Again, thanks for your comments,
sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
