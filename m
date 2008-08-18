Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYHRQsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYHRQsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYHRQp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:26262 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYHRQpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DfGZTTcA2WkpsD/5CwlKAi12HLtKddZhJG/SJSkO1yQ20YSf7s3vj0wvvJCIo1J1eT
         tpkj7kes+Qxpw+fYH2d3An3v2WRGBQPcOBbE9svAH7ufqVEP9ABf5nseqyKWw1M+QzU9
         sKJZgt3g+BAeIFrxSs/D+bCGaujmpkDrRWO7M=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 12/15] x86: apic - unify apic_set_verbosity
Date: Mon, 18 Aug 2008 20:46:00 +0400
Message-Id: <a4b73aa41a1481f606690862364e16afd8a6c178.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   17 +++++++++++++--
 arch/x86/kernel/apic_64.c |   46 ++++++++++++++++++++++++--------------------
 2 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index af227bc..acbc4de 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1768,13 +1768,24 @@ early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
 
 static int __init apic_set_verbosity(char *arg)
 {
-	if (!arg)
+	if (!arg)  {
+#ifdef CONFIG_X86_64
+		skip_ioapic_setup = 0;
+		ioapic_force = 1;
+		return 0;
+#endif
 		return -EINVAL;
+	}
 
-	if (strcmp(arg, "debug") == 0)
+	if (strcmp("debug", arg) == 0)
 		apic_verbosity = APIC_DEBUG;
-	else if (strcmp(arg, "verbose") == 0)
+	else if (strcmp("verbose", arg) == 0)
 		apic_verbosity = APIC_VERBOSE;
+	else {
+		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
+			" use apic=verbose or apic=debug\n", arg);
+		return -EINVAL;
+	}
 
 	return 0;
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index a9ad2cb..9997818 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1759,27 +1759,6 @@ early_param("nox2apic", setup_nox2apic);
 /*
  * APIC command line parameters
  */
-static int __init apic_set_verbosity(char *str)
-{
-	if (str == NULL)  {
-		skip_ioapic_setup = 0;
-		ioapic_force = 1;
-		return 0;
-	}
-	if (strcmp("debug", str) == 0)
-		apic_verbosity = APIC_DEBUG;
-	else if (strcmp("verbose", str) == 0)
-		apic_verbosity = APIC_VERBOSE;
-	else {
-		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
-				" use apic=verbose or apic=debug\n", str);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-early_param("apic", apic_set_verbosity);
-
 static __init int setup_disableapic(char *str)
 {
 	disable_apic = 1;
@@ -1824,6 +1803,31 @@ static __init int setup_apicpmtimer(char *s)
 }
 __setup("apicpmtimer", setup_apicpmtimer);
 
+static int __init apic_set_verbosity(char *arg)
+{
+	if (!arg)  {
+#ifdef CONFIG_X86_64
+		skip_ioapic_setup = 0;
+		ioapic_force = 1;
+		return 0;
+#endif
+		return -EINVAL;
+	}
+
+	if (strcmp("debug", arg) == 0)
+		apic_verbosity = APIC_DEBUG;
+	else if (strcmp("verbose", arg) == 0)
+		apic_verbosity = APIC_VERBOSE;
+	else {
+		printk(KERN_WARNING "APIC Verbosity level %s not recognised"
+			" use apic=verbose or apic=debug\n", arg);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+early_param("apic", apic_set_verbosity);
+
 static int __init lapic_insert_resource(void)
 {
 	if (!apic_phys)
-- 
1.6.0.rc1.34.g0fe8c

