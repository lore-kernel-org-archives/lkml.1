Return-Path: <linux-kernel-owner+w=401wt.eu-S934533AbYBVOXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533AbYBVOXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbYBVOXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:23:31 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:64427 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYBVOXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:23:31 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080222323.714291012@suse.de>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [1/3] Make all drivers that use dma_declare_coherent_memory depend on it
Date: Fri, 22 Feb 2008 15:23:28 +0100 (CET)
X-OriginalArrivalTime: 22 Feb 2008 14:17:03.0758 (UTC) FILETIME=[98E482E0:01C8755D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are two users of dma_declare_coherent_memory in tree. Make them 
dependent on the architectures who actually implement that instead of 
falling at runtime. All cases I checked fail fataly (no recovery)
so these drivers will never work on these architectures.

I'm also a little puzzled why x86-64 allyesconfig worked with CONFIG_MFD_SM501
without this patch anyways. 

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/cris/Kconfig
===================================================================
--- linux.orig/arch/cris/Kconfig
+++ linux/arch/cris/Kconfig
@@ -47,6 +47,11 @@ config GENERIC_CALIBRATE_DELAY
 config NO_IOPORT
 	def_bool y
 
+config HAS_DMA_DECLARE_COHERENT
+	# looks weird, but it really depends on that
+	depends on ETRAX_CARDBUS
+	def_bool y
+
 config FORCE_MAX_ZONEORDER
 	int
 	default 6
Index: linux/arch/sh/Kconfig
===================================================================
--- linux.orig/arch/sh/Kconfig
+++ linux/arch/sh/Kconfig
@@ -90,6 +90,9 @@ config ARCH_HAS_ILOG2_U64
 config ARCH_NO_VIRT_TO_BUS
 	def_bool y
 
+config HAS_DMA_DECLARE_COHERENT
+	def_boot y
+
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -157,6 +157,10 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
+config HAS_DMA_DECLARE_COHERENT
+	def_bool y
+	depends on X86_32
+
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
Index: linux/drivers/mfd/Kconfig
===================================================================
--- linux.orig/drivers/mfd/Kconfig
+++ linux/drivers/mfd/Kconfig
@@ -7,6 +7,7 @@ menu "Multifunction device drivers"
 
 config MFD_SM501
 	tristate "Support for Silicon Motion SM501"
+	depends on HAS_DMA_DECLARE_COHERENT
 	 ---help---
 	  This is the core driver for the Silicon Motion SM501 multimedia
 	  companion chip. This device is a multifunction device which may
Index: linux/drivers/scsi/Kconfig
===================================================================
--- linux.orig/drivers/scsi/Kconfig
+++ linux/drivers/scsi/Kconfig
@@ -1163,7 +1163,7 @@ config SCSI_ZALON
 
 config SCSI_NCR_Q720
 	tristate "NCR Quad 720 MCA SCSI support"
-	depends on MCA && SCSI
+	depends on MCA && SCSI && HAS_DMA_DECLARE_COHERENT
 	select SCSI_SPI_ATTRS
 	help
 	  This is a driver for the MicroChannel Quad 720 card produced by
