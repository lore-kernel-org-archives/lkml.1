Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbYJ2EmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbYJ2EmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 00:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYJ2EmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 00:42:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:6650 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYJ2EmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 00:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=IFuNEpi1Ah0ksrqW47KUr4pPd/VLLxHn1+OZj+r6ZWyljwny+s+A5gEZtiwHJH5Qoh
         rwp+xaNcl0QdKS3iCc/JJqFH4ekKv9hSBP7tCayjQb129ix4WqKntNqLd0zqZkrsM+Mp
         yLcofvebemcPZmiSyHLyzR71yb7+3ZDocbD8M=
Date: Wed, 29 Oct 2008 07:45:24 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org
Cc: viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] headers: reduction in interrupt.h
Message-ID: <20081029044524.GC2304@x200.localdomain>
References: <20081029044351.GA2304@x200.localdomain> <20081029044447.GB2304@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081029044447.GB2304@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2255be0a5f55ffd58b0ebdf456cf77b7258889fe Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Wed, 29 Oct 2008 06:41:45 +0300
Subject: [PATCH 2/2] headers: reduction in interrupt.h

1. remove sched.h from interrupt.h, it's not needed for anything
2. remove sched.h from smp_lock.h, so (1) won't be a lie due to

	linux/interrupt.h => linux/hardirq.h => linux/smp_lock.h => linux/sched.h

   After static inline reacquire_kernel_lock() was moved from there, inclusion
   isn't needed.
3. remove also kernel.h, linkage.h, preempt.h, smp.h, asm/ptrace.h inclusions,
   I manually checked every token.
4. fix fallout

The end result is that, e.g. i386 allyesconfig kernel shrinks (with all those
bloated debuginfo sections) from 604.1 MB to 593.1 MB (-1.8 %).

Compile time should also improve simply because compiler will parse less.

Cross-compile tested on 469 configs, big and small, across many arches
and a dozen of randconfigs.

However!

