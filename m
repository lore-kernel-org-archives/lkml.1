Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZCMQmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZCMQmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZCMQmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:42:43 -0400
Received: from gw.goop.org ([64.81.55.164]:57236 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753212AbZCMQmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:42:43 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 01/17] xen/dom0: handle acpi lapic parsing in Xen dom0
Date: Fri, 13 Mar 2009 09:42:22 -0700
Message-Id: <1236962558-13748-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236962558-13748-1-git-send-email-jeremy@goop.org>
References: <1236962558-13748-1-git-send-email-jeremy@goop.org>
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
 arch/x86/kernel/acpi/boot.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index a18eb7c..6a5af13 100644
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
@@ -754,6 +760,10 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 
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

