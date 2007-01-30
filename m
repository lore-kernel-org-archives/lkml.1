Return-Path: <linux-kernel-owner+w=401wt.eu-S965110AbXA3Lct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbXA3Lct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965114AbXA3Lct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:32:49 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:51268 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965110AbXA3Lcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:32:48 -0500
X-Originating-Ip: 74.109.98.130
Date: Tue, 30 Jan 2007 06:06:00 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: [PATCH] Add "is_power_of_2" checking to log2.h.
Message-ID: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Add the inline function "is_power_of_2()" to log2.h, where the value
zero is *not* considered to be a power of two.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  while people are coming up with more and more clever ways to do
rounding, we can at least add the check for power-of-2 now, so we can
start the cleanup.


 arch/powerpc/mm/pgtable_32.c  |    5 +----
 arch/ppc/mm/pgtable.c         |    5 +----
 arch/ppc/syslib/ppc85xx_rio.c |    2 --
 drivers/net/gianfar_ethtool.c |    2 --
 include/linux/log2.h          |   11 +++++++++++
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 1891dbe..bd02272 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -294,11 +294,8 @@ void __init mapin_ram(void)
 	}
 }

-/* is x a power of 2? */
-#define is_power_of_2(x)	((x) != 0 && (((x) & ((x) - 1)) == 0))
-
 /* is x a power of 4? */
-#define is_power_of_4(x)	((x) != 0 && (((x) & (x-1)) == 0) && (ffs(x) & 1))
+#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))

 /*
  * Set up a mapping for a block of I/O.
diff --git a/arch/ppc/mm/pgtable.c b/arch/ppc/mm/pgtable.c
index 354a940..82b06a1 100644
--- a/arch/ppc/mm/pgtable.c
+++ b/arch/ppc/mm/pgtable.c
@@ -313,11 +313,8 @@ void __init mapin_ram(void)
 	}
 }

-/* is x a power of 2? */
-#define is_power_of_2(x)	((x) != 0 && (((x) & ((x) - 1)) == 0))
-
 /* is x a power of 4? */
-#define is_power_of_4(x)	((x) != 0 && (((x) & (x-1)) == 0) && (ffs(x) & 1))
+#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))

 /*
  * Set up a mapping for a block of I/O.
diff --git a/arch/ppc/syslib/ppc85xx_rio.c b/arch/ppc/syslib/ppc85xx_rio.c
index 05b0e94..2b09780 100644
--- a/arch/ppc/syslib/ppc85xx_rio.c
+++ b/arch/ppc/syslib/ppc85xx_rio.c
@@ -59,8 +59,6 @@
 #define DBELL_TID(x)		(*(u8 *)(x + DOORBELL_TID_OFFSET))
 #define DBELL_INF(x)		(*(u16 *)(x + DOORBELL_INFO_OFFSET))

-#define is_power_of_2(x)	(((x) & ((x) - 1)) == 0)
-
 struct rio_atmu_regs {
 	u32 rowtar;
 	u32 pad1;
diff --git a/drivers/net/gianfar_ethtool.c b/drivers/net/gianfar_ethtool.c
index 6d71bea..0d6943d 100644
--- a/drivers/net/gianfar_ethtool.c
+++ b/drivers/net/gianfar_ethtool.c
@@ -42,8 +42,6 @@

 #include "gianfar.h"

-#define is_power_of_2(x)        ((x) != 0 && (((x) & ((x) - 1)) == 0))
-
 extern void gfar_start(struct net_device *dev);
 extern int gfar_clean_rx_ring(struct net_device *dev, int rx_work_limit);

diff --git a/include/linux/log2.h b/include/linux/log2.h
index d02e1a5..99922be 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -44,6 +44,17 @@ int __ilog2_u64(u64 n)
 #endif

 /*
+ *  Determine whether some value is a power of two, where zero is
+ * *not* considered a power of two.
+ */
+
+static inline __attribute__((const))
+bool is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
+/*
  * round up to nearest power of two
  */
 static inline __attribute__((const))
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