cris, frv, h8300, m32r, mn10300, xtensa weren't tested at all, sorry.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/arm/mach-integrator/pci_v3.c               |    1 +
 arch/arm/mach-msm/dma.c                         |    2 +-
 arch/arm/plat-mxc/dma-mx1-mx2.c                 |    1 +
 arch/arm/plat-omap/include/mach/irda.h          |    2 ++
 arch/blackfin/kernel/time.c                     |    1 +
 arch/um/drivers/line.c                          |    1 +
 arch/um/kernel/irq.c                            |    1 +
 arch/x86/kernel/hpet.c                          |    1 +
 arch/x86/kernel/irq_64.c                        |    1 +
 arch/x86/kernel/pci-gart_64.c                   |    1 +
 arch/x86/xen/time.c                             |    1 +
 crypto/aead.c                                   |    1 +
 drivers/char/applicom.c                         |    1 +
 drivers/char/epca.c                             |    1 +
 drivers/char/generic_serial.c                   |    1 +
 drivers/char/istallion.c                        |    1 +
 drivers/char/nozomi.c                           |    1 +
 drivers/char/pty.c                              |    1 +
 drivers/char/rio/riocmd.c                       |    1 +
 drivers/char/rio/rioctrl.c                      |    1 +
 drivers/char/rio/riotty.c                       |    1 +
 drivers/char/ser_a2232.c                        |    1 +
 drivers/char/stallion.c                         |    1 +
 drivers/char/tlclk.c                            |    1 +
 drivers/crypto/hifn_795x.c                      |    3 ++-
 drivers/dma/mv_xor.h                            |    1 +
 drivers/infiniband/core/iwcm.c                  |    1 +
 drivers/infiniband/core/multicast.c             |    1 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c           |    1 +
 drivers/infiniband/hw/ipath/ipath_driver.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba7220.c     |    1 +
 drivers/infiniband/hw/ipath/ipath_intr.c        |    1 +
 drivers/infiniband/hw/ipath/ipath_kernel.h      |    2 ++
 drivers/infiniband/hw/ipath/ipath_qp.c          |    1 +
 drivers/infiniband/hw/ipath/ipath_ruc.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_ud.c          |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c  |    1 +
 drivers/infiniband/hw/ipath/ipath_user_sdma.c   |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |    2 +-
 drivers/input/keyboard/hilkbd.c                 |    1 +
 drivers/input/keyboard/sunkbd.c                 |    1 +
 drivers/input/serio/libps2.c                    |    1 +
 drivers/input/serio/serport.c                   |    1 +
 drivers/input/touchscreen/ads7846.c             |    1 +
 drivers/isdn/capi/kcapi.c                       |    1 +
 drivers/isdn/hisax/arcofi.c                     |    2 +-
 drivers/isdn/hisax/hfc4s8s_l1.c                 |    1 +
 drivers/isdn/hisax/hfc_2bds0.c                  |    1 +
 drivers/isdn/hisax/hfc_pci.c                    |    1 +
 drivers/isdn/pcbit/drv.c                        |    2 +-
 drivers/isdn/pcbit/layer2.c                     |    2 +-
 drivers/isdn/sc/init.c                          |    1 +
 drivers/lguest/interrupts_and_traps.c           |    1 +
 drivers/message/fusion/mptlan.c                 |    1 +
 drivers/mfd/ucb1x00-core.c                      |    1 +
 drivers/misc/ibmasm/command.c                   |    2 +-
 drivers/misc/ibmasm/event.c                     |    2 +-
 drivers/misc/ibmasm/r_heartbeat.c               |    2 +-
 drivers/misc/sgi-gru/grufile.c                  |    1 +
 drivers/mtd/onenand/omap2.c                     |    1 +
 drivers/net/amd8111e.c                          |    2 +-
 drivers/net/chelsio/cxgb2.c                     |    1 +
 drivers/net/depca.c                             |    1 +
 drivers/net/e100.c                              |    1 +
 drivers/net/e1000e/ich8lan.c                    |    1 +
 drivers/net/eql.c                               |    2 +-
 drivers/net/ewrk3.c                             |    1 +
 drivers/net/hamachi.c                           |    1 +
 drivers/net/hamradio/baycom_epp.c               |    1 +
 drivers/net/hamradio/baycom_ser_fdx.c           |    1 +
 drivers/net/hamradio/baycom_ser_hdx.c           |    1 +
 drivers/net/hamradio/hdlcdrv.c                  |    1 +
 drivers/net/hp100.c                             |    1 +
 drivers/net/igb/igb_ethtool.c                   |    1 +
 drivers/net/irda/sir_dev.c                      |    1 +
 drivers/net/irda/toim3232-sir.c                 |    1 +
 drivers/net/mii.c                               |    2 +-
 drivers/net/ns83820.c                           |    1 +
 drivers/net/pcnet32.c                           |    1 +
 drivers/net/phy/phy.c                           |    1 +
 drivers/net/sb1000.c                            |    1 +
 drivers/net/sis900.c                            |    1 +
 drivers/net/skfp/skfddi.c                       |    1 +
 drivers/net/skge.c                              |    1 +
 drivers/net/slip.c                              |    1 +
 drivers/net/sungem.c                            |    1 +
 drivers/net/tlan.c                              |    1 +
 drivers/net/tokenring/ibmtr.c                   |    1 +
 drivers/net/tulip/tulip_core.c                  |    2 +-
 drivers/net/typhoon.c                           |    1 +
 drivers/net/wan/cycx_x25.c                      |    1 +
 drivers/net/wan/dscc4.c                         |    1 +
 drivers/net/wan/farsync.c                       |    1 +
 drivers/net/wan/pci200syn.c                     |    2 +-
 drivers/net/wan/syncppp.c                       |    1 +
 drivers/net/wireless/b43/main.c                 |    1 +
 drivers/net/wireless/b43/pio.c                  |    2 +-
 drivers/net/wireless/b43legacy/main.c           |    1 +
 drivers/net/wireless/b43legacy/phy.c            |    1 +
 drivers/net/wireless/hostap/hostap_info.c       |    2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c      |    1 +
 drivers/net/wireless/ipw2200.c                  |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    1 +
 drivers/net/wireless/libertas/cmd.c             |    2 +-
 drivers/net/wireless/libertas/tx.c              |    1 +
 drivers/net/wireless/orinoco.c                  |    1 +
 drivers/net/wireless/prism54/isl_ioctl.c        |    2 +-
 drivers/net/wireless/prism54/islpci_dev.c       |    2 +-
 drivers/net/wireless/prism54/islpci_mgt.c       |    1 +
 drivers/net/yellowfin.c                         |    1 +
 drivers/pci/pcie/aer/aerdrv.c                   |    1 +
 drivers/spi/omap2_mcspi.c                       |    1 +
 drivers/spi/orion_spi.c                         |    1 +
 drivers/usb/gadget/m66592-udc.h                 |    2 ++
 drivers/uwb/whc-rc.c                            |    1 +
 fs/file.c                                       |    1 +
 include/linux/interrupt.h                       |   15 +++++++--------
 include/linux/mmc/host.h                        |    2 +-
 include/linux/serio.h                           |    1 +
 include/linux/smp_lock.h                        |    2 +-
 kernel/hrtimer.c                                |    1 +
 kernel/irq/proc.c                               |    1 +
 kernel/mutex-debug.c                            |    1 +
 kernel/time/timekeeping.c                       |    1 +
 lib/debugobjects.c                              |    1 +
 lib/fault-inject.c                              |    1 +
 lib/kernel_lock.c                               |    1 +
 mm/vmalloc.c                                    |    1 +
 net/irda/ircomm/ircomm_tty_attach.c             |    1 +
 net/irda/irlan/irlan_common.c                   |    1 +
 net/irda/irlan/irlan_eth.c                      |    1 +
 net/netfilter/nf_conntrack_core.c               |    1 +
 net/sunrpc/xprtrdma/rpc_rdma.c                  |    1 +
 net/sunrpc/xprtrdma/svc_rdma_transport.c        |    1 +
 net/sunrpc/xprtrdma/transport.c                 |    1 +
 net/sunrpc/xprtrdma/verbs.c                     |    1 +
 142 files changed, 152 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index f1d72b2..d91e9bc 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -31,6 +31,7 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
