Return-Path: <linux-kernel-owner+w=401wt.eu-S1750797AbXCaJLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797AbXCaJLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 05:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXCaJLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 05:11:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39177 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbXCaJLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 05:11:21 -0400
Date: Sat, 31 Mar 2007 11:11:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: 2.6.21-rc5-mm3
Message-ID: <20070331091102.GA31622@elte.hu>
References: <20070330103958.16b738aa.akpm@linux-foundation.org> <200703302131.23469.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703302131.23469.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> >  [<c01040d6>] ret_from_fork+0x6/0x1c
> 
> Hmpf. I saw it once in child_rip here too. Then I wanted to reproduce 
> it to report properly and couldn't again. I had a few other backtraces 
> that were all non stuck with child_rip then on essentially the same 
> kernel. Something weird is going on.

find below a colorful unwinder crash, on an i386 UNWIND_STACK + 
FRAME_POINTERS kernel. It crashed on the context-> dereference:

                /* Should be after the line below, but somewhere
                   in early boot context comes out corrupted and we
                   can't reference it -AK */
                if (ops->stack(data, "IRQ") < 0)
                        break;
                stack = (unsigned long*)context->previous_esp;
                if (!stack)
                        break;

the comment suggests that such a crash isnt without precedence, but my 
crash wasnt during early bootup, it was on a working system.

	Ingo

-------------->
 [<c0106442>] dump_trace+0x78/0x210
 [<c010660f>] show_trace_log_lvl+0x35/0x54
 [<c0106a77>] show_trace+0x2c/0x2e
 [<c0106aa2>] dump_stack+0x29/0x2b
 [<c01637fa>] check_critical_timing+0x26a/0x37e
 [<c0163e7f>] time_hardirqs_on+0xac/0xc2
 [<c014d385>] trace_hardirqs_on+0x16b/0x172
 [<c010533a>] restore_nocheck+0x12/0x15
 [<c02a007b>] acpi_rs_get_address_common+0x63/0x71
 [<c06bc000>] init_thread_union+0x0/0x1000
DWARF2 unwinder stuck at init_thread_union+0x0/0x1000
Leftover inexact backtrace:
BUG: unable to handle kernel paging request at virtual address 70252034
 printing eip:
c0106592
*pde = 00000000
stopped custom tracer.
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in:
CPU:    0
EIP:    0060:[<c0106592>]    Not tainted VLI
EFLAGS: 00010046   (2.6.21-rc5-rt6 #83)
EIP is at dump_trace+0x1c8/0x210
eax: 00000000   ebx: c06bce10   ecx: fffd85a4   edx: c064728c
esi: 70252000   edi: 70252070   ebp: c06bce10   esp: c06bcda4
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068  preempt:00000002
Process swapper (pid: 0, ti=c06bc000 task=c0645280 task.ti=c06bc000)
Stack: c055faad c059b2f4 c06bc000 00000000 c02ae350 00000000 00000000 00000000 
       00000000 c4b83528 0000007b 0000007b 00000000 00000000 c06bc000 00000060 
       00000000 c0645288 00000068 c0645280 0835b643 c064728c c055faad c011c8f4 
Call Trace:
 [<c010660f>] show_trace_log_lvl+0x35/0x54
 [<c0106a77>] show_trace+0x2c/0x2e
 [<c0106aa2>] dump_stack+0x29/0x2b
 [<c01637fa>] check_critical_timing+0x26a/0x37e
 [<c0163e7f>] time_hardirqs_on+0xac/0xc2
 [<c014d385>] trace_hardirqs_on+0x16b/0x172
 [<c010533a>] restore_nocheck+0x12/0x15
 [<c02a007b>] acpi_rs_get_address_common+0x63/0x71
 [<c06bc000>] init_thread_union+0x0/0x1000
DWARF2 unwinder stuck at init_thread_union+0x0/0x1000
Leftover inexact backtrace:
BUG: unable to handle kernel paging request at virtual address 70252034
 printing eip:
c0106592
*pde = 00000000
Oops: 0000 [#2]
PREEMPT SMP 
Modules linked in:
CPU:    0
EIP:    0060:[<c0106592>]    Not tainted VLI
EFLAGS: 00010046   (2.6.21-rc5-rt6 #83)
EIP is at dump_trace+0x1c8/0x210
eax: 00000000   ebx: c06bcc34   ecx: fffd85b7   edx: c064728c
esi: 70252000   edi: 70252070   ebp: c06bcc34   esp: c06bcbc8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068  preempt:00000002
Process swapper (pid: 0, ti=c06bc000 task=c0645280 task.ti=c06bc000)
Stack: c0550554 c059b2f4 c06bc000 00000000 c02ae350 00000000 00000000 00000000 
       00000000 c4b83528 c064007b fffd007b c06400d8 ffffffff c06bc000 00000060 
       00010046 c0645288 00000068 c0645280 00000019 c064728c c0550554 c011c8f4 
Call Trace:
 [<c010660f>] show_trace_log_lvl+0x35/0x54
 [<c01066db>] show_stack_log_lvl+0xad/0xc5
 [<c010691a>] show_registers+0x227/0x31d
 [<c0106d37>] die+0x137/0x21d
 [<c0487550>] do_page_fault+0x4c1/0x5a8
 [<c048585c>] error_code+0x7c/0x84
 [<c0106592>] dump_trace+0x1c8/0x210
 [<c010660f>] show_trace_log_lvl+0x35/0x54
 [<c0106a77>] show_trace+0x2c/0x2e
 [<c0106aa2>] dump_stack+0x29/0x2b
 [<c01637fa>] check_critical_timing+0x26a/0x37e
 [<c0163e7f>] time_hardirqs_on+0xac/0xc2
 [<c014d385>] trace_hardirqs_on+0x16b/0x172
 [<c010533a>] restore_nocheck+0x12/0x15
 [<c02a007b>] acpi_rs_get_address_common+0x63/0x71
 [<c06bc000>] init_thread_union+0x0/0x1000
DWARF2 unwinder stuck at init_thread_union+0x0/0x1000
