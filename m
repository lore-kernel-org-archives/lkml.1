Return-Path: <linux-kernel-owner+w=401wt.eu-S1423437AbXD3Ptj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423437AbXD3Ptj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423442AbXD3Pti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:49:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:44968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423437AbXD3Pth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: bk@suse.de, akpm@linux-foundation.org, ak@suse.de, davej@codemonkey.org.uk,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/34] x86: Save and restore the fixed-range MTRRs of the BSP when  suspending
Message-Id: <20070430154935.EDBA615206@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Bernhard Kaindl <bk@suse.de>
Note: This patch didn'nt need an update since it's initial post.

Some BIOSes may modify fixed-range MTRRs in SMM, e.g. when they
transition the system into ACPI mode, which is entered thru an SMI,
triggered by Linux in acpi_enable().

SMIs which cause that Linux is interrupted and BIOS code is
executed (which may change e.g. fixed-range MTRRs) in SMM may
be raised by an embedded system controller which is often found
in notebooks also at other occasions.

If we would not update our copy of the fixed-range MTRRs before
suspending to RAM or to disk, restore_processor_state() would
set the fixed-range MTRRs of the BSP using old backup values
which may be outdated and this could cause the system to fail
later during resume.

This patch ensures that our copy of the fixed-range MTRRs
is updated when saving the boot processor state on suspend
to disk and suspend to RAM.

In combination with other patches this allows to fix s2ram
and s2disk on the Acer Ferrari 1000 notebook and at least
s2disk on the Acer Ferrari 5000 notebook.

Signed-off-by: Bernhard Kaindl <bk@suse.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>

---
 arch/i386/power/cpu.c        |    1 +
 arch/x86_64/kernel/suspend.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux/arch/i386/power/cpu.c
===================================================================
--- linux.orig/arch/i386/power/cpu.c
+++ linux/arch/i386/power/cpu.c
@@ -21,6 +21,7 @@ unsigned long saved_context_eflags;
 
 void __save_processor_state(struct saved_context *ctxt)
 {
+	mtrr_save_fixed_ranges(NULL);
 	kernel_fpu_begin();
 
 	/*
Index: linux/arch/x86_64/kernel/suspend.c
===================================================================
--- linux.orig/arch/x86_64/kernel/suspend.c
+++ linux/arch/x86_64/kernel/suspend.c
@@ -48,6 +48,7 @@ void __save_processor_state(struct saved
 	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
 	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
 	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+	mtrr_save_fixed_ranges(NULL);
 
 	/*
 	 * control registers 
