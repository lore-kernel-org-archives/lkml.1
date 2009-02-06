Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbZBFVTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbZBFVTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZBFVTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:19:38 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33782 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZBFVTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:19:36 -0500
Date: Fri, 6 Feb 2009 14:19:34 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH D 11/11] Fix omap1 clock issues
In-Reply-To: <20090129143733.GB18233@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902061417390.26737@utopia.booyaka.com>
References: <20090128191638.16688.33452.stgit@localhost.localdomain> <20090128191844.16688.39372.stgit@localhost.localdomain> <20090129143733.GB18233@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Thu, 29 Jan 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:18:48PM -0700, Paul Walmsley wrote:
> > From: Tony Lindgren <tony@atomide.com>
> > 
> > This fixes booting, and is a step toward fixing things properly:
> > 
> > - Make enable_reg u32 instead of u16
> 
> No, you're passing this to __raw_read/write, so it needs to be
> void __iomem *, not u32.  If there's another patch doing that it
> needs to be combined with this one.  The miniscule details of
> fixes upon fixes aren't interesting for submission purposes, and
> just adds extra unnecessary review load for upstream people.
> 
> Ditto for anything else which is passed to __raw_read/write*.

The patch below is a replacement for D 11.  Thanks to Tony for helping 
debug this patch.


- Paul

From: Tony Lindgren <tony@atomide.com>
Date: Fri, 6 Feb 2009 12:14:14 -0700
Subject: [PATCH] Fix omap1 clock issues

This fixes booting, and is a step toward fixing things properly:

- Get rid of VIRTUAL_IO_ADDRESS for clocks
- Use __raw_read/write instead of omap_read/write for clock registers

[paul@pwsan.com: This patch has been updated to use offsets for OMAP1 
clock enable registers, to resolve all current sparse warnings with the 
clock code, and to convert most magic constants into symbolic macros.  
This revision based on review feedback from Russell King 
<linux@arm.linux.org.uk>]

linux-omap source commit is 9d1dff8638c9e96a401e1885f9948662e9ff9636.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Russell King <linux@arm.linux.org.uk>

---
 arch/arm/mach-omap1/clock.c                |  175 +++++++++++++++------------
 arch/arm/mach-omap1/clock.h                |  163 ++++++++++++++++----------
 arch/arm/plat-omap/include/mach/clock.h    |    8 +-
 arch/arm/plat-omap/include/mach/hardware.h |   67 ++++++++---
 arch/arm/plat-omap/include/mach/io.h       |    3 +
 arch/arm/plat-omap/include/mach/usb.h      |    4 +-
 6 files changed, 263 insertions(+), 157 deletions(-)

diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index 5fba207..274a07c 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -30,10 +30,84 @@
 
 __u32 arm_idlect1_mask;
 
+/*
+ * OMAP1_MPU_BASE_TO_MOD_OFFS is an additional offset for enable_reg
+ * address computation.  It allows us to keep mod_offs short (16 bits)
+ * while keeping OMAP1_MPU_BASE consistent with the OMAP1
+ * documentation.
+ */
+#define OMAP1_MPU_BASE_TO_MOD_OFFS      0x0ff00000
+
 /*-------------------------------------------------------------------------
  * Omap1 specific clock functions
  *-------------------------------------------------------------------------*/
 
