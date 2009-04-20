Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZDTNZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZDTNZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbZDTNYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:24:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33689 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbZDTNYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:24:51 -0400
Message-ID: <49EC7797.7060004@redhat.com>
Date: Mon, 20 Apr 2009 15:24:39 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com>
In-Reply-To: <49EC6DEE.4070703@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/09 14:43, Avi Kivity wrote:
> Gerd Hoffmann wrote:
>>> That said, I'd like to be able to emulate the Xen HVM hypercalls. But in
>>> any case, they hypercall implementation has to be in the kernel,
>>
>> No. With Xenner the xen hypercall emulation code lives in guest
>> address space.
>
> In this case the guest ring-0 code should trap the #GP, and install the
> hypercall page (which uses sysenter/syscall?). No kvm or qemu changes
> needed.

Doesn't fly.

Reason #1: In the pv-on-hvm case the guest runs on ring0.
Reason #2: Chicken-egg issue:  For the pv-on-hvm case only few,
            simple hypercalls are needed.  The code to handle them
            is small enougth that it can be loaded directly into the
            hypercall page(s).

pure-pv doesn't need it in the first place.  But, yes, there I could 
simply trap #GP because the guest kernel runs on ring #1 (or #3 on 64bit).

>>> Especially if we need to support
>>> tricky bits like continuations.
>>
>> Is there any reason to? I *think* xen does it for better scheduling
>> latency. But with xen emulation sitting in guest address space we can
>> schedule the guest at will anyway.
>
> It also improves latency within the guest itself. At least I think that
> what was the Hyper-V spec is saying. You can interrupt the execution of
> a long hypercall, inject and interrupt, and resume. Sort of like a
> rep/movs instruction, which the cpu can and will interrupt.

Hmm.  Needs investigation..  I'd expect the main source of latencies is 
page table walking.  Xen works very different from kvm+xenner here ...

> For Xenner, no (and you don't need to intercept the msr at all),  but for
> pv-on-hvm, you do need to update the code.

Xenner handling pv-on-hvm doesn't need code updates either.  Real Xen 
does as it uses vmcall, not sure how they handle migration.

cheers
   Gerd
