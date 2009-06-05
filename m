Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbZFEIH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbZFEIH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZFEIFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37459 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZFEIFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 04/62] Blackfin: Allow bf548 ATAPI to be routed to GPIO
Date: Fri,  5 Jun 2009 04:04:13 -0400
Message-Id: <1244189111-19639-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

By default, it is routed to async memory address. In GPIO case,
GPIO peripheral PINs should be requested in advance.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-bf548/Kconfig                |    7 +++
 arch/blackfin/mach-bf548/include/mach/portmux.h |   64 ++++++++++++++++-------
 2 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/arch/blackfin/mach-bf548/Kconfig b/arch/blackfin/mach-bf548/Kconfig
index dcf6571..8d24eaa 100644
--- a/arch/blackfin/mach-bf548/Kconfig
+++ b/arch/blackfin/mach-bf548/Kconfig
@@ -11,6 +11,13 @@ config DEB_DMA_URGENT
 	help
 	  Treat any DEB1, DEB2 and DEB3 request as Urgent
 
+config BF548_ATAPI_ALTERNATIVE_PORT
+	bool "BF548 ATAPI alternative port via GPIO"
+	help
+	  BF548 ATAPI data and address PINs can be routed through
+	  async address or GPIO port F and G. Select y to route it
+	  to GPIO.
+
 comment "Interrupt Priority Assignment"
 menu "Priority"
 
diff --git a/arch/blackfin/mach-bf548/include/mach/portmux.h b/arch/blackfin/mach-bf548/include/mach/portmux.h
index ffb1d0a..ce372ba 100644
--- a/arch/blackfin/mach-bf548/include/mach/portmux.h
+++ b/arch/blackfin/mach-bf548/include/mach/portmux.h
@@ -167,22 +167,42 @@
 #define P_PPI0_D13	(P_DEFINED | P_IDENT(GPIO_PF13) | P_FUNCT(0))
 #define P_PPI0_D14	(P_DEFINED | P_IDENT(GPIO_PF14) | P_FUNCT(0))
 #define P_PPI0_D15	(P_DEFINED | P_IDENT(GPIO_PF15) | P_FUNCT(0))
