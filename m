Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbZEHAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbZEHAUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbZEHAKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:24 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52713
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755386AbZEHAJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:59 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/18] xen: pre-initialize legacy irqs early
Date: Thu,  7 May 2009 14:14:34 -0700
Message-Id: <1241730883-4917-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730883-4917-1-git-send-email-jeremy@goop.org>
References: <1241730883-4917-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: ISA/legacy device compat

Various legacy devices, such as IDE, assume their legacy interrupts are
already initialized and are immediately usable.  Pre-initialize all the
legacy interrupts.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 0f3663c..fb408ce 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -62,9 +62,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 void __init xen_setup_pirqs(void)
 {
-#ifdef CONFIG_ACPI
 	int irq;
 
+#ifdef CONFIG_ACPI
 	/*
 	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
 	 */
@@ -76,4 +76,8 @@ void __init xen_setup_pirqs(void)
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

