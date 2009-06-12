Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbZFLSW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbZFLSW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZFLSWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:22:51 -0400
Received: from claw.goop.org ([74.207.240.146]:57716 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbZFLSWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:22:51 -0400
Message-ID: <4A329CF8.4050502@goop.org>
Date: Fri, 12 Jun 2009 11:22:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the ACPI MADT for I/O APIC information, even if the cpu has no
(apparent) local APIC (ie, the CPU's APIC feature flag is clear).

In principle, the local APIC and the I/O APIC are distinct (but related)
components, which can be independently present.

In practice this can happen in a Xen system, where the hypervisor has
full control over the local APICs, and delivers interrupts initiated by
the I/O APICs via Xen's event channel mechanism.

(This eliminates the need for any explicit if (xen...) tests in
acpi/boot.c)

Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2410469..19d13e5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -193,9 +193,6 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
  {
  	struct acpi_table_madt *madt = NULL;

-	if (!cpu_has_apic)
-		return -EINVAL;
-
  	madt = (struct acpi_table_madt *)table;
  	if (!madt) {
  		printk(KERN_WARNING PREFIX "Unable to map MADT\n");
@@ -1252,9 +1249,6 @@ static int __init acpi_parse_madt_ioapic_entries(void)
  	if (acpi_disabled || acpi_noirq)
  		return -ENODEV;

-	if (!cpu_has_apic)
-		return -ENODEV;
-
  	/*
  	 * if "noapic" boot option, don't look for IO-APICs
  	 */
@@ -1357,6 +1351,16 @@ static void __init acpi_process_madt(void)
  #ifdef CONFIG_X86_BIGSMP
  			generic_bigsmp_probe();
  #endif
+		}
+		if (error == -EINVAL) {
+			/*
+			 * The ACPI tables themselves were malformed.
+			 * Dell Precision Workstation 410, 610 come here.
+			 */
+			printk(KERN_ERR PREFIX
+			       "Invalid BIOS MADT, disabling ACPI\n");
+			disable_acpi();
+		} else {
  			/*
  			 * Parse MADT IO-APIC entries
  			 */
@@ -1370,14 +1374,6 @@ static void __init acpi_process_madt(void)
  					apic->setup_apic_routing();
  			}
  		}
-		if (error == -EINVAL) {
-			/*
-			 * Dell Precision Workstation 410, 610 come here.
-			 */
-			printk(KERN_ERR PREFIX
-			       "Invalid BIOS MADT, disabling ACPI\n");
-			disable_acpi();
-		}
  	} else {
  		/*
   		 * ACPI found no MADT, and so ACPI wants UP PIC mode.
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c6acce2..d5e3f03 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1807,6 +1807,10 @@ __apicdebuginit(void) print_all_local_APICs(void)
  {
  	int cpu;

+	/* don't print out if apic is not there */
+	if (!cpu_has_apic)
+		return;
+
  	preempt_disable();
  	for_each_online_cpu(cpu)
  		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
@@ -1849,8 +1853,7 @@ __apicdebuginit(int) print_all_ICs(void)
  {
  	print_PIC();

-	/* don't print out if apic is not there */
-	if (!cpu_has_apic || disable_apic)
+	if (disable_apic)
  		return 0;

  	print_all_local_APICs();


