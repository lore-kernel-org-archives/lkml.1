Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbZBLVaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbZBLVaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbZBLVaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:30:07 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:35899 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZBLVaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:30:06 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Zhu Yi <yi.zhu@intel.com>, James Ketrenos <jketreno@linux.intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/1] ipw2200, fix ipw io functions
Date: Thu, 12 Feb 2009 22:29:40 +0100
Message-Id: <1234474180-910-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- some of them are defined as follows:
  #define ipw_write32	expr1; expr2
  and are called from loops or ifs without a compound statement, so
  they are broken. Fix it by putting them into do {} while (0) for
  writes and ({ }) for reads.
- also unify and cleanup them while at it -- convert them from
  macros to inline functions, so that we get some basic typechecking

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: James Ketrenos <jketreno@linux.intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |  106 ++++++++++++++++++--------------
 1 files changed, 60 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index fc527b9..c3a2114 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -301,88 +301,102 @@ static inline void ipw_write_reg32(struct ipw_priv *a, u32 b, u32 c)
 }
 
 /* 8-bit direct write (low 4K) */
-#define _ipw_write8(ipw, ofs, val) writeb((val), (ipw)->hw_base + (ofs))
+static inline void _ipw_write8(struct ipw_priv *ipw, unsigned long ofs,
+		u8 val)
+{
+	writeb(val, ipw->hw_base + ofs);
+}
 
 /* 8-bit direct write (for low 4K of SRAM/regs), with debug wrapper */
 #define ipw_write8(ipw, ofs, val) do { \
- IPW_DEBUG_IO("%s %d: write_direct8(0x%08X, 0x%08X)\n", __FILE__, __LINE__, (u32)(ofs), (u32)(val)); \
- _ipw_write8(ipw, ofs, val); \
- } while (0)
+	IPW_DEBUG_IO("%s %d: write_direct8(0x%08X, 0x%08X)\n", __FILE__, \
+			__LINE__, (u32)(ofs), (u32)(val)); \
+	_ipw_write8(ipw, ofs, val); \
+} while (0)
 
 /* 16-bit direct write (low 4K) */
-#define _ipw_write16(ipw, ofs, val) writew((val), (ipw)->hw_base + (ofs))
+static inline void _ipw_write16(struct ipw_priv *ipw, unsigned long ofs,
+		u16 val)
+{
+	writew(val, ipw->hw_base + ofs);
+}
 
 /* 16-bit direct write (for low 4K of SRAM/regs), with debug wrapper */
-#define ipw_write16(ipw, ofs, val) \
- IPW_DEBUG_IO("%s %d: write_direct16(0x%08X, 0x%08X)\n", __FILE__, __LINE__, (u32)(ofs), (u32)(val)); \
- _ipw_write16(ipw, ofs, val)
+#define ipw_write16(ipw, ofs, val) do { \
+	IPW_DEBUG_IO("%s %d: write_direct16(0x%08X, 0x%08X)\n", __FILE__, \
+			__LINE__, (u32)(ofs), (u32)(val)); \
+	_ipw_write16(ipw, ofs, val); \
+} while (0)
 
 /* 32-bit direct write (low 4K) */
-#define _ipw_write32(ipw, ofs, val) writel((val), (ipw)->hw_base + (ofs))
+static inline void _ipw_write32(struct ipw_priv *ipw, unsigned long ofs,
+		u32 val)
+{
+	writel(val, ipw->hw_base + ofs);
+}
 
 /* 32-bit direct write (for low 4K of SRAM/regs), with debug wrapper */
-#define ipw_write32(ipw, ofs, val) \
- IPW_DEBUG_IO("%s %d: write_direct32(0x%08X, 0x%08X)\n", __FILE__, __LINE__, (u32)(ofs), (u32)(val)); \
- _ipw_write32(ipw, ofs, val)
+#define ipw_write32(ipw, ofs, val) do { \
+	IPW_DEBUG_IO("%s %d: write_direct32(0x%08X, 0x%08X)\n", __FILE__, \
+			__LINE__, (u32)(ofs), (u32)(val)); \
+	_ipw_write32(ipw, ofs, val); \
+} while (0)
 
 /* 8-bit direct read (low 4K) */
-#define _ipw_read8(ipw, ofs) readb((ipw)->hw_base + (ofs))
-
-/* 8-bit direct read (low 4K), with debug wrapper */
-static inline u8 __ipw_read8(char *f, u32 l, struct ipw_priv *ipw, u32 ofs)
+static inline u8 _ipw_read8(struct ipw_priv *ipw, unsigned long ofs)
 {
-	IPW_DEBUG_IO("%s %d: read_direct8(0x%08X)\n", f, l, (u32) (ofs));
-	return _ipw_read8(ipw, ofs);
+	return readb(ipw->hw_base + ofs);
 }
 
 /* alias to 8-bit direct read (low 4K of SRAM/regs), with debug wrapper */
