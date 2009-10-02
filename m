Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZJBOCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZJBOCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZJBOCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:02:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:47857 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbZJBOCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:02:38 -0400
Date: Fri, 2 Oct 2009 14:01:44 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20091002133148.GD28682@aftab>
References: <20091002133148.GD28682@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: EDAC: carve out AMD MCE decoding logic
Message-ID: <tip-0d18b2e34bd1ad8f5bd3f3a17b5e7df132e511a9@git.kernel.org>
Git-Commit-ID: 0d18b2e34bd1ad8f5bd3f3a17b5e7df132e511a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 14:01:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d18b2e34bd1ad8f5bd3f3a17b5e7df132e511a9
Gitweb:     http://git.kernel.org/tip/0d18b2e34bd1ad8f5bd3f3a17b5e7df132e511a9
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 2 Oct 2009 15:31:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Oct 2009 15:42:19 +0200

x86: EDAC: carve out AMD MCE decoding logic

This converts the MCE decoding logic into a standalone config
option which can be built-in or a module, the first one being the
default for MCEs happening early on in the boot process.

This, beyond being separated in a cleaner way, also saves RAM by
making the decoding logic modular.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <20091002133148.GD28682@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 drivers/edac/Kconfig        |   14 +++++++++++++-
 drivers/edac/Makefile       |    5 +----
 drivers/edac/edac_mce_amd.c |   19 ++++++++++++++++++-
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 02127e5..55c9c59 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -47,6 +47,18 @@ config EDAC_DEBUG_VERBOSE
 	  Source file name and line number where debugging message
 	  printed will be added to debugging message.
 
+ config EDAC_DECODE_MCE
+	tristate "Decode MCEs in human-readable form (only on AMD for now)"
+	depends on CPU_SUP_AMD && X86_MCE
+	default y
+	---help---
+	  Enable this option if you want to decode Machine Check Exceptions
+	  occuring on your machine in human-readable form.
+
+	  You should definitely say Y here in case you want to decode MCEs
+	  which occur really early upon boot, before the module infrastructure
+	  has been initialized.
+
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
 	help
@@ -59,7 +71,7 @@ config EDAC_MM_EDAC
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && CPU_SUP_AMD
+	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction on the AMD 64
 	  Families of Memory Controllers (K8, F10h and F11h)
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 8701cd7..bc5dc23 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -6,7 +6,6 @@
 # GNU General Public License.
 #
 
-
 obj-$(CONFIG_EDAC)			:= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 
@@ -17,9 +16,7 @@ ifdef CONFIG_PCI
 edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
 endif
 
-ifdef CONFIG_CPU_SUP_AMD
-obj-$(CONFIG_X86_MCE)			+= edac_mce_amd.o
-endif
+obj-$(CONFIG_EDAC_DECODE_MCE)		+= edac_mce_amd.o
 
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_CPC925)		+= cpc925_edac.o
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 83a01a1..713ed7d 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -3,6 +3,7 @@
 
 static bool report_gart_errors;
 static void (*nb_bus_decoder)(int node_id, struct err_regs *regs);
+static void (*orig_mce_callback)(struct mce *m);
 
 void amd_report_gart_errors(bool v)
 {
@@ -427,9 +428,25 @@ static int __init mce_amd_init(void)
 	 * We can decode MCEs for Opteron and later CPUs:
 	 */
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
-	    (boot_cpu_data.x86 >= 0xf))
+	    (boot_cpu_data.x86 >= 0xf)) {
+		/* safe the default decode mce callback */
+		orig_mce_callback = x86_mce_decode_callback;
+
 		x86_mce_decode_callback = amd_decode_mce;
+	}
 
 	return 0;
 }
 early_initcall(mce_amd_init);
+
+#ifdef MODULE
+static void __exit mce_amd_exit(void)
+{
+	x86_mce_decode_callback = orig_mce_callback;
+}
+
+MODULE_DESCRIPTION("AMD MCE decoder");
+MODULE_ALIAS("edac-mce-amd");
+MODULE_LICENSE("GPL");
+module_exit(mce_amd_exit);
+#endif
