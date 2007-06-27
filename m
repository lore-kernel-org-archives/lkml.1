Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbXF0PbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbXF0PbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXF0PbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:31:17 -0400
Received: from science.horizon.com ([192.35.100.1]:16717 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752978AbXF0PbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:31:16 -0400
Date: 27 Jun 2007 11:31:14 -0400
Message-ID: <20070627153114.17953.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org, linux-laptop@vger.kernel.org
Subject: 2.6.22-rcX Transmeta/APM regression
Cc: hpa@zytor.com, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware: Fujitsu Lifebook P-2040, TM5800 800 MHz processor
2.6.21: Closing the lid causes APM suspend.  Opening it resumes just fine.
2.6.22-rc5/-rc6: On resume, backlight comes on, but system is otherwise
	frozen.  Nothing happens until I hold the power button to force
	a power off.

I'm trying to bisect, but there's a large range of commits which crash
on boot in init_transmeta, which is slowing me down.

However, I did manage to find a kernel version that gives an error
message instead of a blank screen, which might be useful.  I can even
switch VTs and type into the shell afterwards, but actually trying to do
anything hangs.  Which includes anything like run a command to capture
this to a file or another machine on the network, even if I took care
to cache the necessary executables and libraries before suspending.

So the following is transcribed by hand.

general protection fault: 0000 [#1]
Modules linked in:
CPU:    0
EIP:    0060:[<c0108c59>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-gba7cc09c #16)
EIP is at get_fixed_ranges+0x9/0x60
eax: c0338d24   ebx: c03589a0   ecx: 00000250   edx: 00000000
esi: c0338d24   edi: 0000000a   ebp: 00000000   esp: cefa4f5c
ds: 007b   es: 007b   fs: 0000  gs: 000   ss: 0068
Process kapmd (pid: 70, ti=cefa4000 task=cef89550 task.ti=cefa4000)
Stack: c03589a0 c010b1a0 c0238e4d c010b1a0 0000000a 00000000 c010addf c010b1a0
       0000000a 00000000 c010b5f1 cefa4fc4 cefa4fc0 cefa4fbc cefa4fb8 cefa4fb8
       00000001 e45a3b0f 00000000 cef89550 c0110f20 c02f53e4 c02f5e34 c010b1a0
Call Trace:
 [<c010b1a0>] apm+0x0/0x500
 [<c0238e4d>] __save_process_rstate+0xd/0x50
 [<c010b1a0>] apm+0x0/0x500
 [<c010addf>] suspend+0x1f/0xb0
 [<c010b1a0>] apm+0x0/0x500
 [<c010b5f1>] apm+0x451/0x500
 [<c0110f20>] default_wake_function+0x0/0x10
 [<c010b1a0>] apm+0x0/0x500
 [<c010b1a0>] apm+0x0/0x500
 [<c01217f9>] kthread+0x39/0x60
 [<c01217c0>] kthread+0x0/0x60
 [<c0102fe7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 46 83 c7 04 39 ee 0f 8c 40 ff ff ff 83 c4 3c 31 c0 5b 5e 5f 5d c3 90 90 90
 90 90 90 90 90 90 90 90 90 56 b9 50 02 00 00 53 89 c6 <0f> 32 89 06 89 d0 b1 58
 31 d2 89 46 04 0f 32 89 46 08 89 d0 b1
EIP: [<c0108c59>] get_fixed_ranges+0x9/0x60 SS:ESP 0068:cefa4f5c


The init_transmeta crash looks like the following:

Calibrating delay using timer specific routine.. 1630.69 BogoMIPS (lpj=8153474)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 512K (128 bytes/line)
CPU: Processor revision 1.4.1.0, 800 MHz
CPU: Code Morphing Software revision 4.2.6-8-168
CPU: 20010703 00:29 official release 4.2.6#2
general protection fault: 0000 [#1]
Modules linked in:
CPU:     0
EIP:     0060:[<c03142f5>]   Not tainted VLI
EFLAGS: 00010286   (2.6.21-g1e7371c1 #18)
EIP is at init_transmeta+0x1d5/0x230
eax: ffffffff   ebx: 00000000   ecx: 80860004   edx: ffffffff
esi: ffffffff   edi: 00000000   ebp: 80860004   esp: c030fed0
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process swapper (pid: 0, ti=c030f000 task=c02ed280 task.ti=c030f000)
Stack: c02b5c52 c030ff1b 00000002 00000006 00000008 000000a8 cefc2600 00000246
       00000000 00000000 c030d2e0 00000320 00000020 00000000 00000000 c01b553f
       00000000 00000000 32000000 30313030 20333037 323a3030 666f2039 69636966	/* "20010703 00:29 offici" */
Call Trace:
 [<c01b553f>] idr_get_new_above_int+0x10f/0x1f0
 [<c0312eee>] identify_cpu+0x20e/0x370
 [<c01b562d>] idr_get_new+0xd/0x30
 [<c0173e10>] proc_register+0x30/0xe0
 [<c031307d>] identify_boot_cpu+0xd/0x20
 [<c0313318>] check_bugs+0x8/0x100
 [<c03109a3>] start_kernel+0x203/0x210
 [<c0310420>] unknown_bootoption+0x0/0x210
 =======================
Code: 00 c6 84 24 8b 00 00 00 00 89 7c 24 04 c7 04 24 52 5c 2b c0 ed 8d fc df ff
 bd 04 00 86 80 89 e9 0f 32 89 c6 93 c8 ff 89 d7 89 c2 <0f> 30 31 c9 b8 01 00 00
 00 0f a2 8b 44 24 28 89 e9 89 50 0c b8
EIP: [<c03142f5>] init_transmeta+0x1d5/0x230 SS:ESP 0068:c030fed0
Kernel panic - not syncing: Attempted to kill the idle task!