+#include <asm/signal.h>
 #include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/irq_regs.h>
diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index f5420f9..f1b60a4 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -12,7 +12,7 @@
  * GNU General Public License for more details.
  *
  */
-
+#include <linux/completion.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <mach/dma.h>
diff --git a/arch/arm/plat-mxc/dma-mx1-mx2.c b/arch/arm/plat-mxc/dma-mx1-mx2.c
index b296f19..b8a106f 100644
--- a/arch/arm/plat-mxc/dma-mx1-mx2.c
+++ b/arch/arm/plat-mxc/dma-mx1-mx2.c
@@ -29,6 +29,7 @@
 #include <linux/errno.h>
 #include <linux/clk.h>
 #include <linux/scatterlist.h>
+#include <linux/timer.h>
 #include <linux/io.h>
 
 #include <asm/system.h>
diff --git a/arch/arm/plat-omap/include/mach/irda.h b/arch/arm/plat-omap/include/mach/irda.h
index 8372a00..a67fac9 100644
--- a/arch/arm/plat-omap/include/mach/irda.h
+++ b/arch/arm/plat-omap/include/mach/irda.h
@@ -10,6 +10,8 @@
 #ifndef ASMARM_ARCH_IRDA_H
 #define ASMARM_ARCH_IRDA_H
 
+#include <linux/workqueue.h>
+
 /* board specific transceiver capabilities */
 
 #define IR_SEL		1	/* Selects IrDA */
diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index eb23523..1d4cd2c 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/irq.h>
 
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 14a102e..cf8a97f 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -5,6 +5,7 @@
 
 #include "linux/irqreturn.h"
 #include "linux/kd.h"
+#include "linux/sched.h"
 #include "chan_kern.h"
 #include "irq_kern.h"
 #include "irq_user.h"
diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 3d7aad0..104b98d 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -10,6 +10,7 @@
 #include "linux/interrupt.h"
 #include "linux/kernel_stat.h"
 #include "linux/module.h"
+#include "linux/sched.h"
 #include "linux/seq_file.h"
 #include "as-layout.h"
 #include "kern_util.h"
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 77017e8..1d24bdf 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1,6 +1,7 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <linux/sysdev.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 60eb84e..b8035bd 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -10,6 +10,7 @@
 
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/delay.h>
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index e3f75bb..e0cf5b6 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -25,6 +25,7 @@
 #include <linux/bitops.h>
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
+#include <linux/sched.h>
 #include <linux/iommu-helper.h>
 #include <linux/sysdev.h>
 #include <linux/io.h>
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index c9f7cda..a9056dd 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -13,6 +13,7 @@
 #include <linux/clockchips.h>
 #include <linux/kernel_stat.h>
 #include <linux/math64.h>
+#include <linux/sched.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
diff --git a/crypto/aead.c b/crypto/aead.c
index 3a6f3f5..68d2da3 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 05674fe..0b622b3 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index cf2461d..66014ac 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -35,6 +35,7 @@
 #include <linux/ctype.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
diff --git a/drivers/char/generic_serial.c b/drivers/char/generic_serial.c
index c6090f8..4db3b9c 100644
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/tty.h>
+#include <linux/sched.h>
 #include <linux/serial.h>
 #include <linux/mm.h>
 #include <linux/generic_serial.h>
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 44e5d60..02b89aa 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -19,6 +19,7 @@
 /*****************************************************************************/
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 9a34a19..1d546ff 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -44,6 +44,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6d45827..01e519f 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -20,6 +20,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/fcntl.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/major.h>
 #include <linux/mm.h>
diff --git a/drivers/char/rio/riocmd.c b/drivers/char/rio/riocmd.c
index 01f2654..f121357 100644
--- a/drivers/char/rio/riocmd.c
+++ b/drivers/char/rio/riocmd.c
@@ -32,6 +32,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
diff --git a/drivers/char/rio/rioctrl.c b/drivers/char/rio/rioctrl.c
index eecee0f..69d56b9 100644
--- a/drivers/char/rio/rioctrl.c
+++ b/drivers/char/rio/rioctrl.c
@@ -31,6 +31,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <asm/io.h>
diff --git a/drivers/char/rio/riotty.c b/drivers/char/rio/riotty.c
index 2fb49e8..47fab7c 100644
--- a/drivers/char/rio/riotty.c
+++ b/drivers/char/rio/riotty.c
@@ -33,6 +33,7 @@
 #define __EXPLICIT_DEF_H__
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
diff --git a/drivers/char/ser_a2232.c b/drivers/char/ser_a2232.c
index 7b0c352..884209a 100644
--- a/drivers/char/ser_a2232.c
+++ b/drivers/char/ser_a2232.c
@@ -89,6 +89,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/tty.h>
 
 #include <asm/setup.h>
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 963b03f..062f3ed 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -27,6 +27,7 @@
 /*****************************************************************************/
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
diff --git a/drivers/char/tlclk.c b/drivers/char/tlclk.c
index 8f2284b..80ea6bc 100644
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -32,6 +32,7 @@
 #include <linux/kernel.h>	/* printk() */
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 4d22b21..d8ea3a9 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -16,7 +16,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-
+#include <linux/hrtimer.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -32,6 +32,7 @@
 #include <linux/crypto.h>
 #include <linux/hw_random.h>
 #include <linux/ktime.h>
