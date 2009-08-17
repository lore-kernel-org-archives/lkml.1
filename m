Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZHQVhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZHQVhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZHQVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:37:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbZHQVhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:37:35 -0400
Date: Mon, 17 Aug 2009 23:37:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090817213719.GA3195@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Bartlomiej Zolnierkiewicz (1):
      x86, mce: don't log boot MCEs on Pentium M (model == 13) CPUs

Cliff Wickman (1):
      x86: Fix UV BAU destination subnode id

Hugh Dickins (1):
      x86, mce: therm_throt: Don't log redundant normality

Ingo Molnar (1):
      x86, mce: Don't initialize MCEs on unknown CPUs

Leonardo Potenza (1):
      x86: Annotate section mismatch warnings in kernel/apic/x2apic_uv_x.c


 arch/x86/include/asm/uv/uv_bau.h         |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c       |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce.c         |   19 ++++++++++++++++---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    7 +++++--
 arch/x86/kernel/tlb_uv.c                 |    1 +
 5 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index bddd44f..80e2984 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -133,7 +133,7 @@ struct bau_msg_payload {
  * see table 4.2.3.0.1 in broacast_assist spec.
  */
 struct bau_msg_header {
-	unsigned int dest_subnodeid:6;	/* must be zero */
+	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
 	unsigned int base_dest_nodeid:15; /* nasid>>1 (pnode) of */
 	/* bits 20:6 */			  /* first bit in node_map */
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 832e908..6011593 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -46,7 +46,7 @@ static int early_get_nodeid(void)
 	return node_id.s.node_id;
 }
 
-static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
 		if (!strcmp(oem_table_id, "UVL"))
@@ -253,7 +253,7 @@ static void uv_send_IPI_self(int vector)
 	apic_write(APIC_SELF_IPI, vector);
 }
 
-struct apic apic_x2apic_uv_x = {
+struct apic __refdata apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
 	.probe				= NULL,
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1cfb623..0121304 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1226,8 +1226,13 @@ static void mce_init(void)
 }
 
 /* Add per CPU specific workarounds here */
-static void mce_cpu_quirks(struct cpuinfo_x86 *c)
+static int mce_cpu_quirks(struct cpuinfo_x86 *c)
 {
+	if (c->x86_vendor == X86_VENDOR_UNKNOWN) {
+		pr_info("MCE: unknown CPU type - not enabling MCE support.\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
 		if (c->x86 == 15 && banks > 4) {
@@ -1273,11 +1278,20 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 		if ((c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xe)) &&
 			monarch_timeout < 0)
 			monarch_timeout = USEC_PER_SEC;
+
+		/*
+		 * There are also broken BIOSes on some Pentium M and
+		 * earlier systems:
+		 */
+		if (c->x86 == 6 && c->x86_model <= 13 && mce_bootlog < 0)
+			mce_bootlog = 0;
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
 	if (mce_bootlog != 0)
 		mce_panic_timeout = 30;
+
+	return 0;
 }
 
 static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
@@ -1338,11 +1352,10 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	if (!mce_available(c))
 		return;
 
-	if (mce_cap_init() < 0) {
+	if (mce_cap_init() < 0 || mce_cpu_quirks(c) < 0) {
 		mce_disabled = 1;
 		return;
 	}
-	mce_cpu_quirks(c);
 
 	machine_check_vector = do_machine_check;
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 8bc64cf..5957a93 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -116,11 +116,14 @@ static int therm_throt_process(int curr)
 		       cpu, __get_cpu_var(thermal_throttle_count));
 
 		add_taint(TAINT_MACHINE_CHECK);
-	} else if (was_throttled) {
+		return 1;
+	}
+	if (was_throttled) {
 		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 #ifdef CONFIG_SYSFS
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 8ccabb8..77b9689 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -744,6 +744,7 @@ uv_activation_descriptor_init(int node, int pnode)
 		 * note that base_dest_nodeid is actually a nasid.
 		 */
 		ad2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
+		ad2->header.dest_subnodeid = 0x10; /* the LB */
 		ad2->header.command = UV_NET_ENDPOINT_INTD;
 		ad2->header.int_both = 1;
 		/*
