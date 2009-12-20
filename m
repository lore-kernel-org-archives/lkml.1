Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZLTTVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZLTTVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZLTTVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:21:19 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2734 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbZLTTTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:19:16 -0500
Subject: [PATCH 02/11] ACPI: processor: introduce arch_has_acpi_pdc
To: venkatesh.pallipadi@intel.com, lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 20 Dec 2009 12:19:14 -0700
Message-ID: <20091220191914.4274.81028.stgit@bob.kio>
In-Reply-To: <20091220190434.4274.67855.stgit@bob.kio>
References: <20091220190434.4274.67855.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch dependent helper function that tells us if we should attempt to
evaluate _PDC on this machine or not.

The x86 implementation assumes that the CPUs in the machine must be
homogeneous, and that you cannot mix CPUs of different vendors.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 arch/ia64/include/asm/acpi.h     |    2 ++
 arch/x86/include/asm/acpi.h      |    7 +++++++
 arch/x86/kernel/acpi/processor.c |    4 +---
 drivers/acpi/processor_pdc.c     |    3 +++
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index 91df968..3b78882 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -132,6 +132,8 @@ extern int __devinitdata pxm_to_nid_map[MAX_PXM_DOMAINS];
 extern int __initdata nid_to_pxm_map[MAX_NUMNODES];
 #endif
 
+static inline bool arch_has_acpi_pdc(void) { return true; }
+
 #define acpi_unlazy_tlb(x)
 
 #ifdef CONFIG_ACPI_NUMA
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 60d2b2d..d787e6e 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -142,6 +142,13 @@ static inline unsigned int acpi_processor_cstate_check(unsigned int max_cstate)
 		return max_cstate;
 }
 
+static inline bool arch_has_acpi_pdc(void)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+	return (c->x86_vendor == X86_VENDOR_INTEL ||
+		c->x86_vendor == X86_VENDOR_CENTAUR);
+}
+
 #else /* !CONFIG_ACPI */
 
 #define acpi_lapic 0
diff --git a/arch/x86/kernel/acpi/processor.c b/arch/x86/kernel/acpi/processor.c
index d85d1b2..bcb6efe 100644
--- a/arch/x86/kernel/acpi/processor.c
+++ b/arch/x86/kernel/acpi/processor.c
@@ -79,9 +79,7 @@ void arch_acpi_processor_init_pdc(struct acpi_processor *pr)
 	struct cpuinfo_x86 *c = &cpu_data(pr->id);
 
 	pr->pdc = NULL;
-	if (c->x86_vendor == X86_VENDOR_INTEL ||
-	    c->x86_vendor == X86_VENDOR_CENTAUR)
-		init_intel_pdc(pr, c);
+	init_intel_pdc(pr, c);
 
 	return;
 }
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index b416c32..931e735 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -69,6 +69,9 @@ static int acpi_processor_eval_pdc(struct acpi_processor *pr)
 
 void acpi_processor_set_pdc(struct acpi_processor *pr)
 {
+	if (arch_has_acpi_pdc() == false)
+		return;
+
 	arch_acpi_processor_init_pdc(pr);
 	acpi_processor_eval_pdc(pr);
 	arch_acpi_processor_cleanup_pdc(pr);

