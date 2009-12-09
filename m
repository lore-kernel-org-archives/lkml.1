Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZLIHzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZLIHzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbZLIHy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:54:28 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44283 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399AbZLIHyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:54:10 -0500
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Message-ID: <7-1000-25639-1260344705-9533@rere.qmqm.pl>
In-Reply-To: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
Date: Wed, 9 Dec 2009 06:17:52 +0100
Subject: [PATCH 6/7] mtrr: introduce HAVE_MTRR_VENDOR_SPECIFIC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case that only generic MTRR implementation is needed, tell gcc
to optimize out tests for other implementations. Also remove .vendor
from mtrr_ops in this configuration.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 arch/x86/Kconfig                |    3 +++
 arch/x86/Kconfig.cpu            |    3 +++
 arch/x86/kernel/cpu/mtrr/mtrr.h |   12 +++++++++++-
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 32a1918..91422d0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1367,6 +1367,9 @@ config MTRR
 
 	  See <file:Documentation/x86/mtrr.txt> for more information.
 
+config HAVE_MTRR_VENDOR_SPECIFIC
+	def_bool n
+
 config MTRR_SANITIZER
 	def_bool y
 	prompt "MTRR cleanup support"
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index bae1193..d7a6838 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -439,6 +439,7 @@ config CPU_SUP_CYRIX_32
 	default y
 	bool "Support Cyrix processors" if PROCESSOR_SELECT
 	depends on !64BIT
+	select HAVE_MTRR_VENDOR_SPECIFIC
 	---help---
 	  This enables detection, tunings and quirks for Cyrix processors
 
@@ -464,6 +465,7 @@ config CPU_SUP_AMD
 
 config CPU_SUP_AMD_32
 	def_bool y if CPU_SUP_AMD && !64BIT
+	select HAVE_MTRR_VENDOR_SPECIFIC
 
 config CPU_SUP_CENTAUR
 	default y
@@ -480,6 +482,7 @@ config CPU_SUP_CENTAUR
 
 config CPU_SUP_CENTAUR_32
 	def_bool y if CPU_SUP_CENTAUR && !64BIT
+	select HAVE_MTRR_VENDOR_SPECIFIC
 
 config CPU_SUP_TRANSMETA_32
 	default y
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 562e2e3..7a87e65 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -12,7 +12,9 @@
 extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 
 struct mtrr_ops {
+#ifdef CONFIG_HAVE_MTRR_VENDOR_SPECIFIC
 	u32	vendor;
+#endif
 	void	(*set)(unsigned int reg, unsigned long base,
 		       unsigned long size, mtrr_type type);
 	void	(*set_all)(void);
@@ -32,7 +34,7 @@ extern int generic_validate_add_page(unsigned long base, unsigned long size,
 				     unsigned int type);
 
 extern const struct mtrr_ops generic_mtrr_ops;
-#ifdef CONFIG_X86_32
+#ifdef CONFIG_HAVE_MTRR_VENDOR_SPECIFIC
 extern const struct mtrr_ops amd_mtrr_ops;
 extern const struct mtrr_ops centaur_mtrr_ops;
 extern const struct mtrr_ops cyrix_mtrr_ops;
@@ -60,8 +62,16 @@ void get_mtrr_state(void);
 extern u64 size_or_mask, size_and_mask;
 extern const struct mtrr_ops *mtrr_if;
 
+#ifdef CONFIG_HAVE_MTRR_VENDOR_SPECIFIC
+
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 
+#else
+
+#define is_cpu(vnd)	(mtrr_if && 0 == X86_VENDOR_##vnd)
+
+#endif
+
 extern unsigned int num_var_ranges;
 extern u64 mtrr_tom2;
 extern struct mtrr_state_type mtrr_state;
-- 
1.6.4.4

