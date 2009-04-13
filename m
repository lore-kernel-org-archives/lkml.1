Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbZDMNCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbZDMNCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 09:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZDMNC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 09:02:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZDMNC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 09:02:26 -0400
Message-ID: <49E337D7.5050502@redhat.com>
Date: Mon, 13 Apr 2009 16:02:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Sat, 2009-04-11 at 20:04 +0800, Avi Kivity wrote:
>   
>>>> Why not always allocate it on vcpu setup?
>>>>     
>>>>         
>>> Because the MCE bank number is not fixed, it is based on mcg_cap from
>>> user space.
>>>   
>>>       
>> Right, but we can allocate the maximum number, no?  it's a fairly small 
>> amount of memory.
>>     
>
> OK. If you are OK with 8k extra memory usage.
>   

Let's make it 64 banks like Andi suggests.  Return the number in the 
KVM_CHECK_EXTENSION call (we do the same for memory slots) so userspace 
can adjust.

>>
>> kvm does feature negotiation (really, feature advertising) using 
>> KVM_CAP_... and KVM_CHECK_EXTENSION.  So there's no need for this.
>>     
>
> It is not only feature advertising, but also something like CPUID. Based
> on CPU type specified in command line (qemu -cpu ?), different mcg_cap
> can be used to determine number of MCE banks and various features of MCE
> (MCG_CTL_P, MCG_TES_P, MCG_CMCI, etc) for specified CPU type. With KVM
> feature advertising, we can only check whether MCE simulation is
> supported, but can not set parameters of MCE simulation.
>
> Maybe this interface can be changed to KVM_SET_MSRS, with
> MSR_IA32_MCG_CAP be set by kvm-qemu. But MSR_IA32_MCG_CAP is read-only
> by spec, and current interface can not distinguishes between MSR set
> from guest system and MSR setup from kvm-qemu. I think there should be
> other read-only MSRs need to be setup during guest system
> creation/setup. How about add a interface such as KVM_SETUP_MSRS to
> setup the value of read-only MSRs?
>   

Then we would need to tell which read-only MSRs are setup writeable and 
which aren't...

I'm okay with an ioctl to setup MCE, but just make sure userspace has 
all the information to know what the kernel can do rather than the 
try-and-see-if-it-works approach.  We can publish this information via 
KVM_CAP things, or via another ioctl (see KVM_GET_SUPPORTED_CPUID2 for 
an example).

-- 
error compiling committee.c: too many arguments to function

