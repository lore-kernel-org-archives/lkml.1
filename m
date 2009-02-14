Return-Path: <linux-kernel-owner+w=401wt.eu-S1764679AbZBNBuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764679AbZBNBuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbZBNBoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:44:00 -0500
Received: from gw.goop.org ([64.81.55.164]:51051 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932703AbZBNBn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:43:57 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 1/9] xen/dom0: handle acpi lapic parsing in Xen dom0
Date: Fri, 13 Feb 2009 17:11:59 -0800
Message-Id: <3c7db30686056c9b86cc61ef50dd5572de868512.1234573847.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234573847.git.jeremy.fitzhardinge@citrix.com>
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
index 956c1de..32bacfe 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -42,6 +42,8 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
+#include <asm/xen/hypervisor.h>
+
 static int __initdata acpi_force = 0;
 u32 acpi_rsdt_forced;
 #ifdef	CONFIG_ACPI
@@ -219,6 +221,10 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
+	/* We don't want to register lapics when in Xen dom0 */
+	if (xen_initial_domain())
+		return;
+
 	if (!enabled) {
 		++disabled_cpus;
 		return;
@@ -755,6 +761,10 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
 
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

