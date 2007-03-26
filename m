Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXCZTgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXCZTgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbXCZTgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:36:17 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4122 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753724AbXCZTgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:36:14 -0400
Date: Mon, 26 Mar 2007 21:35:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Badari Pulavarty <pbadari@us.ibm.com>, Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070326213548.e27d7361.khali@linux-fr.org>
In-Reply-To: <1174939556.16728.11.camel@dyn9047017100.beaverton.ibm.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<1174939556.16728.11.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Badari,

On Mon, 26 Mar 2007 12:05:56 -0800, Badari Pulavarty wrote:
> On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 
>  # make -j8 modules
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   LD [M]  sound/soundcore.o
>   CC [M]  sound/ppc/beep.o
> sound/ppc/beep.c: In function ‘snd_pmac_attach_beep’:
> sound/ppc/beep.c:224: error: dereferencing pointer to incomplete type
> sound/ppc/beep.c:242: error: dereferencing pointer to incomplete type
> sound/ppc/beep.c:265: error: dereferencing pointer to incomplete type
> sound/ppc/beep.c: In function ‘snd_pmac_detach_beep’:
> sound/ppc/beep.c:275: error: dereferencing pointer to incomplete type
> make[2]: *** [sound/ppc/beep.o] Error 1
> make[1]: *** [sound/ppc] Error 2
> make: *** [sound] Error 2
> make: *** Waiting for unfinished jobs....
> 
> 
> Patch that is causing the problem in -mm:
> gregkh-pci-pci-cleanup-the-includes-of-linux-pcih.patch
> 
> sound/ppc/beep.c needs to include <linux/pci.h>

Good catch, thanks for reporting. I expected a few false positives to
be left in my patch, but couldn't test everything.

Greg, please update your copy with this version of the patch. The only
change is that sound/ppc/beep.c is removed from the patch.

* * * * *

I noticed that many source files include <linux/pci.h> while they do
not appear to need it. Here is an attempt to clean it all up.

In order to find all possibly affected files, I searched for all
files including <linux/pci.h> but without any other occurence of "pci"
or "PCI". I removed the include statement from all of these, then I
compiled an allmodconfig kernel on both i386 and x86_64 and fixed the
false positives manually.

My tests covered 66% of the affected files, so there could be false
positives remaining. Untested files are:

arch/alpha/kernel/err_common.c
arch/alpha/kernel/err_ev6.c
arch/alpha/kernel/err_ev7.c
arch/ia64/sn/kernel/huberror.c
arch/ia64/sn/kernel/xpnet.c
arch/m68knommu/kernel/dma.c
arch/mips/lib/iomap.c
arch/powerpc/platforms/pseries/ras.c
arch/ppc/8260_io/enet.c
arch/ppc/8260_io/fcc_enet.c
arch/ppc/8xx_io/enet.c
arch/ppc/syslib/ppc4xx_sgdma.c
arch/sh64/mach-cayman/iomap.c
arch/xtensa/kernel/xtensa_ksyms.c
arch/xtensa/platform-iss/setup.c
drivers/i2c/busses/i2c-at91.c
drivers/i2c/busses/i2c-mpc.c
drivers/media/video/saa711x.c
drivers/misc/hdpuftrs/hdpu_cpustate.c
drivers/misc/hdpuftrs/hdpu_nexus.c
drivers/net/au1000_eth.c
drivers/net/fec_8xx/fec_main.c
drivers/net/fec_8xx/fec_mii.c
drivers/net/fs_enet/fs_enet-main.c
drivers/net/fs_enet/mac-fcc.c
drivers/net/fs_enet/mac-fec.c
drivers/net/fs_enet/mac-scc.c
drivers/net/fs_enet/mii-bitbang.c
drivers/net/fs_enet/mii-fec.c
drivers/net/ibm_emac/ibm_emac_core.c
drivers/net/lasi_82596.c
drivers/parisc/hppb.c
drivers/sbus/sbus.c
drivers/video/g364fb.c
drivers/video/platinumfb.c
drivers/video/stifb.c
drivers/video/valkyriefb.c
include/asm-arm/arch-ixp4xx/dma.h
sound/oss/au1550_ac97.c

I would welcome test reports for these files. I am fine with removing
the untested files from the patch if the general opinion is that these
changes aren't safe. The tested part would still be nice to have.

