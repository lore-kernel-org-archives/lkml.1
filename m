Return-Path: <linux-kernel-owner+w=401wt.eu-S1764745AbZBNB0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764745AbZBNB0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762543AbZBNBNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:13:09 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:49178
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763639AbZBNBNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:13:06 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 9/9] xen: pre-initialize legacy irqs early
Date: Fri, 13 Feb 2009 17:12:07 -0800
Message-Id: <32e538eef4fe7581644814b3c96d6726456a5daa.1234573847.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <69aeef6bc01fbe1fdc6ebd41910e6dc8767b103c.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <3e46dae897fd5620f50b4cca9272969f5546aa88.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <79724b71f4b8ef1fb65ea246dde2e3e1344b2a43.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cbcff9ab54a2189156077c81c706fc30ba84344c.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <5b0148b366eaa87072ab261f71c4c545be8e607f.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <4e896f722e4175f96f3846896c3a7b627e634e7e.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <0e852da646969a2296f66cbc485f278fe1fa9929.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <69aeef6bc01fbe1fdc6ebd41910e6dc8767b103c.1234573847.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
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

