Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbYHOCVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbYHOCVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYHOCVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:21:24 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:17420 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYHOCVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dGusToq2vKezC2JUuYctJ3KSTy89XDK1InDiyDKPEYuhwcSjmfMu/GlgPJ6iFUWcby
         LmXnABTDTkqt+VjddSaDSIc+Vo1i8dPD5rH47Z/BX2Ey2sWiV3+Rx3OE2ANKYsGmZO57
         I1WFNCXaxltU1ytrVp21XZe3eYF0JJ1BB8x88=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/7] x86: some debug info for 32bit sparse_irq
Date: Thu, 14 Aug 2008 19:20:26 -0700
Message-Id: <1218766832-20476-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218766832-20476-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could figure out who get interrupt, but vector_irq is not initialized.

Signed-off-by: Yinghai Lu  <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |    8 ++++++--
 arch/x86/kernel/io_apic_64.c |    2 ++
 arch/x86/kernel/irq_32.c     |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 9e111d6..429889d 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1120,8 +1120,12 @@ next:
                         cfg->move_in_progress = 1;
                         cfg->old_domain = cfg->domain;
                 }
-                for_each_cpu_mask_nr(new_cpu, new_mask)
-                        per_cpu(vector_irq, new_cpu)[vector] = irq;
+		printk(KERN_DEBUG "assign_irq_vector: irq %d vector %#x cpu ", irq, vector);
+		for_each_cpu_mask_nr(new_cpu, new_mask) {
+			per_cpu(vector_irq, new_cpu)[vector] = irq;
+			printk(KERN_CONT " %d ", new_cpu);
+		}
+		printk(KERN_CONT "\n");
                 cfg->vector = vector;
                 cfg->domain = domain;
                 return 0;
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index a11515f..4d1b02d 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -1392,6 +1392,8 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
+	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
+	printk(KERN_DEBUG ".......    : LTS          : %X\n", reg_00.bits.LTS);
 
 	printk(KERN_DEBUG ".... register #01: %08X\n", *(int *)&reg_01);
 	printk(KERN_DEBUG ".......     : max redirection entries: %04X\n", reg_01.bits.entries);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 63b4f6c..30b58b3 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -237,8 +237,8 @@ unsigned int do_IRQ(struct pt_regs *regs)
 
 	desc = irq_desc(irq);
 	if (unlikely(!desc)) {
-		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x\n",
-					__func__, irq, vector);
+		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x cpu %d\n",
+					__func__, irq, vector, smp_processor_id());
 		BUG();
 	}
 
-- 
1.5.4.5

