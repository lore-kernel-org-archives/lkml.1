Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbXIOHx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbXIOHx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 03:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbXIOHxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 03:53:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:45841 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbXIOHxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 03:53:19 -0400
Message-ID: <46EB8F6C.3090008@qumranet.com>
Date: Sat, 15 Sep 2007 10:53:16 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com>	<46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws>
In-Reply-To: <46EAF6FC.80207@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 15 Sep 2007 10:53:17 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Anthony Liguori wrote:
>>   
>>     
>>> This patch refactors the current hypercall infrastructure to better support live
>>> migration and SMP.  It eliminates the hypercall page by trapping the UD
>>> exception that would occur if you used the wrong hypercall instruction for the
>>> underlying architecture and replacing it with the right one lazily.
>>>   
>>>     
>>>       
>> I guess it would be pretty rude/unlikely for these opcodes to get reused
>> in other implementations...  But couldn't you make the page trap
>> instead, rather than relying on an instruction fault?
>>   
>>     
>
> The whole point of using the instruction is to allow hypercalls to be 
> used in many locations.  This has the nice side effect of not requiring 
> a central hypercall initialization routine in the guest to fetch the 
> hypercall page.  A PV driver can be completely independent of any other 
> code provided that it restricts itself to it's hypercall namespace.
>
>   

It also has the benefit of not requiring an initialization protocol, and
of reducing complaints about the hypervisor injecting code into the guest.


>>> It also introduces the infrastructure to probe for hypercall available via
>>> CPUID leaves 0x40000002.  CPUID leaf 0x40000003 should be filled out by
>>> userspace.
>>>   
>>>     
>>>       
>> Is this compatible with Xen's (and other's) use of cpuid?  That is,
>> 0x40000000 returns a hypervisor-specific signature in e[bcd]x, and eax
>> has the max hypervisor leaf.
>>   
>>     
>
> Xen is currently using 0/1/2.  I had thought it was only using 0/1.  The 
> intention was not to squash Xen's current CPUID usage so that it would 
> still be possible for Xen to make use of the guest code.  Can we agree 
> that Xen won't squash leaves 3/4 or is it not worth trying to be 
> compatible at this point?
>   

I definitely want kvm to be able to emulate the Xen hypercall interface,
but there's no need to allow both concurrently.  So I'd say use
0x40000000 for detection and the rest cannot clash because detection fails.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

