Return-Path: <linux-kernel-owner+w=401wt.eu-S1763616AbZFPUSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763616AbZFPUSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761228AbZFPUQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:18 -0400
Received: from claw.goop.org ([74.207.240.146]:40585 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbZFPUQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/16] x86/ioapic.c: convert io_apic_level_ack_pending loop to normal for() loop
Date: Tue, 16 Jun 2009 13:15:50 -0700
Message-Id: <1245183355-25808-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Convert the unconventional loop in io_apic_level_ack_pending() to
a conventional for() loop.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 089a4e4..8ee2b14 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -408,13 +408,10 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	entry = cfg->irq_2_pin;
-	for (;;) {
+	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
 		unsigned int reg;
 		int pin;
 
-		if (!entry)
-			break;
 		pin = entry->pin;
 		reg = io_apic_read(entry->apic, 0x10 + pin*2);
 		/* Is the remote IRR bit set? */
@@ -422,9 +419,6 @@ static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 			spin_unlock_irqrestore(&ioapic_lock, flags);
 			return true;
 		}
-		if (!entry->next)
-			break;
-		entry = entry->next;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
-- 
1.6.2.2

