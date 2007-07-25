Return-Path: <linux-kernel-owner+w=401wt.eu-S1764039AbXGYMLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764039AbXGYMLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763837AbXGYMI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:58 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33044 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763682AbXGYMI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:56 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7Kae032184@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: make BOOTPARAM setup common
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently most of the m68knommu cpu/board setup files are handling
the setup of fixed boot parameters (via CONFIG_BOOTPARAM) themselves.
Move all this into the common setup code.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

 kernel/setup.c            |    5 +++++
 platform/5206/config.c    |    8 --------
 platform/5206e/config.c   |    7 +------
 platform/520x/config.c    |    7 -------
 platform/523x/config.c    |    8 --------
 platform/5249/config.c    |    8 --------
 platform/5272/config.c    |    7 +------
 platform/527x/config.c    |    8 --------
 platform/528x/config.c    |    8 --------
 platform/5307/config.c    |    7 +------
 platform/532x/config.c    |    5 +----
 platform/5407/config.c    |    7 -------
 platform/68VZ328/config.c |    7 -------
 13 files changed, 9 insertions(+), 83 deletions(-)


diff -Naur linux-2.6.23-rc1/arch/m68knommu/kernel/setup.c linux/arch/m68knommu/kernel/setup.c
--- linux-2.6.23-rc1/arch/m68knommu/kernel/setup.c	2007-07-25 16:39:20.000000000 +1000
+++ linux/arch/m68knommu/kernel/setup.c	2007-07-25 16:55:11.000000000 +1000
@@ -132,6 +132,11 @@
 
 	config_BSP(&command_line[0], sizeof(command_line));
 
+#if defined(CONFIG_BOOTPARAM)
+	strncpy(&command_line[0], CONFIG_BOOTPARAM_STRING, sizeof(command_line));
+	command_line[sizeof(command_line) - 1] = 0;
+#endif
+
 	printk(KERN_INFO "\x0F\r\n\nuClinux/" CPU "\n");
 
 #ifdef CONFIG_UCDIMM
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/5206/config.c linux/arch/m68knommu/platform/5206/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5206/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/5206/config.c	2007-07-25 16:49:48.000000000 +1000
@@ -98,14 +98,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
-#endif
-
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/5206e/config.c linux/arch/m68knommu/platform/5206e/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5206e/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/5206e/config.c	2007-07-25 16:50:16.000000000 +1000
@@ -98,15 +98,10 @@
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#elif defined(CONFIG_NETtel)
+#if defined(CONFIG_NETtel)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0004000, size);
 	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
 #endif /* CONFIG_NETtel */
 
 	mach_sched_init = coldfire_timer_init;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/520x/config.c linux/arch/m68knommu/platform/520x/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/520x/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/520x/config.c	2007-07-25 16:51:13.000000000 +1000
@@ -48,13 +48,6 @@
 
 void config_BSP(char *commandp, int size)
 {
-#ifdef CONFIG_BOOTPARAM
-    strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-    commandp[size-1] = 0;
-#else
-    memset(commandp, 0, size);
-#endif
-
     mach_sched_init = coldfire_pit_init;
     mach_tick = coldfire_pit_tick;
     mach_gettimeoffset = coldfire_pit_offset;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/523x/config.c linux/arch/m68knommu/platform/523x/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/523x/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/523x/config.c	2007-07-25 16:51:20.000000000 +1000
@@ -63,14 +63,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-
-#ifdef CONFIG_BOOTPARAM
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
-#endif
-
 	mach_sched_init = coldfire_pit_init;
 	mach_tick = coldfire_pit_tick;
 	mach_gettimeoffset = coldfire_pit_offset;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/5249/config.c linux/arch/m68knommu/platform/5249/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5249/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/5249/config.c	2007-07-25 16:53:31.000000000 +1000
@@ -96,14 +96,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
-
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
-#endif
-
 	mach_sched_init = coldfire_timer_init;
 	mach_tick = coldfire_tick;
 	mach_gettimeoffset = coldfire_timer_offset;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/5272/config.c linux/arch/m68knommu/platform/5272/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5272/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/5272/config.c	2007-07-25 16:50:28.000000000 +1000
@@ -113,10 +113,7 @@
 
 	mcf_disableall();
 
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#elif defined(CONFIG_NETtel) || defined(CONFIG_SCALES)
+#if defined(CONFIG_NETtel) || defined(CONFIG_SCALES)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0004000, size);
 	commandp[size-1] = 0;
@@ -128,8 +125,6 @@
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0xf0010000, size);
 	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
 #endif
 
 	mcf_timervector = 69;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/527x/config.c linux/arch/m68knommu/platform/527x/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/527x/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/527x/config.c	2007-07-25 16:53:38.000000000 +1000
