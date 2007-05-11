Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbXEKSEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbXEKSEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761187AbXEKSEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:04:25 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1898 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761100AbXEKSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:04:25 -0400
Date: Fri, 11 May 2007 22:04:52 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ALPHA: misc fixes
Message-ID: <20070511220452.C16980@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also from Jay:

1. arch/alpha/Kconfig

   several adjustments:
      a) additions to the systems list and cleanup of same
      b) change limits of NR_CPUS and make dep. on platform

   Note that MARVEL support is limited to 32 CPUs whan using
   42-bit KSEG - one needs 48-bit KSEG to handle up to 64, and
   we've never supported 48-bit KSEG.

2. include/asm-alpha/core_wildfire.h

   fix a typo that undoubtedly prevents WILDFIRE support
   from working


Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>


diff -Naurp a/arch/alpha/Kconfig b/arch/alpha/Kconfig
--- a/arch/alpha/Kconfig	2007-05-03 09:07:42.000000000 -0400
+++ b/arch/alpha/Kconfig	2007-05-10 09:21:57.000000000 -0400
@@ -83,22 +83,20 @@ choice
 	  check out the Linux/Alpha FAQ, accessible on the WWW from
 	  <http://www.alphalinux.org/>. In summary:
 
-	  Alcor/Alpha-XLT     AS 600
+	  Alcor/Alpha-XLT     AS 600, AS 500, XL-300, XL-366
 	  Alpha-XL            XL-233, XL-266
 	  AlphaBook1          Alpha laptop
 	  Avanti              AS 200, AS 205, AS 250, AS 255, AS 300, AS 400
 	  Cabriolet           AlphaPC64, AlphaPCI64
-	  DP264               DP264
+	  DP264               DP264 / DS20 / ES40 / DS10 / DS10L
 	  EB164               EB164 21164 evaluation board
 	  EB64+               EB64+ 21064 evaluation board
 	  EB66                EB66 21066 evaluation board
 	  EB66+               EB66+ 21066 evaluation board
-	  Jensen              DECpc 150, DEC 2000 model 300,
-	  DEC 2000 model 500
+	  Jensen              DECpc 150, DEC 2000 models 300, 500
 	  LX164               AlphaPC164-LX
 	  Lynx                AS 2100A
-	  Miata               Personal Workstation 433a, 433au, 500a,
-	  500au, 600a, or 600au
+	  Miata               Personal Workstation 433/500/600 a/au
 	  Marvel              AlphaServer ES47 / ES80 / GS1280
 	  Mikasa              AS 1000
 	  Noname              AXPpci33, UDB (Multia)
@@ -108,9 +106,9 @@ choice
 	  Ruffian             RPX164-2, AlphaPC164-UX, AlphaPC164-BX
 	  SX164               AlphaPC164-SX
 	  Sable               AS 2000, AS 2100
-	  Shark		      DS 20L
-	  Takara              Takara
-	  Titan               AlphaServer ES45 / DS25
+	  Shark               DS 20L
+	  Takara              Takara (OEM)
+	  Titan               AlphaServer ES45 / DS25 / DS15
 	  Wildfire            AlphaServer GS 40/80/160/320
 
 	  If you don't know what to do, choose "generic".
@@ -537,10 +544,14 @@ config HAVE_DEC_LOCK
 	default y
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-64)"
-	range 2 64
+	int "Maximum number of CPUs (2-32)"
+	range 2 32
 	depends on SMP
-	default "64"
+	default "32" if ALPHA_GENERIC || ALPHA_MARVEL
+	default "4" if !ALPHA_GENERIC && !ALPHA_MARVEL
+	help
+	  MARVEL support can handle a maximum of 32 CPUs, all the others
+          with working support have a maximum of 4 CPUs.
 
 config ARCH_DISCONTIGMEM_ENABLE
 	bool "Discontiguous Memory Support (EXPERIMENTAL)"
diff -Naurp a/include/asm-alpha/core_wildfire.h b/include/asm-alpha/core_wildfire.h
--- a/include/asm-alpha/core_wildfire.h	2007-02-04 13:44:54.000000000 -0500
+++ b/include/asm-alpha/core_wildfire.h	2007-05-08 15:35:51.000000000 -0400
@@ -295,7 +295,7 @@ __EXTERN_INLINE int wildfire_is_ioaddr(u
 
 __EXTERN_INLINE int wildfire_is_mmio(const volatile void __iomem *xaddr)
 {
-	unsigned long addr = (unsigned long)addr;
+	unsigned long addr = (unsigned long)xaddr;
 	return (addr & 0x100000000UL) == 0;
 }
 
