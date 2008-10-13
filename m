Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYJMSvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYJMSvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760647AbYJMSvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:51:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:43271 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbYJMSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rBMCkkf6OguSV0doaUyS5XmLc5SWceGkA0PIyTO3qScVXiWzO/vtgnNmPkOgWZbA8w
         FuqYEMT33K6DQMNrc95swDN8bFrWOyyzKammvgmTzhJ8Ce8lxybhl4vznznX43NKIUQ0
         6ELR9cocWYbqcpS1ZQscF+liMNs74xFLtQvxs=
Message-ID: <e9c3a7c20810131151q2d8c4b44ve538e00bc4d8ae1b@mail.gmail.com>
Date: Mon, 13 Oct 2008 11:51:28 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: dmaengine: DMA_CTRL_ACK flag signification
Cc: "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>
In-Reply-To: <7F38996F7185A24AB9071ED4950AD8C102121A73@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DA2B94.3020804@atmel.com>
	 <7F38996F7185A24AB9071ED4950AD8C102121A73@swsmsx413.ger.corp.intel.com>
X-Google-Sender-Auth: f32626e8587a1a6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2008 at 2:09 AM, Sosnowski, Maciej
<maciej.sosnowski@intel.com> wrote:
> Nicolas Ferre wrote:
>> Hi all,
>>
>> I am in the process of writing a driver for an on-chip Atmel DMA
>> engine.
>>
>> I am a little confused about the use of the flag DMA_CTRL_ACK : It
>> seems that it is set in most of the descriptors in use except the
>> first or last of a descriptor chain. So, I cannot find where this
>> flag is cleared. In short, I do not see what it is used for : how
>> must I take it into account in my driver (in device_prep_dma_memcpy()
>> for instance) ?
>>
>> Can you enlighten me ?
>>
>> Regards,
>
> Hi Nicolas,
>
> Sorry for the delay in response.
> Generally the idea behind DMA_CTRL_ACK is to let an application
> safely set a chain of dependent operations.
> What a DMA driver needs to do is to check
> if a given descriptor has been already acked (using async_tx_test_ack())
> before it recycles or releases it.
> You are right that there is no place where DMA_CTRL_ACK
> is cleared at the moment. I would say it is the offload engine driver
> responsibility to clear the flag when it recycles the descriptor.
> Dan, could you confirm?

It may be better to call this the 'ownership' bit as while it is clear
client code owns the descriptor and can add dependent operations, once
it is set the dmaengine driver is free to recycle the descriptor for
use in another operation.  The driver's only responsibility* is to
read the bit in its cleanup routine.

--
Dan

*Note that if the driver decides to support transfer sizes larger than
its hardware maximum then it needs to set the ack bit on any internal
descriptors.  I.e. if the hardware can only do 4KB per descriptor it
would allocate two descriptors for an 8KB transfer and set the ack bit
on the first, leaving the second up to the caller.
