Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYLAM4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYLAM4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYLAMzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:55:50 -0500
Received: from ozlabs.org ([203.10.76.45]:44018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbYLAMzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:55:48 -0500
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 23:25:43 +1030
Subject: [RFC 4/8] arm: separate hook for commandline
MIME-Version: 1.0
Content-Type: text/plain;
  charset="gb18030"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012325.43758.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows us to call it before setup_arch().

Untested.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/include/asm/mach/arch.h        |    3 ++-
 arch/arm/kernel/setup.c                 |    9 +++++++--
 arch/arm/mach-clps711x/clep7312.c       |    2 +-
 arch/arm/mach-clps711x/edb7211-arch.c   |    2 +-
 arch/arm/mach-clps711x/fortunet.c       |   11 +++++++++--
 arch/arm/mach-clps711x/p720t.c          |    2 +-
 arch/arm/mach-footbridge/cats-hw.c      |    2 +-
 arch/arm/mach-footbridge/netwinder-hw.c |    2 +-
 arch/arm/mach-orion5x/common.c          |    2 +-
 arch/arm/mach-orion5x/common.h          |    2 +-
 arch/arm/mach-pxa/eseries.c             |    2 +-
 arch/arm/mach-pxa/eseries.h             |    2 +-
 arch/arm/mach-pxa/ezx.c                 |    2 +-
 arch/arm/mach-pxa/poodle.c              |    2 +-
 arch/arm/mach-pxa/spitz.c               |    2 +-
 arch/arm/mach-pxa/tosa.c                |    2 +-
 arch/arm/mach-sa1100/assabet.c          |    2 +-
 17 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -34,8 +34,9 @@ struct machine_desc {
 	unsigned int		reserve_lp1 :1;	/* never has lp1	*/
 	unsigned int		reserve_lp2 :1;	/* never has lp2	*/
 	unsigned int		soft_reboot :1;	/* soft reboot		*/
+	const char *		(*cmdline)(void);
 	void			(*fixup)(struct machine_desc *,
-					 struct tag *, char **,
+					 struct tag *,
 					 struct meminfo *);
 	void			(*map_io)(void);/* IO mapping function	*/
 	void			(*init_irq)(void);
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -677,7 +677,7 @@ void __init setup_arch(char **cmdline_p)
 {
 	struct tag *tags = (struct tag *)&init_tags;
 	struct machine_desc *mdesc;
-	char *from = default_command_line;
+	char *from;
 
 	setup_processor();
 	mdesc = setup_machine(machine_arch_type);
@@ -700,8 +700,13 @@ void __init setup_arch(char **cmdline_p)
 	if (tags->hdr.tag != ATAG_CORE)
 		tags = (struct tag *)&init_tags;
 
+	if (mdesc->cmdline)
+		from = mdesc->cmdline();
+	else
+		from = default_command_line;
+
 	if (mdesc->fixup)
-		mdesc->fixup(mdesc, tags, &from, &meminfo);
+		mdesc->fixup(mdesc, tags, &meminfo);
 
 	if (tags->hdr.tag == ATAG_CORE) {
 		if (meminfo.nr_banks != 0)
diff --git a/arch/arm/mach-clps711x/clep7312.c b/arch/arm/mach-clps711x/clep7312.c
--- a/arch/arm/mach-clps711x/clep7312.c
+++ b/arch/arm/mach-clps711x/clep7312.c
@@ -27,7 +27,7 @@
 
 static void __init
 fixup_clep7312(struct machine_desc *desc, struct tag *tags,
-	    char **cmdline, struct meminfo *mi)
+	    struct meminfo *mi)
 {
 	mi->nr_banks=1;
 	mi->bank[0].start = 0xc0000000;
diff --git a/arch/arm/mach-clps711x/edb7211-arch.c b/arch/arm/mach-clps711x/edb7211-arch.c
--- a/arch/arm/mach-clps711x/edb7211-arch.c
+++ b/arch/arm/mach-clps711x/edb7211-arch.c
@@ -31,7 +31,7 @@ extern void edb7211_map_io(void);
 
 static void __init
 fixup_edb7211(struct machine_desc *desc, struct tag *tags,
-	      char **cmdline, struct meminfo *mi)
+	      struct meminfo *mi)
 {
 	/*
 	 * Bank start addresses are not present in the information
diff --git a/arch/arm/mach-clps711x/fortunet.c b/arch/arm/mach-clps711x/fortunet.c
--- a/arch/arm/mach-clps711x/fortunet.c
+++ b/arch/arm/mach-clps711x/fortunet.c
@@ -58,12 +58,18 @@ typedef struct tag_IMAGE_PARAMS
 
 #define IMAGE_PARAMS_PHYS	0xC01F0000
 
+static const char * __init
+fortunet_cmdline(void)
+{
+	IMAGE_PARAMS *ip = phys_to_virt(IMAGE_PARAMS_PHYS);
+	return phys_to_virt(ip->command_line);
+}
+
 static void __init
 fortunet_fixup(struct machine_desc *desc, struct tag *tags,
-		 char **cmdline, struct meminfo *mi)
+		 struct meminfo *mi)
 {
 	IMAGE_PARAMS *ip = phys_to_virt(IMAGE_PARAMS_PHYS);
-	*cmdline = phys_to_virt(ip->command_line);
 #ifdef CONFIG_BLK_DEV_INITRD
 	if(ip->ramdisk_ok)
 	{
@@ -80,6 +86,7 @@ MACHINE_START(FORTUNET, "ARM-FortuNet")
 	.phys_io	= 0x80000000,
 	.io_pg_offst	= ((0xf0000000) >> 18) & 0xfffc,
 	.boot_params	= 0x00000000,
+	.cmdline	= fortunet_cmdline,
 	.fixup		= fortunet_fixup,
 	.map_io		= clps711x_map_io,
 	.init_irq	= clps711x_init_irq,
diff --git a/arch/arm/mach-clps711x/p720t.c b/arch/arm/mach-clps711x/p720t.c
--- a/arch/arm/mach-clps711x/p720t.c
+++ b/arch/arm/mach-clps711x/p720t.c
@@ -57,7 +57,7 @@ static struct map_desc p720t_io_desc[] _
 
 static void __init
 fixup_p720t(struct machine_desc *desc, struct tag *tag,
-	    char **cmdline, struct meminfo *mi)
+	    struct meminfo *mi)
 {
 	/*
 	 * Our bootloader doesn't setup any tags (yet).
diff --git a/arch/arm/mach-footbridge/cats-hw.c b/arch/arm/mach-footbridge/cats-hw.c
--- a/arch/arm/mach-footbridge/cats-hw.c
+++ b/arch/arm/mach-footbridge/cats-hw.c
@@ -76,7 +76,7 @@ __initcall(cats_hw_init);
  */
 static void __init
 fixup_cats(struct machine_desc *desc, struct tag *tags,
-	   char **cmdline, struct meminfo *mi)
+	   struct meminfo *mi)
 {
 	screen_info.orig_video_lines  = 25;
 	screen_info.orig_video_points = 16;
diff --git a/arch/arm/mach-footbridge/netwinder-hw.c b/arch/arm/mach-footbridge/netwinder-
hw.c
--- a/arch/arm/mach-footbridge/netwinder-hw.c
+++ b/arch/arm/mach-footbridge/netwinder-hw.c
@@ -632,7 +632,7 @@ __initcall(nw_hw_init);
  */
 static void __init
 fixup_netwinder(struct machine_desc *desc, struct tag *tags,
-		char **cmdline, struct meminfo *mi)
+		struct meminfo *mi)
 {
 #ifdef CONFIG_ISAPNP
 	extern int isapnp_disable;
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -630,7 +630,7 @@ void __init orion5x_init(void)
  * This is a common fixup for bogus memory tags.
  */
 void __init tag_fixup_mem32(struct machine_desc *mdesc, struct tag *t,
-			    char **from, struct meminfo *meminfo)
+			    struct meminfo *meminfo)
 {
 	for (; t->hdr.size; t = tag_next(t))
 		if (t->hdr.tag == ATAG_MEM &&
diff --git a/arch/arm/mach-orion5x/common.h b/arch/arm/mach-orion5x/common.h
--- a/arch/arm/mach-orion5x/common.h
+++ b/arch/arm/mach-orion5x/common.h
@@ -62,7 +62,7 @@ struct meminfo;
 struct meminfo;
 struct tag;
 extern void __init tag_fixup_mem32(struct machine_desc *, struct tag *,
-				   char **, struct meminfo *);
+				   struct meminfo *);
 
 
 #endif
diff --git a/arch/arm/mach-pxa/eseries.c b/arch/arm/mach-pxa/eseries.c
--- a/arch/arm/mach-pxa/eseries.c
+++ b/arch/arm/mach-pxa/eseries.c
@@ -26,7 +26,7 @@
 
 /* Only e800 has 128MB RAM */
 void __init eseries_fixup(struct machine_desc *desc,
-	struct tag *tags, char **cmdline, struct meminfo *mi)
+	struct tag *tags, struct meminfo *mi)
 {
 	mi->nr_banks=1;
 	mi->bank[0].start = 0xa0000000;
diff --git a/arch/arm/mach-pxa/eseries.h b/arch/arm/mach-pxa/eseries.h
--- a/arch/arm/mach-pxa/eseries.h
+++ b/arch/arm/mach-pxa/eseries.h
@@ -1,4 +1,4 @@ void __init eseries_fixup(struct machine
 void __init eseries_fixup(struct machine_desc *desc,
-	struct tag *tags, char **cmdline, struct meminfo *mi);
+	struct tag *tags, struct meminfo *mi);
 
 extern struct pxa2xx_udc_mach_info e7xx_udc_mach_info;
diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -127,7 +127,7 @@ static void __init ezx_init(void)
 }
 
 static void __init ezx_fixup(struct machine_desc *desc, struct tag *tags,
-		char **cmdline, struct meminfo *mi)
+		struct meminfo *mi)
 {
 	/* We have two ram chips. First one with 32MB at 0xA0000000 and a second
 	 * 16MB one at 0xAC000000
diff --git a/arch/arm/mach-pxa/poodle.c b/arch/arm/mach-pxa/poodle.c
--- a/arch/arm/mach-pxa/poodle.c
+++ b/arch/arm/mach-pxa/poodle.c
@@ -455,7 +455,7 @@ static void __init poodle_init(void)
 }
 
 static void __init fixup_poodle(struct machine_desc *desc,
-		struct tag *tags, char **cmdline, struct meminfo *mi)
+		struct tag *tags, struct meminfo *mi)
 {
 	sharpsl_save_param();
 	mi->nr_banks=1;
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -694,7 +694,7 @@ static void __init akita_init(void)
 #endif
 
 static void __init fixup_spitz(struct machine_desc *desc,
-		struct tag *tags, char **cmdline, struct meminfo *mi)
+		struct tag *tags, struct meminfo *mi)
 {
 	sharpsl_save_param();
 	mi->nr_banks = 1;
diff --git a/arch/arm/mach-pxa/tosa.c b/arch/arm/mach-pxa/tosa.c
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -851,7 +851,7 @@ static void __init tosa_init(void)
 }
 
 static void __init fixup_tosa(struct machine_desc *desc,
-		struct tag *tags, char **cmdline, struct meminfo *mi)
+		struct tag *tags, struct meminfo *mi)
 {
 	sharpsl_save_param();
 	mi->nr_banks=1;
diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -302,7 +302,7 @@ static void __init get_assabet_scr(void)
 
 static void __init
 fixup_assabet(struct machine_desc *desc, struct tag *tags,
-	      char **cmdline, struct meminfo *mi)
+	      struct meminfo *mi)
 {
 	/* This must be done before any call to machine_has_neponset() */
 	map_sa1100_gpio_regs();


