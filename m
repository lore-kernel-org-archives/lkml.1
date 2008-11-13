Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbYKMThs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbYKMThs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYKMTeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:14 -0500
Received: from gw.goop.org ([64.81.55.164]:34372 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYKMTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:05 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 38] x86: define no-op exit_idle() on 32-bit
X-Mercurial-Node: 97ff5883641d4b7828615e63f6ab56a991cb603c
Message-Id: <97ff5883641d4b782861.1226603409@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_idle() is only used on 64-bit, but define a noop version on
32-bit to allow subsequent unification.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/idle.h |   10 ++++++++++
 arch/x86/kernel/apic.c      |    7 +------
 arch/x86/kernel/io_apic.c   |    2 --
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -8,8 +8,18 @@
 void idle_notifier_register(struct notifier_block *n);
 void idle_notifier_unregister(struct notifier_block *n);
 
+#ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
+#else
+static inline void enter_idle(void)
+{
+}
+
+static inline void exit_idle(void)
+{
+}
+#endif	/* CONFIG_X86_64 */
 
 void c1e_remove_cpu(int cpu);
 
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -808,9 +808,8 @@
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
+
 	irq_enter();
 	local_apic_timer_interrupt();
 	irq_exit();
@@ -1668,9 +1667,7 @@
 {
 	u32 v;
 
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1699,9 +1696,7 @@
 {
 	u32 v, v1;
 
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
 	irq_enter();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v = apic_read(APIC_ESR);
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2242,9 +2242,7 @@
 {
 	unsigned vector, me;
 	ack_APIC_irq();
-#ifdef CONFIG_X86_64
 	exit_idle();
-#endif
 	irq_enter();
 
 	me = smp_processor_id();


