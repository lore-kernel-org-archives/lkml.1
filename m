Return-Path: <linux-kernel-owner+w=401wt.eu-S1030192AbXDCOGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030192AbXDCOGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030196AbXDCOGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:06:15 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:47754 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030192AbXDCOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:06:13 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 10:06:13 EDT
Date: Tue, 3 Apr 2007 16:05:46 +0200 (CEST)
From: Bernhard Kaindl <bk@suse.de>
To: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@suse.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jan Beulich <jbeulich@novell.com>
Subject: [PATCH 3/4] BSP: save and restore fixed-range MTRRs during suspend
In-Reply-To: <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
Message-ID: <Pine.LNX.4.64.0704031601220.7626@jbgna.fhfr.qr>
References: <Pine.LNX.4.64.0703211730140.2519@jbgna.fhfr.qr>
 <200703272213.51947.ak@suse.de> <Pine.LNX.4.64.0703281155490.17746@jbgna.fhfr.qr>
 <200703291525.59116.ak@suse.de> <Pine.LNX.4.64.0703301702320.21293@jbgna.fhfr.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

--- linux-2.6.20/arch/i386/power/cpu.c
+++ linux-2.6.20/arch/i386/power/cpu.c
@@ -21,6 +21,7 @@ unsigned long saved_context_eflags;

 void __save_processor_state(struct saved_context *ctxt)
 {
+	mtrr_save_fixed_ranges(NULL);
 	kernel_fpu_begin();

 	/*
--- linux-2.6.20/arch/x86_64/kernel/suspend.c
+++ linux-2.6.20/arch/x86_64/kernel/suspend.c
@@ -46,6 +46,7 @@ void __save_processor_state(struct saved
 	rdmsrl(MSR_FS_BASE, ctxt->fs_base);
 	rdmsrl(MSR_GS_BASE, ctxt->gs_base);
 	rdmsrl(MSR_KERNEL_GS_BASE, ctxt->gs_kernel_base);
+	mtrr_save_fixed_ranges(NULL);

 	/*
 	 * control registers
