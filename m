Return-Path: <linux-kernel-owner+w=401wt.eu-S2992825AbXDDKX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992825AbXDDKX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 06:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992828AbXDDKXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 06:23:55 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16930 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992825AbXDDKXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 06:23:55 -0400
X-IronPort-AV: i="4.14,371,1170651600"; 
   d="scan'208"; a="26319952:sNHT25598804"
Subject: [PATCH] blackfin arch: define a new cacheline_aligned attribute to
	put it in L1 data memory with linkscript update
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 18:25:31 +0800
Message-Id: <1175682332.10608.56.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig              |    8 ++++++++
 arch/blackfin/kernel/vmlinux.lds.S |    8 ++++++++
 include/asm-blackfin/cache.h       |   11 +++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 9ae0223..88e831a 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -513,6 +513,14 @@ config IP_CHECKSUM_L1
 	  If enabled IP Checksum function is linked
 	  into L1 instruction memory.(less latency)
 
+config CACHELINE_ALIGNED_L1
+	bool "Locate cacheline_aligned data to L1 Data Memory"
+	default y
+	depends on !BF531
+	help
+	  If enabled cacheline_anligned data is linked
+	  into L1 data memory.(less latency)
+
 config SYSCALL_TAB_L1
 	bool "Locate Syscall Table L1 Data Memory"
 	default n
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index fb01ca2..53c6a23 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -173,6 +173,9 @@ SECTIONS
 		 __sbss_l1 = .;
 		*(.l1.bss)
 
+		. = ALIGN(32);
+		*(.data_l1.cacheline_aligned)
+
 		. = ALIGN(4);
 		 __ebss_l1 = .;
 	} > l1_data_a AT > ram
@@ -197,6 +200,11 @@ SECTIONS
 		. = ALIGN(0x2000);
 		*(.data.init_task)
 		*(.data)
+
+		. = ALIGN(32);
+		*(.data.cacheline_aligned)
+
+		. = ALIGN(0x2000);
 		__edata = .;
 	} > ram
 
diff --git a/include/asm-blackfin/cache.h b/include/asm-blackfin/cache.h
index 560e390..023d721 100644
--- a/include/asm-blackfin/cache.h
+++ b/include/asm-blackfin/cache.h
@@ -10,13 +10,16 @@
  */
 #define L1_CACHE_SHIFT	5
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
+#define SMP_CACHE_BYTES	L1_CACHE_BYTES
 
 /*
- * Don't make __cacheline_aligned and
- * ____cacheline_aligned defined in include/linux/cache.h
+ * Put cacheline_aliged data to L1 data memory
  */
-#define __cacheline_aligned
-#define ____cacheline_aligned
+#ifdef CONFIG_CACHELINE_ALIGNED_L1
+#define __cacheline_aligned				\
+	  __attribute__((__aligned__(L1_CACHE_BYTES),	\
+		__section__(".data_l1.cacheline_aligned")))
+#endif
 
 /*
  * largest L1 which this arch supports
-- 
1.5.0.5

