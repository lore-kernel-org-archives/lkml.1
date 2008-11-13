Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYKMTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYKMTip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYKMTeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:15 -0500
Received: from gw.goop.org ([64.81.55.164]:34377 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYKMTeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:06 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 38] xen/dom0: handle acpi lapic parsing in Xen dom0
X-Mercurial-Node: 8746d15feae8927374811977f6e046c493665372
Message-Id: <8746d15feae892737481.1226603410@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running in Xen dom0, we still want to parse the ACPI tables to
find out about local and IO apics, but we don't want to actually use
the lapics.

Put a couple of tests for Xen to prevent lapics from being mapped or
accessed.  This is very Xen-specific behaviour, so there didn't seem to
be any point in adding more indirection.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/hypervisor.h |    2 ++
 arch/x86/kernel/acpi/boot.c           |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -46,6 +46,8 @@
 extern enum xen_domain_type xen_domain_type;
 
 #ifdef CONFIG_XEN
+#include <xen/interface/xen.h>
+
 #define xen_domain()		(xen_domain_type != XEN_NATIVE)
 #else
 #define xen_domain()		(0)
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -42,6 +42,8 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include <asm/xen/hypervisor.h>
+
 #ifdef CONFIG_X86_LOCAL_APIC
 # include <mach_apic.h>
 #endif
@@ -234,6 +236,10 @@
 {
 	unsigned int ver = 0;
 
+	/* We don't want to register lapics when in Xen dom0 */
+	if (xen_initial_domain())
+		return;
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
@@ -755,6 +761,10 @@
 
 static void __init acpi_register_lapic_address(unsigned long address)
 {
+	/* Xen dom0 doesn't have usable lapics */
+	if (xen_initial_domain())
+		return;
+
 	mp_lapic_addr = address;
 
 	set_fixmap_nocache(FIX_APIC_BASE, address);


