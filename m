Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbZDSNGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbZDSNGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZDSNGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:06:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034AbZDSNGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:06:24 -0400
Message-ID: <49EB2190.2020503@redhat.com>
Date: Sun, 19 Apr 2009 16:05:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: sen wang <wangsen.linux@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, kvm-devel <kvm@vger.kernel.org>
Subject: Re: port kvm to arm
References: <454c71700904180641p764d13afyd42c753c37bda2cf@mail.gmail.com>	 <alpine.LFD.2.00.0904181202030.4042@localhost.localdomain>	 <49EAE219.5040002@redhat.com> <454c71700904190518o66a286f6s5425c177cdb7b048@mail.gmail.com>
In-Reply-To: <454c71700904190518o66a286f6s5425c177cdb7b048@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(copying kvm@vger.kernel.org, where most kvm development happens)

sen wang wrote:
> I have some idea about the ARM KVM.
>
> I have register a project ,named"arm-kvm", to port KVM to arm.
> I'll kick off the ARM KVM porting next week.
>
> This is my plan:
>
> step 1   Make a guest linux run on the Hypervisor-linux.
>
> From the Hypervisor-linux's viewpoint, The guest is a thread of him. 
> which is like the X86 KVM.But,In this step,the guest-linux has no IO. 
> It is based on roofs. The physical memroy is allocated to the guest os 
> at creating time. The guest-linux still run in the privileged 
> mode,which handle the user mode memory exeception ,SWI system call ... 
> But the guest-linux will not touch the hardware devices.The physical 
> interrupt should be controlled by Hypervisor-linux. So the 
> Hypervisor-linux can switch it off when interrupt happens. And the 
> Hypervisor-linux will provide some vitual system devices like system 
> timer and interrupt controller for guest.
>
> Because lack of hardware support,The guest linux should know when to 
> exit,for exemple the idle time,the kernel panic, the guest should 
> voluntarily exit VM --which is like a thread switch.
>
> so there is another job: modification of Hypervisor-linux to support 
> arm,and modification of qemu for arm KVM

You'll can hook read[bwl]() and similar functions to use hypercalls, 
which will allow you to use emulated devices in qemu, even without  full 
mmu virtualization.

>
> step 2   Make guest IO work
>
> The guest should have IO functions.Of course, IT is the virtIO. we 
> should make the virtIO work on the arm kvm.The arm has no hardware 
> virtualization extension like intel VT. But,In the guest virtIO 
> driver, when need start IO,the guest should voluntarily exit VM--so it 
> like IO-exit of the intel VT.

If you make emulated devices work, then you can defer this to the last 
step.  virtio is only an optimization.

>
>
> step 3   add memory virtualization for guest
>
> just make the guest run in the user mode，porting the x86 kvm memory 
> virtualization function for arm kvm,and so on. But I think we should 
> keep the work mode of step 1 as a option for user. sometime, I think 
> the guest handle the physical memory directly is not a bad thing.
>
>
> step 4   use the trustzone
>
> from arm V6, there is a hardware extension of trustzone. We can make 
> use of it. let the Hypervisor-linux run int the monitor state,the 
> guest run in the non-security state. But,the guest os run as 
> normal--linux kernel in the privileged mode,the user program in the 
> user mode.So architecture is more elegant.

Does the monitor state have its own userspace?  If not, how are you 
going to run qemu?

>
> step5   more guest os
> the work mode of step 1 has the advantage: we don't need modify the 
> guest much,which make port wince,symbain possible. for, you know,we 
> don't have so much source codes for those os.
>
> welcome join the "arm-kvm" team. thanks

Good luck :)

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

