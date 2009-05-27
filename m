Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbZE0Hln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbZE0Hln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761739AbZE0HiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:38:08 -0400
Received: from claw.goop.org ([74.207.240.146]:41734 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbZE0HiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:38:06 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/17] xen: don't setup acpi interrupt unless there is one
Date: Wed, 27 May 2009 00:37:24 -0700
Message-Id: <1243409850-21577-12-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

If the SCI hasn't been set, then presumably we're not running
with acpi, don't bother setting up the interrupt.

[ Impact: compatibility with pre-ACPI machines ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/pci.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/pci.c b/arch/x86/xen/pci.c
index 402a5bd..00ad6df 100644
--- a/arch/x86/xen/pci.c
+++ b/arch/x86/xen/pci.c
@@ -69,13 +69,12 @@ void __init xen_setup_pirqs(void)
 	/*
 	 * Set up acpi interrupt in acpi_gbl_FADT.sci_interrupt.
 	 */
-	irq = xen_allocate_pirq(acpi_gbl_FADT.sci_interrupt);
+	if (acpi_gbl_FADT.sci_interrupt > 0) {
+		irq = xen_allocate_pirq(acpi_gbl_FADT.sci_interrupt);
 
-	printk(KERN_INFO "xen: allocated irq %d for acpi %d\n",
-	       irq, acpi_gbl_FADT.sci_interrupt);
-
-	/* Blerk. */
-	acpi_gbl_FADT.sci_interrupt = irq;
+		printk(KERN_INFO "xen: allocated irq %d for acpi %d\n",
+		       irq, acpi_gbl_FADT.sci_interrupt);
+	}
 #endif
 
 	/* Pre-allocate legacy irqs */
-- 
1.6.0.6

