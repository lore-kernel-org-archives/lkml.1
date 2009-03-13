Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbZCMQos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbZCMQos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759265AbZCMQnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:43:13 -0400
Received: from gw.goop.org ([64.81.55.164]:57276 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759386AbZCMQnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:43:11 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/17] xen: pre-initialize legacy irqs early
Date: Fri, 13 Mar 2009 09:42:30 -0700
Message-Id: <1236962558-13748-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Various legacy devices, such as IDE, assume their legacy interrupts are
already initialized and are immediately usable.  Pre-initialize all the
legacy interrupts.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 61f070c..d661c74 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -60,9 +60,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 void __init xen_setup_pirqs(void)
 {
-#ifdef CONFIG_ACPI
 	int irq;
 
+#ifdef CONFIG_ACPI
 	/*
 	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
 	 */
@@ -74,4 +74,8 @@ void __init xen_setup_pirqs(void)
 	/* Blerk. */
 	acpi_gbl_FADT.sci_interrupt = irq;
 #endif
+
+	/* Pre-allocate legacy irqs */
+	for (irq=0; irq < NR_IRQS_LEGACY; irq++)
+		xen_allocate_pirq(irq);
 }
-- 
1.6.0.6

