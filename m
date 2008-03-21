Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYCUSYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYCUSYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYCUSX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:23:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:1592 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbYCUSX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:23:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,536,1199692800"; 
   d="scan'208";a="308263416"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Date: Fri, 21 Mar 2008 11:22:02 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com>
In-reply-to: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Thread-Index: AciJuGrg9oEXM4ttSNmtOVh5irWVkgBxSYNw
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>, <linux-kernel@vger.kernel.org>
Cc: <npiggin@suse.de>, <paulus@samba.org>, <tglx@linutronix.de>,
       <mingo@redhat.com>
X-OriginalArrivalTime: 21 Mar 2008 18:22:03.0605 (UTC) FILETIME=[76402850:01C88B80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When/if more archs are converted, it'll of course look even better.
> Comments? I've verified that this builts and boots on x86, x86-64
> and powerpc. IA64 may still need a one-liner change, I don't have
> access to that platform anymore so I can't verify that myself. It
> does build, however :-)

Can you give me a clue as to which line needs the one-liner ... although
it builds cleanly for IA64 it panics with a dereference NULL fault. It
looks like we were in the list_add_tail(&data->list, &dst->list) code.

Console log looks like this:

ACPI: Core revision 20070126
Boot processor id 0x0/0xc018
Fixed BSP b0 value from CPU 1
Unable to handle kernel NULL pointer dereference (address 0000000000000000)
swapper[0]: Oops 8804682956800 [1]
Modules linked in:

Pid: 0, CPU 1, comm:              swapper
psr : 00001010084a2010 ifs : 800000000000060e ip  : [<a0000001000be1c0>]    Not tainted (2.6.25-rc6-tiger-smp)
ip is at generic_exec_single+0xc0/0x200
unat: 0000000000000000 pfs : 000000000000060e rsc : 0000000000000003
rnat: 5555555555555555 bsps: 5555555555555555 pr  : 0000000000002655
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001000be180 b6  : e00000007fe131b0 b7  : e00000007fb1bde0
f6  : 000000000000000000000 f7  : 1003e6db6db6db6db6db7
f8  : 1003e00000000000c410a f9  : 1000fffff800000000000
f10 : 1003e000000000001ffff f11 : 000000000000000000000
r1  : a000000100c42f20 r2  : 0000000000000000 r3  : ffffffffffff5968
r8  : 00000010084a6010 r9  : a000000100a617c0 r10 : 0000000000000000
r11 : a000000100a617c0 r12 : e0000001c025fdf0 r13 : e0000001c0250000
r14 : e000000180016058 r15 : e000000180005970 r16 : 0000000000000002
r17 : a000000100a617c0 r18 : 0000000000004000 r19 : a00000010099ffb0
r20 : e0000001c01550c0 r21 : e0000001c01501c0 r22 : 0000000000000000
r23 : e000000180016064 r24 : a07ffffffff20498 r25 : 00000000000000c0
r26 : 00000000000000c1 r27 : 00000010084a6010 r28 : 0000000000000001
r29 : a00000010099ff80 r30 : 0000000000000000 r31 : e000000180005978

Call Trace:
 [<a000000100011bb0>] show_stack+0x50/0xa0
                                sp=e0000001c025f9c0 bsp=e0000001c0250e68
 [<a000000100012490>] show_regs+0x830/0x860
                                sp=e0000001c025fb90 bsp=e0000001c0250e20
 [<a0000001000340a0>] die+0x1c0/0x2c0
                                sp=e0000001c025fb90 bsp=e0000001c0250dd0
 [<a00000010005b150>] ia64_do_page_fault+0x830/0x960
                                sp=e0000001c025fb90 bsp=e0000001c0250d70
 [<a00000010000a600>] ia64_leave_kernel+0x0/0x270
                                sp=e0000001c025fc20 bsp=e0000001c0250d70
 [<a0000001000be1c0>] generic_exec_single+0xc0/0x200
                                sp=e0000001c025fdf0 bsp=e0000001c0250d00
 [<a0000001000be4c0>] generic_smp_call_function_single+0x1c0/0x1e0
                                sp=e0000001c025fdf0 bsp=e0000001c0250cb0
 [<a000000100050aa0>] smp_call_function_single+0x40/0x60
                                sp=e0000001c025fe20 bsp=e0000001c0250c70
 [<a000000100050fa0>] ia64_sync_itc+0xc0/0x3e0
                                sp=e0000001c025fe20 bsp=e0000001c0250c38
 [<a0000001006fbea0>] start_secondary+0x380/0x560
                                sp=e0000001c025fe30 bsp=e0000001c0250be0
 [<a000000100707220>] __kprobes_text_end+0x6c0/0x6f0
                                sp=e0000001c025fe30 bsp=e0000001c0250be0
Kernel panic - not syncing: Attempted to kill the idle task!
