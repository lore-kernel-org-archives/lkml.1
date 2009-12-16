Return-Path: <linux-kernel-owner+w=401wt.eu-S935885AbZLPWmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935885AbZLPWmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935474AbZLPWm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:42:29 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15393 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935873AbZLPWmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:42:14 -0500
Message-ID: <4B295F8C.4050905@caviumnetworks.com>
Date: Wed, 16 Dec 2009 14:30:36 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Chetan Loke <chetanloke@gmail.com>
CC: Chris Friesen <cfriesen@nortel.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: Irq architecture for multi-core network driver.
References: <4AE0D14B.1070307@caviumnetworks.com> <4AE0D72A.4090607@nortel.com>	 <4AE0DB98.1000101@caviumnetworks.com> <b2f3590f0912161408u73947f6fx6902ebef927caf94@mail.gmail.com>
In-Reply-To: <b2f3590f0912161408u73947f6fx6902ebef927caf94@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2009 22:30:36.0463 (UTC) FILETIME=[6350F3F0:01CA7E9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chetan Loke wrote:
>>> Does your hardware do flow-based queues?  In this model you have
>>> multiple rx queues and the hardware hashes incoming packets to a single
>>> queue based on the addresses, ports, etc. This ensures that all the
>>> packets of a single connection always get processed in the order they
>>> arrived at the net device.
>>>
>> Indeed, this is exactly what we have.
>>
>>
>>> Typically in this model you have as many interrupts as queues
>>> (presumably 16 in your case).  Each queue is assigned an interrupt and
>>> that interrupt is affined to a single core.
> 
>> Certainly this is one mode of operation that should be supported, but I
>> would also like to be able to go for raw throughput and have as many cores
>> as possible reading from a single queue (like I currently have).
>>
> Well, you could let the NIC firmware(f/w) handle this. The f/w would
> know which interrupt was just injected recently.In other words it
> would have a history of which CPU's would be available. So if some
> previously interrupted CPU isn't making good progress then the
> firmware should route the incoming response packets to a different
> queue. This way some other CPU will pick it up.
> 


It isn's a NIC.  There is no firmware.  The system interrupt hardware is 
what it is and cannot be changed.

My current implementation still has a single input queue configured and 
I get a maskable interrupt on a single CPU when packets are available. 
If the queue depth increases above a given threshold, I optionally send 
an IPI to another CPU to enable NAPI polling on that CPU.

Currently I have a module parameter that controls the maximum number of 
CPUs that will have NAPI polling enabled.

This allows me to get multiple CPUs doing receive processing without 
having to hack into the lower levels of the system's interrupt 
processing code to try to do interrupt steering.  Since all the 
interrupt service routine was doing was call netif_rx_schedule(), I can 
simply do this via smp_call_function_single().

David Daney
