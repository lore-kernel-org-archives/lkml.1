Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0CBGYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 01:24:22 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:59042 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0CBGYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 01:24:20 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18P4AMtLWSJz9w0+7igcxkR
Date: Mon, 1 Mar 2010 22:25:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the omap tree with the  tree
Message-ID: <20100302062519.GJ3389@atomide.com>
References: <20100301112041.0c92179b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <20100301112041.0c92179b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Stephen Rothwell <sfr@canb.auug.org.au> [100228 16:17]:
> Hi all,
> 
> Today's linux-next merge of the omap tree got a conflict in
> arch/arm/plat-omap/Kconfig between commit
> d6d502fa4be1acd01971476fc732c95a4da16d90 ("ARM: 5952/1: ARM: MM: Add
> ARM_L1_CACHE_SHIFT_6 for handle inside each ARCH Kconfig") from the arm
> tree and commits 56213ca4e440c0b6e56a48f5901c55c4ce3cf1ba ("omap2/3:
> Multiboot compile fixes to compile in omap2 and omap3") and
> a8eb7ca0cbb41c9cd379b8d2a2a5efb503aa65e9 ("omap3: Replace ARCH_OMAP34XX
> with ARCH_OMAP3") from the omap tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/plat-omap/Kconfig
> index 2e3eec6,be9484a..0000000
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@@ -19,10 -28,9 +28,10 @@@ config ARCH_OMAP
>   
>   config ARCH_OMAP3
>   	bool "TI OMAP3"
> + 	depends on ARCH_OMAP2PLUS
>   	select CPU_V7
> - 	select COMMON_CLKDEV
>  +	select ARM_L1_CACHE_SHIFT_6
> + 	select USB_ARCH_HAS_EHCI
>   
>   config ARCH_OMAP4
>   	bool "TI OMAP4"

Thanks, I've merged omap for-next with the mainline to resolve this.

FYI, also need the following not-yet-ready patch to compile omaps.

The weird thing is that unless I set ehci_pdata from __initconst
to __initdata in board-omap3touchbook.c, I get the following early_param
error:
 
error: __setup_str_early_touchbook_revision causes a section type conflict

The error does not seem to be related to ehci_pdata, and only happens
for board-omap3touchbook.c.

Anybody got ideas?

Regards,

Tony 

--ftEhullJWpWg/VHq
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="build-fixes.patch"

>From f8b8a130c8cfef6cc885a61dcee339ba71b497a4 Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Mon, 1 Mar 2010 21:54:09 -0800
Subject: [PATCH] omap: Fix compile for early_param and omap_smc1

Commit 2b0d8c251b8876d530a6bf671eb5425838fa698a changed ARM to use
the common early_param code. Fix compile for omaps accordingly.

Commit d309427e792ea750cdd312e7a92cf6047ae44962 added support for
CACHE_L2X0, this however breaks multi-omap builds for V6 because of
dsb and smc. The proper fix is to separate omap_smc1 into a separate
.S file and compile it with -Wa,-march=armv7-a flags.

Also for some reason touchbook produces a compile error

error: __setup_str_early_touchbook_revision causes a section type conflict

Unless ehci_pdata is set to __initdata instead of __initconst.
No idea yet why this happens only on touchbook.

Not-Yet-Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 180ac11..a462d50 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -49,7 +49,7 @@ static struct omap_board_config_kernel sdp4430_config[] __initdata = {
 	{ OMAP_TAG_LCD,		&sdp4430_lcd_config },
 };
 
-#ifdef CONFIG_CACHE_L2X0
+#if defined(CONFIG_SMP) && defined(CONFIG_CACHE_L2X0)
 noinline void omap_smc1(u32 fn, u32 arg)
 {
 	register u32 r12 asm("r12") = fn;
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 3943d0f..07b7a32 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -493,7 +493,7 @@ static void __init omap3touchbook_flash_init(void)
 	}
 }
 
-static struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
+static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
 
 	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
 	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
@@ -518,14 +518,14 @@ static void omap3_touchbook_poweroff(void)
 	gpio_direction_output(TB_KILL_POWER_GPIO, 0);
 }
 
-static void __init early_touchbook_revision(char **p)
+static int __init early_touchbook_revision(char *p)
 {
-	if (!*p)
-		return;
+	if (!p)
+		return 0;
 
-	strict_strtoul(*p, 10, &touchbook_revision);
+	return strict_strtoul(p, 10, &touchbook_revision);
 }
-__early_param("tbr=", early_touchbook_revision);
+early_param("tbr", early_touchbook_revision);
 
 static struct omap_musb_board_data musb_board_data = {
 	.interface_type		= MUSB_INTERFACE_ULPI,
diff --git a/drivers/video/omap2/vram.c b/drivers/video/omap2/vram.c
index 55a4de5..1d88425 100644
--- a/drivers/video/omap2/vram.c
+++ b/drivers/video/omap2/vram.c
@@ -511,13 +511,17 @@ static u32 omap_vram_sdram_size __initdata;
 static u32 omap_vram_def_sdram_size __initdata;
 static u32 omap_vram_def_sdram_start __initdata;
 
-static void __init omap_vram_early_vram(char **p)
+static int __init omap_vram_early_vram(char *p)
 {
-	omap_vram_def_sdram_size = memparse(*p, p);
-	if (**p == ',')
-		omap_vram_def_sdram_start = simple_strtoul((*p) + 1, p, 16);
+	char *endp;
+
+	omap_vram_def_sdram_size = memparse(p, &endp);
+	if (*endp == ',')
+		omap_vram_def_sdram_start = simple_strtoul(endp + 1, &p, 16);
+
+	return 0;
 }
-__early_param("vram=", omap_vram_early_vram);
+early_param("vram", omap_vram_early_vram);
 
 /*
  * Called from map_io. We need to call to this early enough so that we

--ftEhullJWpWg/VHq--
