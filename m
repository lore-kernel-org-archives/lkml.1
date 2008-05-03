Return-Path: <linux-kernel-owner+w=401wt.eu-S1764345AbYECKe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764345AbYECKe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbYECKdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:33:04 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:22874 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYECKdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:sender;
        b=r8lPQy3fMBLpY6hRo4PumV7Eg9/LH9wjV6pHXDvtDiQnwVq6xTysk4BBqL0lQC8vn2KJi7BPchXDzwxB+cAZZ8ClxwebSpjD7f7v+6sMcHvJf+MGK8g9Oxw6apQYMuS+NVx2WLDGXjaUfjjEPXQLhwRtXza8D+CdHolTb0xRa1E=
Subject: i387/FPU init issues...
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 03 May 2008 06:32:54 -0400
Message-Id: <1209810775.6972.37.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peoplez,

Ive narrowed down a problem i am having with an old P2 to commit
61c4628b538608c1a85211ed8438136adfeb9a95 with subject "x86, fpu: split
FPU state from task struct - v5" (Authored by Suresh and committed by
Ingo on Apr/19).

In the process i learnt how painfully time consuming and boring a blind
git bisect feast could be (the last time a kernel worked on the P2 was
back in 2.6.23). I literally spent no less than 10 hours tracking this
(Ok, I was chewing tobbaco in between running git bisect bad/good,
compile, copy over kernel, spit here, reboot, test).
Also this patch is so huge that given my lack of knowledge in the area,
i couldnt do better bisecting to be more exact on what is causing this.
i.e the patch is not bisect-friendly. 
So the best i can do is have other people take it from here.

I am able to reproduce the issue consistently on my laptop using qemu
(which helped speed debugging a bit). I have also narrowed it down to
include/asm-x86/i387.h::__save_init_fpu in (32 bit version) - it dies
somewhere in calling the following line:

----
        alternative_input(
                "fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
                "fxsave %[fx]\n"
                "bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
                X86_FEATURE_FXSR,
                [fx] "m" (tsk->thread.xstate->fxsave),
                [fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
----------

The only thing that has changed there compared to good version is the
last two lines. But that looks sane to me given the struct naming has
changed. So i am suspecting the calling path perhaps not setting
something or other.

------------ boot output paste ----------------------
[....]
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium II (Klamath) stepping 03
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
invalid opcode: 0000 [#1]
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.25-00000-g61c4628 #22)
EIP: 0060:[<c01012d0>] EFLAGS: 00000202 CPU: 0
EIP is at prepare_to_copy+0x20/0x50
EAX: c1101880 EBX: fffffff4 ECX: c04eff80 EDX: c04bb3e0
ESI: c04bb3e0 EDI: c04eff80 EBP: c04efeb0 ESP: c04efeb0
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c04ee000 task=c04bb3e0 task.ti=c04ee000)
Stack: c04eff0c c01183a0 00000000 c0543566 00000000 c04eff84 00000296
c04effa4
       c04eff80 00000000 00800b00 00000001 c04eff5c 00000296 c0543565
c0543544
       00000026 c04effb4 00000296 c04effd4 00000000 00800b00 c04eff80
c04eff64
Call Trace:
 [<c01183a0>] ? copy_process+0x60/0x10d0
 [<c0119504>] ? do_fork+0x54/0x210
 [<c01355cc>] ? lock_release_holdtime+0x6c/0x70
 [<c04f0000>] ? __init_begin+0x0/0x69
 [<c010fe5d>] ? change_page_attr_set_clr+0xcd/0x1e0
 [<c0101996>] ? kernel_thread+0x86/0xa0
 [<c04f0710>] ? kernel_init+0x0/0x270
 [<c04f0710>] ? kernel_init+0x0/0x270
 [<c0103260>] ? kernel_thread_helper+0x0/0x10
 [<c03bb874>] ? rest_init+0x14/0x50
 [<c04f0b7a>] ? start_kernel+0x1fa/0x280
 [<c04f03f0>] ? unknown_bootoption+0x0/0x210
 [<c04f02b8>] ? i386_start_kernel+0x8/0x10
 =======================
Code: 8d 74 26 00 8d bc 27 00 00 00 00 55 89 c2 8b 40 04 89 e5 f6 40 0c
01 74 32 8b 82 60 02 00 00 0f ae 00 0f ba 60 02 07 73 02 db e2 <0f> 1f
00 90 8d b4 26 00 00 00 00 89 f6 8b 42 04 83 60 0c fe 0f
EIP: [<c01012d0>] prepare_to_copy+0x20/0x50 SS:ESP 0068:c04efeb0
---[ end trace ca143223eefdc828 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
------------------------------------------------------------------------

Remedy:
I am able to get the system to boot fine if i passed an option to tell
it there is no i387 and compile in math emulation (but then a few of
standard programs start segfaulting on me and i dont wanna go chasing
that).

Let me know what you want me to try out since i can do this on my laptop
now.

cheers,
jamal

