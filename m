Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0BHTRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:17:39 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26845 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab0BHTRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:17:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5886"; a="33709059"
Message-ID: <4B70634E.4040008@codeaurora.org>
Date: Mon, 08 Feb 2010 11:17:34 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Daniel Walker <dwalker@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Larry Bassel <lbassel@quicinc.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: Change the mandatory barriers implementation
References: <4B6A131B.1070005@codeaurora.org>	 <1265289330.28746.58.camel@pc1117.cambridge.arm.com> <1265367873.7692.52.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1265367873.7692.52.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On Thu, 2010-02-04 at 13:15 +0000, Catalin Marinas wrote:
>> On Thu, 2010-02-04 at 00:21 +0000, Abhijeet Dharmapurikar wrote:
>>>> The mandatory barriers (mb, rmb, wmb) are used even on uniprocessor
>>>> systems for things like ordering Normal Non-cacheable memory accesses
>>>> with DMA transfer (via Device memory writes). The current implementation
>>>> uses dmb() for mb() and friends but this is not sufficient. The DMB only
>>>> ensures the ordering of accesses with regards to a single observer
>>>> accessing the same memory. If a DMA transfer is started by a write to
>>>> Device memory, the data to be transfered may not reach the main memory
>>>> (even if mapped as Normal Non-cacheable) before the device receives the
>>>> notification to begin the transfer. The only barrier that would help in
>>>> this situation is DSB which would completely drain the write buffers.
>>> On ARMv7, DMB guarantees that all accesses prior to DMB are observed by
>>> an observer if that observer sees any accesses _after_ the DMB. In this
>>> case, since DMA engine observes a write to itself( It is being written
>>> to and hence must observe the write) it should also see the writes to
>>> the buffers. A dmb() after the writes to buffer and before write to DMA
>>> engine should suffice.
>> I asked our processor architect for a clarification on the wording of
>> the DMB definition but the "all accesses" part most likely refer to
>> accesses to the same peripheral or memory block (but not together).
> 
> I got some clarification and there is nothing wrong with the definition
> of the DMB. The catch here is that "observe" (as per the ARM ARM) is
> defined only for master accesses. The DMA engine in this case above does
> not "observe" the write to itself as this is a slave access to one of
> its memory-mapped ports.
> 
> So, the code below:
> 
> 	STR	[Normal non-cacheable]
> 	DMB
> 	STR	[Device]
> 
> puts the first store in Group A (according to the DMB definition) and
> the second store in Group B but since the DMA device does not "observe"
> Group B in this case, there is no requirement for the ordering between
> the observability of the store to normal memory and the observability of
> the side-effects of the store to the DMA device.

I agree now. DSB would be the right thing to do. Moreover the option to 
have a barrier.h for each platform gives them a chance to fine tune 
these barriers further.



