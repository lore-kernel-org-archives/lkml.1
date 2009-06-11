Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZFKNZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZFKNZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZFKNZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:25:44 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40286 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZFKNZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:25:44 -0400
Date: Thu, 11 Jun 2009 16:25:45 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH] init: setup traps before mem_init()
Message-ID: <Pine.LNX.4.64.0906111622510.13992@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

32-bit x86 does WP protect test in mem_init() so we must setup traps before we
call mem_init() during boot. This patch should fix the following bug 
reported by Ingo Molnar:

  We have a hard crash in the WP-protect code:

  [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...BUG: Int 14: CR2 ffcff000
  [    0.000000]      EDI 00000188  ESI 00000ac7  EBP c17eaf9c  ESP c17eaf8c
  [    0.000000]      EBX 000014e0  EDX 0000000e  ECX 01856067  EAX 00000001
  [    0.000000]      err 00000003  EIP c10135b1   CS 00000060  flg 00010002
  [    0.000000] Stack: c17eafa8 c17fd410 c16747bc c17eafc4 c17fd7e5 000011fd f8616000 c18237cc
  [    0.000000]        00099800 c17bb000 c17eafec c17f1668 000001c5 c17f1322 c166e039 c1822bf0
  [    0.000000]        c166e033 c153a014 c18237cc 00020800 c17eaff8 c17f106a 00020800 01ba5003
  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip-02161-g7a74539-dirty #52203
  [    0.000000] Call Trace:
  [    0.000000]  [<c15357c2>] ? printk+0x14/0x16
  [    0.000000]  [<c10135b1>] ? do_test_wp_bit+0x19/0x23
  [    0.000000]  [<c17fd410>] ? test_wp_bit+0x26/0x64
  [    0.000000]  [<c17fd7e5>] ? mem_init+0x1ba/0x1d8
  [    0.000000]  [<c17f1668>] ? start_kernel+0x164/0x2f7
  [    0.000000]  [<c17f1322>] ? unknown_bootoption+0x0/0x19c
  [    0.000000]  [<c17f106a>] ? __init_begin+0x6a/0x6f

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Ingo,

I don't see other architectures doing anything like this in mem_init() so 
moving test_wp_bit() out of the function is probably a better long-term 
fix. I have only tested this on x86-64 so please give it a try.

 init/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 859af21..6d38f96 100644
--- a/init/main.c
+++ b/init/main.c
@@ -588,6 +588,8 @@ asmlinkage void __init start_kernel(void)
 	 */
 	pidhash_init();
 	vfs_caches_init_early();
+	sort_main_extable();
+	trap_init();
 	/*
 	 * Set up kernel memory allocators
 	 */
@@ -610,8 +612,6 @@ asmlinkage void __init start_kernel(void)
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();
 	}
-	sort_main_extable();
-	trap_init();
 	rcu_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
-- 
1.6.0.4

