Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXHDRbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXHDRbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764167AbXHDRbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:31:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39584 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761273AbXHDRbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:31:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B4B7C6.1040107@s5r6.in-berlin.de>
Date: Sat, 04 Aug 2007 19:30:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: stable@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Olaf Hering <olh@suse.de>
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit DMA mapping"
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no> <46B4B3DC.7020609@shaw.ca>
In-Reply-To: <46B4B3DC.7020609@shaw.ca>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Cc: linuxppc-dev, olh)

Robert Hancock wrote:
> Stefan Richter wrote:
>> Date: Wed, 1 Aug 2007 20:30:36 +0200 (CEST)
>> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
>> Subject: ieee1394: revert "sbp2: enforce 32bit DMA mapping"
>>
>> Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.
>> The dma_set_mask call somehow failed on a PowerMac G5, PPC64:
>> http://lkml.org/lkml/2007/8/1/344
>>
>> Should there ever occur a DMA mapping beyond the physical DMA range, a
>> proper SBP-2 firmware will report transport errors.  So let's leave it
>> at that.
> 
> Isn't this a rather poor workaround? All this means is that if we fail
> to set a 32-bit DMA mask, we're likely to blow up at runtime instead of
> at initialization time, when we get a DMA mapping over 4GB.

I generally agree with you.  But since I actually never heard of
problems that could directly be related to sbp2's DMA areas exceeding
the OHCI-1394 physical DMA range (4GB in most OHCI-1394
implementations), I consider this simple reversion good enough for post
2.6.23-rc1 and especially for 2.6.22.y.

My original commit 0555659.. was a violation of "If it ain't (known)
broken, don't fix it".

> If setting 32-bit DMA mask fails on ppc64, that sounds like a problem
> with the DMA implementation on that architecture. There are enough cards
> out there that only support 32-bit DMA that this really needs to work..

Yes, could the PPC folks please have a look at it?  Thanks.

>> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>> Tested-by: Olaf Hering <olh@suse.de>
>> ---
>> Same as commit a9c2f18800753c82c45fc13b27bdc148849bdbb2.
>>
>>  drivers/ieee1394/sbp2.c |    5 -----
>>  1 file changed, 5 deletions(-)
>>
>> Index: linux-2.6.22/drivers/ieee1394/sbp2.c
>> ===================================================================
>> --- linux-2.6.22.orig/drivers/ieee1394/sbp2.c
>> +++ linux-2.6.22/drivers/ieee1394/sbp2.c
>> @@ -774,11 +774,6 @@ static struct sbp2_lu *sbp2_alloc_device
>>              SBP2_ERR("failed to register lower 4GB address range");
>>              goto failed_alloc;
>>          }
>> -#else
>> -        if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
>> -            SBP2_ERR("failed to set 4GB DMA mask");
>> -            goto failed_alloc;
>> -        }
>>  #endif
>>      }
>>  

-- 
Stefan Richter
-=====-=-=== =--- --=--
http://arcgraph.de/sr/
