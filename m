Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbXEDPK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbXEDPK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEDPK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:10:57 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51666 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755291AbXEDPK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:10:56 -0400
Message-ID: <463B4C5C.1000507@vmware.com>
Date: Fri, 04 May 2007 08:08:12 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Petr Vandrovec <petr@vmware.com>, nigel@nigel.suspend2.net,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
References: <1177998147.8981.16.camel@nigel.suspend2.net>	<1178031475.3448.0.camel@laptopd505.fenrus.org>	<1178032456.13953.12.camel@nigel.suspend2.net>	<46385A18.30804@vmware.com> <m1slacu88z.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1slacu88z.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I don't even want to think about how a kernel module gets far enough
> into the kernel to be affected by our vector layout.  These are internal
> implementation details, without anything exported to modules.
>
> Can I please see the source of the code in vmware that is doing this?
>   

Sorry, that code is not part of the kernel or any kernel module.  It is 
part of a fixed set of assumptions about the platform coded in the 
hypervisor, which is not open source.  This code runs completely outside 
the scope of Linux, and uses a platform dependent set of IDT software 
vectors which are known not to collide with IDT IRQ vectors.  We use 
these software vectors for internal purposes; they are never visible to 
any Linux software, but are handled and trapped by the hypervisor.  
Nevertheless, since we must distinguish between software IRQs and 
hardware IRQs, we must find vectors that do not collide with the set of 
hardware IRQs or processor exceptions.

To avoid this dependence on fixed assumtions about vector layout, what 
is needed is a mechanism to reserve and allocate software IDT vectors.  
It may be a GPL'd interface; it certainly is interfacing with the kernel 
at a low-level.

An interface that would likely looking something like:

int idt_allocate_swirq(int best_irq);
void idt_release_swirq(int irq);
int __init idt_reserve_irqs(int count);
void idt_set_swirq_handler (int irq, int is_user, void (*handle)(struct 
pt_regs *regs, unsigned long error_code));
EXPORT_SYMBOL_GPL(idt_allocate_swirq);
EXPORT_SYMBOL_GPL(idt_release_swirq);
EXPORT_SYMBOL_GPL(idt_set_swirq_handler);

Now you can set aside a fixed number of IRQs to be used for software 
IRQs at boot time, and allocate them as required.  You can even create 
software IRQs which can be handled by userspace applications, or reserve 
software IRQs for other uses - from within the kernel itself, or from 
outside any kernel context (for example an IPI invoked from a non-kernel 
CPU).  There are cases where this would be a useful feature for us; 
being able to issue IPIs directly to a hypervisor mode CPU would be a 
significant speedup (alternatively, having a kernel module handle the 
IPI when the CPU is in kernel mode and schedule the vmx process to run 
and forward the IPI).

The thought of running non-kernel code in ring-0 on some CPU is scary, 
certainly.  Nevertheless it is required for running a hypervisor which 
does not live in the kernel address space and must handle its own page 
faults and other exceptions.

Zach