@@ -63,14 +63,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-
-#ifdef CONFIG_BOOTPARAM
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
-#endif
-
 	mach_sched_init = coldfire_pit_init;
 	mach_tick = coldfire_pit_tick;
 	mach_gettimeoffset = coldfire_pit_offset;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/528x/config.c linux/arch/m68knommu/platform/528x/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/528x/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/528x/config.c	2007-07-25 16:50:41.000000000 +1000
@@ -63,14 +63,6 @@
 void config_BSP(char *commandp, int size)
 {
 	mcf_disableall();
-
-#ifdef CONFIG_BOOTPARAM
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
-#endif
-
 	mach_sched_init = coldfire_pit_init;
 	mach_tick = coldfire_pit_tick;
 	mach_gettimeoffset = coldfire_pit_offset;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/5307/config.c linux/arch/m68knommu/platform/5307/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5307/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/5307/config.c	2007-07-25 16:51:04.000000000 +1000
@@ -111,10 +111,7 @@
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#elif defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
+#if defined(CONFIG_NETtel) || defined(CONFIG_eLIA) || \
       defined(CONFIG_DISKtel) || defined(CONFIG_SECUREEDGEMP3) || \
       defined(CONFIG_CLEOPATRA)
 	/* Copy command line from FLASH to local buffer... */
@@ -124,8 +121,6 @@
 	mcf_timervector = 30;
 	mcf_profilevector = 31;
 	mcf_timerlevel = 6;
-#else
-	memset(commandp, 0, size);
 #endif
 
 	mach_sched_init = coldfire_timer_init;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/532x/config.c linux/arch/m68knommu/platform/532x/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/532x/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/532x/config.c	2007-07-25 16:52:13.000000000 +1000
@@ -92,10 +92,7 @@
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#else
+#if !defined(CONFIG_BOOTPARAM)
 	/* Copy command line from FLASH to local buffer... */
 	memcpy(commandp, (char *) 0x4000, 4);
 	if(strncmp(commandp, "kcl ", 4) == 0){
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/5407/config.c linux/arch/m68knommu/platform/5407/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/5407/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/5407/config.c	2007-07-25 16:51:31.000000000 +1000
@@ -102,13 +102,6 @@
 {
 	mcf_setimr(MCFSIM_IMR_MASKALL);
 
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(commandp, CONFIG_BOOTPARAM_STRING, size);
-	commandp[size-1] = 0;
-#else
-	memset(commandp, 0, size);
-#endif
-
 #if defined(CONFIG_CLEOPATRA)
 	/* Different timer setup - to prevent device clash */
 	mcf_timervector = 30;
diff -Naur linux-2.6.23-rc1/arch/m68knommu/platform/68VZ328/config.c linux/arch/m68knommu/platform/68VZ328/config.c
--- linux-2.6.23-rc1/arch/m68knommu/platform/68VZ328/config.c	2007-07-09 09:32:17.000000000 +1000
+++ linux/arch/m68knommu/platform/68VZ328/config.c	2007-07-25 16:53:49.000000000 +1000
@@ -191,13 +191,6 @@
 {
 	printk(KERN_INFO "68VZ328 DragonBallVZ support (c) 2001 Lineo, Inc.\n");
 
-#if defined(CONFIG_BOOTPARAM)
-	strncpy(command, CONFIG_BOOTPARAM_STRING, size);
-	command[size-1] = 0;
-#else
-	memset(command, 0, size);
-#endif
-
 	init_hardware(command, size);
 
 	mach_sched_init = (void *) m68328_timer_init;
