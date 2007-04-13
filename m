Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXDMPwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXDMPwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbXDMPwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:52:51 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39217 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753362AbXDMPwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:52:50 -0400
Date: Fri, 13 Apr 2007 17:52:38 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
cc: Andi Kleen <ak@suse.de>, Dave Jones <davej@codemonkey.org.uk>,
       Bernhard Kaindl <bk@suse.de>
Subject: [PATCH 3/4] Save and restore the fixed-range MTRRs of the BSP when
 suspending
Message-ID: <Pine.LNX.4.64.0704131751220.17956@jbgna.fhfr.qr>
References: <20070413121533.082325752@mahler.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>

---
 arch/i386/power/cpu.c        |    1 +
 arch/x86_64/kernel/suspend.c |    1 +
 2 files changed, 2 insertions(+)

Index: 2.6.21-rc6-mm1/arch/i386/power/cpu.c
===================================================================
--- 2.6.21-rc6-mm1.orig/arch/i386/power/cpu.c
+++ 2.6.21-rc6-mm1/arch/i386/power/cpu.c
@@ -21,6 +21,7 @@ unsigned long saved_context_eflags;

 void __save_processor_state(struct saved_context *ctxt)
 {
+	mtrr_save_fixed_ranges(NULL);
 	kernel_fpu_begin();

 	/*
Index: 2.6.21-rc6-mm1/arch/x86_64/kernel/suspend.c
===================================================================
--- 2.6.21-rc6-mm1.orig/arch/x86_64/kernel/suspend.c
+++ 2.6.21-rc6-mm1/arch/x86_64/kernel/suspend.c
@@ -48,6 +48,7 @@ void __save_processor_state(struct saved
 	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
 	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
 	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+	mtrr_save_fixed_ranges(NULL);

 	/*
 	 * control registers

-- 
Bernhard Kaindl
