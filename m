Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZJBNcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZJBNcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbZJBNcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:32:24 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:13010
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757832AbZJBNcX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:32:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQW2XK-02-053-02
X-M-MSG: 
Date: Fri, 2 Oct 2009 15:31:48 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] EDAC: carve out AMD MCE decoding logic
Message-ID: <20091002133148.GD28682@aftab>
References: <20090930214859.GA28638@elte.hu>
 <20090930223956.GE17712@liondog.tnic>
 <20090930230947.GA9346@elte.hu>
 <20091001141432.GA11410@aftab>
 <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
 <20091001144637.GB11410@aftab>
 <20091001150046.GA21476@elte.hu>
 <20091001152140.GC11410@aftab>
 <20091001153250.GA25885@elte.hu>
 <20091002132101.GA28682@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091002132101.GA28682@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Oct 2009 13:31:20.0424 (UTC) FILETIME=[A0A1F680:01CA4364]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7fa3435b6fdf73e8dfeb9153fe7cec95b88d6196 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 2 Oct 2009 11:59:20 +0200
Subject: [PATCH 3/3] EDAC: carve out AMD MCE decoding logic

This converts the MCE decoding logic into a standalone config option
which can be built-in or a module, the first one being the default for
MCEs happening early on in the boot process.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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
-- 
1.6.4.3

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

