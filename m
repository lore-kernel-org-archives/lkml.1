Return-Path: <linux-kernel-owner+w=401wt.eu-S1762015AbYBSAv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762015AbYBSAv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761158AbYBSAu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:50:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:13094 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760691AbYBSAu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:50:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=d7YDC+BFwYOZgwWbL8n5oGJ8cDzpYEJ9m9oPrva0JBg2BoD4RTZqJMGieFuvwtB5xpZ/APT0b9goLmCkHfgcG4oWQprnwf71DtIFL0ffK144euP04SfMECC/4GwwUcTHaKINgGlG+mUKJcsnTx+awu/pQOsv51hSHg6t0dwV6dw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: linux-next: Tree for Feb 18
Date: Tue, 19 Feb 2008 00:56:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080218190841.eeed735f.sfr@canb.auug.org.au> <20080218.004759.27101677.davem@davemloft.net>
In-Reply-To: <20080218.004759.27101677.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802190056.00277.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 18 Feb 2008 19:08:41 +1100
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> The patch below fixes the allmodconfig build on sparc64
> for me.
> 
> I notice on the build status page that sparc64 allmodconfig
> fails in the CODA filesystem bits.  I suspect this is some
> cross-build issue, and even moreso it appears the "u_quad"
> definition is to blame and the way that gets defined in the
> CODA fs headers is beyond questionable :-/
> 
> Anyways, here is the build fix:
> 
> [SPARC64]: Add ide_default_irq() implementation.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/include/asm-sparc64/ide.h b/include/asm-sparc64/ide.h
> index c5fdabe..5bfb064 100644
> --- a/include/asm-sparc64/ide.h
> +++ b/include/asm-sparc64/ide.h
> @@ -24,6 +24,11 @@
>  # endif
>  #endif
>  
> +static inline int ide_default_irq(unsigned long base)
> +{
> +	return 0;
> +}
> +
>  #define __ide_insl(data_reg, buffer, wcount) \
>  	__ide_insw(data_reg, buffer, (wcount)<<1)
>  #define __ide_outsl(data_reg, buffer, wcount) \

Thanks, I fixed it in the "guilty" patch to preserve bisectability.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS (take 2)

* Add CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS to drivers/ide/Kconfig and use
  it instead of defining IDE_ARCH_OBSOLETE_DEFAULTS in <arch/ide.h>.

v2:
* Define ide_default_irq() in ide-probe.c/ns87415.c if not already defined
  and drop defining ide_default_irq() for CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS=n.

  [ Thanks to Stephen Rothwell and David Miller for noticing the problem. ]

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig                 |    3 +++
 drivers/ide/ide-probe.c             |    4 ++++
 drivers/ide/ide.c                   |    4 ++++
 drivers/ide/pci/ns87415.c           |    4 ++++
 include/asm-alpha/ide.h             |    3 ---
 include/asm-ia64/ide.h              |    2 --
 include/asm-m32r/ide.h              |    2 --
 include/asm-mips/mach-generic/ide.h |    2 --
 include/asm-powerpc/ide.h           |    2 --
 include/asm-x86/ide.h               |    2 --
 include/linux/ide.h                 |    7 -------
 11 files changed, 15 insertions(+), 20 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1099,6 +1099,9 @@ config BLK_DEV_IDEDMA
 config IDE_ARCH_OBSOLETE_INIT
 	def_bool ALPHA || (ARM && !ARCH_L7200) || BLACKFIN || X86 || IA64 || M32R || MIPS || PARISC || PPC || (SUPERH64 && BLK_DEV_IDEPCI) || SPARC
 
+config IDE_ARCH_OBSOLETE_DEFAULTS
+	def_bool ALPHA || X86 || IA64 || M32R || MIPS || PPC32
+
 endif
 
 config BLK_DEV_HD_ONLY
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1229,6 +1229,10 @@ static void drive_release_dev (struct de
 	complete(&drive->gendev_rel_comp);
 }
 
+#ifndef ide_default_irq
+#define ide_default_irq(irq) 0
+#endif
+
 static int hwif_init(ide_hwif_t *hwif)
 {
 	int old_irq;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -167,6 +167,10 @@ static void ide_port_init_devices_data(i
 	}
 }
 
+#ifndef CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS
+# define ide_default_io_base(index)	(0)
+# define ide_init_default_irq(base)	(0)
+#endif
 
 /*
  * init_ide_data() sets reasonable default values into all fields
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -181,6 +181,10 @@ static int ns87415_ide_dma_setup(ide_dri
 	return 1;
 }
 
+#ifndef ide_default_irq
+#define ide_default_irq(irq) 0
+#endif
+
 static void __devinit init_hwif_ns87415 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
Index: b/include/asm-alpha/ide.h
===================================================================
--- a/include/asm-alpha/ide.h
+++ b/include/asm-alpha/ide.h
@@ -13,9 +13,6 @@
 
 #ifdef __KERNEL__
 
-
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static inline int ide_default_irq(unsigned long base)
 {
 	switch (base) {
Index: b/include/asm-ia64/ide.h
===================================================================
--- a/include/asm-ia64/ide.h
+++ b/include/asm-ia64/ide.h
@@ -16,8 +16,6 @@
 
 #include <linux/irq.h>
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static inline int ide_default_irq(unsigned long base)
 {
 	switch (base) {
Index: b/include/asm-m32r/ide.h
===================================================================
--- a/include/asm-m32r/ide.h
+++ b/include/asm-m32r/ide.h
@@ -23,8 +23,6 @@
 # endif
 #endif
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static __inline__ int ide_default_irq(unsigned long base)
 {
 	switch (base) {
Index: b/include/asm-mips/mach-generic/ide.h
===================================================================
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -27,8 +27,6 @@
 # endif
 #endif
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static __inline__ int ide_probe_legacy(void)
 {
 #ifdef CONFIG_PCI
Index: b/include/asm-powerpc/ide.h
===================================================================
--- a/include/asm-powerpc/ide.h
+++ b/include/asm-powerpc/ide.h
@@ -31,8 +31,6 @@
 #include <linux/hdreg.h>
 #include <linux/ioport.h>
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 /* FIXME: use ide_platform host driver */
 static __inline__ int ide_default_irq(unsigned long base)
 {
Index: b/include/asm-x86/ide.h
===================================================================
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -20,8 +20,6 @@
 # endif
 #endif
 
-#define IDE_ARCH_OBSOLETE_DEFAULTS
-
 static __inline__ int ide_default_irq(unsigned long base)
 {
 	switch (base) {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -194,13 +194,6 @@ static inline void ide_std_init_ports(hw
 #define MAX_HWIFS	CONFIG_IDE_MAX_HWIFS
 #endif
 
-/* needed on alpha, x86/x86_64, ia64, mips, ppc32 and sh */
-#ifndef IDE_ARCH_OBSOLETE_DEFAULTS
-# define ide_default_io_base(index)	(0)
-# define ide_default_irq(base)		(0)
-# define ide_init_default_irq(base)	(0)
-#endif
-
 /* Currently only m68k, apus and m8xx need it */
 #ifndef IDE_ARCH_ACK_INTR
 # define ide_ack_intr(hwif) (1)
