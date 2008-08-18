Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYHRQsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYHRQsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbYHRQpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31998 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbYHRQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M+Nj7OiYH3CI3yBStoCycHOC/I/0T8zTgSbxGz0AbMzlI9Tduawo57koL7vyTzhfMg
         8iDni1H8mPwO6TBM5x+B/lHm1Rak2SDKcpe3I/nLhtehqBnRXrvb5uieS9PoXzy+6hd/
         jxgDwyqtD1xvqmrk9/du1S/t/FEOERcwuZACM=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 06/15] x86: apic - unify lapic_setup_esr
Date: Mon, 18 Aug 2008 20:45:54 +0400
Message-Id: <e97a40e970bc5cd8a873e52be6a90c0a459bc276.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use 32bit code former for 64bit
mode since it's much better implementation
and easier to merge.


Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   21 +++++++++--------
 arch/x86/kernel/apic_64.c |   51 ++++++++++++++++++++++++++++++++++----------
 2 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6d230e9..3c1562a 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -983,6 +983,16 @@ static void __cpuinit lapic_setup_esr(void)
 {
 	unsigned long oldvalue, value, maxlvt;
 	if (lapic_is_integrated() && !esr_disable) {
+		if (esr_disable) {
+			/*
+			 * Something untraceable is creating bad interrupts on
+			 * secondary quads ... for the moment, just leave the
+			 * ESR disabled - we can't do anything useful with the
+			 * errors anyway - mbligh
+			 */
+			printk(KERN_INFO "Leaving ESR disabled.\n");
+			return;
+		}
 		/* !82489DX */
 		maxlvt = lapic_get_maxlvt();
 		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
@@ -1003,16 +1013,7 @@ static void __cpuinit lapic_setup_esr(void)
 				"vector: 0x%08lx  after: 0x%08lx\n",
 				oldvalue, value);
 	} else {
-		if (esr_disable)
-			/*
-			 * Something untraceable is creating bad interrupts on
-			 * secondary quads ... for the moment, just leave the
-			 * ESR disabled - we can't do anything useful with the
-			 * errors anyway - mbligh
-			 */
-			printk(KERN_INFO "Leaving ESR disabled.\n");
-		else
-			printk(KERN_INFO "No ESR for 82489DX.\n");
+		printk(KERN_INFO "No ESR for 82489DX.\n");
 	}
 }
 
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5579e21..d74abf7 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -863,6 +863,45 @@ void __init init_bsp_APIC(void)
 	apic_write(APIC_LVT1, value);
 }
 
+static void __cpuinit lapic_setup_esr(void)
+{
+	unsigned long oldvalue, value, maxlvt;
+	if (lapic_is_integrated() && !esr_disable) {
+		if (esr_disable) {
+			/*
+			 * Something untraceable is creating bad interrupts on
+			 * secondary quads ... for the moment, just leave the
+			 * ESR disabled - we can't do anything useful with the
+			 * errors anyway - mbligh
+			 */
+			printk(KERN_INFO "Leaving ESR disabled.\n");
+			return;
+		}
+		/* !82489DX */
+		maxlvt = lapic_get_maxlvt();
+		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
+			apic_write(APIC_ESR, 0);
+		oldvalue = apic_read(APIC_ESR);
+
+		/* enables sending errors */
+		value = ERROR_APIC_VECTOR;
+		apic_write(APIC_LVTERR, value);
+		/*
+		 * spec says clear errors after enabling vector.
+		 */
+		if (maxlvt > 3)
+			apic_write(APIC_ESR, 0);
+		value = apic_read(APIC_ESR);
+		if (value != oldvalue)
+			apic_printk(APIC_VERBOSE, "ESR value before enabling "
+				"vector: 0x%08lx  after: 0x%08lx\n",
+				oldvalue, value);
+	} else {
+		printk(KERN_INFO "No ESR for 82489DX.\n");
+	}
+}
+
+
 /**
  * setup_local_APIC - setup the local APIC
  */
@@ -968,18 +1007,6 @@ void __cpuinit setup_local_APIC(void)
 	preempt_enable();
 }
 
-static void __cpuinit lapic_setup_esr(void)
-{
-	unsigned maxlvt = lapic_get_maxlvt();
-
-	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR);
-	/*
-	 * spec says clear errors after enabling vector.
-	 */
-	if (maxlvt > 3)
-		apic_write(APIC_ESR, 0);
-}
-
 void __cpuinit end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
-- 
1.6.0.rc1.34.g0fe8c

