Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbXHVFqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbXHVFqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 01:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbXHVFpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 01:45:47 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45136 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579AbXHVFpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 01:45:46 -0400
Message-ID: <46CBCC58.3010700@vmware.com>
Date: Tue, 21 Aug 2007 22:40:40 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com>
In-Reply-To: <46CBCADF.2070400@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Zachary Amsden wrote:
>   
>> In general, I/O in a virtual guest is subject to performance
>> problems.  The I/O can not be completed physically, but must be
>> virtualized.  This means trapping and decoding port I/O instructions
>> from the guest OS.  Not only is the trap for a #GP heavyweight, both
>> in the processor and the hypervisor (which usually has a complex #GP
>> path), but this forces the hypervisor to decode the individual
>> instruction which has faulted.  Worse, even with hardware assist such
>> as VT, the exit reason alone is not sufficient to determine the true
>> nature of the faulting instruction, requiring a complex and costly
>> instruction decode and simulation.
>>
>> This patch provides hypercalls for the i386 port I/O instructions,
>> which vastly helps guests which use native-style drivers.  For certain
>> VMI workloads, this provides a performance boost of up to 30%.  We
>> expect KVM and lguest to be able to achieve similar gains on I/O
>> intensive workloads.
>>
>>     
>
>
> Won't these workloads be better off using paravirtualized drivers? 
> i.e., do the native drivers with paravirt I/O instructions get anywhere
> near the performance of paravirt drivers?
>   

Yes, in general, this is true (better off with paravirt drivers).  
However, we have "paravirt" drivers which run in both 
fully-paravirtualized and fully traditionally virtualized environments.  
As a result, they use native port I/O operations to interact with 
virtual hardware.

Since not all hypervisors have paravirtualized driver infrastructures 
and guest O/S support yet, these hypercalls can be advantages to a wide 
range of scenarios.  Using I/O hypercalls as such gives exactly the same 
performance as paravirt drivers for us, by eliminating the costly decode 
path, and the simplicity of using the same driver code makes this a huge 
win in code complexity.

Zach

