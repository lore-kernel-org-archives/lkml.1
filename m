Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbXHVGIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbXHVGIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbXHVGIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:08:24 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53150 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173AbXHVGIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:08:23 -0400
Message-ID: <46CBD1A5.8070702@vmware.com>
Date: Tue, 21 Aug 2007 23:03:17 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CBD0F5.2080709@zytor.com>
In-Reply-To: <46CBD0F5.2080709@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Zachary Amsden wrote:
>   
>> In general, I/O in a virtual guest is subject to performance problems. 
>> The I/O can not be completed physically, but must be virtualized.  This
>> means trapping and decoding port I/O instructions from the guest OS. 
>> Not only is the trap for a #GP heavyweight, both in the processor and
>> the hypervisor (which usually has a complex #GP path), but this forces
>> the hypervisor to decode the individual instruction which has faulted. 
>> Worse, even with hardware assist such as VT, the exit reason alone is
>> not sufficient to determine the true nature of the faulting instruction,
>> requiring a complex and costly instruction decode and simulation.
>>
>> This patch provides hypercalls for the i386 port I/O instructions, which
>> vastly helps guests which use native-style drivers.  For certain VMI
>> workloads, this provides a performance boost of up to 30%.  We expect
>> KVM and lguest to be able to achieve similar gains on I/O intensive
>> workloads.
>>
>>     
>
> What about cost on hardware?
>   

On modern hardware, port I/O is about the most expensive thing you can 
do.  The extra function call cost is totally masked by the stall.  We 
have measured with port I/O converted like this on real hardware, and 
have seen zero measurable impact on macro-benchmarks.  Micro-benchmarks 
that generate massively repeated port I/O might show some effect on 
ancient hardware, but I can't even imagine a workload which does such a 
thing, other than a polling port I/O loop perhaps - which would not be 
performance critical in any case I can reasonably imagine.

Zach
