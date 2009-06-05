Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbZFEIPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbZFEIPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZFEIG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37514 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbZFEIFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 29/62] Blackfin: detect anomaly 05000274
Date: Fri,  5 Jun 2009 04:04:38 -0400
Message-Id: <1244189111-19639-30-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Detect and reject operating conditions for anomaly 05000274 since the
problem cannot be worked around in software.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c        |    9 ++-------
 arch/blackfin/mach-common/cpufreq.c |    3 ++-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 5a4a036..59d9e3f 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -801,10 +801,8 @@ void __init setup_arch(char **cmdline_p)
 	cclk = get_cclk();
 	sclk = get_sclk();
 
-#if !defined(CONFIG_BFIN_KERNEL_CLOCK)
-	if (ANOMALY_05000273 && cclk == sclk)
-		panic("ANOMALY 05000273, SCLK can not be same as CCLK");
-#endif
+	if ((ANOMALY_05000273 || ANOMALY_05000274) && (cclk >> 1) <= sclk)
+		panic("ANOMALY 05000273 or 05000274: CCLK must be >= 2*SCLK");
 
 #ifdef BF561_FAMILY
 	if (ANOMALY_05000266) {
@@ -903,9 +901,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu MHz System Clock\n",
 	       cclk / 1000000, sclk / 1000000);
 
-	if (ANOMALY_05000273 && (cclk >> 1) <= sclk)
-		printk("\n\n\nANOMALY_05000273: CCLK must be >= 2*SCLK !!!\n\n\n");
-
 	setup_bootmem_allocator();
 
 	paging_init();
diff --git a/arch/blackfin/mach-common/cpufreq.c b/arch/blackfin/mach-common/cpufreq.c
index 72e1660..70e3411 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -140,7 +140,8 @@ static int __init __bfin_cpu_init(struct cpufreq_policy *policy)
 	cclk = get_cclk() / 1000;
 	sclk = get_sclk() / 1000;
 
-#if ANOMALY_05000273 || (!defined(CONFIG_BF54x) && defined(CONFIG_BFIN_DCACHE))
+#if ANOMALY_05000273 || ANOMALY_05000274 || \
+	(!defined(CONFIG_BF54x) && defined(CONFIG_BFIN_DCACHE))
 	min_cclk = sclk * 2;
 #else
 	min_cclk = sclk;
-- 
1.6.3.1

