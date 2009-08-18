Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbZHRWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbZHRWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZHRWET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:04:19 -0400
Received: from ru.mvista.com ([213.79.90.228]:44075 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751227AbZHRWER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:04:17 -0400
Date: Wed, 19 Aug 2009 02:04:18 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] powerpc/qe&cpm: Implement static inline stubs for
 non-QE/CPM builds
Message-ID: <20090818220418.GD25090@oksana.dev.rtsoft.ru>
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to avoid ugly #ifdefs in drivers. Also update fsl_qe_udc
driver so that now it doesn't define its own versions that cause build
breakage when the generic stubs are used.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/include/asm/cpm.h  |   44 +++++++++++++++++++++++++++++++++++++++
 arch/powerpc/include/asm/qe.h   |   11 ++++++++-
 drivers/usb/gadget/fsl_qe_udc.h |   15 -------------
 3 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/cpm.h b/arch/powerpc/include/asm/cpm.h
index ea3fdb9..0835eb9 100644
--- a/arch/powerpc/include/asm/cpm.h
+++ b/arch/powerpc/include/asm/cpm.h
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/errno.h>
 #include <linux/of.h>
 
 /*
@@ -131,13 +132,56 @@ typedef struct cpm_buf_desc {
 #define BD_I2C_START		(0x0400)
 
 int cpm_muram_init(void);
+
+#if defined(CONFIG_CPM) || defined(CONFIG_QUICC_ENGINE)
 unsigned long cpm_muram_alloc(unsigned long size, unsigned long align);
 int cpm_muram_free(unsigned long offset);
 unsigned long cpm_muram_alloc_fixed(unsigned long offset, unsigned long size);
 void __iomem *cpm_muram_addr(unsigned long offset);
 unsigned long cpm_muram_offset(void __iomem *addr);
 dma_addr_t cpm_muram_dma(void __iomem *addr);
+#else
+static inline unsigned long cpm_muram_alloc(unsigned long size,
+					    unsigned long align)
+{
+	return -ENOSYS;
+}
+
+static inline int cpm_muram_free(unsigned long offset)
+{
+	return -ENOSYS;
+}
+
+static inline unsigned long cpm_muram_alloc_fixed(unsigned long offset,
+						  unsigned long size)
+{
+	return -ENOSYS;
+}
+
+static inline void __iomem *cpm_muram_addr(unsigned long offset)
+{
+	return NULL;
+}
+
+static inline unsigned long cpm_muram_offset(void __iomem *addr)
+{
+	return -ENOSYS;
+}
+
+static inline dma_addr_t cpm_muram_dma(void __iomem *addr)
+{
+	return 0;
+}
+#endif /* defined(CONFIG_CPM) || defined(CONFIG_QUICC_ENGINE) */
+
+#ifdef CONFIG_CPM
 int cpm_command(u32 command, u8 opcode);
+#else
+static inline int cpm_command(u32 command, u8 opcode)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_CPM */
 
 int cpm2_gpiochip_add32(struct device_node *np);
 
diff --git a/arch/powerpc/include/asm/qe.h b/arch/powerpc/include/asm/qe.h
index 157c5ca..791c67a 100644
--- a/arch/powerpc/include/asm/qe.h
+++ b/arch/powerpc/include/asm/qe.h
@@ -145,8 +145,17 @@ static inline void qe_pin_set_gpio(struct qe_pin *qe_pin) {}
 static inline void qe_pin_set_dedicated(struct qe_pin *pin) {}
 #endif /* CONFIG_QE_GPIO */
 
-/* QE internal API */
+#ifdef CONFIG_QUICC_ENGINE
 int qe_issue_cmd(u32 cmd, u32 device, u8 mcn_protocol, u32 cmd_input);
+#else
+static inline int qe_issue_cmd(u32 cmd, u32 device, u8 mcn_protocol,
+			       u32 cmd_input)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_QUICC_ENGINE */
+
+/* QE internal API */
 enum qe_clock qe_clock_source(const char *source);
 unsigned int qe_get_brg_clk(void);
 int qe_setbrg(enum qe_clock brg, unsigned int rate, unsigned int multiplier);
diff --git a/drivers/usb/gadget/fsl_qe_udc.h b/drivers/usb/gadget/fsl_qe_udc.h
index 31b2710..bea5b82 100644
--- a/drivers/usb/gadget/fsl_qe_udc.h
+++ b/drivers/usb/gadget/fsl_qe_udc.h
@@ -419,19 +419,4 @@ struct qe_udc {
 #define CPM_USB_RESTART_TX_OPCODE 0x0b
 #define CPM_USB_EP_SHIFT 5
 
-#ifndef CONFIG_CPM
-inline int cpm_command(u32 command, u8 opcode)
-{
-	return -EOPNOTSUPP;
-}
-#endif
-
-#ifndef CONFIG_QUICC_ENGINE
-inline int qe_issue_cmd(u32 cmd, u32 device, u8 mcn_protocol,
-	u32 cmd_input)
-{
-	return -EOPNOTSUPP;
-}
-#endif
-
 #endif  /* __FSL_QE_UDC_H */
-- 
1.6.3.3

