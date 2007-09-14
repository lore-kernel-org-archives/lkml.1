Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbXINVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbXINVpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXINVpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:45:13 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:27397 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbXINVpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:45:11 -0400
Message-ID: <46EB00D8.3090903@codemonkey.ws>
Date: Fri, 14 Sep 2007 16:44:56 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.6 (X11/20070830)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com>	 <46EAF4C6.8090903@goop.org>  <46EAF6FC.80207@codemonkey.ws> <1189804847.5982.137.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1189804847.5982.137.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> On Fri, 2007-09-14 at 16:02 -0500, Anthony Liguori wrote:
>   
>> Jeremy Fitzhardinge wrote:
>>     
>>> Anthony Liguori wrote:
>>>   
>>>       
>>>> This patch refactors the current hypercall infrastructure to better support live
>>>> migration and SMP.  It eliminates the hypercall page by trapping the UD
>>>> exception that would occur if you used the wrong hypercall instruction for the
>>>> underlying architecture and replacing it with the right one lazily.
>>>>   
>>>>     
>>>>         
>>> I guess it would be pretty rude/unlikely for these opcodes to get reused
>>> in other implementations...  But couldn't you make the page trap
>>> instead, rather than relying on an instruction fault?
>>>   
>>>       
>> The whole point of using the instruction is to allow hypercalls to be 
>> used in many locations.  This has the nice side effect of not requiring 
>> a central hypercall initialization routine in the guest to fetch the 
>> hypercall page.  A PV driver can be completely independent of any other 
>> code provided that it restricts itself to it's hypercall namespace.
>>     
>
> But if the instruction is architecture dependent, and you run on the
> wrong architecture, now you have to patch many locations at fault time,
> introducing some nasty runtime code / data cache overlap performance
> problems.  Granted, they go away eventually.
>   

We're addressing that by blowing away the shadow cache and holding the 
big kvm lock to ensure SMP safety.  Not a great thing to do from a 
performance perspective but the whole point of patching is that the cost 
is amortized.

> I prefer the idea of a hypercall page, but not a central initialization.
> Rather, a decentralized approach where PV drivers can detect using CPUID
> which hypervisor is present, and a common MSR shared by all hypervisors
> that provides the location of the hypercall page.
>   

So then each module creates a hypercall page using this magic MSR and 
the hypervisor has to keep track of it so that it can appropriately 
change the page on migration.  The page can only contain a single 
instruction or else it cannot be easily changed (or you have to be able 
to prevent the guest from being migrated while in the hypercall page).

We're really talking about identical models.  Instead of an MSR, the #GP 
is what tells the hypervisor to update the instruction.  The nice thing 
about this is that you don't have to keep track of all the current 
hypercall page locations in the hypervisor.

Regards,

Anthony Liguori

> Zach
>
>
>   

