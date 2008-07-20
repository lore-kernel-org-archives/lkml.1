Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYGTBDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYGTBDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 21:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYGTBDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 21:03:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:5944 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYGTBDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 21:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=aqZmOQKInmt7zORjL2eWmMrtJHB6gX640/h9h6D06DPrmxSuujdddsuA15e4xIS4NH
         EEVqJWPvJmL7tbGJje8LtMuoLyuOyHM5QMJZYFE19ZmJsUpQtVTtTagxMb6BBZW4SEsl
         hhlEYCMRWI5Xd0JU7XT//ttsjicNBRwXtO4rM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: use x86_ops with numaq
Date: Sat, 19 Jul 2008 18:01:16 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807190207.26077.yhlu.kernel@gmail.com>
In-Reply-To: <200807190207.26077.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807191801.17143.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move numaq related mps table handling to numaq_32.c

also moving calling to smp_read_mpc_oem() to smp_read_mpc directly

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/mpparse.c                  |  191 +++--------------------------
 arch/x86/kernel/numaq_32.c                 |  190 +++++++++++++++++++++++++++-
 include/asm-x86/mach-generic/mach_mpspec.h |    2 
 include/asm-x86/setup.h                    |   10 +
 4 files changed, 212 insertions(+), 181 deletions(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -49,76 +49,6 @@ static int __init mpf_checksum(unsigned
 	return sum & 0xFF;
 }
 
-#ifdef CONFIG_X86_NUMAQ
-int found_numaq;
-/*
- * Have to match translation table entries to main table entries by counter
- * hence the mpc_record variable .... can't see a less disgusting way of
- * doing this ....
- */
-struct mpc_config_translation {
-	unsigned char mpc_type;
-	unsigned char trans_len;
-	unsigned char trans_type;
-	unsigned char trans_quad;
-	unsigned char trans_global;
-	unsigned char trans_local;
-	unsigned short trans_reserved;
-};
-
-
-static int mpc_record;
-static struct mpc_config_translation *translation_table[MAX_MPC_ENTRY]
-    __cpuinitdata;
-
-static inline int generate_logical_apicid(int quad, int phys_apicid)
-{
-	return (quad << 4) + (phys_apicid ? phys_apicid << 1 : 1);
-}
-
-
-static inline int mpc_apic_id(struct mpc_config_processor *m,
-			struct mpc_config_translation *translation_record)
-{
-	int quad = translation_record->trans_quad;
-	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
-
-	printk(KERN_DEBUG "Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
-	       m->mpc_apicid,
-	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
-	       m->mpc_apicver, quad, logical_apicid);
-	return logical_apicid;
-}
-
-int mp_bus_id_to_node[MAX_MP_BUSSES];
-
-int mp_bus_id_to_local[MAX_MP_BUSSES];
-
-static void mpc_oem_bus_info(struct mpc_config_bus *m, char *name,
-	struct mpc_config_translation *translation)
-{
-	int quad = translation->trans_quad;
-	int local = translation->trans_local;
-
-	mp_bus_id_to_node[m->mpc_busid] = quad;
-	mp_bus_id_to_local[m->mpc_busid] = local;
-	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
-	       m->mpc_busid, name, quad);
-}
-
-int quad_local_to_mp_bus_id [NR_CPUS/4][4];
-static void mpc_oem_pci_bus(struct mpc_config_bus *m,
-	struct mpc_config_translation *translation)
-{
-	int quad = translation->trans_quad;
-	int local = translation->trans_local;
-
-	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
-}
-
-#endif
-
 static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
 {
 	int apicid;
@@ -128,14 +58,12 @@ static void __cpuinit MP_processor_info(
 		disabled_cpus++;
 		return;
 	}
-#ifdef CONFIG_X86_NUMAQ
-	if (found_numaq)
-		apicid = mpc_apic_id(m, translation_table[mpc_record]);
+
+	if (x86_ops->mpc_apic_id)
+		apicid = x86_ops->mpc_apic_id(m);
 	else
 		apicid = m->mpc_apicid;
-#else
-	apicid = m->mpc_apicid;
-#endif
+
 	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
 		boot_cpu_physical_apicid = m->mpc_apicid;
@@ -152,12 +80,10 @@ static void __init MP_bus_info(struct mp
 	memcpy(str, m->mpc_bustype, 6);
 	str[6] = 0;
 
-#ifdef CONFIG_X86_NUMAQ
-	if (found_numaq)
-		mpc_oem_bus_info(m, str, translation_table[mpc_record]);
-#else
-	printk(KERN_INFO "Bus #%d is %s\n", m->mpc_busid, str);
-#endif
+	if (x86_ops->mpc_oem_bus_info)
+		x86_ops->mpc_oem_bus_info(m, str);
+	else
+		printk(KERN_INFO "Bus #%d is %s\n", m->mpc_busid, str);
 
 #if MAX_MP_BUSSES < 256
 	if (m->mpc_busid >= MAX_MP_BUSSES) {
@@ -174,10 +100,9 @@ static void __init MP_bus_info(struct mp
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
-#ifdef CONFIG_X86_NUMAQ
-		if (found_numaq)
-			mpc_oem_pci_bus(m, translation_table[mpc_record]);
-#endif
+		if (x86_ops->mpc_oem_pci_bus)
+			x86_ops->mpc_oem_pci_bus(m);
+
 		clear_bit(m->mpc_busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined (CONFIG_MCA)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_PCI;
@@ -317,83 +242,6 @@ static void __init MP_lintsrc_info(struc
 		m->mpc_srcbusirq, m->mpc_destapic, m->mpc_destapiclint);
 }
 
-#ifdef CONFIG_X86_NUMAQ
-static void __init MP_translation_info(struct mpc_config_translation *m)
-{
-	printk(KERN_INFO
-	       "Translation: record %d, type %d, quad %d, global %d, local %d\n",
-	       mpc_record, m->trans_type, m->trans_quad, m->trans_global,
-	       m->trans_local);
-
-	if (mpc_record >= MAX_MPC_ENTRY)
-		printk(KERN_ERR "MAX_MPC_ENTRY exceeded!\n");
-	else
-		translation_table[mpc_record] = m;	/* stash this for later */
-	if (m->trans_quad < MAX_NUMNODES && !node_online(m->trans_quad))
-		node_set_online(m->trans_quad);
-}
-
-/*
- * Read/parse the MPC oem tables
- */
-
-static void __init smp_read_mpc_oem(struct mp_config_oemtable *oemtable,
-				    unsigned short oemsize)
-{
-	int count = sizeof(*oemtable);	/* the header size */
-	unsigned char *oemptr = ((unsigned char *)oemtable) + count;
-
-	mpc_record = 0;
-	printk(KERN_INFO "Found an OEM MPC table at %8p - parsing it ... \n",
-	       oemtable);
-	if (memcmp(oemtable->oem_signature, MPC_OEM_SIGNATURE, 4)) {
-		printk(KERN_WARNING
-		       "SMP mpc oemtable: bad signature [%c%c%c%c]!\n",
-		       oemtable->oem_signature[0], oemtable->oem_signature[1],
-		       oemtable->oem_signature[2], oemtable->oem_signature[3]);
-		return;
-	}
-	if (mpf_checksum((unsigned char *)oemtable, oemtable->oem_length)) {
-		printk(KERN_WARNING "SMP oem mptable: checksum error!\n");
-		return;
-	}
-	while (count < oemtable->oem_length) {
-		switch (*oemptr) {
-		case MP_TRANSLATION:
-			{
-				struct mpc_config_translation *m =
-				    (struct mpc_config_translation *)oemptr;
-				MP_translation_info(m);
-				oemptr += sizeof(*m);
-				count += sizeof(*m);
-				++mpc_record;
-				break;
-			}
-		default:
-			{
-				printk(KERN_WARNING
-				       "Unrecognised OEM table entry type! - %d\n",
-				       (int)*oemptr);
-				return;
-			}
-		}
-	}
-}
-
-void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				 char *productid)
-{
-	if (strncmp(oem, "IBM NUMA", 8))
-		printk("Warning!  Not a NUMA-Q system!\n");
-	else
-		found_numaq = 1;
-
-	if (mpc->mpc_oemptr)
-		smp_read_mpc_oem((struct mp_config_oemtable *)mpc->mpc_oemptr,
-				 mpc->mpc_oemsize);
-}
-#endif /* CONFIG_X86_NUMAQ */
-
 /*
  * Read/parse the MPC
  */
@@ -458,7 +306,6 @@ static int __init smp_read_mpc(struct mp
 	} else
 		mps_oem_check(mpc, oem, str);
 #endif
-
 	/* save the local APIC address, it might be non-default */
 	if (!acpi_lapic)
 		mp_lapic_addr = mpc->mpc_lapic;
@@ -466,12 +313,17 @@ static int __init smp_read_mpc(struct mp
 	if (early)
 		return 1;
 
+	if (mpc->mpc_oemptr && x86_ops->smp_read_mpc_oem) {
+		struct mp_config_oemtable *oem_table = (struct mp_config_oemtable *)(unsigned long)mpc->mpc_oemptr;
+		x86_ops->smp_read_mpc_oem(oem_table, mpc->mpc_oemsize);
+	}
+
 	/*
 	 *      Now process the configuration blocks.
 	 */
-#ifdef CONFIG_X86_NUMAQ
-	mpc_record = 0;
-#endif
+	if (x86_ops->mpc_record)
+		*x86_ops->mpc_record = 0;
+
 	while (count < mpc->mpc_length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
@@ -537,9 +389,8 @@ static int __init smp_read_mpc(struct mp
 			count = mpc->mpc_length;
 			break;
 		}
-#ifdef CONFIG_X86_NUMAQ
-		++mpc_record;
-#endif
+		if (x86_ops->mpc_record)
+			(*x86_ops->mpc_record)++;
 	}
 
 #ifdef CONFIG_X86_GENERICARCH
Index: linux-2.6/arch/x86/kernel/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/numaq_32.c
+++ linux-2.6/arch/x86/kernel/numaq_32.c
@@ -33,6 +33,7 @@
 #include <asm/processor.h>
 #include <asm/mpspec.h>
 #include <asm/e820.h>
+#include <asm/setup.h>
 
 #define	MB_TO_PAGES(addr) ((addr) << (20 - PAGE_SHIFT))
 
@@ -71,6 +72,181 @@ static void __init smp_dump_qct(void)
 	}
 }
 
+
+void __init numaq_tsc_disable(void)
+{
+	if (!found_numaq)
+		return;
+
+	if (num_online_nodes() > 1) {
+		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
+		setup_clear_cpu_cap(X86_FEATURE_TSC);
+	}
+}
+
+int found_numaq;
+/*
+ * Have to match translation table entries to main table entries by counter
+ * hence the mpc_record variable .... can't see a less disgusting way of
+ * doing this ....
+ */
+struct mpc_config_translation {
+	unsigned char mpc_type;
+	unsigned char trans_len;
+	unsigned char trans_type;
+	unsigned char trans_quad;
+	unsigned char trans_global;
+	unsigned char trans_local;
+	unsigned short trans_reserved;
+};
+
+/* x86_ops member */
+static int mpc_record;
+static struct mpc_config_translation *translation_table[MAX_MPC_ENTRY]
+    __cpuinitdata;
+
+static inline int generate_logical_apicid(int quad, int phys_apicid)
+{
+	return (quad << 4) + (phys_apicid ? phys_apicid << 1 : 1);
+}
+
+/* x86_ops member */
+static int mpc_apic_id(struct mpc_config_processor *m)
+{
+	int quad = translation_table[mpc_record]->trans_quad;
+	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
+
+	printk(KERN_DEBUG "Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
+	       m->mpc_apicid,
+	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
+	       m->mpc_apicver, quad, logical_apicid);
+	return logical_apicid;
+}
+
+int mp_bus_id_to_node[MAX_MP_BUSSES];
+
+int mp_bus_id_to_local[MAX_MP_BUSSES];
+
+/* x86_ops member */
+static void mpc_oem_bus_info(struct mpc_config_bus *m, char *name)
+{
+	int quad = translation_table[mpc_record]->trans_quad;
+	int local = translation_table[mpc_record]->trans_local;
+
+	mp_bus_id_to_node[m->mpc_busid] = quad;
+	mp_bus_id_to_local[m->mpc_busid] = local;
+	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
+	       m->mpc_busid, name, quad);
+}
+
+int quad_local_to_mp_bus_id [NR_CPUS/4][4];
+
+/* x86_ops member */
+static void mpc_oem_pci_bus(struct mpc_config_bus *m)
+{
+	int quad = translation_table[mpc_record]->trans_quad;
+	int local = translation_table[mpc_record]->trans_local;
+
+	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
+}
+
+static void __init MP_translation_info(struct mpc_config_translation *m)
+{
+	printk(KERN_INFO
+	       "Translation: record %d, type %d, quad %d, global %d, local %d\n",
+	       mpc_record, m->trans_type, m->trans_quad, m->trans_global,
+	       m->trans_local);
+
+	if (mpc_record >= MAX_MPC_ENTRY)
+		printk(KERN_ERR "MAX_MPC_ENTRY exceeded!\n");
+	else
+		translation_table[mpc_record] = m;	/* stash this for later */
+	if (m->trans_quad < MAX_NUMNODES && !node_online(m->trans_quad))
+		node_set_online(m->trans_quad);
+}
+
+static int __init mpf_checksum(unsigned char *mp, int len)
+{
+	int sum = 0;
+
+	while (len--)
+		sum += *mp++;
+
+	return sum & 0xFF;
+}
+
+/*
+ * Read/parse the MPC oem tables
+ */
+
+static void __init smp_read_mpc_oem(struct mp_config_oemtable *oemtable,
+				    unsigned short oemsize)
+{
+	int count = sizeof(*oemtable);	/* the header size */
+	unsigned char *oemptr = ((unsigned char *)oemtable) + count;
+
+	mpc_record = 0;
+	printk(KERN_INFO "Found an OEM MPC table at %8p - parsing it ... \n",
+	       oemtable);
+	if (memcmp(oemtable->oem_signature, MPC_OEM_SIGNATURE, 4)) {
+		printk(KERN_WARNING
+		       "SMP mpc oemtable: bad signature [%c%c%c%c]!\n",
+		       oemtable->oem_signature[0], oemtable->oem_signature[1],
+		       oemtable->oem_signature[2], oemtable->oem_signature[3]);
+		return;
+	}
+	if (mpf_checksum((unsigned char *)oemtable, oemtable->oem_length)) {
+		printk(KERN_WARNING "SMP oem mptable: checksum error!\n");
+		return;
+	}
+	while (count < oemtable->oem_length) {
+		switch (*oemptr) {
+		case MP_TRANSLATION:
+			{
+				struct mpc_config_translation *m =
+				    (struct mpc_config_translation *)oemptr;
+				MP_translation_info(m);
+				oemptr += sizeof(*m);
+				count += sizeof(*m);
+				++mpc_record;
+				break;
+			}
+		default:
+			{
+				printk(KERN_WARNING
+				       "Unrecognised OEM table entry type! - %d\n",
+				       (int)*oemptr);
+				return;
+			}
+		}
+	}
+}
+
+static struct x86_ops numaq_x86_ops __initdata = {
+	.arch_time_init		= NULL,
+	.arch_pre_intr_init	= NULL,
+	.arch_memory_setup	= NULL,
+	.arch_intr_init		= NULL,
+	.arch_trap_init		= NULL,
+	.mach_get_smp_config	= NULL,
+	.mach_find_smp_config	= NULL,
+	.mpc_record		= &mpc_record,
+	.mpc_apic_id		= mpc_apic_id,
+	.mpc_oem_bus_info	= mpc_oem_bus_info,
+	.mpc_oem_pci_bus	= mpc_oem_pci_bus,
+	.smp_read_mpc_oem	= smp_read_mpc_oem,
+};
+
+void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
+				 char *productid)
+{
+	if (strncmp(oem, "IBM NUMA", 8))
+		printk("Warning!  Not a NUMA-Q system!\n");
+	else
+		found_numaq = 1;
+}
+
 static __init void early_check_numaq(void)
 {
 	/*
@@ -82,6 +258,9 @@ static __init void early_check_numaq(voi
 	 */
 	if (smp_found_config)
 		early_get_smp_config();
+
+	if (found_numaq)
+		x86_ops = &numaq_x86_ops;
 }
 
 int __init get_memcfg_numaq(void)
