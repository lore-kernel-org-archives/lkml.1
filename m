Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYFRRhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYFRRhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYFRRhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:37:25 -0400
Received: from gw.goop.org ([64.81.55.164]:40414 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYFRRhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:37:23 -0400
Message-ID: <485947A8.8060801@goop.org>
Date: Wed, 18 Jun 2008 10:36:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>
In-Reply-To: <484EF29C.7080100@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>   
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>     
>>>   * Declare the pda as a per cpu variable.
>>>
>>>   * Make the x86_64 per cpu area start at zero.
>>>
>>>   * Since the pda is now the first element of the per_cpu area, cpu_pda()
>>>     is no longer needed and per_cpu() can be used instead.  This also makes
>>>     the _cpu_pda[] table obsolete.
>>>
>>>   * Since %gs is pointing to the pda, it will then also point to the per cpu
>>>     variables and can be accessed thusly:
>>>
>>> 	%gs:[&per_cpu_xxxx - __per_cpu_start]
>>>
>>> Based on linux-2.6.tip
>>>       
>> -tip testing found an instantaneous reboot crash on 64-bit x86, with 
>> this config:
>>
>>   http://redhat.com/~mingo/misc/config-Thu_Jun__5_11_43_51_CEST_2008.bad
>>     
>
> I'm still stuck on this one.  One new development is that the current -tip
> branch without the patches boots to the kernel prompt then hangs after a few
> moments and then reboots.  It seems you can tickle it using ^C to abort a
> process.

Hi Mike,

I added some instrumentation to Xen to print the cpu state on 
triple-fault, which highlights an obvious-looking problem.

(XEN) hvm.c:767:d1 Triple fault on VCPU0 - invoking HVM system reset.
(XEN) ----[ Xen-3.3-unstable  x86_64  debug=y  Not tainted ]----
(XEN) CPU:    1
(XEN) RIP:    0010:[<ffffffff80200160>]
(XEN) RFLAGS: 0000000000010002   CONTEXT: hvm
(XEN) rax: 0000000000000018   rbx: 0000000000000000   rcx: 00000000c0000080
(XEN) rdx: 0000000000000000   rsi: 0000000000092f40   rdi: 0000000020100800
(XEN) rbp: 0000000000000000   rsp: ffffffff807dfff8   r8:  0000000000208000
(XEN) r9:  0000000000000000   r10: 0000000000000000   r11: 00000000000000de
(XEN) r12: 0000000000000000   r13: 0000000000000000   r14: 0000000000000000
(XEN) r15: 0000000000000000   cr0: 0000000080050033   cr4: 00000000000000a0
(XEN) cr3: 0000000000201000   cr2: 0000000000000000
(XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: 0000   cs: 0010

The rip is:

(gdb) x/i 0xffffffff80200160
0xffffffff80200160 <secondary_startup_64+96>:	movl   %eax,%ds

which is:

	lgdt	early_gdt_descr(%rip)

	/* set up data segments. actually 0 would do too */
	movl $__KERNEL_DS,%eax
	movl %eax,%ds
	movl %eax,%ss
	movl %eax,%es

And early_gdt_descr is:

	.globl early_gdt_descr
early_gdt_descr:
	.word	GDT_ENTRIES*8-1
	.quad   per_cpu__gdt_page

and per_cpu__gdt_page is zero-based, and therefore not a directly 
addressable symbol.

I tried this patch, but it didn't work.  Perhaps I'm missing something.

diff -r bf5a46e13f78 arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S	Tue Jun 17 22:10:51 2008 -0700
+++ b/arch/x86/kernel/head_64.S	Wed Jun 18 10:34:24 2008 -0700
@@ -94,6 +94,8 @@
 
 	addq	%rbp, level2_fixmap_pgt + (506*8)(%rip)
 
+	addq	$__per_cpu_load, early_gdt_descr+2(%rip)
+	
 	/* Add an Identity mapping if I am above 1G */
 	leaq	_text(%rip), %rdi
 	andq	$PMD_PAGE_MASK, %rdi


    J
