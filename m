Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXLTVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXLTVJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXLTVJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:09:11 -0500
Received: from gw.goop.org ([64.81.55.164]:56544 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbXLTVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:09:09 -0500
Message-ID: <476AD9EA.7010108@goop.org>
Date: Thu, 20 Dec 2007 13:08:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
References: <20071219223534.129042140@goop.org> <20071220094940.GA14227@elte.hu> <20071220112022.GA15832@elte.hu>
In-Reply-To: <20071220112022.GA15832@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>> Here's another round of the pagetable unification patches.  I've 
>>> done a few dozen rounds of randconfig builds on both 32- and 64-bit, 
>>> so I hope that will prevent compile problems in your test 
>>> environment.
>>>
>>> I've also boot-tested 64-bit and 32-bit PAE/non-PAE configs (both 
>>> paravirt and non-paravirt).
>>>       
>> i've done a dozen random tests too and it's looking good so far. Nice 
>> work!
>>     
>
> found a couple of bugs.
>
> firstly, 64-bit wasnt so lucky, you broke iounmap()/change_page_attr()
> :-)
>   

Crap.  Worked for me.  I'll look into it.

> The crash is here:
>
> [    0.000000] PCI: Calling quirk ffffffff804625d0 for 0000:00:02.0
> [    0.000000] PCI: Calling quirk ffffffff80565b10 for 0000:00:02.0
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] kernel BUG at arch/x86/mm/pageattr_64.c:176!
> [    0.000000] invalid opcode: 0000 [1] SMP 
> [    0.000000] CPU 1 
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 1, comm: swapper Not tainted 2.6.24-rc5 #5
> [    0.000000] RIP: 0010:[<ffffffff802229b9>]  [<ffffffff802229b9>] __change_page_attr+0x189/0x2e0
> [    0.000000] RSP: 0018:ffff81003f9c3d30  EFLAGS: 00010282
> [    0.000000] RAX: 0000000000000400 RBX: 00000000000da103 RCX: ffffe20000000370
> [    0.000000] RDX: 000000000000006e RSI: 00003ffffffff000 RDI: ffff81000000a000
> [    0.000000] RBP: ffff81003f9c3d90 R08: 80000000da0001e3 R09: 0000000000000001
> [    0.000000] R10: 0000000000000001 R11: 00000000ffffffff R12: ffff81000000a680
> [    0.000000] R13: 0000000000000001 R14: 8000000000000163 R15: ffff8100da103000
> [    0.000000] FS:  0000000000000000(0000) GS:ffff81003f8014b0(0000) knlGS:0000000000000000
> [    0.000000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    0.000000] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> [    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.000000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.000000] Process swapper (pid: 1, threadinfo ffff81003f9c2000, task ffff81003f9c0000)
> [    0.000000] Stack:  ffff8100da102000 8000000000000163 8000000000000163 0000000000000000
> [    0.000000]  ffffffff809320e0 ffff8100da102000 ffff81003f9c3d70 00000000000da103
> [    0.000000]  ffff8100da103000 0000000000000001 8000000000000163 0000000000000000
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff80222bb6>] change_page_attr_addr+0xa6/0x150
> [    0.000000]  [<ffffffff8022243b>] ioremap_change_attr+0x5b/0x70
> [    0.000000]  [<ffffffff8022265f>] iounmap+0xbf/0xe0
> [    0.000000]  [<ffffffff80565e23>] quirk_usb_early_handoff+0x313/0x410
> [    0.000000]  [<ffffffff8044a109>] kobject_put+0x19/0x20
> [    0.000000]  [<ffffffff804a45d5>] put_device+0x15/0x20
> [    0.000000]  [<ffffffff804611bd>] pci_fixup_device+0x8d/0xe0
> [    0.000000]  [<ffffffff8045f53d>] pci_init+0x1d/0x40
> [    0.000000]  [<ffffffff80a04794>] kernel_init+0x164/0x350
> [    0.000000]  [<ffffffff8025cd9f>] trace_hardirqs_on+0xbf/0x160
> [    0.000000]  [<ffffffff806fc824>] trace_hardirqs_on_thunk+0x35/0x3a
> [    0.000000]  [<ffffffff8025cd9f>] trace_hardirqs_on+0xbf/0x160
> [    0.000000]  [<ffffffff8020cba8>] child_rip+0xa/0x12
> [    0.000000]  [<ffffffff8020c2bf>] restore_args+0x0/0x30
> [    0.000000]  [<ffffffff80a04630>] kernel_init+0x0/0x350
> [    0.000000]  [<ffffffff8020cb9e>] child_rip+0x0/0x12
> [    0.000000] 
> [    0.000000] 
> [    0.000000] Code: 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 48 b8 7f 0f 
> [    0.000000] RIP  [<ffffffff802229b9>] __change_page_attr+0x189/0x2e0
> [    0.000000]  RSP <ffff81003f9c3d30>
> [    0.000000] Kernel panic - not syncing: Attempted to kill init!
>
> secondly, as i tried to bisect it, it would build and boot at this 
> patch:
>
>   Subject: x86: clean up asm-x86/page*.h
>
> but wouldnt build at this patch:
>
>   Subject: x86: unify pgtable*.h
>
> nor at this patch:
>
>   Subject: x86: fix up formatting in pgtable*.h
>
> it finally built at:
>
>   Subject: x86: use a uniform structure for pte_t
>
> but crashed. So the bug is in one of those 3 patches. Please make them 
> bisect-friendly.
>   

Hm, I tried to.

> full bootlog and config attached. (The crash happens reliably here - if 
> you cannot reproduce it then i can try any fix from you. I've removed 
> the 5 patches of yours for now from x86.git.)
>   

OK.  Will beat on this some more.  Unfortunately I can only test 64-bit
stuff under kvm, and I'm a little bit skeptical of how solid it is,
since i get sporadic random oopses even with base x86.git.  But a nice
simple repeatable BUG_ON should be easy to fix regardless.

    J