@@ -92,14 +271,3 @@ int __init get_memcfg_numaq(void)
 	smp_dump_qct();
 	return 1;
 }
-
-void __init numaq_tsc_disable(void)
-{
-	if (!found_numaq)
-		return;
-
-	if (num_online_nodes() > 1) {
-		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
-		setup_clear_cpu_cap(X86_FEATURE_TSC);
-	}
-}
Index: linux-2.6/include/asm-x86/mach-generic/mach_mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-generic/mach_mpspec.h
+++ linux-2.6/include/asm-x86/mach-generic/mach_mpspec.h
@@ -7,4 +7,6 @@
 /* Maximum 256 PCI busses, plus 1 ISA bus in each of 4 cabinets. */
 #define MAX_MP_BUSSES 260
 
+extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
+				char *productid);
 #endif /* __ASM_MACH_MPSPEC_H */
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -19,6 +19,9 @@ static inline int is_visws_box(void) { r
 /*
  * Any setup quirks to be performed?
  */
+struct mpc_config_processor;
+struct mpc_config_bus;
+struct mp_config_oemtable;
 struct x86_ops {
 	int (*arch_time_init)(void);
 	int (*arch_pre_intr_init)(void);
@@ -27,6 +30,13 @@ struct x86_ops {
 	char * (*arch_memory_setup)(void);
 	int (*mach_get_smp_config)(unsigned int early);
 	int (*mach_find_smp_config)(unsigned int reserve);
+
+	int *mpc_record;
+	int (*mpc_apic_id)(struct mpc_config_processor *m);
+	void (*mpc_oem_bus_info)(struct mpc_config_bus *m, char *name);
+	void (*mpc_oem_pci_bus)(struct mpc_config_bus *m);
+	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
+                                    unsigned short oemsize);
 };
 
 extern struct x86_ops *x86_ops;
