Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYDSAtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYDSAtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 20:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbYDSAtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 20:49:23 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:55250 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYDSAtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 20:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=bcVm3T9UFCQbNX47jKhKivOFgn+TmRqfG3fr/nNWZWANHgscUBMzYQLPbI4YON2guQdb6Yk5OMp8wi98w/5yufob/pt0zDUnDfTdA4V860xTLjXvFrU3D++a76Q+Qq0k1eXA+hOg+gZCPv6UNa/LDxyIUviWJCxWwU+1Kg978aM=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86_64: simplify the memtest parameter setting
Date: Fri, 18 Apr 2008 17:49:15 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804181749.15782.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use CONFIG_MEMTEST only. if it is set, will have memtest=0 (disabled)

need to have memtest=4 in command line to test more patterns.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 21825ea..42d6568 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -389,35 +389,19 @@ config PARAVIRT
 
 endif
 
-config MEMTEST_BOOTPARAM
-	bool "Memtest boot parameter"
+config MEMTEST
+	bool "Memtest"
 	depends on X86_64
 	default y
 	help
 	  This option adds a kernel parameter 'memtest', which allows memtest
-	  to be disabled at boot.  If this option is selected, memtest
-	  functionality can be disabled with memtest=0 on the kernel
-	  command line.  The purpose of this option is to allow a single
-	  kernel image to be distributed with memtest built in, but not
-	  necessarily enabled.
-
+	  to be set.
+		memtest=0, mean disabled; -- default
+		memtest=1, mean do 1 test pattern;
+		...
+		memtest=4, mean do 4 test patterns.
 	  If you are unsure how to answer this question, answer Y.
 
-config MEMTEST_BOOTPARAM_VALUE
-	int "Memtest boot parameter default value (0-4)"
-	depends on MEMTEST_BOOTPARAM
-	range 0 4
-	default 0
-	help
-	  This option sets the default value for the kernel parameter
-	  'memtest', which allows memtest to be disabled at boot.  If this
-	  option is set to 0 (zero), the memtest kernel parameter will
-	  default to 0, disabling memtest at bootup.  If this option is
-	  set to 4, the memtest kernel parameter will default to 4,
-	  enabling memtest at bootup, and use that as pattern number.
-
-	  If you are unsure how to answer this question, answer 0.
-
 config ACPI_SRAT
 	def_bool y
 	depends on X86_32 && ACPI && NUMA && (X86_SUMMIT || X86_GENERICARCH)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b67ede4..82a0319 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -432,7 +432,7 @@ static void __init init_gbpages(void)
 		direct_gbpages = 0;
 }
 
-#ifdef CONFIG_MEMTEST_BOOTPARAM
+#ifdef CONFIG_MEMTEST
 
 static void __init memtest(unsigned long start_phys, unsigned long size,
 				 unsigned pattern)
@@ -494,7 +494,8 @@ static void __init memtest(unsigned long start_phys, unsigned long size,
 
 }
 
-static int memtest_pattern __initdata = CONFIG_MEMTEST_BOOTPARAM_VALUE;
+/* default is disabled */
+static int memtest_pattern __initdata = 0;
 
 static int __init parse_memtest(char *arg)
 {
