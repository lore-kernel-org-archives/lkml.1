Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbYKYPWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbYKYPWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYKYPWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:22:20 -0500
Received: from mail.atmel.fr ([81.80.104.162]:39033 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYKYPWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:22:19 -0500
Message-ID: <492C1816.6020405@atmel.com>
Date: Tue, 25 Nov 2008 16:21:58 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH] dmaengine: at_hdmac: new driver for the Atmel AHB DMA
 Controller
References: <48F8B291.1060500@atmel.com>	 <1224530326.27425.25.camel@dwillia2-linux.ch.intel.com>	 <491DA8AC.5010703@atmel.com> <e9c3a7c20811181100q27af85ey49823ba326e70a09@mail.gmail.com>
In-Reply-To: <e9c3a7c20811181100q27af85ey49823ba326e70a09@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams :
> On Fri, Nov 14, 2008 at 9:34 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>>>>  include/linux/at_hdmac.h                |   26 +
>>> ...this header should be moved somewhere under arch/arm/include.
>> This is where dw_dmac.h resides. Moreover, if one day this IP is implemented
>> on a different architecture, it will be good not to reach it through
>> arch/arm path.
> 
> Ok, I won't gate acceptance on this since dw_dmac already set the
> precedent, but shouldn't the header move after the IP has been
> duplicated?  Just my 2cents.

Ok, I follow your advice.


>>>> +               memset(desc, 0, sizeof(struct at_desc));
>>>> +               dma_async_tx_descriptor_init(&desc->txd, chan);
>>>> +               async_tx_ack(&desc->txd);
>>> the DMA_CTRL_ACK bit is under control of the client.  It should be
>>> read-only to the driver (except for extra descriptors that the driver
>>> creates on behalf of the client).
>> This is precisely where the descriptors are been created so, I thought it
>> should be ok to initialize this bit. Am I right ?
>>
> 
> They will be acknowledged by client code.  Calls like async_memcpy
> assume that the the ack bit is clear by default so they can specify
> some actions to run at completion time.  By setting it early, at
> descriptor allocation time, async_tx will get confused.

This ack bit is annoying me : I cannot figure out how it is used for 
plain memcopy/slave offload calls...

Moreover, at recycle time, if I keep a descriptor chain as a whole, I 
have to introduce another state for my descriptors : consumed but not 
freed yet (with another linked list management).
If I only take care of the ACK flag for releasing descriptors, I loose 
the dependency in my descriptor chain (in a multi-descriptor memcpy case).

Can I only consider this information without taking care of the chaining 
dependency (and loose this information in a multi-descriptor operation) ?
Or, may I drop this DMA_CTRL_ACK bit management as I do not have the 
usefulness of redoing an operations on one descriptor (no xor engine) ?

Kind regards,
-- 
Nicolas Ferre

