Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbZFPUTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbZFPUTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759510AbZFPUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:19 -0400
Received: from claw.goop.org ([74.207.240.146]:40605 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbZFPUQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:10 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/16] x86/ioapic.c: unify __mask_IO_APIC_irq()
Date: Tue, 16 Jun 2009 13:15:46 -0700
Message-Id: <1245183355-25808-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The main difference between 32 and 64-bit __mask_IO_APIC_irq() does a
readback from the I/O APIC to synchronize it.

If there's a hardware requirement to do a readback sync after updating
an APIC register, then it will be a hardware requrement regardless of
whether the kernel is compiled 32 or 64-bit.

Unify __mask_IO_APIC_irq() using the 64-bit version which always syncs
with io_apic_sync().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 01aa429..e767bcb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -577,7 +577,6 @@ static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
-#ifdef CONFIG_X86_64
 static void io_apic_sync(struct irq_pin_list *entry)
 {
 	/*
@@ -593,12 +592,8 @@ static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 {
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
-#else /* CONFIG_X86_32 */
-static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
-{
-	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, NULL);
-}
 
+#ifdef CONFIG_X86_32
 static void __mask_and_edge_IO_APIC_irq(struct irq_cfg *cfg)
 {
 	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_LEVEL_TRIGGER,
-- 
1.6.2.2

