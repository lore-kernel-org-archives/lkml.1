Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYDENuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYDENuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYDENt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:49:58 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:46570 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYDENt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=u7YdGOfeIR5A1vJl9T+dGM4WUBtqYLgtVmj0pkeoavEY035KnDKVThNeBlxcH8Gg4cLz8zNT4V6keWx+w0aKgAIwP1vbh4OdKJ0LGyXK/oejuJus8L1k5leQQ3RdzWBwexWQYpZqDwr1ZX6CAFlOt1XCfib5hbYQI76rAaxqsAg=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:04 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 1/9] x86: avoid redundant loop in io_apic_level_ack_pending()
Content-Disposition: inline; filename=x86-io-apic-optimize.patch
Message-ID: <47f78384.1aa57e0a.0200.49e9@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one can find an ack pending pin, there is no need to check
the rest of them.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/io_apic_64.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: 2.6-git/arch/x86/kernel/io_apic_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/io_apic_64.c
+++ 2.6-git/arch/x86/kernel/io_apic_64.c
@@ -155,11 +155,10 @@ static inline void io_apic_modify(unsign
 	writel(value, &io_apic->data);
 }
 
-static int io_apic_level_ack_pending(unsigned int irq)
+static bool io_apic_level_ack_pending(unsigned int irq)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
-	int pending = 0;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	entry = irq_2_pin + irq;
@@ -172,13 +171,17 @@ static int io_apic_level_ack_pending(uns
 			break;
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
-		pending |= (reg >> 14) & 1;
+		if ((reg >> 14) & 1) {
+			spin_unlock_irqrestore(&ioapic_lock, flags);
+			return true;
+		}
 		if (!entry->next)
 			break;
 		entry = irq_2_pin + entry->next;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
-	return pending;
+
+	return false;
 }
 
 /*

-- 
