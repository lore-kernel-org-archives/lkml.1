Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbZACK11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbZACK11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759942AbZACK0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:26:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937AbZACK0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:26:44 -0500
Subject: [PATCH -tip 3/7] x86: rename mpc_config_processor to mpc_cpu
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:48:52 +0530
Message-Id: <1230977932.6138.24.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, smaller names, solves 80 columns wrap problem

mpc_config_processor should be renamed to mpc_cpu.
The reason: the 'c' in MPC already means 'config' -
no need to repeat that in the type name.
Plus 'processor' is a lot longer than 'cpu' - so we try to use 'cpu' in all
type names, as much as possible.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/genapic_32.h |    2 +-
 arch/x86/include/asm/mpspec_def.h |    2 +-
 arch/x86/include/asm/setup.h      |    4 ++--
 arch/x86/kernel/mpparse.c         |   10 ++++------
 arch/x86/kernel/numaq_32.c        |    2 +-
 arch/x86/kernel/visws_quirks.c    |    4 ++--
 6 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 057e2c2..2c05b73 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -17,7 +17,7 @@
 
 struct mpc_bus;
 struct mpc_table;
-struct mpc_config_processor;
+struct mpc_cpu;
 
 struct genapic {
 	char *name;
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index daa3f4a..7e8ca51 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -70,7 +70,7 @@ struct mpc_table {
 #define CPU_MODEL_MASK		0x00F0
 #define CPU_FAMILY_MASK		0x0F00
 
-struct mpc_config_processor {
+struct mpc_cpu {
 	unsigned char mpc_type;
 	unsigned char mpc_apicid;	/* Local APIC number */
 	unsigned char mpc_apicver;	/* Its versions */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 26754ca..8cf77ec 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -25,7 +25,7 @@ extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
  */
-struct mpc_config_processor;
+struct mpc_cpu;
 struct mpc_bus;
 struct mp_config_oemtable;
 struct x86_quirks {
@@ -39,7 +39,7 @@ struct x86_quirks {
 	int (*mach_find_smp_config)(unsigned int reserve);
 
 	int *mpc_record;
-	int (*mpc_apic_id)(struct mpc_config_processor *m);
+	int (*mpc_apic_id)(struct mpc_cpu *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index edbd2b1..1ec13bb 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -49,7 +49,7 @@ static int __init mpf_checksum(unsigned char *mp, int len)
 	return sum & 0xFF;
 }
 
-static void __init MP_processor_info(struct mpc_config_processor *m)
+static void __init MP_processor_info(struct mpc_cpu *m)
 {
 	int apicid;
 	char *bootup_cpu = "";
@@ -327,8 +327,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		switch (*mpt) {
 		case MP_PROCESSOR:
 			{
-				struct mpc_config_processor *m =
-				    (struct mpc_config_processor *)mpt;
+				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
 				/* ACPI may have already provided this data */
 				if (!acpi_lapic)
 					MP_processor_info(m);
@@ -534,7 +533,7 @@ static inline void __init construct_ioapic_table(int mpc_default_type) { }
 
 static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 {
-	struct mpc_config_processor processor;
+	struct mpc_cpu processor;
 	struct mpc_config_lintsrc lintsrc;
 	int linttypes[2] = { mp_ExtINT, mp_NMI };
 	int i;
@@ -858,8 +857,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		switch (*mpt) {
 		case MP_PROCESSOR:
 			{
-				struct mpc_config_processor *m =
-				    (struct mpc_config_processor *)mpt;
+				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
 				mpt += sizeof(*m);
 				count += sizeof(*m);
 				break;
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 8135426..bcc3da1 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -117,7 +117,7 @@ static inline int generate_logical_apicid(int quad, int phys_apicid)
 }
 
 /* x86_quirks member */
-static int mpc_apic_id(struct mpc_config_processor *m)
+static int mpc_apic_id(struct mpc_cpu *m)
 {
 	int quad = translation_table[mpc_record]->trans_quad;
 	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 0c9667f..ca12afa 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -176,7 +176,7 @@ static int __init visws_get_smp_config(unsigned int early)
  * No problem for Linux.
  */
 
-static void __init MP_processor_info(struct mpc_config_processor *m)
+static void __init MP_processor_info(struct mpc_cpu *m)
 {
 	int ver, logical_apicid;
 	physid_mask_t apic_cpus;
@@ -218,7 +218,7 @@ static void __init MP_processor_info(struct mpc_config_processor *m)
 
 static int __init visws_find_smp_config(unsigned int reserve)
 {
-	struct mpc_config_processor *mp = phys_to_virt(CO_CPU_TAB_PHYS);
+	struct mpc_cpu *mp = phys_to_virt(CO_CPU_TAB_PHYS);
 	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
 
 	if (ncpus > CO_CPU_MAX) {
-- 
1.5.5.1



