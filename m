Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZITS3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZITS3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZITS3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:29:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:56224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbZITS3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:29:16 -0400
Date: Sun, 20 Sep 2009 18:28:42 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, macro@linux-mips.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, macro@linux-mips.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090915071230.GA10604@lenovo>
References: <20090915071230.GA10604@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Fix missed handling of discrete apics
Message-ID: <tip-8312136fa8b0a3ec7323bbb1a46be8c0c26e994e@git.kernel.org>
Git-Commit-ID: 8312136fa8b0a3ec7323bbb1a46be8c0c26e994e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:28:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8312136fa8b0a3ec7323bbb1a46be8c0c26e994e
Gitweb:     http://git.kernel.org/tip/8312136fa8b0a3ec7323bbb1a46be8c0c26e994e
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Tue, 15 Sep 2009 11:12:30 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:18:07 +0200

x86, apic: Fix missed handling of discrete apics

In case of discrete (pretty old) apics we may have cpu_has_apic bit
not set but have to check if smp_found_config (MP spec) is there
and apic was not disabled.

Also don't forget to print apic/io-apic for such case as well.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090915071230.GA10604@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h    |   13 +++++++++++++
 arch/x86/kernel/apic/apic.c    |    2 +-
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 586b7ad..9a86fb4 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -66,6 +66,19 @@ static inline void default_inquire_remote_apic(int apicid)
 }
 
 /*
+ * With 82489DX we can't rely on apic feature bit
+ * retrieved via cpuid but still have to deal with
+ * such an apic chip so we assume that SMP configuration
+ * is found from MP table (64bit case uses ACPI mostly
+ * which set smp presence flag as well so we are safe
+ * to use this helper too).
+ */
+static inline bool apic_from_smp_config(void)
+{
+	return smp_found_config && !disable_apic;
+}
+
+/*
  * Basic functions accessing APICs.
  */
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 072aea6..2d59dfa 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -978,7 +978,7 @@ void lapic_shutdown(void)
 {
 	unsigned long flags;
 
-	if (!cpu_has_apic)
+	if (!cpu_has_apic && !apic_from_smp_config())
 		return;
 
 	local_irq_save(flags);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3c8f9e7..593c4f8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1863,7 +1863,7 @@ __apicdebuginit(int) print_all_ICs(void)
 	print_PIC();
 
 	/* don't print out if apic is not there */
-	if (!cpu_has_apic || disable_apic)
+	if (!cpu_has_apic && !apic_from_smp_config())
 		return 0;
 
 	print_all_local_APICs();
@@ -1981,7 +1981,7 @@ void disable_IO_APIC(void)
 	/*
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
-	if (cpu_has_apic)
+	if (cpu_has_apic || apic_from_smp_config())
 		disconnect_bsp_APIC(!intr_remapping_enabled &&
 				ioapic_i8259.pin != -1);
 }
