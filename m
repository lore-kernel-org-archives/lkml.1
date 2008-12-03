Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbYLCT5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbYLCT5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYLCTud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:33 -0500
Received: from kroah.org ([198.145.64.141]:59600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754596AbYLCTuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:25 -0500
Date: Wed, 3 Dec 2008 11:48:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Doug Chapman <doug.chapman@hp.com>,
       Alex Chiang <achiang@hp.com>, Robin Holt <holt@sgi.com>,
       Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 018/104] IA64: fix boot panic caused by offline CPUs
Message-ID: <20081203194859.GS8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ia64-fix-boot-panic-caused-by-offline-cpus.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Doug Chapman <doug.chapman@hp.com>

commit 62ee0540f5e5a804b79cae8b3c0185a85f02436b upstream.

This fixes a regression introduced by 2c6e6db41f01b6b4eb98809350827c9678996698
"Minimize per_cpu reservations."  That patch incorrectly used information about
what CPUs are possible that was not yet initialized by ACPI.  The end result
was that per_cpu structures for offline CPUs were not initialized causing a
NULL pointer reference.

Since we cannot do the full acpi_boot_init() call any earlier, the simplest
fix is to just parse the MADT for SAPIC entries early to find the CPU
info.  This should also allow for some cleanup of the code added by the
"Minimize per_cpu reservations".  This patch just fixes the regressions, the
cleanup will come in a later patch.

Signed-off-by: Doug Chapman <doug.chapman@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
CC: Robin Holt <holt@sgi.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kernel/acpi.c  |   29 ++++++++++++++++++++++++-----
 arch/ia64/kernel/setup.c |    7 ++++---
 2 files changed, 28 insertions(+), 8 deletions(-)

--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -656,6 +656,30 @@ static int __init acpi_parse_fadt(struct
 	return 0;
 }
 
+int __init early_acpi_boot_init(void)
+{
+	int ret;
+
+	/*
+	 * do a partial walk of MADT to determine how many CPUs
+	 * we have including offline CPUs
+	 */
+	if (acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {
+		printk(KERN_ERR PREFIX "Can't find MADT\n");
+		return 0;
+	}
+
+	ret = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC,
+		acpi_parse_lsapic, NR_CPUS);
+	if (ret < 1)
+		printk(KERN_ERR PREFIX
+		       "Error parsing MADT - no LAPIC entries\n");
+
+	return 0;
+}
+
+
+
 int __init acpi_boot_init(void)
 {
 
@@ -679,11 +703,6 @@ int __init acpi_boot_init(void)
 		printk(KERN_ERR PREFIX
 		       "Error parsing LAPIC address override entry\n");
 
-	if (acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_SAPIC, acpi_parse_lsapic, NR_CPUS)
-	    < 1)
-		printk(KERN_ERR PREFIX
-		       "Error parsing MADT - no LAPIC entries\n");
-
 	if (acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI, acpi_parse_lapic_nmi, 0)
 	    < 0)
 		printk(KERN_ERR PREFIX "Error parsing LAPIC NMI entry\n");
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -549,8 +549,12 @@ setup_arch (char **cmdline_p)
 #ifdef CONFIG_ACPI
 	/* Initialize the ACPI boot-time table parser */
 	acpi_table_init();
+	early_acpi_boot_init();
 # ifdef CONFIG_ACPI_NUMA
 	acpi_numa_init();
+#ifdef CONFIG_ACPI_HOTPLUG_CPU
+	prefill_possible_map();
+#endif
 	per_cpu_scan_finalize((cpus_weight(early_cpu_possible_map) == 0 ?
 		32 : cpus_weight(early_cpu_possible_map)),
 		additional_cpus > 0 ? additional_cpus : 0);
@@ -841,9 +845,6 @@ void __init
 setup_per_cpu_areas (void)
 {
 	/* start_kernel() requires this... */
-#ifdef CONFIG_ACPI_HOTPLUG_CPU
-	prefill_possible_map();
-#endif
 }
 
 /*

