Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbZE0Hla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbZE0Hla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761648AbZE0HiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:38:07 -0400
Received: from claw.goop.org ([74.207.240.146]:41718 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761524AbZE0HiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:38:05 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>, Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/17] xen: pre-initialize legacy irqs early
Date: Wed, 27 May 2009 00:37:23 -0700
Message-Id: <1243409850-21577-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Various legacy devices, such as IDE, assume their legacy interrupts are
already initialized and are immediately usable.  Pre-initialize all the
legacy interrupts.

[ Impact: ISA/legacy device compat ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index af4e898..402a5bd 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -63,9 +63,9 @@ int xen_register_gsi(u32 gsi, int triggering, int polarity)
 
 void __init xen_setup_pirqs(void)
 {
-#ifdef CONFIG_ACPI
 	int irq;
 
+#ifdef CONFIG_ACPI
 	/*
 	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
 	 */
@@ -77,4 +77,8 @@ void __init xen_setup_pirqs(void)
 	/* Blerk. */
 	acpi_gbl_FADT.sci_interrupt = irq;
 #endif
+
+	/* Pre-allocate legacy irqs */
+	for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
+		xen_allocate_pirq(irq);
 }
-- 
1.6.0.6

