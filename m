Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZAINWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZAINWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZAINWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:22:44 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58437 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752753AbZAINWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:22:43 -0500
Date: Fri, 9 Jan 2009 14:21:48 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-mtd@lists.infradead.org
Subject: [regression] jffs2 gc thread oops in set_dumpable()
Message-ID: <20090109142148.35f3a99a@hskinnemoen-d830>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following crash has been observed on an ARM platform (intelmote 2)
and an AVR32 platform (ATSTK1006). In both cases, it's a NULL pointer
dereference at virtual address 0x150 from set_dumpable() called from
one of the jffs2_gcd_mtdX threads, and both boards work fine with
2.6.28.

Jonathan identified the following commit through bisection:

d84f4f992cbd76e8f39c488cf0c5d123843923b1 is first bad commit                              
commit d84f4f992cbd76e8f39c488cf0c5d123843923b1                                           
Author: David Howells <dhowells@redhat.com>                                               
Date:   Fri Nov 14 10:39:23 2008 +1100                                                    

    CRED: Inaugurate COW credentials

I attempted to revert it, but it caused an enormous number of conflicts
which I didn't even try to resolve.

Further analysis by Jonathan: "For some reason, when set_dumpable is
run in commit_creds (cred.c) task->mm is null.  Don't know my way around
this bit of the kernel, but guessing that isn't good!"

The ARM Oops looks like this:

Unable to handle kernel NULL pointer dereference at virtual address 00000150
pgd = c0004000
[00000150] *pgd=00000000
Internal error: Oops: 17 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.28_r1.0-06127-g238c6d5 #2)
PC is at set_dumpable+0x3c/0xc8
LR is at commit_creds+0x140/0x23c
pc : [<c0092450>]    lr : [<c0051f90>]    psr: 60000093
sp : c1083ed4  ip : c1083ee4  fp : c1083ee0
r10: 00000000  r9 : 00000000  r8 : c1d38400
r7 : c1c3f080  r6 : c02a72f8  r5 : c1c4faa0  r4 : 00000000
r3 : 60000093  r2 : 60000093  r1 : 00000000  r0 : 00000000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0000397f  Table: a1e1c000  DAC: 00000015
Process jffs2_gcd_mtd2 (pid: 787, stack limit = 0xc1082268)
Stack: (0xc1083ed4 to 0xc1084000)
3ec0:                                              c1083f20 c1083ee4 c0051f90 
3ee0: c0092420 00000100 00000000 fffffeff ffffffff ffffffff ffffffff 00000100 
3f00: 00000000 c1082000 c02a0e38 00000000 00000000 c1083f40 c1083f24 c0039028 
3f20: c0051e5c ffffffff ffffffff 00000000 00000000 c1083ff4 c1083f54 c0114ef0 
3f40: c0038e10 c0278768 00000002 c0114ecc c1c724a0 00000000 00000000 00000000 
3f60: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
3f80: 58000442 00000000 00000000 c1083fac c1083f9c c00319ac c002fec4 00000000 
3fa0: 00000000 c1083fb0 c001df84 c0031998 00000000 c1d38400 c0114ecc c0039064 
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
3fe0: 00000000 00000000 00000000 c1083ff8 c0039064 c0114ed8 a0311021 a0311421 
Backtrace: 
[<c0092414>] (set_dumpable+0x0/0xc8) from [<c0051f90>] (commit_creds+0x140/0x23c)
[<c0051e50>] (commit_creds+0x0/0x23c) from [<c0039028>] (daemonize+0x228/0x264)
 r7:00000000 r6:00000000 r5:c02a0e38 r4:c1082000
[<c0038e00>] (daemonize+0x0/0x264) from [<c0114ef0>] (jffs2_garbage_collect_thread+0x24/0x1e4)
 r3:c1c724a0 r2:c0114ecc r1:00000002 r0:c0278768
 r5:00000000 r4:00000000
[<c0114ecc>] (jffs2_garbage_collect_thread+0x0/0x1e4) from [<c0039064>] (do_exit+0x0/0x758)
 r8:00000000 r7:00000000 r6:00000000 r5:00000000 r4:00000000
Code: e89da800 e10f2000 e3823080 e121f003 (e5903150) 
---[ end trace 28404767015f24df ]---
note: jffs2_gcd_mtd2[787] exited with preempt_count 1

while the AVR32 Oops looks like this:

Unable to handle kernel NULL pointer dereference at virtual address 00000150
ptbr = 93a9b000 pgd = 93b45000
Oops: Kernel access of bad area, sig: 11 [#1]
FRAME_POINTER chip: 0x01f:0x1e82 rev 2
Modules linked in:
PC is at set_dumpable+0x16/0x5e
LR is at commit_creds+0x86/0x10c
pc : [<9005bfc6>]    lr : [<9002e4fe>]    Not tainted
sp : 93bbff00  r12: 00000000  r11: 00000000
r10: ffffffff  r9 : 00000000  r8 : 00000150
r7 : 93bbff00  r6 : 939b9420  r5 : 901eca58  r4 : 00000000
r3 : 939e02e0  r2 : 90021494  r1 : 900a40c4  r0 : 93b52400
Flags: qvnzC
Mode bits: hjmde....G
CPU Mode: Supervisor
Process: jffs2_gcd_mtd1 [281] (task: 939e02e0 thread: 93bbe000)
Stack: (0x93bbff00 to 0x93bc0000)
ff00: 9002e4fe 93bbff14 939b9420 901eca58 00000000 90021b00 93bbff44 93bbe000 
ff20: 901ea8b0 00000000 00000000 90021494 900a40c4 93b52400 ffffffff ffffffff 
ff40: 93bbff58 900a40da 93bbffdc 00000000 93b52400 00000000 00000001 038e300c 
ff60: b3ec22cd 11c4148c b11833cc 338d19ec 77ca338c 734831ec 23dc63cc 33ec334c 
ff80: 33cc33cd 338c30cc 37cc338c b3fcb68d 9001be6c 93bbffa4 90204640 939e05c0 
ffa0: 93b5248c 90014166 93badcfc 90204640 939e05c0 93b5248c 00400000 900180e0 
ffc0: 900180e0 93bc0000 00000000 00000000 00000000 00000000 00000000 90021494 
ffe0: 00000000 00000000 00000000 00000000 00000000 90021494 900a40c4 93b52400 
Call trace:
 [<9002e4fe>] commit_creds+0x86/0x10c
 [<90021b00>] daemonize+0x14c/0x16c
 [<900a40da>] jffs2_garbage_collect_thread+0x16/0x108
 [<90021494>] do_exit+0x0/0x488

I'd appreciate some help finding the cause of this, as I'm not at all
familiar with the code in question. Please let me know if you need more
information or want me to test something.

Haavard
