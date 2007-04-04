Return-Path: <linux-kernel-owner+w=401wt.eu-S966324AbXDDG7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966324AbXDDG7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966325AbXDDG7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:59:20 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:34308 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966324AbXDDG7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:59:19 -0400
Date: Wed, 4 Apr 2007 16:59:16 +1000
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Powerpc build unhappy in 2.6.20.4?
Message-ID: <20070404065916.GQ12768@bakeyournoodle.com>
Mail-Followup-To: Rob Landley <rob@landley.net>,
	linux-kernel@vger.kernel.org
References: <200703301753.27379.rob@landley.net> <200704021514.14681.rob@landley.net> <20070403005156.GN12768@bakeyournoodle.com> <200704022351.10343.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704022351.10343.rob@landley.net>
User-Agent: Mutt/1.5.9i
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 11:51:09PM -0400, Rob Landley wrote:
 
> So "make oldconfig ARCH=powerpc" will accept a config that doesn't have a 
> platform selected?

It seems so.

I think the patch below will fix that by forcing at least one platform
to be selected.  Can you try it and see if it helps with your current
problem?

> Hmmm...  So CONFIG_PPC_MULTIPLATFORM doesn't cover it?  ("There is no help 
> available for this kernel option"...  Maybe a website somewhere?)

CONFIG_PPC_MULTIPLATFORM Allows you to select from the options, but
isn't a valid platform in itself.
 
> Er, never.  I was largely guessing at what I needed via menuconfig.  (I'm 
> trying to get something I can boot to a shell prompt under QEMU.)

Ahh.
 
> I'll try this CHRP thing...

Perhaps starting with make chrp32_defconfig would be a reasonable
starting point?

---
 arch/powerpc/Kconfig |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d6abe49..f3f0628 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -360,6 +360,14 @@ endmenu
 
 source "init/Kconfig"
 
+config PPC_PLATFORM_CHOSEN
+	def_bool n
+
+config PPC_DEFAULT_PLATFORM
+	def_bool PPC_MULTIPLATFORM && !PPC_PLATFORM_CHOSEN
+	select PPC_CHRP    if PPC32
+	select PPC_PSERIES if PPC64
+
 menu "Platform support"
 	depends on PPC64 || CLASSIC32
 
@@ -406,12 +414,15 @@ config PPC_PSERIES
 	select RTAS_ERROR_LOGGING
 	select PPC_UDBG_16550
 	select PPC_NATIVE
+# No need to "select PPC_PLATFORM_CHOSEN" for pSeries, as it is the default
+# platform for PPC64, see PPC_DEFAULT_PLATFORM
 	default y
 
 config PPC_ISERIES
 	bool "IBM Legacy iSeries"
 	depends on PPC_MULTIPLATFORM && PPC64
 	select PPC_INDIRECT_IO
+	select PPC_PLATFORM_CHOSEN
 
 config PPC_CHRP
 	bool "Common Hardware Reference Platform (CHRP) based machines"
@@ -423,6 +434,8 @@ config PPC_CHRP
 	select PPC_MPC106
 	select PPC_UDBG_16550
 	select PPC_NATIVE
+# No need to "select PPC_PLATFORM_CHOSEN" here, as it is the default platform 
+# for PPC32, see PPC_DEFAULT_PLATFORM
 	default y
 
 config PPC_MPC52xx
@@ -436,6 +449,7 @@ config PPC_EFIKA
 	select RTAS_PROC
 	select PPC_MPC52xx
 	select PPC_NATIVE
+	select PPC_PLATFORM_CHOSEN
 	default n
 
 config PPC_LITE5200
@@ -451,6 +465,7 @@ config PPC_PMAC
 	select PPC_INDIRECT_PCI if PPC32
 	select PPC_MPC106 if PPC32
 	select PPC_NATIVE
+	select PPC_PLATFORM_CHOSEN
 	default y
 
 config PPC_PMAC64
@@ -461,6 +476,7 @@ config PPC_PMAC64
 	select MPIC_BROKEN_U3
 	select GENERIC_TBSYNC
 	select PPC_970_NAP
+	select PPC_PLATFORM_CHOSEN
 	default y
 
 config PPC_PREP
@@ -471,6 +487,7 @@ config PPC_PREP
 	select PPC_INDIRECT_PCI
 	select PPC_UDBG_16550
 	select PPC_NATIVE
+	select PPC_PLATFORM_CHOSEN
 	default n
 
 config PPC_MAPLE
@@ -485,6 +502,7 @@ config PPC_MAPLE
 	select PPC_NATIVE
 	select PPC_RTAS
 	select ATA_NONSTANDARD if ATA
+	select PPC_PLATFORM_CHOSEN
 	default n
 	help
           This option enables support for the Maple 970FX Evaluation Board.
@@ -498,6 +516,7 @@ config PPC_PASEMI
 	select PPC_UDBG_16550
 	select GENERIC_TBSYNC
 	select PPC_NATIVE
+	select PPC_PLATFORM_CHOSEN
 	help
 	  This option enables support for PA Semi's PWRficient line
 	  of SoC processors, including PA6T-1682M
@@ -524,11 +543,13 @@ config PPC_IBM_CELL_BLADE
 	select MMIO_NVRAM
 	select PPC_UDBG_16550
 	select UDBG_RTAS_CONSOLE
+	select PPC_PLATFORM_CHOSEN
 
 config PPC_PS3
 	bool "Sony PS3 (incomplete)"
 	depends on PPC_MULTIPLATFORM && PPC64
 	select PPC_CELL
+	select PPC_PLATFORM_CHOSEN
 	help
 	  This option enables support for the Sony PS3 game console
 	  and other platforms using the PS3 hypervisor.
-- 
1.5.0.6


Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

