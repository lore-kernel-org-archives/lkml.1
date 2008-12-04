Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYLDS0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYLDS0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYLDS0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:26:14 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:55564 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbYLDS0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=TrKrJcwpYRPTEn0uqGw/cHIlc62kADwjTJWLVXKweBuGMXegATZcsRuulHrabTgpFS
         wsmMzvTBNKBQDVCsWJzFxSr8JpVyqn6BdJnGGCpk9A2p7wPYGdQn8XSWCowPfU5+4xyi
         9FsXNM9tNQjHN9sYT4p4Hz+N/q/hnE25xUAL8=
Message-ID: <e9c3a7c20812041026v3293786sea3e81e2f777d58d@mail.gmail.com>
Date: Thu, 4 Dec 2008 11:26:10 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller
Cc: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Andrew Victor" <linux@maxim.org.za>
In-Reply-To: <492C1816.6020405@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F8B291.1060500@atmel.com>
	 <1224530326.27425.25.camel@dwillia2-linux.ch.intel.com>
	 <491DA8AC.5010703@atmel.com>
	 <e9c3a7c20811181100q27af85ey49823ba326e70a09@mail.gmail.com>
	 <492C1816.6020405@atmel.com>
X-Google-Sender-Auth: c4637166866f5732
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 8:21 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>>
>> They will be acknowledged by client code.  Calls like async_memcpy
>> assume that the the ack bit is clear by default so they can specify
>> some actions to run at completion time.  By setting it early, at
>> descriptor allocation time, async_tx will get confused.
>
> This ack bit is annoying me : I cannot figure out how it is used for plain
> memcopy/slave offload calls...
>
> Moreover, at recycle time, if I keep a descriptor chain as a whole, I have
> to introduce another state for my descriptors : consumed but not freed yet
> (with another linked list management).
> If I only take care of the ACK flag for releasing descriptors, I loose the
> dependency in my descriptor chain (in a multi-descriptor memcpy case).

Maybe I misread your driver... in the multi-descriptor memcpy case it
is perfectly fine to set the ack-bit in the driver for all but the
last descriptor in the chain.  The client is only expected to attach
dependencies at the end of the chain.

> Can I only consider this information without taking care of the chaining
> dependency (and loose this information in a multi-descriptor operation) ?

You can lose it for all but the last descriptor.

> Or, may I drop this DMA_CTRL_ACK bit management as I do not have the
> usefulness of redoing an operations on one descriptor (no xor engine) ?
>

If you will never need to run async_memcpy and don't want to handle
the bit then you could set DMA_PRIVATE and the channels would never be
picked up by the async_tx api.  But, I am not convinced we need to
take that step yet.

> Kind regards,
> --
> Nicolas Ferre
>

Thanks,
Dan
