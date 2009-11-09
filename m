Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZKIHpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZKIHpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZKIHpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:45:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:37193 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZKIHps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:45:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BavfJPP0ss2mgcW0n2I/ZmqMg6C3NRD32IuFnxbuVKtjYwrq9Xh777jWFiNBYo+/yz
         y1F8ODbw5yUVAV3mvmyO6yt0/6y2EH+Uy+4+ssFlW14Ue9NMYk3vYLE3xHyu5l0ubY/K
         Kue6FpfvR7Nw5iasa53NEtPAl3WBNBLDWG2SI=
MIME-Version: 1.0
Date: Mon, 9 Nov 2009 13:15:54 +0530
Message-ID: <6d53329e0911082345o60d5b37m936e2a7138a230b@mail.gmail.com>
Subject: MIPS + Kernel unaligned instruction access issue in 2.6.23 kernel
From: venki kaps <venkiece2005@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       linux-mips@vger.kernel.org, nubi@linux-mips.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been tracing kernel system call information using the my own
Kprobes implementation in the 2.6.23 kernel on MIPS architecture.
I have been facing one issue while running my own kprobe tests.

For instance, when I am planting kprobe at ‘’’sys_call_table’’’
(arch/mips/kernel/scall32-o32.S) while unregister of probe, Kernel
panic is getting generated.
But I do not have any issues with other system calls which are present
in scall32-o32.S expect ‘’’sys_call_table’’’.

The following is debugging snapshot-

•	/ # unaligned.c: in do_ade
•	unaligned.c: in do_ade
•	do_ade: regs->cp0_badvaddr = 13 regs->cp0_epc = 2147741016
regs->cp0_epc & 0x1 = 0
•	emulate_load_store_insn : lw_op
•	res
•	unaligned.c: in do_ade
•	do_ade: regs->cp0_badvaddr = 17 regs->cp0_epc = 2147741024
regs->cp0_epc & 0x1 = 0
•	emulate_load_store_insn : lw_op
•	res
•	do_ade: regs->cp0_badvaddr = 13 regs->cp0_epc = 13 regs->cp0_epc & 0x1 = 1
•	do_ade: regs->cp0_badvaddr == regs->cp0_epc) || (regs->cp0_epc & 0x1
•	Kernel unaligned instruction access[#1]:
•	Cpu 0
•	$ 0   : 00000000 fffffff8 00000000 2abf972c
•	$ 4   : 00001021 0047a540 00000480 0000002d
•	$ 8   : 00000000 c0000008 0000000d 0000000c
•	$12   : 7fb46cd0 0047d830 004214a8 004752b8
•	$16   : 7fb46ef8 00000001 7fb46e28 00000480
•	$20   : 00000000 00000002 004f3008 004f5908
•	$24   : 00000000 2abf971c
•	$28   : 87d0a000 87d0bf30 7fb46d48 8002b0f0
•	Hi    : 00000351
•	Lo    : 002f4a35
•	epc   : 0000000d 0xc     Not tainted
•	ra    : 8002b0f0 stack_done+0x20/0x3c
•	Status: 30048403    KERNEL EXL IE
•	Cause : 10000010
•	BadVA : 0000000d
•	PrId  : 00002d30
•	Modules linked in: kprobe_sys_call_table
•	Process rmmod (pid: 55, threadinfo=87d0a000, task=807c7120)
•	Stack : 004f5608 004f5348 004f3008 00000000 0047d830 004214a8
004752b8 00000000
•	        00000fa0 00000004 00001021 0047a540 00000480 0000002d
2ab1a2e4 00000000
•	        2aac6000 2aad6520 0000003d 0000003f 0000003a 00426c48
7fb46ef8 00000001
•	        7fb46e28 00000480 00000000 00000002 004f3008 004f5908
00000273 2abf971c
•	        0000002d 00000000 2ac87950 7fb46cb0 7fb46d48 00426c48
20048413 00000351
•	        ...
•	Call Trace:
•	
•	
•	Code: (Bad address in epc)
•	
•	Fatal exception: panic in 5 seconds
•	Kernel panic - not syncing: Fatal exception

Generally we used to get the above error when system call is not
aligned on 32 bit boundary.
But in my case, ‘’’sys_call_table’’’ is .align 3.

MIPS cpuinfo:
=======
system type             : Toshiba RBTX4927/RBTX4937
processor               : 0
cpu model               : TX49xx V3.0  FPU V3.0
BogoMIPS                : 299.00
wait instruction        : yes
microsecond timers      : yes
tlb_entries             : 48

Queries:
=====
1. Are there any unaligned instructions in MIPS (Toshiba RBTX4927/RBTX4937)?
2. Is it my MIPS kprobe implementation problem?
3. May I know the tracing flow to resolve these types of issues?


Please give your valuable comments.

Thanks in advance.

Best regards,
Venkappa