+#include <linux/workqueue.h>
 
 #include <crypto/algapi.h>
 #include <crypto/des.h>
diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index 06cafe1..d788e6b 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -18,6 +18,7 @@
 #ifndef MV_XOR_H
 #define MV_XOR_H
 
+#include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/io.h>
 #include <linux/dmaengine.h>
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 8f9509e..3f7c378 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -40,6 +40,7 @@
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 107f170..e516506 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -36,6 +36,7 @@
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/random.h>
+#include <linux/workqueue.h>
 
 #include <rdma/ib_cache.h>
 #include "sa.h"
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 3e4585c..984d0aa 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/sched.h>
 #include "iwch_provider.h"
 #include "iwch.h"
 #include "iwch_cm.h"
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index ad0aab6..093800c 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
 #include <linux/pci.h>
diff --git a/drivers/infiniband/hw/ipath/ipath_iba7220.c b/drivers/infiniband/hw/ipath/ipath_iba7220.c
index 9839e20..1ecf037 100644
--- a/drivers/infiniband/hw/ipath/ipath_iba7220.c
+++ b/drivers/infiniband/hw/ipath/ipath_iba7220.c
@@ -37,6 +37,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <rdma/ib_verbs.h>
diff --git a/drivers/infiniband/hw/ipath/ipath_intr.c b/drivers/infiniband/hw/ipath/ipath_intr.c
index 6c21b4b..c0a03ac 100644
--- a/drivers/infiniband/hw/ipath/ipath_intr.c
+++ b/drivers/infiniband/hw/ipath/ipath_intr.c
@@ -33,6 +33,7 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 0bd8bcb..3078261 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -44,6 +44,8 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/scatterlist.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
 #include <asm/io.h>
 #include <rdma/ib_verbs.h>
 
diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/infiniband/hw/ipath/ipath_qp.c
index 4715911..b8d12ed 100644
--- a/drivers/infiniband/hw/ipath/ipath_qp.c
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/sched.h>
 #include <linux/vmalloc.h>
 
 #include "ipath_verbs.h"
diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/infiniband/hw/ipath/ipath_ruc.c
index fc0f6d9..ff0095c 100644
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 
 #include "ipath_verbs.h"
diff --git a/drivers/infiniband/hw/ipath/ipath_ud.c b/drivers/infiniband/hw/ipath/ipath_ud.c
index 729446f..d02918a 100644
--- a/drivers/infiniband/hw/ipath/ipath_ud.c
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#include <linux/sched.h>
 #include <rdma/ib_smi.h>
 
 #include "ipath_verbs.h"
diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/infiniband/hw/ipath/ipath_user_pages.c
index 0190edc..490f602 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -33,6 +33,7 @@
 
 #include <linux/mm.h>
 #include <linux/device.h>
+#include <linux/sched.h>
 
 #include "ipath_kernel.h"
 
diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
index 82d9a0b..c63771d 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -33,6 +33,7 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/dmapool.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c b/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
index d73e322..451a3d5 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
@@ -30,7 +30,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
-
+#include <linux/sched.h>
 #include <linux/rculist.h>
 
 #include "ipath_verbs.h"
diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
index aacf71f..5364d41 100644
--- a/drivers/input/keyboard/hilkbd.c
+++ b/drivers/input/keyboard/hilkbd.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/hil.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <asm/irq.h>
 #ifdef CONFIG_HP300
diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
index 9fce6d1..dd7b5a9 100644
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
diff --git a/drivers/input/serio/libps2.c b/drivers/input/serio/libps2.c
index 2b304c2..f843a40 100644
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -13,6 +13,7 @@
 
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index b9694b6..6d34511 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -15,6 +15,7 @@
 
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index b9b7fc6..080a50d 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -17,6 +17,7 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation.
  */
+#include <linux/hrtimer.h>
 #include <linux/hwmon.h>
 #include <linux/init.h>
 #include <linux/err.h>
diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 5360c4f..2812f4b 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
diff --git a/drivers/isdn/hisax/arcofi.c b/drivers/isdn/hisax/arcofi.c
index d30ce5b..6fa2425 100644
--- a/drivers/isdn/hisax/arcofi.c
+++ b/drivers/isdn/hisax/arcofi.c
@@ -9,7 +9,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  *
  */
- 
+#include <linux/sched.h> 
 #include "hisax.h"
 #include "isdnl1.h"
 #include "isac.h"
