Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZDTNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZDTNpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZDTNpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:45:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbZDTNpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:45:15 -0400
Message-ID: <49EC7C5F.2000006@redhat.com>
Date: Mon, 20 Apr 2009 16:45:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add MCE support to KVM
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com> <49EC7797.7060004@redhat.com>
In-Reply-To: <49EC7797.7060004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> On 04/20/09 14:43, Avi Kivity wrote:
>> Gerd Hoffmann wrote:
>>>> That said, I'd like to be able to emulate the Xen HVM hypercalls. 
>>>> But in
>>>> any case, they hypercall implementation has to be in the kernel,
>>>
>>> No. With Xenner the xen hypercall emulation code lives in guest
>>> address space.
>>
>> In this case the guest ring-0 code should trap the #GP, and install the
>> hypercall page (which uses sysenter/syscall?). No kvm or qemu changes
>> needed.
>
> Doesn't fly.
>
> Reason #1: In the pv-on-hvm case the guest runs on ring0.

Sure, in this case you need to trap the MSR in the kernel (or qemu).  
But the handler is no longer in the guest address space, and you do need 
to update the opcode.

Let's not confuse the two cases.

> Reason #2: Chicken-egg issue:  For the pv-on-hvm case only few,
>            simple hypercalls are needed.  The code to handle them
>            is small enougth that it can be loaded directly into the
>            hypercall page(s).

Please elaborate.  What hypercalls are so simple that an exit into the 
hypervisor is not necessary?

>>> Is there any reason to? I *think* xen does it for better scheduling
>>> latency. But with xen emulation sitting in guest address space we can
>>> schedule the guest at will anyway.
>>
>> It also improves latency within the guest itself. At least I think that
>> what was the Hyper-V spec is saying. You can interrupt the execution of
>> a long hypercall, inject and interrupt, and resume. Sort of like a
>> rep/movs instruction, which the cpu can and will interrupt.
>
> Hmm.  Needs investigation..  I'd expect the main source of latencies 
> is page table walking.  Xen works very different from kvm+xenner here ...

kvm is mostly O(1).  We need to limit rmap chains, but we're fairly 
close.  The kvm paravirt mmu calls are not O(1), but we can easily use 
continuations there (and they're disabled on newer processors anyway).

Another area that worries me is virtio notification, which can take a 
long time.  It won't be trivial, but we can make work:

- for the existing pio-to-userspace notification, add a bit that tells 
the kernel to repeat the instruction instead of continuing.  the 'outl' 
instruction is idempotent, so we can do partial work, and return to the 
kernel.
- if using hypercallfd/piofd to a pipe, we're offloading everything to 
another thread anyway, so we can return immediately
- if using hypercallfd/piofd to a kernel virtio server, it can return 0 
bytes written, indicating it needs a retry.  kvm can try to inject an 
interrupt if it sees this.


-- 
error compiling committee.c: too many arguments to function

