Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbXFTBXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbXFTBXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757825AbXFTBX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:23:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:5081 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102AbXFTBX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:23:27 -0400
Message-ID: <46788188.1040403@codemonkey.ws>
Date: Tue, 19 Jun 2007 20:23:20 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mbligh@google.com
Subject: Re: Problem with global_flush_tlb() on i386 in 2.6.22-rc4-mm2
References: <20070619170914.GA30623@Krystal>
In-Reply-To: <20070619170914.GA30623@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hi,
> 
> Trying to test my "Text Edit Lock" patches, I ran into a problem related
> to global_flush_tlb() not doing its job at updating the page flags when,
> it seems, the page has been recently accessed. Therefore, it can only be
> reproduced by doing a couple of iterations.
> 
> I run on a Pentium 4 with the following characteristics:
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 4
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 1
> cpu MHz         : 3000.201
> cache size      : 1024 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl cid xtpr
> bogomips        : 6007.49
> clflush size    : 64
> 
> config :
> CONFIG_X86_INVLPG=y (complete .config at the end)
> CONFIG_PARAVIRT=y/n
> 
> 
> (notice that pge and clflush features are present)
> 
> The kernel is configured in UP (I first saw the problem in SMT, but
> switched to UP and it is still there).
> 
> I provide a really crude hackish test module that shows the problematic
> behavior below.
> 
> Whenever I run the module using global_flush_tlb(), I get the following
> OOPS:
> 
> 
> [ 1112.512389] Init Attr RX
> [ 1112.521691] Init Attr RX end
> [ 1113.702965] Loop 0
> [ 1113.709171] Attr RWX 621545
> [ 1113.717662] Attr RX 621545
> [ 1113.725869] Attr RWX 432917
> [ 1113.734295] Attr RX 432917
> [ 1113.742460] Attr RWX 973425
> [ 1113.750885] Attr RX 973425
> [ 1113.759048] Attr RWX 453890
> [ 1113.767490] Attr RX 453890
> [ 1113.775653] Attr RWX 1035918
> [ 1113.784341] Attr RX 1035918
> [ 1113.792764] Attr RWX 1038276
> [ 1113.801449] Attr RX 1038276
> [ 1113.809902] Attr RWX 71394
> [ 1113.818067] Attr RX 71394
> [ 1113.825970] Attr RWX 88253
> [ 1113.834134] Attr RX 88253
> [ 1113.842039] Attr RWX 108029
> [ 1113.850505] Attr RX 108029
> [ 1113.858670] Attr RWX 767772
> [ 1113.867095] Attr RX 767772
> [ 1113.875259] Attr RWX 251394
> [ 1113.883694] Attr RX 251394
> [ 1113.891859] Attr RWX 817582
> [ 1113.900376] Attr RX 817582
> [ 1113.908540] Attr RWX 577819
> [ 1113.916965] Attr RX 577819
> [ 1113.925127] Attr RWX 56979
> [ 1113.933293] Attr RX 56979
> [ 1113.941195] Attr RWX 72953
> [ 1113.949361] Attr RX 72953
> [ 1113.957265] Attr RWX 94222
> [ 1113.965445] BUG: unable to handle kernel paging request at virtual address c3a1700e
> [ 1113.988291]  printing eip:
> [ 1113.996340] f885e0a6
> [ 1114.002835] *pde = 038c6163
> [ 1114.011145] *pte = 03a17163
> [ 1114.019455] Oops: 0003 [#1]
> [ 1114.027766] PREEMPT 
> [ 1114.034268] LTT NESTING LEVEL : 0 
> [ 1114.044402] Modules linked in: test_rodata ltt_statedump ltt_control sky2 skge rtc snd_hda_intel
> [ 1114.070679] CPU:    0
> [ 1114.070680] EIP:    0060:[<f885e0a6>]    Not tainted VLI
> [ 1114.070681] EFLAGS: 00010282   (2.6.22-rc4-mm2-testssmp #129)
> [ 1114.110395] EIP is at my_open+0xa6/0x124 [test_rodata]
> [ 1114.125711] eax: c3a00000   ebx: 0001700e   ecx: c39e4000   edx: 00000000
> [ 1114.145953] esi: 36f1700e   edi: f885e000   ebp: c39e5ebc   esp: c39e5ea0
> [ 1114.166195] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> [ 1114.183583] Process cat (pid: 4112, ti=c39e4000 task=c38ac1b0 task.ti=c39e4000)
> [ 1114.204862] Stack: f885e223 0001700e 00000000 0000f000 c31d3480 00000000 f885e000 c39e5ed8 
> [ 1114.229843]        c01a3c2a c39d2540 c368d4a8 c39d2540 00000000 c368d4a8 c39e5ef8 c016f5d9 
> [ 1114.254830]        c1c0eec0 c378ccfc c39e5eec c39d2540 00008000 c39e5f1c c39e5f0c c016f76b 
> [ 1114.279814] Call Trace:
> [ 1114.287620]  [<c01a3c2a>] proc_reg_open+0x42/0x68
> [ 1114.301655]  [<c016f5d9>] __dentry_open+0xe6/0x1e2
> [ 1114.315944]  [<c016f76b>] nameidata_to_filp+0x35/0x3f
> [ 1114.331008]  [<c016f7b0>] do_filp_open+0x3b/0x43
> [ 1114.344777]  [<c016f7fb>] do_sys_open+0x43/0x116
> [ 1114.358545]  [<c016f906>] sys_open+0x1c/0x1e
> [ 1114.371274]  [<c0104128>] syscall_call+0x7/0xb
> [ 1114.384524]  [<ffffe410>] 0xffffe410
> [ 1114.395178]  =======================
> [ 1114.405823] INFO: lockdep is turned off.
> [ 1114.417504] Code: 60 df 7c c0 b9 63 01 00 00 ba 01 00 00 00 e8 3f 7d 8b c7 0f ae f0 89 f6 e8 5c 80 8b c7 0f ae f0 89 f6 a1 88 eb 85 f8 0f b6 55 f0 <88> 14 03 0f ae f0 89 f6 89 d8 03 05 88 eb 85 f8 05 00 00 00 40 
> [ 1114.474329] EIP: [<f885e0a6>] my_open+0xa6/0x124 [test_rodata] SS:ESP 0068:c39e5ea0
> [ 1114.497187] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> [ 1114.520025] in_atomic():0, irqs_disabled():1
> [ 1114.532744] INFO: lockdep is turned off.
> [ 1114.544427] irq event stamp: 1894
> [ 1114.554293] hardirqs last  enabled at (1893): [<c03c892b>] _spin_unlock_irq+0x22/0x4e
> [ 1114.577666] hardirqs last disabled at (1894): [<c03c8584>] _spin_lock_irqsave+0x25/0x61
> [ 1114.601556] softirqs last  enabled at (1886): [<c0122988>] __do_softirq+0xe1/0x184
> [ 1114.624149] softirqs last disabled at (1875): [<c0122a9d>] do_softirq+0x72/0x77
> [ 1114.645969]  [<c01051bc>] dump_trace+0x1d5/0x204
> [ 1114.659737]  [<c0105205>] show_trace_log_lvl+0x1a/0x30
> [ 1114.675060]  [<c0105fc2>] show_trace+0x12/0x14
> [ 1114.688308]  [<c0105fd9>] dump_stack+0x15/0x17
> [ 1114.701557]  [<c0118dbf>] __might_sleep+0xcf/0xe1
> [ 1114.715584]  [<c013273c>] down_read+0x18/0x4b
> [ 1114.728574]  [<c011f4a0>] exit_mm+0x27/0xd1
> [ 1114.741045]  [<c0120bc1>] do_exit+0x10f/0x88f
> [ 1114.754035]  [<c01058ef>] do_trap+0x0/0x152
> [ 1114.766503]  [<c0115553>] do_page_fault+0x310/0x7ed
> [ 1114.781050]  [<c03c8bda>] error_code+0x6a/0x70
> [ 1114.794303]  [<f885e0a6>] my_open+0xa6/0x124 [test_rodata]
> [ 1114.810665]  [<c01a3c2a>] proc_reg_open+0x42/0x68
> [ 1114.824692]  [<c016f5d9>] __dentry_open+0xe6/0x1e2
> [ 1114.838979]  [<c016f76b>] nameidata_to_filp+0x35/0x3f
> [ 1114.854044]  [<c016f7b0>] do_filp_open+0x3b/0x43
> [ 1114.867811]  [<c016f7fb>] do_sys_open+0x43/0x116
> [ 1114.881579]  [<c016f906>] sys_open+0x1c/0x1e
> [ 1114.894308]  [<c0104128>] syscall_call+0x7/0xb
> [ 1114.907557]  [<ffffe410>] 0xffffe410
> [ 1114.918212]  =======================
> 
> This is clearly the memory write I am trying to do in the page of
> which I just changed the attributes to RWX.
> 
> If I remove the variable read before I change the flags, it starts
> working correctly (as far as I have tested...).
> 
> If I use my own my_local_tlb_flush() function (not SMP aware) instead of
> global_flush_tlb(), it works correctly.
> 

What is your my_local_tlb_flush() and are you calling with preemption 
disabled?

> I also tried just calling clflush on the modified page just after the
> global_flush_tlb(), and the problem was still there.
> 
> I therefore suspect that
> 
> include/asm-i386/tlbflush.h:
> #define __native_flush_tlb_global()                                     \
>         do {                                                            \
>                 unsigned int tmpreg, cr4, cr4_orig;                     \
>                                                                         \
>                 __asm__ __volatile__(                                   \
>                         "movl %%cr4, %2;  # turn off PGE     \n"        \
>                         "movl %2, %1;                        \n"        \
>                         "andl %3, %1;                        \n"        \
>                         "movl %1, %%cr4;                     \n"        \
>                         "movl %%cr3, %0;                     \n"        \
>                         "movl %0, %%cr3;  # flush TLB        \n"        \
>                         "movl %2, %%cr4;  # turn PGE back on \n"        \
>                         : "=&r" (tmpreg), "=&r" (cr4), "=&r" (cr4_orig) \
>                         : "i" (~X86_CR4_PGE)                            \
>                         : "memory");                                    \
>         } while (0)
> 
> is not doing its job correctly. The problem does not seem to be caused
> by PARAVIRT, because it is still buggy even if I disable the PARAVIRT
> config option.

This is actually very conservative seeing as how disabling CR4.PGE 
should be sufficient to flush global pages on modern processors.  I 
suspect you're getting preempted while it's running.

Regards,

Anthony Liguori