diff --git a/drivers/isdn/hisax/hfc4s8s_l1.c b/drivers/isdn/hisax/hfc4s8s_l1.c
index ab98e13..883ad4c 100644
--- a/drivers/isdn/hisax/hfc4s8s_l1.c
+++ b/drivers/isdn/hisax/hfc4s8s_l1.c
@@ -28,6 +28,7 @@
 #include <linux/timer.h>
 #include <linux/skbuff.h>
 #include <linux/wait.h>
+#include <linux/workqueue.h>
 #include <asm/io.h>
 #include "hisax_if.h"
 #include "hfc4s8s_l1.h"
diff --git a/drivers/isdn/hisax/hfc_2bds0.c b/drivers/isdn/hisax/hfc_2bds0.c
index 5c46a71..02648f5 100644
--- a/drivers/isdn/hisax/hfc_2bds0.c
+++ b/drivers/isdn/hisax/hfc_2bds0.c
@@ -15,6 +15,7 @@
 #include "hfc_2bds0.h"
 #include "isdnl1.h"
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 /*
 #define KDEBUG_DEF
 #include "kdebug.h"
diff --git a/drivers/isdn/hisax/hfc_pci.c b/drivers/isdn/hisax/hfc_pci.c
index f126566..e03bfc1 100644
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -20,6 +20,7 @@
 #include "hfc_pci.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 
 static const char *hfcpci_revision = "$Revision: 1.48.2.4 $";
diff --git a/drivers/isdn/pcbit/drv.c b/drivers/isdn/pcbit/drv.c
index 8c66bcb..123f3a4 100644
--- a/drivers/isdn/pcbit/drv.c
+++ b/drivers/isdn/pcbit/drv.c
@@ -18,7 +18,7 @@
  */
 
 #include <linux/module.h>
-
+#include <linux/sched.h>
 
 #include <linux/kernel.h>
 
diff --git a/drivers/isdn/pcbit/layer2.c b/drivers/isdn/pcbit/layer2.c
index 5ba2a87..54f1efe 100644
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -23,7 +23,7 @@
  *        TODO: better handling of errors
  *              re-write/remove debug printks
  */
-
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index dd0acd0..5a07748 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include "includes.h"
 #include "hardware.h"
 #include "card.h"
diff --git a/drivers/lguest/interrupts_and_traps.c b/drivers/lguest/interrupts_and_traps.c
index a103906..638263e 100644
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -14,6 +14,7 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include "lg.h"
 
 /* Allow Guests to use a non-128 (ie. non-Linux) syscall trap. */
diff --git a/drivers/message/fusion/mptlan.c b/drivers/message/fusion/mptlan.c
index a1abf95..675821b 100644
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -56,6 +56,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
 
 #define my_VERSION	MPT_LINUX_VERSION_COMMON
 #define MYNAM		"mptlan"
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index a316f1b..c494dc1 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/errno.h>
diff --git a/drivers/misc/ibmasm/command.c b/drivers/misc/ibmasm/command.c
index 276d3fb..0847658 100644
--- a/drivers/misc/ibmasm/command.c
+++ b/drivers/misc/ibmasm/command.c
@@ -21,7 +21,7 @@
  * Author: Max Asböck <amax@us.ibm.com>
  *
  */
-
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "lowlevel.h"
 
diff --git a/drivers/misc/ibmasm/event.c b/drivers/misc/ibmasm/event.c
index fda6a4d..3e93308 100644
--- a/drivers/misc/ibmasm/event.c
+++ b/drivers/misc/ibmasm/event.c
@@ -21,7 +21,7 @@
  * Author: Max Asböck <amax@us.ibm.com>
  *
  */
-
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "lowlevel.h"
 
diff --git a/drivers/misc/ibmasm/r_heartbeat.c b/drivers/misc/ibmasm/r_heartbeat.c
index bec9e2c..6f5a260 100644
--- a/drivers/misc/ibmasm/r_heartbeat.c
+++ b/drivers/misc/ibmasm/r_heartbeat.c
@@ -19,7 +19,7 @@
  * Author: Max Asböck <amax@us.ibm.com>
  *
  */
-
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "dot_command.h"
 
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 5c027b6..e6c0dee 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/smp_lock.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index 8387e05..8f1276b 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/onenand.h>
 #include <linux/mtd/partitions.h>
diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index c54967f..aa25289 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -68,7 +68,7 @@ Revision History:
 
 */
 
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/drivers/net/chelsio/cxgb2.c b/drivers/net/chelsio/cxgb2.c
index 638c9a2..a6e9963 100644
--- a/drivers/net/chelsio/cxgb2.c
+++ b/drivers/net/chelsio/cxgb2.c
@@ -37,6 +37,7 @@
  ****************************************************************************/
 
 #include "common.h"
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index ace39ec..6103d75 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -237,6 +237,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 3d69fae..7927477 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -149,6 +149,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/init.h>
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 523b971..f733527 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -52,6 +52,7 @@
 #include <linux/ethtool.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 
 #include "e1000.h"
 
diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index 18f1364..26e914f 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -110,7 +110,7 @@
  *
  * Sorry, I had to rewrite most of this for 2.5.x -DaveM
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/net/ewrk3.c b/drivers/net/ewrk3.c
index 593a120..7d5e3f9 100644
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -145,6 +145,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index 3199526..f655090 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -145,6 +145,7 @@ static int tx_params[MAX_UNITS] = {-1, -1, -1, -1, -1, -1, -1, -1};
 /* Time in jiffies before concluding the transmitter is hung. */
 #define TX_TIMEOUT  (5*HZ)
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 00bc7fb..2d3969c 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -44,6 +44,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/workqueue.h>
 #include <linux/fs.h>
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index b6a816e..eb9dba1 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -71,6 +71,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/string.h>
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
index 3bcc57a..5a24cd4 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -61,6 +61,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/string.h>
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index c258a05..6e497e7 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -42,6 +42,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/net.h>
diff --git a/drivers/net/hp100.c b/drivers/net/hp100.c
index 571dd80..fd5af93 100644
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -106,6 +106,7 @@
 #include <linux/eisa.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/igb/igb_ethtool.c b/drivers/net/igb/igb_ethtool.c
index 58906c9..46c138f 100644
--- a/drivers/net/igb/igb_ethtool.c
+++ b/drivers/net/igb/igb_ethtool.c
@@ -32,6 +32,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/if_ether.h>
 #include <linux/ethtool.h>
 
diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 3f32909..5b65624 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 #include <net/irda/wrapper.h>
diff --git a/drivers/net/irda/toim3232-sir.c b/drivers/net/irda/toim3232-sir.c
index fcf287b..99e1ec0 100644
--- a/drivers/net/irda/toim3232-sir.c
+++ b/drivers/net/irda/toim3232-sir.c
@@ -120,6 +120,7 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 
diff --git a/drivers/net/mii.c b/drivers/net/mii.c
index 9205605..8dec7ed 100644
--- a/drivers/net/mii.c
+++ b/drivers/net/mii.c
@@ -26,7 +26,7 @@
 
 
  */
-
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ns83820.c b/drivers/net/ns83820.c
index ff44961..0a0e1d6 100644
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -100,6 +100,7 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/net/pcnet32.c b/drivers/net/pcnet32.c
index ca8c0e0..75ddc8b 100644
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -34,6 +34,7 @@ static const char *const version =
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index df4e625..e9f09ad 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -15,6 +15,7 @@
  * option) any later version.
  *
  */
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/errno.h>
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index 5986cec..fc2c3a1 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -41,6 +41,7 @@ static char version[] = "sb1000.c:v1.1.2 6/01/98 (fventuri@mediaone.net)\n";
 #include <linux/errno.h>
 #include <linux/if_cablemodem.h> /* for SIOGCM/SIOSCM stuff */
 #include <linux/in.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index fa3a460..4207755 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -56,6 +56,7 @@
 #include <linux/timer.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
diff --git a/drivers/net/skfp/skfddi.c b/drivers/net/skfp/skfddi.c
index a2b092b..add7fd1 100644
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -73,6 +73,7 @@ static const char * const boot_msg =
 
 /* Include files */
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/net/skge.c b/drivers/net/skge.c
index 43f4c73..21322b4 100644
--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -37,6 +37,7 @@
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
 #include <linux/debugfs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/mii.h>
 #include <asm/irq.h>
diff --git a/drivers/net/slip.c b/drivers/net/slip.c
index 1d58991..1ae9130 100644
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -75,6 +75,7 @@
 #include <linux/errno.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_arp.h>
diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index 4291458..0dd3c39 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index c41d687..8348717 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -165,6 +165,7 @@
  *	                       Thanks to Gunnar Eikman
  *******************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
diff --git a/drivers/net/tokenring/ibmtr.c b/drivers/net/tokenring/ibmtr.c
index e494c63..571d7d2 100644
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -108,6 +108,7 @@ in the event that chatty debug messages are desired - jjs 12/30/98 */
 #define IBMTR_DEBUG_MESSAGES 0
 
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #ifdef PCMCIA		/* required for ibmtr_cs.c to build */
 #undef MODULE		/* yes, really */
diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index cafa89e..a2c6f28 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -21,7 +21,7 @@
 #endif
 #define DRV_RELDATE	"Feb 27, 2007"
 
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "tulip.h"
diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 734ce09..3a74bc5 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -111,6 +111,7 @@ static const int multicast_filter_limit = 32;
 #include <linux/timer.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
diff --git a/drivers/net/wan/cycx_x25.c b/drivers/net/wan/cycx_x25.c
index 5a7303d..53d708a 100644
--- a/drivers/net/wan/cycx_x25.c
+++ b/drivers/net/wan/cycx_x25.c
@@ -83,6 +83,7 @@
 #include <linux/if_arp.h>       /* ARPHRD_HWX25 */
 #include <linux/kernel.h>	/* printk(), and other useful stuff */
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/string.h>	/* inline memset(), etc. */
 #include <linux/slab.h>		/* kmalloc(), kfree() */
 #include <linux/stddef.h>	/* offsetof(), etc. */
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index 5f1ccb2..090d2f2 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -86,6 +86,7 @@
 #include <linux/list.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 9557ad0..4dc842b 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/version.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/if.h>
diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index b595b64..68c91f0 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -13,7 +13,7 @@
  *    Hitachi HD64572 SCA-II User's Manual
  *    PLX Technology Inc. PCI9052 Data Book
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/drivers/net/wan/syncppp.c b/drivers/net/wan/syncppp.c
index 327d585..6104534 100644
--- a/drivers/net/wan/syncppp.c
+++ b/drivers/net/wan/syncppp.c
@@ -37,6 +37,7 @@
  */
 #undef DEBUG
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 14c44df..1198009 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -36,6 +36,7 @@
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 4015912..1f9a3e0 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -30,7 +30,7 @@
 #include "xmit.h"
 
 #include <linux/delay.h>
-
+#include <linux/sched.h>
 
 static void b43_pio_rx_work(struct work_struct *work);
 
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index c66d575..677db04 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -37,6 +37,7 @@
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
 #include <net/dst.h>
diff --git a/drivers/net/wireless/b43legacy/phy.c b/drivers/net/wireless/b43legacy/phy.c
index 4c9442b..635dd9e 100644
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -31,6 +31,7 @@
 
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 
 #include "b43legacy.h"
diff --git a/drivers/net/wireless/hostap/hostap_info.c b/drivers/net/wireless/hostap/hostap_info.c
index 7cd3fb7..f80cb21 100644
--- a/drivers/net/wireless/hostap/hostap_info.c
+++ b/drivers/net/wireless/hostap/hostap_info.c
@@ -1,5 +1,5 @@
 /* Host AP driver Info Frame processing (part of hostap.o module) */
-
+#include <linux/sched.h>
 #include "hostap_wlan.h"
 #include "hostap.h"
 #include "hostap_ap.h"
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 3f8b1d7..9d751b3 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -2,6 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/ethtool.h>
+#include <linux/sched.h>
 #include <net/ieee80211_crypt.h>
 
 #include "hostap_wlan.h"
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..88dc01c 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -30,6 +30,7 @@
 
 ******************************************************************************/
 
+#include <linux/sched.h>
 #include "ipw2200.h"
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7ca5627..fb611bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9838de5..6d485e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5155b8a..5f0d370 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 24a1aeb..42ab7a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 8300f3d..3bc8480 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -28,6 +28,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h" /* FIXME: remove */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 907a53e..c044b97 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -27,6 +27,7 @@
  *
  *****************************************************************************/
 
+#include <linux/sched.h>
 #include <linux/etherdevice.h>
 #include <net/mac80211.h>
 #include "iwl-eeprom.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d15a2c9..139348f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 297696d..d28426e 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -2,7 +2,7 @@
   * This file contains the handling of command.
   * It prepares command and sends it to firmware when it is ready.
   */
-
+#include <linux/sched.h>
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
 #include <linux/kfifo.h>
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index a4972fe..15df84e 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -1,6 +1,7 @@
 /**
   * This file contains the handling of TX in wlan driver.
   */
+#include <linux/sched.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index e0512e4..b9a4911 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -76,6 +76,7 @@
 
 #define DRIVER_NAME "orinoco"
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index 16e68f4..64f62ea 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 9196825..9032937 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -19,7 +19,7 @@
  */
 
 #include <linux/module.h>
-
+#include <linux/sched.h>
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
 #include <linux/pci.h>
diff --git a/drivers/net/wireless/prism54/islpci_mgt.c b/drivers/net/wireless/prism54/islpci_mgt.c
index f7c677e..69d2f88 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/prism54/islpci_mgt.c
@@ -20,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index 57e1f49..74b6482 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -84,6 +84,7 @@ static int gx_fix;
 
 #define yellowfin_debug debug
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index e390707..d35bed5 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/omap2_mcspi.c
index 454a271..cfa4fce 100644
--- a/drivers/spi/omap2_mcspi.c
+++ b/drivers/spi/omap2_mcspi.c
@@ -32,6 +32,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/workqueue.h>
 
 #include <linux/spi/spi.h>
 
diff --git a/drivers/spi/orion_spi.c b/drivers/spi/orion_spi.c
index 014becb..85c095b 100644
--- a/drivers/spi/orion_spi.c
+++ b/drivers/spi/orion_spi.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/orion_spi.h>
 #include <asm/unaligned.h>
diff --git a/drivers/usb/gadget/m66592-udc.h b/drivers/usb/gadget/m66592-udc.h
index f118f00..f2f9f98 100644
--- a/drivers/usb/gadget/m66592-udc.h
+++ b/drivers/usb/gadget/m66592-udc.h
@@ -23,6 +23,8 @@
 #ifndef __M66592_UDC_H__
 #define __M66592_UDC_H__
 
+#include <linux/timer.h>
+
 #define M66592_SYSCFG		0x00
 #define M66592_XTAL		0xC000	/* b15-14: Crystal selection */
 #define   M66592_XTAL48		 0x8000		/* 48MHz */
