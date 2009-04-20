Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZDTMnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZDTMnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbZDTMnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:43:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34165 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbZDTMni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:43:38 -0400
Message-ID: <49EC6DEE.4070703@redhat.com>
Date: Mon, 20 Apr 2009 15:43:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com>
In-Reply-To: <49EC68A7.8080403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
>> That said, I'd like to be able to emulate the Xen HVM hypercalls. But in
>> any case, they hypercall implementation has to be in the kernel,
>
> No.  With Xenner the xen hypercall emulation code lives in guest 
> address space.

In this case the guest ring-0 code should trap the #GP, and install the 
hypercall page (which uses sysenter/syscall?).  No kvm or qemu changes 
needed.

>> Especially if we need to support
>> tricky bits like continuations.
>
> Is there any reason to?  I *think* xen does it for better scheduling 
> latency.  But with xen emulation sitting in guest address space we can 
> schedule the guest at will anyway.

It also improves latency within the guest itself.  At least I think that 
what was the Hyper-V spec is saying.  You can interrupt the execution of 
a long hypercall, inject and interrupt, and resume.  Sort of like a 
rep/movs instruction, which the cpu can and will interrupt.

>>> Same MSR, multiple writes (page number in the low bits).
>>
>> Nasty. The hypervisor has to remember all of the pages, so it can update
>> them for live migration.
>
> Xenner doesn't need update-on-migration, so there is no need at all to 
> remember this.  At the end of the day it is just memcpy(guest, data, 
> PAGESIZE) triggered by wrmsr. 

For Xenner, no (and you don't need to intercept the msr at all), but for 
pv-on-hvm, you do need to update the code.

-- 
error compiling committee.c: too many arguments to function

