Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYJIAdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYJIAdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYJIAdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:33:05 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:36222 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757013AbYJIAdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:33:03 -0400
Date: Thu, 9 Oct 2008 04:32:59 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc: fix fsl_upm nand driver modular build
Message-ID: <20081009003259.GA8373@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081008222815.GA20542@redhat.com> <20081008230219.GA8075@oksana.dev.rtsoft.ru> <20081008233306.GA31771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081008233306.GA31771@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsl_upm nand driver fails to build because fsl_lbc_lock isn't
exported, the lock is needed by the inlined fsl_upm_run_pattern()
function:

ERROR: "fsl_lbc_lock" [drivers/mtd/nand/fsl_upm.ko] undefined!

Dave Jones purposed to export the lock, but it is better to just uninline
the fsl_upm_run_pattern().

When uninlined we also no longer need the exported fsl_lbc_regs, and
both fsl_lbc_lock and fsl_lbc_regs could be marked static.

While at it, also add some missing includes that we should have included
explicitly.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Wed, Oct 08, 2008 at 07:33:06PM -0400, Dave Jones wrote:
[...]
>  > > ERROR: "fsl_lbc_lock" [drivers/mtd/nand/fsl_upm.ko] undefined!
>  > 
>  > Weird. It works for me with mpc836x_rdk_defconfig and
>  > MTD_NAND_FSL_UPM=m...
>  > 
>  > Hm..
>  > 
>  >   CC      drivers/mtd/nand/fsl_upm.mod.o
>  >   LD [M]  drivers/mtd/nand/fsl_upm.ko
>  > 
>  > Can you send me the .config file you use?
>  
> http://davej.fedorapeople.org/ppc.config

Still works here. :-/  I'm using latest Linus' git tree, pulled few
minutes ago just in case.

gcc version 4.2.0 (MontaVista 4.2.0-16.0.20.0800760 2008-04-05)
GNU ld (GNU Binutils) 2.17.50.20070611

Most probably something on my side, maybe need to update the toolchain.

>  > But the patch looks obviously correct. Much thanks for catching this.
>  > 
>  > Though better option would be to uninline the fsl_upm_run_pattern()..
>  > it is quite big anyway... Something like this:
> 
> I'll leave it to you to decide what to push to Linus

Ok, here it is. Since I'm unable to reproduce the error, I'd
appreciate Tested-by: tag if you could find time to build-test
the patch. It works for me though...

Thanks again,

 arch/powerpc/include/asm/fsl_lbc.h |   48 +++-----------------------------
 arch/powerpc/sysdev/fsl_lbc.c      |   53 +++++++++++++++++++++++++++++++++---
 2 files changed, 53 insertions(+), 48 deletions(-)

diff --git a/arch/powerpc/include/asm/fsl_lbc.h b/arch/powerpc/include/asm/fsl_lbc.h
index 303f548..63a4f77 100644
--- a/arch/powerpc/include/asm/fsl_lbc.h
+++ b/arch/powerpc/include/asm/fsl_lbc.h
@@ -23,9 +23,9 @@
 #ifndef __ASM_FSL_LBC_H
 #define __ASM_FSL_LBC_H
 
+#include <linux/compiler.h>
 #include <linux/types.h>
-#include <linux/spinlock.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 struct fsl_lbc_bank {
 	__be32 br;             /**< Base Register  */
@@ -227,9 +227,6 @@ struct fsl_lbc_regs {
 	u8 res8[0xF00];
 };
 
-extern struct fsl_lbc_regs __iomem *fsl_lbc_regs;
-extern spinlock_t fsl_lbc_lock;
-
 /*
  * FSL UPM routines
  */
@@ -268,44 +265,7 @@ static inline void fsl_upm_end_pattern(struct fsl_upm *upm)
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
index 422c8fa..0494ee5 100644
--- a/arch/powerpc/sysdev/fsl_lbc.c
+++ b/arch/powerpc/sysdev/fsl_lbc.c
@@ -11,14 +11,19 @@
  * (at your option) any later version.
  */
 
+#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/io.h>
 #include <linux/of.h>
+#include <asm/prom.h>
 #include <asm/fsl_lbc.h>
 
-spinlock_t fsl_lbc_lock = __SPIN_LOCK_UNLOCKED(fsl_lbc_lock);
-
-struct fsl_lbc_regs __iomem *fsl_lbc_regs;
-EXPORT_SYMBOL(fsl_lbc_regs);
+static spinlock_t fsl_lbc_lock = __SPIN_LOCK_UNLOCKED(fsl_lbc_lock);
+static struct fsl_lbc_regs __iomem *fsl_lbc_regs;
 
 static char __initdata *compat_lbc[] = {
 	"fsl,pq2-localbus",
@@ -127,3 +132,43 @@ int fsl_upm_find(phys_addr_t addr_base, struct fsl_upm *upm)
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
-- 
1.5.6.3