diff --git a/drivers/uwb/whc-rc.c b/drivers/uwb/whc-rc.c
index 1711dea..d98df4c 100644
--- a/drivers/uwb/whc-rc.c
+++ b/drivers/uwb/whc-rc.c
@@ -43,6 +43,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
diff --git a/fs/file.c b/fs/file.c
index f313314..87e1290 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/time.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/file.h>
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f58a0cf..96a6660 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -2,22 +2,23 @@
 #ifndef _LINUX_INTERRUPT_H
 #define _LINUX_INTERRUPT_H
 
-#include <linux/kernel.h>
-#include <linux/linkage.h>
 #include <linux/bitops.h>
-#include <linux/preempt.h>
+#include <linux/compiler.h>
 #include <linux/cpumask.h>
+#include <linux/errno.h>
 #include <linux/irqreturn.h>
 #include <linux/irqnr.h>
 #include <linux/hardirq.h>
-#include <linux/sched.h>
 #include <linux/irqflags.h>
-#include <linux/smp.h>
 #include <linux/percpu.h>
 #include <asm/atomic.h>
-#include <asm/ptrace.h>
 #include <asm/system.h>
 
+struct call_single_data;
+struct device;
+struct proc_dir_entry;
+struct seq_file;
+
 /*
  * These correspond to the IORESOURCE_IRQ_* defines in
  * linux/ioport.h to select the interrupt line behaviour.  When
@@ -76,8 +77,6 @@ extern int __must_check request_irq(unsigned int, irq_handler_t handler,
 		       unsigned long, const char *, void *);
 extern void free_irq(unsigned int, void *);
 
-struct device;
-
 extern int __must_check devm_request_irq(struct device *dev, unsigned int irq,
 			    irq_handler_t handler, unsigned long irqflags,
 			    const char *devname, void *dev_id);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index bde891f..98884e4 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -11,7 +11,7 @@
 #define LINUX_MMC_HOST_H
 
 #include <linux/leds.h>
-
+#include <linux/sched.h>
 #include <linux/mmc/core.h>
 
 struct mmc_ios {
diff --git a/include/linux/serio.h b/include/linux/serio.h
index 25641d9..57a1128 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -17,6 +17,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/list.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 6052f02..835f2d8 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -2,7 +2,7 @@
 #define __LINUX_SMPLOCK_H
 
 #ifdef CONFIG_LOCK_KERNEL
-#include <linux/sched.h>
+#include <linux/spinlock.h>
 
 #define kernel_locked()		(current->lock_depth >= 0)
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 2b465df..26e395a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -37,6 +37,7 @@
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
 #include <linux/notifier.h>
+#include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index fac014a..5f5e8f6 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/jiffies.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index 1d94160..56612da 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/poison.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e7acfb4..9f221ba 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -13,6 +13,7 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/sysdev.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index e3ab374..c4a1691 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -9,6 +9,7 @@
  */
 #include <linux/debugobjects.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/hash.h>
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index a50a311..605cb0a 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/types.h>
 #include <linux/fs.h>
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 01a3c22..208e439 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -5,6 +5,7 @@
  * relegated to obsolescence, but used by various less
  * important (or lazy) subsystems.
  */
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0365369..a13364f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/highmem.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
diff --git a/net/irda/ircomm/ircomm_tty_attach.c b/net/irda/ircomm/ircomm_tty_attach.c
index 9032a1d..144e2c7 100644
--- a/net/irda/ircomm/ircomm_tty_attach.c
+++ b/net/irda/ircomm/ircomm_tty_attach.c
@@ -30,6 +30,7 @@
  ********************************************************************/
 
 #include <linux/init.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 #include <net/irda/irlmp.h>
diff --git a/net/irda/irlan/irlan_common.c b/net/irda/irlan/irlan_common.c
index 9a1cd87..9456929 100644
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/errno.h>
diff --git a/net/irda/irlan/irlan_eth.c b/net/irda/irlan/irlan_eth.c
index 05112be..0c554c3 100644
--- a/net/irda/irlan/irlan_eth.c
+++ b/net/irda/irlan/irlan_eth.c
@@ -30,6 +30,7 @@
 #include <linux/inetdevice.h>
 #include <linux/if_arp.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <net/arp.h>
 
 #include <net/irda/irda.h>
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 622d7c6..62870e3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -18,6 +18,7 @@
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/stddef.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 14106d2..f3b3ac2 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -48,6 +48,7 @@
 #include "xprt_rdma.h"
 
 #include <linux/highmem.h>
+#include <linux/sched.h>
 
 #ifdef RPC_DEBUG
 # define RPCDBG_FACILITY	RPCDBG_TRANS
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 6fb493c..cea2a9c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -42,6 +42,7 @@
 #include <linux/sunrpc/svc_xprt.h>
 #include <linux/sunrpc/debug.h>
 #include <linux/sunrpc/rpc_rdma.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 9839c3d..dfef836 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -49,6 +49,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 
 #include "xprt_rdma.h"
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index a5fef5e..cc422f1 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -48,6 +48,7 @@
  */
 
 #include <linux/pci.h>	/* for Tavor hack below */
+#include <linux/sched.h>
 
 #include "xprt_rdma.h"
 
-- 
1.5.6.5

