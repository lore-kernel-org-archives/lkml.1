Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbYBRMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbYBRMZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758316AbYBRMZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:25:48 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41896 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYBRMZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:25:46 -0500
X-Mozilla-Status: 0001
X-Mozilla-Status2: 00800000
X-Mozilla-Keys: 
Message-ID: <47B9775F.1050203@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2008 17:47:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Regression with sched yield - 2.6.25-rc2-mm1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was looking at the 45% regression reported by Yanmin, when while running the
test, I ran into

1:mon> t
[c0000000e7677da0] c000000000067de0 .sys_sched_yield+0x6c/0xbc
[c0000000e7677e30] c000000000008748 syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 00000400001d09e4
SP (4000664cb10) is in userspace
1:mon> r
R00 = 0000000000000001   R16 = 0000000000000000
R01 = c0000000e7677d20   R17 = 0000000000000000
R02 = c000000000949490   R18 = 00000000100c5290
R03 = 0000000000000008   R19 = 0000000000000000
R04 = 0000000010036370   R20 = 0000000010040bc0
R05 = 0000000000000000   R21 = 0000000000000000
R06 = 0000000000000001   R22 = 0000000000000002
R07 = 000000000000002d   R23 = 0000000000000008
R08 = 0000000000000000   R24 = 00000000100387c0
R09 = 0000000000000000   R25 = 0000000010038c20
R10 = c0000000e5c12520   R26 = 00000000100363e8
R11 = c0000000e5c12558   R27 = 0000000010038c50
R12 = 800000000000f032   R28 = 0000000000360000
R13 = c00000000083c300   R29 = c000000000b43b80
R14 = 0000040000ee6e0d   R30 = c0000000008ba608
R15 = 0000000000000000   R31 = c000000000b42680
pc  = c000000000068e50 .yield_task_fair+0x94/0xc4
lr  = c000000000067de0 .sys_sched_yield+0x6c/0xbc
msr = 8000000000009032   cr  = 24204482
ctr = c000000000068dbc   xer = 0000000020000010   trap =  300
dar = 0000000000000050   dsisr = 40000000
1:mon> e
cpu 0x1: Vector: 300 (Data Access) at [c0000000e7677aa0]
    pc: c000000000068e50: .yield_task_fair+0x94/0xc4
    lr: c000000000067de0: .sys_sched_yield+0x6c/0xbc
    sp: c0000000e7677d20
   msr: 8000000000009032
   dar: 50
 dsisr: 40000000
  current = 0xc0000000e5c12520
  paca    = 0xc00000000083c300
    pid   = 569, comm = java
1:mon> di %pc
c000000000068e50  e9280050      ld      r9,80(r8)
c000000000068e54  e80b0050      ld      r0,80(r11)
c000000000068e58  7fa90040      cmpld   cr7,r9,r0
c000000000068e5c  419c000c      blt     cr7,c000000000068e68    #
.yield_task_fair+0xac/0xc4
c000000000068e60  38090001      addi    r0,r9,1
c000000000068e64  f80b0050      std     r0,80(r11)
c000000000068e68  38210080      addi    r1,r1,128
c000000000068e6c  e8010010      ld      r0,16(r1)
c000000000068e70  ebc1fff0      ld      r30,-16(r1)
c000000000068e74  ebe1fff8      ld      r31,-8(r1)
c000000000068e78  7c0803a6      mtlr    r0
c000000000068e7c  4e800020      blr
c000000000068e80  7c0802a6      mflr    r0
c000000000068e84  fba1ffe8      std     r29,-24(r1)
c000000000068e88  fbe1fff8      std     r31,-8(r1)
c000000000068e8c  f8010010      std     r0,16(r1)

Matching assembly and symbols, the code turned out to be around

        /*
         * Find the rightmost entry in the rbtree:
         */
        rightmost = __pick_last_entity(&rq->cfs);
        /*
         * Already in the rightmost position?
         */
        if (unlikely(rightmost->vruntime < se->vruntime))
                return;

It looked like rightmost was set to NULL. I am going to try and find some time
in tomorrow and see if I can debug it further.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

