Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbXIXVNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbXIXVNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXIXVNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:13:25 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:56806 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbXIXVNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:13:24 -0400
Subject: 2.6.23-rc7-mm1:  panic in scheduler
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 24 Sep 2007 17:12:52 -0400
Message-Id: <1190668373.5030.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I looked around on the MLs for mention of this, but didn't find anything
that appeared to match.

Platform:  HP rx8620 - 16-cpu/32GB/4-node ia64 [Madison]

2.6.23-rc7-mm1 broken out -- panic occurs when git-sched.patch pushed:

Unable to handle kernel NULL pointer dereference (address 0000000000000000)
swapper[0]: Oops 8813272891392 [1]
Modules linked in: scsi_wait_scan ehci_hcd ohci_hcd uhci_hcd usbcore

Pid: 0, CPU 14, comm:              swapper
psr : 0000101008522030 ifs : 8000000000000002 ip  : [<a0000001003014e0>]    Not tainted
ip is at rb_next+0x0/0x140
unat: 0000000000000000 pfs : 0000000000000308 rsc : 0000000000000003
rnat: 8000000000000012 bsps: 000000000001003e pr  : 6609a840599519a5
ldrs: 0000000000000000 ccv : 0000000000000002 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100078dc0 b6  : a000000100074a40 b7  : a000000100078e00
f6  : 1003e0000000000000000 f7  : 1003e0000000000400000
f8  : 1003e000000002aaaaaab f9  : 1003e0000000d43798a2b
f10 : 1003e35e9970b967dd8b9 f11 : 1003e0000000000000002
r1  : a000000100bc0920 r2  : e0000760000577f0 r3  : e000076000057f10
r8  : fffffffffffffff0 r9  : 0000000000000002 r10 : e000076000057780
r11 : 0000000000000000 r12 : e00007004160fe10 r13 : e000070041608000
r14 : 0000000000000000 r15 : 000000000000000e r16 : 00000007f6c30a22
r17 : e000070041608040 r18 : a0000001008383a8 r19 : a000000100078e00
r20 : e000076000055bb8 r21 : e000076000055bb0 r22 : e000076000057ed0
r23 : 00000000000f4240 r24 : a0000001009e0440 r25 : e000070041608bb4
r26 : 0000000000000000 r27 : 0000000000000000 r28 : e000076000057f80
r29 : 00000000000002e7 r30 : 0000000000000000 r31 : e000076000057780

Call Trace:
 [<a000000100014f60>] show_stack+0x80/0xa0
                                sp=e00007004160f9e0 bsp=e000070041609008
 [<a000000100015bf0>] show_regs+0x870/0x8a0
                                sp=e00007004160fbb0 bsp=e000070041608fa8
 [<a00000010003d170>] die+0x190/0x300
                                sp=e00007004160fbb0 bsp=e000070041608f60
 [<a000000100071bc0>] ia64_do_page_fault+0x780/0xa80
                                sp=e00007004160fbb0 bsp=e000070041608f08
 [<a00000010000b5c0>] ia64_leave_kernel+0x0/0x270
                                sp=e00007004160fc40 bsp=e000070041608f08
 [<a0000001003014e0>] rb_next+0x0/0x140
                                sp=e00007004160fe10 bsp=e000070041608ef8
 [<a000000100078dc0>] __dequeue_entity+0x80/0xc0
                                sp=e00007004160fe10 bsp=e000070041608ec8
 [<a000000100078e60>] pick_next_task_fair+0x60/0x180
                                sp=e00007004160fe10 bsp=e000070041608e98
 [<a0000001006a5880>] schedule+0x340/0x19c0
                                sp=e00007004160fe10 bsp=e000070041608cc0
 [<a000000100014cb0>] cpu_idle+0x290/0x3e0
                                sp=e00007004160fe30 bsp=e000070041608c50
 [<a000000100066020>] start_secondary+0x380/0x5a0
                                sp=e00007004160fe30 bsp=e000070041608c00
 [<a0000001006abca0>] __kprobes_text_end+0x6c0/0x6f0
                                sp=e00007004160fe30 bsp=e000070041608c00


Taking a quick look at [__]{en|de|queue_entity() and the functions they call,
I see something suspicious in set_leftmost() in sched_fair.c:

static inline void
set_leftmost(struct cfs_rq *cfs_rq, struct rb_node *leftmost)
{
        struct sched_entity *se;

        cfs_rq->rb_leftmost = leftmost;
        if (leftmost)
                se = rb_entry(leftmost, struct sched_entity, run_node);
}

Missing code?  corrupt patch?

config available on request, but there doesn't seem to be much in the way
of scheduler config option.  A few that might apply:

SCHED_SMT is not set
SCHED_DEBUG=y
SCHEDSTATS=y


Regards,
Lee Schermerhorn


