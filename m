Return-Path: <linux-kernel-owner+w=401wt.eu-S1765476AbYCSUP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765476AbYCSUP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbYCSTi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbYCSTiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:51 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 74/79] [PATCH] change x86_64 sanity checks to match i386.
Date: Wed, 19 Mar 2008 14:26:09 -0300
Message-Id: <1205947906258-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947902868-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

They are mostly inocuous. APIC_INTEGRATED will expand to 1,
check_phys_apicid_present is checking for the same thing it was before,
etc. But the code is identical to i386 now, and will allow us to
integrate it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 6679ac5..c66fb15 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -50,6 +50,7 @@
 #include <linux/smp.h>
 #include <linux/kdebug.h>
 
+#include <asm/acpi.h>
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
 #include <asm/desc.h>
@@ -105,7 +106,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 * If we couldn't find an SMP configuration at boot time,
 	 * get out of here now!
 	 */
-	if (!smp_found_config) {
+	if (!smp_found_config && !acpi_lapic) {
 		printk(KERN_NOTICE "SMP motherboard not detected.\n");
 		disable_smp();
 		if (APIC_init_uniprocessor())
@@ -118,7 +119,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 * Should not be necessary because the MP table should list the boot
 	 * CPU too, but we do it for the sake of robustness anyway.
 	 */
-	if (!physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map)) {
+	if (!check_phys_apicid_present(boot_cpu_physical_apicid)) {
 		printk(KERN_NOTICE
 			"weird, boot CPU (#%d) not listed by the BIOS.\n",
 			boot_cpu_physical_apicid);
@@ -128,7 +129,8 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	/*
 	 * If we couldn't find a local APIC, then get out of here now!
 	 */
-	if (!cpu_has_apic) {
+	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
+	    !cpu_has_apic) {
 		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
 			boot_cpu_physical_apicid);
 		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
@@ -136,6 +138,8 @@ static int __init smp_sanity_check(unsigned max_cpus)
 		return -1;
 	}
 
+	verify_local_APIC();
+
 	/*
 	 * If SMP should be disabled, then really disable it!
 	 */
-- 
1.5.0.6

