Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYIYO4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYIYO4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYIYO4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:56:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:45982 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYIYO4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QriPdcyqqhOentVVMR6FJW/VOy8kpomT9yPdAm9KYkukU/ESvMHWZ0tbFNnhdQ+dCB
         zvwle4UnVFkkRoq+P/CKD7i/B6yHitGCBup5XurnAaQARe7+LsApwa8s5MMBp8xH2gy9
         FYWgzErfuMl63Ml+vmA7B/I0YhQQICeLbGDps=
Date: Thu, 25 Sep 2008 18:56:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tej <bewith.tej@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel PANIC with 2.6.27-rc6
Message-ID: <20080925145635.GA7277@localhost>
References: <f1c9d250809110841s5c3d08b9ha93f0ef1da58642a@mail.gmail.com> <48C94F65.3050405@windriver.com> <f1c9d250809250735i4b98201ft753d6ec2959097e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c9d250809250735i4b98201ft753d6ec2959097e6@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Tej - Thu, Sep 25, 2008 at 08:05:23PM +0530]
| On 9/11/08, Jason Wessel <jason.wessel@windriver.com> wrote:
| > Tej wrote:
| >> observed a panic on 2.6.27-rc6 caused by  enabling
| >> "CONFIG_KGDB_TESTS_ON_BOOT" option
| >>
| >> panic logged using serial console and .config are attached.
| >>
| >> Linux version 2.6.27-rc6 (root@luser-desktop) (gcc version 4.2.3
| > (Ubuntu 4.2.3-8
| > [clip]
| >> kgdb: Registered I/O driver kgdbts.
| >> kgdbts:RUN plant and detach test
| >> kgdbts:RUN sw breakpoint test
| >> kgdbts:RUN bad memory access test
| >> kgdbts:RUN singlestep test 1000 iterations
| >> kgdbts:RUN singlestep [0/1000]
| >> kgdbts:RUN singlestep [100/1000]
| >> kgdbts: BP mismatch c0109c02 expected c02ad250
| >
| >
| >
| > So if we break this down into what it means, the kgdb test got an
| > exception and stopped somewhere other than where it placed the
| > breakpoint.  In this case 0xc0109c02 which you can see right after the
| > text "BP mismatch".
| 
| i have obsvered this  bug from 2.6.27-rc1 to rc7
| however the 2.6.26 was fine
| 
| 
| >
| > This address is in your stack trace below (read on)
| 
| >
| >
| >> ------------[ cut here ]------------
| >> WARNING: at drivers/misc/kgdbts.c:302 check_and_rewind_pc+0xb2/0xe0()
| >> Modules linked in:
| >> Pid: 0, comm: swapper Not tainted 2.6.27-rc6 #16
| >>  [<c0125d04>] warn_on_slowpath+0x54/0x70
| >>  [<c01260f0>] ? __call_console_drivers+0x60/0x70
| >>  [<c013c15b>] ? up+0x2b/0x40
| >>  [<c0126634>] ? release_console_sem+0x1a4/0x1c0
| >>  [<c01548f7>] ? __rmqueue_smallest+0xb7/0x130
| >>  [<c02445e7>] ? __copy_to_user_ll+0x57/0x60
| >>  [<c0153dc0>] ? probe_kernel_write+0x20/0x40
| >>  [<c02ad250>] ? kgdbts_break_test+0x0/0x30
| >>  [<c0126bab>] ? printk+0x1b/0x20
| >>  [<c02ad250>] ? kgdbts_break_test+0x0/0x30
| >>  [<c02adfb2>] check_and_rewind_pc+0xb2/0xe0
| >>  [<c0109c02>] ? mwait_idle+0x32/0x40
| >
| >
| > So if you were to do:
| > gdb ./vmlinux
| > i line *0xc0109c02
| >
| > It will print the line of source that caused the problem.  It is
| > probably the case that this is a victim however, as this looks like
| > some kind of nmi race condition.
| >
| > Perhaps you could confirm this?
| 
| ok so i did git bisection which pointed:-
| 
| commit 3ed3f06295e69700fa808396f7b350bff2b69de0
| Author: Cyrill Gorcunov <gorcunov@gmail.com>
| Date:   Wed Jun 4 01:00:47 2008 +0400
| 
|     x86: nmi - consolidate nmi_watchdog_default for 32bit mode
| 
|     64bit mode bootstrap code does set nmi_watchdog to NMI_NONE
|     by default and doing the same on 32bit mode is safe too.
|     Such an action saves us from several #ifdef.
| 
| 
| 
| git -bisection log.
| 
| git-bisect start
| # bad: [6e86841d05f371b5b9b86ce76c02aaee83352298] Linux 2.6.27-rc1
| git-bisect bad 6e86841d05f371b5b9b86ce76c02aaee83352298
| # good: [bce7f793daec3e65ec5c5705d2457b81fe7b5725] Linux 2.6.26
| git-bisect good bce7f793daec3e65ec5c5705d2457b81fe7b5725
| # bad: [d20b27478d6ccf7c4c8de4f09db2bdbaec82a6c0] V4L/DVB (8415):
| gspca: Infinite loop in i2c_w() of etoms.
| git-bisect bad d20b27478d6ccf7c4c8de4f09db2bdbaec82a6c0
| # bad: [666484f0250db2e016948d63b3ef33e202e3b8d0] Merge branch
| 'core/softirq' of
| git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
| git-bisect bad 666484f0250db2e016948d63b3ef33e202e3b8d0
| # bad: [d59fdcf2ac501de99c3dfb452af5e254d4342886] Merge commit
| 'v2.6.26' into x86/core
| git-bisect bad d59fdcf2ac501de99c3dfb452af5e254d4342886
| # good: [3de352bbd86f890dd0c5e1c09a6a1b0b29e0f8ce] Merge branch
| 'x86/mpparse' into x86/devel
| git-bisect good 3de352bbd86f890dd0c5e1c09a6a1b0b29e0f8ce
| # bad: [b4df32f4aeef8794d0135fc8dc250acb44cfee60] x86: fix warning in
| e820_reserve_resources with 32bit
| git-bisect bad b4df32f4aeef8794d0135fc8dc250acb44cfee60
| # bad: [7f0be02c5ed1deb04c54c6a17f412e04f417df11] x86: move
| boot_params declaring to setup.c
| git-bisect bad 7f0be02c5ed1deb04c54c6a17f412e04f417df11
| # bad: [4b62ac9a2b859f932afd5625362c927111b7dd9b] Merge branch
| 'x86/nmi' into x86/devel
| git-bisect bad 4b62ac9a2b859f932afd5625362c927111b7dd9b
| # bad: [f781b03c4b1c713ac000877c8bbc31fc4164a29b] x86:
| touch_nmi_watchdog(): reset alert counters for supported nmi_watchdog
| modes only
| git-bisect bad f781b03c4b1c713ac000877c8bbc31fc4164a29b
| # good: [96f9dcb10755e96eae706b9e869c0dc25adb3d74] x86: nmi_64.c - use
| for_each_possible_cpu helper
| git-bisect good 96f9dcb10755e96eae706b9e869c0dc25adb3d74
| # good: [ba3a5974239293d921235e6fa82b09b670e674ef] - fix typo in
| include/asm-x86/nmi.h
| git-bisect good ba3a5974239293d921235e6fa82b09b670e674ef
| # bad: [3ed3f06295e69700fa808396f7b350bff2b69de0] x86: nmi -
| consolidate nmi_watchdog_default for 32bit mode
| git-bisect bad 3ed3f06295e69700fa808396f7b350bff2b69de0
| # good: [3d1ba1da2b4ff4ace7801e99fb9a3095b182d847] x86: fix nmi.c build bug
| git-bisect good 3d1ba1da2b4ff4ace7801e99fb9a3095b182d847
| 
| 
| One more point, this bug i have observed on intel VT machine, on
| non-VT machine i couldn't able to trigger this bug.
| 
| cat /proc/cpuinfo | grep vmx
| 
| flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
| pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
| constant_tsc pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr
| lahf_lm
| flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
| pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
| constant_tsc pni monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr
| lahf_lm
| 
| HTH
| 
| 
| 
| 
| 
| 
| 
| >
| > My guess would rougly be arch/x86/kernel/processs.c
| >
| > 170         __monitor((void *)&current_thread_info()->flags, 0, 0);
| >
| > And perhaps this is a deference error, or it will be an even less
| > obvious problem where the return from the nmi kgdb uses to sync the
| > processors has created some kind of invalid context.  This may or may
| > not be a direct problem with kgdb, but nothing in this area had really
| > changed since the 2.6.26 kernel.
| >
| > Unfortunately I could not reproduce the problem.  If you consistently
| > see this with each boot, but you do not see it on the 2.6.27 rc1 or
| > 2.6.26 released kernel for instance, it is definitely worth bisecting,
| > as the problem was caused elsewhere in the kernel.
| >
| >>  [<c02ad250>] ? kgdbts_break_test+0x0/0x30
| >>  [<c02acdd1>] validate_simple_test+0x21/0xb0
| >>  [<c02ad5a7>] run_simple_test+0x107/0x260
| >>  [<c0153e00>] ? probe_kernel_read+0x20/0x40
| >>  [<c02acec4>] kgdbts_put_char+0x14/0x20
| >>  [<c014aa36>] put_packet+0x86/0xe0
| >>  [<c014b650>] kgdb_handle_exception+0x2f0/0xd90
| >>  [<c0114cc8>] kgdb_notify+0x58/0x180
| >>  [<c013c33d>] notifier_call_chain+0x2d/0x60
| >>  [<c013c38c>] __atomic_notifier_call_chain+0x1c/0x30
| >>  [<c013c3ba>] atomic_notifier_call_chain+0x1a/0x20
| >>  [<c013c44d>] notify_die+0x2d/0x30
| >>  [<c01056ca>] die_nmi+0x3a/0x100
| >>  [<c0112697>] nmi_watchdog_tick+0x187/0x190
| >>  [<c0106067>] do_nmi+0x87/0x2a0
| >>  [<c04d5a73>] nmi_stack_correct+0x26/0x2b
| >>  [<c011007b>] ? msr_seek+0xb/0x80
| >>  [<c0109c02>] ? mwait_idle+0x32/0x40
| >>  [<c01026c5>] cpu_idle+0x55/0xf0
| >>  [<c04ae02e>] rest_init+0x4e/0x60
| >>  [<c069794f>] start_kernel+0x23f/0x2c0
| >>  [<c0697270>] ? unknown_bootoption+0x0/0x210
| >>  [<c0697077>] __init_begin+0x77/0xb0
| >
| >
| > Jason.
| >
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
| 

Thanks for feedback, Tej! Will check this commit.

		- Cyrill -