Note that this patch depends on another header fixup patch I submitted
to LKML yesterday:
  [PATCH] scatterlist.h needs types.h
  http://lkml.org/lkml/2007/3/01/141

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 arch/alpha/kernel/err_common.c               |    1 -
 arch/alpha/kernel/err_ev6.c                  |    1 -
 arch/alpha/kernel/err_ev7.c                  |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-lib.c |    1 -
 arch/i386/kernel/cpu/cpufreq/speedstep-smi.c |    2 +-
 arch/ia64/sn/kernel/huberror.c               |    1 -
 arch/ia64/sn/kernel/xpnet.c                  |    1 -
 arch/m68knommu/kernel/dma.c                  |    1 -
 arch/mips/lib/iomap.c                        |    1 -
 arch/powerpc/platforms/pseries/ras.c         |    1 -
 arch/ppc/8260_io/enet.c                      |    1 -
 arch/ppc/8260_io/fcc_enet.c                  |    1 -
 arch/ppc/8xx_io/enet.c                       |    1 -
 arch/ppc/syslib/ppc4xx_sgdma.c               |    1 -
 arch/sh64/mach-cayman/iomap.c                |    1 -
 arch/xtensa/kernel/xtensa_ksyms.c            |    1 -
 arch/xtensa/platform-iss/setup.c             |    1 -
 drivers/ata/pata_winbond.c                   |    1 -
 drivers/atm/adummy.c                         |    1 -
 drivers/char/hw_random/via-rng.c             |    1 -
 drivers/char/pcmcia/synclink_cs.c            |    1 -
 drivers/char/tpm/tpm.h                       |    1 -
 drivers/char/watchdog/sc1200wdt.c            |    1 -
 drivers/char/watchdog/scx200_wdt.c           |    2 +-
 drivers/i2c/busses/i2c-at91.c                |    1 -
 drivers/i2c/busses/i2c-mpc.c                 |    1 -
 drivers/i2c/busses/i2c-pca-isa.c             |    1 -
 drivers/ieee1394/hosts.c                     |    1 -
 drivers/infiniband/core/cm.c                 |    1 -
 drivers/infiniband/core/iwcm.c               |    1 -
 drivers/infiniband/core/mad_priv.h           |    1 -
 drivers/infiniband/core/multicast.c          |    1 -
 drivers/infiniband/core/sa_query.c           |    1 -
 drivers/infiniband/core/user_mad.c           |    1 -
 drivers/infiniband/hw/ipath/ipath_fs.c       |    1 -
 drivers/infiniband/hw/ipath/ipath_layer.c    |    1 -
 drivers/infiniband/hw/ipath/ipath_stats.c    |    2 --
 drivers/infiniband/hw/ipath/ipath_sysfs.c    |    1 -
 drivers/infiniband/hw/mthca/mthca_memfree.h  |    1 -
 drivers/infiniband/ulp/ipoib/ipoib.h         |    1 -
 drivers/isdn/hisax/netjet.c                  |    1 -
 drivers/isdn/hysdn/hysdn_proclog.c           |    1 -
 drivers/media/dvb/cinergyT2/cinergyT2.c      |    2 +-
 drivers/media/video/adv7170.c                |    1 -
 drivers/media/video/adv7175.c                |    1 -
 drivers/media/video/bt819.c                  |    1 -
 drivers/media/video/bt856.c                  |    1 -
 drivers/media/video/bt866.c                  |    1 -
 drivers/media/video/cx88/cx88-tvaudio.c      |    1 -
 drivers/media/video/em28xx/em28xx-cards.c    |    1 -
 drivers/media/video/saa7111.c                |    1 -
 drivers/media/video/saa7114.c                |    1 -
 drivers/media/video/saa711x.c                |    1 -
 drivers/media/video/saa7185.c                |    1 -
 drivers/misc/hdpuftrs/hdpu_cpustate.c        |    1 -
 drivers/misc/hdpuftrs/hdpu_nexus.c           |    1 -
 drivers/mtd/devices/doc2000.c                |    1 -
 drivers/mtd/devices/doc2001.c                |    1 -
 drivers/mtd/devices/doc2001plus.c            |    1 -
 drivers/mtd/devices/docecc.c                 |    1 -
 drivers/mtd/inftlmount.c                     |    1 -
 drivers/mtd/nand/cs553x_nand.c               |    1 -
 drivers/mtd/nftlcore.c                       |    1 -
 drivers/net/atl1/atl1_param.c                |    1 -
 drivers/net/au1000_eth.c                     |    1 -
 drivers/net/fec_8xx/fec_main.c               |    1 -
 drivers/net/fec_8xx/fec_mii.c                |    1 -
 drivers/net/fs_enet/fs_enet-main.c           |    1 -
 drivers/net/fs_enet/mac-fcc.c                |    1 -
 drivers/net/fs_enet/mac-fec.c                |    1 -
 drivers/net/fs_enet/mac-scc.c                |    1 -
 drivers/net/fs_enet/mii-bitbang.c            |    1 -
 drivers/net/fs_enet/mii-fec.c                |    1 -
 drivers/net/ibm_emac/ibm_emac_core.c         |    1 -
 drivers/net/ixgb/ixgb_osdep.h                |    1 -
 drivers/net/lasi_82596.c                     |    1 -
 drivers/net/tokenring/madgemc.c              |    1 -
 drivers/net/tokenring/smctr.c                |    1 -
 drivers/net/tulip/21142.c                    |    1 -
 drivers/net/tulip/pnic.c                     |    1 -
 drivers/net/tulip/pnic2.c                    |    1 -
 drivers/net/tulip/timer.c                    |    1 -
 drivers/net/tulip/tulip.h                    |    1 +
 drivers/net/wan/lmc/lmc_media.c              |    1 -
 drivers/net/wan/lmc/lmc_proto.c              |    1 -
 drivers/net/wan/pc300_tty.c                  |    1 -
 drivers/parisc/hppb.c                        |    2 --
 drivers/pcmcia/cs.c                          |    1 -
 drivers/pcmcia/socket_sysfs.c                |    1 -
 drivers/sbus/sbus.c                          |    1 -
 drivers/scsi/aacraid/dpcsup.c                |    1 -
 drivers/scsi/aacraid/sa.c                    |    1 -
 drivers/scsi/aha1542.c                       |    1 -
 drivers/scsi/aic94xx/aic94xx_scb.c           |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c            |    1 -
 drivers/scsi/libsas/sas_expander.c           |    1 -
 drivers/scsi/libsrp.c                        |    1 -
 drivers/usb/net/kaweth.c                     |    1 -
 drivers/video/aty/radeon_i2c.c               |    1 -
 drivers/video/g364fb.c                       |    1 -
 drivers/video/platinumfb.c                   |    1 -
 drivers/video/stifb.c                        |    1 -
 drivers/video/valkyriefb.c                   |    1 -
 include/asm-arm/arch-ixp4xx/dma.h            |    1 -
 include/rdma/ib_mad.h                        |    2 --
 sound/core/init.c                            |    1 -
 sound/oss/au1550_ac97.c                      |    1 -
 sound/oss/soundcard.c                        |    1 +
 sound/pci/ca0106/ca0106_mixer.c              |    2 +-
 sound/pci/ca0106/ca0106_proc.c               |    2 +-
 sound/pci/cs46xx/dsp_spos.c                  |    1 -
 sound/pci/cs46xx/dsp_spos_scb_lib.c          |    1 -
 sound/pci/hda/hda_generic.c                  |    1 -
 sound/pci/hda/hda_proc.c                     |    1 -
 sound/pci/hda/patch_atihdmi.c                |    1 -
 sound/pci/hda/patch_si3054.c                 |    1 -
 sound/pci/hda/patch_via.c                    |    1 -
 117 files changed, 7 insertions(+), 118 deletions(-)

