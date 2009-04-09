Return-Path: <linux-kernel-owner+w=401wt.eu-S936028AbZDISSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936028AbZDISSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935899AbZDISSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:18:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:21791 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935891AbZDISSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:18:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bgWKIene63UxvyGP2Td0bXwnI8B5mHCxGhKvmul7eyG4l+ZZ8VJXX5FQOzS0baKUTJ
         Ey47seewMpb0MU5b0/5HmtL2ZoInH7o2IgtQDlpCPsPkHqbZ5dUDQ7/UwOB7mgs5w8jP
         om9Dm/xVniGLE7vtMuSxQefusqn34YPa+V4Sc=
Date: Thu, 9 Apr 2009 22:18:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [RFC -tip] x86: do_IRQ - send APIC EOI for x86-32 on irq without
	handler v3
Message-ID: <20090409181802.GC7558@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: bugfix, cleanup

We should send APIC EOI if it's enabled only.
Since the same is needed for ack_bad_irq
we just introduce ack_APIC_irq_safe which in
turn check if we have APIC properly installed
and initialized and do EOI then.

Also a tiny cleanup: use pr_... macros and
add printk_ratelimit for ack_bad_irq to eliminate
possible storm on screwed hardware.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Ingo, I've checked the sources and as far as I see
we could NOP'ify apic->write indeed but I have
an internal feeling that this will bring us more problem
in future (for example it could be the following scenario:
some screwed APIC would require cleaning of LVT's or
IRR after resume regardless if it was initialized
or not at all). Mostly I mean that the idea of making
apic->write NOP'ified is quite elegant indeed but
cut off the subset of apic operations (we need
apic->read anyway) somehow bothering me from inside :)

CC'ed a number of people I know were involved in
this area.

On the other hand I could make a testing patch for
nop'fied ->write operation so we could check if
it bring any problems in real tests. Thoughts?

 arch/x86/include/asm/apic.h |   10 +++++++++-
 arch/x86/kernel/irq.c       |   18 ++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apic.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apic.h
+++ linux-2.6.git/arch/x86/include/asm/apic.h
@@ -392,7 +392,6 @@ static inline u32 safe_apic_wait_icr_idl
 	return apic->safe_wait_icr_idle();
 }
 
-
 static inline void ack_APIC_irq(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -406,6 +405,15 @@ static inline void ack_APIC_irq(void)
 #endif
 }
 
+/* Ack APIC irq if it's enabled only */
+static inline void ack_APIC_irq_safe(void)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (cpu_has_apic)
+		ack_APIC_irq();
+#endif
+}
+
 static inline unsigned default_get_apic_id(unsigned long x)
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
Index: linux-2.6.git/arch/x86/kernel/irq.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq.c
+++ linux-2.6.git/arch/x86/kernel/irq.c
@@ -24,9 +24,9 @@ void (*generic_interrupt_extension)(void
  */
 void ack_bad_irq(unsigned int irq)
 {
-	printk(KERN_ERR "unexpected IRQ trap at vector %02x\n", irq);
+	if (printk_ratelimit())
+		pr_err("unexpected IRQ trap at vector %02x\n", irq);
 
-#ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
 	 * We _must_ ack these because every local APIC has only N
@@ -36,9 +36,7 @@ void ack_bad_irq(unsigned int irq)
 	 * completely.
 	 * But only ack when the APIC is enabled -AK
 	 */
-	if (cpu_has_apic)
-		ack_APIC_irq();
-#endif
+	ack_APIC_irq_safe();
 }
 
 #define irq_stats(x)		(&per_cpu(irq_stat, x))
@@ -223,14 +221,10 @@ unsigned int __irq_entry do_IRQ(struct p
 	irq = __get_cpu_var(vector_irq)[vector];
 
 	if (!handle_irq(irq, regs)) {
-#ifdef CONFIG_X86_64
-		if (!disable_apic)
-			ack_APIC_irq();
-#endif
-
+		ack_APIC_irq_safe();
 		if (printk_ratelimit())
-			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
-			       __func__, smp_processor_id(), vector, irq);
+			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
+				__func__, smp_processor_id(), vector, irq);
 	}
 
 	irq_exit();
