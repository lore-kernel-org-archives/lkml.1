Return-Path: <linux-kernel-owner+w=401wt.eu-S1764039AbZE0Hi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764039AbZE0Hi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763852AbZE0Hhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:37:36 -0400
Received: from claw.goop.org ([74.207.240.146]:41638 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763840AbZE0Hhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:37:34 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/17] xen/dom0: handle acpi lapic parsing in Xen dom0
Date: Wed, 27 May 2009 00:37:14 -0700
Message-Id: <1243409850-21577-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running in Xen dom0, we still want to parse the ACPI tables to
find out about local and IO apics, but we don't want to actually use
the lapics.

Put a couple of tests for Xen to prevent lapics from being mapped or
accessed.  This is very Xen-specific behaviour, so there didn't seem to
be any point in adding more indirection.

[ Impact: ignore local apics, which are not usable under Xen ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/acpi/boot.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 723989d..4147e0c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -41,6 +41,8 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include <asm/xen/hypervisor.h>
+
 static int __initdata acpi_force = 0;
 u32 acpi_rsdt_forced;
 #ifdef	CONFIG_ACPI
@@ -218,6 +220,10 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
+	/* We don't want to register lapics when in Xen dom0 */
+	if (xen_initial_domain())
+		return;
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
@@ -802,6 +808,10 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 
 static void __init acpi_register_lapic_address(unsigned long address)
 {
+	/* Xen dom0 doesn't have usable lapics */
+	if (xen_initial_domain())
+		return;
+
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);
-- 
1.6.0.6