+/**
+ * omap1_clk_get_enable_addr - return enable_reg IO addr from offsets in clk
+ * @clk: struct clk * to return an enable_reg address for
+ *
+ * Return the virtual address of the clock enable register for the clock
+ * @clk.
+ */
+static void __iomem *omap1_clk_get_enable_addr(struct clk *clk)
+{
+	u32 b;
+
+	WARN(!clk->mod_offs, "clock: %s: missing mod_offs\n", clk->name);
+
+	if (clk->flags & OMAP1_DSP_CLOCK)
+		b = OMAP1_DSP_IO_BASE;
+	else
+		b = OMAP1_MPU_BASE + OMAP1_MPU_BASE_TO_MOD_OFFS;
+
+	b += (clk->mod_offs << 8);
+	b += clk->enable_reg;
+
+	return OMAP1_IO_ADDRESS(b);
+}
+
+/**
+ * omap1_read_enable_reg - return contents of the clk's enable_reg register
+ * @clk: struct clk *
+ *
+ * Return the contents of the enable_reg register for clk @clk.
+ * Always returns a 32-bit value.  For clock registers that are only
+ * 16 bits wide, the register value will be in the lower 16 bits of
+ * the return value.
+ */
+static u32 omap1_read_enable_reg(struct clk *clk)
+{
+	void __iomem *r;
+
+	r = omap1_clk_get_enable_addr(clk);
+
+	if (clk->flags & ENABLE_REG_32BIT)
+		return __raw_readl(r);
+	else
+		return __raw_readw(r);
+}
+
+/**
+ * omap1_write_enable_reg - write a value to the clk's enable_reg
+ * @v: value to write (32 bits)
+ * @clk: struct clk *
+ *
+ * Write @v to the register referenced by the @clk enable_reg.  For
+ * 16-bit wide clock registers, the lower 16 bits of @v .are written.
+ * No return value.
+ */
+static void omap1_write_enable_reg(u32 v, struct clk *clk)
+{
+	void __iomem *r;
+
+	r = omap1_clk_get_enable_addr(clk);
+
+	if (clk->flags & ENABLE_REG_32BIT)
+		__raw_writel(v, r);
+	else
+		__raw_writew((v & 0xffff), r);
+}
+
 static void omap1_watchdog_recalc(struct clk * clk)
 {
 	clk->rate = clk->parent->rate / 14;
@@ -41,7 +115,7 @@ static void omap1_watchdog_recalc(struct clk * clk)
 
 static void omap1_uart_recalc(struct clk * clk)
 {
-	unsigned int val = omap_readl(clk->enable_reg);
+	unsigned int val = omap1_read_enable_reg(clk);
 	if (val & clk->enable_bit)
 		clk->rate = 48000000;
 	else
@@ -372,14 +446,14 @@ static int omap1_set_uart_rate(struct clk * clk, unsigned long rate)
 {
 	unsigned int val;
 
-	val = omap_readl(clk->enable_reg);
+	val = omap1_read_enable_reg(clk);
 	if (rate == 12000000)
 		val &= ~(1 << clk->enable_bit);
 	else if (rate == 48000000)
 		val |= (1 << clk->enable_bit);
 	else
 		return -EINVAL;
-	omap_writel(val, clk->enable_reg);
+	omap1_write_enable_reg(val, clk);
 	clk->rate = rate;
 
 	return 0;
@@ -398,8 +472,8 @@ static int omap1_set_ext_clk_rate(struct clk * clk, unsigned long rate)
 	else
 		ratio_bits = (dsor - 2) << 2;
 
-	ratio_bits |= omap_readw(clk->enable_reg) & ~0xfd;
-	omap_writew(ratio_bits, clk->enable_reg);
+	ratio_bits |= omap1_read_enable_reg(clk) & ~0xfd;
+	omap1_write_enable_reg(ratio_bits, clk);
 
 	return 0;
 }
@@ -440,8 +514,8 @@ static void omap1_init_ext_clk(struct clk * clk)
 	__u16 ratio_bits;
 
 	/* Determine current rate and ensure clock is based on 96MHz APLL */
-	ratio_bits = omap_readw(clk->enable_reg) & ~1;
-	omap_writew(ratio_bits, clk->enable_reg);
+	ratio_bits = omap1_read_enable_reg(clk) & ~1;
+	omap1_write_enable_reg(ratio_bits, clk);
 
 	ratio_bits = (ratio_bits & 0xfc) >> 2;
 	if (ratio_bits > 6)
@@ -493,72 +567,28 @@ static void omap1_clk_disable(struct clk *clk)
 
 static int omap1_clk_enable_generic(struct clk *clk)
 {
-	__u16 regval16;
-	__u32 regval32;
+	u32 v;
 
 	if (clk->flags & ALWAYS_ENABLED)
 		return 0;
 
-	if (unlikely(clk->enable_reg == NULL)) {
-		printk(KERN_ERR "clock.c: Enable for %s without enable code\n",
-		       clk->name);
-		return -EINVAL;
-	}
-
-	if (clk->flags & ENABLE_REG_32BIT) {
-		if (clk->flags & VIRTUAL_IO_ADDRESS) {
-			regval32 = __raw_readl(clk->enable_reg);
-			regval32 |= (1 << clk->enable_bit);
-			__raw_writel(regval32, clk->enable_reg);
-		} else {
-			regval32 = omap_readl(clk->enable_reg);
-			regval32 |= (1 << clk->enable_bit);
-			omap_writel(regval32, clk->enable_reg);
-		}
-	} else {
-		if (clk->flags & VIRTUAL_IO_ADDRESS) {
-			regval16 = __raw_readw(clk->enable_reg);
-			regval16 |= (1 << clk->enable_bit);
-			__raw_writew(regval16, clk->enable_reg);
-		} else {
-			regval16 = omap_readw(clk->enable_reg);
-			regval16 |= (1 << clk->enable_bit);
-			omap_writew(regval16, clk->enable_reg);
-		}
-	}
+	v = omap1_read_enable_reg(clk);
+	v |= (1 << clk->enable_bit);
+	omap1_write_enable_reg(v, clk);
 
 	return 0;
 }
 
 static void omap1_clk_disable_generic(struct clk *clk)
 {
-	__u16 regval16;
-	__u32 regval32;
+	u32 v;
 
-	if (clk->enable_reg == NULL)
-		return;
+	if (clk->flags & ALWAYS_ENABLED)
+		return 0;
 
-	if (clk->flags & ENABLE_REG_32BIT) {
-		if (clk->flags & VIRTUAL_IO_ADDRESS) {
-			regval32 = __raw_readl(clk->enable_reg);
-			regval32 &= ~(1 << clk->enable_bit);
-			__raw_writel(regval32, clk->enable_reg);
-		} else {
-			regval32 = omap_readl(clk->enable_reg);
-			regval32 &= ~(1 << clk->enable_bit);
-			omap_writel(regval32, clk->enable_reg);
-		}
-	} else {
-		if (clk->flags & VIRTUAL_IO_ADDRESS) {
-			regval16 = __raw_readw(clk->enable_reg);
-			regval16 &= ~(1 << clk->enable_bit);
-			__raw_writew(regval16, clk->enable_reg);
-		} else {
-			regval16 = omap_readw(clk->enable_reg);
-			regval16 &= ~(1 << clk->enable_bit);
-			omap_writew(regval16, clk->enable_reg);
-		}
-	}
+	v = omap1_read_enable_reg(clk);
+	v &= ~(1 << clk->enable_bit);
+	omap1_write_enable_reg(v, clk);
 }
 
 static long omap1_clk_round_rate(struct clk *clk, unsigned long rate)
@@ -621,30 +651,19 @@ static int omap1_clk_set_rate(struct clk *clk, unsigned long rate)
 
 static void __init omap1_clk_disable_unused(struct clk *clk)
 {
-	__u32 regval32;
+	u32 v;
 
 	/* Clocks in the DSP domain need api_ck. Just assume bootloader
 	 * has not enabled any DSP clocks */
-	if (clk->enable_reg == DSP_IDLECT2) {
+	if (clk->enable_reg == DSP_IDLECT2_OFFSET) {
 		printk(KERN_INFO "Skipping reset check for DSP domain "
 		       "clock \"%s\"\n", clk->name);
 		return;
 	}
 
 	/* Is the clock already disabled? */
-	if (clk->flags & ENABLE_REG_32BIT) {
-		if (clk->flags & VIRTUAL_IO_ADDRESS)
-			regval32 = __raw_readl(clk->enable_reg);
-			else
-				regval32 = omap_readl(clk->enable_reg);
-	} else {
-		if (clk->flags & VIRTUAL_IO_ADDRESS)
-			regval32 = __raw_readw(clk->enable_reg);
-		else
-			regval32 = omap_readw(clk->enable_reg);
-	}
-
-	if ((regval32 & (1 << clk->enable_bit)) == 0)
+	v = omap1_read_enable_reg(clk);
+	if ((v & (1 << clk->enable_bit)) == 0)
 		return;
 
 	/* FIXME: This clock seems to be necessary but no-one
@@ -690,8 +709,8 @@ int __init omap1_clk_init(void)
 #endif
 
 	/* USB_REQ_EN will be disabled later if necessary (usb_dc_ck) */
-	reg = omap_readw(SOFT_REQ_REG) & (1 << 4);
-	omap_writew(reg, SOFT_REQ_REG);
+	reg = omap_readw(ULPD_SOFT_REQ) & (1 << 4);
+	omap_writew(reg, ULPD_SOFT_REQ);
 	if (!cpu_is_omap15xx())
 		omap_writew(0, SOFT_REQ_REG2);
 
diff --git a/arch/arm/mach-omap1/clock.h b/arch/arm/mach-omap1/clock.h
index c1dcdf1..016d7eb 100644
--- a/arch/arm/mach-omap1/clock.h
+++ b/arch/arm/mach-omap1/clock.h
@@ -98,9 +98,19 @@ struct arm_idlect1_clk {
 #define COM_ULPD_PLL_CLK_REQ	1	/* In COM_CLK_DIV_CTRL_SEL */
 #define SWD_CLK_DIV_CTRL_SEL	0xfffe0874
 #define COM_CLK_DIV_CTRL_SEL	0xfffe0878
-#define SOFT_REQ_REG		0xfffe0834
 #define SOFT_REQ_REG2		0xfffe0880
 
+/* Offsets for OMAP1 modules that contain clock control registers */
+
+/* DSP offsets are shifted left 8 and added to OMAP1_DSP_IO_BASE */
+#define DSP_CONFIG_OFFS		0x0080		/* = e1008000 */
+
+/* MPU offsets are shifted left 8 and added to OMAP1_MPU_BASE + 0x0ff00000 */
+#define MPU_OTG_OFFS		0x0b04		/* = fffb0400 */
+#define MPU_ULPD_OFFS		0x0e08		/* = fffe0800 */
+#define MPU_CONF_OFFS		0x0e10		/* = fffe1000 */
+#define MPU_CLKGEN_OFFS		0x0ece		/* = fffece00 */
+
 /*-------------------------------------------------------------------------
  * Omap1 MPU rate table
  *-------------------------------------------------------------------------*/
@@ -174,13 +184,14 @@ static struct arm_idlect1_clk ck_dpll1out = {
 		.parent		= &ck_dpll1,
 		.flags		= CLOCK_IN_OMAP16XX | CLOCK_IDLE_CONTROL |
 				  ENABLE_REG_32BIT | RATE_PROPAGATES,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_CKOUT_ARM,
 		.recalc		= &followparent_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 12,
+	.idlect_shift	= IDL_CLKOUT_ARM_SHIFT, /* XXX duplicate? */
 };
 
 static struct clk sossi_ck = {
@@ -188,8 +199,9 @@ static struct clk sossi_ck = {
 	.parent		= &ck_dpll1out.clk,
 	.flags		= CLOCK_IN_OMAP16XX | CLOCK_NO_IDLE_PARENT |
 			  ENABLE_REG_32BIT,
-	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_1,
-	.enable_bit	= 16,
+	.mod_offs	= MPU_CONF_OFFS,
+	.enable_reg	= MOD_CONF_CTRL_1_OFFSET,
+	.enable_bit	= CONF_MOD_SOSSI_CLK_EN_R_SHIFT,
 	.recalc		= &omap1_sossi_recalc,
 	.set_rate	= &omap1_set_sossi_rate,
 	.enable		= &omap1_clk_enable_generic,
@@ -215,21 +227,23 @@ static struct arm_idlect1_clk armper_ck = {
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 				  CLOCK_IN_OMAP310 | RATE_CKCTL |
 				  CLOCK_IDLE_CONTROL,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_PERCK,
 		.rate_offset	= CKCTL_PERDIV_OFFSET,
 		.recalc		= &omap1_ckctl_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 2,
+	.idlect_shift	= IDL_CLKOUT_ARM_SHIFT,
 };
 
 static struct clk arm_gpio_ck = {
 	.name		= "arm_gpio_ck",
 	.parent		= &ck_dpll1,
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310,
-	.enable_reg	= (void __iomem *)ARM_IDLECT2,
+	.mod_offs	= MPU_CLKGEN_OFFS,
+	.enable_reg	= ARM_IDLECT2_OFFSET,
 	.enable_bit	= EN_GPIOCK,
 	.recalc		= &followparent_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -242,13 +256,14 @@ static struct arm_idlect1_clk armxor_ck = {
 		.parent		= &ck_ref,
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 				  CLOCK_IN_OMAP310 | CLOCK_IDLE_CONTROL,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_XORPCK,
 		.recalc		= &followparent_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 1,
+	.idlect_shift	= IDLXORP_ARM_SHIFT,
 };
 
 static struct arm_idlect1_clk armtim_ck = {
@@ -257,13 +272,14 @@ static struct arm_idlect1_clk armtim_ck = {
 		.parent		= &ck_ref,
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 				  CLOCK_IN_OMAP310 | CLOCK_IDLE_CONTROL,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_TIMCK,
 		.recalc		= &followparent_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 9,
+	.idlect_shift	= IDLTIM_ARM_SHIFT,
 };
 
 static struct arm_idlect1_clk armwdt_ck = {
@@ -272,13 +288,14 @@ static struct arm_idlect1_clk armwdt_ck = {
 		.parent		= &ck_ref,
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 				  CLOCK_IN_OMAP310 | CLOCK_IDLE_CONTROL,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_WDTCK,
 		.recalc		= &omap1_watchdog_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 0,
+	.idlect_shift	= IDLWDT_ARM_SHIFT,
 };
 
 static struct clk arminth_ck16xx = {
@@ -300,7 +317,8 @@ static struct clk dsp_ck = {
 	.parent		= &ck_dpll1,
 	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  RATE_CKCTL,
-	.enable_reg	= (void __iomem *)ARM_CKCTL,
+	.mod_offs	= MPU_CLKGEN_OFFS,
+	.enable_reg	= ARM_CKCTL_OFFSET,
 	.enable_bit	= EN_DSPCK,
 	.rate_offset	= CKCTL_DSPDIV_OFFSET,
 	.recalc		= &omap1_ckctl_recalc,
@@ -323,8 +341,9 @@ static struct clk dspper_ck = {
 	.name		= "dspper_ck",
 	.parent		= &ck_dpll1,
 	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  RATE_CKCTL | VIRTUAL_IO_ADDRESS,
-	.enable_reg	= DSP_IDLECT2,
+			  RATE_CKCTL | OMAP1_DSP_CLOCK,
+	.mod_offs	= DSP_CONFIG_OFFS,
+	.enable_reg	= DSP_IDLECT2_OFFSET,
 	.enable_bit	= EN_PERCK,
 	.rate_offset	= CKCTL_PERDIV_OFFSET,
 	.recalc		= &omap1_ckctl_recalc_dsp_domain,
@@ -337,8 +356,9 @@ static struct clk dspxor_ck = {
 	.name		= "dspxor_ck",
 	.parent		= &ck_ref,
 	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  VIRTUAL_IO_ADDRESS,
-	.enable_reg	= DSP_IDLECT2,
+			  OMAP1_DSP_CLOCK,
+	.mod_offs	= DSP_CONFIG_OFFS,
+	.enable_reg	= DSP_IDLECT2_OFFSET,
 	.enable_bit	= EN_XORPCK,
 	.recalc		= &followparent_recalc,
 	.enable		= &omap1_clk_enable_dsp_domain,
@@ -349,8 +369,9 @@ static struct clk dsptim_ck = {
 	.name		= "dsptim_ck",
 	.parent		= &ck_ref,
 	.flags		= CLOCK_IN_OMAP310 | CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
-			  VIRTUAL_IO_ADDRESS,
-	.enable_reg	= DSP_IDLECT2,
+			  OMAP1_DSP_CLOCK,
+	.mod_offs	= DSP_CONFIG_OFFS,
+	.enable_reg	= DSP_IDLECT2_OFFSET,
 	.enable_bit	= EN_DSPTIMCK,
 	.recalc		= &followparent_recalc,
 	.enable		= &omap1_clk_enable_dsp_domain,
@@ -371,7 +392,7 @@ static struct arm_idlect1_clk tc_ck = {
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 6,
+	.idlect_shift	= IDLIF_ARM_SHIFT,
 };
 
 static struct clk arminth_ck1510 = {
@@ -404,7 +425,8 @@ static struct clk l3_ocpi_ck = {
 	.name		= "l3_ocpi_ck",
 	.parent		= &tc_ck.clk,
 	.flags		= CLOCK_IN_OMAP16XX,
-	.enable_reg	= (void __iomem *)ARM_IDLECT3,
+	.mod_offs	= MPU_CLKGEN_OFFS,
+	.enable_reg	= ARM_IDLECT3_OFFSET,
 	.enable_bit	= EN_OCPI_CK,
 	.recalc		= &followparent_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -415,7 +437,8 @@ static struct clk tc1_ck = {
 	.name		= "tc1_ck",
 	.parent		= &tc_ck.clk,
 	.flags		= CLOCK_IN_OMAP16XX,
-	.enable_reg	= (void __iomem *)ARM_IDLECT3,
+	.mod_offs	= MPU_CLKGEN_OFFS,
+	.enable_reg	= ARM_IDLECT3_OFFSET,
 	.enable_bit	= EN_TC1_CK,
 	.recalc		= &followparent_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -426,7 +449,8 @@ static struct clk tc2_ck = {
 	.name		= "tc2_ck",
 	.parent		= &tc_ck.clk,
 	.flags		= CLOCK_IN_OMAP16XX,
-	.enable_reg	= (void __iomem *)ARM_IDLECT3,
+	.mod_offs	= MPU_CLKGEN_OFFS,
+	.enable_reg	= ARM_IDLECT3_OFFSET,
 	.enable_bit	= EN_TC2_CK,
 	.recalc		= &followparent_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -459,13 +483,14 @@ static struct arm_idlect1_clk api_ck = {
 		.parent		= &tc_ck.clk,
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 				  CLOCK_IN_OMAP310 | CLOCK_IDLE_CONTROL,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_APICK,
 		.recalc		= &followparent_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 8,
+	.idlect_shift	= IDLAPI_ARM_SHIFT,
 };
 
 static struct arm_idlect1_clk lb_ck = {
@@ -474,13 +499,14 @@ static struct arm_idlect1_clk lb_ck = {
 		.parent		= &tc_ck.clk,
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 |
 				  CLOCK_IDLE_CONTROL,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_LBCK,
 		.recalc		= &followparent_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 4,
+	.idlect_shift	= IDLLB_ARM_SHIFT,
 };
 
 static struct clk rhea1_ck = {
@@ -505,7 +531,8 @@ static struct clk lcd_ck_16xx = {
 	.name		= "lcd_ck",
 	.parent		= &ck_dpll1,
 	.flags		= CLOCK_IN_OMAP16XX | CLOCK_IN_OMAP730 | RATE_CKCTL,
-	.enable_reg	= (void __iomem *)ARM_IDLECT2,
+	.mod_offs	= MPU_CLKGEN_OFFS,
+	.enable_reg	= ARM_IDLECT2_OFFSET,
 	.enable_bit	= EN_LCDCK,
 	.rate_offset	= CKCTL_LCDDIV_OFFSET,
 	.recalc		= &omap1_ckctl_recalc,
@@ -519,14 +546,15 @@ static struct arm_idlect1_clk lcd_ck_1510 = {
 		.parent		= &ck_dpll1,
 		.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 |
 				  RATE_CKCTL | CLOCK_IDLE_CONTROL,
-		.enable_reg	= (void __iomem *)ARM_IDLECT2,
+		.mod_offs	= MPU_CLKGEN_OFFS,
+		.enable_reg	= ARM_IDLECT2_OFFSET,
 		.enable_bit	= EN_LCDCK,
 		.rate_offset	= CKCTL_LCDDIV_OFFSET,
 		.recalc		= &omap1_ckctl_recalc,
 		.enable		= &omap1_clk_enable_generic,
 		.disable	= &omap1_clk_disable_generic,
 	},
-	.idlect_shift	= 3,
+	.idlect_shift	= IDLLCD_ARM_SHIFT,
 };
 
 static struct clk uart1_1510 = {
@@ -537,8 +565,9 @@ static struct clk uart1_1510 = {
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 |
 			  ENABLE_REG_32BIT | ALWAYS_ENABLED |
 			  CLOCK_NO_IDLE_PARENT,
-	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
-	.enable_bit	= 29,	/* Chooses between 12MHz and 48MHz */
+	.mod_offs	= MPU_CONF_OFFS,
+	.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
+	.enable_bit	= CONF_MOD_UART1_CLK_MODE_R_SHIFT, /* 12MHz or 48MHz */
 	.set_rate	= &omap1_set_uart_rate,
 	.recalc		= &omap1_uart_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -553,8 +582,9 @@ static struct uart_clk uart1_16xx = {
 		.rate		= 48000000,
 		.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED |
 				  ENABLE_REG_32BIT | CLOCK_NO_IDLE_PARENT,
-		.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
-		.enable_bit	= 29,
+		.mod_offs	= MPU_CONF_OFFS,
+		.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
+		.enable_bit	= CONF_MOD_UART1_CLK_MODE_R_SHIFT, /* 12MHz or 48MHz */
 		.enable		= &omap1_clk_enable_uart_functional,
 		.disable	= &omap1_clk_disable_uart_functional,
 	},
@@ -569,8 +599,9 @@ static struct clk uart2_ck = {
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  CLOCK_IN_OMAP310 | ENABLE_REG_32BIT |
 			  ALWAYS_ENABLED | CLOCK_NO_IDLE_PARENT,
-	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
-	.enable_bit	= 30,	/* Chooses between 12MHz and 48MHz */
+	.mod_offs	= MPU_CONF_OFFS,
+	.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
+	.enable_bit	= CONF_MOD_UART2_CLK_MODE_R_SHIFT, /* 12MHz or 48MHz */
 	.set_rate	= &omap1_set_uart_rate,
 	.recalc		= &omap1_uart_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -585,8 +616,9 @@ static struct clk uart3_1510 = {
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 |
 			  ENABLE_REG_32BIT | ALWAYS_ENABLED |
 			  CLOCK_NO_IDLE_PARENT,
-	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
-	.enable_bit	= 31,	/* Chooses between 12MHz and 48MHz */
+	.mod_offs	= MPU_CONF_OFFS,
+	.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
+	.enable_bit	= CONF_MOD_UART3_CLK_MODE_R_SHIFT, /* 12MHz or 48MHz */
 	.set_rate	= &omap1_set_uart_rate,
 	.recalc		= &omap1_uart_recalc,
 	.enable		= &omap1_clk_enable_generic,
@@ -601,8 +633,9 @@ static struct uart_clk uart3_16xx = {
 		.rate		= 48000000,
 		.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED |
 				  ENABLE_REG_32BIT | CLOCK_NO_IDLE_PARENT,
-		.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
-		.enable_bit	= 31,
+		.mod_offs	= MPU_CONF_OFFS,
+		.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
+		.enable_bit	= CONF_MOD_UART3_CLK_MODE_R_SHIFT, /* 12MHz or 48MHz */
 		.enable		= &omap1_clk_enable_uart_functional,
 		.disable	= &omap1_clk_disable_uart_functional,
 	},
@@ -615,7 +648,8 @@ static struct clk usb_clko = {	/* 6 MHz output on W4_USB_CLKO */
 	.rate		= 6000000,
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  CLOCK_IN_OMAP310 | RATE_FIXED | ENABLE_REG_32BIT,
-	.enable_reg	= (void __iomem *)ULPD_CLOCK_CTRL,
+	.mod_offs	= MPU_ULPD_OFFS,
+	.enable_reg	= ULPD_CLOCK_CTRL_OFFSET,
 	.enable_bit	= USB_MCLK_EN_BIT,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
@@ -627,7 +661,8 @@ static struct clk usb_hhc_ck1510 = {
 	.rate		= 48000000, /* Actually 2 clocks, 12MHz and 48MHz */
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 |
 			  RATE_FIXED | ENABLE_REG_32BIT,
-	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
+	.mod_offs	= MPU_CONF_OFFS,
+	.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
 	.enable_bit	= USB_HOST_HHC_UHOST_EN,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
@@ -638,10 +673,10 @@ static struct clk usb_hhc_ck16xx = {
 	/* Direct from ULPD, no parent */
 	.rate		= 48000000,
 	/* OTG_SYSCON_2.OTG_PADEN == 0 (not 1510-compatible) */
-	.flags		= CLOCK_IN_OMAP16XX |
-			  RATE_FIXED | ENABLE_REG_32BIT,
-	.enable_reg	= (void __iomem *)OTG_BASE + 0x08 /* OTG_SYSCON_2 */,
-	.enable_bit	= 8 /* UHOST_EN */,
+	.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED | ENABLE_REG_32BIT,
+	.mod_offs	= MPU_OTG_OFFS,
+	.enable_reg	= OTG_SYSCON_2_OFFSET,
+	.enable_bit	= UHOST_EN_SHIFT,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
 };
@@ -651,8 +686,9 @@ static struct clk usb_dc_ck = {
 	/* Direct from ULPD, no parent */
 	.rate		= 48000000,
 	.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED,
-	.enable_reg	= (void __iomem *)SOFT_REQ_REG,
-	.enable_bit	= 4,
+	.mod_offs	= MPU_ULPD_OFFS,
+	.enable_reg	= ULPD_SOFT_REQ_OFFSET,
+	.enable_bit	= SOFT_UDC_REQ_SHIFT,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
 };
@@ -661,9 +697,10 @@ static struct clk mclk_1510 = {
 	.name		= "mclk",
 	/* Direct from ULPD, no parent. May be enabled by ext hardware. */
 	.rate		= 12000000,
- 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 | RATE_FIXED,
- 	.enable_reg	= (void __iomem *)SOFT_REQ_REG,
- 	.enable_bit	= 6,
+	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP310 | RATE_FIXED,
+	.mod_offs	= MPU_ULPD_OFFS,
+	.enable_reg	= ULPD_SOFT_REQ_OFFSET,
+	.enable_bit	= SOFT_COM_MCKO_REQ_SHIFT,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
 };
@@ -672,7 +709,8 @@ static struct clk mclk_16xx = {
 	.name		= "mclk",
 	/* Direct from ULPD, no parent. May be enabled by ext hardware. */
 	.flags		= CLOCK_IN_OMAP16XX,
-	.enable_reg	= (void __iomem *)COM_CLK_DIV_CTRL_SEL,
+	.mod_offs	= MPU_ULPD_OFFS,
+	.enable_reg	= ULPD_COM_CLK_DIV_CTRL_SEL_OFFSET,
 	.enable_bit	= COM_ULPD_PLL_CLK_REQ,
 	.set_rate	= &omap1_set_ext_clk_rate,
 	.round_rate	= &omap1_round_ext_clk_rate,
@@ -694,7 +732,8 @@ static struct clk bclk_16xx = {
 	.name		= "bclk",
 	/* Direct from ULPD, no parent. May be enabled by ext hardware. */
 	.flags		= CLOCK_IN_OMAP16XX,
-	.enable_reg	= (void __iomem *)SWD_CLK_DIV_CTRL_SEL,
+	.mod_offs	= MPU_ULPD_OFFS,
+	.enable_reg	= ULPD_SDW_CLK_DIV_CTRL_SEL_OFFSET,
 	.enable_bit	= SWD_ULPD_PLL_CLK_REQ,
 	.set_rate	= &omap1_set_ext_clk_rate,
 	.round_rate	= &omap1_round_ext_clk_rate,
@@ -711,8 +750,9 @@ static struct clk mmc1_ck = {
 	.flags		= CLOCK_IN_OMAP1510 | CLOCK_IN_OMAP16XX |
 			  CLOCK_IN_OMAP310 | RATE_FIXED | ENABLE_REG_32BIT |
 			  CLOCK_NO_IDLE_PARENT,
-	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
-	.enable_bit	= 23,
+	.mod_offs	= MPU_CONF_OFFS,
+	.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
+	.enable_bit	= CONF_MOD_MMC_SD_CLK_REQ_R_SHIFT,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
 };
@@ -723,10 +763,11 @@ static struct clk mmc2_ck = {
 	/* Functional clock is direct from ULPD, interface clock is ARMPER */
 	.parent		= &armper_ck.clk,
 	.rate		= 48000000,
-	.flags		= CLOCK_IN_OMAP16XX |
-			  RATE_FIXED | ENABLE_REG_32BIT | CLOCK_NO_IDLE_PARENT,
-	.enable_reg	= (void __iomem *)MOD_CONF_CTRL_0,
-	.enable_bit	= 20,
+	.flags		= CLOCK_IN_OMAP16XX | RATE_FIXED | ENABLE_REG_32BIT |
+			  CLOCK_NO_IDLE_PARENT,
+	.mod_offs	= MPU_CONF_OFFS,
+	.enable_reg	= MOD_CONF_CTRL_0_OFFSET,
+	.enable_bit	= CONF_MOD_MMC_SD2_CLK_REQ_R_SHIFT,
 	.enable		= &omap1_clk_enable_generic,
 	.disable	= &omap1_clk_disable_generic,
 };
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index e58dac1..565fe84 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -90,6 +90,7 @@ struct clk {
 	} clkdm;
 	s16			prcm_mod;
 #else
+	u16			mod_offs;
 	__u8			rate_offset;
 	__u8			src_offset;
 #endif
@@ -130,6 +131,11 @@ extern void clk_enable_init_clocks(void);
 extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #endif
 
+#ifdef CONFIG_ARCH_OMAP1
+extern __u32 arm_idlect1_mask;
+extern int omap1_clk_init(void);
+#endif
+
 /* Clock flags */
 #define RATE_CKCTL		(1 << 0)	/* Main fixed ratio clocks */
 #define RATE_FIXED		(1 << 1)	/* Fixed clock rate */
@@ -137,7 +143,7 @@ extern void clk_init_cpufreq_table(struct cpufreq_frequency_table **table);
 #define VIRTUAL_CLOCK		(1 << 3)	/* Composite clock from table */
 #define ALWAYS_ENABLED		(1 << 4)	/* Clock cannot be disabled */
 #define ENABLE_REG_32BIT	(1 << 5)	/* Use 32-bit access */
-#define VIRTUAL_IO_ADDRESS	(1 << 6)	/* Clock in virtual address */
+#define OMAP1_DSP_CLOCK		(1 << 6)	/* Registers in DSP space */
 #define CLOCK_IDLE_CONTROL	(1 << 7)
 #define CLOCK_NO_IDLE_PARENT	(1 << 8)
 #define DELAYED_APP		(1 << 9)	/* Delay application of clock */
diff --git a/arch/arm/plat-omap/include/mach/hardware.h b/arch/arm/plat-omap/include/mach/hardware.h
index 6589ddb..ecb30b6 100644
--- a/arch/arm/plat-omap/include/mach/hardware.h
+++ b/arch/arm/plat-omap/include/mach/hardware.h
@@ -70,14 +70,30 @@
  * ----------------------------------------------------------------------------
  */
 #define CLKGEN_REG_BASE		(0xfffece00)
-#define ARM_CKCTL		(CLKGEN_REG_BASE + 0x0)
-#define ARM_IDLECT1		(CLKGEN_REG_BASE + 0x4)
-#define ARM_IDLECT2		(CLKGEN_REG_BASE + 0x8)
-#define ARM_EWUPCT		(CLKGEN_REG_BASE + 0xC)
-#define ARM_RSTCT1		(CLKGEN_REG_BASE + 0x10)
-#define ARM_RSTCT2		(CLKGEN_REG_BASE + 0x14)
-#define ARM_SYSST		(CLKGEN_REG_BASE + 0x18)
-#define ARM_IDLECT3		(CLKGEN_REG_BASE + 0x24)
+#define ARM_CKCTL_OFFSET	0x00
+#define ARM_CKCTL		(CLKGEN_REG_BASE + ARM_CKCTL_OFFSET)
+#define ARM_IDLECT1_OFFSET	0x04
+#define ARM_IDLECT1		(CLKGEN_REG_BASE + ARM_IDLECT1_OFFSET)
+#	define IDL_CLKOUT_ARM_SHIFT	12
+#	define IDLTIM_ARM_SHIFT		9
+#	define IDLAPI_ARM_SHIFT		8
+#	define IDLIF_ARM_SHIFT		6
+#	define IDLLB_ARM_SHIFT		4
+#	define IDLLCD_ARM_SHIFT		3
+#	define IDLXORP_ARM_SHIFT	1
+#	define IDLWDT_ARM_SHIFT		0
+#define ARM_IDLECT2_OFFSET	0x08
+#define ARM_IDLECT2		(CLKGEN_REG_BASE + ARM_IDLECT2_OFFSET)
+#define ARM_EWUPCT_OFFSET	0x0c
+#define ARM_EWUPCT		(CLKGEN_REG_BASE + ARM_EWUPCT_OFFSET)
+#define ARM_RSTCT1_OFFSET	0x10
+#define ARM_RSTCT1		(CLKGEN_REG_BASE + ARM_RSTCT1_OFFSET)
+#define ARM_RSTCT2_OFFSET	0x14
+#define ARM_RSTCT2		(CLKGEN_REG_BASE + ARM_RSTCT2_OFFSET)
+#define ARM_SYSST_OFFSET	0x18
+#define ARM_SYSST		(CLKGEN_REG_BASE + ARM_SYSST_OFFSET)
+#define ARM_IDLECT3_OFFSET	0x24
+#define ARM_IDLECT3		(CLKGEN_REG_BASE + ARM_IDLECT3_OFFSET)
 
 #define CK_RATEF		1
 #define CK_IDLEF		2
@@ -89,11 +105,15 @@
 #define DPLL_CTL		(0xfffecf00)
 
 /* DSP clock control. Must use __raw_readw() and __raw_writew() with these */
-#define DSP_CONFIG_REG_BASE     IOMEM(0xe1008000)
-#define DSP_CKCTL		(DSP_CONFIG_REG_BASE + 0x0)
-#define DSP_IDLECT1		(DSP_CONFIG_REG_BASE + 0x4)
-#define DSP_IDLECT2		(DSP_CONFIG_REG_BASE + 0x8)
-#define DSP_RSTCT2		(DSP_CONFIG_REG_BASE + 0x14)
+#define DSP_CONFIG_REG_BASE	IOMEM(0xe1008000)
+#define DSP_CKCTL_OFFSET	0x0
+#define DSP_CKCTL		(DSP_CONFIG_REG_BASE + DSP_CKCTL_OFFSET)
+#define DSP_IDLECT1_OFFSET	0x4
+#define DSP_IDLECT1		(DSP_CONFIG_REG_BASE + DSP_IDLECT1_OFFSET)
+#define DSP_IDLECT2_OFFSET	0x8
+#define DSP_IDLECT2		(DSP_CONFIG_REG_BASE + DSP_IDLECT2_OFFSET)
+#define DSP_RSTCT2_OFFSET	0x14
+#define DSP_RSTCT2		(DSP_CONFIG_REG_BASE + DSP_RSTCT2_OFFSET)
 
 /*
  * ---------------------------------------------------------------------------
@@ -103,10 +123,14 @@
 #define ULPD_REG_BASE		(0xfffe0800)
 #define ULPD_IT_STATUS		(ULPD_REG_BASE + 0x14)
 #define ULPD_SETUP_ANALOG_CELL_3	(ULPD_REG_BASE + 0x24)
+#define ULPD_CLOCK_CTRL_OFFSET	0x30
 #define ULPD_CLOCK_CTRL		(ULPD_REG_BASE + 0x30)
 #	define DIS_USB_PVCI_CLK		(1 << 5)	/* no USB/FAC synch */
 #	define USB_MCLK_EN		(1 << 4)	/* enable W4_USB_CLKO */
-#define ULPD_SOFT_REQ		(ULPD_REG_BASE + 0x34)
+#define ULPD_SOFT_REQ_OFFSET	0x34
+#define ULPD_SOFT_REQ		(ULPD_REG_BASE + ULPD_SOFT_REQ_OFFSET)
+#	define SOFT_COM_MCKO_REQ_SHIFT	6
+#	define SOFT_UDC_REQ_SHIFT	4
 #	define SOFT_UDC_REQ		(1 << 4)
 #	define SOFT_USB_CLK_REQ		(1 << 3)
 #	define SOFT_DPLL_REQ		(1 << 0)
@@ -121,7 +145,9 @@
 #	define DIS_UART2_DPLL_REQ	(1 << 8)
 #	define DIS_UART1_DPLL_REQ	(1 << 7)
 #	define DIS_USB_HOST_DPLL_REQ	(1 << 6)
+#define ULPD_SDW_CLK_DIV_CTRL_SEL_OFFSET	0x74
 #define ULPD_SDW_CLK_DIV_CTRL_SEL	(ULPD_REG_BASE + 0x74)
+#define ULPD_COM_CLK_DIV_CTRL_SEL_OFFSET	0x78
 #define ULPD_CAM_CLK_CTRL	(ULPD_REG_BASE + 0x7c)
 
 /*
@@ -184,8 +210,17 @@
  * System control registers
  * ----------------------------------------------------------------------------
  */
-#define MOD_CONF_CTRL_0		0xfffe1080
-#define MOD_CONF_CTRL_1		0xfffe1110
+#define MOD_CONF_REG_BASE	0xfffe1000
+#define MOD_CONF_CTRL_0_OFFSET	0x080
+#define MOD_CONF_CTRL_0		(MOD_CONF_REG_BASE + MOD_CONF_CTRL_0_OFFSET)
+#	define CONF_MOD_UART3_CLK_MODE_R_SHIFT		31
+#	define CONF_MOD_UART2_CLK_MODE_R_SHIFT		30
+#	define CONF_MOD_UART1_CLK_MODE_R_SHIFT		29
+#	define CONF_MOD_MMC_SD_CLK_REQ_R_SHIFT		23
+#	define CONF_MOD_MMC_SD2_CLK_REQ_R_SHIFT		20
+#define MOD_CONF_CTRL_1_OFFSET	0x110
+#define MOD_CONF_CTRL_1		(MOD_CONF_REG_BASE + MOD_CONF_CTRL_1_OFFSET)
+#	define CONF_MOD_SOSSI_CLK_EN_R_SHIFT		16
 
 /*
  * ----------------------------------------------------------------------------
diff --git a/arch/arm/plat-omap/include/mach/io.h b/arch/arm/plat-omap/include/mach/io.h
index d92bf79..61d43f9 100644
--- a/arch/arm/plat-omap/include/mach/io.h
+++ b/arch/arm/plat-omap/include/mach/io.h
@@ -61,6 +61,9 @@
 #define __OMAP1_IO_ADDRESS(pa)	((pa) - IO_OFFSET)
 #define io_v2p(va)		((va) + IO_OFFSET)
 
+#define OMAP1_DSP_IO_BASE	0xe1000000
+#define OMAP1_MPU_BASE		0xf0000000
+
 #elif defined(CONFIG_ARCH_OMAP2)
 
 /* We map both L3 and L4 on OMAP2 */
diff --git a/arch/arm/plat-omap/include/mach/usb.h b/arch/arm/plat-omap/include/mach/usb.h
index a56a610..59dbbae 100644
--- a/arch/arm/plat-omap/include/mach/usb.h
+++ b/arch/arm/plat-omap/include/mach/usb.h
@@ -44,7 +44,8 @@
 #	define	 DEV_IDLE_EN		(1 << 13)
 #	define	 OTG_RESET_DONE		(1 << 2)
 #	define	 OTG_SOFT_RESET		(1 << 1)
-#define OTG_SYSCON_2			(OTG_BASE + 0x08)
+#define OTG_SYSCON_2_OFFSET		0x08
+#define OTG_SYSCON_2			(OTG_BASE + OTG_SYSCON_2_OFFSET)
 #	define	 OTG_EN			(1 << 31)
 #	define	 USBX_SYNCHRO		(1 << 30)
 #	define	 OTG_MST16		(1 << 29)
@@ -58,6 +59,7 @@
 #	define	 SRP_VBUS		(1 << 12)
 #	define	 OTG_PADEN		(1 << 10)
 #	define	 HMC_PADEN		(1 << 9)
+#	define	 UHOST_EN_SHIFT		8
 #	define	 UHOST_EN		(1 << 8)
 #	define	 HMC_TLLSPEED		(1 << 7)
 #	define	 HMC_TLLATTACH		(1 << 6)
-- 
1.6.0.2.GIT

