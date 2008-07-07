Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYGGRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYGGRa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYGGRaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:30:19 -0400
Received: from mail.in-ulm.de ([217.10.8.10]:39861 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753684AbYGGRaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:30:18 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 13:30:17 EDT
Date: Mon, 7 Jul 2008 19:23:34 +0200
From: Christian Ehrhardt <lk@c--e.de>
To: linux-kernel@vger.kernel.org
Subject: Boot failures on Qemu due to P6_NOPS
Message-ID: <20080707172334.GH1009@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

this might well be a bug in Qemu but even then, it would be nice if the
linux kernel could do a work around.

I tried to boot a current git kernel (around 2.6.26-rc8) on qemu and
got the an invalid opcode oops on boot (full oops data below).

The illegal instruction is 0x0f 0x1f 0x00 aka P6_NOP3.

I have verified that this opcode gets patched in because
apply_alternatives() or more precisely add_nops() uses P6 nops
on this CPU type while padding after patching in an fxsave
instruction. More precisely the code that oopses is:

   fxsave (%eax)
   btl    $0x7,0x2(%eax)
   jae    0x804833e <main+26>
   fnclex 
   nopl   (%eax)      <==== Faulting instruction

P6 nops are used when patching because init_intel() sets X86_FEATURE_P3 for
family 6 CPUs and X86_FEATURE_P3 in turn enables the P6 NOPS.

The Qemu CPU identifies itself as follows:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 3
model name      : Pentium II (Klamath)
stepping        : 3
cpu MHz         : 1862.133

I have no idea if this specific CPU type should support this specific
instruction. If it really should this is obviously a Qemu bug but it
might be reasonable to work around this in the linux kernel.

The kernel is configured with CONFIG_M586 but without CONFIG_X86_GENERIC
(full config upon request). Apparently setting CONFIG_X86_GENERIC works
around the problem.

========== ooops data follows ===================================
invalid opcode: 0000 [#1] SMP
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.26-rc9 #1)
EIP: 0060:[<c0102035>] EFLAGS: 00000202 CPU: 0
EIP is at prepare_to_copy+0x1d/0x43
EAX: c781de00 EBX: 00000000 ECX: c03f3f9c EDX: c03c23e0
ESI: fffffff4 EDI: c03c23e0 EBP: 00000000 ESP: c03f3f08
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c03f2000 task=c03c23e0 task.ti=c03f2000)
Stack: c011c653 c03f3f9c 00000000 00800b00 00000286 00000000 00000000 00000000 
       00800b00 c03f3f9c 00000000 c011d671 00000000 00000000 00000000 00000000 
       c03c8cb0 00000246 c03c8a80 00000046 00000000 00000002 00000001 c014a30c 
Call Trace:
 [<c011c653>] copy_process+0x70/0xf75
 [<c011d671>] do_fork+0xab/0x19c
 [<c014a30c>] free_pages_bulk+0x23/0x1d0
 [<c0108b4a>] native_sched_clock+0x90/0xa4
 [<c03f72fd>] kernel_init+0x0/0x25d
 [<c01024b1>] kernel_thread+0x78/0x80
 [<c03f72fd>] kernel_init+0x0/0x25d
 [<c0104af0>] kernel_thread_helper+0x0/0x10
 [<c02e0d39>] rest_init+0x11/0x4b
 [<c03f7811>] start_kernel+0x2a0/0x2a3
 =======================
Code: ff 05 0c 20 47 c0 c3 ff 0d 0c 20 47 c0 c3 89 c2 8b 40 04 f6 40 0c
01 74 30 8b 82 6c 02 00 00 0f ae 00 0f ba 60 02 07 73 02 db e2 <0f> 1f
00 90 8d b4 26 00 00 00 00 89 f6 8b 42 04 83 60 0c fe 0f 
EIP: [<c0102035>] prepare_to_copy+0x1d/0x43 SS:ESP 0068:c03f3f08
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

    regards   Christian


