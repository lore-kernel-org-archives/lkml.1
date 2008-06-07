Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbYFGP5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbYFGP5e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 11:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbYFGP4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 11:56:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:56268 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758861AbYFGP4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 11:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=WjtEjhm5p56ynxdhHZJ91oMjrwCmeCuEJDZMp+pwqxR6tc/7imR0d9wSVmu8Vf2fbD
         JyaoZEOVBOfecdO86AWlB7Os2iGw0fK5XM8Tylw1YGCr301m+CqgvWswIKmCUaUagPAa
         v44ZbyK5WIxRqzONT2GZ+joBgoP3Gm1mwg7ag=
References: <20080607155355.010786004@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jun 2008 19:53:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] x86: io-apic - use predefined names instead of numeric constants
Content-Disposition: inline; filename=x86-io-apic-use-defs
Message-ID: <484aafc1.0c58560a.4018.6edc@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces some hard-coded numbers
with predefined names.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

The patch was checked to _not_ introduce any finctional
change - compiled text sections remains the same.

Index: linux-2.6.git/arch/x86/kernel/io_apic_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic_64.c	2008-06-07 19:29:26.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic_64.c	2008-06-07 19:36:50.000000000 +0400
@@ -183,7 +183,7 @@ static bool io_apic_level_ack_pending(un
 			break;
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
-		if ((reg >> 14) & 1) {
+		if (reg & IO_APIC_REDIR_REMOTE_IRR) {
 			spin_unlock_irqrestore(&ioapic_lock, flags);
 			return true;
 		}
@@ -298,7 +298,7 @@ static void __target_IO_APIC_irq(unsigne
 			break;
 		io_apic_write(apic, 0x11 + pin*2, dest);
 		reg = io_apic_read(apic, 0x10 + pin*2);
-		reg &= ~0x000000ff;
+		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
 		io_apic_modify(apic, reg);
 		if (!entry->next)
@@ -366,10 +366,11 @@ static void add_pin_to_irq(unsigned int 
 	static void name##_IO_APIC_irq (unsigned int irq)		\
 	__DO_ACTION(R, ACTION, FINAL)
 
-DO_ACTION( __mask,             0, |= 0x00010000, io_apic_sync(entry->apic) )
-						/* mask = 1 */
-DO_ACTION( __unmask,           0, &= 0xfffeffff, )
-						/* mask = 0 */
+/* mask = 1 */
+DO_ACTION(__mask,	0, |= IO_APIC_REDIR_MASKED, io_apic_sync(entry->apic))
+
+/* mask = 0 */
+DO_ACTION(__unmask,	0, &= ~IO_APIC_REDIR_MASKED, )
 
 static void mask_IO_APIC_irq (unsigned int irq)
 {
Index: linux-2.6.git/arch/x86/kernel/io_apic_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic_32.c	2008-06-07 19:29:26.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic_32.c	2008-06-07 19:35:21.000000000 +0400
@@ -261,25 +261,27 @@ static void __modify_IO_APIC_irq (unsign
 /* mask = 1 */
 static void __mask_IO_APIC_irq (unsigned int irq)
 {
-	__modify_IO_APIC_irq(irq, 0x00010000, 0);
+	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED, 0);
 }
 
 /* mask = 0 */
 static void __unmask_IO_APIC_irq (unsigned int irq)
 {
-	__modify_IO_APIC_irq(irq, 0, 0x00010000);
+	__modify_IO_APIC_irq(irq, 0, IO_APIC_REDIR_MASKED);
 }
 
 /* mask = 1, trigger = 0 */
 static void __mask_and_edge_IO_APIC_irq (unsigned int irq)
 {
-	__modify_IO_APIC_irq(irq, 0x00010000, 0x00008000);
+	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_MASKED,
+				IO_APIC_REDIR_LEVEL_TRIGGER);
 }
 
 /* mask = 0, trigger = 1 */
 static void __unmask_and_level_IO_APIC_irq (unsigned int irq)
 {
-	__modify_IO_APIC_irq(irq, 0x00008000, 0x00010000);
+	__modify_IO_APIC_irq(irq, IO_APIC_REDIR_LEVEL_TRIGGER,
+				IO_APIC_REDIR_MASKED);
 }
 
 static void mask_IO_APIC_irq (unsigned int irq)

-- 
