Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZG0F1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZG0F1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZG0F1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:27:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZG0F1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:27:12 -0400
Date: Sun, 26 Jul 2009 22:26:20 -0700
Message-Id: <200907270526.n6R5QK5G032346@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86 fixes for 2.6.31-rc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 78af08d90b8f745044b1274430bc4bc6b2b27aca:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Alexey Fisher (1):
      x86: Add quirk for Intel DG45ID board to avoid low memory corruption

Andi Kleen (1):
      x86-64: Fix bad_srat() to clear all state

Catalin Marinas (1):
      x86: Include all of .data.* sections in _edata on 64-bit

Denis Turischev (1):
      x86: Add reboot fixup for SBC-fitPC2

H. Peter Anvin (1):
      x86: Fix movq immediate operand constraints in uaccess.h

Hidehiro Kawai (1):
      x86, mce: Rename incorrect macro name "CONFIG_X86_THRESHOLD"

Jan Beulich (1):
      x86, mce: Fix set_trigger() accessor

Jeremy Fitzhardinge (1):
      x86, amd: Don't probe for extended APIC ID if APICs are disabled

Thomas Gleixner (1):
      x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure

Uros Bizjak (1):
      x86: Fix movq immediate operand constraints in uaccess_64.h

 arch/x86/include/asm/uaccess.h    |    4 ++--
 arch/x86/include/asm/uaccess_64.h |   10 +++++-----
 arch/x86/kernel/cpu/amd.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c  |    6 ++----
 arch/x86/kernel/irqinit.c         |    2 +-
 arch/x86/kernel/mfgpt_32.c        |    2 +-
 arch/x86/kernel/reboot.c          |    8 ++++++++
 arch/x86/kernel/setup.c           |   13 +++++++++++++
 arch/x86/kernel/vmlinux.lds.S     |    7 -------
 arch/x86/mm/srat_64.c             |    6 ++++--
 10 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 20e6a79..d2c6c93 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -212,9 +212,9 @@ extern int __get_user_bad(void);
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
 #define __put_user_asm_u64(x, ptr, retval, errret) \
-	__put_user_asm(x, ptr, retval, "q", "", "Zr", errret)
+	__put_user_asm(x, ptr, retval, "q", "", "er", errret)
 #define __put_user_asm_ex_u64(x, addr)	\
-	__put_user_asm_ex(x, addr, "q", "", "Zr")
+	__put_user_asm_ex(x, addr, "q", "", "er")
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
 #endif
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 8cc6873..db24b21 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -88,11 +88,11 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
 			      ret, "l", "k", "ir", 4);
 		return ret;
 	case 8:__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			      ret, "q", "", "ir", 8);
+			      ret, "q", "", "er", 8);
 		return ret;
 	case 10:
 		__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			       ret, "q", "", "ir", 10);
+			       ret, "q", "", "er", 10);
 		if (unlikely(ret))
 			return ret;
 		asm("":::"memory");
@@ -101,12 +101,12 @@ int __copy_to_user(void __user *dst, const void *src, unsigned size)
 		return ret;
 	case 16:
 		__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			       ret, "q", "", "ir", 16);
+			       ret, "q", "", "er", 16);
 		if (unlikely(ret))
 			return ret;
 		asm("":::"memory");
 		__put_user_asm(1[(u64 *)src], 1 + (u64 __user *)dst,
-			       ret, "q", "", "ir", 8);
+			       ret, "q", "", "er", 8);
 		return ret;
 	default:
 		return copy_user_generic((__force void *)dst, src, size);
@@ -157,7 +157,7 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 			       ret, "q", "", "=r", 8);
 		if (likely(!ret))
 			__put_user_asm(tmp, (u64 __user *)dst,
-				       ret, "q", "", "ir", 8);
+				       ret, "q", "", "er", 8);
 		return ret;
 	}
 	default:
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 28e5f59..e2485b0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -356,7 +356,7 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
 	/* check CPU config space for extended APIC ID */
-	if (c->x86 >= 0xf) {
+	if (cpu_has_apic && c->x86 >= 0xf) {
 		unsigned int val;
 		val = read_pci_config(0, 24, 0, 0x68);
 		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 484c1e5..1cfb623 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1692,17 +1692,15 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 				const char *buf, size_t siz)
 {
 	char *p;
-	int len;
 
 	strncpy(mce_helper, buf, sizeof(mce_helper));
 	mce_helper[sizeof(mce_helper)-1] = 0;
-	len = strlen(mce_helper);
 	p = strchr(mce_helper, '\n');
 
-	if (*p)
+	if (p)
 		*p = 0;
 
-	return len;
+	return strlen(mce_helper) + !!p;
 }
 
 static ssize_t set_ignore_ce(struct sys_device *s,
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 696f0e4..92b7703 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -187,7 +187,7 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
-#ifdef CONFIG_X86_THRESHOLD
+#ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
 #if defined(CONFIG_X86_NEW_MCE) && defined(CONFIG_X86_LOCAL_APIC)
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 846510b..2a62d84 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -347,7 +347,7 @@ static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
 	.name = "mfgpt-timer"
 };
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d2d1ce8..508e982 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -249,6 +249,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
 		},
 	},
+	{	/* Handle problems with rebooting on CompuLab SBC-FITPC2 */
+		.callback = set_bios_reboot,
+		.ident = "CompuLab SBC-FITPC2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..63f32d2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -672,6 +672,19 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
 		},
 	},
+	{
+	/*
+	 * AMI BIOS with low memory corruption was found on Intel DG45ID board.
+	 * It hase different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
+	 * match only DMI_BOARD_NAME and see if there is more bad products
+	 * with this vendor.
+	 */
+		.callback = dmi_low_memory_corruption,
+		.ident = "AMI BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "DG45ID"),
+		},
+	},
 #endif
 	{}
 };
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 367e878..59f31d2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -112,11 +112,6 @@ SECTIONS
 		_sdata = .;
 		DATA_DATA
 		CONSTRUCTORS
-
-#ifdef CONFIG_X86_64
-		/* End of data section */
-		_edata = .;
-#endif
 	} :data
 
 #ifdef CONFIG_X86_32
@@ -156,10 +151,8 @@ SECTIONS
 	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
 		*(.data.read_mostly)
 
-#ifdef CONFIG_X86_32
 		/* End of data section */
 		_edata = .;
-#endif
 	}
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 2dfcbf9..dbb5381 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -79,8 +79,10 @@ static __init void bad_srat(void)
 	acpi_numa = -1;
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		apicid_to_node[i] = NUMA_NO_NODE;
-	for (i = 0; i < MAX_NUMNODES; i++)
-		nodes_add[i].start = nodes[i].end = 0;
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		nodes[i].start = nodes[i].end = 0;
+		nodes_add[i].start = nodes_add[i].end = 0;
+	}
 	remove_all_active_ranges();
 }
 