-#define P_ATAPI_D0A	(P_DEFINED | P_IDENT(GPIO_PF0) | P_FUNCT(1))
-#define P_ATAPI_D1A	(P_DEFINED | P_IDENT(GPIO_PF1) | P_FUNCT(1))
-#define P_ATAPI_D2A	(P_DEFINED | P_IDENT(GPIO_PF2) | P_FUNCT(1))
-#define P_ATAPI_D3A	(P_DEFINED | P_IDENT(GPIO_PF3) | P_FUNCT(1))
-#define P_ATAPI_D4A	(P_DEFINED | P_IDENT(GPIO_PF4) | P_FUNCT(1))
-#define P_ATAPI_D5A	(P_DEFINED | P_IDENT(GPIO_PF5) | P_FUNCT(1))
-#define P_ATAPI_D6A	(P_DEFINED | P_IDENT(GPIO_PF6) | P_FUNCT(1))
-#define P_ATAPI_D7A	(P_DEFINED | P_IDENT(GPIO_PF7) | P_FUNCT(1))
-#define P_ATAPI_D8A	(P_DEFINED | P_IDENT(GPIO_PF8) | P_FUNCT(1))
-#define P_ATAPI_D9A	(P_DEFINED | P_IDENT(GPIO_PF9) | P_FUNCT(1))
-#define P_ATAPI_D10A	(P_DEFINED | P_IDENT(GPIO_PF10) | P_FUNCT(1))
-#define P_ATAPI_D11A	(P_DEFINED | P_IDENT(GPIO_PF11) | P_FUNCT(1))
-#define P_ATAPI_D12A	(P_DEFINED | P_IDENT(GPIO_PF12) | P_FUNCT(1))
-#define P_ATAPI_D13A	(P_DEFINED | P_IDENT(GPIO_PF13) | P_FUNCT(1))
-#define P_ATAPI_D14A	(P_DEFINED | P_IDENT(GPIO_PF14) | P_FUNCT(1))
-#define P_ATAPI_D15A	(P_DEFINED | P_IDENT(GPIO_PF15) | P_FUNCT(1))
+
+#ifdef CONFIG_BF548_ATAPI_ALTERNATIVE_PORT
+# define P_ATAPI_D0A	(P_DEFINED | P_IDENT(GPIO_PF0) | P_FUNCT(1))
+# define P_ATAPI_D1A	(P_DEFINED | P_IDENT(GPIO_PF1) | P_FUNCT(1))
+# define P_ATAPI_D2A	(P_DEFINED | P_IDENT(GPIO_PF2) | P_FUNCT(1))
+# define P_ATAPI_D3A	(P_DEFINED | P_IDENT(GPIO_PF3) | P_FUNCT(1))
+# define P_ATAPI_D4A	(P_DEFINED | P_IDENT(GPIO_PF4) | P_FUNCT(1))
+# define P_ATAPI_D5A	(P_DEFINED | P_IDENT(GPIO_PF5) | P_FUNCT(1))
+# define P_ATAPI_D6A	(P_DEFINED | P_IDENT(GPIO_PF6) | P_FUNCT(1))
+# define P_ATAPI_D7A	(P_DEFINED | P_IDENT(GPIO_PF7) | P_FUNCT(1))
+# define P_ATAPI_D8A	(P_DEFINED | P_IDENT(GPIO_PF8) | P_FUNCT(1))
+# define P_ATAPI_D9A	(P_DEFINED | P_IDENT(GPIO_PF9) | P_FUNCT(1))
+# define P_ATAPI_D10A	(P_DEFINED | P_IDENT(GPIO_PF10) | P_FUNCT(1))
+# define P_ATAPI_D11A	(P_DEFINED | P_IDENT(GPIO_PF11) | P_FUNCT(1))
+# define P_ATAPI_D12A	(P_DEFINED | P_IDENT(GPIO_PF12) | P_FUNCT(1))
+# define P_ATAPI_D13A	(P_DEFINED | P_IDENT(GPIO_PF13) | P_FUNCT(1))
+# define P_ATAPI_D14A	(P_DEFINED | P_IDENT(GPIO_PF14) | P_FUNCT(1))
+# define P_ATAPI_D15A	(P_DEFINED | P_IDENT(GPIO_PF15) | P_FUNCT(1))
+#else
+# define P_ATAPI_D0A	(P_DONTCARE)
+# define P_ATAPI_D1A	(P_DONTCARE)
+# define P_ATAPI_D2A	(P_DONTCARE)
+# define P_ATAPI_D3A	(P_DONTCARE)
+# define P_ATAPI_D4A	(P_DONTCARE)
+# define P_ATAPI_D5A	(P_DONTCARE)
+# define P_ATAPI_D6A	(P_DONTCARE)
+# define P_ATAPI_D7A	(P_DONTCARE)
+# define P_ATAPI_D8A	(P_DONTCARE)
+# define P_ATAPI_D9A	(P_DONTCARE)
+# define P_ATAPI_D10A	(P_DONTCARE)
+# define P_ATAPI_D11A	(P_DONTCARE)
+# define P_ATAPI_D12A	(P_DONTCARE)
+# define P_ATAPI_D13A	(P_DONTCARE)
+# define P_ATAPI_D14A	(P_DONTCARE)
+# define P_ATAPI_D15A	(P_DONTCARE)
+#endif
 
 #define P_PPI0_CLK	(P_DEFINED | P_IDENT(GPIO_PG0) | P_FUNCT(0))
 #define P_PPI0_FS1	(P_DEFINED | P_IDENT(GPIO_PG1) | P_FUNCT(0))
@@ -200,9 +220,15 @@
 #define P_CAN0_RX	(P_DEFINED | P_IDENT(GPIO_PG13) | P_FUNCT(0))
 #define P_CAN1_TX	(P_DEFINED | P_IDENT(GPIO_PG14) | P_FUNCT(0))
 #define P_CAN1_RX	(P_DEFINED | P_IDENT(GPIO_PG15) | P_FUNCT(0))
-#define P_ATAPI_A0A	(P_DEFINED | P_IDENT(GPIO_PG2) | P_FUNCT(1))
-#define P_ATAPI_A1A	(P_DEFINED | P_IDENT(GPIO_PG3) | P_FUNCT(1))
-#define P_ATAPI_A2A	(P_DEFINED | P_IDENT(GPIO_PG4) | P_FUNCT(1))
+#ifdef CONFIG_BF548_ATAPI_ALTERNATIVE_PORT
+# define P_ATAPI_A0A	(P_DEFINED | P_IDENT(GPIO_PG2) | P_FUNCT(1))
+# define P_ATAPI_A1A	(P_DEFINED | P_IDENT(GPIO_PG3) | P_FUNCT(1))
+# define P_ATAPI_A2A	(P_DEFINED | P_IDENT(GPIO_PG4) | P_FUNCT(1))
+#else
+# define P_ATAPI_A0A	(P_DONTCARE)
+# define P_ATAPI_A1A	(P_DONTCARE)
+# define P_ATAPI_A2A	(P_DONTCARE)
+#endif
 #define P_HOST_CE	(P_DEFINED | P_IDENT(GPIO_PG5) | P_FUNCT(1))
 #define P_HOST_RD	(P_DEFINED | P_IDENT(GPIO_PG6) | P_FUNCT(1))
 #define P_HOST_WR	(P_DEFINED | P_IDENT(GPIO_PG7) | P_FUNCT(1))
-- 
1.6.3.1

