Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYLJOHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYLJOHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYLJOHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:07:20 -0500
Received: from xenbox.codefidence.com ([92.48.73.16]:33002 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYLJOHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:07:19 -0500
Message-ID: <493FCD12.30000@codefidence.com>
Date: Wed, 10 Dec 2008 16:07:14 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
Organization: Codefidence Ltd.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Laurent Pinchart <laurent.pinchart@skynet.be>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
References: <20081210073247.GA18630@localhost> <200812101040.09886.laurent.pinchart@skynet.be> <20081210124308.GB6772@localhost>
In-Reply-To: <20081210124308.GB6772@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:

> Hi Laurent,
>
> On Wed, Dec 10, 2008 at 11:40:09AM +0200, Laurent Pinchart wrote:
>   
>> Hi Wu,
>>
>> On Wednesday 10 December 2008, Wu Fengguang wrote:
>>     
>>> sizeof(struct usb_ctrlrequest) = 8, which is as small as the *dt pointer
>>> in a 64bit system.
>>>       
>> The usb_ctrlrequest pointer is passed down to the hardware and must point to 
>> DMA-able memory. For this reason you can't use the stack and must kmalloc() 
>> the structure.
>>     
>
> Ah thanks for the background. Does GFP_NOIO guarantee that?
>   
No, GFP_NOIO means - do not generate block IO operations (e.g. move 
pages to swap, sync dirty buffers to permanent storage etc.) in order to 
fulfill this allocation.

The reason for this flag here is presumably that such block IO 
operations may very cause USB transaction of the very same kind we're 
trying to service now, which can easily get us to a loop.
> e.g. what if the memory is allocated from ZONE_HIGHMEM?
>   
In many cases there is no problem to DMA high memory. If you happen to 
be working with a device that does have problems with full 32 bit 
addresses then GFP_DMA would be the right flag, not GFP_NOIO.

Cheers,
Gilad


-- 
Gilad Ben-Yossef 
Chief Coffee Drinker

Codefidence Ltd.
The code is free, your time isn't.(TM)

Web:    http://codefidence.com
Email:  gilad@codefidence.com
Office: +972-8-9316883 ext. 201
Fax:    +972-8-9316885
Mobile: +972-52-8260388

	The Doctor: Don't worry, Reinette, just a nightmare. 
	Everyone has nightmares. Even monsters from under the 
	bed have nightmares, don't you, monster?
	Reinette: What do monsters have nightmares about?
	The Doctor: Me! 

