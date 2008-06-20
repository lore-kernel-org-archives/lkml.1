Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbYFTRZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbYFTRZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYFTRZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:25:36 -0400
Received: from gw.goop.org ([64.81.55.164]:58816 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYFTRZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:25:35 -0400
Message-ID: <485BE80E.10209@goop.org>
Date: Fri, 20 Jun 2008 10:25:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>
In-Reply-To: <485BDB04.4090709@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Mike Travis wrote:
>>     
>>> @@ -132,6 +133,12 @@ ident_complete:
>>>  #ifdef CONFIG_SMP
>>>      addq    %rbp, trampoline_level4_pgt + 0(%rip)
>>>      addq    %rbp, trampoline_level4_pgt + (511*8)(%rip)
>>> +
>>> +    /*
>>> +     * Fix up per_cpu__gdt_page offset when basing percpu
>>> +     * variables at zero.  This is only needed for the boot cpu.
>>> +     */
>>> +    addq    $__per_cpu_load, early_gdt_descr_base
>>>   
>>>       
>> This needs to be rip-relative.  An absolute reference here will fail
>> because you're still running in physical addresses.
>>
>>    J
>>     
>
> Still bombs right at boot up... ;-(
>   

Yep.  I see the triple-fault at the "mov %eax,%ds", which means it's 
having trouble with the gdt.  Either 1) the lgdt pointed to a bad 
address, or 2) there's something wrong with the descriptor there.

The dump is:

(XEN) hvm.c:767:d14 Triple fault on VCPU0 - invoking HVM system reset.
(XEN) ----[ Xen-3.3-unstable  x86_64  debug=n  Not tainted ]----
(XEN) CPU:    0
(XEN) RIP:    0010:[<ffffffff80200167>]
(XEN) RFLAGS: 0000000000010002   CONTEXT: hvm
(XEN) rax: 0000000000000018   rbx: 0000000000000000   rcx: ffffffff808d6000
(XEN) rdx: 0000000000000000   rsi: 0000000000092f40   rdi: 0000000020100800
(XEN) rbp: 0000000000000000   rsp: ffffffff80827ff8   r8:  0000000000208000
(XEN) r9:  0000000000000000   r10: 0000000000000000   r11: 00000000000000d8
(XEN) r12: 0000000000000000   r13: 0000000000000000   r14: 0000000000000000
(XEN) r15: 0000000000000000   cr0: 0000000080050033   cr4: 00000000000000a0
(XEN) cr3: 0000000000201000   cr2: 0000000000000000
(XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: 0000   cs: 0010


I loaded early_gdt_descr+2 into %rcx, which looks reasonable.  Hm, but 
loading the __KERNEL_DS descriptor into %rdx, which is all zero.

So it seems the problem is that the pre-initialized gdt_page is being 
lost and replaced with zero.  Linker script bug?

    J

--- a/arch/x86/kernel/head_64.S	Fri Jun 20 09:50:02 2008 -0700
+++ b/arch/x86/kernel/head_64.S	Fri Jun 20 10:19:20 2008 -0700
@@ -213,6 +213,8 @@
 	 * because in 32bit we couldn't load a 64bit linear address.
 	 */
 	lgdt	early_gdt_descr(%rip)
+	movq	early_gdt_descr+2(%rip), %rcx
+	movq	__KERNEL_DS(%rcx), %rdx
 
 	/* set up data segments. actually 0 would do too */
 	movl $__KERNEL_DS,%eax