--- linux-2.6.21-rc5.orig/arch/alpha/kernel/err_common.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/alpha/kernel/err_common.c	2007-03-26 13:54:33.000000000 +0200
@@ -7,7 +7,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
--- linux-2.6.21-rc5.orig/arch/alpha/kernel/err_ev6.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/alpha/kernel/err_ev6.c	2007-03-26 13:54:33.000000000 +0200
@@ -7,7 +7,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
--- linux-2.6.21-rc5.orig/arch/alpha/kernel/err_ev7.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/alpha/kernel/err_ev7.c	2007-03-26 13:54:33.000000000 +0200
@@ -7,7 +7,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 
 #include <asm/io.h>
--- linux-2.6.21-rc5.orig/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/i386/kernel/cpu/cpufreq/speedstep-lib.c	2007-03-26 13:54:33.000000000 +0200
@@ -13,7 +13,6 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 
 #include <asm/msr.h>
--- linux-2.6.21-rc5.orig/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/i386/kernel/cpu/cpufreq/speedstep-smi.c	2007-03-26 13:54:33.000000000 +0200
@@ -17,10 +17,10 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/cpufreq.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <asm/ist.h>
+#include <asm/io.h>
 
 #include "speedstep-lib.h"
 
--- linux-2.6.21-rc5.orig/arch/ia64/sn/kernel/huberror.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/ia64/sn/kernel/huberror.c	2007-03-26 13:54:33.000000000 +0200
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <asm/delay.h>
 #include <asm/sn/sn_sal.h>
 #include "ioerror.h"
