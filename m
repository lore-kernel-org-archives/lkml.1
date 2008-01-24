Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYAXByi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYAXByi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYAXBy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:54:29 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4719 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYAXBy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:54:28 -0500
Date: Wed, 23 Jan 2008 19:53:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv and 2.6.24 (was Re: fixed a bug of adma in rhel4u5 with
 HDS7250SASUN500G.)
In-reply-to: <4797ECF8.9000606@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Kuan Luo <kluo@nvidia.com>, Tejun Heo <htejun@gmail.com>,
       Mark Lord <liml@rtr.ca>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Allen Martin <AMartin@nvidia.com>, Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Milburn <dmilburn@redhat.com>
Message-id: <4797EF9D.4010003@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4781F008.9070404@gmail.com> <4782422C.8020202@rtr.ca>
 <4782B73B.8080309@shaw.ca> <4782BC48.4000309@gmail.com>
 <4782C008.3030902@shaw.ca> <4782CB62.7040901@gmail.com>
 <4782CEF9.3040708@gmail.com> <4782DFFE.50301@shaw.ca>
 <4782E5A8.9010305@gmail.com> <4782E63E.1000606@gmail.com>
 <4782E78F.9050205@shaw.ca> <4782E912.1050204@gmail.com>
 <4783493A.7070800@gmail.com> <47838B57.8020407@shaw.ca>
 <47842A54.2060107@gmail.com> <47842ABA.2060605@gmail.com>
 <47844471.4070705@shaw.ca> <47845708.6060900@gmail.com>
 <478567D8.10601@shaw.ca>
 <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com>
 <478812C9.1000901@shaw.ca>
 <15F501D1A78BD343BE8F4D8DB854566B1BFE2AC0@hkemmail01.nvidia.com>
 <478AF10D.5080805@shaw.ca> <479709BE.2090707@garzik.org>
 <479752D7.4020206@shaw.ca> <4797ECF8.9000606@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> Jeff Garzik wrote:
>>> Ping...  sata_nv status is still a bit open for 2.6.24, and I would 
>>> like to move us forward a bit.
>>>
>>> * Kuan's patch...  it has been confirmed (and is needed), correct?  
>>> can someone work up a good patch for 2.6.24?  The only one I ever 
>>> received was badly word-wrapped, and at the time, Robert seemed 
>>> uncertain of it, so I waited.
>>
>> I can get you one later today hopefully.

A question came up on this patch, whether it will cause problems with 
ATAPI mode - waiting for a response from the NVIDIA guys.

>>
>>>
>>> * ADMA ATAPI 4GB issues...  playing tricks with the ordering of 
>>> allocations and DMA masks is just way too fragile.  We just cannot 
>>> guarantee that all allocators work that way.  The obvious solution to 
>>> me seems to be hardcoding the consistent DMA mask to 32-bit, but 
>>> using 64-bit for regular dma mask if-and-only-if ADMA is enabled.
>>
>> That's not enough to fix the problem since there's issues with actual 
>> transfer data being allocated above 4GB as well, not just the 
>> consistent  allocations (it appears that blk_queue_bounce_limit 
>> setting to 32-bit doesn't prevent this on x86_64). Either we play some 
>> funky games with changing the DMA mask of the entire device to 32-bit 
>> if either port is in ATAPI mode (which blew up when I tried it) or we 
>> add the ability to set the DMA mask independently on each port (like 
>> by setting the mask on the SCSI device and using that for DMA mapping 
>> instead) which requires core changes.
> 
> Its all funky games that no other driver is doing...  There is one 
> guaranteed to work scenario -- set all masks and bounce limits etc. to 
> 32-bit.  There is also one highly-likely-to-work scenario, disabling 
> ADMA by default.

Sure, if you don't mind a potentially significant performance 
regression. All the DMA mask problems are due to the fact that the mask 
settings for both ports are ganged together on the PCI device. If we 
could set the DMA masks on the SCSI device or something else that was 
port-specific, and do the command DMA mapping against that device, then 
most of the wierdness goes away.

It does seem like we're starting to get a bit of NVIDIA interest in 
looking into ADMA issues, which is definitely welcome.

> 
> 
>>> * it sure seems like there are other open sata_nv ADMA issues -- can 
>>> we hard-confirm or deny this?  bugzilla wasn't very helpful for me.  
>>> It doesn't seem like we can disable ADMA (to solve those issues) and 
>>> get enough test time in (which is what I said a week (or more?) ago 
>>> too...)
>>
>> The NCQ/non-NCQ command switching issue is still hitting some people 
>> (last I heard Kuan was looking into this), also there's a hotplug 
>> issue that Tejun reported..
> 
> The former implies we need to disable swncq for 2.6.24, if it's not 
> stable yet.

Huh? Nothing to do with SWNCQ, which last I checked was still off by 
default.
