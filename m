Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbYFSVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbYFSVh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYFSVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:36:38 -0400
Received: from gw.goop.org ([64.81.55.164]:47852 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbYFSVgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:36:36 -0400
Message-ID: <485AD138.4010404@goop.org>
Date: Thu, 19 Jun 2008 14:35:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>
In-Reply-To: <485ACD92.8050109@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Oh yeah, is it alright to re-use the pda in the static percpu load area
> for each startup cpu, or should it be adjusted to use the areas allocated
> by setup_per_cpu_areas()?  pda_init() is called in x86_64_start_kernel
> so it would only be for anything that occurs before then.  (And I moved
> the call to pda_init() to before the early_idt_handlers are setup.)
>   

Why not use the real pda for all cpus?

Do you move the boot-cpu's per-cpu data? (Please don't)  If not, you can 
just use percpu__pda from the start without having to do anything else, 
and then set up %gs pointing to the pda base for each secondary cpu.

64-bit inherits 32-bit's use of per-cpu gdts, though its mostly useless 
on 64-bit.

More important is to have a:

startup_percpu_base:	.quad	__per_cpu_load

which you stick the processor's initial %gs into, and then load that 
from in startup_secondary_64:

	mov	$X86_MSR_GSBASE, %ecx
	mov	startup_percpu_base, %eax
	mov	startup_percpu_base+4, %edx
	wrmsr

and put

	startup_percpu_base = new_cpus_percpu_base;

in do_cpu_boot().

> I hadn't realized that this code is executed for cpus other than the
> boot cpu.  Is there a way to find out if this is the boot cpu (and/or
> the initial execution)?
>   

Don't think so.  If you want something to happen only at boot time, do 
it in startup_64.

> If it's the boot cpu, then this would work for the gdt, yes?
>
>         leaq    early_gdt_descr_base(%rip), %edi
>         movq    0(%edi), %rax
>         addq    $__per_cpu_load, %rax
>         movq    %rax, 0(%edi)
>         lgdt    early_gdt_descr(%rip)
>   

As I mentioned in my other mail, a simple add should be enough.

> But it should only be executed for the boot because do_boot_cpu()
> does this:
>
>         early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
>
> static inline struct desc_struct *get_cpu_gdt_table(unsigned int cpu)
> {
>         return per_cpu(gdt_page, cpu).gdt;
> }
>   

Right, do it in startup_64.

> Btw, I've only been testing on an x86_64 system.  I'm sure I've got
> things to fix up for i386.
>   

It should be possible to share almost everything, at least in C.

    J
