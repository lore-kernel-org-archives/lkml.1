Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbYJHXSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbYJHXSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 19:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYJHXR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 19:17:58 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:35981 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752887AbYJHXR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 19:17:58 -0400
Date: Thu, 9 Oct 2008 03:17:56 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: fsl_upm compile failure.
Message-ID: <20081008231756.GA2150@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081008222815.GA20542@redhat.com> <20081008230219.GA8075@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081008230219.GA8075@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 03:02:19AM +0400, Anton Vorontsov wrote:
> Though better option would be to uninline the fsl_upm_run_pattern()..
> it is quite big anyway... Something like this:

Even better. We don't need exported fsl_lbc_regs too. And also we can
mark the lock and regs as static. Yeah, w/o inline things look much
better.


diff --git a/arch/powerpc/include/asm/fsl_lbc.h b/arch/powerpc/include/asm/fsl_lbc.h
index 303f548..375f46c 100644
--- a/arch/powerpc/include/asm/fsl_lbc.h
+++ b/arch/powerpc/include/asm/fsl_lbc.h
@@ -24,7 +24,6 @@
 #define __ASM_FSL_LBC_H
 
 #include <linux/types.h>
-#include <linux/spinlock.h>
 #include <asm/io.h>
 
 struct fsl_lbc_bank {
@@ -227,9 +226,6 @@ struct fsl_lbc_regs {
 	u8 res8[0xF00];
 };
 
-extern struct fsl_lbc_regs __iomem *fsl_lbc_regs;
-extern spinlock_t fsl_lbc_lock;
-
 /*
  * FSL UPM routines
  */
@@ -268,44 +264,7 @@ static inline void fsl_upm_end_pattern(struct fsl_upm *upm)
 		cpu_relax();
 }
 
-/**
- * fsl_upm_run_pattern - actually run an UPM pattern
- * @upm:	pointer to the fsl_upm structure obtained via fsl_upm_find
- * @io_base:	remapped pointer to where memory access should happen
- * @mar:	MAR register content during pattern execution
- *
- * This function triggers dummy write to the memory specified by the io_base,
- * thus UPM pattern actually executed. Note that mar usage depends on the
- * pre-programmed AMX bits in the UPM RAM.
- */
-static inline int fsl_upm_run_pattern(struct fsl_upm *upm,
-				      void __iomem *io_base, u32 mar)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&fsl_lbc_lock, flags);
-
-	out_be32(&fsl_lbc_regs->mar, mar << (32 - upm->width));
-
-	switch (upm->width) {
-	case 8:
-		out_8(io_base, 0x0);
-		break;
-	case 16:
-		out_be16(io_base, 0x0);
-		break;
-	case 32:
-		out_be32(io_base, 0x0);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	spin_unlock_irqrestore(&fsl_lbc_lock, flags);
-
-	return ret;
-}
+extern int fsl_upm_run_pattern(struct fsl_upm *upm, void __iomem *io_base,
+			       u32 mar);
 
 #endif /* __ASM_FSL_LBC_H */
diff --git a/arch/powerpc/sysdev/fsl_lbc.c b/arch/powerpc/sysdev/fsl_lbc.c
index 422c8fa..cb4f570 100644
--- a/arch/powerpc/sysdev/fsl_lbc.c
+++ b/arch/powerpc/sysdev/fsl_lbc.c
@@ -13,12 +13,12 @@
 
 #include <linux/kernel.h>
 #include <linux/of.h>
+#include <linux/spinlock.h>
 #include <asm/fsl_lbc.h>
 
-spinlock_t fsl_lbc_lock = __SPIN_LOCK_UNLOCKED(fsl_lbc_lock);
+static spinlock_t fsl_lbc_lock = __SPIN_LOCK_UNLOCKED(fsl_lbc_lock);
 
-struct fsl_lbc_regs __iomem *fsl_lbc_regs;
-EXPORT_SYMBOL(fsl_lbc_regs);
+static struct fsl_lbc_regs __iomem *fsl_lbc_regs;
 
 static char __initdata *compat_lbc[] = {
 	"fsl,pq2-localbus",
@@ -127,3 +127,43 @@ int fsl_upm_find(phys_addr_t addr_base, struct fsl_upm *upm)
 	return 0;
 }
 EXPORT_SYMBOL(fsl_upm_find);
+
+/**
+ * fsl_upm_run_pattern - actually run an UPM pattern
+ * @upm:	pointer to the fsl_upm structure obtained via fsl_upm_find
+ * @io_base:	remapped pointer to where memory access should happen
+ * @mar:	MAR register content during pattern execution
+ *
+ * This function triggers dummy write to the memory specified by the io_base,
+ * thus UPM pattern actually executed. Note that mar usage depends on the
+ * pre-programmed AMX bits in the UPM RAM.
+ */
+int fsl_upm_run_pattern(struct fsl_upm *upm, void __iomem *io_base, u32 mar)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fsl_lbc_lock, flags);
+
+	out_be32(&fsl_lbc_regs->mar, mar << (32 - upm->width));
+
+	switch (upm->width) {
+	case 8:
+		out_8(io_base, 0x0);
+		break;
+	case 16:
+		out_be16(io_base, 0x0);
+		break;
+	case 32:
+		out_be32(io_base, 0x0);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	spin_unlock_irqrestore(&fsl_lbc_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(fsl_upm_run_pattern);