-#define ipw_read8(ipw, ofs) __ipw_read8(__FILE__, __LINE__, ipw, ofs)
+#define ipw_read8(ipw, ofs) ({ \
+	IPW_DEBUG_IO("%s %d: read_direct8(0x%08X)\n", __FILE__, __LINE__, \
+			(u32)(ofs)); \
+	_ipw_read8(ipw, ofs); \
+})
 
 /* 16-bit direct read (low 4K) */
-#define _ipw_read16(ipw, ofs) readw((ipw)->hw_base + (ofs))
-
-/* 16-bit direct read (low 4K), with debug wrapper */
-static inline u16 __ipw_read16(char *f, u32 l, struct ipw_priv *ipw, u32 ofs)
+static inline u16 _ipw_read16(struct ipw_priv *ipw, unsigned long ofs)
 {
-	IPW_DEBUG_IO("%s %d: read_direct16(0x%08X)\n", f, l, (u32) (ofs));
-	return _ipw_read16(ipw, ofs);
+	return readw(ipw->hw_base + ofs);
 }
 
 /* alias to 16-bit direct read (low 4K of SRAM/regs), with debug wrapper */
-#define ipw_read16(ipw, ofs) __ipw_read16(__FILE__, __LINE__, ipw, ofs)
+#define ipw_read16(ipw, ofs) ({ \
+	IPW_DEBUG_IO("%s %d: read_direct16(0x%08X)\n", __FILE__, __LINE__, \
+			(u32)(ofs)); \
+	_ipw_read16(ipw, ofs); \
+})
 
 /* 32-bit direct read (low 4K) */
-#define _ipw_read32(ipw, ofs) readl((ipw)->hw_base + (ofs))
-
-/* 32-bit direct read (low 4K), with debug wrapper */
-static inline u32 __ipw_read32(char *f, u32 l, struct ipw_priv *ipw, u32 ofs)
+static inline u32 _ipw_read32(struct ipw_priv *ipw, unsigned long ofs)
 {
-	IPW_DEBUG_IO("%s %d: read_direct32(0x%08X)\n", f, l, (u32) (ofs));
-	return _ipw_read32(ipw, ofs);
+	return readl(ipw->hw_base + ofs);
 }
 
 /* alias to 32-bit direct read (low 4K of SRAM/regs), with debug wrapper */
-#define ipw_read32(ipw, ofs) __ipw_read32(__FILE__, __LINE__, ipw, ofs)
+#define ipw_read32(ipw, ofs) ({ \
+	IPW_DEBUG_IO("%s %d: read_direct32(0x%08X)\n", __FILE__, __LINE__, \
+			(u32)(ofs)); \
+	_ipw_read32(ipw, ofs); \
+})
 
-/* multi-byte read (above 4K), with debug wrapper */
 static void _ipw_read_indirect(struct ipw_priv *, u32, u8 *, int);
-static inline void __ipw_read_indirect(const char *f, int l,
-				       struct ipw_priv *a, u32 b, u8 * c, int d)
-{
-	IPW_DEBUG_IO("%s %d: read_indirect(0x%08X) %d bytes\n", f, l, (u32) (b),
-		     d);
-	_ipw_read_indirect(a, b, c, d);
-}
-
 /* alias to multi-byte read (SRAM/regs above 4K), with debug wrapper */
-#define ipw_read_indirect(a, b, c, d) __ipw_read_indirect(__FILE__, __LINE__, a, b, c, d)
+#define ipw_read_indirect(a, b, c, d) ({ \
+	IPW_DEBUG_IO("%s %d: read_indirect(0x%08X) %u bytes\n", __FILE__, \
+			__LINE__, (u32)(b), (u32)(d)); \
+	_ipw_read_indirect(a, b, c, d); \
+})
 
 /* alias to multi-byte read (SRAM/regs above 4K), with debug wrapper */
 static void _ipw_write_indirect(struct ipw_priv *priv, u32 addr, u8 * data,
 				int num);
-#define ipw_write_indirect(a, b, c, d) \
-	IPW_DEBUG_IO("%s %d: write_indirect(0x%08X) %d bytes\n", __FILE__, __LINE__, (u32)(b), d); \
-	_ipw_write_indirect(a, b, c, d)
+#define ipw_write_indirect(a, b, c, d) do { \
+	IPW_DEBUG_IO("%s %d: write_indirect(0x%08X) %u bytes\n", __FILE__, \
+			__LINE__, (u32)(b), (u32)(d)); \
+	_ipw_write_indirect(a, b, c, d); \
+} while (0)
 
 /* 32-bit indirect write (above 4K) */
 static void _ipw_write_reg32(struct ipw_priv *priv, u32 reg, u32 value)
-- 
1.6.1.3

