Return-Path: <linux-kernel-owner+w=401wt.eu-S1423019AbXEDUTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423019AbXEDUTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161531AbXEDUTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:19:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42191 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161584AbXEDUTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:19:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zachary Amsden <zach@vmware.com>
Cc: Petr Vandrovec <petr@vmware.com>, nigel@nigel.suspend2.net,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
References: <1177998147.8981.16.camel@nigel.suspend2.net>
	<1178031475.3448.0.camel@laptopd505.fenrus.org>
	<1178032456.13953.12.camel@nigel.suspend2.net>
	<46385A18.30804@vmware.com> <m1slacu88z.fsf@ebiederm.dsl.xmission.com>
	<463B4C5C.1000507@vmware.com>
Date: Fri, 04 May 2007 14:14:41 -0600
In-Reply-To: <463B4C5C.1000507@vmware.com> (Zachary Amsden's message of "Fri,
	04 May 2007 08:08:12 -0700")
Message-ID: <m13b2cpcr2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden <zach@vmware.com> writes:

> Eric W. Biederman wrote:
>> I don't even want to think about how a kernel module gets far enough
>> into the kernel to be affected by our vector layout.  These are internal
>> implementation details, without anything exported to modules.
>>
>> Can I please see the source of the code in vmware that is doing this?
>>
>
> Sorry, that code is not part of the kernel or any kernel module.  It is part of
> a fixed set of assumptions about the platform coded in the hypervisor, which is
> not open source.  This code runs completely outside the scope of Linux, and uses
> a platform dependent set of IDT software vectors which are known not to collide
> with IDT IRQ vectors.

Is this linux running on vmware or vmware running on linux?

> We use these software vectors for internal purposes; they
> are never visible to any Linux software, but are handled and trapped by the
> hypervisor.  Nevertheless, since we must distinguish between software IRQs and
> hardware IRQs, we must find vectors that do not collide with the set of hardware
> IRQs or processor exceptions.

This sounds like playing with fire.  Although I suppose you could do it generally
by making software irqs trigger a general protection fault.

> To avoid this dependence on fixed assumtions about vector layout, what is needed
> is a mechanism to reserve and allocate software IDT vectors.  It may be a GPL'd
> interface; it certainly is interfacing with the kernel at a low-level.
>
> An interface that would likely looking something like:
>
> int idt_allocate_swirq(int best_irq);
> void idt_release_swirq(int irq);
> int __init idt_reserve_irqs(int count);
> void idt_set_swirq_handler (int irq, int is_user, void (*handle)(struct pt_regs
> *regs, unsigned long error_code));
> EXPORT_SYMBOL_GPL(idt_allocate_swirq);
> EXPORT_SYMBOL_GPL(idt_release_swirq);
> EXPORT_SYMBOL_GPL(idt_set_swirq_handler);

What we currently have is: 
int assign_irq_vector(int irq, cpumask_t);

It has a number of interesting properties such as you can change
the vector assignment at runtime, and we can migrate the irq
between cpus.

None of this is accessible as a module because we don't have any irq
controllers that it makes sense to write as modules.  There is to much
platform magic involved to have portable irq controller code and not
really any point in it.

> Now you can set aside a fixed number of IRQs to be used for software IRQs at
> boot time, and allocate them as required.  You can even create software IRQs
> which can be handled by userspace applications, or reserve software IRQs for
> other uses - from within the kernel itself, or from outside any kernel context
> (for example an IPI invoked from a non-kernel CPU).  There are cases where this
> would be a useful feature for us; being able to issue IPIs directly to a
> hypervisor mode CPU would be a significant speedup (alternatively, having a
> kernel module handle the IPI when the CPU is in kernel mode and schedule the vmx
> process to run and forward the IPI).

That is pretty much the architecture we have to support msi.  Although
irq != vector not even at a fixed offset.

> The thought of running non-kernel code in ring-0 on some CPU is scary,
> certainly.  Nevertheless it is required for running a hypervisor which does not
> live in the kernel address space and must handle its own page faults and other
> exceptions.

Yep.  Untrusted binary blobs in ring-0 are very scary.

Eric