--- linux-2.6.21-rc5.orig/arch/ia64/sn/kernel/xpnet.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/ia64/sn/kernel/xpnet.c	2007-03-26 13:54:33.000000000 +0200
@@ -24,7 +24,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/arch/m68knommu/kernel/dma.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/m68knommu/kernel/dma.c	2007-03-26 13:54:33.000000000 +0200
@@ -8,7 +8,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/string.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 
 void *dma_alloc_coherent(struct device *dev, size_t size,
--- linux-2.6.21-rc5.orig/arch/mips/lib/iomap.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/mips/lib/iomap.c	2007-03-26 13:54:33.000000000 +0200
@@ -6,7 +6,6 @@
  * (C) Copyright 2007 MIPS Technologies, Inc.
  *     written by Ralf Baechle <ralf@linux-mips.org>
  */
-#include <linux/pci.h>
 #include <linux/module.h>
 #include <asm/io.h>
 
--- linux-2.6.21-rc5.orig/arch/powerpc/platforms/pseries/ras.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/powerpc/platforms/pseries/ras.c	2007-03-26 13:54:33.000000000 +0200
@@ -31,7 +31,6 @@
 #include <linux/timex.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/random.h>
--- linux-2.6.21-rc5.orig/arch/ppc/8260_io/enet.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/ppc/8260_io/enet.c	2007-03-26 13:54:33.000000000 +0200
@@ -32,7 +32,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/arch/ppc/8260_io/fcc_enet.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/ppc/8260_io/fcc_enet.c	2007-03-26 13:54:33.000000000 +0200
@@ -29,7 +29,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/arch/ppc/8xx_io/enet.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/ppc/8xx_io/enet.c	2007-03-26 13:54:33.000000000 +0200
@@ -30,7 +30,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/arch/ppc/syslib/ppc4xx_sgdma.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/ppc/syslib/ppc4xx_sgdma.c	2007-03-26 13:54:33.000000000 +0200
@@ -23,7 +23,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
--- linux-2.6.21-rc5.orig/arch/sh64/mach-cayman/iomap.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/sh64/mach-cayman/iomap.c	2007-03-26 13:54:33.000000000 +0200
@@ -9,7 +9,6 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
-#include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/cayman.h>
 
--- linux-2.6.21-rc5.orig/arch/xtensa/kernel/xtensa_ksyms.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/xtensa/kernel/xtensa_ksyms.c	2007-03-26 13:54:33.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <asm/irq.h>
 #include <linux/in6.h>
-#include <linux/pci.h>
 #include <linux/ide.h>
 
 #include <asm/uaccess.h>
--- linux-2.6.21-rc5.orig/arch/xtensa/platform-iss/setup.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/arch/xtensa/platform-iss/setup.c	2007-03-26 13:54:33.000000000 +0200
@@ -20,7 +20,6 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/reboot.h>
-#include <linux/pci.h>
 #include <linux/kdev_t.h>
 #include <linux/types.h>
 #include <linux/major.h>
--- linux-2.6.21-rc5.orig/drivers/ata/pata_winbond.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/ata/pata_winbond.c	2007-03-26 13:54:33.000000000 +0200
@@ -8,7 +8,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
--- linux-2.6.21-rc5.orig/drivers/atm/adummy.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/atm/adummy.c	2007-03-26 13:54:33.000000000 +0200
@@ -6,7 +6,6 @@
 #include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
-#include <linux/pci.h>
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/string.h>
--- linux-2.6.21-rc5.orig/drivers/char/hw_random/via-rng.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/char/hw_random/via-rng.c	2007-03-26 13:54:33.000000000 +0200
@@ -26,7 +26,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/hw_random.h>
 #include <asm/io.h>
 #include <asm/msr.h>
--- linux-2.6.21-rc5.orig/drivers/char/pcmcia/synclink_cs.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/char/pcmcia/synclink_cs.c	2007-03-26 13:54:33.000000000 +0200
@@ -42,7 +42,6 @@
 #include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
--- linux-2.6.21-rc5.orig/drivers/char/tpm/tpm.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/char/tpm/tpm.h	2007-03-26 13:54:33.000000000 +0200
@@ -19,7 +19,6 @@
  * 
  */
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
--- linux-2.6.21-rc5.orig/drivers/char/watchdog/sc1200wdt.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/char/watchdog/sc1200wdt.c	2007-03-26 13:54:33.000000000 +0200
@@ -38,7 +38,6 @@
 #include <linux/init.h>
 #include <linux/pnp.h>
 #include <linux/fs.h>
-#include <linux/pci.h>
 
 #include <asm/semaphore.h>
 #include <asm/io.h>
--- linux-2.6.21-rc5.orig/drivers/char/watchdog/scx200_wdt.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/char/watchdog/scx200_wdt.c	2007-03-26 13:54:33.000000000 +0200
@@ -25,7 +25,7 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/fs.h>
-#include <linux/pci.h>
+#include <linux/ioport.h>
 #include <linux/scx200.h>
 
 #include <asm/uaccess.h>
--- linux-2.6.21-rc5.orig/drivers/i2c/busses/i2c-at91.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/i2c/busses/i2c-at91.c	2007-03-26 13:54:33.000000000 +0200
@@ -17,7 +17,6 @@
 #include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
--- linux-2.6.21-rc5.orig/drivers/i2c/busses/i2c-mpc.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/i2c/busses/i2c-mpc.c	2007-03-26 13:54:33.000000000 +0200
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
--- linux-2.6.21-rc5.orig/drivers/i2c/busses/i2c-pca-isa.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/i2c/busses/i2c-pca-isa.c	2007-03-26 21:30:22.000000000 +0200
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/wait.h>
 
 #include <linux/i2c.h>
--- linux-2.6.21-rc5.orig/drivers/ieee1394/hosts.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/ieee1394/hosts.c	2007-03-26 13:54:33.000000000 +0200
@@ -15,7 +15,6 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
--- linux-2.6.21-rc5.orig/drivers/infiniband/core/cm.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/core/cm.c	2007-03-26 13:54:33.000000000 +0200
@@ -40,7 +40,6 @@
 #include <linux/err.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/random.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
--- linux-2.6.21-rc5.orig/drivers/infiniband/core/iwcm.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/core/iwcm.c	2007-03-26 13:54:33.000000000 +0200
@@ -39,7 +39,6 @@
 #include <linux/err.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
--- linux-2.6.21-rc5.orig/drivers/infiniband/core/mad_priv.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/core/mad_priv.h	2007-03-26 13:54:33.000000000 +0200
@@ -39,7 +39,6 @@
 
 #include <linux/completion.h>
 #include <linux/err.h>
-#include <linux/pci.h>
 #include <linux/workqueue.h>
 #include <rdma/ib_mad.h>
 #include <rdma/ib_smi.h>
--- linux-2.6.21-rc5.orig/drivers/infiniband/core/multicast.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/core/multicast.c	2007-03-26 13:54:33.000000000 +0200
@@ -34,7 +34,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/random.h>
 
--- linux-2.6.21-rc5.orig/drivers/infiniband/core/sa_query.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/core/sa_query.c	2007-03-26 13:54:33.000000000 +0200
@@ -40,7 +40,6 @@
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/kref.h>
 #include <linux/idr.h>
--- linux-2.6.21-rc5.orig/drivers/infiniband/core/user_mad.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/core/user_mad.c	2007-03-26 13:54:33.000000000 +0200
@@ -40,7 +40,6 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/cdev.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/poll.h>
 #include <linux/rwsem.h>
--- linux-2.6.21-rc5.orig/drivers/infiniband/hw/ipath/ipath_fs.c	2007-03-26 13:54:18.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/hw/ipath/ipath_fs.c	2007-03-26 13:54:33.000000000 +0200
@@ -38,7 +38,6 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/namei.h>
-#include <linux/pci.h>
 
 #include "ipath_kernel.h"
 
--- linux-2.6.21-rc5.orig/drivers/infiniband/hw/ipath/ipath_layer.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/hw/ipath/ipath_layer.c	2007-03-26 13:54:33.000000000 +0200
@@ -37,7 +37,6 @@
  */
 
 #include <linux/io.h>
-#include <linux/pci.h>
 #include <asm/byteorder.h>
 
 #include "ipath_kernel.h"
--- linux-2.6.21-rc5.orig/drivers/infiniband/hw/ipath/ipath_stats.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/hw/ipath/ipath_stats.c	2007-03-26 13:54:33.000000000 +0200
@@ -31,8 +31,6 @@
  * SOFTWARE.
  */
 
-#include <linux/pci.h>
-
 #include "ipath_kernel.h"
 
 struct infinipath_stats ipath_stats;
--- linux-2.6.21-rc5.orig/drivers/infiniband/hw/ipath/ipath_sysfs.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/hw/ipath/ipath_sysfs.c	2007-03-26 13:54:33.000000000 +0200
@@ -32,7 +32,6 @@
  */
 
 #include <linux/ctype.h>
-#include <linux/pci.h>
 
 #include "ipath_kernel.h"
 #include "ipath_common.h"
--- linux-2.6.21-rc5.orig/drivers/infiniband/hw/mthca/mthca_memfree.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/hw/mthca/mthca_memfree.h	2007-03-26 13:54:33.000000000 +0200
@@ -38,7 +38,6 @@
 #define MTHCA_MEMFREE_H
 
 #include <linux/list.h>
-#include <linux/pci.h>
 #include <linux/mutex.h>
 
 #define MTHCA_ICM_CHUNK_LEN \
--- linux-2.6.21-rc5.orig/drivers/infiniband/ulp/ipoib/ipoib.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/infiniband/ulp/ipoib/ipoib.h	2007-03-26 13:54:33.000000000 +0200
@@ -41,7 +41,6 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
-#include <linux/pci.h>
 #include <linux/kref.h>
 #include <linux/if_infiniband.h>
 #include <linux/mutex.h>
--- linux-2.6.21-rc5.orig/drivers/isdn/hisax/netjet.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/isdn/hisax/netjet.c	2007-03-26 13:54:33.000000000 +0200
@@ -19,7 +19,6 @@
 #include "isac.h"
 #include "hscx.h"
 #include "isdnl1.h"
-#include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/ppp_defs.h>
 #include <asm/io.h>
--- linux-2.6.21-rc5.orig/drivers/isdn/hysdn/hysdn_proclog.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/isdn/hysdn/hysdn_proclog.c	2007-03-26 13:54:33.000000000 +0200
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
-#include <linux/pci.h>
 #include <linux/smp_lock.h>
 
 #include "hysdn_defs.h"
--- linux-2.6.21-rc5.orig/drivers/media/dvb/cinergyT2/cinergyT2.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/dvb/cinergyT2/cinergyT2.c	2007-03-26 13:54:33.000000000 +0200
@@ -26,11 +26,11 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-#include <linux/pci.h>
 #include <linux/input.h>
 #include <linux/dvb/frontend.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
+#include <asm/io.h>
 
 #include "dmxdev.h"
 #include "dvb_demux.h"
--- linux-2.6.21-rc5.orig/drivers/media/video/adv7170.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/adv7170.c	2007-03-26 13:54:33.000000000 +0200
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/adv7175.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/adv7175.c	2007-03-26 13:54:33.000000000 +0200
@@ -33,7 +33,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/bt819.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/bt819.c	2007-03-26 13:54:33.000000000 +0200
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/bt856.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/bt856.c	2007-03-26 13:54:33.000000000 +0200
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/bt866.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/bt866.c	2007-03-26 13:54:33.000000000 +0200
@@ -37,7 +37,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/cx88/cx88-tvaudio.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/cx88/cx88-tvaudio.c	2007-03-26 13:54:33.000000000 +0200
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/poll.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <linux/ioport.h>
 #include <linux/types.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/em28xx/em28xx-cards.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/em28xx/em28xx-cards.c	2007-03-26 13:54:33.000000000 +0200
@@ -23,7 +23,6 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/usb.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/saa7111.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/saa7111.c	2007-03-26 13:54:33.000000000 +0200
@@ -36,7 +36,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/saa7114.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/saa7114.c	2007-03-26 13:54:33.000000000 +0200
@@ -39,7 +39,6 @@
 #include <linux/slab.h>
 
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/saa711x.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/saa711x.c	2007-03-26 13:54:33.000000000 +0200
@@ -30,7 +30,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/media/video/saa7185.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/media/video/saa7185.c	2007-03-26 13:54:33.000000000 +0200
@@ -33,7 +33,6 @@
 #include <linux/major.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/pci.h>
 #include <linux/signal.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
--- linux-2.6.21-rc5.orig/drivers/misc/hdpuftrs/hdpu_cpustate.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/misc/hdpuftrs/hdpu_cpustate.c	2007-03-26 13:54:33.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
 #include <asm/uaccess.h>
--- linux-2.6.21-rc5.orig/drivers/misc/hdpuftrs/hdpu_nexus.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/misc/hdpuftrs/hdpu_nexus.c	2007-03-26 13:54:33.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/hdpu_features.h>
-#include <linux/pci.h>
 
 #include <linux/platform_device.h>
 
--- linux-2.6.21-rc5.orig/drivers/mtd/devices/doc2000.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/mtd/devices/doc2000.c	2007-03-26 13:54:33.000000000 +0200
@@ -13,7 +13,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
--- linux-2.6.21-rc5.orig/drivers/mtd/devices/doc2001.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/mtd/devices/doc2001.c	2007-03-26 13:54:33.000000000 +0200
@@ -13,7 +13,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- linux-2.6.21-rc5.orig/drivers/mtd/devices/doc2001plus.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/mtd/devices/doc2001plus.c	2007-03-26 13:54:33.000000000 +0200
@@ -17,7 +17,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- linux-2.6.21-rc5.orig/drivers/mtd/devices/docecc.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/mtd/devices/docecc.c	2007-03-26 13:54:33.000000000 +0200
@@ -29,7 +29,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- linux-2.6.21-rc5.orig/drivers/mtd/inftlmount.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/mtd/inftlmount.c	2007-03-26 13:54:33.000000000 +0200
@@ -31,7 +31,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- linux-2.6.21-rc5.orig/drivers/mtd/nand/cs553x_nand.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/mtd/nand/cs553x_nand.c	2007-03-26 13:54:33.000000000 +0200
@@ -20,7 +20,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/nand_ecc.h>
--- linux-2.6.21-rc5.orig/drivers/mtd/nftlcore.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/mtd/nftlcore.c	2007-03-26 13:54:33.000000000 +0200
@@ -17,7 +17,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/miscdevice.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
--- linux-2.6.21-rc5.orig/drivers/net/atl1/atl1_param.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/atl1/atl1_param.c	2007-03-26 13:54:33.000000000 +0200
@@ -22,7 +22,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/moduleparam.h>
 #include "atl1.h"
 
--- linux-2.6.21-rc5.orig/drivers/net/au1000_eth.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/au1000_eth.c	2007-03-26 13:54:33.000000000 +0200
@@ -45,7 +45,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fec_8xx/fec_main.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fec_8xx/fec_main.c	2007-03-26 13:54:33.000000000 +0200
@@ -19,7 +19,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fec_8xx/fec_mii.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fec_8xx/fec_mii.c	2007-03-26 13:54:33.000000000 +0200
@@ -19,7 +19,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fs_enet/fs_enet-main.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fs_enet/fs_enet-main.c	2007-03-26 13:54:33.000000000 +0200
@@ -24,7 +24,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fs_enet/mac-fcc.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fs_enet/mac-fcc.c	2007-03-26 13:54:33.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fs_enet/mac-fec.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fs_enet/mac-fec.c	2007-03-26 13:54:33.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fs_enet/mac-scc.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fs_enet/mac-scc.c	2007-03-26 13:54:33.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fs_enet/mii-bitbang.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fs_enet/mii-bitbang.c	2007-03-26 13:54:33.000000000 +0200
@@ -22,7 +22,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/fs_enet/mii-fec.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/fs_enet/mii-fec.c	2007-03-26 13:54:33.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/ibm_emac/ibm_emac_core.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/ibm_emac/ibm_emac_core.c	2007-03-26 13:54:33.000000000 +0200
@@ -27,7 +27,6 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
--- linux-2.6.21-rc5.orig/drivers/net/ixgb/ixgb_osdep.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/ixgb/ixgb_osdep.h	2007-03-26 13:54:33.000000000 +0200
@@ -34,7 +34,6 @@
 #define _IXGB_OSDEP_H_
 
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include <asm/io.h>
 #include <linux/interrupt.h>
--- linux-2.6.21-rc5.orig/drivers/net/lasi_82596.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/lasi_82596.c	2007-03-26 13:54:33.000000000 +0200
@@ -81,7 +81,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/types.h>
 #include <linux/bitops.h>
 
--- linux-2.6.21-rc5.orig/drivers/net/tokenring/madgemc.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/tokenring/madgemc.c	2007-03-26 13:54:33.000000000 +0200
@@ -23,7 +23,6 @@ static const char version[] = "madgemc.c
 #include <linux/mca.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/tokenring/smctr.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/tokenring/smctr.c	2007-03-26 13:54:33.000000000 +0200
@@ -41,7 +41,6 @@
 #include <linux/time.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/mca-legacy.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/tulip/21142.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/tulip/21142.c	2007-03-26 13:54:33.000000000 +0200
@@ -14,7 +14,6 @@
 
 */
 
-#include <linux/pci.h>
 #include <linux/delay.h>
 #include "tulip.h"
 
--- linux-2.6.21-rc5.orig/drivers/net/tulip/pnic.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/tulip/pnic.c	2007-03-26 13:54:33.000000000 +0200
@@ -15,7 +15,6 @@
 */
 
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/jiffies.h>
 #include "tulip.h"
 
--- linux-2.6.21-rc5.orig/drivers/net/tulip/pnic2.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/tulip/pnic2.c	2007-03-26 13:54:33.000000000 +0200
@@ -76,7 +76,6 @@
 
 
 
-#include <linux/pci.h>
 #include "tulip.h"
 #include <linux/delay.h>
 
--- linux-2.6.21-rc5.orig/drivers/net/tulip/timer.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/tulip/timer.c	2007-03-26 13:54:33.000000000 +0200
@@ -14,7 +14,6 @@
 
 */
 
-#include <linux/pci.h>
 #include "tulip.h"
 
 
--- linux-2.6.21-rc5.orig/drivers/net/tulip/tulip.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/tulip/tulip.h	2007-03-26 13:54:33.000000000 +0200
@@ -22,6 +22,7 @@
 #include <linux/netdevice.h>
 #include <linux/timer.h>
 #include <linux/delay.h>
+#include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
--- linux-2.6.21-rc5.orig/drivers/net/wan/lmc/lmc_media.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/wan/lmc/lmc_media.c	2007-03-26 13:54:33.000000000 +0200
@@ -8,7 +8,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/wan/lmc/lmc_proto.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/wan/lmc/lmc_proto.c	2007-03-26 13:54:33.000000000 +0200
@@ -27,7 +27,6 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
--- linux-2.6.21-rc5.orig/drivers/net/wan/pc300_tty.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/net/wan/pc300_tty.c	2007-03-26 13:54:33.000000000 +0200
@@ -38,7 +38,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/pci.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/init.h>
--- linux-2.6.21-rc5.orig/drivers/parisc/hppb.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/parisc/hppb.c	2007-03-26 13:54:33.000000000 +0200
@@ -22,8 +22,6 @@
 #include <asm/hardware.h>
 #include <asm/parisc-device.h>
 
-#include <linux/pci.h>
-
 struct hppb_card {
 	unsigned long hpa;
 	struct resource mmio_region;
--- linux-2.6.21-rc5.orig/drivers/pcmcia/cs.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/pcmcia/cs.c	2007-03-26 13:54:33.000000000 +0200
@@ -26,7 +26,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
-#include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
--- linux-2.6.21-rc5.orig/drivers/pcmcia/socket_sysfs.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/pcmcia/socket_sysfs.c	2007-03-26 13:54:33.000000000 +0200
@@ -22,7 +22,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
-#include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <asm/system.h>
--- linux-2.6.21-rc5.orig/drivers/sbus/sbus.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/sbus/sbus.c	2007-03-26 13:54:33.000000000 +0200
@@ -6,7 +6,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/device.h>
 
 #include <asm/system.h>
--- linux-2.6.21-rc5.orig/drivers/scsi/aacraid/dpcsup.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/scsi/aacraid/dpcsup.c	2007-03-26 13:54:33.000000000 +0200
@@ -32,7 +32,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
--- linux-2.6.21-rc5.orig/drivers/scsi/aacraid/sa.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/scsi/aacraid/sa.c	2007-03-26 13:54:33.000000000 +0200
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
--- linux-2.6.21-rc5.orig/drivers/scsi/aha1542.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/scsi/aha1542.c	2007-03-26 13:54:33.000000000 +0200
@@ -35,7 +35,6 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/pci.h>
 #include <linux/isapnp.h>
 #include <linux/blkdev.h>
 #include <linux/mca.h>
--- linux-2.6.21-rc5.orig/drivers/scsi/aic94xx/aic94xx_scb.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/scsi/aic94xx/aic94xx_scb.c	2007-03-26 13:54:33.000000000 +0200
@@ -24,7 +24,6 @@
  *
  */
 
-#include <linux/pci.h>
 #include <scsi/scsi_host.h>
 
 #include "aic94xx.h"
--- linux-2.6.21-rc5.orig/drivers/scsi/arcmsr/arcmsr_attr.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/scsi/arcmsr/arcmsr_attr.c	2007-03-26 13:54:33.000000000 +0200
@@ -49,7 +49,6 @@
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
--- linux-2.6.21-rc5.orig/drivers/scsi/libsas/sas_expander.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/scsi/libsas/sas_expander.c	2007-03-26 13:54:33.000000000 +0200
@@ -22,7 +22,6 @@
  *
  */
 
-#include <linux/pci.h>
 #include <linux/scatterlist.h>
 
 #include "sas_internal.h"
--- linux-2.6.21-rc5.orig/drivers/scsi/libsrp.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/scsi/libsrp.c	2007-03-26 13:54:33.000000000 +0200
@@ -22,7 +22,6 @@
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
-#include <linux/pci.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
--- linux-2.6.21-rc5.orig/drivers/usb/net/kaweth.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/usb/net/kaweth.c	2007-03-26 13:54:33.000000000 +0200
@@ -55,7 +55,6 @@
 #include <linux/usb.h>
 #include <linux/types.h>
 #include <linux/ethtool.h>
-#include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
--- linux-2.6.21-rc5.orig/drivers/video/aty/radeon_i2c.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/video/aty/radeon_i2c.c	2007-03-26 21:30:25.000000000 +0200
@@ -1,7 +1,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/fb.h>
 
 
--- linux-2.6.21-rc5.orig/drivers/video/g364fb.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/video/g364fb.c	2007-03-26 13:54:33.000000000 +0200
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/jazz.h>
 
--- linux-2.6.21-rc5.orig/drivers/video/platinumfb.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/video/platinumfb.c	2007-03-26 13:54:33.000000000 +0200
@@ -28,7 +28,6 @@
 #include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/nvram.h>
 #include <asm/io.h>
 #include <asm/prom.h>
--- linux-2.6.21-rc5.orig/drivers/video/stifb.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/video/stifb.c	2007-03-26 13:54:33.000000000 +0200
@@ -64,7 +64,6 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/pci.h>
 
 #include <asm/grfioctl.h>	/* for HP-UX compatibility */
 #include <asm/uaccess.h>
--- linux-2.6.21-rc5.orig/drivers/video/valkyriefb.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/drivers/video/valkyriefb.c	2007-03-26 13:54:33.000000000 +0200
@@ -51,7 +51,6 @@
 #include <linux/fb.h>
 #include <linux/selection.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <linux/nvram.h>
 #include <linux/adb.h>
 #include <linux/cuda.h>
--- linux-2.6.21-rc5.orig/include/asm-arm/arch-ixp4xx/dma.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/include/asm-arm/arch-ixp4xx/dma.h	2007-03-26 13:54:33.000000000 +0200
@@ -12,7 +12,6 @@
 #define __ASM_ARCH_DMA_H
 
 #include <linux/device.h>
-#include <linux/pci.h>
 #include <asm/page.h>
 #include <asm/sizes.h>
 #include <asm/hardware.h>
--- linux-2.6.21-rc5.orig/include/rdma/ib_mad.h	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/include/rdma/ib_mad.h	2007-03-26 13:54:33.000000000 +0200
@@ -39,8 +39,6 @@
 #if !defined( IB_MAD_H )
 #define IB_MAD_H
 
-#include <linux/pci.h>
-
 #include <rdma/ib_verbs.h>
 
 /* Management base version */
--- linux-2.6.21-rc5.orig/sound/core/init.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/core/init.c	2007-03-26 13:54:33.000000000 +0200
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/ctype.h>
-#include <linux/pci.h>
 #include <linux/pm.h>
 
 #include <sound/core.h>
--- linux-2.6.21-rc5.orig/sound/oss/au1550_ac97.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/oss/au1550_ac97.c	2007-03-26 13:54:33.000000000 +0200
@@ -47,7 +47,6 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/poll.h>
-#include <linux/pci.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/smp_lock.h>
--- linux-2.6.21-rc5.orig/sound/oss/soundcard.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/oss/soundcard.c	2007-03-26 13:54:33.000000000 +0200
@@ -44,6 +44,7 @@
 #include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/device.h>
 
 /*
  * This ought to be moved into include/asm/dma.h
--- linux-2.6.21-rc5.orig/sound/pci/ca0106/ca0106_mixer.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/ca0106/ca0106_mixer.c	2007-03-26 13:54:33.000000000 +0200
@@ -62,7 +62,6 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <sound/core.h>
@@ -71,6 +70,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/info.h>
 #include <sound/tlv.h>
+#include <asm/io.h>
 
 #include "ca0106.h"
 
--- linux-2.6.21-rc5.orig/sound/pci/ca0106/ca0106_proc.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/ca0106/ca0106_proc.c	2007-03-26 13:54:33.000000000 +0200
@@ -64,7 +64,6 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <sound/core.h>
@@ -73,6 +72,7 @@
 #include <sound/ac97_codec.h>
 #include <sound/info.h>
 #include <sound/asoundef.h>
+#include <asm/io.h>
 
 #include "ca0106.h"
 
--- linux-2.6.21-rc5.orig/sound/pci/cs46xx/dsp_spos.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/cs46xx/dsp_spos.c	2007-03-26 13:54:33.000000000 +0200
@@ -23,7 +23,6 @@
 #include <sound/driver.h>
 #include <asm/io.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/slab.h>
--- linux-2.6.21-rc5.orig/sound/pci/cs46xx/dsp_spos_scb_lib.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/cs46xx/dsp_spos_scb_lib.c	2007-03-26 13:54:33.000000000 +0200
@@ -24,7 +24,6 @@
 #include <sound/driver.h>
 #include <asm/io.h>
 #include <linux/delay.h>
-#include <linux/pci.h>
 #include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/slab.h>
--- linux-2.6.21-rc5.orig/sound/pci/hda/hda_generic.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/hda/hda_generic.c	2007-03-26 13:54:33.000000000 +0200
@@ -23,7 +23,6 @@
 #include <sound/driver.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
--- linux-2.6.21-rc5.orig/sound/pci/hda/hda_proc.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/hda/hda_proc.c	2007-03-26 13:54:33.000000000 +0200
@@ -23,7 +23,6 @@
 
 #include <sound/driver.h>
 #include <linux/init.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
--- linux-2.6.21-rc5.orig/sound/pci/hda/patch_atihdmi.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/hda/patch_atihdmi.c	2007-03-26 13:54:33.000000000 +0200
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
--- linux-2.6.21-rc5.orig/sound/pci/hda/patch_si3054.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/hda/patch_si3054.c	2007-03-26 13:54:33.000000000 +0200
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"
--- linux-2.6.21-rc5.orig/sound/pci/hda/patch_via.c	2007-03-26 13:51:51.000000000 +0200
+++ linux-2.6.21-rc5/sound/pci/hda/patch_via.c	2007-03-26 13:54:33.000000000 +0200
@@ -35,7 +35,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/pci.h>
 #include <sound/core.h>
 #include "hda_codec.h"
 #include "hda_local.h"


-- 
Jean Delvare
