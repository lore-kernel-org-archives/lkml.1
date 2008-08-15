Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYHOXop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYHOXop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYHOXnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:43:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:28620 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbYHOXni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lxrLGdIpJqgwc/4fkLirk91Os5AyE8W+ETXJP5+NSjahr1QRkqJOA2EjSs6pRK1a9h
         ujEa8Jn1X/ayitQrwVFLSvcwYb8xFCKUURWE9dh8Zo+bqOBZKFJvMZJ9UQk02q1tnWfS
         11tonaQad/lRDVyOWRpeB04H3EtSlqzvtuHfY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/7] x86: make 64 handle sis_apic_bug like the 32 bit
Date: Fri, 15 Aug 2008 16:42:38 -0700
Message-Id: <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do we have 64bit system with sis chipset?

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic_64.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -65,7 +65,11 @@
 
 int ioapic_force;
 
-int sis_apic_bug; /* not actually supported, dummy for compile */
+/*
+ *      Is the SiS APIC rmw bug present ?
+ *      -1 = don't know, 0 = no, 1 = yes
+ */
+int sis_apic_bug = -1;
 
 static DEFINE_SPINLOCK(ioapic_lock);
 static DEFINE_SPINLOCK(vector_lock);
@@ -373,9 +377,11 @@ static inline void io_apic_write(unsigne
  * Re-write a value: to be used for read-modify-write
  * cycles where the read already set up the index register.
  */
-static inline void io_apic_modify(unsigned int apic, unsigned int value)
+static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
+        if (sis_apic_bug)
+                writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
 }
 
@@ -494,7 +500,7 @@ static void __target_IO_APIC_irq(unsigne
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
-		io_apic_modify(apic, reg);
+		io_apic_modify(apic, 0x10 + pin*2, reg);
 		if (!entry->next)
 			break;
 		entry = entry->next;
@@ -622,7 +628,7 @@ static inline void io_apic_sync(unsigned
 		pin = entry->pin;					\
 		reg = io_apic_read(entry->apic, 0x10 + R + pin*2);	\
 		reg ACTION;						\
-		io_apic_modify(entry->apic, reg);			\
+		io_apic_modify(entry->apic, 0x10 + R + pin*2, reg);	\
 		FINAL;							\
 		if (!entry->next)					\
 			break;						\
@@ -2446,6 +2452,20 @@ void __init setup_IO_APIC(void)
 	check_timer();
 }
 
+/*
+ *      Called after all the initialization is done. If we didnt find any
+ *      APIC bugs then we can allow the modify fast path
+ */
+
+static int __init io_apic_bug_finalize(void)
+{
+        if (sis_apic_bug == -1)
+                sis_apic_bug = 0;
+        return 0;
+}
+
+late_initcall(io_apic_bug_finalize);
+
 struct sysfs_ioapic_data {
 	struct sys_device dev;
 	struct IO_APIC_route_entry entry[0];
