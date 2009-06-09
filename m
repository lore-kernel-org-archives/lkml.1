Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbZFIOmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbZFIOmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZFIOlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:41:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZFIOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:41:55 -0400
Date: Tue, 9 Jun 2009 10:40:50 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch v2] x86: clear TS in irq_ts_save() when in an atomic section
Message-ID: <20090609104050.50158cfe@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090609142254.GC32703@elte.hu>
References: <20090609100512.7d191fd4@dhcp-100-2-144.bos.redhat.com>
	<20090609142254.GC32703@elte.hu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: clear TS in irq_ts_save() when in atomic

The dynamic FPU context allocation changes caused the padlock driver
to generate the below warning. Fix it by masking TS when doing padlock
encryption operations in an atomic section.

BUG: sleeping function called from invalid context at mm/slub.c:1602
in_atomic(): 1, irqs_disabled(): 0, pid: 82, name: cryptomgr_test
Pid: 82, comm: cryptomgr_test Not tainted 2.6.29.4-168.test7.fc11.x86_64 #1
Call Trace:
[<ffffffff8103ff16>] __might_sleep+0x10b/0x110
[<ffffffff810cd3b2>] kmem_cache_alloc+0x37/0xf1
[<ffffffff81018505>] init_fpu+0x49/0x8a
[<ffffffff81012a83>] math_state_restore+0x3e/0xbc
[<ffffffff813ac6d0>] do_device_not_available+0x9/0xb
[<ffffffff810123ab>] device_not_available+0x1b/0x20
[<ffffffffa001c066>] ? aes_crypt+0x66/0x74 [padlock_aes]
[<ffffffff8119a51a>] ? blkcipher_walk_next+0x257/0x2e0
[<ffffffff8119a731>] ? blkcipher_walk_first+0x18e/0x19d
[<ffffffffa001c1fe>] aes_encrypt+0x9d/0xe5 [padlock_aes]
[<ffffffffa0027253>] crypt+0x6b/0x114 [xts]
[<ffffffffa001c161>] ? aes_encrypt+0x0/0xe5 [padlock_aes]
[<ffffffffa001c161>] ? aes_encrypt+0x0/0xe5 [padlock_aes]
[<ffffffffa0027390>] encrypt+0x49/0x4b [xts]
[<ffffffff81199acc>] async_encrypt+0x3c/0x3e
[<ffffffff8119dafc>] test_skcipher+0x1da/0x658
[<ffffffff811979c3>] ? crypto_spawn_tfm+0x8e/0xb1
[<ffffffff8119672d>] ? __crypto_alloc_tfm+0x11b/0x15f
[<ffffffff811979c3>] ? crypto_spawn_tfm+0x8e/0xb1
[<ffffffff81199dbe>] ? skcipher_geniv_init+0x2b/0x47
[<ffffffff8119a905>] ? async_chainiv_init+0x5c/0x61
[<ffffffff8119dfdd>] alg_test_skcipher+0x63/0x9b
[<ffffffff8119e1bc>] alg_test+0x12d/0x175
[<ffffffff8119c488>] cryptomgr_test+0x38/0x54
[<ffffffff8119c450>] ? cryptomgr_test+0x0/0x54
[<ffffffff8105c6c9>] kthread+0x4d/0x78
[<ffffffff8101264a>] child_rip+0xa/0x20
[<ffffffff81011f67>] ? restore_args+0x0/0x30
[<ffffffff8105c67c>] ? kthread+0x0/0x78
[<ffffffff81012640>] ? child_rip+0x0/0x20

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- work-2.6.29.4.orig/arch/x86/include/asm/i387.h
+++ work-2.6.29.4/arch/x86/include/asm/i387.h
@@ -305,18 +305,18 @@ static inline void kernel_fpu_end(void)
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions
- * get used from interrupt context aswell. To prevent these kernel instructions
- * in interrupt context interact wrongly with other user/kernel fpu usage, we
+ * get used from interrupt context as well. To prevent these kernel instructions
+ * in interrupt context interacting wrongly with other user/kernel fpu usage, we
  * should use them only in the context of irq_ts_save/restore()
  */
 static inline int irq_ts_save(void)
 {
 	/*
-	 * If we are in process context, we are ok to take a spurious DNA fault.
-	 * Otherwise, doing clts() in process context require pre-emption to
-	 * be disabled or some heavy lifting like kernel_fpu_begin()
+	 * If in process context and not atomic, we can take a spurious DNA fault.
+	 * Otherwise, doing clts() in process context requires disabling preemption
+	 * or some heavy lifting like kernel_fpu_begin()
 	 */
-	if (!in_interrupt())
+	if (!in_atomic())
 		return 0;
 
 	if (read_cr0() & X86_CR0_TS) {
