Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab0BRCxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:53:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:33739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab0BRCxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:53:31 -0500
Message-ID: <4B7CAAEC.1000608@kernel.org>
Date: Wed, 17 Feb 2010 18:50:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [RFC PATCH 3/3] genericirq: change ack/mask in irq_chip to take irq_desc
 in addition to irq
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org> <m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org>
In-Reply-To: <4B7CA9A1.3020806@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



will have
void            (*ack)(unsigned int irq, struct irq_desc *desc);
void            (*mask)(unsigned int irq, struct irq_desc *desc);
void            (*mask_ack)(unsigned int irq, struct irq_desc *desc);
void            (*unmask)(unsigned int irq, struct irq_desc *desc);
void            (*eoi)(unsigned int irq, struct irq_desc *desc);

so for sparseirq with raidix tree, we don't call extra irq_to_desc, and could use desc directly

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
---
 Documentation/DocBook/genericirq.tmpl            |   12 +++---
 arch/alpha/kernel/irq_alpha.c                    |    3 +
 arch/alpha/kernel/irq_i8259.c                    |    7 +++
 arch/alpha/kernel/irq_pyxis.c                    |    2 -
 arch/alpha/kernel/irq_srm.c                      |    8 +++-
 arch/alpha/kernel/sys_alcor.c                    |    2 -
 arch/alpha/kernel/sys_cabriolet.c                |    8 +++-
 arch/alpha/kernel/sys_dp264.c                    |   16 +++++++-
 arch/alpha/kernel/sys_eb64p.c                    |    8 +++-
 arch/alpha/kernel/sys_eiger.c                    |    8 +++-
 arch/alpha/kernel/sys_jensen.c                   |    2 -
 arch/alpha/kernel/sys_marvel.c                   |   18 +++++++---
 arch/alpha/kernel/sys_mikasa.c                   |    8 +++-
 arch/alpha/kernel/sys_noritake.c                 |    8 +++-
 arch/alpha/kernel/sys_rawhide.c                  |    2 -
 arch/alpha/kernel/sys_rx164.c                    |    8 +++-
 arch/alpha/kernel/sys_sable.c                    |    2 -
 arch/alpha/kernel/sys_takara.c                   |    8 +++-
 arch/alpha/kernel/sys_titan.c                    |    8 +++-
 arch/alpha/kernel/sys_wildfire.c                 |    2 -
 arch/arm/common/gic.c                            |   10 ++---
 arch/arm/common/it8152.c                         |    4 +-
 arch/arm/common/locomo.c                         |   32 ++++++++---------
 arch/arm/common/sa1111.c                         |   14 +++----
 arch/arm/common/vic.c                            |    6 +--
 arch/arm/kernel/ecard.c                          |   10 ++---
 arch/arm/mach-aaec2000/core.c                    |    6 +--
 arch/arm/mach-at91/gpio.c                        |    8 ++--
 arch/arm/mach-at91/irq.c                         |    4 +-
 arch/arm/mach-bcmring/irq.c                      |   12 +++---
 arch/arm/mach-clps711x/irq.c                     |   12 +++---
 arch/arm/mach-davinci/cp_intc.c                  |    6 +--
 arch/arm/mach-davinci/gpio.c                     |    6 +--
 arch/arm/mach-davinci/irq.c                      |    6 +--
 arch/arm/mach-dove/irq.c                         |    6 +--
 arch/arm/mach-ebsa110/core.c                     |    4 +-
 arch/arm/mach-ep93xx/core.c                      |    8 ++--
 arch/arm/mach-footbridge/common.c                |    4 +-
 arch/arm/mach-footbridge/isa-irq.c               |   12 +++---
 arch/arm/mach-gemini/gpio.c                      |    6 +--
 arch/arm/mach-gemini/irq.c                       |    6 +--
 arch/arm/mach-h720x/common.c                     |   10 ++---
 arch/arm/mach-h720x/cpu-h7202.c                  |    4 +-
 arch/arm/mach-integrator/integrator_ap.c         |    4 +-
 arch/arm/mach-integrator/integrator_cp.c         |   12 +++---
 arch/arm/mach-iop13xx/irq.c                      |   16 ++++----
 arch/arm/mach-iop13xx/msi.c                      |    2 -
 arch/arm/mach-iop32x/irq.c                       |    4 +-
 arch/arm/mach-ixp2000/core.c                     |   18 +++++-----
 arch/arm/mach-ixp2000/ixdp2x00.c                 |    8 ++--
 arch/arm/mach-ixp2000/ixdp2x01.c                 |    8 ++--
 arch/arm/mach-ixp23xx/core.c                     |   16 ++++----
 arch/arm/mach-ixp23xx/ixdp2351.c                 |   16 ++++----
 arch/arm/mach-ixp4xx/common.c                    |    6 +--
 arch/arm/mach-ks8695/irq.c                       |    6 +--
 arch/arm/mach-l7200/core.c                       |    4 +-
 arch/arm/mach-lh7a40x/arch-kev7a400.c            |    6 +--
 arch/arm/mach-lh7a40x/arch-lpd7a40x.c            |   10 ++---
 arch/arm/mach-lh7a40x/irq-lh7a400.c              |    6 +--
 arch/arm/mach-lh7a40x/irq-lh7a404.c              |   12 +++---
 arch/arm/mach-lh7a40x/irq-lpd7a40x.c             |   10 ++---
 arch/arm/mach-mmp/irq.c                          |    4 +-
 arch/arm/mach-mx3/mx31ads.c                      |    6 +--
 arch/arm/mach-mx3/mx31pdk.c                      |    6 +--
 arch/arm/mach-netx/generic.c                     |    6 +--
 arch/arm/mach-nomadik/gpio.c                     |    6 +--
 arch/arm/mach-ns9xxx/board-a9m9750dev.c          |   12 +++---
 arch/arm/mach-ns9xxx/irq.c                       |   12 +++---
 arch/arm/mach-omap1/fpga.c                       |    8 ++--
 arch/arm/mach-omap1/irq.c                        |   12 +++---
 arch/arm/mach-pnx4008/irq.c                      |    6 +--
 arch/arm/mach-pxa/balloon3.c                     |    6 +--
 arch/arm/mach-pxa/irq.c                          |   10 ++---
 arch/arm/mach-pxa/lpd270.c                       |    4 +-
 arch/arm/mach-pxa/lubbock.c                      |    4 +-
 arch/arm/mach-pxa/mainstone.c                    |    4 +-
 arch/arm/mach-pxa/pcm990-baseboard.c             |    4 +-
 arch/arm/mach-pxa/pxa3xx.c                       |    6 +--
 arch/arm/mach-pxa/viper.c                        |    6 +--
 arch/arm/mach-pxa/zeus.c                         |    8 ++--
 arch/arm/mach-rpc/irq.c                          |   18 +++++-----
 arch/arm/mach-s3c2410/bast-irq.c                 |   12 ++----
 arch/arm/mach-s3c2412/irq.c                      |   14 +++----
 arch/arm/mach-s3c2440/irq.c                      |    6 +--
 arch/arm/mach-s3c2443/irq.c                      |   30 ++++++++--------
 arch/arm/mach-sa1100/irq.c                       |   16 ++++----
 arch/arm/mach-sa1100/neponset.c                  |    8 ++--
 arch/arm/mach-shark/irq.c                        |    8 ++--
 arch/arm/mach-stmp378x/stmp378x.c                |    6 +--
 arch/arm/mach-stmp37xx/stmp37xx.c                |    6 +--
 arch/arm/mach-versatile/core.c                   |    4 +-
 arch/arm/mach-w90x900/irq.c                      |    6 +--
 arch/arm/plat-mxc/gpio.c                         |    6 +--
 arch/arm/plat-mxc/irq.c                          |    4 +-
 arch/arm/plat-omap/gpio.c                        |   18 +++++-----
 arch/arm/plat-orion/gpio.c                       |    6 +--
 arch/arm/plat-orion/irq.c                        |    4 +-
 arch/arm/plat-pxa/gpio.c                         |    6 +--
 arch/arm/plat-s3c24xx/irq.c                      |   38 ++++++++++-----------
 arch/arm/plat-s3c24xx/s3c244x-irq.c              |    6 +--
 arch/arm/plat-s3c64xx/irq-eint.c                 |   12 +++---
 arch/arm/plat-s3c64xx/irq.c                      |   14 +++----
 arch/arm/plat-s5pc1xx/irq-eint.c                 |   24 ++++++-------
 arch/arm/plat-s5pc1xx/irq-gpio.c                 |   12 +++---
 arch/arm/plat-s5pc1xx/irq.c                      |   14 +++----
 arch/arm/plat-stmp3xxx/irq.c                     |    2 -
 arch/arm/plat-stmp3xxx/pinmux.c                  |    6 +--
 arch/avr32/mach-at32ap/extint.c                  |    8 ++--
 arch/avr32/mach-at32ap/pio.c                     |    4 +-
 arch/blackfin/include/asm/ipipe.h                |    4 +-
 arch/blackfin/mach-common/ints-priority.c        |   41 ++++++++++++++++-------
 arch/cris/arch-v10/kernel/irq.c                  |    2 -
 arch/frv/kernel/irq-mb93091.c                    |    8 ++--
 arch/frv/kernel/irq-mb93093.c                    |    8 ++--
 arch/frv/kernel/irq-mb93493.c                    |    6 +--
 arch/frv/kernel/irq.c                            |    8 ++--
 arch/ia64/hp/sim/hpsim_irq.c                     |    6 ++-
 arch/ia64/kernel/iosapic.c                       |   27 +++++++++++----
 arch/ia64/kernel/irq_lsapic.c                    |    7 +++
 arch/ia64/kernel/msi_ia64.c                      |    2 -
 arch/ia64/sn/kernel/irq.c                        |    6 +--
 arch/ia64/sn/kernel/msi_sn.c                     |    2 -
 arch/m32r/platforms/m32104ut/setup.c             |    2 -
 arch/m32r/platforms/m32700ut/setup.c             |    2 -
 arch/m32r/platforms/mappi/setup.c                |    2 -
 arch/m32r/platforms/mappi2/setup.c               |    2 -
 arch/m32r/platforms/mappi3/setup.c               |    2 -
 arch/m32r/platforms/oaks32r/setup.c              |    2 -
 arch/m32r/platforms/opsput/setup.c               |    8 ++--
 arch/m32r/platforms/usrv/setup.c                 |    4 +-
 arch/m68knommu/platform/5249/intc2.c             |    6 +--
 arch/m68knommu/platform/5272/intc.c              |    6 +--
 arch/m68knommu/platform/68328/ints.c             |    4 +-
 arch/m68knommu/platform/68360/ints.c             |    6 +--
 arch/m68knommu/platform/coldfire/intc-2.c        |    4 +-
 arch/m68knommu/platform/coldfire/intc-simr.c     |    4 +-
 arch/m68knommu/platform/coldfire/intc.c          |    4 +-
 arch/microblaze/kernel/intc.c                    |    8 ++--
 arch/mips/alchemy/common/irq.c                   |   16 ++++----
 arch/mips/alchemy/devboards/pb1200/irqmap.c      |    6 +--
 arch/mips/ar7/irq.c                              |   12 +++---
 arch/mips/bcm63xx/irq.c                          |   17 ++++++---
 arch/mips/cavium-octeon/octeon-irq.c             |   40 +++++++++++++++-------
 arch/mips/dec/ioasic-irq.c                       |    6 +--
 arch/mips/dec/kn02-irq.c                         |    6 +--
 arch/mips/emma/markeins/irq.c                    |   16 ++++----
 arch/mips/jazz/irq.c                             |    4 +-
 arch/mips/kernel/i8259.c                         |   16 ++++++--
 arch/mips/kernel/irq-gic.c                       |    6 +--
 arch/mips/kernel/irq-gt641xx.c                   |    8 ++--
 arch/mips/kernel/irq-msc01.c                     |    8 ++--
 arch/mips/kernel/irq-rm7000.c                    |    4 +-
 arch/mips/kernel/irq-rm9000.c                    |    4 +-
 arch/mips/kernel/irq_cpu.c                       |    6 +--
 arch/mips/kernel/irq_txx9.c                      |    6 +--
 arch/mips/lasat/interrupt.c                      |    4 +-
 arch/mips/loongson/common/bonito-irq.c           |    4 +-
 arch/mips/nxp/pnx833x/common/interrupts.c        |    4 +-
 arch/mips/nxp/pnx8550/common/int.c               |    4 +-
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c       |    4 +-
 arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c       |    6 +--
 arch/mips/powertv/asic/irq_asic.c                |    4 +-
 arch/mips/rb532/irq.c                            |    6 +--
 arch/mips/sgi-ip22/ip22-int.c                    |   16 ++++----
 arch/mips/sgi-ip27/ip27-irq.c                    |    4 +-
 arch/mips/sgi-ip27/ip27-timer.c                  |    4 +-
 arch/mips/sgi-ip32/ip32-irq.c                    |   22 ++++++------
 arch/mips/sibyte/bcm1480/irq.c                   |   12 +++---
 arch/mips/sibyte/sb1250/irq.c                    |   12 +++---
 arch/mips/sni/a20r.c                             |    4 +-
 arch/mips/sni/pcimt.c                            |    4 +-
 arch/mips/sni/pcit.c                             |    4 +-
 arch/mips/sni/rm200.c                            |   12 +++---
 arch/mips/txx9/generic/irq_tx4939.c              |    4 +-
 arch/mips/txx9/jmr3927/irq.c                     |    4 +-
 arch/mips/txx9/rbtx4927/irq.c                    |    8 ++--
 arch/mips/txx9/rbtx4938/irq.c                    |    8 ++--
 arch/mips/txx9/rbtx4939/irq.c                    |    4 +-
 arch/mips/vr41xx/common/icu.c                    |    8 ++--
 arch/mips/vr41xx/common/irq.c                    |    8 ++--
 arch/mn10300/kernel/irq.c                        |   26 ++++++++++----
 arch/mn10300/kernel/mn10300-serial.c             |    4 +-
 arch/parisc/include/asm/irq.h                    |    4 +-
 arch/parisc/kernel/irq.c                         |    4 +-
 arch/powerpc/include/asm/mpic.h                  |    6 +--
 arch/powerpc/include/asm/qe_ic.h                 |    6 +--
 arch/powerpc/kernel/crash.c                      |    2 -
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    4 +-
 arch/powerpc/platforms/52xx/media5200.c          |   10 ++---
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   10 ++---
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    4 +-
 arch/powerpc/platforms/85xx/ksi8560.c            |    2 -
 arch/powerpc/platforms/85xx/mpc85xx_ads.c        |    2 -
 arch/powerpc/platforms/85xx/mpc85xx_ds.c         |    2 -
 arch/powerpc/platforms/85xx/sbc8560.c            |    2 -
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   12 +++---
 arch/powerpc/platforms/85xx/stx_gp3.c            |    2 -
 arch/powerpc/platforms/85xx/tqm85xx.c            |    2 -
 arch/powerpc/platforms/86xx/gef_pic.c            |    8 ++--
 arch/powerpc/platforms/86xx/pic.c                |    2 -
 arch/powerpc/platforms/8xx/m8xx_setup.c          |    4 +-
 arch/powerpc/platforms/cell/axon_msi.c           |    9 +++--
 arch/powerpc/platforms/cell/beat_interrupt.c     |    4 +-
 arch/powerpc/platforms/cell/interrupt.c          |   12 +++---
 arch/powerpc/platforms/cell/setup.c              |    2 -
 arch/powerpc/platforms/cell/spider-pic.c         |    8 ++--
 arch/powerpc/platforms/chrp/setup.c              |    2 -
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |    8 ++--
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   14 +++----
 arch/powerpc/platforms/iseries/irq.c             |    6 +--
 arch/powerpc/platforms/powermac/pic.c            |   10 ++---
 arch/powerpc/platforms/ps3/interrupt.c           |    6 +--
 arch/powerpc/platforms/pseries/setup.c           |    2 -
 arch/powerpc/platforms/pseries/xics.c            |    8 ++--
 arch/powerpc/sysdev/cpm1.c                       |    6 +--
 arch/powerpc/sysdev/cpm2_pic.c                   |    8 ++--
 arch/powerpc/sysdev/fsl_msi.c                    |   12 +++---
 arch/powerpc/sysdev/i8259.c                      |    6 +--
 arch/powerpc/sysdev/ipic.c                       |    8 ++--
 arch/powerpc/sysdev/mpc8xx_pic.c                 |    8 ++--
 arch/powerpc/sysdev/mpic.c                       |   16 ++++----
 arch/powerpc/sysdev/mpic_pasemi_msi.c            |    4 +-
 arch/powerpc/sysdev/mpic_u3msi.c                 |   19 ++++++----
 arch/powerpc/sysdev/mv64x60_pic.c                |   14 +++----
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |    4 +-
 arch/powerpc/sysdev/tsi108_pci.c                 |   10 ++---
 arch/powerpc/sysdev/uic.c                        |   16 ++++----
 arch/powerpc/sysdev/xilinx_intc.c                |   10 ++---
 arch/score/kernel/irq.c                          |    4 +-
 arch/sh/boards/mach-cayman/irq.c                 |    6 +--
 arch/sh/boards/mach-dreamcast/irq.c              |    6 +--
 arch/sh/boards/mach-landisk/irq.c                |    4 +-
 arch/sh/boards/mach-microdev/irq.c               |   14 +++----
 arch/sh/boards/mach-se/7206/irq.c                |    6 +--
 arch/sh/boards/mach-se/7343/irq.c                |    4 +-
 arch/sh/boards/mach-se/7722/irq.c                |    4 +-
 arch/sh/boards/mach-se/7724/irq.c                |    4 +-
 arch/sh/boards/mach-systemh/irq.c                |   14 +++----
 arch/sh/cchips/hd6446x/hd64461.c                 |    8 ++--
 arch/sh/kernel/cpu/irq/imask.c                   |    4 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c                |   14 +++----
 arch/sparc/kernel/irq_64.c                       |    6 +--
 arch/sparc/kernel/pci_msi.c                      |   13 ++++++-
 arch/um/kernel/irq.c                             |    8 +++-
 arch/x86/include/asm/hpet.h                      |    4 +-
 arch/x86/kernel/apic/io_apic.c                   |   31 ++++++-----------
 arch/x86/kernel/hpet.c                           |    4 +-
 arch/x86/kernel/i8259.c                          |   19 +++++++---
 arch/x86/kernel/irq.c                            |    4 +-
 arch/x86/kernel/uv_irq.c                         |   10 +++--
 arch/x86/kernel/visws_quirks.c                   |    2 -
 arch/x86/kernel/vmiclock_32.c                    |    6 +--
 arch/x86/lguest/boot.c                           |    4 +-
 arch/xtensa/kernel/irq.c                         |   10 ++---
 arch/xtensa/variants/s6000/gpio.c                |   12 +++---
 drivers/dma/ipu/ipu_irq.c                        |    6 +--
 drivers/gpio/langwell_gpio.c                     |    6 +--
 drivers/gpio/pl061.c                             |    8 ++--
 drivers/gpio/timbgpio.c                          |    6 +--
 drivers/gpio/vr41xx_giu.c                        |   16 ++++----
 drivers/mfd/asic3.c                              |   10 ++---
 drivers/mfd/ezx-pcap.c                           |    6 +--
 drivers/mfd/htc-egpio.c                          |    6 +--
 drivers/mfd/t7l66xb.c                            |    4 +-
 drivers/mfd/tc6393xb.c                           |    6 +--
 drivers/mfd/twl4030-irq.c                        |    4 +-
 drivers/mfd/wm831x-irq.c                         |    4 +-
 drivers/misc/sgi-gru/grufile.c                   |    2 -
 drivers/pci/dmar.c                               |    4 +-
 drivers/pci/htirq.c                              |    4 +-
 drivers/pci/msi.c                                |    4 +-
 drivers/vlynq/vlynq.c                            |    8 ++--
 drivers/xen/events.c                             |   18 ++++++++--
 include/linux/dmar.h                             |    4 +-
 include/linux/htirq.h                            |    5 +-
 include/linux/irq.h                              |   18 +++++-----
 include/linux/msi.h                              |    4 +-
 kernel/irq/chip.c                                |   26 +++++++-------
 kernel/irq/handle.c                              |   18 +++++-----
 kernel/irq/manage.c                              |    2 -
 kernel/irq/migration.c                           |   14 ++-----
 281 files changed, 1242 insertions(+), 1042 deletions(-)

Index: linux-2.6/Documentation/DocBook/genericirq.tmpl
===================================================================
--- linux-2.6.orig/Documentation/DocBook/genericirq.tmpl
+++ linux-2.6/Documentation/DocBook/genericirq.tmpl
@@ -235,27 +235,27 @@
 		<programlisting>
 default_enable(irq)
 {
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 default_disable(irq)
 {
 	if (!delay_disable(irq))
-		desc->chip->mask(irq);
+		desc->chip->mask(irq, desc);
 }
 
 default_ack(irq)
 {
-	chip->ack(irq);
+	chip->ack(irq, desc);
 }
 
 default_mask_ack(irq)
 {
 	if (chip->mask_ack) {
-		chip->mask_ack(irq);
+		chip->mask_ack(irq, irq_to_desc(irq));
 	} else {
-		chip->mask(irq);
-		chip->ack(irq);
+		chip->mask(irq, irq_to_desc(irq));
+		chip->ack(irq, irq_to_desc(irq));
 	}
 }
 
Index: linux-2.6/arch/alpha/kernel/irq_alpha.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_alpha.c
+++ linux-2.6/arch/alpha/kernel/irq_alpha.c
@@ -219,6 +219,7 @@ process_mcheck_info(unsigned long vector
  */
 
 static void rtc_enable_disable(unsigned int irq) { }
+static void rtc_enable_disable_desc(unsigned int irq, struct irq_desc *desc) { }
 static unsigned int rtc_startup(unsigned int irq) { return 0; }
 
 struct irqaction timer_irqaction = {
@@ -233,7 +234,7 @@ static struct irq_chip rtc_irq_type = {
 	.shutdown	= rtc_enable_disable,
 	.enable		= rtc_enable_disable,
 	.disable	= rtc_enable_disable,
-	.ack		= rtc_enable_disable,
+	.ack		= rtc_enable_disable_desc,
 	.end		= rtc_enable_disable,
 };
 
Index: linux-2.6/arch/alpha/kernel/irq_i8259.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_i8259.c
+++ linux-2.6/arch/alpha/kernel/irq_i8259.c
@@ -69,6 +69,11 @@ i8259a_mask_and_ack_irq(unsigned int irq
 	spin_unlock(&i8259_irq_lock);
 }
 
+static void i8259a_mask_and_ack_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	i8259a_mask_and_ack_irq(irq);
+}
+
 unsigned int
 i8259a_startup_irq(unsigned int irq)
 {
@@ -89,7 +94,7 @@ struct irq_chip i8259a_irq_type = {
 	.shutdown	= i8259a_disable_irq,
 	.enable		= i8259a_enable_irq,
 	.disable	= i8259a_disable_irq,
-	.ack		= i8259a_mask_and_ack_irq,
+	.ack		= i8259a_mask_and_ack_irq_desc,
 	.end		= i8259a_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/irq_pyxis.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_pyxis.c
+++ linux-2.6/arch/alpha/kernel/irq_pyxis.c
@@ -55,7 +55,7 @@ pyxis_end_irq(unsigned int irq)
 }
 
 static void
-pyxis_mask_and_ack_irq(unsigned int irq)
+pyxis_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long bit = 1UL << (irq - 16);
 	unsigned long mask = cached_irq_mask &= ~bit;
Index: linux-2.6/arch/alpha/kernel/irq_srm.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_srm.c
+++ linux-2.6/arch/alpha/kernel/irq_srm.c
@@ -33,6 +33,12 @@ srm_disable_irq(unsigned int irq)
 	spin_unlock(&srm_irq_lock);
 }
 
+static void
+srm_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	srm_disable_irq(irq);
+}
+
 static unsigned int
 srm_startup_irq(unsigned int irq)
 {
@@ -54,7 +60,7 @@ static struct irq_chip srm_irq_type = {
 	.shutdown	= srm_disable_irq,
 	.enable		= srm_enable_irq,
 	.disable	= srm_disable_irq,
-	.ack		= srm_disable_irq,
+	.ack		= srm_disable_irq_desc,
 	.end		= srm_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_alcor.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_alcor.c
+++ linux-2.6/arch/alpha/kernel/sys_alcor.c
@@ -73,7 +73,7 @@ alcor_startup_irq(unsigned int irq)
 }
 
 static void
-alcor_isa_mask_and_ack_irq(unsigned int irq)
+alcor_isa_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	i8259a_mask_and_ack_irq(irq);
 
Index: linux-2.6/arch/alpha/kernel/sys_cabriolet.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_cabriolet.c
+++ linux-2.6/arch/alpha/kernel/sys_cabriolet.c
@@ -57,6 +57,12 @@ cabriolet_disable_irq(unsigned int irq)
 	cabriolet_update_irq_hw(irq, cached_irq_mask |= 1UL << irq);
 }
 
+static void
+cabriolet_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	cabriolet_disable_irq(irq);
+}
+
 static unsigned int
 cabriolet_startup_irq(unsigned int irq)
 { 
@@ -77,7 +83,7 @@ static struct irq_chip cabriolet_irq_typ
 	.shutdown	= cabriolet_disable_irq,
 	.enable		= cabriolet_enable_irq,
 	.disable	= cabriolet_disable_irq,
-	.ack		= cabriolet_disable_irq,
+	.ack		= cabriolet_disable_irq_desc,
 	.end		= cabriolet_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_dp264.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_dp264.c
+++ linux-2.6/arch/alpha/kernel/sys_dp264.c
@@ -115,6 +115,12 @@ dp264_disable_irq(unsigned int irq)
 	spin_unlock(&dp264_irq_lock);
 }
 
+static void
+dp264_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	dp264_disable_irq(irq);
+}
+
 static unsigned int
 dp264_startup_irq(unsigned int irq)
 { 
@@ -147,6 +153,12 @@ clipper_disable_irq(unsigned int irq)
 	spin_unlock(&dp264_irq_lock);
 }
 
+static void
+clipper_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	clipper_disable_irq(irq);
+}
+
 static unsigned int
 clipper_startup_irq(unsigned int irq)
 { 
@@ -204,7 +216,7 @@ static struct irq_chip dp264_irq_type =
 	.shutdown	= dp264_disable_irq,
 	.enable		= dp264_enable_irq,
 	.disable	= dp264_disable_irq,
-	.ack		= dp264_disable_irq,
+	.ack		= dp264_disable_irq_desc,
 	.end		= dp264_end_irq,
 	.set_affinity	= dp264_set_affinity,
 };
@@ -215,7 +227,7 @@ static struct irq_chip clipper_irq_type
 	.shutdown	= clipper_disable_irq,
 	.enable		= clipper_enable_irq,
 	.disable	= clipper_disable_irq,
-	.ack		= clipper_disable_irq,
+	.ack		= clipper_disable_irq_desc,
 	.end		= clipper_end_irq,
 	.set_affinity	= clipper_set_affinity,
 };
Index: linux-2.6/arch/alpha/kernel/sys_eb64p.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eb64p.c
+++ linux-2.6/arch/alpha/kernel/sys_eb64p.c
@@ -55,6 +55,12 @@ eb64p_disable_irq(unsigned int irq)
 	eb64p_update_irq_hw(irq, cached_irq_mask |= 1 << irq);
 }
 
+static void
+eb64p_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	eb64p_disable_irq(irq);
+}
+
 static unsigned int
 eb64p_startup_irq(unsigned int irq)
 {
@@ -75,7 +81,7 @@ static struct irq_chip eb64p_irq_type =
 	.shutdown	= eb64p_disable_irq,
 	.enable		= eb64p_enable_irq,
 	.disable	= eb64p_disable_irq,
-	.ack		= eb64p_disable_irq,
+	.ack		= eb64p_disable_irq_desc,
 	.end		= eb64p_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_eiger.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eiger.c
+++ linux-2.6/arch/alpha/kernel/sys_eiger.c
@@ -66,6 +66,12 @@ eiger_disable_irq(unsigned int irq)
 	eiger_update_irq_hw(irq, mask);
 }
 
+static void
+eiger_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	eiger_disable_irq(irq);
+}
+
 static unsigned int
 eiger_startup_irq(unsigned int irq)
 {
@@ -86,7 +92,7 @@ static struct irq_chip eiger_irq_type =
 	.shutdown	= eiger_disable_irq,
 	.enable		= eiger_enable_irq,
 	.disable	= eiger_disable_irq,
-	.ack		= eiger_disable_irq,
+	.ack		= eiger_disable_irq_desc,
 	.end		= eiger_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_jensen.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_jensen.c
+++ linux-2.6/arch/alpha/kernel/sys_jensen.c
@@ -103,7 +103,7 @@ jensen_local_disable(unsigned int irq)
 }
 
 static void
-jensen_local_ack(unsigned int irq)
+jensen_local_ack(unsigned int irq, struct irq_desc *desc)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
 	if (irq == 7)
Index: linux-2.6/arch/alpha/kernel/sys_marvel.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_marvel.c
+++ linux-2.6/arch/alpha/kernel/sys_marvel.c
@@ -143,7 +143,12 @@ io7_disable_irq(unsigned int irq)
 	spin_unlock(&io7->irq_lock);
 }
 
-static unsigned int
+static void
+io7_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	io7_disable_irq(irq)
+}
+
 io7_startup_irq(unsigned int irq)
 {
 	io7_enable_irq(irq);
@@ -163,6 +168,11 @@ marvel_irq_noop(unsigned int irq)
 	return; 
 }
 
+static void
+marvel_irq_noop_desc(unsigned int irq, struct irq_desc *desc)
+{
+}
+
 static unsigned int
 marvel_irq_noop_return(unsigned int irq) 
 { 
@@ -175,7 +185,7 @@ static struct irq_chip marvel_legacy_irq
 	.shutdown	= marvel_irq_noop,
 	.enable		= marvel_irq_noop,
 	.disable	= marvel_irq_noop,
-	.ack		= marvel_irq_noop,
+	.ack		= marvel_irq_noop_desc,
 	.end		= marvel_irq_noop,
 };
 
@@ -185,7 +195,7 @@ static struct irq_chip io7_lsi_irq_type
 	.shutdown	= io7_disable_irq,
 	.enable		= io7_enable_irq,
 	.disable	= io7_disable_irq,
-	.ack		= io7_disable_irq,
+	.ack		= io7_disable_irq_desc,
 	.end		= io7_end_irq,
 };
 
@@ -195,7 +205,7 @@ static struct irq_chip io7_msi_irq_type
 	.shutdown	= io7_disable_irq,
 	.enable		= io7_enable_irq,
 	.disable	= io7_disable_irq,
-	.ack		= marvel_irq_noop,
+	.ack		= marvel_irq_noop_desc,
 	.end		= io7_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_mikasa.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_mikasa.c
+++ linux-2.6/arch/alpha/kernel/sys_mikasa.c
@@ -54,6 +54,12 @@ mikasa_disable_irq(unsigned int irq)
 	mikasa_update_irq_hw(cached_irq_mask &= ~(1 << (irq - 16)));
 }
 
+static void
+mikasa_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	mikasa_disable_irq(irq);
+}
+
 static unsigned int
 mikasa_startup_irq(unsigned int irq)
 {
@@ -74,7 +80,7 @@ static struct irq_chip mikasa_irq_type =
 	.shutdown	= mikasa_disable_irq,
 	.enable		= mikasa_enable_irq,
 	.disable	= mikasa_disable_irq,
-	.ack		= mikasa_disable_irq,
+	.ack		= mikasa_disable_irq_desc,
 	.end		= mikasa_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_noritake.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_noritake.c
+++ linux-2.6/arch/alpha/kernel/sys_noritake.c
@@ -59,6 +59,12 @@ noritake_disable_irq(unsigned int irq)
 	noritake_update_irq_hw(irq, cached_irq_mask &= ~(1 << (irq - 16)));
 }
 
+static void
+noritake_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	noritake_disable_irq(irq);
+}
+
 static unsigned int
 noritake_startup_irq(unsigned int irq)
 {
@@ -79,7 +85,7 @@ static struct irq_chip noritake_irq_type
 	.shutdown	= noritake_disable_irq,
 	.enable		= noritake_enable_irq,
 	.disable	= noritake_disable_irq,
-	.ack		= noritake_disable_irq,
+	.ack		= noritake_disable_irq_desc,
 	.end		= noritake_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_rawhide.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rawhide.c
+++ linux-2.6/arch/alpha/kernel/sys_rawhide.c
@@ -96,7 +96,7 @@ rawhide_disable_irq(unsigned int irq)
 }
 
 static void
-rawhide_mask_and_ack_irq(unsigned int irq)
+rawhide_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask, mask1, hose;
 
Index: linux-2.6/arch/alpha/kernel/sys_rx164.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rx164.c
+++ linux-2.6/arch/alpha/kernel/sys_rx164.c
@@ -58,6 +58,12 @@ rx164_disable_irq(unsigned int irq)
 	rx164_update_irq_hw(cached_irq_mask &= ~(1UL << (irq - 16)));
 }
 
+static void
+rx164_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	rx164_disable_irq(irq);
+}
+
 static unsigned int
 rx164_startup_irq(unsigned int irq)
 {
@@ -78,7 +84,7 @@ static struct irq_chip rx164_irq_type =
 	.shutdown	= rx164_disable_irq,
 	.enable		= rx164_enable_irq,
 	.disable	= rx164_disable_irq,
-	.ack		= rx164_disable_irq,
+	.ack		= rx164_disable_irq_desc,
 	.end		= rx164_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_sable.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_sable.c
+++ linux-2.6/arch/alpha/kernel/sys_sable.c
@@ -489,7 +489,7 @@ sable_lynx_end_irq(unsigned int irq)
 }
 
 static void
-sable_lynx_mask_and_ack_irq(unsigned int irq)
+sable_lynx_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long bit, mask;
 
Index: linux-2.6/arch/alpha/kernel/sys_takara.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_takara.c
+++ linux-2.6/arch/alpha/kernel/sys_takara.c
@@ -60,6 +60,12 @@ takara_disable_irq(unsigned int irq)
 	takara_update_irq_hw(irq, mask);
 }
 
+static void
+takara_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	takara_disable_irq(irq);
+}
+
 static unsigned int
 takara_startup_irq(unsigned int irq)
 {
@@ -80,7 +86,7 @@ static struct irq_chip takara_irq_type =
 	.shutdown	= takara_disable_irq,
 	.enable		= takara_enable_irq,
 	.disable	= takara_disable_irq,
-	.ack		= takara_disable_irq,
+	.ack		= takara_disable_irq_desc,
 	.end		= takara_end_irq,
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_titan.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_titan.c
+++ linux-2.6/arch/alpha/kernel/sys_titan.c
@@ -129,6 +129,12 @@ titan_disable_irq(unsigned int irq)
 	spin_unlock(&titan_irq_lock);
 }
 
+static void
+titan_disable_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	titan_disable_irq(irq);
+}
+
 static unsigned int
 titan_startup_irq(unsigned int irq)
 {
@@ -200,7 +206,7 @@ static struct irq_chip titan_irq_type =
        .shutdown       = titan_disable_irq,
        .enable         = titan_enable_irq,
        .disable        = titan_disable_irq,
-       .ack            = titan_disable_irq,
+       .ack            = titan_disable_irq_desc,
        .end            = titan_end_irq,
        .set_affinity   = titan_set_irq_affinity,
 };
Index: linux-2.6/arch/alpha/kernel/sys_wildfire.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_wildfire.c
+++ linux-2.6/arch/alpha/kernel/sys_wildfire.c
@@ -128,7 +128,7 @@ wildfire_disable_irq(unsigned int irq)
 }
 
 static void
-wildfire_mask_and_ack_irq(unsigned int irq)
+wildfire_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	if (irq < 16)
 		i8259a_mask_and_ack_irq(irq);
Index: linux-2.6/arch/arm/common/gic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/gic.c
+++ linux-2.6/arch/arm/common/gic.c
@@ -80,7 +80,7 @@ static inline unsigned int gic_irq(unsig
  * our "acknowledge" routine disable the interrupt, then mark it as
  * complete.
  */
-static void gic_ack_irq(unsigned int irq)
+static void gic_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -90,7 +90,7 @@ static void gic_ack_irq(unsigned int irq
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_mask_irq(unsigned int irq)
+static void gic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -99,7 +99,7 @@ static void gic_mask_irq(unsigned int ir
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(unsigned int irq)
+static void gic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask = 1 << (irq % 32);
 
@@ -135,7 +135,7 @@ static void gic_handle_cascade_irq(unsig
 	unsigned long status;
 
 	/* primary controller ack'ing */
-	chip->ack(irq);
+	chip->ack(irq, desc);
 
 	spin_lock(&irq_controller_lock);
 	status = readl(chip_data->cpu_base + GIC_CPU_INTACK);
@@ -153,7 +153,7 @@ static void gic_handle_cascade_irq(unsig
 
  out:
 	/* primary controller unmasking */
-	chip->unmask(irq);
+	chip->unmask(irq, desc);
 }
 
 static struct irq_chip gic_chip = {
Index: linux-2.6/arch/arm/common/it8152.c
===================================================================
--- linux-2.6.orig/arch/arm/common/it8152.c
+++ linux-2.6/arch/arm/common/it8152.c
@@ -32,7 +32,7 @@
 
 #define MAX_SLOTS		21
 
-static void it8152_mask_irq(unsigned int irq)
+static void it8152_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
        if (irq >= IT8152_LD_IRQ(0)) {
 	       __raw_writel((__raw_readl(IT8152_INTC_LDCNIMR) |
@@ -49,7 +49,7 @@ static void it8152_mask_irq(unsigned int
        }
 }
 
-static void it8152_unmask_irq(unsigned int irq)
+static void it8152_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
        if (irq >= IT8152_LD_IRQ(0)) {
 	       __raw_writel((__raw_readl(IT8152_INTC_LDCNIMR) &
Index: linux-2.6/arch/arm/common/locomo.c
===================================================================
--- linux-2.6.orig/arch/arm/common/locomo.c
+++ linux-2.6/arch/arm/common/locomo.c
@@ -172,7 +172,7 @@ static void locomo_handler(unsigned int
 	void __iomem *mapbase = get_irq_chip_data(irq);
 
 	/* Acknowledge the parent IRQ */
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 
 	/* check why this interrupt was generated */
 	req = locomo_readl(mapbase + LOCOMO_ICR) & 0x0f00;
@@ -189,11 +189,11 @@ static void locomo_handler(unsigned int
 	}
 }
 
-static void locomo_ack_irq(unsigned int irq)
+static void locomo_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
-static void locomo_mask_irq(unsigned int irq)
+static void locomo_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -202,7 +202,7 @@ static void locomo_mask_irq(unsigned int
 	locomo_writel(r, mapbase + LOCOMO_ICR);
 }
 
-static void locomo_unmask_irq(unsigned int irq)
+static void locomo_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -227,7 +227,7 @@ static void locomo_key_handler(unsigned
 	}
 }
 
-static void locomo_key_ack_irq(unsigned int irq)
+static void locomo_key_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -236,7 +236,7 @@ static void locomo_key_ack_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
 }
 
-static void locomo_key_mask_irq(unsigned int irq)
+static void locomo_key_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -245,7 +245,7 @@ static void locomo_key_mask_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
 }
 
-static void locomo_key_unmask_irq(unsigned int irq)
+static void locomo_key_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -280,7 +280,7 @@ static void locomo_gpio_handler(unsigned
 	}
 }
 
-static void locomo_gpio_ack_irq(unsigned int irq)
+static void locomo_gpio_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -297,7 +297,7 @@ static void locomo_gpio_ack_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_GWE);
 }
 
-static void locomo_gpio_mask_irq(unsigned int irq)
+static void locomo_gpio_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -306,7 +306,7 @@ static void locomo_gpio_mask_irq(unsigne
 	locomo_writel(r, mapbase + LOCOMO_GIE);
 }
 
-static void locomo_gpio_unmask_irq(unsigned int irq)
+static void locomo_gpio_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -362,7 +362,7 @@ static void locomo_lt_handler(unsigned i
 	}
 }
 
-static void locomo_lt_ack_irq(unsigned int irq)
+static void locomo_lt_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -371,7 +371,7 @@ static void locomo_lt_ack_irq(unsigned i
 	locomo_writel(r, mapbase + LOCOMO_LTINT);
 }
 
-static void locomo_lt_mask_irq(unsigned int irq)
+static void locomo_lt_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -380,7 +380,7 @@ static void locomo_lt_mask_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_LTINT);
 }
 
-static void locomo_lt_unmask_irq(unsigned int irq)
+static void locomo_lt_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -413,7 +413,7 @@ static void locomo_spi_handler(unsigned
 	}
 }
 
-static void locomo_spi_ack_irq(unsigned int irq)
+static void locomo_spi_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -430,7 +430,7 @@ static void locomo_spi_ack_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_SPI + LOCOMO_SPIWE);
 }
 
-static void locomo_spi_mask_irq(unsigned int irq)
+static void locomo_spi_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
@@ -439,7 +439,7 @@ static void locomo_spi_mask_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_SPI + LOCOMO_SPIIE);
 }
 
-static void locomo_spi_unmask_irq(unsigned int irq)
+static void locomo_spi_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned int r;
Index: linux-2.6/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6.orig/arch/arm/common/sa1111.c
+++ linux-2.6/arch/arm/common/sa1111.c
@@ -159,7 +159,7 @@ sa1111_irq_handler(unsigned int irq, str
 
 	sa1111_writel(stat0, base + SA1111_INTSTATCLR0);
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 
 	sa1111_writel(stat1, base + SA1111_INTSTATCLR1);
 
@@ -177,17 +177,17 @@ sa1111_irq_handler(unsigned int irq, str
 			handle_edge_irq(i, irq_desc + i);
 
 	/* For level-based interrupts */
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 #define SA1111_IRQMASK_LO(x)	(1 << (x - IRQ_SA1111_START))
 #define SA1111_IRQMASK_HI(x)	(1 << (x - IRQ_SA1111_START - 32))
 
-static void sa1111_ack_irq(unsigned int irq)
+static void sa1111_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
-static void sa1111_mask_lowirq(unsigned int irq)
+static void sa1111_mask_lowirq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned long ie0;
@@ -197,7 +197,7 @@ static void sa1111_mask_lowirq(unsigned
 	writel(ie0, mapbase + SA1111_INTEN0);
 }
 
-static void sa1111_unmask_lowirq(unsigned int irq)
+static void sa1111_unmask_lowirq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned long ie0;
@@ -284,7 +284,7 @@ static struct irq_chip sa1111_low_chip =
 	.set_wake	= sa1111_wake_lowirq,
 };
 
-static void sa1111_mask_highirq(unsigned int irq)
+static void sa1111_mask_highirq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned long ie1;
@@ -294,7 +294,7 @@ static void sa1111_mask_highirq(unsigned
 	sa1111_writel(ie1, mapbase + SA1111_INTEN1);
 }
 
-static void sa1111_unmask_highirq(unsigned int irq)
+static void sa1111_unmask_highirq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *mapbase = get_irq_chip_data(irq);
 	unsigned long ie1;
Index: linux-2.6/arch/arm/common/vic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/vic.c
+++ linux-2.6/arch/arm/common/vic.c
@@ -28,7 +28,7 @@
 #include <asm/mach/irq.h>
 #include <asm/hardware/vic.h>
 
-static void vic_ack_irq(unsigned int irq)
+static void vic_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *base = get_irq_chip_data(irq);
 	irq &= 31;
@@ -37,14 +37,14 @@ static void vic_ack_irq(unsigned int irq
 	writel(1 << irq, base + VIC_INT_SOFT_CLEAR);
 }
 
-static void vic_mask_irq(unsigned int irq)
+static void vic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *base = get_irq_chip_data(irq);
 	irq &= 31;
 	writel(1 << irq, base + VIC_INT_ENABLE_CLEAR);
 }
 
-static void vic_unmask_irq(unsigned int irq)
+static void vic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *base = get_irq_chip_data(irq);
 	irq &= 31;
Index: linux-2.6/arch/arm/kernel/ecard.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ecard.c
+++ linux-2.6/arch/arm/kernel/ecard.c
@@ -443,7 +443,7 @@ static expansioncard_ops_t ecard_default
  *
  * They are not meant to be called directly, but via enable/disable_irq.
  */
-static void ecard_irq_unmask(unsigned int irqnr)
+static void ecard_irq_unmask(unsigned int irqnr, struct irq_desc *desc)
 {
 	ecard_t *ec = slot_to_ecard(irqnr - 32);
 
@@ -459,7 +459,7 @@ static void ecard_irq_unmask(unsigned in
 	}
 }
 
-static void ecard_irq_mask(unsigned int irqnr)
+static void ecard_irq_mask(unsigned int irqnr, struct irq_desc *desc)
 {
 	ecard_t *ec = slot_to_ecard(irqnr - 32);
 
@@ -551,7 +551,7 @@ static void ecard_check_lockup(struct ir
 			printk(KERN_ERR "\nInterrupt lockup detected - "
 			       "disabling all expansion card interrupts\n");
 
-			desc->chip->mask(IRQ_EXPANSIONCARD);
+			desc->chip->mask(IRQ_EXPANSIONCARD, irq_to_desc(IRQ_EXPANSIONCARD));
 			ecard_dump_irq_state();
 		}
 	} else
@@ -574,7 +574,7 @@ ecard_irq_handler(unsigned int irq, stru
 	ecard_t *ec;
 	int called = 0;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(irq, desc);
 	for (ec = cards; ec; ec = ec->next) {
 		int pending;
 
@@ -591,7 +591,7 @@ ecard_irq_handler(unsigned int irq, stru
 			called ++;
 		}
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 
 	if (called == 0)
 		ecard_check_lockup(desc);
Index: linux-2.6/arch/arm/mach-aaec2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-aaec2000/core.c
+++ linux-2.6/arch/arm/mach-aaec2000/core.c
@@ -67,17 +67,17 @@ void __init aaec2000_map_io(void)
 /*
  * Interrupt handling routines
  */
-static void aaec2000_int_ack(unsigned int irq)
+static void aaec2000_int_ack(unsigned int irq, struct irq_desc *desc)
 {
 	IRQ_INTSR = 1 << irq;
 }
 
-static void aaec2000_int_mask(unsigned int irq)
+static void aaec2000_int_mask(unsigned int irq, struct irq_desc *desc)
 {
 	IRQ_INTENC |= (1 << irq);
 }
 
-static void aaec2000_int_unmask(unsigned int irq)
+static void aaec2000_int_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	IRQ_INTENS |= (1 << irq);
 }
Index: linux-2.6/arch/arm/mach-at91/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/gpio.c
+++ linux-2.6/arch/arm/mach-at91/gpio.c
@@ -344,7 +344,7 @@ void at91_gpio_resume(void)
  * IRQ0..IRQ6 should be configurable, e.g. level vs edge triggering.
  */
 
-static void gpio_irq_mask(unsigned pin)
+static void gpio_irq_mask(unsigned pin, struct irq_desc *desc)
 {
 	void __iomem	*pio = pin_to_controller(pin);
 	unsigned	mask = pin_to_mask(pin);
@@ -353,7 +353,7 @@ static void gpio_irq_mask(unsigned pin)
 		__raw_writel(mask, pio + PIO_IDR);
 }
 
-static void gpio_irq_unmask(unsigned pin)
+static void gpio_irq_unmask(unsigned pin, struct irq_desc *desc)
 {
 	void __iomem	*pio = pin_to_controller(pin);
 	unsigned	mask = pin_to_mask(pin);
@@ -393,7 +393,7 @@ static void gpio_irq_handler(unsigned ir
 	pio = at91_gpio->regbase;
 
 	/* temporarily mask (level sensitive) parent IRQ */
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 	for (;;) {
 		/* Reading ISR acks pending (edge triggered) GPIO interrupts.
 		 * When there none are pending, we're finished unless we need
@@ -429,7 +429,7 @@ static void gpio_irq_handler(unsigned ir
 			isr >>= 1;
 		}
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 	/* now it may re-trigger */
 }
 
Index: linux-2.6/arch/arm/mach-at91/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/irq.c
+++ linux-2.6/arch/arm/mach-at91/irq.c
@@ -34,13 +34,13 @@
 #include <asm/mach/map.h>
 
 
-static void at91_aic_mask_irq(unsigned int irq)
+static void at91_aic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* Disable interrupt on AIC */
 	at91_sys_write(AT91_AIC_IDCR, 1 << irq);
 }
 
-static void at91_aic_unmask_irq(unsigned int irq)
+static void at91_aic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* Enable interrupt on AIC */
 	at91_sys_write(AT91_AIC_IECR, 1 << irq);
Index: linux-2.6/arch/arm/mach-bcmring/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-bcmring/irq.c
+++ linux-2.6/arch/arm/mach-bcmring/irq.c
@@ -30,37 +30,37 @@
 #include <mach/csp/intcHw_reg.h>
 #include <mach/csp/mm_io.h>
 
-static void bcmring_mask_irq0(unsigned int irq)
+static void bcmring_mask_irq0(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - IRQ_INTC0_START),
 	       MM_IO_BASE_INTC0 + INTCHW_INTENCLEAR);
 }
 
-static void bcmring_unmask_irq0(unsigned int irq)
+static void bcmring_unmask_irq0(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - IRQ_INTC0_START),
 	       MM_IO_BASE_INTC0 + INTCHW_INTENABLE);
 }
 
-static void bcmring_mask_irq1(unsigned int irq)
+static void bcmring_mask_irq1(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - IRQ_INTC1_START),
 	       MM_IO_BASE_INTC1 + INTCHW_INTENCLEAR);
 }
 
-static void bcmring_unmask_irq1(unsigned int irq)
+static void bcmring_unmask_irq1(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - IRQ_INTC1_START),
 	       MM_IO_BASE_INTC1 + INTCHW_INTENABLE);
 }
 
-static void bcmring_mask_irq2(unsigned int irq)
+static void bcmring_mask_irq2(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - IRQ_SINTC_START),
 	       MM_IO_BASE_SINTC + INTCHW_INTENCLEAR);
 }
 
-static void bcmring_unmask_irq2(unsigned int irq)
+static void bcmring_unmask_irq2(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - IRQ_SINTC_START),
 	       MM_IO_BASE_SINTC + INTCHW_INTENABLE);
Index: linux-2.6/arch/arm/mach-clps711x/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-clps711x/irq.c
+++ linux-2.6/arch/arm/mach-clps711x/irq.c
@@ -27,7 +27,7 @@
 
 #include <asm/hardware/clps7111.h>
 
-static void int1_mask(unsigned int irq)
+static void int1_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 intmr1;
 
@@ -36,7 +36,7 @@ static void int1_mask(unsigned int irq)
 	clps_writel(intmr1, INTMR1);
 }
 
-static void int1_ack(unsigned int irq)
+static void int1_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u32 intmr1;
 
@@ -54,7 +54,7 @@ static void int1_ack(unsigned int irq)
 	}
 }
 
-static void int1_unmask(unsigned int irq)
+static void int1_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 intmr1;
 
@@ -69,7 +69,7 @@ static struct irq_chip int1_chip = {
 	.unmask = int1_unmask,
 };
 
-static void int2_mask(unsigned int irq)
+static void int2_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 intmr2;
 
@@ -78,7 +78,7 @@ static void int2_mask(unsigned int irq)
 	clps_writel(intmr2, INTMR2);
 }
 
-static void int2_ack(unsigned int irq)
+static void int2_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u32 intmr2;
 
@@ -91,7 +91,7 @@ static void int2_ack(unsigned int irq)
 	}
 }
 
-static void int2_unmask(unsigned int irq)
+static void int2_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 intmr2;
 
Index: linux-2.6/arch/arm/mach-davinci/cp_intc.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/cp_intc.c
+++ linux-2.6/arch/arm/mach-davinci/cp_intc.c
@@ -27,13 +27,13 @@ static inline void cp_intc_write(unsigne
 	__raw_writel(value, cp_intc_base + offset);
 }
 
-static void cp_intc_ack_irq(unsigned int irq)
+static void cp_intc_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	cp_intc_write(irq, CP_INTC_SYS_STAT_IDX_CLR);
 }
 
 /* Disable interrupt */
-static void cp_intc_mask_irq(unsigned int irq)
+static void cp_intc_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* XXX don't know why we need to disable nIRQ here... */
 	cp_intc_write(1, CP_INTC_HOST_ENABLE_IDX_CLR);
@@ -42,7 +42,7 @@ static void cp_intc_mask_irq(unsigned in
 }
 
 /* Enable interrupt */
-static void cp_intc_unmask_irq(unsigned int irq)
+static void cp_intc_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	cp_intc_write(irq, CP_INTC_SYS_ENABLE_IDX_SET);
 }
Index: linux-2.6/arch/arm/mach-davinci/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/gpio.c
+++ linux-2.6/arch/arm/mach-davinci/gpio.c
@@ -223,8 +223,8 @@ gpio_irq_handler(unsigned irq, struct ir
 		mask <<= 16;
 
 	/* temporarily mask (level sensitive) parent IRQ */
-	desc->chip->mask(irq);
-	desc->chip->ack(irq);
+	desc->chip->mask(irq, desc);
+	desc->chip->ack(irq, desc);
 	while (1) {
 		u32		status;
 		int		n;
@@ -247,7 +247,7 @@ gpio_irq_handler(unsigned irq, struct ir
 			status >>= res;
 		}
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 	/* now it may re-trigger */
 }
 
Index: linux-2.6/arch/arm/mach-davinci/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/irq.c
+++ linux-2.6/arch/arm/mach-davinci/irq.c
@@ -53,7 +53,7 @@ static inline void davinci_irq_writel(un
 }
 
 /* Disable interrupt */
-static void davinci_mask_irq(unsigned int irq)
+static void davinci_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 	u32 l;
@@ -72,7 +72,7 @@ static void davinci_mask_irq(unsigned in
 }
 
 /* Enable interrupt */
-static void davinci_unmask_irq(unsigned int irq)
+static void davinci_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 	u32 l;
@@ -91,7 +91,7 @@ static void davinci_unmask_irq(unsigned
 }
 
 /* EOI interrupt */
-static void davinci_ack_irq(unsigned int irq)
+static void davinci_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 
Index: linux-2.6/arch/arm/mach-dove/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-dove/irq.c
+++ linux-2.6/arch/arm/mach-dove/irq.c
@@ -36,7 +36,7 @@ static void gpio_irq_handler(unsigned in
 	}
 }
 
-static void pmu_irq_mask(unsigned int irq)
+static void pmu_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	int pin = irq_to_pmu(irq);
 	u32 u;
@@ -46,7 +46,7 @@ static void pmu_irq_mask(unsigned int ir
 	writel(u, PMU_INTERRUPT_MASK);
 }
 
-static void pmu_irq_unmask(unsigned int irq)
+static void pmu_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	int pin = irq_to_pmu(irq);
 	u32 u;
@@ -56,7 +56,7 @@ static void pmu_irq_unmask(unsigned int
 	writel(u, PMU_INTERRUPT_MASK);
 }
 
-static void pmu_irq_ack(unsigned int irq)
+static void pmu_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	int pin = irq_to_pmu(irq);
 	u32 u;
Index: linux-2.6/arch/arm/mach-ebsa110/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ebsa110/core.c
+++ linux-2.6/arch/arm/mach-ebsa110/core.c
@@ -35,12 +35,12 @@
 #define IRQ_STAT		0xff000000	/* read */
 #define IRQ_MCLR		0xff000000	/* write */
 
-static void ebsa110_mask_irq(unsigned int irq)
+static void ebsa110_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writeb(1 << irq, IRQ_MCLR);
 }
 
-static void ebsa110_unmask_irq(unsigned int irq)
+static void ebsa110_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writeb(1 << irq, IRQ_MSET);
 }
Index: linux-2.6/arch/arm/mach-ep93xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ep93xx/core.c
+++ linux-2.6/arch/arm/mach-ep93xx/core.c
@@ -225,7 +225,7 @@ static void ep93xx_gpio_f_irq_handler(un
 	generic_handle_irq(gpio_irq);
 }
 
-static void ep93xx_gpio_irq_ack(unsigned int irq)
+static void ep93xx_gpio_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
@@ -239,7 +239,7 @@ static void ep93xx_gpio_irq_ack(unsigned
 	__raw_writeb(port_mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
 }
 
-static void ep93xx_gpio_irq_mask_ack(unsigned int irq)
+static void ep93xx_gpio_irq_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
@@ -254,7 +254,7 @@ static void ep93xx_gpio_irq_mask_ack(uns
 	__raw_writeb(port_mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
 }
 
-static void ep93xx_gpio_irq_mask(unsigned int irq)
+static void ep93xx_gpio_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
@@ -263,7 +263,7 @@ static void ep93xx_gpio_irq_mask(unsigne
 	ep93xx_gpio_update_int_params(port);
 }
 
-static void ep93xx_gpio_irq_unmask(unsigned int irq)
+static void ep93xx_gpio_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
Index: linux-2.6/arch/arm/mach-footbridge/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/common.c
+++ linux-2.6/arch/arm/mach-footbridge/common.c
@@ -74,12 +74,12 @@ static const int fb_irq_mask[] = {
 	IRQ_MASK_PCI_PERR,	/* 19 */
 };
 
-static void fb_mask_irq(unsigned int irq)
+static void fb_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	*CSR_IRQ_DISABLE = fb_irq_mask[_DC21285_INR(irq)];
 }
 
-static void fb_unmask_irq(unsigned int irq)
+static void fb_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	*CSR_IRQ_ENABLE = fb_irq_mask[_DC21285_INR(irq)];
 }
Index: linux-2.6/arch/arm/mach-footbridge/isa-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/isa-irq.c
+++ linux-2.6/arch/arm/mach-footbridge/isa-irq.c
@@ -30,14 +30,14 @@
 
 #include "common.h"
 
-static void isa_mask_pic_lo_irq(unsigned int irq)
+static void isa_mask_pic_lo_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_LO) | mask, PIC_MASK_LO);
 }
 
-static void isa_ack_pic_lo_irq(unsigned int irq)
+static void isa_ack_pic_lo_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq & 7);
 
@@ -45,7 +45,7 @@ static void isa_ack_pic_lo_irq(unsigned
 	outb(0x20, PIC_LO);
 }
 
-static void isa_unmask_pic_lo_irq(unsigned int irq)
+static void isa_unmask_pic_lo_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq & 7);
 
@@ -58,14 +58,14 @@ static struct irq_chip isa_lo_chip = {
 	.unmask = isa_unmask_pic_lo_irq,
 };
 
-static void isa_mask_pic_hi_irq(unsigned int irq)
+static void isa_mask_pic_hi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_HI) | mask, PIC_MASK_HI);
 }
 
-static void isa_ack_pic_hi_irq(unsigned int irq)
+static void isa_ack_pic_hi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq & 7);
 
@@ -74,7 +74,7 @@ static void isa_ack_pic_hi_irq(unsigned
 	outb(0x20, PIC_HI);
 }
 
-static void isa_unmask_pic_hi_irq(unsigned int irq)
+static void isa_unmask_pic_hi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq & 7);
 
Index: linux-2.6/arch/arm/mach-gemini/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-gemini/gpio.c
+++ linux-2.6/arch/arm/mach-gemini/gpio.c
@@ -54,7 +54,7 @@ static void _set_gpio_irqenable(unsigned
 	__raw_writel(reg, base + GPIO_INT_EN);
 }
 
-static void gpio_ack_irq(unsigned int irq)
+static void gpio_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = irq_to_gpio(irq);
 	unsigned int base = GPIO_BASE(gpio / 32);
@@ -62,7 +62,7 @@ static void gpio_ack_irq(unsigned int ir
 	__raw_writel(1 << (gpio % 32), base + GPIO_INT_CLR);
 }
 
-static void gpio_mask_irq(unsigned int irq)
+static void gpio_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = irq_to_gpio(irq);
 	unsigned int base = GPIO_BASE(gpio / 32);
@@ -70,7 +70,7 @@ static void gpio_mask_irq(unsigned int i
 	_set_gpio_irqenable(base, gpio % 32, 0);
 }
 
-static void gpio_unmask_irq(unsigned int irq)
+static void gpio_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = irq_to_gpio(irq);
 	unsigned int base = GPIO_BASE(gpio / 32);
Index: linux-2.6/arch/arm/mach-gemini/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-gemini/irq.c
+++ linux-2.6/arch/arm/mach-gemini/irq.c
@@ -32,12 +32,12 @@
 #define FIQ_LEVEL(base_addr)	(base_addr + 0x30)
 #define FIQ_STATUS(base_addr)	(base_addr + 0x34)
 
-static void gemini_ack_irq(unsigned int irq)
+static void gemini_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(1 << irq, IRQ_CLEAR(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
 }
 
-static void gemini_mask_irq(unsigned int irq)
+static void gemini_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 
@@ -46,7 +46,7 @@ static void gemini_mask_irq(unsigned int
 	__raw_writel(mask, IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
 }
 
-static void gemini_unmask_irq(unsigned int irq)
+static void gemini_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 
Index: linux-2.6/arch/arm/mach-h720x/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/common.c
+++ linux-2.6/arch/arm/mach-h720x/common.c
@@ -53,7 +53,7 @@ unsigned long h720x_gettimeoffset(void)
 /*
  * mask Global irq's
  */
-static void mask_global_irq (unsigned int irq )
+static void mask_global_irq(unsigned int irq, struct irq_desc *desc)
 {
 	CPU_REG (IRQC_VIRT, IRQC_IER) &= ~(1 << irq);
 }
@@ -61,7 +61,7 @@ static void mask_global_irq (unsigned in
 /*
  * unmask Global irq's
  */
-static void unmask_global_irq (unsigned int irq )
+static void unmask_global_irq(unsigned int irq, struct irq_desc *desc)
 {
 	CPU_REG (IRQC_VIRT, IRQC_IER) |= (1 << irq);
 }
@@ -71,7 +71,7 @@ static void unmask_global_irq (unsigned
  * ack GPIO irq's
  * Ack only for edge triggered int's valid
  */
-static void inline ack_gpio_irq(u32 irq)
+static inline void ack_gpio_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(irq));
 	u32 bit = IRQ_TO_BIT(irq);
@@ -82,7 +82,7 @@ static void inline ack_gpio_irq(u32 irq)
 /*
  * mask GPIO irq's
  */
-static void inline mask_gpio_irq(u32 irq)
+static inline void mask_gpio_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(irq));
 	u32 bit = IRQ_TO_BIT(irq);
@@ -92,7 +92,7 @@ static void inline mask_gpio_irq(u32 irq
 /*
  * unmask GPIO irq's
  */
-static void inline unmask_gpio_irq(u32 irq)
+static inline void unmask_gpio_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(irq));
 	u32 bit = IRQ_TO_BIT(irq);
Index: linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/cpu-h7202.c
+++ linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
@@ -141,7 +141,7 @@ h7202_timer_interrupt(int irq, void *dev
 /*
  * mask multiplexed timer IRQs
  */
-static void inline mask_timerx_irq (u32 irq)
+static inline void mask_timerx_irq(u32 irq, struct irq_desc *desc)
 {
 	unsigned int bit;
 	bit = 2 << ((irq == IRQ_TIMER64B) ? 4 : (irq - IRQ_TIMER1));
@@ -151,7 +151,7 @@ static void inline mask_timerx_irq (u32
 /*
  * unmask multiplexed timer IRQs
  */
-static void inline unmask_timerx_irq (u32 irq)
+static inline void unmask_timerx_irq(u32 irq, struct irq_desc *desc)
 {
 	unsigned int bit;
 	bit = 2 << ((irq == IRQ_TIMER64B) ? 4 : (irq - IRQ_TIMER1));
Index: linux-2.6/arch/arm/mach-integrator/integrator_ap.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/integrator_ap.c
+++ linux-2.6/arch/arm/mach-integrator/integrator_ap.c
@@ -151,12 +151,12 @@ static void __init ap_map_io(void)
 
 #define INTEGRATOR_SC_VALID_INT	0x003fffff
 
-static void sc_mask_irq(unsigned int irq)
+static void sc_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << irq, VA_IC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void sc_unmask_irq(unsigned int irq)
+static void sc_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << irq, VA_IC_BASE + IRQ_ENABLE_SET);
 }
Index: linux-2.6/arch/arm/mach-integrator/integrator_cp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/integrator_cp.c
+++ linux-2.6/arch/arm/mach-integrator/integrator_cp.c
@@ -145,13 +145,13 @@ static void __init intcp_map_io(void)
 #define sic_writel	__raw_writel
 #define sic_readl	__raw_readl
 
-static void cic_mask_irq(unsigned int irq)
+static void cic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_CIC_START;
 	cic_writel(1 << irq, INTCP_VA_CIC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void cic_unmask_irq(unsigned int irq)
+static void cic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_CIC_START;
 	cic_writel(1 << irq, INTCP_VA_CIC_BASE + IRQ_ENABLE_SET);
@@ -164,13 +164,13 @@ static struct irq_chip cic_chip = {
 	.unmask	= cic_unmask_irq,
 };
 
-static void pic_mask_irq(unsigned int irq)
+static void pic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_PIC_START;
 	pic_writel(1 << irq, INTCP_VA_PIC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void pic_unmask_irq(unsigned int irq)
+static void pic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_PIC_START;
 	pic_writel(1 << irq, INTCP_VA_PIC_BASE + IRQ_ENABLE_SET);
@@ -183,13 +183,13 @@ static struct irq_chip pic_chip = {
 	.unmask = pic_unmask_irq,
 };
 
-static void sic_mask_irq(unsigned int irq)
+static void sic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_SIC_START;
 	sic_writel(1 << irq, INTCP_VA_SIC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void sic_unmask_irq(unsigned int irq)
+static void sic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_SIC_START;
 	sic_writel(1 << irq, INTCP_VA_SIC_BASE + IRQ_ENABLE_SET);
Index: linux-2.6/arch/arm/mach-iop13xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop13xx/irq.c
+++ linux-2.6/arch/arm/mach-iop13xx/irq.c
@@ -123,49 +123,49 @@ static void write_intsize(u32 val)
 
 /* 0 = Interrupt Masked and 1 = Interrupt not masked */
 static void
-iop13xx_irq_mask0 (unsigned int irq)
+iop13xx_irq_mask0(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_0(read_intctl_0() & ~(1 << (irq - 0)));
 }
 
 static void
-iop13xx_irq_mask1 (unsigned int irq)
+iop13xx_irq_mask1(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_1(read_intctl_1() & ~(1 << (irq - 32)));
 }
 
 static void
-iop13xx_irq_mask2 (unsigned int irq)
+iop13xx_irq_mask2(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_2(read_intctl_2() & ~(1 << (irq - 64)));
 }
 
 static void
-iop13xx_irq_mask3 (unsigned int irq)
+iop13xx_irq_mask3(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_3(read_intctl_3() & ~(1 << (irq - 96)));
 }
 
 static void
-iop13xx_irq_unmask0(unsigned int irq)
+iop13xx_irq_unmask0(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_0(read_intctl_0() | (1 << (irq - 0)));
 }
 
 static void
-iop13xx_irq_unmask1(unsigned int irq)
+iop13xx_irq_unmask1(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_1(read_intctl_1() | (1 << (irq - 32)));
 }
 
 static void
-iop13xx_irq_unmask2(unsigned int irq)
+iop13xx_irq_unmask2(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_2(read_intctl_2() | (1 << (irq - 64)));
 }
 
 static void
-iop13xx_irq_unmask3(unsigned int irq)
+iop13xx_irq_unmask3(unsigned int irq, struct irq_desc *desc)
 {
 	write_intctl_3(read_intctl_3() | (1 << (irq - 96)));
 }
Index: linux-2.6/arch/arm/mach-iop13xx/msi.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop13xx/msi.c
+++ linux-2.6/arch/arm/mach-iop13xx/msi.c
@@ -156,7 +156,7 @@ void arch_teardown_msi_irq(unsigned int
 	destroy_irq(irq);
 }
 
-static void iop13xx_msi_nop(unsigned int irq)
+static void iop13xx_msi_nop(unsigned int irq, struct irq_desc *desc)
 {
 	return;
 }
Index: linux-2.6/arch/arm/mach-iop32x/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop32x/irq.c
+++ linux-2.6/arch/arm/mach-iop32x/irq.c
@@ -32,14 +32,14 @@ static void intstr_write(u32 val)
 }
 
 static void
-iop32x_irq_mask(unsigned int irq)
+iop32x_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	iop32x_mask &= ~(1 << irq);
 	intctl_write(iop32x_mask);
 }
 
 static void
-iop32x_irq_unmask(unsigned int irq)
+iop32x_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	iop32x_mask |= 1 << irq;
 	intctl_write(iop32x_mask);
Index: linux-2.6/arch/arm/mach-ixp2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/core.c
+++ linux-2.6/arch/arm/mach-ixp2000/core.c
@@ -342,7 +342,7 @@ static int ixp2000_GPIO_irq_type(unsigne
 	return 0;
 }
 
-static void ixp2000_GPIO_irq_mask_ack(unsigned int irq)
+static void ixp2000_GPIO_irq_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_write(IXP2000_GPIO_INCR, (1 << (irq - IRQ_IXP2000_GPIO0)));
 
@@ -351,12 +351,12 @@ static void ixp2000_GPIO_irq_mask_ack(un
 	ixp2000_reg_wrb(IXP2000_GPIO_INST, (1 << (irq - IRQ_IXP2000_GPIO0)));
 }
 
-static void ixp2000_GPIO_irq_mask(unsigned int irq)
+static void ixp2000_GPIO_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_wrb(IXP2000_GPIO_INCR, (1 << (irq - IRQ_IXP2000_GPIO0)));
 }
 
-static void ixp2000_GPIO_irq_unmask(unsigned int irq)
+static void ixp2000_GPIO_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_write(IXP2000_GPIO_INSR, (1 << (irq - IRQ_IXP2000_GPIO0)));
 }
@@ -368,7 +368,7 @@ static struct irq_chip ixp2000_GPIO_irq_
 	.set_type	= ixp2000_GPIO_irq_type,
 };
 
-static void ixp2000_pci_irq_mask(unsigned int irq)
+static void ixp2000_pci_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long temp = *IXP2000_PCI_XSCALE_INT_ENABLE;
 	if (irq == IRQ_IXP2000_PCIA)
@@ -377,7 +377,7 @@ static void ixp2000_pci_irq_mask(unsigne
 		ixp2000_reg_wrb(IXP2000_PCI_XSCALE_INT_ENABLE, (temp & ~(1 << 27)));
 }
 
-static void ixp2000_pci_irq_unmask(unsigned int irq)
+static void ixp2000_pci_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long temp = *IXP2000_PCI_XSCALE_INT_ENABLE;
 	if (irq == IRQ_IXP2000_PCIA)
@@ -401,13 +401,13 @@ static void ixp2000_err_irq_handler(unsi
 	}
 }
 
-static void ixp2000_err_irq_mask(unsigned int irq)
+static void ixp2000_err_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_write(IXP2000_IRQ_ERR_ENABLE_CLR,
 			(1 << (irq - IRQ_IXP2000_DRAM0_MIN_ERR)));
 }
 
-static void ixp2000_err_irq_unmask(unsigned int irq)
+static void ixp2000_err_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_write(IXP2000_IRQ_ERR_ENABLE_SET,
 			(1 << (irq - IRQ_IXP2000_DRAM0_MIN_ERR)));
@@ -425,12 +425,12 @@ static struct irq_chip ixp2000_pci_irq_c
 	.unmask	= ixp2000_pci_irq_unmask
 };
 
-static void ixp2000_irq_mask(unsigned int irq)
+static void ixp2000_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_wrb(IXP2000_IRQ_ENABLE_CLR, (1 << irq));
 }
 
-static void ixp2000_irq_unmask(unsigned int irq)
+static void ixp2000_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_write(IXP2000_IRQ_ENABLE_SET, (1 << irq));
 }
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2x00.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -64,7 +64,7 @@ static struct slowport_cfg slowport_cpld
 };
 #endif
 
-static void ixdp2x00_irq_mask(unsigned int irq)
+static void ixdp2x00_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long dummy;
 	static struct slowport_cfg old_cfg;
@@ -88,7 +88,7 @@ static void ixdp2x00_irq_mask(unsigned i
 #endif
 }
 
-static void ixdp2x00_irq_unmask(unsigned int irq)
+static void ixdp2x00_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long dummy;
 	static struct slowport_cfg old_cfg;
@@ -112,7 +112,7 @@ static void ixdp2x00_irq_handler(unsigne
 	static struct slowport_cfg old_cfg;
 	int i;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(irq, desc);
 
 #ifdef CONFIG_ARCH_IXDP2400
 	if (machine_is_ixdp2400())
@@ -134,7 +134,7 @@ static void ixdp2x00_irq_handler(unsigne
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 static struct irq_chip ixdp2x00_cpld_irq_chip = {
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2x01.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2x01.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -49,13 +49,13 @@
 /*************************************************************************
  * IXDP2x01 IRQ Handling
  *************************************************************************/
-static void ixdp2x01_irq_mask(unsigned int irq)
+static void ixdp2x01_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_wrb(IXDP2X01_INT_MASK_SET_REG,
 				IXP2000_BOARD_IRQ_MASK(irq));
 }
 
-static void ixdp2x01_irq_unmask(unsigned int irq)
+static void ixdp2x01_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	ixp2000_reg_write(IXDP2X01_INT_MASK_CLR_REG,
 				IXP2000_BOARD_IRQ_MASK(irq));
@@ -68,7 +68,7 @@ static void ixdp2x01_irq_handler(unsigne
 	u32 ex_interrupt;
 	int i;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(irq, desc);
 
 	ex_interrupt = *IXDP2X01_INT_STAT_REG & valid_irq_mask;
 
@@ -84,7 +84,7 @@ static void ixdp2x01_irq_handler(unsigne
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 static struct irq_chip ixdp2x01_irq_chip = {
Index: linux-2.6/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp23xx/core.c
+++ linux-2.6/arch/arm/mach-ixp23xx/core.c
@@ -173,7 +173,7 @@ static int ixp23xx_irq_set_type(unsigned
 	return 0;
 }
 
-static void ixp23xx_irq_mask(unsigned int irq)
+static void ixp23xx_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	volatile unsigned long *intr_reg;
 
@@ -184,7 +184,7 @@ static void ixp23xx_irq_mask(unsigned in
 	*intr_reg &= ~(1 << (irq % 32));
 }
 
-static void ixp23xx_irq_ack(unsigned int irq)
+static void ixp23xx_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	int line = irq - IRQ_IXP23XX_GPIO6 + 6;
 
@@ -198,7 +198,7 @@ static void ixp23xx_irq_ack(unsigned int
  * Level triggered interrupts on GPIO lines can only be cleared when the
  * interrupt condition disappears.
  */
-static void ixp23xx_irq_level_unmask(unsigned int irq)
+static void ixp23xx_irq_level_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	volatile unsigned long *intr_reg;
 
@@ -211,7 +211,7 @@ static void ixp23xx_irq_level_unmask(uns
 	*intr_reg |= (1 << (irq % 32));
 }
 
-static void ixp23xx_irq_edge_unmask(unsigned int irq)
+static void ixp23xx_irq_edge_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	volatile unsigned long *intr_reg;
 
@@ -236,12 +236,12 @@ static struct irq_chip ixp23xx_irq_edge_
 	.set_type	= ixp23xx_irq_set_type
 };
 
-static void ixp23xx_pci_irq_mask(unsigned int irq)
+static void ixp23xx_pci_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	*IXP23XX_PCI_XSCALE_INT_ENABLE &= ~(1 << (IRQ_IXP23XX_INTA + 27 - irq));
 }
 
-static void ixp23xx_pci_irq_unmask(unsigned int irq)
+static void ixp23xx_pci_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	*IXP23XX_PCI_XSCALE_INT_ENABLE |= (1 << (IRQ_IXP23XX_INTA + 27 - irq));
 }
@@ -256,7 +256,7 @@ static void pci_handler(unsigned int irq
 
 	pci_interrupt = *IXP23XX_PCI_XSCALE_INT_STATUS;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 
 	/* See which PCI_INTA, or PCI_INTB interrupted */
 	if (pci_interrupt & (1 << 26)) {
@@ -269,7 +269,7 @@ static void pci_handler(unsigned int irq
 
 	generic_handle_irq(irqno);
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 static struct irq_chip ixp23xx_pci_irq_chip = {
Index: linux-2.6/arch/arm/mach-ixp23xx/ixdp2351.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp23xx/ixdp2351.c
+++ linux-2.6/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -48,12 +48,12 @@
 /*
  * IXDP2351 Interrupt Handling
  */
-static void ixdp2351_inta_mask(unsigned int irq)
+static void ixdp2351_inta_mask(unsigned int irq, struct irq_desc *desc)
 {
 	*IXDP2351_CPLD_INTA_MASK_SET_REG = IXDP2351_INTA_IRQ_MASK(irq);
 }
 
-static void ixdp2351_inta_unmask(unsigned int irq)
+static void ixdp2351_inta_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	*IXDP2351_CPLD_INTA_MASK_CLR_REG = IXDP2351_INTA_IRQ_MASK(irq);
 }
@@ -64,7 +64,7 @@ static void ixdp2351_inta_handler(unsign
 		*IXDP2351_CPLD_INTA_STAT_REG & IXDP2351_INTA_IRQ_VALID;
 	int i;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(irq, desc);
 
 	for (i = 0; i < IXDP2351_INTA_IRQ_NUM; i++) {
 		if (ex_interrupt & (1 << i)) {
@@ -74,7 +74,7 @@ static void ixdp2351_inta_handler(unsign
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 static struct irq_chip ixdp2351_inta_chip = {
@@ -83,12 +83,12 @@ static struct irq_chip ixdp2351_inta_chi
 	.unmask	= ixdp2351_inta_unmask
 };
 
-static void ixdp2351_intb_mask(unsigned int irq)
+static void ixdp2351_intb_mask(unsigned int irq, struct irq_desc *desc)
 {
 	*IXDP2351_CPLD_INTB_MASK_SET_REG = IXDP2351_INTB_IRQ_MASK(irq);
 }
 
-static void ixdp2351_intb_unmask(unsigned int irq)
+static void ixdp2351_intb_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	*IXDP2351_CPLD_INTB_MASK_CLR_REG = IXDP2351_INTB_IRQ_MASK(irq);
 }
@@ -99,7 +99,7 @@ static void ixdp2351_intb_handler(unsign
 		*IXDP2351_CPLD_INTB_STAT_REG & IXDP2351_INTB_IRQ_VALID;
 	int i;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 
 	for (i = 0; i < IXDP2351_INTB_IRQ_NUM; i++) {
 		if (ex_interrupt & (1 << i)) {
@@ -109,7 +109,7 @@ static void ixdp2351_intb_handler(unsign
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 static struct irq_chip ixdp2351_intb_chip = {
Index: linux-2.6/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6/arch/arm/mach-ixp4xx/common.c
@@ -193,7 +193,7 @@ static int ixp4xx_set_irq_type(unsigned
 	return 0;
 }
 
-static void ixp4xx_irq_mask(unsigned int irq)
+static void ixp4xx_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	if ((cpu_is_ixp46x() || cpu_is_ixp43x()) && irq >= 32)
 		*IXP4XX_ICMR2 &= ~(1 << (irq - 32));
@@ -201,7 +201,7 @@ static void ixp4xx_irq_mask(unsigned int
 		*IXP4XX_ICMR &= ~(1 << irq);
 }
 
-static void ixp4xx_irq_ack(unsigned int irq)
+static void ixp4xx_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	int line = (irq < 32) ? irq2gpio[irq] : -1;
 
@@ -213,7 +213,7 @@ static void ixp4xx_irq_ack(unsigned int
  * Level triggered interrupts on GPIO lines can only be cleared when the
  * interrupt condition disappears.
  */
-static void ixp4xx_irq_unmask(unsigned int irq)
+static void ixp4xx_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	if (!(ixp4xx_irq_edge & (1 << irq)))
 		ixp4xx_irq_ack(irq);
Index: linux-2.6/arch/arm/mach-ks8695/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ks8695/irq.c
+++ linux-2.6/arch/arm/mach-ks8695/irq.c
@@ -34,7 +34,7 @@
 #include <mach/regs-irq.h>
 #include <mach/regs-gpio.h>
 
-static void ks8695_irq_mask(unsigned int irqno)
+static void ks8695_irq_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long inten;
 
@@ -44,7 +44,7 @@ static void ks8695_irq_mask(unsigned int
 	__raw_writel(inten, KS8695_IRQ_VA + KS8695_INTEN);
 }
 
-static void ks8695_irq_unmask(unsigned int irqno)
+static void ks8695_irq_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long inten;
 
@@ -54,7 +54,7 @@ static void ks8695_irq_unmask(unsigned i
 	__raw_writel(inten, KS8695_IRQ_VA + KS8695_INTEN);
 }
 
-static void ks8695_irq_ack(unsigned int irqno)
+static void ks8695_irq_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	__raw_writel((1 << irqno), KS8695_IRQ_VA + KS8695_INTST);
 }
Index: linux-2.6/arch/arm/mach-l7200/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-l7200/core.c
+++ linux-2.6/arch/arm/mach-l7200/core.c
@@ -45,12 +45,12 @@
 #define FIQ_SOFT	(*(volatile unsigned long *) (IRQ_BASE + 0x110))
 #define FIQ_SOURCESEL	(*(volatile unsigned long *) (IRQ_BASE + 0x118))
 
-static void l7200_mask_irq(unsigned int irq)
+static void l7200_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	IRQ_ENABLECLEAR = 1 << irq;
 }
 
-static void l7200_unmask_irq(unsigned int irq)
+static void l7200_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	IRQ_ENABLE = 1 << irq;
 }
Index: linux-2.6/arch/arm/mach-lh7a40x/arch-kev7a400.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/arch-kev7a400.c
+++ linux-2.6/arch/arm/mach-lh7a40x/arch-kev7a400.c
@@ -46,18 +46,18 @@ void __init kev7a400_map_io(void)
 
 static u16 CPLD_IRQ_mask;	/* Mask for CPLD IRQs, 1 == unmasked */
 
-static void kev7a400_ack_cpld_irq (u32 irq)
+static void kev7a400_ack_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	CPLD_CL_INT = 1 << (irq - IRQ_KEV7A400_CPLD);
 }
 
-static void kev7a400_mask_cpld_irq (u32 irq)
+static void kev7a400_mask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	CPLD_IRQ_mask &= ~(1 << (irq - IRQ_KEV7A400_CPLD));
 	CPLD_WR_PB_INT_MASK = CPLD_IRQ_mask;
 }
 
-static void kev7a400_unmask_cpld_irq (u32 irq)
+static void kev7a400_unmask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	CPLD_IRQ_mask |= 1 << (irq - IRQ_KEV7A400_CPLD);
 	CPLD_WR_PB_INT_MASK = CPLD_IRQ_mask;
Index: linux-2.6/arch/arm/mach-lh7a40x/arch-lpd7a40x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/arch-lpd7a40x.c
+++ linux-2.6/arch/arm/mach-lh7a40x/arch-lpd7a40x.c
@@ -159,7 +159,7 @@ static void __init lpd7a40x_init (void)
 #endif
 }
 
-static void lh7a40x_ack_cpld_irq (u32 irq)
+static void lh7a40x_ack_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	/* CPLD doesn't have ack capability, but some devices may */
 
@@ -172,7 +172,7 @@ static void lh7a40x_ack_cpld_irq (u32 ir
 #endif
 }
 
-static void lh7a40x_mask_cpld_irq (u32 irq)
+static void lh7a40x_mask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
@@ -186,7 +186,7 @@ static void lh7a40x_mask_cpld_irq (u32 i
 	}
 }
 
-static void lh7a40x_unmask_cpld_irq (u32 irq)
+static void lh7a40x_unmask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
@@ -211,7 +211,7 @@ static void lpd7a40x_cpld_handler (unsig
 {
 	unsigned int mask = CPLD_INTERRUPTS;
 
-	desc->chip->ack (irq);
+	desc->chip->ack(irq, desc);
 
 	if ((mask & (1<<0)) == 0)	/* WLAN */
 		generic_handle_irq(IRQ_LPD7A40X_ETH_INT);
@@ -221,7 +221,7 @@ static void lpd7a40x_cpld_handler (unsig
 		generic_handle_irq(IRQ_TOUCH);
 #endif
 
-	desc->chip->unmask (irq); /* Level-triggered need this */
+	desc->chip->unmask(irq, desc); /* Level-triggered need this */
 }
 
 
Index: linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a400.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/irq-lh7a400.c
+++ linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a400.c
@@ -21,17 +21,17 @@
 
   /* CPU IRQ handling */
 
-static void lh7a400_mask_irq (u32 irq)
+static void lh7a400_mask_irq(u32 irq, struct irq_desc *desc)
 {
 	INTC_INTENC = (1 << irq);
 }
 
-static void lh7a400_unmask_irq (u32 irq)
+static void lh7a400_unmask_irq(u32 irq, struct irq_desc *desc)
 {
 	INTC_INTENS = (1 << irq);
 }
 
-static void lh7a400_ack_gpio_irq (u32 irq)
+static void lh7a400_ack_gpio_irq(u32 irq, struct irq_desc *desc)
 {
 	GPIO_GPIOFEOI = (1 << IRQ_TO_GPIO (irq));
 	INTC_INTENC = (1 << irq);
Index: linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a404.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/irq-lh7a404.c
+++ linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a404.c
@@ -43,33 +43,33 @@ static unsigned char irq_pri_vic2[] = {
 
   /* CPU IRQ handling */
 
-static void lh7a404_vic1_mask_irq (u32 irq)
+static void lh7a404_vic1_mask_irq(u32 irq, struct irq_desc *desc)
 {
 	VIC1_INTENCLR = (1 << irq);
 }
 
-static void lh7a404_vic1_unmask_irq (u32 irq)
+static void lh7a404_vic1_unmask_irq(u32 irq, struct irq_desc *desc)
 {
 	VIC1_INTEN = (1 << irq);
 }
 
-static void lh7a404_vic2_mask_irq (u32 irq)
+static void lh7a404_vic2_mask_irq(u32 irq, struct irq_desc *desc)
 {
 	VIC2_INTENCLR = (1 << (irq - 32));
 }
 
-static void lh7a404_vic2_unmask_irq (u32 irq)
+static void lh7a404_vic2_unmask_irq(u32 irq, struct irq_desc *desc)
 {
 	VIC2_INTEN = (1 << (irq - 32));
 }
 
-static void lh7a404_vic1_ack_gpio_irq (u32 irq)
+static void lh7a404_vic1_ack_gpio_irq(u32 irq, struct irq_desc *desc)
 {
 	GPIO_GPIOFEOI = (1 << IRQ_TO_GPIO (irq));
 	VIC1_INTENCLR = (1 << irq);
 }
 
-static void lh7a404_vic2_ack_gpio_irq (u32 irq)
+static void lh7a404_vic2_ack_gpio_irq(u32 irq, struct irq_desc *desc)
 {
 	GPIO_GPIOFEOI = (1 << IRQ_TO_GPIO (irq));
 	VIC2_INTENCLR = (1 << irq);
Index: linux-2.6/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
+++ linux-2.6/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
@@ -20,12 +20,12 @@
 
 #include "common.h"
 
-static void lh7a40x_ack_cpld_irq (u32 irq)
+static void lh7a40x_ack_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	/* CPLD doesn't have ack capability */
 }
 
-static void lh7a40x_mask_cpld_irq (u32 irq)
+static void lh7a40x_mask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
@@ -37,7 +37,7 @@ static void lh7a40x_mask_cpld_irq (u32 i
 	}
 }
 
-static void lh7a40x_unmask_cpld_irq (u32 irq)
+static void lh7a40x_unmask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
@@ -60,7 +60,7 @@ static void lh7a40x_cpld_handler (unsign
 {
 	unsigned int mask = CPLD_INTERRUPTS;
 
-	desc->chip->ack (irq);
+	desc->chip->ack(irq, desc);
 
 	if ((mask & 0x1) == 0)	/* WLAN */
 		generic_handle_irq(IRQ_LPD7A40X_ETH_INT);
@@ -68,7 +68,7 @@ static void lh7a40x_cpld_handler (unsign
 	if ((mask & 0x2) == 0)	/* Touch */
 		generic_handle_irq(IRQ_LPD7A400_TS);
 
-	desc->chip->unmask (irq); /* Level-triggered need this */
+	desc->chip->unmask(irq, desc); /* Level-triggered need this */
 }
 
 
Index: linux-2.6/arch/arm/mach-mmp/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-mmp/irq.c
+++ linux-2.6/arch/arm/mach-mmp/irq.c
@@ -25,12 +25,12 @@
 #define PRIORITY_DEFAULT	0x1
 #define PRIORITY_NONE		0x0	/* means IRQ disabled */
 
-static void icu_mask_irq(unsigned int irq)
+static void icu_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(PRIORITY_NONE, ICU_INT_CONF(irq));
 }
 
-static void icu_unmask_irq(unsigned int irq)
+static void icu_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(IRQ_ROUTE_TO_AP | PRIORITY_DEFAULT, ICU_INT_CONF(irq));
 }
Index: linux-2.6/arch/arm/mach-mx3/mx31ads.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-mx3/mx31ads.c
+++ linux-2.6/arch/arm/mach-mx3/mx31ads.c
@@ -142,7 +142,7 @@ static void mx31ads_expio_irq_handler(u3
  * Disable an expio pin's interrupt by setting the bit in the imr.
  * @param irq           an expio virtual irq number
  */
-static void expio_mask_irq(u32 irq)
+static void expio_mask_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 expio = MXC_IRQ_TO_EXPIO(irq);
 	/* mask the interrupt */
@@ -154,7 +154,7 @@ static void expio_mask_irq(u32 irq)
  * Acknowledge an expanded io pin's interrupt by clearing the bit in the isr.
  * @param irq           an expanded io virtual irq number
  */
-static void expio_ack_irq(u32 irq)
+static void expio_ack_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 expio = MXC_IRQ_TO_EXPIO(irq);
 	/* clear the interrupt status */
@@ -165,7 +165,7 @@ static void expio_ack_irq(u32 irq)
  * Enable a expio pin's interrupt by clearing the bit in the imr.
  * @param irq           a expio virtual irq number
  */
-static void expio_unmask_irq(u32 irq)
+static void expio_unmask_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 expio = MXC_IRQ_TO_EXPIO(irq);
 	/* unmask the interrupt */
Index: linux-2.6/arch/arm/mach-mx3/mx31pdk.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-mx3/mx31pdk.c
+++ linux-2.6/arch/arm/mach-mx3/mx31pdk.c
@@ -116,7 +116,7 @@ static void mx31pdk_expio_irq_handler(ui
  * Disable an expio pin's interrupt by setting the bit in the imr.
  * @param irq           an expio virtual irq number
  */
-static void expio_mask_irq(uint32_t irq)
+static void expio_mask_irq(uint32_t irq, struct irq_desc *desc)
 {
 	uint16_t reg;
 	uint32_t expio = MXC_IRQ_TO_EXPIO(irq);
@@ -131,7 +131,7 @@ static void expio_mask_irq(uint32_t irq)
  * Acknowledge an expanded io pin's interrupt by clearing the bit in the isr.
  * @param irq           an expanded io virtual irq number
  */
-static void expio_ack_irq(uint32_t irq)
+static void expio_ack_irq(uint32_t irq, struct irq_desc *desc)
 {
 	uint32_t expio = MXC_IRQ_TO_EXPIO(irq);
 
@@ -146,7 +146,7 @@ static void expio_ack_irq(uint32_t irq)
  * Enable a expio pin's interrupt by clearing the bit in the imr.
  * @param irq           a expio virtual irq number
  */
-static void expio_unmask_irq(uint32_t irq)
+static void expio_unmask_irq(uint32_t irq, struct irq_desc *desc)
 {
 	uint16_t reg;
 	uint32_t expio = MXC_IRQ_TO_EXPIO(irq);
Index: linux-2.6/arch/arm/mach-netx/generic.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-netx/generic.c
+++ linux-2.6/arch/arm/mach-netx/generic.c
@@ -119,7 +119,7 @@ netx_hif_irq_type(unsigned int _irq, uns
 }
 
 static void
-netx_hif_ack_irq(unsigned int _irq)
+netx_hif_ack_irq(unsigned int _irq, struct irq_desc *desc)
 {
 	unsigned int val, irq;
 
@@ -134,7 +134,7 @@ netx_hif_ack_irq(unsigned int _irq)
 }
 
 static void
-netx_hif_mask_irq(unsigned int _irq)
+netx_hif_mask_irq(unsigned int _irq, struct irq_desc *desc)
 {
 	unsigned int val, irq;
 
@@ -146,7 +146,7 @@ netx_hif_mask_irq(unsigned int _irq)
 }
 
 static void
-netx_hif_unmask_irq(unsigned int _irq)
+netx_hif_unmask_irq(unsigned int _irq, struct irq_desc *desc)
 {
 	unsigned int val, irq;
 
Index: linux-2.6/arch/arm/mach-nomadik/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-nomadik/gpio.c
+++ linux-2.6/arch/arm/mach-nomadik/gpio.c
@@ -95,7 +95,7 @@ static inline int nmk_gpio_get_bitmask(i
 	return 1 << (gpio % 32);
 }
 
-static void nmk_gpio_irq_ack(unsigned int irq)
+static void nmk_gpio_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
@@ -107,7 +107,7 @@ static void nmk_gpio_irq_ack(unsigned in
 	writel(nmk_gpio_get_bitmask(gpio), nmk_chip->addr + NMK_GPIO_IC);
 }
 
-static void nmk_gpio_irq_mask(unsigned int irq)
+static void nmk_gpio_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
@@ -135,7 +135,7 @@ static void nmk_gpio_irq_mask(unsigned i
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
 };
 
-static void nmk_gpio_irq_unmask(unsigned int irq)
+static void nmk_gpio_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
Index: linux-2.6/arch/arm/mach-ns9xxx/board-a9m9750dev.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/board-a9m9750dev.c
+++ linux-2.6/arch/arm/mach-ns9xxx/board-a9m9750dev.c
@@ -37,12 +37,12 @@ void __init board_a9m9750dev_map_io(void
 		     ARRAY_SIZE(board_a9m9750dev_io_desc));
 }
 
-static void a9m9750dev_fpga_ack_irq(unsigned int irq)
+static void a9m9750dev_fpga_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* nothing */
 }
 
-static void a9m9750dev_fpga_mask_irq(unsigned int irq)
+static void a9m9750dev_fpga_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u8 ier;
 
@@ -53,13 +53,13 @@ static void a9m9750dev_fpga_mask_irq(uns
 	__raw_writeb(ier, FPGA_IER);
 }
 
-static void a9m9750dev_fpga_maskack_irq(unsigned int irq)
+static void a9m9750dev_fpga_maskack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	a9m9750dev_fpga_mask_irq(irq);
 	a9m9750dev_fpga_ack_irq(irq);
 }
 
-static void a9m9750dev_fpga_unmask_irq(unsigned int irq)
+static void a9m9750dev_fpga_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u8 ier;
 
@@ -82,7 +82,7 @@ static void a9m9750dev_fpga_demux_handle
 {
 	u8 stat = __raw_readb(FPGA_ISR);
 
-	desc->chip->mask_ack(irq);
+	desc->chip->mask_ack(irq, desc);
 
 	while (stat != 0) {
 		int irqno = fls(stat) - 1;
@@ -92,7 +92,7 @@ static void a9m9750dev_fpga_demux_handle
 		generic_handle_irq(FPGA_IRQ(irqno));
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 void __init board_a9m9750dev_init_irq(void)
Index: linux-2.6/arch/arm/mach-ns9xxx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/irq.c
+++ linux-2.6/arch/arm/mach-ns9xxx/irq.c
@@ -22,7 +22,7 @@
 #define irq2prio(i) (i)
 #define prio2irq(p) (p)
 
-static void ns9xxx_mask_irq(unsigned int irq)
+static void ns9xxx_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* XXX: better use cpp symbols */
 	int prio = irq2prio(irq);
@@ -31,18 +31,18 @@ static void ns9xxx_mask_irq(unsigned int
 	__raw_writel(ic, SYS_IC(prio / 4));
 }
 
-static void ns9xxx_ack_irq(unsigned int irq)
+static void ns9xxx_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(0, SYS_ISRADDR);
 }
 
-static void ns9xxx_maskack_irq(unsigned int irq)
+static void ns9xxx_maskack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	ns9xxx_mask_irq(irq);
 	ns9xxx_ack_irq(irq);
 }
 
-static void ns9xxx_unmask_irq(unsigned int irq)
+static void ns9xxx_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* XXX: better use cpp symbols */
 	int prio = irq2prio(irq);
@@ -92,10 +92,10 @@ static void handle_prio_irq(unsigned int
 
 	if (desc->status & IRQ_DISABLED)
 out_mask:
-		desc->chip->mask(irq);
+		desc->chip->mask(irq, desc);
 
 	/* ack unconditionally to unmask lower prio irqs */
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 
 	raw_spin_unlock(&desc->lock);
 }
Index: linux-2.6/arch/arm/mach-omap1/fpga.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/fpga.c
+++ linux-2.6/arch/arm/mach-omap1/fpga.c
@@ -30,7 +30,7 @@
 #include <plat/fpga.h>
 #include <mach/gpio.h>
 
-static void fpga_mask_irq(unsigned int irq)
+static void fpga_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= OMAP_FPGA_IRQ_BASE;
 
@@ -58,12 +58,12 @@ static inline u32 get_fpga_unmasked_irqs
 }
 
 
-static void fpga_ack_irq(unsigned int irq)
+static void fpga_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* Don't need to explicitly ACK FPGA interrupts */
 }
 
-static void fpga_unmask_irq(unsigned int irq)
+static void fpga_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= OMAP_FPGA_IRQ_BASE;
 
@@ -78,7 +78,7 @@ static void fpga_unmask_irq(unsigned int
 			      | (1 << (irq - 16))), INNOVATOR_FPGA_IMR2);
 }
 
-static void fpga_mask_ack_irq(unsigned int irq)
+static void fpga_mask_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	fpga_mask_irq(irq);
 	fpga_ack_irq(irq);
Index: linux-2.6/arch/arm/mach-omap1/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/irq.c
+++ linux-2.6/arch/arm/mach-omap1/irq.c
@@ -70,7 +70,7 @@ static inline void irq_bank_writel(unsig
 	omap_writel(value, irq_banks[bank].base_reg + offset);
 }
 
-static void omap_ack_irq(unsigned int irq)
+static void omap_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	if (irq > 31)
 		omap_writel(0x1, OMAP_IH2_BASE + IRQ_CONTROL_REG_OFFSET);
@@ -78,7 +78,7 @@ static void omap_ack_irq(unsigned int ir
 	omap_writel(0x1, OMAP_IH1_BASE + IRQ_CONTROL_REG_OFFSET);
 }
 
-static void omap_mask_irq(unsigned int irq)
+static void omap_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int bank = IRQ_BANK(irq);
 	u32 l;
@@ -88,7 +88,7 @@ static void omap_mask_irq(unsigned int i
 	omap_writel(l, irq_banks[bank].base_reg + IRQ_MIR_REG_OFFSET);
 }
 
-static void omap_unmask_irq(unsigned int irq)
+static void omap_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int bank = IRQ_BANK(irq);
 	u32 l;
@@ -98,10 +98,10 @@ static void omap_unmask_irq(unsigned int
 	omap_writel(l, irq_banks[bank].base_reg + IRQ_MIR_REG_OFFSET);
 }
 
-static void omap_mask_ack_irq(unsigned int irq)
+static void omap_mask_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
-	omap_mask_irq(irq);
-	omap_ack_irq(irq);
+	omap_mask_irq(irq, desc);
+	omap_ack_irq(irq, desc);
 }
 
 static int omap_wake_irq(unsigned int irq, unsigned int enable)
Index: linux-2.6/arch/arm/mach-pnx4008/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pnx4008/irq.c
+++ linux-2.6/arch/arm/mach-pnx4008/irq.c
@@ -36,17 +36,17 @@
 
 static u8 pnx4008_irq_type[NR_IRQS] = PNX4008_IRQ_TYPES;
 
-static void pnx4008_mask_irq(unsigned int irq)
+static void pnx4008_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(__raw_readl(INTC_ER(irq)) & ~INTC_BIT(irq), INTC_ER(irq));	/* mask interrupt */
 }
 
-static void pnx4008_unmask_irq(unsigned int irq)
+static void pnx4008_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(__raw_readl(INTC_ER(irq)) | INTC_BIT(irq), INTC_ER(irq));	/* unmask interrupt */
 }
 
-static void pnx4008_mask_ack_irq(unsigned int irq)
+static void pnx4008_mask_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(__raw_readl(INTC_ER(irq)) & ~INTC_BIT(irq), INTC_ER(irq));	/* mask interrupt */
 	__raw_writel(INTC_BIT(irq), INTC_SR(irq));	/* clear interrupt status */
Index: linux-2.6/arch/arm/mach-pxa/balloon3.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/balloon3.c
+++ linux-2.6/arch/arm/mach-pxa/balloon3.c
@@ -73,14 +73,14 @@ int __init parse_balloon3_features(char
 }
 early_param("balloon3_features", parse_balloon3_features);
 
-static void balloon3_mask_irq(unsigned int irq)
+static void balloon3_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int balloon3_irq = (irq - BALLOON3_IRQ(0));
 	balloon3_irq_enabled &= ~(1 << balloon3_irq);
 	__raw_writel(~balloon3_irq_enabled, BALLOON3_INT_CONTROL_REG);
 }
 
-static void balloon3_unmask_irq(unsigned int irq)
+static void balloon3_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int balloon3_irq = (irq - BALLOON3_IRQ(0));
 	balloon3_irq_enabled |= (1 << balloon3_irq);
@@ -102,7 +102,7 @@ static void balloon3_irq_handler(unsigne
 	do {
 		/* clear useless edge notification */
 		if (desc->chip->ack)
-			desc->chip->ack(BALLOON3_AUX_NIRQ);
+			desc->chip->ack(BALLOON3_AUX_NIRQ, irq_to_desc(BALLOON3_AUX_NIRQ));
 		while (pending) {
 			irq = BALLOON3_IRQ(0) + __ffs(pending);
 			generic_handle_irq(irq);
Index: linux-2.6/arch/arm/mach-pxa/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/irq.c
+++ linux-2.6/arch/arm/mach-pxa/irq.c
@@ -37,12 +37,12 @@
 
 static int pxa_internal_irq_nr;
 
-static void pxa_mask_irq(unsigned int irq)
+static void pxa_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	_ICMR(irq) &= ~(1 << IRQ_BIT(irq));
 }
 
-static void pxa_unmask_irq(unsigned int irq)
+static void pxa_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	_ICMR(irq) |= 1 << IRQ_BIT(irq);
 }
@@ -79,17 +79,17 @@ static int pxa_set_low_gpio_type(unsigne
 	return 0;
 }
 
-static void pxa_ack_low_gpio(unsigned int irq)
+static void pxa_ack_low_gpio(unsigned int irq, struct irq_desc *desc)
 {
 	GEDR0 = (1 << (irq - IRQ_GPIO0));
 }
 
-static void pxa_mask_low_gpio(unsigned int irq)
+static void pxa_mask_low_gpio(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR &= ~(1 << (irq - PXA_IRQ(0)));
 }
 
-static void pxa_unmask_low_gpio(unsigned int irq)
+static void pxa_unmask_low_gpio(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR |= 1 << (irq - PXA_IRQ(0));
 }
Index: linux-2.6/arch/arm/mach-pxa/lpd270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lpd270.c
+++ linux-2.6/arch/arm/mach-pxa/lpd270.c
@@ -90,7 +90,7 @@ static unsigned long lpd270_pin_config[]
 
 static unsigned int lpd270_irq_enabled;
 
-static void lpd270_mask_irq(unsigned int irq)
+static void lpd270_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int lpd270_irq = irq - LPD270_IRQ(0);
 
@@ -100,7 +100,7 @@ static void lpd270_mask_irq(unsigned int
 	__raw_writew(lpd270_irq_enabled, LPD270_INT_MASK);
 }
 
-static void lpd270_unmask_irq(unsigned int irq)
+static void lpd270_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int lpd270_irq = irq - LPD270_IRQ(0);
 
Index: linux-2.6/arch/arm/mach-pxa/lubbock.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lubbock.c
+++ linux-2.6/arch/arm/mach-pxa/lubbock.c
@@ -133,13 +133,13 @@ EXPORT_SYMBOL(lubbock_set_misc_wr);
 
 static unsigned long lubbock_irq_enabled;
 
-static void lubbock_mask_irq(unsigned int irq)
+static void lubbock_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int lubbock_irq = (irq - LUBBOCK_IRQ(0));
 	LUB_IRQ_MASK_EN = (lubbock_irq_enabled &= ~(1 << lubbock_irq));
 }
 
-static void lubbock_unmask_irq(unsigned int irq)
+static void lubbock_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int lubbock_irq = (irq - LUBBOCK_IRQ(0));
 	/* the irq can be acknowledged only if deasserted, so it's done here */
Index: linux-2.6/arch/arm/mach-pxa/mainstone.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mainstone.c
+++ linux-2.6/arch/arm/mach-pxa/mainstone.c
@@ -137,13 +137,13 @@ static unsigned long mainstone_pin_confi
 
 static unsigned long mainstone_irq_enabled;
 
-static void mainstone_mask_irq(unsigned int irq)
+static void mainstone_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int mainstone_irq = (irq - MAINSTONE_IRQ(0));
 	MST_INTMSKENA = (mainstone_irq_enabled &= ~(1 << mainstone_irq));
 }
 
-static void mainstone_unmask_irq(unsigned int irq)
+static void mainstone_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int mainstone_irq = (irq - MAINSTONE_IRQ(0));
 	/* the irq can be acknowledged only if deasserted, so it's done here */
Index: linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pcm990-baseboard.c
+++ linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -235,13 +235,13 @@ static struct platform_device pcm990_bac
 
 static unsigned long pcm990_irq_enabled;
 
-static void pcm990_mask_ack_irq(unsigned int irq)
+static void pcm990_mask_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int pcm990_irq = (irq - PCM027_IRQ(0));
 	PCM990_INTMSKENA = (pcm990_irq_enabled &= ~(1 << pcm990_irq));
 }
 
-static void pcm990_unmask_irq(unsigned int irq)
+static void pcm990_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int pcm990_irq = (irq - PCM027_IRQ(0));
 	/* the irq can be acknowledged only if deasserted, so it's done here */
Index: linux-2.6/arch/arm/mach-pxa/pxa3xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pxa3xx.c
+++ linux-2.6/arch/arm/mach-pxa/pxa3xx.c
@@ -536,18 +536,18 @@ static inline void pxa3xx_init_pm(void)
 #define pxa3xx_set_wake	NULL
 #endif
 
-static void pxa_ack_ext_wakeup(unsigned int irq)
+static void pxa_ack_ext_wakeup(unsigned int irq, struct irq_desc *desc)
 {
 	PECR |= PECR_IS(irq - IRQ_WAKEUP0);
 }
 
-static void pxa_mask_ext_wakeup(unsigned int irq)
+static void pxa_mask_ext_wakeup(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR2 &= ~(1 << ((irq - PXA_IRQ(0)) & 0x1f));
 	PECR &= ~PECR_IE(irq - IRQ_WAKEUP0);
 }
 
-static void pxa_unmask_ext_wakeup(unsigned int irq)
+static void pxa_unmask_ext_wakeup(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR2 |= 1 << ((irq - PXA_IRQ(0)) & 0x1f);
 	PECR |= PECR_IE(irq - IRQ_WAKEUP0);
Index: linux-2.6/arch/arm/mach-pxa/viper.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/viper.c
+++ linux-2.6/arch/arm/mach-pxa/viper.c
@@ -247,7 +247,7 @@ static inline int viper_bit_to_irq(int b
 	return viper_isa_irqs[bit] + PXA_ISA_IRQ(0);
 }
 
-static void viper_ack_irq(unsigned int irq)
+static void viper_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	int viper_irq = viper_irq_to_bitmask(irq);
 
@@ -257,12 +257,12 @@ static void viper_ack_irq(unsigned int i
 		VIPER_HI_IRQ_STATUS = (viper_irq >> 8);
 }
 
-static void viper_mask_irq(unsigned int irq)
+static void viper_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	viper_irq_enabled_mask &= ~(viper_irq_to_bitmask(irq));
 }
 
-static void viper_unmask_irq(unsigned int irq)
+static void viper_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	viper_irq_enabled_mask |= viper_irq_to_bitmask(irq);
 }
Index: linux-2.6/arch/arm/mach-pxa/zeus.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/zeus.c
+++ linux-2.6/arch/arm/mach-pxa/zeus.c
@@ -81,17 +81,17 @@ static inline int zeus_bit_to_irq(int bi
 	return zeus_isa_irqs[bit] + PXA_ISA_IRQ(0);
 }
 
-static void zeus_ack_irq(unsigned int irq)
+static void zeus_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writew(zeus_irq_to_bitmask(irq), ZEUS_CPLD_ISA_IRQ);
 }
 
-static void zeus_mask_irq(unsigned int irq)
+static void zeus_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	zeus_irq_enabled_mask &= ~(zeus_irq_to_bitmask(irq));
 }
 
-static void zeus_unmask_irq(unsigned int irq)
+static void zeus_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	zeus_irq_enabled_mask |= zeus_irq_to_bitmask(irq);
 }
@@ -109,7 +109,7 @@ static void zeus_irq_handler(unsigned in
 	do {
 		/* we're in a chained irq handler,
 		 * so ack the interrupt by hand */
-		desc->chip->ack(gpio_to_irq(ZEUS_ISA_GPIO));
+		desc->chip->ack(gpio_to_irq(ZEUS_ISA_GPIO), irq_to_desc(gipo_to_irq(ZEUS_ISA_GPIO));
 
 		if (likely(pending)) {
 			irq = zeus_bit_to_irq(__ffs(pending));
Index: linux-2.6/arch/arm/mach-rpc/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-rpc/irq.c
+++ linux-2.6/arch/arm/mach-rpc/irq.c
@@ -6,7 +6,7 @@
 #include <asm/hardware/iomd.h>
 #include <asm/irq.h>
 
-static void iomd_ack_irq_a(unsigned int irq)
+static void iomd_ack_irq_a(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -16,7 +16,7 @@ static void iomd_ack_irq_a(unsigned int
 	iomd_writeb(mask, IOMD_IRQCLRA);
 }
 
-static void iomd_mask_irq_a(unsigned int irq)
+static void iomd_mask_irq_a(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -25,7 +25,7 @@ static void iomd_mask_irq_a(unsigned int
 	iomd_writeb(val & ~mask, IOMD_IRQMASKA);
 }
 
-static void iomd_unmask_irq_a(unsigned int irq)
+static void iomd_unmask_irq_a(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -40,7 +40,7 @@ static struct irq_chip iomd_a_chip = {
 	.unmask = iomd_unmask_irq_a,
 };
 
-static void iomd_mask_irq_b(unsigned int irq)
+static void iomd_mask_irq_b(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -49,7 +49,7 @@ static void iomd_mask_irq_b(unsigned int
 	iomd_writeb(val & ~mask, IOMD_IRQMASKB);
 }
 
-static void iomd_unmask_irq_b(unsigned int irq)
+static void iomd_unmask_irq_b(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -64,7 +64,7 @@ static struct irq_chip iomd_b_chip = {
 	.unmask = iomd_unmask_irq_b,
 };
 
-static void iomd_mask_irq_dma(unsigned int irq)
+static void iomd_mask_irq_dma(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -73,7 +73,7 @@ static void iomd_mask_irq_dma(unsigned i
 	iomd_writeb(val & ~mask, IOMD_DMAMASK);
 }
 
-static void iomd_unmask_irq_dma(unsigned int irq)
+static void iomd_unmask_irq_dma(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -88,7 +88,7 @@ static struct irq_chip iomd_dma_chip = {
 	.unmask = iomd_unmask_irq_dma,
 };
 
-static void iomd_mask_irq_fiq(unsigned int irq)
+static void iomd_mask_irq_fiq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
@@ -97,7 +97,7 @@ static void iomd_mask_irq_fiq(unsigned i
 	iomd_writeb(val & ~mask, IOMD_FIQMASK);
 }
 
-static void iomd_unmask_irq_fiq(unsigned int irq)
+static void iomd_unmask_irq_fiq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int val, mask;
 
Index: linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/bast-irq.c
+++ linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
@@ -75,7 +75,7 @@ static unsigned char bast_pc104_irqmasks
 static unsigned char bast_pc104_irqs[] = { 3, 5, 7, 10 };
 
 static void
-bast_pc104_mask(unsigned int irqno)
+bast_pc104_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long temp;
 
@@ -85,16 +85,14 @@ bast_pc104_mask(unsigned int irqno)
 }
 
 static void
-bast_pc104_maskack(unsigned int irqno)
+bast_pc104_maskack(unsigned int irqno, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc + IRQ_ISA;
-
 	bast_pc104_mask(irqno);
-	desc->chip->ack(IRQ_ISA);
+	desc->chip->ack(IRQ_ISA, desc);
 }
 
 static void
-bast_pc104_unmask(unsigned int irqno)
+bast_pc104_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long temp;
 
@@ -123,7 +121,7 @@ bast_irq_pc104_demux(unsigned int irq,
 		/* ack if we get an irq with nothing (ie, startup) */
 
 		desc = irq_desc + IRQ_ISA;
-		desc->chip->ack(IRQ_ISA);
+		desc->chip->ack(IRQ_ISA, desc);
 	} else {
 		/* handle the IRQ */
 
Index: linux-2.6/arch/arm/mach-s3c2412/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2412/irq.c
+++ linux-2.6/arch/arm/mach-s3c2412/irq.c
@@ -49,7 +49,7 @@
 */
 
 static void
-s3c2412_irq_mask(unsigned int irqno)
+s3c2412_irq_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
 	unsigned long mask;
@@ -62,7 +62,7 @@ s3c2412_irq_mask(unsigned int irqno)
 }
 
 static inline void
-s3c2412_irq_ack(unsigned int irqno)
+s3c2412_irq_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
 
@@ -72,7 +72,7 @@ s3c2412_irq_ack(unsigned int irqno)
 }
 
 static inline void
-s3c2412_irq_maskack(unsigned int irqno)
+s3c2412_irq_maskack(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
 	unsigned long mask;
@@ -89,7 +89,7 @@ s3c2412_irq_maskack(unsigned int irqno)
 }
 
 static void
-s3c2412_irq_unmask(unsigned int irqno)
+s3c2412_irq_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
 	unsigned long mask;
@@ -132,17 +132,17 @@ static void s3c2412_irq_demux_cfsdi(unsi
 #define INTMSK_CFSDI	(1UL << (IRQ_S3C2412_CFSDI - IRQ_EINT0))
 #define SUBMSK_CFSDI	INTMSK_SUB(IRQ_S3C2412_SDI, IRQ_S3C2412_CF)
 
-static void s3c2412_irq_cfsdi_mask(unsigned int irqno)
+static void s3c2412_irq_cfsdi_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_CFSDI, SUBMSK_CFSDI);
 }
 
-static void s3c2412_irq_cfsdi_unmask(unsigned int irqno)
+static void s3c2412_irq_cfsdi_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_CFSDI);
 }
 
-static void s3c2412_irq_cfsdi_ack(unsigned int irqno)
+static void s3c2412_irq_cfsdi_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_CFSDI, SUBMSK_CFSDI);
 }
Index: linux-2.6/arch/arm/mach-s3c2440/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/irq.c
+++ linux-2.6/arch/arm/mach-s3c2440/irq.c
@@ -69,19 +69,19 @@ static void s3c_irq_demux_wdtac97(unsign
 #define INTMSK_WDT	 (1UL << (IRQ_WDT - IRQ_EINT0))
 
 static void
-s3c_irq_wdtac97_mask(unsigned int irqno)
+s3c_irq_wdtac97_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_WDT, 3<<13);
 }
 
 static void
-s3c_irq_wdtac97_unmask(unsigned int irqno)
+s3c_irq_wdtac97_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_WDT);
 }
 
 static void
-s3c_irq_wdtac97_ack(unsigned int irqno)
+s3c_irq_wdtac97_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_WDT, 3<<13);
 }
Index: linux-2.6/arch/arm/mach-s3c2443/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2443/irq.c
+++ linux-2.6/arch/arm/mach-s3c2443/irq.c
@@ -75,17 +75,17 @@ static void s3c2443_irq_demux_wdtac97(un
 #define INTMSK_WDTAC97	(1UL << (IRQ_WDT - IRQ_EINT0))
 #define SUBMSK_WDTAC97	INTMSK(IRQ_S3C2443_WDT, IRQ_S3C2443_AC97)
 
-static void s3c2443_irq_wdtac97_mask(unsigned int irqno)
+static void s3c2443_irq_wdtac97_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_WDTAC97, SUBMSK_WDTAC97);
 }
 
-static void s3c2443_irq_wdtac97_unmask(unsigned int irqno)
+static void s3c2443_irq_wdtac97_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_WDTAC97);
 }
 
-static void s3c2443_irq_wdtac97_ack(unsigned int irqno)
+static void s3c2443_irq_wdtac97_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_WDTAC97, SUBMSK_WDTAC97);
 }
@@ -107,17 +107,17 @@ static void s3c2443_irq_demux_lcd(unsign
 #define INTMSK_LCD	(1UL << (IRQ_LCD - IRQ_EINT0))
 #define SUBMSK_LCD	INTMSK(IRQ_S3C2443_LCD1, IRQ_S3C2443_LCD4)
 
-static void s3c2443_irq_lcd_mask(unsigned int irqno)
+static void s3c2443_irq_lcd_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_LCD, SUBMSK_LCD);
 }
 
-static void s3c2443_irq_lcd_unmask(unsigned int irqno)
+static void s3c2443_irq_lcd_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_LCD);
 }
 
-static void s3c2443_irq_lcd_ack(unsigned int irqno)
+static void s3c2443_irq_lcd_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_LCD, SUBMSK_LCD);
 }
@@ -140,17 +140,17 @@ static void s3c2443_irq_demux_dma(unsign
 #define SUBMSK_DMA	INTMSK(IRQ_S3C2443_DMA0, IRQ_S3C2443_DMA5)
 
 
-static void s3c2443_irq_dma_mask(unsigned int irqno)
+static void s3c2443_irq_dma_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_DMA, SUBMSK_DMA);
 }
 
-static void s3c2443_irq_dma_unmask(unsigned int irqno)
+static void s3c2443_irq_dma_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_DMA);
 }
 
-static void s3c2443_irq_dma_ack(unsigned int irqno)
+static void s3c2443_irq_dma_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_DMA, SUBMSK_DMA);
 }
@@ -173,17 +173,17 @@ static void s3c2443_irq_demux_uart3(unsi
 #define SUBMSK_UART3	(0xf << (IRQ_S3C2443_RX3 - S3C2410_IRQSUB(0)))
 
 
-static void s3c2443_irq_uart3_mask(unsigned int irqno)
+static void s3c2443_irq_uart3_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_UART3, SUBMSK_UART3);
 }
 
-static void s3c2443_irq_uart3_unmask(unsigned int irqno)
+static void s3c2443_irq_uart3_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_UART3);
 }
 
-static void s3c2443_irq_uart3_ack(unsigned int irqno)
+static void s3c2443_irq_uart3_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_UART3, SUBMSK_UART3);
 }
@@ -205,17 +205,17 @@ static void s3c2443_irq_demux_cam(unsign
 #define INTMSK_CAM	(1UL << (IRQ_CAM - IRQ_EINT0))
 #define SUBMSK_CAM	INTMSK(IRQ_S3C2440_CAM_C, IRQ_S3C2440_CAM_P)
 
-static void s3c2443_irq_cam_mask(unsigned int irqno)
+static void s3c2443_irq_cam_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_CAM, SUBMSK_CAM);
 }
 
-static void s3c2443_irq_cam_unmask(unsigned int irqno)
+static void s3c2443_irq_cam_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_CAM);
 }
 
-static void s3c2443_irq_cam_ack(unsigned int irqno)
+static void s3c2443_irq_cam_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_CAM, SUBMSK_CAM);
 }
Index: linux-2.6/arch/arm/mach-sa1100/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/irq.c
+++ linux-2.6/arch/arm/mach-sa1100/irq.c
@@ -70,17 +70,17 @@ static int sa1100_gpio_type(unsigned int
 /*
  * GPIO IRQs must be acknowledged.  This is for IRQs from 0 to 10.
  */
-static void sa1100_low_gpio_ack(unsigned int irq)
+static void sa1100_low_gpio_ack(unsigned int irq, struct irq_desc *desc)
 {
 	GEDR = (1 << irq);
 }
 
-static void sa1100_low_gpio_mask(unsigned int irq)
+static void sa1100_low_gpio_mask(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR &= ~(1 << irq);
 }
 
-static void sa1100_low_gpio_unmask(unsigned int irq)
+static void sa1100_low_gpio_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR |= 1 << irq;
 }
@@ -139,14 +139,14 @@ sa1100_high_gpio_handler(unsigned int ir
  * In addition, the IRQs are all collected up into one bit in the
  * interrupt controller registers.
  */
-static void sa1100_high_gpio_ack(unsigned int irq)
+static void sa1100_high_gpio_ack(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = GPIO11_27_MASK(irq);
 
 	GEDR = mask;
 }
 
-static void sa1100_high_gpio_mask(unsigned int irq)
+static void sa1100_high_gpio_mask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = GPIO11_27_MASK(irq);
 
@@ -156,7 +156,7 @@ static void sa1100_high_gpio_mask(unsign
 	GFER &= ~mask;
 }
 
-static void sa1100_high_gpio_unmask(unsigned int irq)
+static void sa1100_high_gpio_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = GPIO11_27_MASK(irq);
 
@@ -188,12 +188,12 @@ static struct irq_chip sa1100_high_gpio_
  * We don't need to ACK IRQs on the SA1100 unless they're GPIOs
  * this is for internal IRQs i.e. from 11 to 31.
  */
-static void sa1100_mask_irq(unsigned int irq)
+static void sa1100_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR &= ~(1 << irq);
 }
 
-static void sa1100_unmask_irq(unsigned int irq)
+static void sa1100_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	ICMR |= (1 << irq);
 }
Index: linux-2.6/arch/arm/mach-sa1100/neponset.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/neponset.c
+++ linux-2.6/arch/arm/mach-sa1100/neponset.c
@@ -36,7 +36,7 @@ neponset_irq_handler(unsigned int irq, s
 		/*
 		 * Acknowledge the parent IRQ.
 		 */
-		desc->chip->ack(irq);
+		desc->chip->ack(irq, desc);
 
 		/*
 		 * Read the interrupt reason register.  Let's have all
@@ -54,7 +54,7 @@ neponset_irq_handler(unsigned int irq, s
 		 * recheck the register for any pending IRQs.
 		 */
 		if (irr & (IRR_ETHERNET | IRR_USAR)) {
-			desc->chip->mask(irq);
+			desc->chip->mask(irq, desc);
 
 			/*
 			 * Ack the interrupt now to prevent re-entering
@@ -62,7 +62,7 @@ neponset_irq_handler(unsigned int irq, s
 			 * since we'll check the IRR register prior to
 			 * leaving.
 			 */
-			desc->chip->ack(irq);
+			desc->chip->ack(irq, desc);
 
 			if (irr & IRR_ETHERNET) {
 				generic_handle_irq(IRQ_NEPONSET_SMC9196);
@@ -72,7 +72,7 @@ neponset_irq_handler(unsigned int irq, s
 				generic_handle_irq(IRQ_NEPONSET_USAR);
 			}
 
-			desc->chip->unmask(irq);
+			desc->chip->unmask(irq, desc);
 		}
 
 		if (irr & IRR_SA1111) {
Index: linux-2.6/arch/arm/mach-shark/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shark/irq.c
+++ linux-2.6/arch/arm/mach-shark/irq.c
@@ -30,7 +30,7 @@ static unsigned char cached_irq_mask[2]
  * These have to be protected by the irq controller spinlock
  * before being called.
  */
-static void shark_disable_8259A_irq(unsigned int irq)
+static void shark_disable_8259A_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 	if (irq<8) {
@@ -44,7 +44,7 @@ static void shark_disable_8259A_irq(unsi
 	}
 }
 
-static void shark_enable_8259A_irq(unsigned int irq)
+static void shark_enable_8259A_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 	if (irq<8) {
@@ -58,7 +58,9 @@ static void shark_enable_8259A_irq(unsig
 	}
 }
 
-static void shark_ack_8259A_irq(unsigned int irq){}
+static void shark_ack_8259A_irq(unsigned int irq, struct irq_desc *desc)
+{
+}
 
 static irqreturn_t bogus_int(int irq, void *dev_id)
 {
Index: linux-2.6/arch/arm/mach-stmp378x/stmp378x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-stmp378x/stmp378x.c
+++ linux-2.6/arch/arm/mach-stmp378x/stmp378x.c
@@ -47,7 +47,7 @@
 /*
  * IRQ handling
  */
-static void stmp378x_ack_irq(unsigned int irq)
+static void stmp378x_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* Tell ICOLL to release IRQ line */
 	__raw_writel(0, REGS_ICOLL_BASE + HW_ICOLL_VECTOR);
@@ -60,14 +60,14 @@ static void stmp378x_ack_irq(unsigned in
 	(void)__raw_readl(REGS_ICOLL_BASE + HW_ICOLL_STAT);
 }
 
-static void stmp378x_mask_irq(unsigned int irq)
+static void stmp378x_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* IRQ disable */
 	stmp3xxx_clearl(BM_ICOLL_INTERRUPTn_ENABLE,
 			REGS_ICOLL_BASE + HW_ICOLL_INTERRUPTn + irq * 0x10);
 }
 
-static void stmp378x_unmask_irq(unsigned int irq)
+static void stmp378x_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* IRQ enable */
 	stmp3xxx_setl(BM_ICOLL_INTERRUPTn_ENABLE,
Index: linux-2.6/arch/arm/mach-stmp37xx/stmp37xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-stmp37xx/stmp37xx.c
+++ linux-2.6/arch/arm/mach-stmp37xx/stmp37xx.c
@@ -43,7 +43,7 @@
 /*
  * IRQ handling
  */
-static void stmp37xx_ack_irq(unsigned int irq)
+static void stmp37xx_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* Disable IRQ */
 	stmp3xxx_clearl(0x04 << ((irq % 4) * 8),
@@ -56,14 +56,14 @@ static void stmp37xx_ack_irq(unsigned in
 	(void)__raw_readl(REGS_ICOLL_BASE + HW_ICOLL_STAT);
 }
 
-static void stmp37xx_mask_irq(unsigned int irq)
+static void stmp37xx_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* IRQ disable */
 	stmp3xxx_clearl(0x04 << ((irq % 4) * 8),
 		REGS_ICOLL_BASE + HW_ICOLL_PRIORITYn + irq / 4 * 0x10);
 }
 
-static void stmp37xx_unmask_irq(unsigned int irq)
+static void stmp37xx_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* IRQ enable */
 	stmp3xxx_setl(0x04 << ((irq % 4) * 8),
Index: linux-2.6/arch/arm/mach-versatile/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-versatile/core.c
+++ linux-2.6/arch/arm/mach-versatile/core.c
@@ -62,13 +62,13 @@
 #define VA_VIC_BASE		__io_address(VERSATILE_VIC_BASE)
 #define VA_SIC_BASE		__io_address(VERSATILE_SIC_BASE)
 
-static void sic_mask_irq(unsigned int irq)
+static void sic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_SIC_START;
 	writel(1 << irq, VA_SIC_BASE + SIC_IRQ_ENABLE_CLEAR);
 }
 
-static void sic_unmask_irq(unsigned int irq)
+static void sic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= IRQ_SIC_START;
 	writel(1 << irq, VA_SIC_BASE + SIC_IRQ_ENABLE_SET);
Index: linux-2.6/arch/arm/mach-w90x900/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-w90x900/irq.c
+++ linux-2.6/arch/arm/mach-w90x900/irq.c
@@ -92,7 +92,7 @@ static void nuc900_group_enable(struct g
 	__raw_writel(regval, REG_AIC_GEN);
 }
 
-static void nuc900_irq_mask(unsigned int irq)
+static void nuc900_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	struct group_irq *group_irq;
 
@@ -143,12 +143,12 @@ static void nuc900_irq_mask(unsigned int
  * to REG_AIC_EOSCR for ACK
  */
 
-static void nuc900_irq_ack(unsigned int irq)
+static void nuc900_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(0x01, REG_AIC_EOSCR);
 }
 
-static void nuc900_irq_unmask(unsigned int irq)
+static void nuc900_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct group_irq *group_irq;
 
Index: linux-2.6/arch/arm/plat-mxc/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/gpio.c
+++ linux-2.6/arch/arm/plat-mxc/gpio.c
@@ -63,19 +63,19 @@ static void _set_gpio_irqenable(struct m
 	__raw_writel(l, port->base + GPIO_IMR);
 }
 
-static void gpio_ack_irq(u32 irq)
+static void gpio_ack_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 gpio = irq_to_gpio(irq);
 	_clear_gpio_irqstatus(&mxc_gpio_ports[gpio / 32], gpio & 0x1f);
 }
 
-static void gpio_mask_irq(u32 irq)
+static void gpio_mask_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 gpio = irq_to_gpio(irq);
 	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 0);
 }
 
-static void gpio_unmask_irq(u32 irq)
+static void gpio_unmask_irq(u32 irq, struct irq_desc *desc)
 {
 	u32 gpio = irq_to_gpio(irq);
 	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 1);
Index: linux-2.6/arch/arm/plat-mxc/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/irq.c
+++ linux-2.6/arch/arm/plat-mxc/irq.c
@@ -91,13 +91,13 @@ EXPORT_SYMBOL(mxc_set_irq_fiq);
 #endif /* CONFIG_FIQ */
 
 /* Disable interrupt number "irq" in the AVIC */
-static void mxc_mask_irq(unsigned int irq)
+static void mxc_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(irq, avic_base + AVIC_INTDISNUM);
 }
 
 /* Enable interrupt number "irq" in the AVIC */
-static void mxc_unmask_irq(unsigned int irq)
+static void mxc_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(irq, avic_base + AVIC_INTENNUM);
 }
Index: linux-2.6/arch/arm/plat-omap/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/gpio.c
+++ linux-2.6/arch/arm/plat-omap/gpio.c
@@ -1267,7 +1267,7 @@ static void gpio_irq_handler(unsigned in
 	u32 retrigger = 0;
 	int unmasked = 0;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 
 	bank = get_irq_data(irq);
 #ifdef CONFIG_ARCH_OMAP1
@@ -1319,7 +1319,7 @@ static void gpio_irq_handler(unsigned in
 		configured, we could unmask GPIO bank interrupt immediately */
 		if (!level_mask && !unmasked) {
 			unmasked = 1;
-			desc->chip->unmask(irq);
+			desc->chip->unmask(irq, desc);
 		}
 
 		isr |= retrigger;
@@ -1354,7 +1354,7 @@ static void gpio_irq_handler(unsigned in
 	handler(s) are executed in order to avoid spurious bank
 	interrupt */
 	if (!unmasked)
-		desc->chip->unmask(irq);
+		desc->chip->unmask(irq, desc);
 
 }
 
@@ -1366,7 +1366,7 @@ static void gpio_irq_shutdown(unsigned i
 	_reset_gpio(bank, gpio);
 }
 
-static void gpio_ack_irq(unsigned int irq)
+static void gpio_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = get_irq_chip_data(irq);
@@ -1374,7 +1374,7 @@ static void gpio_ack_irq(unsigned int ir
 	_clear_gpio_irqstatus(bank, gpio);
 }
 
-static void gpio_mask_irq(unsigned int irq)
+static void gpio_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = get_irq_chip_data(irq);
@@ -1383,7 +1383,7 @@ static void gpio_mask_irq(unsigned int i
 	_set_gpio_triggering(bank, get_gpio_index(gpio), IRQ_TYPE_NONE);
 }
 
-static void gpio_unmask_irq(unsigned int irq)
+static void gpio_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = get_irq_chip_data(irq);
@@ -1420,12 +1420,12 @@ static struct irq_chip gpio_irq_chip = {
 
 /* MPUIO uses the always-on 32k clock */
 
-static void mpuio_ack_irq(unsigned int irq)
+static void mpuio_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* The ISR is reset automatically, so do nothing here. */
 }
 
-static void mpuio_mask_irq(unsigned int irq)
+static void mpuio_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = OMAP_MPUIO(irq - IH_MPUIO_BASE);
 	struct gpio_bank *bank = get_irq_chip_data(irq);
@@ -1433,7 +1433,7 @@ static void mpuio_mask_irq(unsigned int
 	_set_gpio_irqenable(bank, gpio, 0);
 }
 
-static void mpuio_unmask_irq(unsigned int irq)
+static void mpuio_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int gpio = OMAP_MPUIO(irq - IH_MPUIO_BASE);
 	struct gpio_bank *bank = get_irq_chip_data(irq);
Index: linux-2.6/arch/arm/plat-orion/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-orion/gpio.c
+++ linux-2.6/arch/arm/plat-orion/gpio.c
@@ -233,7 +233,7 @@ EXPORT_SYMBOL(orion_gpio_set_blink);
  *
  ****************************************************************************/
 
-static void gpio_irq_ack(u32 irq)
+static void gpio_irq_ack(u32 irq, struct irq_desc *desc)
 {
 	int type = irq_desc[irq].status & IRQ_TYPE_SENSE_MASK;
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
@@ -242,7 +242,7 @@ static void gpio_irq_ack(u32 irq)
 	}
 }
 
-static void gpio_irq_mask(u32 irq)
+static void gpio_irq_mask(u32 irq, struct irq_desc *desc)
 {
 	int pin = irq_to_gpio(irq);
 	int type = irq_desc[irq].status & IRQ_TYPE_SENSE_MASK;
@@ -253,7 +253,7 @@ static void gpio_irq_mask(u32 irq)
 	writel(u, reg);
 }
 
-static void gpio_irq_unmask(u32 irq)
+static void gpio_irq_unmask(u32 irq, struct irq_desc *desc)
 {
 	int pin = irq_to_gpio(irq);
 	int type = irq_desc[irq].status & IRQ_TYPE_SENSE_MASK;
Index: linux-2.6/arch/arm/plat-orion/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-orion/irq.c
+++ linux-2.6/arch/arm/plat-orion/irq.c
@@ -14,7 +14,7 @@
 #include <linux/io.h>
 #include <plat/irq.h>
 
-static void orion_irq_mask(u32 irq)
+static void orion_irq_mask(u32 irq, struct irq_desc *desc)
 {
 	void __iomem *maskaddr = get_irq_chip_data(irq);
 	u32 mask;
@@ -24,7 +24,7 @@ static void orion_irq_mask(u32 irq)
 	writel(mask, maskaddr);
 }
 
-static void orion_irq_unmask(u32 irq)
+static void orion_irq_unmask(u32 irq, struct irq_desc *desc)
 {
 	void __iomem *maskaddr = get_irq_chip_data(irq);
 	u32 mask;
Index: linux-2.6/arch/arm/plat-pxa/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-pxa/gpio.c
+++ linux-2.6/arch/arm/plat-pxa/gpio.c
@@ -227,7 +227,7 @@ static void pxa_gpio_demux_handler(unsig
 	} while (loop);
 }
 
-static void pxa_ack_muxed_gpio(unsigned int irq)
+static void pxa_ack_muxed_gpio(unsigned int irq, struct irq_desc *desc)
 {
 	int gpio = irq_to_gpio(irq);
 	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
@@ -235,7 +235,7 @@ static void pxa_ack_muxed_gpio(unsigned
 	__raw_writel(GPIO_bit(gpio), c->regbase + GEDR_OFFSET);
 }
 
-static void pxa_mask_muxed_gpio(unsigned int irq)
+static void pxa_mask_muxed_gpio(unsigned int irq, struct irq_desc *desc)
 {
 	int gpio = irq_to_gpio(irq);
 	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
@@ -249,7 +249,7 @@ static void pxa_mask_muxed_gpio(unsigned
 	__raw_writel(gfer, c->regbase + GFER_OFFSET);
 }
 
-static void pxa_unmask_muxed_gpio(unsigned int irq)
+static void pxa_unmask_muxed_gpio(unsigned int irq, struct irq_desc *desc)
 {
 	int gpio = irq_to_gpio(irq);
 	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
Index: linux-2.6/arch/arm/plat-s3c24xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/irq.c
+++ linux-2.6/arch/arm/plat-s3c24xx/irq.c
@@ -34,7 +34,7 @@
 #include <plat/irq.h>
 
 static void
-s3c_irq_mask(unsigned int irqno)
+s3c_irq_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long mask;
 
@@ -46,7 +46,7 @@ s3c_irq_mask(unsigned int irqno)
 }
 
 static inline void
-s3c_irq_ack(unsigned int irqno)
+s3c_irq_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
 
@@ -55,7 +55,7 @@ s3c_irq_ack(unsigned int irqno)
 }
 
 static inline void
-s3c_irq_maskack(unsigned int irqno)
+s3c_irq_maskack(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
 	unsigned long mask;
@@ -69,7 +69,7 @@ s3c_irq_maskack(unsigned int irqno)
 
 
 static void
-s3c_irq_unmask(unsigned int irqno)
+s3c_irq_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long mask;
 
@@ -100,7 +100,7 @@ struct irq_chip s3c_irq_chip = {
 };
 
 static void
-s3c_irqext_mask(unsigned int irqno)
+s3c_irqext_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long mask;
 
@@ -112,7 +112,7 @@ s3c_irqext_mask(unsigned int irqno)
 }
 
 static void
-s3c_irqext_ack(unsigned int irqno)
+s3c_irqext_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long req;
 	unsigned long bit;
@@ -139,7 +139,7 @@ s3c_irqext_ack(unsigned int irqno)
 }
 
 static void
-s3c_irqext_unmask(unsigned int irqno)
+s3c_irqext_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	unsigned long mask;
 
@@ -261,19 +261,19 @@ static struct irq_chip s3c_irq_eint0t4 =
 /* UART0 */
 
 static void
-s3c_irq_uart0_mask(unsigned int irqno)
+s3c_irq_uart0_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_UART0, 7);
 }
 
 static void
-s3c_irq_uart0_unmask(unsigned int irqno)
+s3c_irq_uart0_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_UART0);
 }
 
 static void
-s3c_irq_uart0_ack(unsigned int irqno)
+s3c_irq_uart0_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_UART0, 7);
 }
@@ -288,19 +288,19 @@ static struct irq_chip s3c_irq_uart0 = {
 /* UART1 */
 
 static void
-s3c_irq_uart1_mask(unsigned int irqno)
+s3c_irq_uart1_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_UART1, 7 << 3);
 }
 
 static void
-s3c_irq_uart1_unmask(unsigned int irqno)
+s3c_irq_uart1_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_UART1);
 }
 
 static void
-s3c_irq_uart1_ack(unsigned int irqno)
+s3c_irq_uart1_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_UART1, 7 << 3);
 }
@@ -315,19 +315,19 @@ static struct irq_chip s3c_irq_uart1 = {
 /* UART2 */
 
 static void
-s3c_irq_uart2_mask(unsigned int irqno)
+s3c_irq_uart2_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_UART2, 7 << 6);
 }
 
 static void
-s3c_irq_uart2_unmask(unsigned int irqno)
+s3c_irq_uart2_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_UART2);
 }
 
 static void
-s3c_irq_uart2_ack(unsigned int irqno)
+s3c_irq_uart2_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_UART2, 7 << 6);
 }
@@ -342,19 +342,19 @@ static struct irq_chip s3c_irq_uart2 = {
 /* ADC and Touchscreen */
 
 static void
-s3c_irq_adc_mask(unsigned int irqno)
+s3c_irq_adc_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_ADCPARENT, 3 << 9);
 }
 
 static void
-s3c_irq_adc_unmask(unsigned int irqno)
+s3c_irq_adc_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_ADCPARENT);
 }
 
 static void
-s3c_irq_adc_ack(unsigned int irqno)
+s3c_irq_adc_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_ack(irqno, INTMSK_ADCPARENT, 3 << 9);
 }
Index: linux-2.6/arch/arm/plat-s3c24xx/s3c244x-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/s3c244x-irq.c
+++ linux-2.6/arch/arm/plat-s3c24xx/s3c244x-irq.c
@@ -68,19 +68,19 @@ static void s3c_irq_demux_cam(unsigned i
 #define INTMSK_CAM (1UL << (IRQ_CAM - IRQ_EINT0))
 
 static void
-s3c_irq_cam_mask(unsigned int irqno)
+s3c_irq_cam_mask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_mask(irqno, INTMSK_CAM, 3<<11);
 }
 
 static void
-s3c_irq_cam_unmask(unsigned int irqno)
+s3c_irq_cam_unmask(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_unmask(irqno, INTMSK_CAM);
 }
 
 static void
-s3c_irq_cam_ack(unsigned int irqno)
+s3c_irq_cam_ack(unsigned int irqno, struct irq_desc *desc)
 {
 	s3c_irqsub_maskack(irqno, INTMSK_CAM, 3<<11);
 }
Index: linux-2.6/arch/arm/plat-s3c64xx/irq-eint.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c64xx/irq-eint.c
+++ linux-2.6/arch/arm/plat-s3c64xx/irq-eint.c
@@ -32,7 +32,7 @@
 #define eint_offset(irq)	((irq) - IRQ_EINT(0))
 #define eint_irq_to_bit(irq)	(1 << eint_offset(irq))
 
-static inline void s3c_irq_eint_mask(unsigned int irq)
+static inline void s3c_irq_eint_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask;
 
@@ -41,7 +41,7 @@ static inline void s3c_irq_eint_mask(uns
 	__raw_writel(mask, S3C64XX_EINT0MASK);
 }
 
-static void s3c_irq_eint_unmask(unsigned int irq)
+static void s3c_irq_eint_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask;
 
@@ -50,16 +50,16 @@ static void s3c_irq_eint_unmask(unsigned
 	__raw_writel(mask, S3C64XX_EINT0MASK);
 }
 
-static inline void s3c_irq_eint_ack(unsigned int irq)
+static inline void s3c_irq_eint_ack(unsigned int irq, struct irq_desc *desc)
 {
 	__raw_writel(eint_irq_to_bit(irq), S3C64XX_EINT0PEND);
 }
 
-static void s3c_irq_eint_maskack(unsigned int irq)
+static void s3c_irq_eint_maskack(unsigned int irq, struct irq_desc *desc)
 {
 	/* compiler should in-line these */
-	s3c_irq_eint_mask(irq);
-	s3c_irq_eint_ack(irq);
+	s3c_irq_eint_mask(irq, desc);
+	s3c_irq_eint_ack(irq, desc);
 }
 
 static int s3c_irq_eint_set_type(unsigned int irq, unsigned int type)
Index: linux-2.6/arch/arm/plat-s3c64xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c64xx/irq.c
+++ linux-2.6/arch/arm/plat-s3c64xx/irq.c
@@ -59,7 +59,7 @@ static void s3c_irq_demux_timer4(unsigne
 
 /* We assume the IRQ_TIMER0..IRQ_TIMER4 range is continuous. */
 
-static void s3c_irq_timer_mask(unsigned int irq)
+static void s3c_irq_timer_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
@@ -68,7 +68,7 @@ static void s3c_irq_timer_mask(unsigned
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_unmask(unsigned int irq)
+static void s3c_irq_timer_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
@@ -77,7 +77,7 @@ static void s3c_irq_timer_unmask(unsigne
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_ack(unsigned int irq)
+static void s3c_irq_timer_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
@@ -138,7 +138,7 @@ static inline unsigned int s3c_irq_uart_
 
 /* UART interrupt registers, not worth adding to seperate include header */
 
-static void s3c_irq_uart_mask(unsigned int irq)
+static void s3c_irq_uart_mask(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
@@ -149,7 +149,7 @@ static void s3c_irq_uart_mask(unsigned i
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_maskack(unsigned int irq)
+static void s3c_irq_uart_maskack(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
@@ -161,7 +161,7 @@ static void s3c_irq_uart_maskack(unsigne
 	__raw_writel(1 << bit, regs + S3C64XX_UINTP);
 }
 
-static void s3c_irq_uart_unmask(unsigned int irq)
+static void s3c_irq_uart_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
@@ -172,7 +172,7 @@ static void s3c_irq_uart_unmask(unsigned
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_ack(unsigned int irq)
+static void s3c_irq_uart_ack(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
Index: linux-2.6/arch/arm/plat-s5pc1xx/irq-eint.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s5pc1xx/irq-eint.c
+++ linux-2.6/arch/arm/plat-s5pc1xx/irq-eint.c
@@ -67,7 +67,7 @@ static inline int s3c_eint_to_bit(unsign
 	return bit;
 }
 
-static inline void s3c_irq_eint_mask(unsigned int irq)
+static inline void s3c_irq_eint_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask;
 	u32 bank = s3c_get_bank(irq);
@@ -77,7 +77,7 @@ static inline void s3c_irq_eint_mask(uns
 	__raw_writel(mask, S5PC1XX_WKUP_INT_MASK(bank));
 }
 
-static void s3c_irq_eint_unmask(unsigned int irq)
+static void s3c_irq_eint_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask;
 	u32 bank = s3c_get_bank(irq);
@@ -87,18 +87,18 @@ static void s3c_irq_eint_unmask(unsigned
 	__raw_writel(mask, S5PC1XX_WKUP_INT_MASK(bank));
 }
 
-static inline void s3c_irq_eint_ack(unsigned int irq)
+static inline void s3c_irq_eint_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u32 bank = s3c_get_bank(irq);
 
 	__raw_writel(s3c_eint_to_bit(irq), S5PC1XX_WKUP_INT_PEND(bank));
 }
 
-static void s3c_irq_eint_maskack(unsigned int irq)
+static void s3c_irq_eint_maskack(unsigned int irq, struct irq_desc *desc)
 {
 	/* compiler should in-line these */
-	s3c_irq_eint_mask(irq);
-	s3c_irq_eint_ack(irq);
+	s3c_irq_eint_mask(irq, desc);
+	s3c_irq_eint_ack(irq, desc);
 }
 
 static int s3c_irq_eint_set_type(unsigned int irq, unsigned int type)
@@ -211,7 +211,7 @@ static void s3c_irq_demux_eint16_31(unsi
 /*
  * Handle EINT0 ... EINT15 at VIC directly
  */
-static void s3c_irq_vic_eint_mask(unsigned int irq)
+static void s3c_irq_vic_eint_mask(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *base = get_irq_chip_data(irq);
 	unsigned int real;
@@ -221,7 +221,7 @@ static void s3c_irq_vic_eint_mask(unsign
 	writel(1 << real, base + VIC_INT_ENABLE_CLEAR);
 }
 
-static void s3c_irq_vic_eint_unmask(unsigned int irq)
+static void s3c_irq_vic_eint_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *base = get_irq_chip_data(irq);
 	unsigned int real;
@@ -231,7 +231,7 @@ static void s3c_irq_vic_eint_unmask(unsi
 	writel(1 << real, base + VIC_INT_ENABLE);
 }
 
-static inline void s3c_irq_vic_eint_ack(unsigned int irq)
+static inline void s3c_irq_vic_eint_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u32 bit;
 	u32 bank = s3c_get_bank(irq);
@@ -240,11 +240,11 @@ static inline void s3c_irq_vic_eint_ack(
 	__raw_writel(bit, S5PC1XX_WKUP_INT_PEND(bank));
 }
 
-static void s3c_irq_vic_eint_maskack(unsigned int irq)
+static void s3c_irq_vic_eint_maskack(unsigned int irq, struct irq_desc *desc)
 {
 	/* compiler should in-line these */
-	s3c_irq_vic_eint_mask(irq);
-	s3c_irq_vic_eint_ack(irq);
+	s3c_irq_vic_eint_mask(irq, desc);
+	s3c_irq_vic_eint_ack(irq, desc);
 }
 
 static struct irq_chip s3c_irq_vic_eint = {
Index: linux-2.6/arch/arm/plat-s5pc1xx/irq-gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s5pc1xx/irq-gpio.c
+++ linux-2.6/arch/arm/plat-s5pc1xx/irq-gpio.c
@@ -140,7 +140,7 @@ static int s5pc1xx_get_offset(unsigned i
 	return irq - S3C_IRQ_GPIO(chip->base);
 }
 
-static void s5pc1xx_gpioint_ack(unsigned int irq)
+static void s5pc1xx_gpioint_ack(unsigned int irq, struct irq_desc *desc)
 {
 	int group, offset, pend_offset;
 	unsigned int value;
@@ -154,7 +154,7 @@ static void s5pc1xx_gpioint_ack(unsigned
 	__raw_writel(value, S5PC1XX_GPIOREG(PEND_OFFSET) + pend_offset);
 }
 
-static void s5pc1xx_gpioint_mask(unsigned int irq)
+static void s5pc1xx_gpioint_mask(unsigned int irq, struct irq_desc *desc)
 {
 	int group, offset, mask_offset;
 	unsigned int value;
@@ -168,7 +168,7 @@ static void s5pc1xx_gpioint_mask(unsigne
 	__raw_writel(value, S5PC1XX_GPIOREG(MASK_OFFSET) + mask_offset);
 }
 
-static void s5pc1xx_gpioint_unmask(unsigned int irq)
+static void s5pc1xx_gpioint_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	int group, offset, mask_offset;
 	unsigned int value;
@@ -182,10 +182,10 @@ static void s5pc1xx_gpioint_unmask(unsig
 	__raw_writel(value, S5PC1XX_GPIOREG(MASK_OFFSET) + mask_offset);
 }
 
-static void s5pc1xx_gpioint_mask_ack(unsigned int irq)
+static void s5pc1xx_gpioint_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
-	s5pc1xx_gpioint_mask(irq);
-	s5pc1xx_gpioint_ack(irq);
+	s5pc1xx_gpioint_mask(irq, desc);
+	s5pc1xx_gpioint_ack(irq, desc);
 }
 
 static int s5pc1xx_gpioint_set_type(unsigned int irq, unsigned int type)
Index: linux-2.6/arch/arm/plat-s5pc1xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s5pc1xx/irq.c
+++ linux-2.6/arch/arm/plat-s5pc1xx/irq.c
@@ -57,7 +57,7 @@ static void s3c_irq_demux_timer4(unsigne
 
 /* We assume the IRQ_TIMER0..IRQ_TIMER4 range is continuous. */
 
-static void s3c_irq_timer_mask(unsigned int irq)
+static void s3c_irq_timer_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
@@ -66,7 +66,7 @@ static void s3c_irq_timer_mask(unsigned
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_unmask(unsigned int irq)
+static void s3c_irq_timer_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
@@ -75,7 +75,7 @@ static void s3c_irq_timer_unmask(unsigne
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_ack(unsigned int irq)
+static void s3c_irq_timer_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
@@ -139,7 +139,7 @@ static inline unsigned int s3c_irq_uart_
 #define S3C64XX_UINTSP	0x34
 #define S3C64XX_UINTM	0x38
 
-static void s3c_irq_uart_mask(unsigned int irq)
+static void s3c_irq_uart_mask(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
@@ -150,7 +150,7 @@ static void s3c_irq_uart_mask(unsigned i
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_maskack(unsigned int irq)
+static void s3c_irq_uart_maskack(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
@@ -162,7 +162,7 @@ static void s3c_irq_uart_maskack(unsigne
 	__raw_writel(1 << bit, regs + S3C64XX_UINTP);
 }
 
-static void s3c_irq_uart_unmask(unsigned int irq)
+static void s3c_irq_uart_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
@@ -173,7 +173,7 @@ static void s3c_irq_uart_unmask(unsigned
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_ack(unsigned int irq)
+static void s3c_irq_uart_ack(unsigned int irq, struct irq_desc *desc)
 {
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
Index: linux-2.6/arch/arm/plat-stmp3xxx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-stmp3xxx/irq.c
+++ linux-2.6/arch/arm/plat-stmp3xxx/irq.c
@@ -34,7 +34,7 @@ void __init stmp3xxx_init_irq(struct irq
 
 	/* Disable all interrupts initially */
 	for (i = 0; i < NR_REAL_IRQS; i++) {
-		chip->mask(i);
+		chip->mask(i, irq_to_desc(i));
 		set_irq_chip(i, chip);
 		set_irq_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
Index: linux-2.6/arch/arm/plat-stmp3xxx/pinmux.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-stmp3xxx/pinmux.c
+++ linux-2.6/arch/arm/plat-stmp3xxx/pinmux.c
@@ -398,7 +398,7 @@ static int stmp3xxx_set_irqtype(unsigned
 	return 0;
 }
 
-static void stmp3xxx_pin_ack_irq(unsigned irq)
+static void stmp3xxx_pin_ack_irq(unsigned irq, struct irq_desc *desc)
 {
 	u32 stat;
 	struct stmp3xxx_pinmux_bank *pm;
@@ -409,7 +409,7 @@ static void stmp3xxx_pin_ack_irq(unsigne
 	stmp3xxx_clearl(stat, pm->irqstat);
 }
 
-static void stmp3xxx_pin_mask_irq(unsigned irq)
+static void stmp3xxx_pin_mask_irq(unsigned irq, struct irq_desc *desc)
 {
 	struct stmp3xxx_pinmux_bank *pm;
 	unsigned gpio;
@@ -419,7 +419,7 @@ static void stmp3xxx_pin_mask_irq(unsign
 	stmp3xxx_clearl(1 << gpio, pm->pin2irq);
 }
 
-static void stmp3xxx_pin_unmask_irq(unsigned irq)
+static void stmp3xxx_pin_unmask_irq(unsigned irq, struct irq_desc *desc)
 {
 	struct stmp3xxx_pinmux_bank *pm;
 	unsigned gpio;
Index: linux-2.6/arch/avr32/mach-at32ap/extint.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/extint.c
+++ linux-2.6/arch/avr32/mach-at32ap/extint.c
@@ -60,26 +60,26 @@ struct eic {
 static struct eic *nmi_eic;
 static bool nmi_enabled;
 
-static void eic_ack_irq(unsigned int irq)
+static void eic_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct eic *eic = get_irq_chip_data(irq);
 	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
 }
 
-static void eic_mask_irq(unsigned int irq)
+static void eic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct eic *eic = get_irq_chip_data(irq);
 	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
 }
 
-static void eic_mask_ack_irq(unsigned int irq)
+static void eic_mask_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct eic *eic = get_irq_chip_data(irq);
 	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
 	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
 }
 
-static void eic_unmask_irq(unsigned int irq)
+static void eic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct eic *eic = get_irq_chip_data(irq);
 	eic_writel(eic, IER, 1 << (irq - eic->first_irq));
Index: linux-2.6/arch/avr32/mach-at32ap/pio.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/pio.c
+++ linux-2.6/arch/avr32/mach-at32ap/pio.c
@@ -249,7 +249,7 @@ static void gpio_set(struct gpio_chip *c
 
 /* GPIO IRQ support */
 
-static void gpio_irq_mask(unsigned irq)
+static void gpio_irq_mask(unsigned irq, struct irq_desc *desc)
 {
 	unsigned		gpio = irq_to_gpio(irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
@@ -257,7 +257,7 @@ static void gpio_irq_mask(unsigned irq)
 	pio_writel(pio, IDR, 1 << (gpio & 0x1f));
 }
 
-static void gpio_irq_unmask(unsigned irq)
+static void gpio_irq_unmask(unsigned irq, struct irq_desc *desc)
 {
 	unsigned		gpio = irq_to_gpio(irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
Index: linux-2.6/arch/blackfin/include/asm/ipipe.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/ipipe.h
+++ linux-2.6/arch/blackfin/include/asm/ipipe.h
@@ -115,9 +115,9 @@ void __ipipe_enable_irqdesc(struct ipipe
 void __ipipe_disable_irqdesc(struct ipipe_domain *ipd,
 			     unsigned irq);
 
-#define __ipipe_enable_irq(irq)		(irq_desc[irq].chip->unmask(irq))
+#define __ipipe_enable_irq(irq)		(irq_desc[irq].chip->unmask(irq, irq_to_desc(irq)))
 
-#define __ipipe_disable_irq(irq)	(irq_desc[irq].chip->mask(irq))
+#define __ipipe_disable_irq(irq)	(irq_desc[irq].chip->mask(irq, irq_to_desc(irq)))
 
 static inline int __ipipe_check_tickdev(const char *devname)
 {
Index: linux-2.6/arch/blackfin/mach-common/ints-priority.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/ints-priority.c
+++ linux-2.6/arch/blackfin/mach-common/ints-priority.c
@@ -120,19 +120,19 @@ static void __init search_IAR(void)
  * This is for core internal IRQs
  */
 
-static void bfin_ack_noop(unsigned int irq)
+static void bfin_ack_noop(unsigned int irq, struct irq_desc *desc)
 {
 	/* Dummy function.  */
 }
 
-static void bfin_core_mask_irq(unsigned int irq)
+static void bfin_core_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	bfin_irq_flags &= ~(1 << irq);
 	if (!irqs_disabled_hw())
 		local_irq_enable_hw();
 }
 
-static void bfin_core_unmask_irq(unsigned int irq)
+static void bfin_core_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	bfin_irq_flags |= 1 << irq;
 	/*
@@ -171,6 +171,10 @@ static void bfin_internal_mask_irq(unsig
 #endif
 	local_irq_restore_hw(flags);
 }
+static void bfin_internal_mask_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	bfin_internal_mask_irq(irq);
+}
 
 static void bfin_internal_unmask_irq(unsigned int irq)
 {
@@ -195,6 +199,11 @@ static void bfin_internal_unmask_irq(uns
 	local_irq_restore_hw(flags);
 }
 
+static void bfin_internal_unmask_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	bfin_internal_unmask_irq(irq);
+}
+
 #ifdef CONFIG_PM
 int bfin_internal_set_wake(unsigned int irq, unsigned int state)
 {
@@ -265,9 +274,9 @@ static struct irq_chip bfin_core_irqchip
 static struct irq_chip bfin_internal_irqchip = {
 	.name = "INTN",
 	.ack = bfin_ack_noop,
-	.mask = bfin_internal_mask_irq,
-	.unmask = bfin_internal_unmask_irq,
-	.mask_ack = bfin_internal_mask_irq,
+	.mask = bfin_internal_mask_irq_desc,
+	.unmask = bfin_internal_unmask_irq_desc,
+	.mask_ack = bfin_internal_mask_irq_desc,
 	.disable = bfin_internal_mask_irq,
 	.enable = bfin_internal_unmask_irq,
 #ifdef CONFIG_PM
@@ -291,7 +300,7 @@ static void bfin_handle_irq(unsigned irq
 #ifdef BF537_GENERIC_ERROR_INT_DEMUX
 static int error_int_mask;
 
-static void bfin_generic_error_mask_irq(unsigned int irq)
+static void bfin_generic_error_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	error_int_mask &= ~(1L << (irq - IRQ_PPI_ERROR));
 
@@ -299,7 +308,7 @@ static void bfin_generic_error_mask_irq(
 		bfin_internal_mask_irq(IRQ_GENERIC_ERROR);
 }
 
-static void bfin_generic_error_unmask_irq(unsigned int irq)
+static void bfin_generic_error_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	bfin_internal_unmask_irq(IRQ_GENERIC_ERROR);
 	error_int_mask |= 1L << (irq - IRQ_PPI_ERROR);
@@ -675,7 +684,7 @@ void init_pint_lut(void)
 	}
 }
 
-static void bfin_gpio_ack_irq(unsigned int irq)
+static void bfin_gpio_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
@@ -692,7 +701,7 @@ static void bfin_gpio_ack_irq(unsigned i
 
 }
 
-static void bfin_gpio_mask_ack_irq(unsigned int irq)
+static void bfin_gpio_mask_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
@@ -716,6 +725,10 @@ static void bfin_gpio_mask_irq(unsigned
 
 	pint[PINT_2_BANK(pint_val)]->mask_clear = PINT_BIT(pint_val);
 }
+static void bfin_gpio_mask_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	bfin_gpio_mask_irq(irq);
+}
 
 static void bfin_gpio_unmask_irq(unsigned int irq)
 {
@@ -726,6 +739,10 @@ static void bfin_gpio_unmask_irq(unsigne
 	pint[bank]->request = pintbit;
 	pint[bank]->mask_set = pintbit;
 }
+static void bfin_gpio_unmask_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	bfin_gpio_unmask_irq(irq);
+}
 
 static unsigned int bfin_gpio_irq_startup(unsigned int irq)
 {
@@ -925,9 +942,9 @@ static void bfin_demux_gpio_irq(unsigned
 static struct irq_chip bfin_gpio_irqchip = {
 	.name = "GPIO",
 	.ack = bfin_gpio_ack_irq,
-	.mask = bfin_gpio_mask_irq,
+	.mask = bfin_gpio_mask_irq_desc,
 	.mask_ack = bfin_gpio_mask_ack_irq,
-	.unmask = bfin_gpio_unmask_irq,
+	.unmask = bfin_gpio_unmask_irq_desc,
 	.disable = bfin_gpio_mask_irq,
 	.enable = bfin_gpio_unmask_irq,
 	.set_type = bfin_gpio_irq_type,
Index: linux-2.6/arch/cris/arch-v10/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v10/kernel/irq.c
@@ -124,7 +124,7 @@ static void disable_crisv10_irq(unsigned
 	mask_irq(irq);
 }
 
-static void ack_crisv10_irq(unsigned int irq)
+static void ack_crisv10_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/frv/kernel/irq-mb93091.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93091.c
+++ linux-2.6/arch/frv/kernel/irq-mb93091.c
@@ -36,7 +36,7 @@
 /*
  * on-motherboard FPGA PIC operations
  */
-static void frv_fpga_mask(unsigned int irq)
+static void frv_fpga_mask(unsigned int irq, struct irq_desc *desc)
 {
 	uint16_t imr = __get_IMR();
 
@@ -45,12 +45,12 @@ static void frv_fpga_mask(unsigned int i
 	__set_IMR(imr);
 }
 
-static void frv_fpga_ack(unsigned int irq)
+static void frv_fpga_ack(unsigned int irq, struct irq_desc *desc)
 {
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_mask_ack(unsigned int irq)
+static void frv_fpga_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	uint16_t imr = __get_IMR();
 
@@ -60,7 +60,7 @@ static void frv_fpga_mask_ack(unsigned i
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_unmask(unsigned int irq)
+static void frv_fpga_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	uint16_t imr = __get_IMR();
 
Index: linux-2.6/arch/frv/kernel/irq-mb93093.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93093.c
+++ linux-2.6/arch/frv/kernel/irq-mb93093.c
@@ -35,7 +35,7 @@
 /*
  * off-CPU FPGA PIC operations
  */
-static void frv_fpga_mask(unsigned int irq)
+static void frv_fpga_mask(unsigned int irq, struct irq_desc *desc)
 {
 	uint16_t imr = __get_IMR();
 
@@ -43,12 +43,12 @@ static void frv_fpga_mask(unsigned int i
 	__set_IMR(imr);
 }
 
-static void frv_fpga_ack(unsigned int irq)
+static void frv_fpga_ack(unsigned int irq, struct irq_desc *desc)
 {
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_mask_ack(unsigned int irq)
+static void frv_fpga_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	uint16_t imr = __get_IMR();
 
@@ -58,7 +58,7 @@ static void frv_fpga_mask_ack(unsigned i
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_unmask(unsigned int irq)
+static void frv_fpga_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	uint16_t imr = __get_IMR();
 
Index: linux-2.6/arch/frv/kernel/irq-mb93493.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93493.c
+++ linux-2.6/arch/frv/kernel/irq-mb93493.c
@@ -45,7 +45,7 @@
  * daughter board PIC operations
  * - there is no way to ACK interrupts in the MB93493 chip
  */
-static void frv_mb93493_mask(unsigned int irq)
+static void frv_mb93493_mask(unsigned int irq, struct irq_desc *desc)
 {
 	uint32_t iqsr;
 	volatile void *piqsr;
@@ -60,11 +60,11 @@ static void frv_mb93493_mask(unsigned in
 	writel(iqsr, piqsr);
 }
 
-static void frv_mb93493_ack(unsigned int irq)
+static void frv_mb93493_ack(unsigned int irq, struct irq_desc *desc)
 {
 }
 
-static void frv_mb93493_unmask(unsigned int irq)
+static void frv_mb93493_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	uint32_t iqsr;
 	volatile void *piqsr;
Index: linux-2.6/arch/frv/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq.c
+++ linux-2.6/arch/frv/kernel/irq.c
@@ -96,25 +96,25 @@ int show_interrupts(struct seq_file *p,
 /*
  * on-CPU PIC operations
  */
-static void frv_cpupic_ack(unsigned int irqlevel)
+static void frv_cpupic_ack(unsigned int irqlevel, struct irq_desc *desc)
 {
 	__clr_RC(irqlevel);
 	__clr_IRL();
 }
 
-static void frv_cpupic_mask(unsigned int irqlevel)
+static void frv_cpupic_mask(unsigned int irqlevel, struct irq_desc *desc)
 {
 	__set_MASK(irqlevel);
 }
 
-static void frv_cpupic_mask_ack(unsigned int irqlevel)
+static void frv_cpupic_mask_ack(unsigned int irqlevel, struct irq_desc *desc)
 {
 	__set_MASK(irqlevel);
 	__clr_RC(irqlevel);
 	__clr_IRL();
 }
 
-static void frv_cpupic_unmask(unsigned int irqlevel)
+static void frv_cpupic_unmask(unsigned int irqlevel, struct irq_desc *desc)
 {
 	__clr_MASK(irqlevel);
 }
Index: linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
@@ -20,6 +20,10 @@ static void
 hpsim_irq_noop (unsigned int irq)
 {
 }
+static void
+hpsim_irq_noop_desc(unsigned int irq, struct irq_desc *desc)
+{
+}
 
 static int
 hpsim_set_affinity_noop(unsigned int a, const struct cpumask *b)
@@ -33,7 +37,7 @@ static struct irq_chip irq_type_hp_sim =
 	.shutdown =	hpsim_irq_noop,
 	.enable =	hpsim_irq_noop,
 	.disable =	hpsim_irq_noop,
-	.ack =		hpsim_irq_noop,
+	.ack =		hpsim_irq_noop_desc,
 	.end =		hpsim_irq_noop,
 	.set_affinity =	hpsim_set_affinity_noop,
 };
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -267,6 +267,10 @@ static void
 nop (unsigned int irq)
 {
 	/* do nothing... */
+static void
+nop_desc(unsigned int irq, struct irq_desc *desc)
+{
+	/* do nothing... */
 }
 
 
@@ -310,6 +314,11 @@ mask_irq (unsigned int irq)
 		iosapic_write(rte->iosapic, IOSAPIC_RTE_LOW(rte_index), low32);
 	}
 }
+static void
+mask_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	mask_irq(irq);
+}
 
 static void
 unmask_irq (unsigned int irq)
@@ -327,7 +336,11 @@ unmask_irq (unsigned int irq)
 		iosapic_write(rte->iosapic, IOSAPIC_RTE_LOW(rte_index), low32);
 	}
 }
-
+static void
+unmask_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	unmask_irq(irq);
+}
 
 static int
 iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
@@ -417,7 +430,7 @@ iosapic_end_level_irq (unsigned int irq)
 #define iosapic_shutdown_level_irq	mask_irq
 #define iosapic_enable_level_irq	unmask_irq
 #define iosapic_disable_level_irq	mask_irq
-#define iosapic_ack_level_irq		nop
+#define iosapic_ack_level_irq		nop_desc
 
 static struct irq_chip irq_type_iosapic_level = {
 	.name =		"IO-SAPIC-level",
@@ -427,8 +440,8 @@ static struct irq_chip irq_type_iosapic_
 	.disable =	iosapic_disable_level_irq,
 	.ack =		iosapic_ack_level_irq,
 	.end =		iosapic_end_level_irq,
-	.mask =		mask_irq,
-	.unmask =	unmask_irq,
+	.mask =		mask_irq_desc,
+	.unmask =	unmask_irq_desc,
 	.set_affinity =	iosapic_set_affinity
 };
 
@@ -467,7 +480,7 @@ iosapic_ack_edge_irq (unsigned int irq)
 
 #define iosapic_enable_edge_irq		unmask_irq
 #define iosapic_disable_edge_irq	nop
-#define iosapic_end_edge_irq		nop
+#define iosapic_end_edge_irq		nop_desc
 
 static struct irq_chip irq_type_iosapic_edge = {
 	.name =		"IO-SAPIC-edge",
@@ -477,8 +490,8 @@ static struct irq_chip irq_type_iosapic_
 	.disable =	iosapic_disable_edge_irq,
 	.ack =		iosapic_ack_edge_irq,
 	.end =		iosapic_end_edge_irq,
-	.mask =		mask_irq,
-	.unmask =	unmask_irq,
+	.mask =		mask_irq_desc,
+	.unmask =	unmask_irq_desc,
 	.set_affinity =	iosapic_set_affinity
 };
 
Index: linux-2.6/arch/ia64/kernel/irq_lsapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_lsapic.c
+++ linux-2.6/arch/ia64/kernel/irq_lsapic.c
@@ -25,6 +25,11 @@ lsapic_noop (unsigned int irq)
 {
 	/* nothing to do... */
 }
+static void
+lsapic_noop_desc(unsigned int irq)
+{
+	/* nothing to do... */
+}
 
 static int lsapic_retrigger(unsigned int irq)
 {
@@ -39,7 +44,7 @@ struct irq_chip irq_type_ia64_lsapic = {
 	.shutdown =	lsapic_noop,
 	.enable =	lsapic_noop,
 	.disable =	lsapic_noop,
-	.ack =		lsapic_noop,
+	.ack =		lsapic_noop_desc,
 	.end =		lsapic_noop,
 	.retrigger =	lsapic_retrigger,
 };
Index: linux-2.6/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6/arch/ia64/kernel/msi_ia64.c
@@ -84,7 +84,7 @@ void ia64_teardown_msi_irq(unsigned int
 	destroy_irq(irq);
 }
 
-static void ia64_ack_msi_irq(unsigned int irq)
+static void ia64_ack_msi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq_complete_move(irq);
 	move_native_irq(irq);
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -100,7 +100,7 @@ static void sn_enable_irq(unsigned int i
 		ia64_mca_register_cpev(irq);
 }
 
-static void sn_ack_irq(unsigned int irq)
+static void sn_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u64 event_occurred, mask;
 
@@ -258,12 +258,12 @@ void sn_set_err_irq_affinity(unsigned in
 #endif
 
 static void
-sn_mask_irq(unsigned int irq)
+sn_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
 static void
-sn_unmask_irq(unsigned int irq)
+sn_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6/arch/ia64/sn/kernel/msi_sn.c
@@ -211,7 +211,7 @@ static int sn_set_msi_irq_affinity(unsig
 }
 #endif /* CONFIG_SMP */
 
-static void sn_ack_msi_irq(unsigned int irq)
+static void sn_ack_msi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	move_native_irq(irq);
 	ia64_eoi();
Index: linux-2.6/arch/m32r/platforms/m32104ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32104ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32104ut/setup.c
@@ -39,7 +39,7 @@ static void enable_m32104ut_irq(unsigned
 	outl(data, port);
 }
 
-static void mask_and_ack_m32104ut(unsigned int irq)
+static void mask_and_ack_m32104ut(unsigned int irq, struct irq_desc *desc)
 {
 	disable_m32104ut_irq(irq);
 }
Index: linux-2.6/arch/m32r/platforms/m32700ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32700ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32700ut/setup.c
@@ -45,7 +45,7 @@ static void enable_m32700ut_irq(unsigned
 	outl(data, port);
 }
 
-static void mask_and_ack_m32700ut(unsigned int irq)
+static void mask_and_ack_m32700ut(unsigned int irq, struct irq_desc *desc)
 {
 	disable_m32700ut_irq(irq);
 }
Index: linux-2.6/arch/m32r/platforms/mappi/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi/setup.c
@@ -38,7 +38,7 @@ static void enable_mappi_irq(unsigned in
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_and_ack_mappi(unsigned int irq, struct irq_desc *desc)
 {
 	disable_mappi_irq(irq);
 }
Index: linux-2.6/arch/m32r/platforms/mappi2/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi2/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi2/setup.c
@@ -46,7 +46,7 @@ static void enable_mappi2_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi2(unsigned int irq)
+static void mask_and_ack_mappi2(unsigned int irq, struct irq_desc *desc)
 {
 	disable_mappi2_irq(irq);
 }
Index: linux-2.6/arch/m32r/platforms/mappi3/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi3/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi3/setup.c
@@ -46,7 +46,7 @@ static void enable_mappi3_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi3(unsigned int irq)
+static void mask_and_ack_mappi3(unsigned int irq, struct irq_desc *desc)
 {
 	disable_mappi3_irq(irq);
 }
Index: linux-2.6/arch/m32r/platforms/oaks32r/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/oaks32r/setup.c
+++ linux-2.6/arch/m32r/platforms/oaks32r/setup.c
@@ -37,7 +37,7 @@ static void enable_oaks32r_irq(unsigned
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_and_ack_mappi(unsigned int irq, struct irq_desc *desc)
 {
 	disable_oaks32r_irq(irq);
 }
Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -46,7 +46,7 @@ static void enable_opsput_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_opsput(unsigned int irq)
+static void mask_and_ack_opsput(unsigned int irq, struct irq_desc *desc)
 {
 	disable_opsput_irq(irq);
 }
@@ -118,7 +118,7 @@ static void enable_opsput_pld_irq(unsign
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_pld(unsigned int irq)
+static void mask_and_ack_opsput_pld(unsigned int irq, struct irq_desc *desc)
 {
 	disable_opsput_pld_irq(irq);
 //	mask_and_ack_opsput(M32R_IRQ_INT1);
@@ -189,7 +189,7 @@ static void enable_opsput_lanpld_irq(uns
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_lanpld(unsigned int irq)
+static void mask_and_ack_opsput_lanpld(unsigned int irq, struct irq_desc *desc)
 {
 	disable_opsput_lanpld_irq(irq);
 }
@@ -258,7 +258,7 @@ static void enable_opsput_lcdpld_irq(uns
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_lcdpld(unsigned int irq)
+static void mask_and_ack_opsput_lcdpld(unsigned int irq, struct irq_desc *desc)
 {
 	disable_opsput_lcdpld_irq(irq);
 }
Index: linux-2.6/arch/m32r/platforms/usrv/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/usrv/setup.c
+++ linux-2.6/arch/m32r/platforms/usrv/setup.c
@@ -37,7 +37,7 @@ static void enable_mappi_irq(unsigned in
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_and_ack_mappi(unsigned int irq, struct irq_desc *desc)
 {
 	disable_mappi_irq(irq);
 }
@@ -107,7 +107,7 @@ static void enable_m32700ut_pld_irq(unsi
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_pld(unsigned int irq)
+static void mask_and_ack_m32700ut_pld(unsigned int irq, struct irq_desc *desc)
 {
 	disable_m32700ut_pld_irq(irq);
 }
Index: linux-2.6/arch/m68knommu/platform/5249/intc2.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/5249/intc2.c
+++ linux-2.6/arch/m68knommu/platform/5249/intc2.c
@@ -17,7 +17,7 @@
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 
-static void intc2_irq_gpio_mask(unsigned int irq)
+static void intc2_irq_gpio_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 imr;
 	imr = readl(MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
@@ -25,7 +25,7 @@ static void intc2_irq_gpio_mask(unsigned
 	writel(imr, MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 }
 
-static void intc2_irq_gpio_unmask(unsigned int irq)
+static void intc2_irq_gpio_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 imr;
 	imr = readl(MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
@@ -33,7 +33,7 @@ static void intc2_irq_gpio_unmask(unsign
 	writel(imr, MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 }
 
-static void intc2_irq_gpio_ack(unsigned int irq)
+static void intc2_irq_gpio_ack(unsigned int irq, struct irq_desc *desc)
 {
 	writel(0x1 << (irq - MCFINTC2_GPIOIRQ0), MCF_MBAR2 + MCFSIM2_GPIOINTCLEAR);
 }
Index: linux-2.6/arch/m68knommu/platform/5272/intc.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/5272/intc.c
+++ linux-2.6/arch/m68knommu/platform/5272/intc.c
@@ -68,7 +68,7 @@ static struct irqmap intc_irqmap[MCFINT_
 	/*MCF_IRQ_SWTO*/	{ .icr = MCFSIM_ICR4, .index = 16, .ack = 0, },
 };
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		u32 v;
@@ -78,7 +78,7 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		u32 v;
@@ -88,7 +88,7 @@ static void intc_irq_unmask(unsigned int
 	}
 }
 
-static void intc_irq_ack(unsigned int irq)
+static void intc_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	/* Only external interrupts are acked */
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
Index: linux-2.6/arch/m68knommu/platform/68328/ints.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/68328/ints.c
+++ linux-2.6/arch/m68knommu/platform/68328/ints.c
@@ -135,12 +135,12 @@ void process_int(int vec, struct pt_regs
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	IMR &= ~(1<<irq);
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	IMR |= (1<<irq);
 }
Index: linux-2.6/arch/m68knommu/platform/68360/ints.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/68360/ints.c
+++ linux-2.6/arch/m68knommu/platform/68360/ints.c
@@ -37,17 +37,17 @@ extern void *_ramvec[];
 /* The number of spurious interrupts */
 volatile unsigned int num_spurious;
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	pquicc->intr_cimr |= (1 << irq);
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	pquicc->intr_cimr &= ~(1 << irq);
 }
 
-static void intc_irq_ack(unsigned int irq)
+static void intc_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	pquicc->intr_cisr = (1 << irq);
 }
Index: linux-2.6/arch/m68knommu/platform/coldfire/intc-2.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/intc-2.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/intc-2.c
@@ -25,7 +25,7 @@
  */
 static u8 intc_intpri = 0x36;
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECBASE + 128)) {
 		unsigned long imraddr;
@@ -42,7 +42,7 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECBASE + 128)) {
 		unsigned long intaddr, imraddr, icraddr;
Index: linux-2.6/arch/m68knommu/platform/coldfire/intc-simr.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/intc-simr.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/intc-simr.c
@@ -18,7 +18,7 @@
 #include <asm/mcfsim.h>
 #include <asm/traps.h>
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
@@ -28,7 +28,7 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
Index: linux-2.6/arch/m68knommu/platform/coldfire/intc.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/intc.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/intc.c
@@ -111,13 +111,13 @@ void mcf_autovector(int irq)
 #endif
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	if (mcf_irq2imr[irq])
 		mcf_setimr(mcf_irq2imr[irq]);
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	if (mcf_irq2imr[irq])
 		mcf_clrimr(mcf_irq2imr[irq]);
Index: linux-2.6/arch/microblaze/kernel/intc.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/intc.c
+++ linux-2.6/arch/microblaze/kernel/intc.c
@@ -40,7 +40,7 @@ unsigned int nr_irq;
 #define MER_ME (1<<0)
 #define MER_HIE (1<<1)
 
-static void intc_enable_or_unmask(unsigned int irq)
+static void intc_enable_or_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long mask = 1 << irq;
 	pr_debug("enable_or_unmask: %d\n", irq);
@@ -54,19 +54,19 @@ static void intc_enable_or_unmask(unsign
 		out_be32(INTC_BASE + IAR, mask);
 }
 
-static void intc_disable_or_mask(unsigned int irq)
+static void intc_disable_or_mask(unsigned int irq, struct irq_desc *desc)
 {
 	pr_debug("disable: %d\n", irq);
 	out_be32(INTC_BASE + CIE, 1 << irq);
 }
 
-static void intc_ack(unsigned int irq)
+static void intc_ack(unsigned int irq, struct irq_desc *desc)
 {
 	pr_debug("ack: %d\n", irq);
 	out_be32(INTC_BASE + IAR, 1 << irq);
 }
 
-static void intc_mask_ack(unsigned int irq)
+static void intc_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long mask = 1 << irq;
 	pr_debug("disable_and_ack: %d\n", irq);
Index: linux-2.6/arch/mips/alchemy/common/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/alchemy/common/irq.c
+++ linux-2.6/arch/mips/alchemy/common/irq.c
@@ -288,7 +288,7 @@ void restore_au1xxx_intctl(void)
 #endif /* CONFIG_PM */
 
 
-static void au1x_ic0_unmask(unsigned int irq_nr)
+static void au1x_ic0_unmask(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
 	au_writel(1 << bit, IC0_MASKSET);
@@ -296,7 +296,7 @@ static void au1x_ic0_unmask(unsigned int
 	au_sync();
 }
 
-static void au1x_ic1_unmask(unsigned int irq_nr)
+static void au1x_ic1_unmask(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
 	au_writel(1 << bit, IC1_MASKSET);
@@ -312,7 +312,7 @@ static void au1x_ic1_unmask(unsigned int
 	au_sync();
 }
 
-static void au1x_ic0_mask(unsigned int irq_nr)
+static void au1x_ic0_mask(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
 	au_writel(1 << bit, IC0_MASKCLR);
@@ -320,7 +320,7 @@ static void au1x_ic0_mask(unsigned int i
 	au_sync();
 }
 
-static void au1x_ic1_mask(unsigned int irq_nr)
+static void au1x_ic1_mask(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
 	au_writel(1 << bit, IC1_MASKCLR);
@@ -328,7 +328,7 @@ static void au1x_ic1_mask(unsigned int i
 	au_sync();
 }
 
-static void au1x_ic0_ack(unsigned int irq_nr)
+static void au1x_ic0_ack(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
 
@@ -341,7 +341,7 @@ static void au1x_ic0_ack(unsigned int ir
 	au_sync();
 }
 
-static void au1x_ic1_ack(unsigned int irq_nr)
+static void au1x_ic1_ack(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
 
@@ -354,7 +354,7 @@ static void au1x_ic1_ack(unsigned int ir
 	au_sync();
 }
 
-static void au1x_ic0_maskack(unsigned int irq_nr)
+static void au1x_ic0_maskack(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
 
@@ -365,7 +365,7 @@ static void au1x_ic0_maskack(unsigned in
 	au_sync();
 }
 
-static void au1x_ic1_maskack(unsigned int irq_nr)
+static void au1x_ic1_maskack(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
 
Index: linux-2.6/arch/mips/alchemy/devboards/pb1200/irqmap.c
===================================================================
--- linux-2.6.orig/arch/mips/alchemy/devboards/pb1200/irqmap.c
+++ linux-2.6/arch/mips/alchemy/devboards/pb1200/irqmap.c
@@ -59,14 +59,14 @@ static void pb1200_cascade_handler(unsig
 /* NOTE: both the enable and mask bits must be cleared, otherwise the
  * CPLD generates tons of spurious interrupts (at least on the DB1200).
  */
-static void pb1200_mask_irq(unsigned int irq_nr)
+static void pb1200_mask_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	bcsr->intclr_mask = 1 << (irq_nr - PB1200_INT_BEGIN);
 	bcsr->intclr = 1 << (irq_nr - PB1200_INT_BEGIN);
 	au_sync();
 }
 
-static void pb1200_maskack_irq(unsigned int irq_nr)
+static void pb1200_maskack_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	bcsr->intclr_mask = 1 << (irq_nr - PB1200_INT_BEGIN);
 	bcsr->intclr = 1 << (irq_nr - PB1200_INT_BEGIN);
@@ -74,7 +74,7 @@ static void pb1200_maskack_irq(unsigned
 	au_sync();
 }
 
-static void pb1200_unmask_irq(unsigned int irq_nr)
+static void pb1200_unmask_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	bcsr->intset = 1 << (irq_nr - PB1200_INT_BEGIN);
 	bcsr->intset_mask = 1 << (irq_nr - PB1200_INT_BEGIN);
Index: linux-2.6/arch/mips/ar7/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/ar7/irq.c
+++ linux-2.6/arch/mips/ar7/irq.c
@@ -48,35 +48,35 @@
 
 static int ar7_irq_base;
 
-static void ar7_unmask_irq(unsigned int irq)
+static void ar7_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << ((irq - ar7_irq_base) % 32),
 	       REG(ESR_OFFSET(irq - ar7_irq_base)));
 }
 
-static void ar7_mask_irq(unsigned int irq)
+static void ar7_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << ((irq - ar7_irq_base) % 32),
 	       REG(ECR_OFFSET(irq - ar7_irq_base)));
 }
 
-static void ar7_ack_irq(unsigned int irq)
+static void ar7_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << ((irq - ar7_irq_base) % 32),
 	       REG(CR_OFFSET(irq - ar7_irq_base)));
 }
 
-static void ar7_unmask_sec_irq(unsigned int irq)
+static void ar7_unmask_sec_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - ar7_irq_base - 40), REG(SEC_ESR_OFFSET));
 }
 
-static void ar7_mask_sec_irq(unsigned int irq)
+static void ar7_mask_sec_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - ar7_irq_base - 40), REG(SEC_ECR_OFFSET));
 }
 
-static void ar7_ack_sec_irq(unsigned int irq)
+static void ar7_ack_sec_irq(unsigned int irq, struct irq_desc *desc)
 {
 	writel(1 << (irq - ar7_irq_base - 40), REG(SEC_CR_OFFSET));
 }
Index: linux-2.6/arch/mips/bcm63xx/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/bcm63xx/irq.c
+++ linux-2.6/arch/mips/bcm63xx/irq.c
@@ -84,8 +84,13 @@ static inline void bcm63xx_internal_irq_
 	mask &= ~(1 << irq);
 	bcm_perf_writel(mask, PERF_IRQMASK_REG);
 }
+static void
+bcm63xx_internal_irq_mask_desc(unsigned int irq, struct irq_desc *desc)
+{
+	bcm63xx_internal_irq_mask(irq);
+}
 
-static void bcm63xx_internal_irq_unmask(unsigned int irq)
+static void bcm63xx_internal_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask;
 
@@ -105,7 +110,7 @@ static unsigned int bcm63xx_internal_irq
  * external IRQs operations: mask/unmask and clear on PERF external
  * irq control register.
  */
-static void bcm63xx_external_irq_mask(unsigned int irq)
+static void bcm63xx_external_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -115,7 +120,7 @@ static void bcm63xx_external_irq_mask(un
 	bcm_perf_writel(reg, PERF_EXTIRQ_CFG_REG);
 }
 
-static void bcm63xx_external_irq_unmask(unsigned int irq)
+static void bcm63xx_external_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -125,7 +130,7 @@ static void bcm63xx_external_irq_unmask(
 	bcm_perf_writel(reg, PERF_EXTIRQ_CFG_REG);
 }
 
-static void bcm63xx_external_irq_clear(unsigned int irq)
+static void bcm63xx_external_irq_clear(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -213,8 +218,8 @@ static struct irq_chip bcm63xx_internal_
 	.startup	= bcm63xx_internal_irq_startup,
 	.shutdown	= bcm63xx_internal_irq_mask,
 
-	.mask		= bcm63xx_internal_irq_mask,
-	.mask_ack	= bcm63xx_internal_irq_mask,
+	.mask		= bcm63xx_internal_irq_mask_desc,
+	.mask_ack	= bcm63xx_internal_irq_mask_desc,
 	.unmask		= bcm63xx_internal_irq_unmask,
 };
 
Index: linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/cavium-octeon/octeon-irq.c
+++ linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
@@ -26,7 +26,7 @@ static int octeon_coreid_for_cpu(int cpu
 #endif
 }
 
-static void octeon_irq_core_ack(unsigned int irq)
+static void octeon_irq_core_ack(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - OCTEON_IRQ_SW0;
 	/*
@@ -40,7 +40,7 @@ static void octeon_irq_core_ack(unsigned
 		clear_c0_cause(0x100 << bit);
 }
 
-static void octeon_irq_core_eoi(unsigned int irq)
+static void octeon_irq_core_eoi(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	unsigned int bit = irq - OCTEON_IRQ_SW0;
@@ -108,7 +108,7 @@ static struct irq_chip octeon_irq_chip_c
 };
 
 
-static void octeon_irq_ciu0_ack(unsigned int irq)
+static void octeon_irq_ciu0_ack(unsigned int irq, struct irq_desc *desc)
 {
 	/*
 	 * In order to avoid any locking accessing the CIU, we
@@ -124,7 +124,7 @@ static void octeon_irq_ciu0_ack(unsigned
 	clear_c0_status(0x100 << 2);
 }
 
-static void octeon_irq_ciu0_eoi(unsigned int irq)
+static void octeon_irq_ciu0_eoi(unsigned int irq, struct irq_desc *desc)
 {
 	/*
 	 * Enable all CIU interrupts again.  We don't need to disable
@@ -188,6 +188,10 @@ static void octeon_irq_ciu0_enable_v2(un
 
 	cvmx_write_csr(CVMX_CIU_INTX_EN0_W1S(index), mask);
 }
+static void octeon_irq_ciu0_enable_v2_desc(unsigned int irq, struct irq_desc *desc)
+{
+	octeon_irq_ciu0_enable_v2(irq);
+}
 
 /*
  * Disable the irq on the current core for chips that have the EN*_W1{S,C}
@@ -200,6 +204,10 @@ static void octeon_irq_ciu0_disable_v2(u
 
 	cvmx_write_csr(CVMX_CIU_INTX_EN0_W1C(index), mask);
 }
+static void octeon_irq_ciu0_disable_v2_desc(unsigned int irq, struct irq_desc *desc)
+{
+	octeon_irq_ciu0_disable_v2(irq);
+}
 
 /*
  * Disable the irq on the all cores for chips that have the EN*_W1{S,C}
@@ -272,8 +280,8 @@ static struct irq_chip octeon_irq_chip_c
 	.name = "CIU0",
 	.enable = octeon_irq_ciu0_enable_v2,
 	.disable = octeon_irq_ciu0_disable_all_v2,
-	.ack = octeon_irq_ciu0_disable_v2,
-	.eoi = octeon_irq_ciu0_enable_v2,
+	.ack = octeon_irq_ciu0_disable_v2_desc,
+	.eoi = octeon_irq_ciu0_enable_v2_desc,
 #ifdef CONFIG_SMP
 	.set_affinity = octeon_irq_ciu0_set_affinity_v2,
 #endif
@@ -291,7 +299,7 @@ static struct irq_chip octeon_irq_chip_c
 };
 
 
-static void octeon_irq_ciu1_ack(unsigned int irq)
+static void octeon_irq_ciu1_ack(unsigned int irq, struct irq_desc *desc)
 {
 	/*
 	 * In order to avoid any locking accessing the CIU, we
@@ -305,7 +313,7 @@ static void octeon_irq_ciu1_ack(unsigned
 	clear_c0_status(0x100 << 3);
 }
 
-static void octeon_irq_ciu1_eoi(unsigned int irq)
+static void octeon_irq_ciu1_eoi(unsigned int irq, struct irq_desc *desc)
 {
 	/*
 	 * Enable all CIU interrupts again.  We don't need to disable
@@ -369,6 +377,10 @@ static void octeon_irq_ciu1_enable_v2(un
 
 	cvmx_write_csr(CVMX_CIU_INTX_EN1_W1S(index), mask);
 }
+static void octeon_irq_ciu1_enable_v2_desc(unsigned int irq, struct irq_desc *desc)
+{
+	octeon_irq_ciu1_enable_v2(irq);
+}
 
 /*
  * Disable the irq on the current core for chips that have the EN*_W1{S,C}
@@ -381,6 +393,10 @@ static void octeon_irq_ciu1_disable_v2(u
 
 	cvmx_write_csr(CVMX_CIU_INTX_EN1_W1C(index), mask);
 }
+static void octeon_irq_ciu1_disable_v2_desc(unsigned int irq, struct irq_desc *desc)
+{
+	octeon_irq_ciu1_disable_v2(irq);
+}
 
 /*
  * Disable the irq on the all cores for chips that have the EN*_W1{S,C}
@@ -455,8 +471,8 @@ static struct irq_chip octeon_irq_chip_c
 	.name = "CIU0",
 	.enable = octeon_irq_ciu1_enable_v2,
 	.disable = octeon_irq_ciu1_disable_all_v2,
-	.ack = octeon_irq_ciu1_disable_v2,
-	.eoi = octeon_irq_ciu1_enable_v2,
+	.ack = octeon_irq_ciu1_disable_v2_desc,
+	.eoi = octeon_irq_ciu1_enable_v2_desc,
 #ifdef CONFIG_SMP
 	.set_affinity = octeon_irq_ciu1_set_affinity_v2,
 #endif
@@ -475,7 +491,7 @@ static struct irq_chip octeon_irq_chip_c
 
 #ifdef CONFIG_PCI_MSI
 
-static void octeon_irq_msi_ack(unsigned int irq)
+static void octeon_irq_msi_ack(unsigned int irq, struct irq_desc *desc)
 {
 	if (!octeon_has_feature(OCTEON_FEATURE_PCIE)) {
 		/* These chips have PCI */
@@ -491,7 +507,7 @@ static void octeon_irq_msi_ack(unsigned
 	}
 }
 
-static void octeon_irq_msi_eoi(unsigned int irq)
+static void octeon_irq_msi_eoi(unsigned int irq, struct irq_desc *desc)
 {
 	/* Nothing needed */
 }
Index: linux-2.6/arch/mips/dec/ioasic-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/dec/ioasic-irq.c
+++ linux-2.6/arch/mips/dec/ioasic-irq.c
@@ -21,7 +21,7 @@
 static int ioasic_irq_base;
 
 
-static inline void unmask_ioasic_irq(unsigned int irq)
+static inline void unmask_ioasic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u32 simr;
 
@@ -30,7 +30,7 @@ static inline void unmask_ioasic_irq(uns
 	ioasic_write(IO_REG_SIMR, simr);
 }
 
-static inline void mask_ioasic_irq(unsigned int irq)
+static inline void mask_ioasic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u32 simr;
 
@@ -47,7 +47,7 @@ static inline void clear_ioasic_irq(unsi
 	ioasic_write(IO_REG_SIR, sir);
 }
 
-static inline void ack_ioasic_irq(unsigned int irq)
+static inline void ack_ioasic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	mask_ioasic_irq(irq);
 	fast_iob();
Index: linux-2.6/arch/mips/dec/kn02-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/dec/kn02-irq.c
+++ linux-2.6/arch/mips/dec/kn02-irq.c
@@ -31,7 +31,7 @@ u32 cached_kn02_csr;
 static int kn02_irq_base;
 
 
-static inline void unmask_kn02_irq(unsigned int irq)
+static inline void unmask_kn02_irq(unsigned int irq, struct irq_desc *desc)
 {
 	volatile u32 *csr = (volatile u32 *)CKSEG1ADDR(KN02_SLOT_BASE +
 						       KN02_CSR);
@@ -40,7 +40,7 @@ static inline void unmask_kn02_irq(unsig
 	*csr = cached_kn02_csr;
 }
 
-static inline void mask_kn02_irq(unsigned int irq)
+static inline void mask_kn02_irq(unsigned int irq, struct irq_desc *desc)
 {
 	volatile u32 *csr = (volatile u32 *)CKSEG1ADDR(KN02_SLOT_BASE +
 						       KN02_CSR);
@@ -49,7 +49,7 @@ static inline void mask_kn02_irq(unsigne
 	*csr = cached_kn02_csr;
 }
 
-static void ack_kn02_irq(unsigned int irq)
+static void ack_kn02_irq(unsigned int irq, struct irq_desc *desc)
 {
 	mask_kn02_irq(irq);
 	iob();
Index: linux-2.6/arch/mips/emma/markeins/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/emma/markeins/irq.c
+++ linux-2.6/arch/mips/emma/markeins/irq.c
@@ -34,7 +34,7 @@
 
 #include <asm/emma/emma2rh.h>
 
-static void emma2rh_irq_enable(unsigned int irq)
+static void emma2rh_irq_enable(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg_value;
 	u32 reg_bitmask;
@@ -49,7 +49,7 @@ static void emma2rh_irq_enable(unsigned
 	emma2rh_out32(reg_index, reg_value | reg_bitmask);
 }
 
-static void emma2rh_irq_disable(unsigned int irq)
+static void emma2rh_irq_disable(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg_value;
 	u32 reg_bitmask;
@@ -82,7 +82,7 @@ void emma2rh_irq_init(void)
 					      handle_level_irq, "level");
 }
 
-static void emma2rh_sw_irq_enable(unsigned int irq)
+static void emma2rh_sw_irq_enable(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -93,7 +93,7 @@ static void emma2rh_sw_irq_enable(unsign
 	emma2rh_out32(EMMA2RH_BHIF_SW_INT_EN, reg);
 }
 
-static void emma2rh_sw_irq_disable(unsigned int irq)
+static void emma2rh_sw_irq_disable(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -122,7 +122,7 @@ void emma2rh_sw_irq_init(void)
 					      handle_level_irq, "level");
 }
 
-static void emma2rh_gpio_irq_enable(unsigned int irq)
+static void emma2rh_gpio_irq_enable(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -133,7 +133,7 @@ static void emma2rh_gpio_irq_enable(unsi
 	emma2rh_out32(EMMA2RH_GPIO_INT_MASK, reg);
 }
 
-static void emma2rh_gpio_irq_disable(unsigned int irq)
+static void emma2rh_gpio_irq_disable(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -144,13 +144,13 @@ static void emma2rh_gpio_irq_disable(uns
 	emma2rh_out32(EMMA2RH_GPIO_INT_MASK, reg);
 }
 
-static void emma2rh_gpio_irq_ack(unsigned int irq)
+static void emma2rh_gpio_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= EMMA2RH_GPIO_IRQ_BASE;
 	emma2rh_out32(EMMA2RH_GPIO_INT_ST, ~(1 << irq));
 }
 
-static void emma2rh_gpio_irq_mask_ack(unsigned int irq)
+static void emma2rh_gpio_irq_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u32 reg;
 
Index: linux-2.6/arch/mips/jazz/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/jazz/irq.c
+++ linux-2.6/arch/mips/jazz/irq.c
@@ -22,7 +22,7 @@
 
 static DEFINE_SPINLOCK(r4030_lock);
 
-static void enable_r4030_irq(unsigned int irq)
+static void enable_r4030_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq - JAZZ_IRQ_START);
 	unsigned long flags;
@@ -33,7 +33,7 @@ static void enable_r4030_irq(unsigned in
 	spin_unlock_irqrestore(&r4030_lock, flags);
 }
 
-void disable_r4030_irq(unsigned int irq)
+void disable_r4030_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = ~(1 << (irq - JAZZ_IRQ_START));
 	unsigned long flags;
Index: linux-2.6/arch/mips/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/i8259.c
+++ linux-2.6/arch/mips/kernel/i8259.c
@@ -31,15 +31,23 @@
 static int i8259A_auto_eoi = -1;
 DEFINE_SPINLOCK(i8259A_lock);
 static void disable_8259A_irq(unsigned int irq);
+static void disable_8259A_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	disable_8259A_irq(irq);
+}
 static void enable_8259A_irq(unsigned int irq);
-static void mask_and_ack_8259A(unsigned int irq);
+static void enable_8259A_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	enable_8259A_irq(irq);
+}
+static void mask_and_ack_8259A(unsigned int irq, struct irq_desc *desc);
 static void init_8259A(int auto_eoi);
 
 static struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
-	.mask		= disable_8259A_irq,
+	.mask		= disable_8259A_irq_desc,
 	.disable	= disable_8259A_irq,
-	.unmask		= enable_8259A_irq,
+	.unmask		= enable_8259A_irq_desc,
 	.mask_ack	= mask_and_ack_8259A,
 #ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
 	.set_affinity	= plat_set_irq_affinity,
@@ -144,7 +152,7 @@ static inline int i8259A_irq_real(unsign
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-static void mask_and_ack_8259A(unsigned int irq)
+static void mask_and_ack_8259A(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int irqmask;
 	unsigned long flags;
Index: linux-2.6/arch/mips/kernel/irq-gic.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-gic.c
+++ linux-2.6/arch/mips/kernel/irq-gic.c
@@ -96,7 +96,7 @@ static unsigned int gic_irq_startup(unsi
 	return 0;
 }
 
-static void gic_irq_ack(unsigned int irq)
+static void gic_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= _irqbase;
 	pr_debug("CPU%d: %s: irq%d\n", smp_processor_id(), __func__, irq);
@@ -106,14 +106,14 @@ static void gic_irq_ack(unsigned int irq
 		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
 }
 
-static void gic_mask_irq(unsigned int irq)
+static void gic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= _irqbase;
 	pr_debug("CPU%d: %s: irq%d\n", smp_processor_id(), __func__, irq);
 	GIC_CLR_INTR_MASK(irq);
 }
 
-static void gic_unmask_irq(unsigned int irq)
+static void gic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	irq -= _irqbase;
 	pr_debug("CPU%d: %s: irq%d\n", smp_processor_id(), __func__, irq);
Index: linux-2.6/arch/mips/kernel/irq-gt641xx.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-gt641xx.c
+++ linux-2.6/arch/mips/kernel/irq-gt641xx.c
@@ -29,7 +29,7 @@
 
 static DEFINE_SPINLOCK(gt641xx_irq_lock);
 
-static void ack_gt641xx_irq(unsigned int irq)
+static void ack_gt641xx_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	u32 cause;
@@ -41,7 +41,7 @@ static void ack_gt641xx_irq(unsigned int
 	spin_unlock_irqrestore(&gt641xx_irq_lock, flags);
 }
 
-static void mask_gt641xx_irq(unsigned int irq)
+static void mask_gt641xx_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	u32 mask;
@@ -53,7 +53,7 @@ static void mask_gt641xx_irq(unsigned in
 	spin_unlock_irqrestore(&gt641xx_irq_lock, flags);
 }
 
-static void mask_ack_gt641xx_irq(unsigned int irq)
+static void mask_ack_gt641xx_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	u32 cause, mask;
@@ -69,7 +69,7 @@ static void mask_ack_gt641xx_irq(unsigne
 	spin_unlock_irqrestore(&gt641xx_irq_lock, flags);
 }
 
-static void unmask_gt641xx_irq(unsigned int irq)
+static void unmask_gt641xx_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	u32 mask;
Index: linux-2.6/arch/mips/kernel/irq-msc01.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-msc01.c
+++ linux-2.6/arch/mips/kernel/irq-msc01.c
@@ -28,7 +28,7 @@ static unsigned long _icctrl_msc;
 static unsigned int irq_base;
 
 /* mask off an interrupt */
-static inline void mask_msc_irq(unsigned int irq)
+static inline void mask_msc_irq(unsigned int irq, struct irq_desc *desc)
 {
 	if (irq < (irq_base + 32))
 		MSCIC_WRITE(MSC01_IC_DISL, 1<<(irq - irq_base));
@@ -37,7 +37,7 @@ static inline void mask_msc_irq(unsigned
 }
 
 /* unmask an interrupt */
-static inline void unmask_msc_irq(unsigned int irq)
+static inline void unmask_msc_irq(unsigned int irq, struct irq_desc *desc)
 {
 	if (irq < (irq_base + 32))
 		MSCIC_WRITE(MSC01_IC_ENAL, 1<<(irq - irq_base));
@@ -48,7 +48,7 @@ static inline void unmask_msc_irq(unsign
 /*
  * Masks and ACKs an IRQ
  */
-static void level_mask_and_ack_msc_irq(unsigned int irq)
+static void level_mask_and_ack_msc_irq(unsigned int irq, struct irq_desc *desc)
 {
 	mask_msc_irq(irq);
 	if (!cpu_has_veic)
@@ -60,7 +60,7 @@ static void level_mask_and_ack_msc_irq(u
 /*
  * Masks and ACKs an IRQ
  */
-static void edge_mask_and_ack_msc_irq(unsigned int irq)
+static void edge_mask_and_ack_msc_irq(unsigned int irq, struct irq_desc *desc)
 {
 	mask_msc_irq(irq);
 	if (!cpu_has_veic)
Index: linux-2.6/arch/mips/kernel/irq-rm7000.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-rm7000.c
+++ linux-2.6/arch/mips/kernel/irq-rm7000.c
@@ -17,12 +17,12 @@
 #include <asm/mipsregs.h>
 #include <asm/system.h>
 
-static inline void unmask_rm7k_irq(unsigned int irq)
+static inline void unmask_rm7k_irq(unsigned int irq, struct irq_desc *desc)
 {
 	set_c0_intcontrol(0x100 << (irq - RM7K_CPU_IRQ_BASE));
 }
 
-static inline void mask_rm7k_irq(unsigned int irq)
+static inline void mask_rm7k_irq(unsigned int irq, struct irq_desc *desc)
 {
 	clear_c0_intcontrol(0x100 << (irq - RM7K_CPU_IRQ_BASE));
 }
Index: linux-2.6/arch/mips/kernel/irq-rm9000.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-rm9000.c
+++ linux-2.6/arch/mips/kernel/irq-rm9000.c
@@ -18,7 +18,7 @@
 #include <asm/mipsregs.h>
 #include <asm/system.h>
 
-static inline void unmask_rm9k_irq(unsigned int irq)
+static inline void unmask_rm9k_irq(unsigned int irq, struct irq_desc *desc)
 {
 	set_c0_intcontrol(0x1000 << (irq - RM9K_CPU_IRQ_BASE));
 }
@@ -28,7 +28,7 @@ static inline void mask_rm9k_irq(unsigne
 	clear_c0_intcontrol(0x1000 << (irq - RM9K_CPU_IRQ_BASE));
 }
 
-static inline void rm9k_cpu_irq_enable(unsigned int irq)
+static inline void rm9k_cpu_irq_enable(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 
Index: linux-2.6/arch/mips/kernel/irq_cpu.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq_cpu.c
+++ linux-2.6/arch/mips/kernel/irq_cpu.c
@@ -36,13 +36,13 @@
 #include <asm/mipsmtregs.h>
 #include <asm/system.h>
 
-static inline void unmask_mips_irq(unsigned int irq)
+static inline void unmask_mips_irq(unsigned int irq, struct irq_desc *desc)
 {
 	set_c0_status(0x100 << (irq - MIPS_CPU_IRQ_BASE));
 	irq_enable_hazard();
 }
 
-static inline void mask_mips_irq(unsigned int irq)
+static inline void mask_mips_irq(unsigned int irq, struct irq_desc *desc)
 {
 	clear_c0_status(0x100 << (irq - MIPS_CPU_IRQ_BASE));
 	irq_disable_hazard();
@@ -79,7 +79,7 @@ static unsigned int mips_mt_cpu_irq_star
  * While we ack the interrupt interrupts are disabled and thus we don't need
  * to deal with concurrency issues.  Same for mips_cpu_irq_end.
  */
-static void mips_mt_cpu_irq_ack(unsigned int irq)
+static void mips_mt_cpu_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int vpflags = dvpe();
 	clear_c0_cause(0x100 << (irq - MIPS_CPU_IRQ_BASE));
Index: linux-2.6/arch/mips/kernel/irq_txx9.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq_txx9.c
+++ linux-2.6/arch/mips/kernel/irq_txx9.c
@@ -62,7 +62,7 @@ static struct {
 	unsigned char mode;
 } txx9irq[TXx9_MAX_IR] __read_mostly;
 
-static void txx9_irq_unmask(unsigned int irq)
+static void txx9_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *ilrp = &txx9_ircptr->ilr[(irq_nr % 16 ) / 2];
@@ -78,7 +78,7 @@ static void txx9_irq_unmask(unsigned int
 #endif
 }
 
-static inline void txx9_irq_mask(unsigned int irq)
+static inline void txx9_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *ilrp = &txx9_ircptr->ilr[(irq_nr % 16) / 2];
@@ -98,7 +98,7 @@ static inline void txx9_irq_mask(unsigne
 #endif
 }
 
-static void txx9_irq_mask_ack(unsigned int irq)
+static void txx9_irq_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 
Index: linux-2.6/arch/mips/lasat/interrupt.c
===================================================================
--- linux-2.6.orig/arch/mips/lasat/interrupt.c
+++ linux-2.6/arch/mips/lasat/interrupt.c
@@ -32,13 +32,13 @@ static volatile int *lasat_int_status;
 static volatile int *lasat_int_mask;
 static volatile int lasat_int_mask_shift;
 
-void disable_lasat_irq(unsigned int irq_nr)
+void disable_lasat_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	irq_nr -= LASAT_IRQ_BASE;
 	*lasat_int_mask &= ~(1 << irq_nr) << lasat_int_mask_shift;
 }
 
-void enable_lasat_irq(unsigned int irq_nr)
+void enable_lasat_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	irq_nr -= LASAT_IRQ_BASE;
 	*lasat_int_mask |= (1 << irq_nr) << lasat_int_mask_shift;
Index: linux-2.6/arch/mips/loongson/common/bonito-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/loongson/common/bonito-irq.c
+++ linux-2.6/arch/mips/loongson/common/bonito-irq.c
@@ -16,13 +16,13 @@
 
 #include <loongson.h>
 
-static inline void bonito_irq_enable(unsigned int irq)
+static inline void bonito_irq_enable(unsigned int irq, struct irq_desc *desc)
 {
 	LOONGSON_INTENSET = (1 << (irq - LOONGSON_IRQ_BASE));
 	mmiowb();
 }
 
-static inline void bonito_irq_disable(unsigned int irq)
+static inline void bonito_irq_disable(unsigned int irq, struct irq_desc *desc)
 {
 	LOONGSON_INTENCLR = (1 << (irq - LOONGSON_IRQ_BASE));
 	mmiowb();
Index: linux-2.6/arch/mips/nxp/pnx833x/common/interrupts.c
===================================================================
--- linux-2.6.orig/arch/mips/nxp/pnx833x/common/interrupts.c
+++ linux-2.6/arch/mips/nxp/pnx833x/common/interrupts.c
@@ -212,7 +212,7 @@ static void pnx833x_disable_pic_irq(unsi
 	spin_unlock_irqrestore(&pnx833x_irq_lock, flags);
 }
 
-static void pnx833x_ack_pic_irq(unsigned int irq)
+static void pnx833x_ack_pic_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
@@ -250,7 +250,7 @@ static void pnx833x_disable_gpio_irq(uns
 	spin_unlock_irqrestore(&pnx833x_gpio_pnx833x_irq_lock, flags);
 }
 
-static void pnx833x_ack_gpio_irq(unsigned int irq)
+static void pnx833x_ack_gpio_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/mips/nxp/pnx8550/common/int.c
===================================================================
--- linux-2.6.orig/arch/mips/nxp/pnx8550/common/int.c
+++ linux-2.6/arch/mips/nxp/pnx8550/common/int.c
@@ -115,7 +115,7 @@ static inline void unmask_gic_int(unsign
 	PNX8550_GIC_REQ(irq_nr) = (1<<26 | 1<<16) | (1<<28) | gic_prio[irq_nr];
 }
 
-static inline void mask_irq(unsigned int irq_nr)
+static inline void mask_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	if ((PNX8550_INT_CP0_MIN <= irq_nr) && (irq_nr <= PNX8550_INT_CP0_MAX)) {
 		modify_cp0_intmask(1 << irq_nr, 0);
@@ -130,7 +130,7 @@ static inline void mask_irq(unsigned int
 	}
 }
 
-static inline void unmask_irq(unsigned int irq_nr)
+static inline void unmask_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	if ((PNX8550_INT_CP0_MIN <= irq_nr) && (irq_nr <= PNX8550_INT_CP0_MAX)) {
 		modify_cp0_intmask(0, 1 << irq_nr);
Index: linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
===================================================================
--- linux-2.6.orig/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
+++ linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
@@ -24,7 +24,7 @@
  * NOTE: We are only enabling support for VPE0 right now.
  */
 
-static inline void unmask_msp_cic_irq(unsigned int irq)
+static inline void unmask_msp_cic_irq(unsigned int irq, struct irq_desc *desc)
 {
 
 	/* check for PER interrupt range */
@@ -47,7 +47,7 @@ static inline void mask_msp_cic_irq(unsi
  * While we ack the interrupt interrupts are disabled and thus we don't need
  * to deal with concurrency issues.  Same for msp_cic_irq_end.
  */
-static inline void ack_msp_cic_irq(unsigned int irq)
+static inline void ack_msp_cic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	mask_msp_cic_irq(irq);
 
Index: linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
===================================================================
--- linux-2.6.orig/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
+++ linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
@@ -21,7 +21,7 @@
 #include <msp_slp_int.h>
 #include <msp_regs.h>
 
-static inline void unmask_msp_slp_irq(unsigned int irq)
+static inline void unmask_msp_slp_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
@@ -30,7 +30,7 @@ static inline void unmask_msp_slp_irq(un
 		*PER_INT_MSK_REG |= (1 << (irq - MSP_PER_INTBASE));
 }
 
-static inline void mask_msp_slp_irq(unsigned int irq)
+static inline void mask_msp_slp_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
@@ -43,7 +43,7 @@ static inline void mask_msp_slp_irq(unsi
  * While we ack the interrupt interrupts are disabled and thus we don't need
  * to deal with concurrency issues.  Same for msp_slp_irq_end.
  */
-static inline void ack_msp_slp_irq(unsigned int irq)
+static inline void ack_msp_slp_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
Index: linux-2.6/arch/mips/powertv/asic/irq_asic.c
===================================================================
--- linux-2.6.orig/arch/mips/powertv/asic/irq_asic.c
+++ linux-2.6/arch/mips/powertv/asic/irq_asic.c
@@ -20,7 +20,7 @@
 
 #include <asm/mach-powertv/asic_regs.h>
 
-static inline void unmask_asic_irq(unsigned int irq)
+static inline void unmask_asic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long enable_bit;
 
@@ -44,7 +44,7 @@ static inline void unmask_asic_irq(unsig
 	}
 }
 
-static inline void mask_asic_irq(unsigned int irq)
+static inline void mask_asic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long disable_mask;
 
Index: linux-2.6/arch/mips/rb532/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/rb532/irq.c
+++ linux-2.6/arch/mips/rb532/irq.c
@@ -112,7 +112,7 @@ static inline void ack_local_irq(unsigne
 	clear_c0_cause(ipnum);
 }
 
-static void rb532_enable_irq(unsigned int irq_nr)
+static void rb532_enable_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	int ip = irq_nr - GROUP0_IRQ_BASE;
 	unsigned int group, intr_bit;
@@ -133,7 +133,7 @@ static void rb532_enable_irq(unsigned in
 	}
 }
 
-static void rb532_disable_irq(unsigned int irq_nr)
+static void rb532_disable_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	int ip = irq_nr - GROUP0_IRQ_BASE;
 	unsigned int group, intr_bit, mask;
@@ -164,7 +164,7 @@ static void rb532_disable_irq(unsigned i
 	}
 }
 
-static void rb532_mask_and_ack_irq(unsigned int irq_nr)
+static void rb532_mask_and_ack_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	rb532_disable_irq(irq_nr);
 	ack_local_irq(group_to_ip(irq_to_group(irq_nr)));
Index: linux-2.6/arch/mips/sgi-ip22/ip22-int.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip22/ip22-int.c
+++ linux-2.6/arch/mips/sgi-ip22/ip22-int.c
@@ -31,7 +31,7 @@ static char lc3msk_to_irqnr[256];
 
 extern int ip22_eisa_init(void);
 
-static void enable_local0_irq(unsigned int irq)
+static void enable_local0_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* don't allow mappable interrupt to be enabled from setup_irq,
 	 * we have our own way to do so */
@@ -39,7 +39,7 @@ static void enable_local0_irq(unsigned i
 		sgint->imask0 |= (1 << (irq - SGINT_LOCAL0));
 }
 
-static void disable_local0_irq(unsigned int irq)
+static void disable_local0_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sgint->imask0 &= ~(1 << (irq - SGINT_LOCAL0));
 }
@@ -52,7 +52,7 @@ static struct irq_chip ip22_local0_irq_t
 	.unmask		= enable_local0_irq,
 };
 
-static void enable_local1_irq(unsigned int irq)
+static void enable_local1_irq(unsigned int irq, struct irq_desc *desc)
 {
 	/* don't allow mappable interrupt to be enabled from setup_irq,
 	 * we have our own way to do so */
@@ -60,7 +60,7 @@ static void enable_local1_irq(unsigned i
 		sgint->imask1 |= (1 << (irq - SGINT_LOCAL1));
 }
 
-static void disable_local1_irq(unsigned int irq)
+static void disable_local1_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sgint->imask1 &= ~(1 << (irq - SGINT_LOCAL1));
 }
@@ -73,13 +73,13 @@ static struct irq_chip ip22_local1_irq_t
 	.unmask		= enable_local1_irq,
 };
 
-static void enable_local2_irq(unsigned int irq)
+static void enable_local2_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sgint->imask0 |= (1 << (SGI_MAP_0_IRQ - SGINT_LOCAL0));
 	sgint->cmeimask0 |= (1 << (irq - SGINT_LOCAL2));
 }
 
-static void disable_local2_irq(unsigned int irq)
+static void disable_local2_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sgint->cmeimask0 &= ~(1 << (irq - SGINT_LOCAL2));
 	if (!sgint->cmeimask0)
@@ -94,13 +94,13 @@ static struct irq_chip ip22_local2_irq_t
 	.unmask		= enable_local2_irq,
 };
 
-static void enable_local3_irq(unsigned int irq)
+static void enable_local3_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sgint->imask1 |= (1 << (SGI_MAP_1_IRQ - SGINT_LOCAL1));
 	sgint->cmeimask1 |= (1 << (irq - SGINT_LOCAL3));
 }
 
-static void disable_local3_irq(unsigned int irq)
+static void disable_local3_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sgint->cmeimask1 &= ~(1 << (irq - SGINT_LOCAL3));
 	if (!sgint->cmeimask1)
Index: linux-2.6/arch/mips/sgi-ip27/ip27-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip27/ip27-irq.c
+++ linux-2.6/arch/mips/sgi-ip27/ip27-irq.c
@@ -310,7 +310,7 @@ static void shutdown_bridge_irq(unsigned
 	bridge->b_wid_tflush;
 }
 
-static inline void enable_bridge_irq(unsigned int irq)
+static inline void enable_bridge_irq(unsigned int irq, struct irq_desc *desc)
 {
 	cpuid_t cpu;
 	int swlevel;
@@ -319,7 +319,7 @@ static inline void enable_bridge_irq(uns
 	intr_connect_level(cpu, swlevel);
 }
 
-static inline void disable_bridge_irq(unsigned int irq)
+static inline void disable_bridge_irq(unsigned int irq, struct irq_desc *desc)
 {
 	cpuid_t cpu;
 	int swlevel;
Index: linux-2.6/arch/mips/sgi-ip27/ip27-timer.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip27/ip27-timer.c
+++ linux-2.6/arch/mips/sgi-ip27/ip27-timer.c
@@ -36,11 +36,11 @@
 #include <asm/sn/sn0/hubio.h>
 #include <asm/pci/bridge.h>
 
-static void enable_rt_irq(unsigned int irq)
+static void enable_rt_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
-static void disable_rt_irq(unsigned int irq)
+static void disable_rt_irq(unsigned int irq, struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip32/ip32-irq.c
+++ linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
@@ -131,7 +131,7 @@ static struct irqaction cpuerr_irq = {
 
 static uint64_t crime_mask;
 
-static inline void crime_enable_irq(unsigned int irq)
+static inline void crime_enable_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
@@ -139,7 +139,7 @@ static inline void crime_enable_irq(unsi
 	crime->imask = crime_mask;
 }
 
-static inline void crime_disable_irq(unsigned int irq)
+static inline void crime_disable_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
@@ -148,7 +148,7 @@ static inline void crime_disable_irq(uns
 	flush_crime_bus();
 }
 
-static void crime_level_mask_and_ack_irq(unsigned int irq)
+static void crime_level_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	crime_disable_irq(irq);
 }
@@ -168,7 +168,7 @@ static struct irq_chip crime_level_inter
 	.end		= crime_level_end_irq,
 };
 
-static void crime_edge_mask_and_ack_irq(unsigned int irq)
+static void crime_edge_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 	uint64_t crime_int;
@@ -205,7 +205,7 @@ static struct irq_chip crime_edge_interr
 
 static unsigned long macepci_mask;
 
-static void enable_macepci_irq(unsigned int irq)
+static void enable_macepci_irq(unsigned int irq, struct irq_desc *desc)
 {
 	macepci_mask |= MACEPCI_CONTROL_INT(irq - MACEPCI_SCSI0_IRQ);
 	mace->pci.control = macepci_mask;
@@ -213,7 +213,7 @@ static void enable_macepci_irq(unsigned
 	crime->imask = crime_mask;
 }
 
-static void disable_macepci_irq(unsigned int irq)
+static void disable_macepci_irq(unsigned int irq, struct irq_desc *desc)
 {
 	crime_mask &= ~(1 << (irq - CRIME_IRQ_BASE));
 	crime->imask = crime_mask;
@@ -277,7 +277,7 @@ static struct irq_chip ip32_macepci_inte
 
 static unsigned long maceisa_mask;
 
-static void enable_maceisa_irq(unsigned int irq)
+static void enable_maceisa_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int crime_int = 0;
 
@@ -301,7 +301,7 @@ static void enable_maceisa_irq(unsigned
 	mace->perif.ctrl.imask = maceisa_mask;
 }
 
-static void disable_maceisa_irq(unsigned int irq)
+static void disable_maceisa_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int crime_int = 0;
 
@@ -319,7 +319,7 @@ static void disable_maceisa_irq(unsigned
 	flush_mace_bus();
 }
 
-static void mask_and_ack_maceisa_irq(unsigned int irq)
+static void mask_and_ack_maceisa_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long mace_int;
 
@@ -359,7 +359,7 @@ static struct irq_chip ip32_maceisa_edge
  * bits 0-3 and 7 in the CRIME register.
  */
 
-static void enable_mace_irq(unsigned int irq)
+static void enable_mace_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
@@ -367,7 +367,7 @@ static void enable_mace_irq(unsigned int
 	crime->imask = crime_mask;
 }
 
-static void disable_mace_irq(unsigned int irq)
+static void disable_mace_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
Index: linux-2.6/arch/mips/sibyte/bcm1480/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/irq.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/irq.c
@@ -47,9 +47,9 @@
 
 
 static void end_bcm1480_irq(unsigned int irq);
-static void enable_bcm1480_irq(unsigned int irq);
-static void disable_bcm1480_irq(unsigned int irq);
-static void ack_bcm1480_irq(unsigned int irq);
+static void enable_bcm1480_irq(unsigned int irq, struct irq_desc *desc);
+static void disable_bcm1480_irq(unsigned int irq, struct irq_desc *desc);
+static void ack_bcm1480_irq(unsigned int irq, struct irq_desc *desc);
 #ifdef CONFIG_SMP
 static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
@@ -157,18 +157,18 @@ static int bcm1480_set_affinity(unsigned
 
 /*****************************************************************************/
 
-static void disable_bcm1480_irq(unsigned int irq)
+static void disable_bcm1480_irq(unsigned int irq, struct irq_desc *desc)
 {
 	bcm1480_mask_irq(bcm1480_irq_owner[irq], irq);
 }
 
-static void enable_bcm1480_irq(unsigned int irq)
+static void enable_bcm1480_irq(unsigned int irq, struct irq_desc *desc)
 {
 	bcm1480_unmask_irq(bcm1480_irq_owner[irq], irq);
 }
 
 
-static void ack_bcm1480_irq(unsigned int irq)
+static void ack_bcm1480_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u64 pending;
 	unsigned int irq_dirty;
Index: linux-2.6/arch/mips/sibyte/sb1250/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/irq.c
+++ linux-2.6/arch/mips/sibyte/sb1250/irq.c
@@ -46,9 +46,9 @@
 
 
 static void end_sb1250_irq(unsigned int irq);
-static void enable_sb1250_irq(unsigned int irq);
-static void disable_sb1250_irq(unsigned int irq);
-static void ack_sb1250_irq(unsigned int irq);
+static void enable_sb1250_irq(unsigned int irq, struct irq_desc *desc);
+static void disable_sb1250_irq(unsigned int irq, struct irq_desc *desc);
+static void ack_sb1250_irq(unsigned int irq, struct irq_desc *desc);
 #ifdef CONFIG_SMP
 static int sb1250_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
@@ -145,18 +145,18 @@ static int sb1250_set_affinity(unsigned
 
 /*****************************************************************************/
 
-static void disable_sb1250_irq(unsigned int irq)
+static void disable_sb1250_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sb1250_mask_irq(sb1250_irq_owner[irq], irq);
 }
 
-static void enable_sb1250_irq(unsigned int irq)
+static void enable_sb1250_irq(unsigned int irq, struct irq_desc *desc)
 {
 	sb1250_unmask_irq(sb1250_irq_owner[irq], irq);
 }
 
 
-static void ack_sb1250_irq(unsigned int irq)
+static void ack_sb1250_irq(unsigned int irq, struct irq_desc *desc)
 {
 #ifdef CONFIG_SIBYTE_HAS_LDT
 	u64 pending;
Index: linux-2.6/arch/mips/sni/a20r.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/a20r.c
+++ linux-2.6/arch/mips/sni/a20r.c
@@ -167,13 +167,13 @@ static u32 a20r_ack_hwint(void)
 	return status;
 }
 
-static inline void unmask_a20r_irq(unsigned int irq)
+static inline void unmask_a20r_irq(unsigned int irq, struct irq_desc *desc)
 {
 	set_c0_status(0x100 << (irq - SNI_A20R_IRQ_BASE));
 	irq_enable_hazard();
 }
 
-static inline void mask_a20r_irq(unsigned int irq)
+static inline void mask_a20r_irq(unsigned int irq, struct irq_desc *desc)
 {
 	clear_c0_status(0x100 << (irq - SNI_A20R_IRQ_BASE));
 	irq_disable_hazard();
Index: linux-2.6/arch/mips/sni/pcimt.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/pcimt.c
+++ linux-2.6/arch/mips/sni/pcimt.c
@@ -193,14 +193,14 @@ static struct pci_controller sni_control
 	.io_map_base    = SNI_PORT_BASE
 };
 
-static void enable_pcimt_irq(unsigned int irq)
+static void enable_pcimt_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq - PCIMT_IRQ_INT2);
 
 	*(volatile u8 *) PCIMT_IRQSEL |= mask;
 }
 
-void disable_pcimt_irq(unsigned int irq)
+void disable_pcimt_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = ~(1 << (irq - PCIMT_IRQ_INT2));
 
Index: linux-2.6/arch/mips/sni/pcit.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/pcit.c
+++ linux-2.6/arch/mips/sni/pcit.c
@@ -155,14 +155,14 @@ static struct pci_controller sni_pcit_co
 	.io_map_base    = SNI_PORT_BASE
 };
 
-static void enable_pcit_irq(unsigned int irq)
+static void enable_pcit_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask = 1 << (irq - SNI_PCIT_INT_START + 24);
 
 	*(volatile u32 *)SNI_PCIT_INT_REG |= mask;
 }
 
-void disable_pcit_irq(unsigned int irq)
+void disable_pcit_irq(unsigned int irq, struct irq_desc *desc)
 {
 	u32 mask = 1 << (irq - SNI_PCIT_INT_START + 24);
 
Index: linux-2.6/arch/mips/sni/rm200.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/rm200.c
+++ linux-2.6/arch/mips/sni/rm200.c
@@ -154,7 +154,7 @@ static __iomem u8 *rm200_pic_slave;
 #define cached_master_mask	(rm200_cached_irq_mask)
 #define cached_slave_mask	(rm200_cached_irq_mask >> 8)
 
-static void sni_rm200_disable_8259A_irq(unsigned int irq)
+static void sni_rm200_disable_8259A_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 	unsigned long flags;
@@ -170,7 +170,7 @@ static void sni_rm200_disable_8259A_irq(
 	spin_unlock_irqrestore(&sni_rm200_i8259A_lock, flags);
 }
 
-static void sni_rm200_enable_8259A_irq(unsigned int irq)
+static void sni_rm200_enable_8259A_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 	unsigned long flags;
@@ -186,7 +186,7 @@ static void sni_rm200_enable_8259A_irq(u
 	spin_unlock_irqrestore(&sni_rm200_i8259A_lock, flags);
 }
 
-static inline int sni_rm200_i8259A_irq_real(unsigned int irq)
+static inline int sni_rm200_i8259A_irq_real(unsigned int irq, struct irq_desc *desc)
 {
 	int value;
 	int irqmask = 1 << irq;
@@ -428,21 +428,21 @@ void __init sni_rm200_i8259_irqs(void)
 #define SNI_RM200_INT_START  24
 #define SNI_RM200_INT_END    28
 
-static void enable_rm200_irq(unsigned int irq)
+static void enable_rm200_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq - SNI_RM200_INT_START);
 
 	*(volatile u8 *)SNI_RM200_INT_ENA_REG &= ~mask;
 }
 
-void disable_rm200_irq(unsigned int irq)
+void disable_rm200_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask = 1 << (irq - SNI_RM200_INT_START);
 
 	*(volatile u8 *)SNI_RM200_INT_ENA_REG |= mask;
 }
 
-void end_rm200_irq(unsigned int irq)
+void end_rm200_irq(unsigned int irq, struct irq_desc *desc)
 {
 	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		enable_rm200_irq(irq);
Index: linux-2.6/arch/mips/txx9/generic/irq_tx4939.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/generic/irq_tx4939.c
+++ linux-2.6/arch/mips/txx9/generic/irq_tx4939.c
@@ -49,7 +49,7 @@ static struct {
 	unsigned char mode;
 } tx4939irq[TX4939_NUM_IR] __read_mostly;
 
-static void tx4939_irq_unmask(unsigned int irq)
+static void tx4939_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *lvlp;
@@ -67,7 +67,7 @@ static void tx4939_irq_unmask(unsigned i
 		     lvlp);
 }
 
-static inline void tx4939_irq_mask(unsigned int irq)
+static inline void tx4939_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *lvlp;
Index: linux-2.6/arch/mips/txx9/jmr3927/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/jmr3927/irq.c
+++ linux-2.6/arch/mips/txx9/jmr3927/irq.c
@@ -46,7 +46,7 @@
  * CP0_STATUS is a thread's resource (saved/restored on context switch).
  * So disable_irq/enable_irq MUST handle IOC/IRC registers.
  */
-static void mask_irq_ioc(unsigned int irq)
+static void mask_irq_ioc(unsigned int irq, struct irq_desc *desc)
 {
 	/* 0: mask */
 	unsigned int irq_nr = irq - JMR3927_IRQ_IOC;
@@ -56,7 +56,7 @@ static void mask_irq_ioc(unsigned int ir
 	/* flush write buffer */
 	(void)jmr3927_ioc_reg_in(JMR3927_IOC_REV_ADDR);
 }
-static void unmask_irq_ioc(unsigned int irq)
+static void unmask_irq_ioc(unsigned int irq, struct irq_desc *desc)
 {
 	/* 0: mask */
 	unsigned int irq_nr = irq - JMR3927_IRQ_IOC;
Index: linux-2.6/arch/mips/txx9/rbtx4927/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/rbtx4927/irq.c
+++ linux-2.6/arch/mips/txx9/rbtx4927/irq.c
@@ -116,8 +116,8 @@
 #include <asm/txx9/generic.h>
 #include <asm/txx9/rbtx4927.h>
 
-static void toshiba_rbtx4927_irq_ioc_enable(unsigned int irq);
-static void toshiba_rbtx4927_irq_ioc_disable(unsigned int irq);
+static void toshiba_rbtx4927_irq_ioc_enable(unsigned int irq, struct irq_desc *desc);
+static void toshiba_rbtx4927_irq_ioc_disable(unsigned int irq, struct irq_desc *desc);
 
 #define TOSHIBA_RBTX4927_IOC_NAME "RBTX4927-IOC"
 static struct irq_chip toshiba_rbtx4927_irq_ioc_type = {
@@ -154,7 +154,7 @@ static void __init toshiba_rbtx4927_irq_
 	set_irq_chained_handler(RBTX4927_IRQ_IOCINT, handle_simple_irq);
 }
 
-static void toshiba_rbtx4927_irq_ioc_enable(unsigned int irq)
+static void toshiba_rbtx4927_irq_ioc_enable(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned char v;
 
@@ -163,7 +163,7 @@ static void toshiba_rbtx4927_irq_ioc_ena
 	writeb(v, rbtx4927_imask_addr);
 }
 
-static void toshiba_rbtx4927_irq_ioc_disable(unsigned int irq)
+static void toshiba_rbtx4927_irq_ioc_disable(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned char v;
 
Index: linux-2.6/arch/mips/txx9/rbtx4938/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/rbtx4938/irq.c
+++ linux-2.6/arch/mips/txx9/rbtx4938/irq.c
@@ -68,8 +68,8 @@
 #include <asm/txx9/generic.h>
 #include <asm/txx9/rbtx4938.h>
 
-static void toshiba_rbtx4938_irq_ioc_enable(unsigned int irq);
-static void toshiba_rbtx4938_irq_ioc_disable(unsigned int irq);
+static void toshiba_rbtx4938_irq_ioc_enable(unsigned int irq, struct irq_desc *desc);
+static void toshiba_rbtx4938_irq_ioc_disable(unsigned int irq, struct irq_desc *desc);
 
 #define TOSHIBA_RBTX4938_IOC_NAME "RBTX4938-IOC"
 static struct irq_chip toshiba_rbtx4938_irq_ioc_type = {
@@ -105,7 +105,7 @@ toshiba_rbtx4938_irq_ioc_init(void)
 }
 
 static void
-toshiba_rbtx4938_irq_ioc_enable(unsigned int irq)
+toshiba_rbtx4938_irq_ioc_enable(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned char v;
 
@@ -116,7 +116,7 @@ toshiba_rbtx4938_irq_ioc_enable(unsigned
 }
 
 static void
-toshiba_rbtx4938_irq_ioc_disable(unsigned int irq)
+toshiba_rbtx4938_irq_ioc_disable(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned char v;
 
Index: linux-2.6/arch/mips/txx9/rbtx4939/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/rbtx4939/irq.c
+++ linux-2.6/arch/mips/txx9/rbtx4939/irq.c
@@ -18,14 +18,14 @@
  * RBTX4939 IOC controller definition
  */
 
-static void rbtx4939_ioc_irq_unmask(unsigned int irq)
+static void rbtx4939_ioc_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	int ioc_nr = irq - RBTX4939_IRQ_IOC;
 
 	writeb(readb(rbtx4939_ien_addr) | (1 << ioc_nr), rbtx4939_ien_addr);
 }
 
-static void rbtx4939_ioc_irq_mask(unsigned int irq)
+static void rbtx4939_ioc_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	int ioc_nr = irq - RBTX4939_IRQ_IOC;
 
Index: linux-2.6/arch/mips/vr41xx/common/icu.c
===================================================================
--- linux-2.6.orig/arch/mips/vr41xx/common/icu.c
+++ linux-2.6/arch/mips/vr41xx/common/icu.c
@@ -442,12 +442,12 @@ void vr41xx_disable_bcuint(void)
 
 EXPORT_SYMBOL(vr41xx_disable_bcuint);
 
-static void disable_sysint1_irq(unsigned int irq)
+static void disable_sysint1_irq(unsigned int irq, struct irq_desc *desc)
 {
 	icu1_clear(MSYSINT1REG, 1 << SYSINT1_IRQ_TO_PIN(irq));
 }
 
-static void enable_sysint1_irq(unsigned int irq)
+static void enable_sysint1_irq(unsigned int irq, struct irq_desc *desc)
 {
 	icu1_set(MSYSINT1REG, 1 << SYSINT1_IRQ_TO_PIN(irq));
 }
@@ -460,12 +460,12 @@ static struct irq_chip sysint1_irq_type
 	.unmask		= enable_sysint1_irq,
 };
 
-static void disable_sysint2_irq(unsigned int irq)
+static void disable_sysint2_irq(unsigned int irq, struct irq_desc *desc)
 {
 	icu2_clear(MSYSINT2REG, 1 << SYSINT2_IRQ_TO_PIN(irq));
 }
 
-static void enable_sysint2_irq(unsigned int irq)
+static void enable_sysint2_irq(unsigned int irq, struct irq_desc *desc)
 {
 	icu2_set(MSYSINT2REG, 1 << SYSINT2_IRQ_TO_PIN(irq));
 }
Index: linux-2.6/arch/mips/vr41xx/common/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/vr41xx/common/irq.c
+++ linux-2.6/arch/mips/vr41xx/common/irq.c
@@ -74,10 +74,10 @@ static void irq_dispatch(unsigned int ir
 		int ret;
 		desc = irq_desc + source_irq;
 		if (desc->chip->mask_ack)
-			desc->chip->mask_ack(source_irq);
+			desc->chip->mask_ack(source_irq, desc);
 		else {
-			desc->chip->mask(source_irq);
-			desc->chip->ack(source_irq);
+			desc->chip->mask(source_irq, desc);
+			desc->chip->ack(source_irq, desc);
 		}
 		ret = cascade->get_irq(irq);
 		irq = ret;
@@ -86,7 +86,7 @@ static void irq_dispatch(unsigned int ir
 		else
 			irq_dispatch(irq);
 		if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-			desc->chip->unmask(source_irq);
+			desc->chip->unmask(source_irq, desc);
 	} else
 		do_IRQ(irq);
 }
Index: linux-2.6/arch/mn10300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/irq.c
+++ linux-2.6/arch/mn10300/kernel/irq.c
@@ -22,7 +22,7 @@ atomic_t irq_err_count;
 /*
  * MN10300 interrupt controller operations
  */
-static void mn10300_cpupic_ack(unsigned int irq)
+static void mn10300_cpupic_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u16 tmp;
 	*(volatile u8 *) &GxICR(irq) = GxICR_DETECT;
@@ -35,8 +35,12 @@ static void mn10300_cpupic_mask(unsigned
 	GxICR(irq) = (tmp & GxICR_LEVEL);
 	tmp = GxICR(irq);
 }
+static void mn10300_cpupic_mask_desc(unsigned int irq, struct irq_desc *desc)
+{
+	mn10300_cpupic_mask(irq);
+}
 
-static void mn10300_cpupic_mask_ack(unsigned int irq)
+static void mn10300_cpupic_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u16 tmp = GxICR(irq);
 	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
@@ -49,6 +53,10 @@ static void mn10300_cpupic_unmask(unsign
 	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
 	tmp = GxICR(irq);
 }
+static void mn10300_cpupic_unmask_desc(unsigned int irq, struct irq_desc *desc)
+{
+	mn10300_cpupic_unmask(irq);
+}
 
 static void mn10300_cpupic_unmask_clear(unsigned int irq)
 {
@@ -60,6 +68,10 @@ static void mn10300_cpupic_unmask_clear(
 	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
 	tmp = GxICR(irq);
 }
+static void mn10300_cpupic_unmask_clear_desc(unsigned int irq, struct irq_desc *desc)
+{
+	mn10300_cpupic_unmask_clear(irq);
+}
 
 /*
  * MN10300 PIC level-triggered IRQ handling.
@@ -76,9 +88,9 @@ static struct irq_chip mn10300_cpu_pic_l
 	.disable	= mn10300_cpupic_mask,
 	.enable		= mn10300_cpupic_unmask_clear,
 	.ack		= NULL,
-	.mask		= mn10300_cpupic_mask,
-	.mask_ack	= mn10300_cpupic_mask,
-	.unmask		= mn10300_cpupic_unmask_clear,
+	.mask		= mn10300_cpupic_mask_desc,
+	.mask_ack	= mn10300_cpupic_mask_desc,
+	.unmask		= mn10300_cpupic_unmask_clear_desc,
 };
 
 /*
@@ -91,9 +103,9 @@ static struct irq_chip mn10300_cpu_pic_e
 	.disable	= mn10300_cpupic_mask,
 	.enable		= mn10300_cpupic_unmask,
 	.ack		= mn10300_cpupic_ack,
-	.mask		= mn10300_cpupic_mask,
+	.mask		= mn10300_cpupic_mask_desc,
 	.mask_ack	= mn10300_cpupic_mask_ack,
-	.unmask		= mn10300_cpupic_unmask,
+	.unmask		= mn10300_cpupic_unmask_desc,
 };
 
 /*
Index: linux-2.6/arch/mn10300/kernel/mn10300-serial.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/mn10300-serial.c
+++ linux-2.6/arch/mn10300/kernel/mn10300-serial.c
@@ -325,14 +325,14 @@ struct mn10300_serial_port *mn10300_seri
  * note that we can't just leave the line enabled as the baud rate timer *also*
  * generates interrupts
  */
-static void mn10300_serial_mask_ack(unsigned int irq)
+static void mn10300_serial_mask_ack(unsigned int irq, struct irq_desc *desc)
 {
 	u16 tmp;
 	GxICR(irq) = GxICR_LEVEL_6;
 	tmp = GxICR(irq); /* flush write buffer */
 }
 
-static void mn10300_serial_nop(unsigned int irq)
+static void mn10300_serial_nop(unsigned int irq, struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/parisc/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/irq.h
+++ linux-2.6/arch/parisc/include/asm/irq.h
@@ -37,9 +37,9 @@ struct irq_chip;
  * Some useful "we don't have to do anything here" handlers.  Should
  * probably be provided by the generic code.
  */
-void no_ack_irq(unsigned int irq);
+void no_ack_irq(unsigned int irq, struct irq_desc *desc);
 void no_end_irq(unsigned int irq);
-void cpu_ack_irq(unsigned int irq);
+void cpu_ack_irq(unsigned int irq, struct irq_desc *desc);
 void cpu_end_irq(unsigned int irq);
 
 extern int txn_alloc_irq(unsigned int nbits);
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -81,10 +81,10 @@ static unsigned int cpu_startup_irq(unsi
 	return 0;
 }
 
-void no_ack_irq(unsigned int irq) { }
+void no_ack_irq(unsigned int irq, struct irq_desc *desc) { }
 void no_end_irq(unsigned int irq) { }
 
-void cpu_ack_irq(unsigned int irq)
+void cpu_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long mask = EIEM_MASK(irq);
 	int cpu = smp_processor_id();
Index: linux-2.6/arch/powerpc/include/asm/mpic.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/mpic.h
+++ linux-2.6/arch/powerpc/include/asm/mpic.h
@@ -470,11 +470,11 @@ extern void mpic_send_ipi(unsigned int i
 void smp_mpic_message_pass(int target, int msg);
 
 /* Unmask a specific virq */
-extern void mpic_unmask_irq(unsigned int irq);
+extern void mpic_unmask_irq(unsigned int irq, struct irq_desc *desc);
 /* Mask a specific virq */
-extern void mpic_mask_irq(unsigned int irq);
+extern void mpic_mask_irq(unsigned int irq, struct irq_desc *desc);
 /* EOI a specific virq */
-extern void mpic_end_irq(unsigned int irq);
+extern void mpic_end_irq(unsigned int irq, struct irq_desc *desc);
 
 /* Fetch interrupt from a given mpic */
 extern unsigned int mpic_get_one_irq(struct mpic *mpic);
Index: linux-2.6/arch/powerpc/include/asm/qe_ic.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/qe_ic.h
+++ linux-2.6/arch/powerpc/include/asm/qe_ic.h
@@ -107,7 +107,7 @@ static inline void qe_ic_cascade_low_mpi
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static inline void qe_ic_cascade_high_mpic(unsigned int irq,
@@ -119,7 +119,7 @@ static inline void qe_ic_cascade_high_mp
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static inline void qe_ic_cascade_muxed_mpic(unsigned int irq,
@@ -135,7 +135,7 @@ static inline void qe_ic_cascade_muxed_m
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 #endif /* _ASM_POWERPC_QE_IC_H */
Index: linux-2.6/arch/powerpc/kernel/crash.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/crash.c
+++ linux-2.6/arch/powerpc/kernel/crash.c
@@ -376,7 +376,7 @@ void default_machine_crash_shutdown(stru
 		struct irq_desc *desc = irq_to_desc(i);
 
 		if (desc->status & IRQ_INPROGRESS)
-			desc->chip->eoi(i);
+			desc->chip->eoi(i, desc);
 
 		if (!(desc->status & IRQ_DISABLED))
 			desc->chip->disable(i);
Index: linux-2.6/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ linux-2.6/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -59,7 +59,7 @@ irq_to_pic_bit(unsigned int irq)
 }
 
 static void
-cpld_mask_irq(unsigned int irq)
+cpld_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpld_irq = (unsigned int)irq_map[irq].hwirq;
 	void __iomem *pic_mask = irq_to_pic_mask(cpld_irq);
@@ -69,7 +69,7 @@ cpld_mask_irq(unsigned int irq)
 }
 
 static void
-cpld_unmask_irq(unsigned int irq)
+cpld_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpld_irq = (unsigned int)irq_map[irq].hwirq;
 	void __iomem *pic_mask = irq_to_pic_mask(cpld_irq);
Index: linux-2.6/arch/powerpc/platforms/52xx/media5200.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/52xx/media5200.c
+++ linux-2.6/arch/powerpc/platforms/52xx/media5200.c
@@ -49,7 +49,7 @@ struct media5200_irq {
 };
 struct media5200_irq media5200_irq;
 
-static void media5200_irq_unmask(unsigned int virq)
+static void media5200_irq_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	u32 val;
@@ -61,7 +61,7 @@ static void media5200_irq_unmask(unsigne
 	spin_unlock_irqrestore(&media5200_irq.lock, flags);
 }
 
-static void media5200_irq_mask(unsigned int virq)
+static void media5200_irq_mask(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	u32 val;
@@ -87,7 +87,7 @@ void media5200_irq_cascade(unsigned int
 
 	/* Mask off the cascaded IRQ */
 	raw_spin_lock(&desc->lock);
-	desc->chip->mask(virq);
+	desc->chip->mask(virq, desc);
 	raw_spin_unlock(&desc->lock);
 
 	/* Ask the FPGA for IRQ status.  If 'val' is 0, then no irqs
@@ -105,9 +105,9 @@ void media5200_irq_cascade(unsigned int
 
 	/* Processing done; can reenable the cascade now */
 	raw_spin_lock(&desc->lock);
-	desc->chip->ack(virq);
+	desc->chip->ack(virq, desc);
 	if (!(desc->status & IRQ_DISABLED))
-		desc->chip->unmask(virq);
+		desc->chip->unmask(virq, desc);
 	raw_spin_unlock(&desc->lock);
 }
 
Index: linux-2.6/arch/powerpc/platforms/52xx/mpc52xx_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ linux-2.6/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -235,7 +235,7 @@ static int mpc52xx_null_set_type(unsigne
 	return 0; /* Do nothing so that the sense mask will get updated */
 }
 
-static void mpc52xx_main_mask(unsigned int virq)
+static void mpc52xx_main_mask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq;
 	int l2irq;
@@ -246,7 +246,7 @@ static void mpc52xx_main_mask(unsigned i
 	io_be_setbit(&intr->main_mask, 16 - l2irq);
 }
 
-static void mpc52xx_main_unmask(unsigned int virq)
+static void mpc52xx_main_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq;
 	int l2irq;
@@ -301,7 +301,7 @@ static struct irq_chip mpc52xx_periph_ir
 /*
  * SDMA interrupt irq_chip
  */
-static void mpc52xx_sdma_mask(unsigned int virq)
+static void mpc52xx_sdma_mask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq;
 	int l2irq;
@@ -312,7 +312,7 @@ static void mpc52xx_sdma_mask(unsigned i
 	io_be_setbit(&sdma->IntMask, l2irq);
 }
 
-static void mpc52xx_sdma_unmask(unsigned int virq)
+static void mpc52xx_sdma_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq;
 	int l2irq;
@@ -323,7 +323,7 @@ static void mpc52xx_sdma_unmask(unsigned
 	io_be_clrbit(&sdma->IntMask, l2irq);
 }
 
-static void mpc52xx_sdma_ack(unsigned int virq)
+static void mpc52xx_sdma_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int irq;
 	int l2irq;
Index: linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -38,7 +38,7 @@ struct pq2ads_pci_pic {
 
 #define NUM_IRQS 32
 
-static void pq2ads_pci_mask_irq(unsigned int virq)
+static void pq2ads_pci_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct pq2ads_pci_pic *priv = get_irq_chip_data(virq);
 	int irq = NUM_IRQS - virq_to_hw(virq) - 1;
@@ -54,7 +54,7 @@ static void pq2ads_pci_mask_irq(unsigned
 	}
 }
 
-static void pq2ads_pci_unmask_irq(unsigned int virq)
+static void pq2ads_pci_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct pq2ads_pci_pic *priv = get_irq_chip_data(virq);
 	int irq = NUM_IRQS - virq_to_hw(virq) - 1;
Index: linux-2.6/arch/powerpc/platforms/85xx/ksi8560.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/ksi8560.c
+++ linux-2.6/arch/powerpc/platforms/85xx/ksi8560.c
@@ -61,7 +61,7 @@ static void cpm2_cascade(unsigned int ir
 	while ((cascade_irq = cpm2_get_irq()) >= 0)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static void __init ksi8560_pic_init(void)
Index: linux-2.6/arch/powerpc/platforms/85xx/mpc85xx_ads.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ linux-2.6/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -55,7 +55,7 @@ static void cpm2_cascade(unsigned int ir
 	while ((cascade_irq = cpm2_get_irq()) >= 0)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 #endif /* CONFIG_CPM2 */
Index: linux-2.6/arch/powerpc/platforms/85xx/mpc85xx_ds.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ linux-2.6/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -52,7 +52,7 @@ static void mpc85xx_8259_cascade(unsigne
 	if (cascade_irq != NO_IRQ) {
 		generic_handle_irq(cascade_irq);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 #endif	/* CONFIG_PPC_I8259 */
 
Index: linux-2.6/arch/powerpc/platforms/85xx/sbc8560.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/sbc8560.c
+++ linux-2.6/arch/powerpc/platforms/85xx/sbc8560.c
@@ -46,7 +46,7 @@ static void cpm2_cascade(unsigned int ir
 	while ((cascade_irq = cpm2_get_irq()) >= 0)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 #endif /* CONFIG_CPM2 */
Index: linux-2.6/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ linux-2.6/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -103,11 +103,11 @@ void socrates_fpga_pic_cascade(unsigned
 
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 
 }
 
-static void socrates_fpga_pic_ack(unsigned int virq)
+static void socrates_fpga_pic_ack(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int hwirq, irq_line;
@@ -124,7 +124,7 @@ static void socrates_fpga_pic_ack(unsign
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_mask(unsigned int virq)
+static void socrates_fpga_pic_mask(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int hwirq;
@@ -142,7 +142,7 @@ static void socrates_fpga_pic_mask(unsig
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_mask_ack(unsigned int virq)
+static void socrates_fpga_pic_mask_ack(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int hwirq;
@@ -161,7 +161,7 @@ static void socrates_fpga_pic_mask_ack(u
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_unmask(unsigned int virq)
+static void socrates_fpga_pic_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int hwirq;
@@ -179,7 +179,7 @@ static void socrates_fpga_pic_unmask(uns
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_eoi(unsigned int virq)
+static void socrates_fpga_pic_eoi(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int hwirq;
Index: linux-2.6/arch/powerpc/platforms/85xx/stx_gp3.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/stx_gp3.c
+++ linux-2.6/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -51,7 +51,7 @@ static void cpm2_cascade(unsigned int ir
 	while ((cascade_irq = cpm2_get_irq()) >= 0)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 #endif /* CONFIG_CPM2 */
 
Index: linux-2.6/arch/powerpc/platforms/85xx/tqm85xx.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/tqm85xx.c
+++ linux-2.6/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -49,7 +49,7 @@ static void cpm2_cascade(unsigned int ir
 	while ((cascade_irq = cpm2_get_irq()) >= 0)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 #endif /* CONFIG_CPM2 */
 
Index: linux-2.6/arch/powerpc/platforms/86xx/gef_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/86xx/gef_pic.c
+++ linux-2.6/arch/powerpc/platforms/86xx/gef_pic.c
@@ -106,11 +106,11 @@ void gef_pic_cascade(unsigned int irq, s
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 
 }
 
-static void gef_pic_mask(unsigned int virq)
+static void gef_pic_mask(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int hwirq;
@@ -125,7 +125,7 @@ static void gef_pic_mask(unsigned int vi
 	spin_unlock_irqrestore(&gef_pic_lock, flags);
 }
 
-static void gef_pic_mask_ack(unsigned int virq)
+static void gef_pic_mask_ack(unsigned int virq, struct irq_desc *desc)
 {
 	/* Don't think we actually have to do anything to ack an interrupt,
 	 * we just need to clear down the devices interrupt and it will go away
@@ -133,7 +133,7 @@ static void gef_pic_mask_ack(unsigned in
 	gef_pic_mask(virq);
 }
 
-static void gef_pic_unmask(unsigned int virq)
+static void gef_pic_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int hwirq;
Index: linux-2.6/arch/powerpc/platforms/86xx/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/86xx/pic.c
+++ linux-2.6/arch/powerpc/platforms/86xx/pic.c
@@ -22,7 +22,7 @@ static void mpc86xx_8259_cascade(unsigne
 	unsigned int cascade_irq = i8259_irq();
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 #endif	/* CONFIG_PPC_I8259 */
 
Index: linux-2.6/arch/powerpc/platforms/8xx/m8xx_setup.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ linux-2.6/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -225,9 +225,9 @@ static void cpm_cascade(unsigned int irq
 		struct irq_desc *cdesc = irq_to_desc(cascade_irq);
 
 		generic_handle_irq(cascade_irq);
-		cdesc->chip->eoi(cascade_irq);
+		cdesc->chip->eoi(cascade_irq, cdesc);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 /* Initialize the internal interrupt controllers.  The number of
Index: linux-2.6/arch/powerpc/platforms/cell/axon_msi.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/axon_msi.c
+++ linux-2.6/arch/powerpc/platforms/cell/axon_msi.c
@@ -144,7 +144,7 @@ static void axon_msi_cascade(unsigned in
 		msic->read_offset &= MSIC_FIFO_SIZE_MASK;
 	}
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static struct axon_msic *find_msi_translator(struct pci_dev *dev)
@@ -308,10 +308,15 @@ static void axon_msi_teardown_msi_irqs(s
 	}
 }
 
+static void axon_unmask_msi_irq(unsigned int irq)
+{
+	unmask_msi_irq(irq, irq_to_desc(irq));
+}
+
 static struct irq_chip msic_irq_chip = {
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
-	.shutdown	= unmask_msi_irq,
+	.shutdown	= axon_unmask_msi_irq,
 	.name		= "AXON-MSI",
 };
 
Index: linux-2.6/arch/powerpc/platforms/cell/beat_interrupt.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/beat_interrupt.c
+++ linux-2.6/arch/powerpc/platforms/cell/beat_interrupt.c
@@ -71,7 +71,7 @@ static void beatic_mask_irq(unsigned int
 	spin_unlock_irqrestore(&beatic_irq_mask_lock, flags);
 }
 
-static void beatic_unmask_irq(unsigned int irq_plug)
+static void beatic_unmask_irq(unsigned int irq_plug, struct irq_desc *desc)
 {
 	unsigned long flags;
 
@@ -91,7 +91,7 @@ static void beatic_ack_irq(unsigned int
 	spin_unlock_irqrestore(&beatic_irq_mask_lock, flags);
 }
 
-static void beatic_end_irq(unsigned int irq_plug)
+static void beatic_end_irq(unsigned int irq_plug, struct irq_desc *desc)
 {
 	s64 err;
 	unsigned long flags;
Index: linux-2.6/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/interrupt.c
+++ linux-2.6/arch/powerpc/platforms/cell/interrupt.c
@@ -72,15 +72,15 @@ static irq_hw_number_t iic_pending_to_hw
 		return (node << IIC_IRQ_NODE_SHIFT) | (class << 4) | unit;
 }
 
-static void iic_mask(unsigned int irq)
+static void iic_mask(unsigned int irq, struct irq_desc *desc)
 {
 }
 
-static void iic_unmask(unsigned int irq)
+static void iic_unmask(unsigned int irq, struct irq_desc *desc)
 {
 }
 
-static void iic_eoi(unsigned int irq)
+static void iic_eoi(unsigned int irq, struct irq_desc *desc)
 {
 	struct iic *iic = &__get_cpu_var(cpu_iic);
 	out_be64(&iic->regs->prio, iic->eoi_stack[--iic->eoi_ptr]);
@@ -95,7 +95,7 @@ static struct irq_chip iic_chip = {
 };
 
 
-static void iic_ioexc_eoi(unsigned int irq)
+static void iic_ioexc_eoi(unsigned int irq, struct irq_desc *desc)
 {
 }
 
@@ -128,7 +128,7 @@ static void iic_ioexc_cascade(unsigned i
 		if (ack)
 			out_be64(&node_iic->iic_is, ack);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 
@@ -275,7 +275,7 @@ static void handle_iic_irq(unsigned int
 
 	desc->status &= ~IRQ_INPROGRESS;
 out_eoi:
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 	raw_spin_unlock(&desc->lock);
 }
 
Index: linux-2.6/arch/powerpc/platforms/cell/setup.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/setup.c
+++ linux-2.6/arch/powerpc/platforms/cell/setup.c
@@ -182,7 +182,7 @@ static void cell_mpic_cascade(unsigned i
 	virq = mpic_get_one_irq(mpic);
 	if (virq != NO_IRQ)
 		generic_handle_irq(virq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static void __init mpic_init_IRQ(void)
Index: linux-2.6/arch/powerpc/platforms/cell/spider-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spider-pic.c
+++ linux-2.6/arch/powerpc/platforms/cell/spider-pic.c
@@ -79,7 +79,7 @@ static void __iomem *spider_get_irq_conf
 	return pic->regs + TIR_CFGA + 8 * src;
 }
 
-static void spider_unmask_irq(unsigned int virq)
+static void spider_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct spider_pic *pic = spider_virq_to_pic(virq);
 	void __iomem *cfg = spider_get_irq_config(pic, irq_map[virq].hwirq);
@@ -87,7 +87,7 @@ static void spider_unmask_irq(unsigned i
 	out_be32(cfg, in_be32(cfg) | 0x30000000u);
 }
 
-static void spider_mask_irq(unsigned int virq)
+static void spider_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct spider_pic *pic = spider_virq_to_pic(virq);
 	void __iomem *cfg = spider_get_irq_config(pic, irq_map[virq].hwirq);
@@ -95,7 +95,7 @@ static void spider_mask_irq(unsigned int
 	out_be32(cfg, in_be32(cfg) & ~0x30000000u);
 }
 
-static void spider_ack_irq(unsigned int virq)
+static void spider_ack_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct spider_pic *pic = spider_virq_to_pic(virq);
 	unsigned int src = irq_map[virq].hwirq;
@@ -217,7 +217,7 @@ static void spider_irq_cascade(unsigned
 		virq = irq_linear_revmap(pic->host, cs);
 	if (virq != NO_IRQ)
 		generic_handle_irq(virq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 /* For hooking up the cascace we have a problem. Our device-tree is
Index: linux-2.6/arch/powerpc/platforms/chrp/setup.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/chrp/setup.c
+++ linux-2.6/arch/powerpc/platforms/chrp/setup.c
@@ -369,7 +369,7 @@ static void chrp_8259_cascade(unsigned i
 	unsigned int cascade_irq = i8259_irq();
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 /*
Index: linux-2.6/arch/powerpc/platforms/embedded6xx/flipper-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ linux-2.6/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -46,7 +46,7 @@
  *
  */
 
-static void flipper_pic_mask_and_ack(unsigned int virq)
+static void flipper_pic_mask_and_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
@@ -57,7 +57,7 @@ static void flipper_pic_mask_and_ack(uns
 	out_be32(io_base + FLIPPER_ICR, mask);
 }
 
-static void flipper_pic_ack(unsigned int virq)
+static void flipper_pic_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
@@ -66,7 +66,7 @@ static void flipper_pic_ack(unsigned int
 	out_be32(io_base + FLIPPER_ICR, 1 << irq);
 }
 
-static void flipper_pic_mask(unsigned int virq)
+static void flipper_pic_mask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
@@ -74,7 +74,7 @@ static void flipper_pic_mask(unsigned in
 	clrbits32(io_base + FLIPPER_IMR, 1 << irq);
 }
 
-static void flipper_pic_unmask(unsigned int virq)
+static void flipper_pic_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
Index: linux-2.6/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ linux-2.6/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -41,7 +41,7 @@
  *
  */
 
-static void hlwd_pic_mask_and_ack(unsigned int virq)
+static void hlwd_pic_mask_and_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
@@ -51,7 +51,7 @@ static void hlwd_pic_mask_and_ack(unsign
 	out_be32(io_base + HW_BROADWAY_ICR, mask);
 }
 
-static void hlwd_pic_ack(unsigned int virq)
+static void hlwd_pic_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
@@ -59,7 +59,7 @@ static void hlwd_pic_ack(unsigned int vi
 	out_be32(io_base + HW_BROADWAY_ICR, 1 << irq);
 }
 
-static void hlwd_pic_mask(unsigned int virq)
+static void hlwd_pic_mask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
@@ -67,7 +67,7 @@ static void hlwd_pic_mask(unsigned int v
 	clrbits32(io_base + HW_BROADWAY_IMR, 1 << irq);
 }
 
-static void hlwd_pic_unmask(unsigned int virq)
+static void hlwd_pic_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
@@ -133,7 +133,7 @@ static void hlwd_pic_irq_cascade(unsigne
 	unsigned int virq;
 
 	raw_spin_lock(&desc->lock);
-	desc->chip->mask(cascade_virq); /* IRQ_LEVEL */
+	desc->chip->mask(cascade_virq, desc); /* IRQ_LEVEL */
 	raw_spin_unlock(&desc->lock);
 
 	virq = __hlwd_pic_get_irq(irq_host);
@@ -143,9 +143,9 @@ static void hlwd_pic_irq_cascade(unsigne
 		pr_err("spurious interrupt!\n");
 
 	raw_spin_lock(&desc->lock);
-	desc->chip->ack(cascade_virq); /* IRQ_LEVEL */
+	desc->chip->ack(cascade_virq, desc); /* IRQ_LEVEL */
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(cascade_virq);
+		desc->chip->unmask(cascade_virq, desc);
 	raw_spin_unlock(&desc->lock);
 }
 
Index: linux-2.6/arch/powerpc/platforms/iseries/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/iseries/irq.c
+++ linux-2.6/arch/powerpc/platforms/iseries/irq.c
@@ -225,7 +225,7 @@ void __init iSeries_activate_IRQs()
 }
 
 /*  this is not called anywhere currently */
-static void iseries_shutdown_IRQ(unsigned int irq)
+static void iseries_shutdown_IRQ(unsigned int irq, struct irq_desc *desc)
 {
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
@@ -248,7 +248,7 @@ static void iseries_shutdown_IRQ(unsigne
  * This will be called by device drivers (via disable_IRQ)
  * to disable INTA in the bridge interrupt status register.
  */
-static void iseries_disable_IRQ(unsigned int irq)
+static void iseries_disable_IRQ(unsigned int irq, struct irq_desc *desc)
 {
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
@@ -264,7 +264,7 @@ static void iseries_disable_IRQ(unsigned
 	HvCallPci_maskInterrupts(bus, sub_bus, dev_id, mask);
 }
 
-static void iseries_end_IRQ(unsigned int irq)
+static void iseries_end_IRQ(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int rirq = (unsigned int)irq_map[irq].hwirq;
 
Index: linux-2.6/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6/arch/powerpc/platforms/powermac/pic.c
@@ -78,7 +78,7 @@ static void __pmac_retrigger(unsigned in
 	}
 }
 
-static void pmac_mask_and_ack_irq(unsigned int virq)
+static void pmac_mask_and_ack_irq(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned int src = irq_map[virq].hwirq;
         unsigned long bit = 1UL << (src & 0x1f);
@@ -100,7 +100,7 @@ static void pmac_mask_and_ack_irq(unsign
 	spin_unlock_irqrestore(&pmac_pic_lock, flags);
 }
 
-static void pmac_ack_irq(unsigned int virq)
+static void pmac_ack_irq(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned int src = irq_map[virq].hwirq;
         unsigned long bit = 1UL << (src & 0x1f);
@@ -162,7 +162,7 @@ static unsigned int pmac_startup_irq(uns
 	return 0;
 }
 
-static void pmac_mask_irq(unsigned int virq)
+static void pmac_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int src = irq_map[virq].hwirq;
@@ -173,7 +173,7 @@ static void pmac_mask_irq(unsigned int v
   	spin_unlock_irqrestore(&pmac_pic_lock, flags);
 }
 
-static void pmac_unmask_irq(unsigned int virq)
+static void pmac_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned int src = irq_map[virq].hwirq;
@@ -437,7 +437,7 @@ static void pmac_u3_cascade(unsigned int
 	unsigned int cascade_irq = mpic_get_one_irq(mpic);
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static void __init pmac_pic_setup_mpic_nmi(struct mpic *mpic)
Index: linux-2.6/arch/powerpc/platforms/ps3/interrupt.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/ps3/interrupt.c
+++ linux-2.6/arch/powerpc/platforms/ps3/interrupt.c
@@ -99,7 +99,7 @@ static DEFINE_PER_CPU(struct ps3_private
  * Sets ps3_bmp.mask and calls lv1_did_update_interrupt_mask().
  */
 
-static void ps3_chip_mask(unsigned int virq)
+static void ps3_chip_mask(unsigned int virq, struct irq_desc *desc)
 {
 	struct ps3_private *pd = get_irq_chip_data(virq);
 	unsigned long flags;
@@ -120,7 +120,7 @@ static void ps3_chip_mask(unsigned int v
  * Clears ps3_bmp.mask and calls lv1_did_update_interrupt_mask().
  */
 
-static void ps3_chip_unmask(unsigned int virq)
+static void ps3_chip_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	struct ps3_private *pd = get_irq_chip_data(virq);
 	unsigned long flags;
@@ -141,7 +141,7 @@ static void ps3_chip_unmask(unsigned int
  * Calls lv1_end_of_interrupt_ext().
  */
 
-static void ps3_chip_eoi(unsigned int virq)
+static void ps3_chip_eoi(unsigned int virq, struct irq_desc *desc)
 {
 	const struct ps3_private *pd = get_irq_chip_data(virq);
 	lv1_end_of_interrupt_ext(pd->ppe_id, pd->thread_id, virq);
Index: linux-2.6/arch/powerpc/platforms/pseries/setup.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/setup.c
+++ linux-2.6/arch/powerpc/platforms/pseries/setup.c
@@ -118,7 +118,7 @@ static void pseries_8259_cascade(unsigne
 	unsigned int cascade_irq = i8259_irq();
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static void __init pseries_setup_i8259_cascade(void)
Index: linux-2.6/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6/arch/powerpc/platforms/pseries/xics.c
@@ -194,7 +194,7 @@ static int get_irq_server(unsigned int v
 #define get_irq_server(virq, cpumask, strict_check) (default_server)
 #endif
 
-static void xics_unmask_irq(unsigned int virq)
+static void xics_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned int irq;
 	int call_status;
@@ -266,7 +266,7 @@ static void xics_mask_real_irq(unsigned
 	}
 }
 
-static void xics_mask_irq(unsigned int virq)
+static void xics_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned int irq;
 
@@ -362,7 +362,7 @@ static unsigned char pop_cppr(void)
 	return os_cppr->stack[--os_cppr->index];
 }
 
-static void xics_eoi_direct(unsigned int virq)
+static void xics_eoi_direct(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned int irq = (unsigned int)irq_map[virq].hwirq;
 
@@ -370,7 +370,7 @@ static void xics_eoi_direct(unsigned int
 	direct_xirr_info_set((pop_cppr() << 24) | irq);
 }
 
-static void xics_eoi_lpar(unsigned int virq)
+static void xics_eoi_lpar(unsigned int virq, struct irq_desc *desc)
 {
 	unsigned int irq = (unsigned int)irq_map[virq].hwirq;
 
Index: linux-2.6/arch/powerpc/sysdev/cpm1.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/cpm1.c
+++ linux-2.6/arch/powerpc/sysdev/cpm1.c
@@ -55,21 +55,21 @@ static cpic8xx_t __iomem *cpic_reg;
 
 static struct irq_host *cpm_pic_host;
 
-static void cpm_mask_irq(unsigned int irq)
+static void cpm_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpm_vec = (unsigned int)irq_map[irq].hwirq;
 
 	clrbits32(&cpic_reg->cpic_cimr, (1 << cpm_vec));
 }
 
-static void cpm_unmask_irq(unsigned int irq)
+static void cpm_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpm_vec = (unsigned int)irq_map[irq].hwirq;
 
 	setbits32(&cpic_reg->cpic_cimr, (1 << cpm_vec));
 }
 
-static void cpm_end_irq(unsigned int irq)
+static void cpm_end_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cpm_vec = (unsigned int)irq_map[irq].hwirq;
 
Index: linux-2.6/arch/powerpc/sysdev/cpm2_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/cpm2_pic.c
+++ linux-2.6/arch/powerpc/sysdev/cpm2_pic.c
@@ -78,7 +78,7 @@ static const u_char irq_to_siubit[] = {
 	24, 25, 26, 27, 28, 29, 30, 31,
 };
 
-static void cpm2_mask_irq(unsigned int virq)
+static void cpm2_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
@@ -90,7 +90,7 @@ static void cpm2_mask_irq(unsigned int v
 	out_be32(&cpm2_intctl->ic_simrh + word, ppc_cached_irq_mask[word]);
 }
 
-static void cpm2_unmask_irq(unsigned int virq)
+static void cpm2_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
@@ -102,7 +102,7 @@ static void cpm2_unmask_irq(unsigned int
 	out_be32(&cpm2_intctl->ic_simrh + word, ppc_cached_irq_mask[word]);
 }
 
-static void cpm2_ack(unsigned int virq)
+static void cpm2_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
@@ -113,7 +113,7 @@ static void cpm2_ack(unsigned int virq)
 	out_be32(&cpm2_intctl->ic_sipnrh + word, 1 << bit);
 }
 
-static void cpm2_end_irq(unsigned int virq)
+static void cpm2_end_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct irq_desc *desc;
 	int	bit, word;
Index: linux-2.6/arch/powerpc/sysdev/fsl_msi.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/fsl_msi.c
+++ linux-2.6/arch/powerpc/sysdev/fsl_msi.c
@@ -39,7 +39,7 @@ static inline u32 fsl_msi_read(u32 __iom
  * We do not need this actually. The MSIR register has been read once
  * in the cascade interrupt. So, this MSI interrupt has been acked
 */
-static void fsl_msi_end_irq(unsigned int virq)
+static void fsl_msi_end_irq(unsigned int virq, struct irq_desc *desc)
 {
 }
 
@@ -176,10 +176,10 @@ static void fsl_msi_cascade(unsigned int
 	raw_spin_lock(&desc->lock);
 	if ((msi_data->feature &  FSL_PIC_IP_MASK) == FSL_PIC_IP_IPIC) {
 		if (desc->chip->mask_ack)
-			desc->chip->mask_ack(irq);
+			desc->chip->mask_ack(irq, desc);
 		else {
-			desc->chip->mask(irq);
-			desc->chip->ack(irq);
+			desc->chip->mask(irq, desc);
+			desc->chip->ack(irq, desc);
 		}
 	}
 
@@ -217,11 +217,11 @@ static void fsl_msi_cascade(unsigned int
 
 	switch (msi_data->feature & FSL_PIC_IP_MASK) {
 	case FSL_PIC_IP_MPIC:
-		desc->chip->eoi(irq);
+		desc->chip->eoi(irq, desc);
 		break;
 	case FSL_PIC_IP_IPIC:
 		if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-			desc->chip->unmask(irq);
+			desc->chip->unmask(irq, desc);
 		break;
 	}
 unlock:
Index: linux-2.6/arch/powerpc/sysdev/i8259.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/i8259.c
+++ linux-2.6/arch/powerpc/sysdev/i8259.c
@@ -78,7 +78,7 @@ unsigned int i8259_irq(void)
 	return irq;
 }
 
-static void i8259_mask_and_ack_irq(unsigned int irq_nr)
+static void i8259_mask_and_ack_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned long flags;
 
@@ -104,7 +104,7 @@ static void i8259_set_irq_mask(int irq_n
 	outb(cached_21,0x21);
 }
 
-static void i8259_mask_irq(unsigned int irq_nr)
+static void i8259_mask_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned long flags;
 
@@ -119,7 +119,7 @@ static void i8259_mask_irq(unsigned int
 	spin_unlock_irqrestore(&i8259_lock, flags);
 }
 
-static void i8259_unmask_irq(unsigned int irq_nr)
+static void i8259_unmask_irq(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned long flags;
 
Index: linux-2.6/arch/powerpc/sysdev/ipic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/ipic.c
+++ linux-2.6/arch/powerpc/sysdev/ipic.c
@@ -523,7 +523,7 @@ static inline struct ipic * ipic_from_ir
 
 #define ipic_irq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
 
-static void ipic_unmask_irq(unsigned int virq)
+static void ipic_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
@@ -539,7 +539,7 @@ static void ipic_unmask_irq(unsigned int
 	spin_unlock_irqrestore(&ipic_lock, flags);
 }
 
-static void ipic_mask_irq(unsigned int virq)
+static void ipic_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
@@ -559,7 +559,7 @@ static void ipic_mask_irq(unsigned int v
 	spin_unlock_irqrestore(&ipic_lock, flags);
 }
 
-static void ipic_ack_irq(unsigned int virq)
+static void ipic_ack_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
@@ -578,7 +578,7 @@ static void ipic_ack_irq(unsigned int vi
 	spin_unlock_irqrestore(&ipic_lock, flags);
 }
 
-static void ipic_mask_irq_and_ack(unsigned int virq)
+static void ipic_mask_irq_and_ack(unsigned int virq, struct irq_desc *desc)
 {
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
Index: linux-2.6/arch/powerpc/sysdev/mpc8xx_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpc8xx_pic.c
+++ linux-2.6/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -25,7 +25,7 @@ static sysconf8xx_t __iomem *siu_reg;
 
 int cpm_get_irq(struct pt_regs *regs);
 
-static void mpc8xx_unmask_irq(unsigned int virq)
+static void mpc8xx_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	int	bit, word;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
@@ -37,7 +37,7 @@ static void mpc8xx_unmask_irq(unsigned i
 	out_be32(&siu_reg->sc_simask, ppc_cached_irq_mask[word]);
 }
 
-static void mpc8xx_mask_irq(unsigned int virq)
+static void mpc8xx_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	int	bit, word;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
@@ -49,7 +49,7 @@ static void mpc8xx_mask_irq(unsigned int
 	out_be32(&siu_reg->sc_simask, ppc_cached_irq_mask[word]);
 }
 
-static void mpc8xx_ack(unsigned int virq)
+static void mpc8xx_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int	bit;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
@@ -58,7 +58,7 @@ static void mpc8xx_ack(unsigned int virq
 	out_be32(&siu_reg->sc_sipend, 1 << (31-bit));
 }
 
-static void mpc8xx_end_irq(unsigned int virq)
+static void mpc8xx_end_irq(unsigned int virq, struct irq_desc *desc)
 {
 	int bit, word;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -663,7 +663,7 @@ static inline void mpic_eoi(struct mpic
  */
 
 
-void mpic_unmask_irq(unsigned int irq)
+void mpic_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int loops = 100000;
 	struct mpic *mpic = mpic_from_irq(irq);
@@ -683,7 +683,7 @@ void mpic_unmask_irq(unsigned int irq)
 	} while(mpic_irq_read(src, MPIC_INFO(IRQ_VECTOR_PRI)) & MPIC_VECPRI_MASK);
 }
 
-void mpic_mask_irq(unsigned int irq)
+void mpic_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int loops = 100000;
 	struct mpic *mpic = mpic_from_irq(irq);
@@ -704,7 +704,7 @@ void mpic_mask_irq(unsigned int irq)
 	} while(!(mpic_irq_read(src, MPIC_INFO(IRQ_VECTOR_PRI)) & MPIC_VECPRI_MASK));
 }
 
-void mpic_end_irq(unsigned int irq)
+void mpic_end_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 
@@ -721,7 +721,7 @@ void mpic_end_irq(unsigned int irq)
 
 #ifdef CONFIG_MPIC_U3_HT_IRQS
 
-static void mpic_unmask_ht_irq(unsigned int irq)
+static void mpic_unmask_ht_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -752,7 +752,7 @@ static void mpic_shutdown_ht_irq(unsigne
 	mpic_mask_irq(irq);
 }
 
-static void mpic_end_ht_irq(unsigned int irq)
+static void mpic_end_ht_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -773,7 +773,7 @@ static void mpic_end_ht_irq(unsigned int
 
 #ifdef CONFIG_SMP
 
-static void mpic_unmask_ipi(unsigned int irq)
+static void mpic_unmask_ipi(unsigned int irq, struct irq_desc *desc)
 {
 	struct mpic *mpic = mpic_from_ipi(irq);
 	unsigned int src = mpic_irq_to_hw(irq) - mpic->ipi_vecs[0];
@@ -782,12 +782,12 @@ static void mpic_unmask_ipi(unsigned int
 	mpic_ipi_write(src, mpic_ipi_read(src) & ~MPIC_VECPRI_MASK);
 }
 
-static void mpic_mask_ipi(unsigned int irq)
+static void mpic_mask_ipi(unsigned int irq, struct irq_desc *desc)
 {
 	/* NEVER disable an IPI... that's just plain wrong! */
 }
 
-static void mpic_end_ipi(unsigned int irq)
+static void mpic_end_ipi(unsigned int irq, struct irq_desc *desc)
 {
 	struct mpic *mpic = mpic_from_ipi(irq);
 
Index: linux-2.6/arch/powerpc/sysdev/mpic_pasemi_msi.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ linux-2.6/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -39,14 +39,14 @@
 static struct mpic *msi_mpic;
 
 
-static void mpic_pasemi_msi_mask_irq(unsigned int irq)
+static void mpic_pasemi_msi_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	pr_debug("mpic_pasemi_msi_mask_irq %d\n", irq);
 	mask_msi_irq(irq);
 	mpic_mask_irq(irq);
 }
 
-static void mpic_pasemi_msi_unmask_irq(unsigned int irq)
+static void mpic_pasemi_msi_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	pr_debug("mpic_pasemi_msi_unmask_irq %d\n", irq);
 	mpic_unmask_irq(irq);
Index: linux-2.6/arch/powerpc/sysdev/mpic_u3msi.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic_u3msi.c
+++ linux-2.6/arch/powerpc/sysdev/mpic_u3msi.c
@@ -23,20 +23,25 @@
 /* A bit ugly, can we get this from the pci_dev somehow? */
 static struct mpic *msi_mpic;
 
-static void mpic_u3msi_mask_irq(unsigned int irq)
+static void mpic_u3msi_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
-	mask_msi_irq(irq);
-	mpic_mask_irq(irq);
+	mask_msi_irq(irq, desc);
+	mpic_mask_irq(irq, desc);
 }
 
-static void mpic_u3msi_unmask_irq(unsigned int irq)
+static void mpic_u3msi_shutdown_irq(unsigned int irq)
 {
-	mpic_unmask_irq(irq);
-	unmask_msi_irq(irq);
+	mpic_u3msi_mask_irq(irq, irq_to_desc(irq));
+}
+
+static void mpic_u3msi_unmask_irq(unsigned int irq, struct irq_desc *desc)
+{
+	mpic_unmask_irq(irq, desc);
+	unmask_msi_irq(irq, desc);
 }
 
 static struct irq_chip mpic_u3msi_chip = {
-	.shutdown	= mpic_u3msi_mask_irq,
+	.shutdown	= mpic_u3msi_shutdown_irq,
 	.mask		= mpic_u3msi_mask_irq,
 	.unmask		= mpic_u3msi_unmask_irq,
 	.eoi		= mpic_end_irq,
Index: linux-2.6/arch/powerpc/sysdev/mv64x60_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mv64x60_pic.c
+++ linux-2.6/arch/powerpc/sysdev/mv64x60_pic.c
@@ -76,7 +76,7 @@ static struct irq_host *mv64x60_irq_host
  * mv64x60_chip_low functions
  */
 
-static void mv64x60_mask_low(unsigned int virq)
+static void mv64x60_mask_low(unsigned int virq, struct irq_desc *desc)
 {
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
@@ -89,7 +89,7 @@ static void mv64x60_mask_low(unsigned in
 	(void)in_le32(mv64x60_irq_reg_base + MV64X60_IC_CPU0_INTR_MASK_LO);
 }
 
-static void mv64x60_unmask_low(unsigned int virq)
+static void mv64x60_unmask_low(unsigned int virq, struct irq_desc *desc)
 {
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
@@ -113,7 +113,7 @@ static struct irq_chip mv64x60_chip_low
  * mv64x60_chip_high functions
  */
 
-static void mv64x60_mask_high(unsigned int virq)
+static void mv64x60_mask_high(unsigned int virq, struct irq_desc *desc)
 {
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
@@ -126,7 +126,7 @@ static void mv64x60_mask_high(unsigned i
 	(void)in_le32(mv64x60_irq_reg_base + MV64X60_IC_CPU0_INTR_MASK_HI);
 }
 
-static void mv64x60_unmask_high(unsigned int virq)
+static void mv64x60_unmask_high(unsigned int virq, struct irq_desc *desc)
 {
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
@@ -150,7 +150,7 @@ static struct irq_chip mv64x60_chip_high
  * mv64x60_chip_gpp functions
  */
 
-static void mv64x60_mask_gpp(unsigned int virq)
+static void mv64x60_mask_gpp(unsigned int virq, struct irq_desc *desc)
 {
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
@@ -163,7 +163,7 @@ static void mv64x60_mask_gpp(unsigned in
 	(void)in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_INTR_MASK);
 }
 
-static void mv64x60_mask_ack_gpp(unsigned int virq)
+static void mv64x60_mask_ack_gpp(unsigned int virq, struct irq_desc *desc)
 {
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
@@ -178,7 +178,7 @@ static void mv64x60_mask_ack_gpp(unsigne
 	(void)in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_INTR_CAUSE);
 }
 
-static void mv64x60_unmask_gpp(unsigned int virq)
+static void mv64x60_unmask_gpp(unsigned int virq, struct irq_desc *desc)
 {
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
Index: linux-2.6/arch/powerpc/sysdev/qe_lib/qe_ic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ linux-2.6/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -194,7 +194,7 @@ static inline struct qe_ic *qe_ic_from_i
 
 #define virq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
 
-static void qe_ic_unmask_irq(unsigned int virq)
+static void qe_ic_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct qe_ic *qe_ic = qe_ic_from_irq(virq);
 	unsigned int src = virq_to_hw(virq);
@@ -210,7 +210,7 @@ static void qe_ic_unmask_irq(unsigned in
 	spin_unlock_irqrestore(&qe_ic_lock, flags);
 }
 
-static void qe_ic_mask_irq(unsigned int virq)
+static void qe_ic_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct qe_ic *qe_ic = qe_ic_from_irq(virq);
 	unsigned int src = virq_to_hw(virq);
Index: linux-2.6/arch/powerpc/sysdev/tsi108_pci.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/tsi108_pci.c
+++ linux-2.6/arch/powerpc/sysdev/tsi108_pci.c
@@ -344,22 +344,22 @@ static inline unsigned int get_pci_sourc
  * Linux descriptor level callbacks
  */
 
-static void tsi108_pci_irq_enable(u_int irq)
+static void tsi108_pci_irq_enable(u_int irq, struct irq_desc *desc)
 {
 	tsi108_pci_int_unmask(irq);
 }
 
-static void tsi108_pci_irq_disable(u_int irq)
+static void tsi108_pci_irq_disable(u_int irq, struct irq_desc *desc)
 {
 	tsi108_pci_int_mask(irq);
 }
 
-static void tsi108_pci_irq_ack(u_int irq)
+static void tsi108_pci_irq_ack(u_int irq, struct irq_desc *desc)
 {
 	tsi108_pci_int_mask(irq);
 }
 
-static void tsi108_pci_irq_end(u_int irq)
+static void tsi108_pci_irq_end(u_int irq, struct irq_desc *desc)
 {
 	tsi108_pci_int_unmask(irq);
 
@@ -441,5 +441,5 @@ void tsi108_irq_cascade(unsigned int irq
 	unsigned int cascade_irq = get_pci_source();
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
Index: linux-2.6/arch/powerpc/sysdev/uic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/uic.c
+++ linux-2.6/arch/powerpc/sysdev/uic.c
@@ -55,7 +55,7 @@ struct uic {
 	struct irq_host	*irqhost;
 };
 
-static void uic_unmask_irq(unsigned int virq)
+static void uic_unmask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct irq_desc *desc = irq_to_desc(virq);
 	struct uic *uic = get_irq_chip_data(virq);
@@ -74,7 +74,7 @@ static void uic_unmask_irq(unsigned int
 	spin_unlock_irqrestore(&uic->lock, flags);
 }
 
-static void uic_mask_irq(unsigned int virq)
+static void uic_mask_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct uic *uic = get_irq_chip_data(virq);
 	unsigned int src = uic_irq_to_hw(virq);
@@ -88,7 +88,7 @@ static void uic_mask_irq(unsigned int vi
 	spin_unlock_irqrestore(&uic->lock, flags);
 }
 
-static void uic_ack_irq(unsigned int virq)
+static void uic_ack_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct uic *uic = get_irq_chip_data(virq);
 	unsigned int src = uic_irq_to_hw(virq);
@@ -99,7 +99,7 @@ static void uic_ack_irq(unsigned int vir
 	spin_unlock_irqrestore(&uic->lock, flags);
 }
 
-static void uic_mask_ack_irq(unsigned int virq)
+static void uic_mask_ack_irq(unsigned int virq, struct irq_desc *desc)
 {
 	struct irq_desc *desc = irq_to_desc(virq);
 	struct uic *uic = get_irq_chip_data(virq);
@@ -227,9 +227,9 @@ void uic_irq_cascade(unsigned int virq,
 
 	raw_spin_lock(&desc->lock);
 	if (desc->status & IRQ_LEVEL)
-		desc->chip->mask(virq);
+		desc->chip->mask(virq, desc);
 	else
-		desc->chip->mask_ack(virq);
+		desc->chip->mask_ack(virq, desc);
 	raw_spin_unlock(&desc->lock);
 
 	msr = mfdcr(uic->dcrbase + UIC_MSR);
@@ -244,9 +244,9 @@ void uic_irq_cascade(unsigned int virq,
 uic_irq_ret:
 	raw_spin_lock(&desc->lock);
 	if (desc->status & IRQ_LEVEL)
-		desc->chip->ack(virq);
+		desc->chip->ack(virq, desc);
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(virq);
+		desc->chip->unmask(virq, desc);
 	raw_spin_unlock(&desc->lock);
 }
 
Index: linux-2.6/arch/powerpc/sysdev/xilinx_intc.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/xilinx_intc.c
+++ linux-2.6/arch/powerpc/sysdev/xilinx_intc.c
@@ -69,7 +69,7 @@ static unsigned char xilinx_intc_map_sen
  *
  * IRQ Chip common (across level and edge) operations
  */
-static void xilinx_intc_mask(unsigned int virq)
+static void xilinx_intc_mask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void * regs = get_irq_chip_data(virq);
@@ -91,7 +91,7 @@ static int xilinx_intc_set_type(unsigned
 /*
  * IRQ Chip level operations
  */
-static void xilinx_intc_level_unmask(unsigned int virq)
+static void xilinx_intc_level_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void * regs = get_irq_chip_data(virq);
@@ -116,7 +116,7 @@ static struct irq_chip xilinx_intc_level
 /*
  * IRQ Chip edge operations
  */
-static void xilinx_intc_edge_unmask(unsigned int virq)
+static void xilinx_intc_edge_unmask(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void *regs = get_irq_chip_data(virq);
@@ -124,7 +124,7 @@ static void xilinx_intc_edge_unmask(unsi
 	out_be32(regs + XINTC_SIE, 1 << irq);
 }
 
-static void xilinx_intc_edge_ack(unsigned int virq)
+static void xilinx_intc_edge_ack(unsigned int virq, struct irq_desc *desc)
 {
 	int irq = virq_to_hw(virq);
 	void * regs = get_irq_chip_data(virq);
@@ -234,7 +234,7 @@ static void xilinx_i8259_cascade(unsigne
 		generic_handle_irq(cascade_irq);
 
 	/* Let xilinx_intc end the interrupt */
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 static void __init xilinx_i8259_setup_cascade(void)
Index: linux-2.6/arch/score/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/score/kernel/irq.c
+++ linux-2.6/arch/score/kernel/irq.c
@@ -52,7 +52,7 @@ asmlinkage void do_IRQ(int irq)
 	irq_exit();
 }
 
-static void score_mask(unsigned int irq_nr)
+static void score_mask(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int irq_source = 63 - irq_nr;
 
@@ -64,7 +64,7 @@ static void score_mask(unsigned int irq_
 			(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
 }
 
-static void score_unmask(unsigned int irq_nr)
+static void score_unmask(unsigned int irq_nr, struct irq_desc *desc)
 {
 	unsigned int irq_source = 63 - irq_nr;
 
Index: linux-2.6/arch/sh/boards/mach-cayman/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-cayman/irq.c
+++ linux-2.6/arch/sh/boards/mach-cayman/irq.c
@@ -55,7 +55,7 @@ static struct irqaction cayman_action_pc
 	.flags		= IRQF_DISABLED,
 };
 
-static void enable_cayman_irq(unsigned int irq)
+static void enable_cayman_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -72,7 +72,7 @@ static void enable_cayman_irq(unsigned i
 	local_irq_restore(flags);
 }
 
-void disable_cayman_irq(unsigned int irq)
+void disable_cayman_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 	unsigned long mask;
@@ -89,7 +89,7 @@ void disable_cayman_irq(unsigned int irq
 	local_irq_restore(flags);
 }
 
-static void ack_cayman_irq(unsigned int irq)
+static void ack_cayman_irq(unsigned int irq, struct irq_desc *desc)
 {
 	disable_cayman_irq(irq);
 }
Index: linux-2.6/arch/sh/boards/mach-dreamcast/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-dreamcast/irq.c
+++ linux-2.6/arch/sh/boards/mach-dreamcast/irq.c
@@ -60,7 +60,7 @@
  */
 
 /* Disable the hardware event by masking its bit in its EMR */
-static inline void disable_systemasic_irq(unsigned int irq)
+static inline void disable_systemasic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__u32 emr = EMR_BASE + (LEVEL(irq) << 4) + (LEVEL(irq) << 2);
 	__u32 mask;
@@ -71,7 +71,7 @@ static inline void disable_systemasic_ir
 }
 
 /* Enable the hardware event by setting its bit in its EMR */
-static inline void enable_systemasic_irq(unsigned int irq)
+static inline void enable_systemasic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__u32 emr = EMR_BASE + (LEVEL(irq) << 4) + (LEVEL(irq) << 2);
 	__u32 mask;
@@ -82,7 +82,7 @@ static inline void enable_systemasic_irq
 }
 
 /* Acknowledge a hardware event by writing its bit back to its ESR */
-static void mask_ack_systemasic_irq(unsigned int irq)
+static void mask_ack_systemasic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	__u32 esr = ESR_BASE + (LEVEL(irq) << 2);
 	disable_systemasic_irq(irq);
Index: linux-2.6/arch/sh/boards/mach-landisk/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-landisk/irq.c
+++ linux-2.6/arch/sh/boards/mach-landisk/irq.c
@@ -18,14 +18,14 @@
 #include <linux/io.h>
 #include <mach-landisk/mach/iodata_landisk.h>
 
-static void disable_landisk_irq(unsigned int irq)
+static void disable_landisk_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned char mask = 0xff ^ (0x01 << (irq - 5));
 
 	ctrl_outb(ctrl_inb(PA_IMASK) & mask, PA_IMASK);
 }
 
-static void enable_landisk_irq(unsigned int irq)
+static void enable_landisk_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned char value = (0x01 << (irq - 5));
 
Index: linux-2.6/arch/sh/boards/mach-microdev/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-microdev/irq.c
+++ linux-2.6/arch/sh/boards/mach-microdev/irq.c
@@ -65,9 +65,9 @@ static const struct {
 #  error Inconsistancy in defining the IRQ# for primary IDE!
 #endif
 
-static void enable_microdev_irq(unsigned int irq);
-static void disable_microdev_irq(unsigned int irq);
-static void mask_and_ack_microdev(unsigned int);
+static void enable_microdev_irq(unsigned int irq, struct irq_desc *desc);
+static void disable_microdev_irq(unsigned int irq, struct irq_desc *desc);
+static void mask_and_ack_microdev(unsigned int, struct irq_desc *desc);
 
 static struct irq_chip microdev_irq_type = {
 	.name = "MicroDev-IRQ",
@@ -76,7 +76,7 @@ static struct irq_chip microdev_irq_type
 	.ack = mask_and_ack_microdev,
 };
 
-static void disable_microdev_irq(unsigned int irq)
+static void disable_microdev_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int fpgaIrq;
 
@@ -91,7 +91,7 @@ static void disable_microdev_irq(unsigne
 	ctrl_outl(MICRODEV_FPGA_INTC_MASK(fpgaIrq), MICRODEV_FPGA_INTDSB_REG);
 }
 
-static void enable_microdev_irq(unsigned int irq)
+static void enable_microdev_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long priorityReg, priorities, pri;
 	unsigned int fpgaIrq;
@@ -124,9 +124,9 @@ static void __init make_microdev_irq(uns
 	disable_microdev_irq(irq);
 }
 
-static void mask_and_ack_microdev(unsigned int irq)
+static void mask_and_ack_microdev(unsigned int irq, struct irq_desc *desc)
 {
-	disable_microdev_irq(irq);
+	disable_microdev_irq(irq, desc);
 }
 
 extern void __init init_microdev_irq(void)
Index: linux-2.6/arch/sh/boards/mach-se/7206/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7206/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7206/irq.c
@@ -25,7 +25,7 @@
 #define INTC_IPR01 0xfffe0818
 #define INTC_ICR1  0xfffe0802
 
-static void disable_se7206_irq(unsigned int irq)
+static void disable_se7206_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned short val;
 	unsigned short mask = 0xffff ^ (0x0f << 4 * (3 - (IRQ0_IRQ - irq)));
@@ -55,7 +55,7 @@ static void disable_se7206_irq(unsigned
 	ctrl_outw(msk1, INTMSK1);
 }
 
-static void enable_se7206_irq(unsigned int irq)
+static void enable_se7206_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned short val;
 	unsigned short value = (0x0001 << 4 * (3 - (IRQ0_IRQ - irq)));
@@ -86,7 +86,7 @@ static void enable_se7206_irq(unsigned i
 	ctrl_outw(msk1, INTMSK1);
 }
 
-static void eoi_se7206_irq(unsigned int irq)
+static void eoi_se7206_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned short sts0,sts1;
 
Index: linux-2.6/arch/sh/boards/mach-se/7343/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7343/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7343/irq.c
@@ -16,13 +16,13 @@
 #include <linux/io.h>
 #include <mach-se/mach/se7343.h>
 
-static void disable_se7343_irq(unsigned int irq)
+static void disable_se7343_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - SE7343_FPGA_IRQ_BASE;
 	ctrl_outw(ctrl_inw(PA_CPLD_IMSK) | 1 << bit, PA_CPLD_IMSK);
 }
 
-static void enable_se7343_irq(unsigned int irq)
+static void enable_se7343_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = irq - SE7343_FPGA_IRQ_BASE;
 	ctrl_outw(ctrl_inw(PA_CPLD_IMSK) & ~(1 << bit), PA_CPLD_IMSK);
Index: linux-2.6/arch/sh/boards/mach-se/7722/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7722/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7722/irq.c
@@ -18,13 +18,13 @@
 
 unsigned int se7722_fpga_irq[SE7722_FPGA_IRQ_NR] = { 0, };
 
-static void disable_se7722_irq(unsigned int irq)
+static void disable_se7722_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = (unsigned int)get_irq_chip_data(irq);
 	ctrl_outw(ctrl_inw(IRQ01_MASK) | 1 << bit, IRQ01_MASK);
 }
 
-static void enable_se7722_irq(unsigned int irq)
+static void enable_se7722_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int bit = (unsigned int)get_irq_chip_data(irq);
 	ctrl_outw(ctrl_inw(IRQ01_MASK) & ~(1 << bit), IRQ01_MASK);
Index: linux-2.6/arch/sh/boards/mach-se/7724/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7724/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7724/irq.c
@@ -68,14 +68,14 @@ static struct fpga_irq get_fpga_irq(unsi
 	return set;
 }
 
-static void disable_se7724_irq(unsigned int irq)
+static void disable_se7724_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct fpga_irq set = get_fpga_irq(fpga2irq(irq));
 	unsigned int bit = irq - set.base;
 	ctrl_outw(ctrl_inw(set.mraddr) | 0x0001 << bit, set.mraddr);
 }
 
-static void enable_se7724_irq(unsigned int irq)
+static void enable_se7724_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct fpga_irq set = get_fpga_irq(fpga2irq(irq));
 	unsigned int bit = irq - set.base;
Index: linux-2.6/arch/sh/boards/mach-systemh/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-systemh/irq.c
+++ linux-2.6/arch/sh/boards/mach-systemh/irq.c
@@ -24,9 +24,9 @@ static unsigned long *systemh_irq_mask_r
 static unsigned long *systemh_irq_request_register = (unsigned long *)0xB3F10000;
 
 /* forward declaration */
-static void enable_systemh_irq(unsigned int irq);
-static void disable_systemh_irq(unsigned int irq);
-static void mask_and_ack_systemh(unsigned int);
+static void enable_systemh_irq(unsigned int irq, struct irq_desc *desc);
+static void disable_systemh_irq(unsigned int irq, struct irq_desc *desc);
+static void mask_and_ack_systemh(unsigned int, struct irq_desc *desc);
 
 static struct irq_chip systemh_irq_type = {
 	.name = " SystemH Register",
@@ -35,7 +35,7 @@ static struct irq_chip systemh_irq_type
 	.ack = mask_and_ack_systemh,
 };
 
-static void disable_systemh_irq(unsigned int irq)
+static void disable_systemh_irq(unsigned int irq, struct irq_desc *desc)
 {
 	if (systemh_irq_mask_register) {
 		unsigned long val, mask = 0x01 << 1;
@@ -51,7 +51,7 @@ static void disable_systemh_irq(unsigned
 	}
 }
 
-static void enable_systemh_irq(unsigned int irq)
+static void enable_systemh_irq(unsigned int irq, struct irq_desc *desc)
 {
 	if (systemh_irq_mask_register) {
 		unsigned long val, mask = 0x01 << 1;
@@ -63,9 +63,9 @@ static void enable_systemh_irq(unsigned
 	}
 }
 
-static void mask_and_ack_systemh(unsigned int irq)
+static void mask_and_ack_systemh(unsigned int irq, struct irq_desc *desc)
 {
-	disable_systemh_irq(irq);
+	disable_systemh_irq(irq, desc);
 }
 
 void make_systemh_irq(unsigned int irq)
Index: linux-2.6/arch/sh/cchips/hd6446x/hd64461.c
===================================================================
--- linux-2.6.orig/arch/sh/cchips/hd6446x/hd64461.c
+++ linux-2.6/arch/sh/cchips/hd6446x/hd64461.c
@@ -17,7 +17,7 @@
 /* This belongs in cpu specific */
 #define INTC_ICR1 0xA4140010UL
 
-static void hd64461_mask_irq(unsigned int irq)
+static void hd64461_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned short nimr;
 	unsigned short mask = 1 << (irq - HD64461_IRQBASE);
@@ -27,7 +27,7 @@ static void hd64461_mask_irq(unsigned in
 	__raw_writew(nimr, HD64461_NIMR);
 }
 
-static void hd64461_unmask_irq(unsigned int irq)
+static void hd64461_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned short nimr;
 	unsigned short mask = 1 << (irq - HD64461_IRQBASE);
@@ -37,9 +37,9 @@ static void hd64461_unmask_irq(unsigned
 	__raw_writew(nimr, HD64461_NIMR);
 }
 
-static void hd64461_mask_and_ack_irq(unsigned int irq)
+static void hd64461_mask_and_ack_irq(unsigned int irq, struct irq_desc *desc)
 {
-	hd64461_mask_irq(irq);
+	hd64461_mask_irq(irq, desc);
 #ifdef CONFIG_HD64461_ENABLER
 	if (irq == HD64461_IRQBASE + 13)
 		__raw_writeb(0x00, HD64461_PCC1CSCR);
Index: linux-2.6/arch/sh/kernel/cpu/irq/imask.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/imask.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/imask.c
@@ -51,7 +51,7 @@ static inline void set_interrupt_registe
 		     : "t");
 }
 
-static void mask_imask_irq(unsigned int irq)
+static void mask_imask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	clear_bit(irq, imask_mask);
 	if (interrupt_priority < IMASK_PRIORITY - irq)
@@ -59,7 +59,7 @@ static void mask_imask_irq(unsigned int
 	set_interrupt_registers(interrupt_priority);
 }
 
-static void unmask_imask_irq(unsigned int irq)
+static void unmask_imask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	set_bit(irq, imask_mask);
 	interrupt_priority = IMASK_PRIORITY -
Index: linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/intc-sh5.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
@@ -79,9 +79,9 @@ static unsigned long intc_virt;
 
 static unsigned int startup_intc_irq(unsigned int irq);
 static void shutdown_intc_irq(unsigned int irq);
-static void enable_intc_irq(unsigned int irq);
-static void disable_intc_irq(unsigned int irq);
-static void mask_and_ack_intc(unsigned int);
+static void enable_intc_irq(unsigned int irq, struct irq_desc *desc);
+static void disable_intc_irq(unsigned int irq, struct irq_desc *desc);
+static void mask_and_ack_intc(unsigned int, struct irq_desc *desc);
 static void end_intc_irq(unsigned int irq);
 
 static struct irq_chip intc_irq_type = {
@@ -107,7 +107,7 @@ static void shutdown_intc_irq(unsigned i
 	disable_intc_irq(irq);
 }
 
-static void enable_intc_irq(unsigned int irq)
+static void enable_intc_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long reg;
 	unsigned long bitmask;
@@ -126,7 +126,7 @@ static void enable_intc_irq(unsigned int
 	ctrl_outl(bitmask, reg);
 }
 
-static void disable_intc_irq(unsigned int irq)
+static void disable_intc_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long reg;
 	unsigned long bitmask;
@@ -142,9 +142,9 @@ static void disable_intc_irq(unsigned in
 	ctrl_outl(bitmask, reg);
 }
 
-static void mask_and_ack_intc(unsigned int irq)
+static void mask_and_ack_intc(unsigned int irq, struct irq_desc *desc)
 {
-	disable_intc_irq(irq);
+	disable_intc_irq(irq, desc);
 }
 
 static void end_intc_irq(unsigned int irq)
Index: linux-2.6/arch/sparc/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/irq_64.c
+++ linux-2.6/arch/sparc/kernel/irq_64.c
@@ -341,7 +341,7 @@ static void sun4u_irq_disable(unsigned i
 {
 }
 
-static void sun4u_irq_eoi(unsigned int virt_irq)
+static void sun4u_irq_eoi(unsigned int virt_irq, struct irq_desc *desc)
 {
 	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
 	struct irq_desc *desc = irq_desc + virt_irq;
@@ -400,7 +400,7 @@ static void sun4v_irq_disable(unsigned i
 		       "err(%d)\n", ino, err);
 }
 
-static void sun4v_irq_eoi(unsigned int virt_irq)
+static void sun4v_irq_eoi(unsigned int virt_irq, struct irq_desc *desc)
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	struct irq_desc *desc = irq_desc + virt_irq;
@@ -480,7 +480,7 @@ static void sun4v_virq_disable(unsigned
 		       dev_handle, dev_ino, err);
 }
 
-static void sun4v_virq_eoi(unsigned int virt_irq)
+static void sun4v_virq_eoi(unsigned int virt_irq, struct irq_desc *desc)
 {
 	struct irq_desc *desc = irq_desc + virt_irq;
 	unsigned long dev_handle, dev_ino;
Index: linux-2.6/arch/sparc/kernel/pci_msi.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/pci_msi.c
+++ linux-2.6/arch/sparc/kernel/pci_msi.c
@@ -111,12 +111,21 @@ static void free_msi(struct pci_pbm_info
 	clear_bit(msi_num, pbm->msi_bitmap);
 }
 
+static void sparc64_enable_msi_irq(unsigned int irq)
+{
+	unmask_msi_irq(irq, irq_to_desc(irq));
+}
+static void sparc64_diable_msi_irq(unsigned int irq)
+{
+	mask_msi_irq(irq, irq_to_desc(irq));
+}
+
 static struct irq_chip msi_irq = {
 	.name		= "PCI-MSI",
 	.mask		= mask_msi_irq,
 	.unmask		= unmask_msi_irq,
-	.enable		= unmask_msi_irq,
-	.disable	= mask_msi_irq,
+	.enable		= sparc64_enable_msi_irq,
+	.disable	= sparc64_disable_msi_irq,
 	/* XXX affinity XXX */
 };
 
Index: linux-2.6/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/irq.c
+++ linux-2.6/arch/um/kernel/irq.c
@@ -366,13 +366,17 @@ static void dummy(unsigned int irq)
 {
 }
 
+static void dummy_desc(unsigned int irq, struct irq_desc *desc)
+{
+}
+
 /* This is used for everything else than the timer. */
 static struct irq_chip normal_irq_type = {
 	.typename = "SIGIO",
 	.release = free_irq_by_irq_and_dev,
 	.disable = dummy,
 	.enable = dummy,
-	.ack = dummy,
+	.ack = dummy_desc,
 	.end = dummy
 };
 
@@ -382,7 +386,7 @@ static struct irq_chip SIGVTALRM_irq_typ
 	.shutdown = dummy, /* never called */
 	.disable = dummy,
 	.enable = dummy,
-	.ack = dummy,
+	.ack = dummy_desc,
 	.end = dummy
 };
 
Index: linux-2.6/arch/x86/include/asm/hpet.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hpet.h
+++ linux-2.6/arch/x86/include/asm/hpet.h
@@ -74,8 +74,8 @@ extern void hpet_disable(void);
 extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
-extern void hpet_msi_unmask(unsigned int irq);
-extern void hpet_msi_mask(unsigned int irq);
+extern void hpet_msi_unmask(unsigned int irq, struct irq_desc *);
+extern void hpet_msi_mask(unsigned int irq, struct irq_desc *);
 extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
 extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -606,16 +606,12 @@ static void unmask_IO_APIC_irq_desc(stru
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_IO_APIC_irq(unsigned int irq)
+static void mask_IO_APIC_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	mask_IO_APIC_irq_desc(desc);
 }
-static void unmask_IO_APIC_irq(unsigned int irq)
+static void unmask_IO_APIC_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	unmask_IO_APIC_irq_desc(desc);
 }
 
@@ -2540,12 +2536,10 @@ void irq_force_complete_move(int irq)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-static void ack_apic_edge(unsigned int irq)
+static void ack_apic_edge(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	irq_complete_move(&desc);
-	move_native_irq(irq);
+	move_native_irq(irq, desc);
 	ack_APIC_irq();
 }
 
@@ -2604,9 +2598,8 @@ static void eoi_ioapic_irq(struct irq_de
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void ack_apic_level(unsigned int irq)
+static void ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 	int i;
 	struct irq_cfg *cfg;
@@ -2706,21 +2699,19 @@ static void ack_apic_level(unsigned int
 		 */
 		cfg = desc->chip_data;
 		if (!io_apic_level_ack_pending(cfg))
-			move_masked_irq(irq);
+			move_masked_irq(irq, desc);
 		unmask_IO_APIC_irq_desc(desc);
 	}
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void ir_ack_apic_edge(unsigned int irq)
+static void ir_ack_apic_edge(unsigned int irq, struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
-static void ir_ack_apic_level(unsigned int irq)
+static void ir_ack_apic_level(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	ack_APIC_irq();
 	eoi_ioapic_irq(desc);
 }
@@ -2792,7 +2783,7 @@ static inline void init_IO_APIC_traps(vo
  * The local APIC irq-chip implementation:
  */
 
-static void mask_lapic_irq(unsigned int irq)
+static void mask_lapic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2800,7 +2791,7 @@ static void mask_lapic_irq(unsigned int
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2808,7 +2799,7 @@ static void unmask_lapic_irq(unsigned in
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq(unsigned int irq)
+static void ack_lapic_irq(unsigned int irq, struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -426,7 +426,7 @@ static int hpet_legacy_next_event(unsign
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
-void hpet_msi_unmask(unsigned int irq)
+void hpet_msi_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct hpet_dev *hdev = get_irq_data(irq);
 	unsigned int cfg;
@@ -437,7 +437,7 @@ void hpet_msi_unmask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_mask(unsigned int irq)
+void hpet_msi_mask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int cfg;
 	struct hpet_dev *hdev = get_irq_data(irq);
Index: linux-2.6/arch/x86/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259.c
+++ linux-2.6/arch/x86/kernel/i8259.c
@@ -33,13 +33,22 @@
 
 static int i8259A_auto_eoi;
 DEFINE_RAW_SPINLOCK(i8259A_lock);
-static void mask_and_ack_8259A(unsigned int);
+static void mask_and_ack_8259A(unsigned int, struct irq_desc *desc);
+
+static void disable_8259A_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	disable_8259A_irq(irq);
+}
+static void enable_8259A_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	enable_8259A_irq(irq);
+}
 
 struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
-	.mask		= disable_8259A_irq,
+	.mask		= disable_8259A_irq_desc,
 	.disable	= disable_8259A_irq,
-	.unmask		= enable_8259A_irq,
+	.unmask		= enable_8259A_irq_desc,
 	.mask_ack	= mask_and_ack_8259A,
 };
 
@@ -145,7 +154,7 @@ static inline int i8259A_irq_real(unsign
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-static void mask_and_ack_8259A(unsigned int irq)
+static void mask_and_ack_8259A(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int irqmask = 1 << irq;
 	unsigned long flags;
@@ -347,7 +356,7 @@ void init_8259A(int auto_eoi)
 		 * In AEOI mode we just have to mask the interrupt
 		 * when acking.
 		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
+		i8259A_chip.mask_ack = disable_8259A_irq_desc;
 	else
 		i8259A_chip.mask_ack = mask_and_ack_8259A;
 
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -316,7 +316,7 @@ void fixup_irqs(void)
 		}
 
 		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
-			desc->chip->mask(irq);
+			desc->chip->mask(irq, desc);
 
 		if (desc->chip->set_affinity)
 			desc->chip->set_affinity(irq, affinity);
@@ -324,7 +324,7 @@ void fixup_irqs(void)
 			set_affinity = 0;
 
 		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
-			desc->chip->unmask(irq);
+			desc->chip->unmask(irq, desc);
 
 		raw_spin_unlock(&desc->lock);
 
Index: linux-2.6/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6/arch/x86/kernel/uv_irq.c
@@ -33,6 +33,10 @@ static void uv_noop(unsigned int irq)
 {
 }
 
+static void uv_noop_desc(unsigned int irq, struct irq_desc *desc)
+{
+}
+
 static unsigned int uv_noop_ret(unsigned int irq)
 {
 	return 0;
@@ -49,9 +53,9 @@ struct irq_chip uv_irq_chip = {
 	.shutdown	= uv_noop,
 	.enable		= uv_noop,
 	.disable	= uv_noop,
-	.ack		= uv_noop,
-	.mask		= uv_noop,
-	.unmask		= uv_noop,
+	.ack		= uv_noop_desc,
+	.mask		= uv_noop_desc,
+	.unmask		= uv_noop_desc,
 	.eoi		= uv_ack_apic,
 	.end		= uv_noop,
 	.set_affinity	= uv_set_irq_affinity,
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -464,7 +464,7 @@ static unsigned int startup_cobalt_irq(u
 	return 0;
 }
 
-static void ack_cobalt_irq(unsigned int irq)
+static void ack_cobalt_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flags;
 
Index: linux-2.6/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmiclock_32.c
+++ linux-2.6/arch/x86/kernel/vmiclock_32.c
@@ -92,19 +92,19 @@ static unsigned int startup_timer_irq(un
 	return (val & APIC_SEND_PENDING);
 }
 
-static void mask_timer_irq(unsigned int irq)
+static void mask_timer_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val | APIC_LVT_MASKED);
 }
 
-static void unmask_timer_irq(unsigned int irq)
+static void unmask_timer_irq(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val & ~APIC_LVT_MASKED);
 }
 
-static void ack_timer_irq(unsigned int irq)
+static void ack_timer_irq(unsigned int irq, struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -789,12 +789,12 @@ static void lguest_flush_tlb_kernel(void
  * simple as setting a bit.  We don't actually "ack" interrupts as such, we
  * just mask and unmask them.  I wonder if we should be cleverer?
  */
-static void disable_lguest_irq(unsigned int irq)
+static void disable_lguest_irq(unsigned int irq, struct irq_desc *desc)
 {
 	set_bit(irq, lguest_data.blocked_interrupts);
 }
 
-static void enable_lguest_irq(unsigned int irq)
+static void enable_lguest_irq(unsigned int irq, struct irq_desc *desc)
 {
 	clear_bit(irq, lguest_data.blocked_interrupts);
 }
Index: linux-2.6/arch/xtensa/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/irq.c
+++ linux-2.6/arch/xtensa/kernel/irq.c
@@ -120,13 +120,13 @@ skip:
 	return 0;
 }
 
-static void xtensa_irq_mask(unsigned int irq)
+static void xtensa_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	cached_irq_mask &= ~(1 << irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_unmask(unsigned int irq)
+static void xtensa_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	cached_irq_mask |= 1 << irq;
 	set_sr (cached_irq_mask, INTENABLE);
@@ -135,16 +135,16 @@ static void xtensa_irq_unmask(unsigned i
 static void xtensa_irq_enable(unsigned int irq)
 {
 	variant_irq_enable(irq);
-	xtensa_irq_unmask(irq);
+	xtensa_irq_unmask(irq, irq_to_desc(irq));
 }
 
 static void xtensa_irq_disable(unsigned int irq)
 {
-	xtensa_irq_mask(irq);
+	xtensa_irq_mask(irq, irq_to_desc(irq));
 	variant_irq_disable(irq);
 }
 
-static void xtensa_irq_ack(unsigned int irq)
+static void xtensa_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	set_sr(1 << irq, INTCLEAR);
 }
Index: linux-2.6/arch/xtensa/variants/s6000/gpio.c
===================================================================
--- linux-2.6.orig/arch/xtensa/variants/s6000/gpio.c
+++ linux-2.6/arch/xtensa/variants/s6000/gpio.c
@@ -85,19 +85,19 @@ int s6_gpio_init(u32 afsel)
 	return gpiochip_add(&gpiochip);
 }
 
-static void ack(unsigned int irq)
+static void ack(unsigned int irq, struct irq_desc *desc)
 {
 	writeb(1 << (irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
 }
 
-static void mask(unsigned int irq)
+static void mask(unsigned int irq, struct irq_desc *desc)
 {
 	u8 r = readb(S6_REG_GPIO + S6_GPIO_IE);
 	r &= ~(1 << (irq - IRQ_BASE));
 	writeb(r, S6_REG_GPIO + S6_GPIO_IE);
 }
 
-static void unmask(unsigned int irq)
+static void unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u8 m = readb(S6_REG_GPIO + S6_GPIO_IE);
 	m |= 1 << (irq - IRQ_BASE);
@@ -164,8 +164,8 @@ static void demux_irqs(unsigned int irq,
 	u8 pending;
 	int cirq;
 
-	desc->chip->mask(irq);
-	desc->chip->ack(irq);
+	desc->chip->mask(irq, desc);
+	desc->chip->ack(irq, desc);
 	pending = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_MIS) & *mask;
 	cirq = IRQ_BASE - 1;
 	while (pending) {
@@ -174,7 +174,7 @@ static void demux_irqs(unsigned int irq,
 		pending >>= n;
 		generic_handle_irq(cirq);
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 extern const signed char *platform_irq_mappings[XTENSA_NR_IRQS];
Index: linux-2.6/drivers/dma/ipu/ipu_irq.c
===================================================================
--- linux-2.6.orig/drivers/dma/ipu/ipu_irq.c
+++ linux-2.6/drivers/dma/ipu/ipu_irq.c
@@ -94,7 +94,7 @@ static struct ipu_irq_map *src2map(unsig
 	return NULL;
 }
 
-static void ipu_irq_unmask(unsigned int irq)
+static void ipu_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct ipu_irq_map *map = get_irq_chip_data(irq);
 	struct ipu_irq_bank *bank;
@@ -117,7 +117,7 @@ static void ipu_irq_unmask(unsigned int
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_mask(unsigned int irq)
+static void ipu_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	struct ipu_irq_map *map = get_irq_chip_data(irq);
 	struct ipu_irq_bank *bank;
@@ -140,7 +140,7 @@ static void ipu_irq_mask(unsigned int ir
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_ack(unsigned int irq)
+static void ipu_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 	struct ipu_irq_map *map = get_irq_chip_data(irq);
 	struct ipu_irq_bank *bank;
Index: linux-2.6/drivers/gpio/langwell_gpio.c
===================================================================
--- linux-2.6.orig/drivers/gpio/langwell_gpio.c
+++ linux-2.6/drivers/gpio/langwell_gpio.c
@@ -142,11 +142,11 @@ static int lnw_irq_type(unsigned irq, un
 	return 0;
 };
 
-static void lnw_irq_unmask(unsigned irq)
+static void lnw_irq_unmask(unsigned irq, struct irq_desc *desc)
 {
 };
 
-static void lnw_irq_mask(unsigned irq)
+static void lnw_irq_mask(unsigned irq, struct irq_desc *desc)
 {
 };
 
@@ -184,7 +184,7 @@ static void lnw_irq_handler(unsigned irq
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
Index: linux-2.6/drivers/gpio/pl061.c
===================================================================
--- linux-2.6.orig/drivers/gpio/pl061.c
+++ linux-2.6/drivers/gpio/pl061.c
@@ -122,7 +122,7 @@ static int pl061_to_irq(struct gpio_chip
 /*
  * PL061 GPIO IRQ
  */
-static void pl061_irq_disable(unsigned irq)
+static void pl061_irq_disable(unsigned irq, struct irq_desc *desc)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
 	int offset = irq - chip->irq_base;
@@ -136,7 +136,7 @@ static void pl061_irq_disable(unsigned i
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static void pl061_irq_enable(unsigned irq)
+static void pl061_irq_enable(unsigned irq, struct irq_desc *desc)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
 	int offset = irq - chip->irq_base;
@@ -207,7 +207,7 @@ static void pl061_irq_handler(unsigned i
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
 		int offset;
@@ -222,7 +222,7 @@ static void pl061_irq_handler(unsigned i
 		for_each_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 }
 
 static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
Index: linux-2.6/drivers/gpio/timbgpio.c
===================================================================
--- linux-2.6.orig/drivers/gpio/timbgpio.c
+++ linux-2.6/drivers/gpio/timbgpio.c
@@ -104,7 +104,7 @@ static int timbgpio_to_irq(struct gpio_c
 /*
  * GPIO IRQ
  */
-static void timbgpio_irq_disable(unsigned irq)
+static void timbgpio_irq_disable(unsigned irq, struct irq_desc *desc)
 {
 	struct timbgpio *tgpio = get_irq_chip_data(irq);
 	int offset = irq - tgpio->irq_base;
@@ -112,7 +112,7 @@ static void timbgpio_irq_disable(unsigne
 	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 0);
 }
 
-static void timbgpio_irq_enable(unsigned irq)
+static void timbgpio_irq_enable(unsigned irq, struct irq_desc *desc)
 {
 	struct timbgpio *tgpio = get_irq_chip_data(irq);
 	int offset = irq - tgpio->irq_base;
@@ -170,7 +170,7 @@ static void timbgpio_irq(unsigned int ir
 	unsigned long ipr;
 	int offset;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
Index: linux-2.6/drivers/gpio/vr41xx_giu.c
===================================================================
--- linux-2.6.orig/drivers/gpio/vr41xx_giu.c
+++ linux-2.6/drivers/gpio/vr41xx_giu.c
@@ -111,17 +111,17 @@ static inline u16 giu_clear(u16 offset,
 	return data;
 }
 
-static void ack_giuint_low(unsigned int irq)
+static void ack_giuint_low(unsigned int irq, struct irq_desc *desc)
 {
 	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(irq));
 }
 
-static void mask_giuint_low(unsigned int irq)
+static void mask_giuint_low(unsigned int irq, struct irq_desc *desc)
 {
 	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
 }
 
-static void mask_ack_giuint_low(unsigned int irq)
+static void mask_ack_giuint_low(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int pin;
 
@@ -130,7 +130,7 @@ static void mask_ack_giuint_low(unsigned
 	giu_write(GIUINTSTATL, 1 << pin);
 }
 
-static void unmask_giuint_low(unsigned int irq)
+static void unmask_giuint_low(unsigned int irq, struct irq_desc *desc)
 {
 	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
 }
@@ -143,18 +143,18 @@ static struct irq_chip giuint_low_irq_ch
 	.unmask		= unmask_giuint_low,
 };
 
-static void ack_giuint_high(unsigned int irq)
+static void ack_giuint_high(unsigned int irq, struct irq_desc *desc)
 {
 	giu_write(GIUINTSTATH,
 		  1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_giuint_high(unsigned int irq)
+static void mask_giuint_high(unsigned int irq, struct irq_desc *desc)
 {
 	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_ack_giuint_high(unsigned int irq)
+static void mask_ack_giuint_high(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int pin;
 
@@ -163,7 +163,7 @@ static void mask_ack_giuint_high(unsigne
 	giu_write(GIUINTSTATH, 1 << pin);
 }
 
-static void unmask_giuint_high(unsigned int irq)
+static void unmask_giuint_high(unsigned int irq, struct irq_desc *desc)
 {
 	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
 }
Index: linux-2.6/drivers/mfd/asic3.c
===================================================================
--- linux-2.6.orig/drivers/mfd/asic3.c
+++ linux-2.6/drivers/mfd/asic3.c
@@ -142,7 +142,7 @@ static void asic3_irq_demux(unsigned int
 	unsigned long flags;
 	struct asic3 *asic;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 
 	asic = desc->handler_data;
 
@@ -225,7 +225,7 @@ static inline int asic3_irq_to_index(str
 	return (irq - asic->irq_base) & 0xf;
 }
 
-static void asic3_mask_gpio_irq(unsigned int irq)
+static void asic3_mask_gpio_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	u32 val, bank, index;
@@ -241,7 +241,7 @@ static void asic3_mask_gpio_irq(unsigned
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_mask_irq(unsigned int irq)
+static void asic3_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	int regval;
@@ -262,7 +262,7 @@ static void asic3_mask_irq(unsigned int
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_gpio_irq(unsigned int irq)
+static void asic3_unmask_gpio_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	u32 val, bank, index;
@@ -278,7 +278,7 @@ static void asic3_unmask_gpio_irq(unsign
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_irq(unsigned int irq)
+static void asic3_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct asic3 *asic = get_irq_chip_data(irq);
 	int regval;
Index: linux-2.6/drivers/mfd/ezx-pcap.c
===================================================================
--- linux-2.6.orig/drivers/mfd/ezx-pcap.c
+++ linux-2.6/drivers/mfd/ezx-pcap.c
@@ -143,7 +143,7 @@ int pcap_to_irq(struct pcap_chip *pcap,
 }
 EXPORT_SYMBOL_GPL(pcap_to_irq);
 
-static void pcap_mask_irq(unsigned int irq)
+static void pcap_mask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct pcap_chip *pcap = get_irq_chip_data(irq);
 
@@ -151,7 +151,7 @@ static void pcap_mask_irq(unsigned int i
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
 
-static void pcap_unmask_irq(unsigned int irq)
+static void pcap_unmask_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct pcap_chip *pcap = get_irq_chip_data(irq);
 
@@ -217,7 +217,7 @@ static void pcap_irq_handler(unsigned in
 {
 	struct pcap_chip *pcap = get_irq_data(irq);
 
-	desc->chip->ack(irq);
+	desc->chip->ack(irq, desc);
 	queue_work(pcap->workqueue, &pcap->isr_work);
 	return;
 }
Index: linux-2.6/drivers/mfd/htc-egpio.c
===================================================================
--- linux-2.6.orig/drivers/mfd/htc-egpio.c
+++ linux-2.6/drivers/mfd/htc-egpio.c
@@ -69,20 +69,20 @@ static inline void ack_irqs(struct egpio
 			ei->ack_write, ei->ack_register << ei->bus_shift);
 }
 
-static void egpio_ack(unsigned int irq)
+static void egpio_ack(unsigned int irq, struct irq_desc *desc)
 {
 }
 
 /* There does not appear to be a way to proactively mask interrupts
  * on the egpio chip itself.  So, we simply ignore interrupts that
  * aren't desired. */
-static void egpio_mask(unsigned int irq)
+static void egpio_mask(unsigned int irq, struct irq_desc *desc)
 {
 	struct egpio_info *ei = get_irq_chip_data(irq);
 	ei->irqs_enabled &= ~(1 << (irq - ei->irq_start));
 	pr_debug("EGPIO mask %d %04x\n", irq, ei->irqs_enabled);
 }
-static void egpio_unmask(unsigned int irq)
+static void egpio_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct egpio_info *ei = get_irq_chip_data(irq);
 	ei->irqs_enabled |= 1 << (irq - ei->irq_start);
Index: linux-2.6/drivers/mfd/t7l66xb.c
===================================================================
--- linux-2.6.orig/drivers/mfd/t7l66xb.c
+++ linux-2.6/drivers/mfd/t7l66xb.c
@@ -198,7 +198,7 @@ static void t7l66xb_irq(unsigned int irq
 				generic_handle_irq(irq_base + i);
 }
 
-static void t7l66xb_irq_mask(unsigned int irq)
+static void t7l66xb_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
 	unsigned long			flags;
@@ -211,7 +211,7 @@ static void t7l66xb_irq_mask(unsigned in
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 }
 
-static void t7l66xb_irq_unmask(unsigned int irq)
+static void t7l66xb_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
 	unsigned long flags;
Index: linux-2.6/drivers/mfd/tc6393xb.c
===================================================================
--- linux-2.6.orig/drivers/mfd/tc6393xb.c
+++ linux-2.6/drivers/mfd/tc6393xb.c
@@ -526,11 +526,11 @@ tc6393xb_irq(unsigned int irq, struct ir
 		}
 }
 
-static void tc6393xb_irq_ack(unsigned int irq)
+static void tc6393xb_irq_ack(unsigned int irq, struct irq_desc *desc)
 {
 }
 
-static void tc6393xb_irq_mask(unsigned int irq)
+static void tc6393xb_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
 	unsigned long flags;
@@ -543,7 +543,7 @@ static void tc6393xb_irq_mask(unsigned i
 	spin_unlock_irqrestore(&tc6393xb->lock, flags);
 }
 
-static void tc6393xb_irq_unmask(unsigned int irq)
+static void tc6393xb_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
 	unsigned long flags;
Index: linux-2.6/drivers/mfd/twl4030-irq.c
===================================================================
--- linux-2.6.orig/drivers/mfd/twl4030-irq.c
+++ linux-2.6/drivers/mfd/twl4030-irq.c
@@ -595,7 +595,7 @@ static void twl4030_sih_do_edge(struct w
  * completion, potentially including some re-ordering, of these requests.
  */
 
-static void twl4030_sih_mask(unsigned irq)
+static void twl4030_sih_mask(unsigned irq, struct irq_desc *desc)
 {
 	struct sih_agent *sih = get_irq_chip_data(irq);
 	unsigned long flags;
@@ -607,7 +607,7 @@ static void twl4030_sih_mask(unsigned ir
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static void twl4030_sih_unmask(unsigned irq)
+static void twl4030_sih_unmask(unsigned irq, struct irq_desc *desc)
 {
 	struct sih_agent *sih = get_irq_chip_data(irq);
 	unsigned long flags;
Index: linux-2.6/drivers/mfd/wm831x-irq.c
===================================================================
--- linux-2.6.orig/drivers/mfd/wm831x-irq.c
+++ linux-2.6/drivers/mfd/wm831x-irq.c
@@ -372,7 +372,7 @@ static void wm831x_irq_sync_unlock(unsig
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(unsigned int irq)
+static void wm831x_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct wm831x *wm831x = get_irq_chip_data(irq);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
@@ -380,7 +380,7 @@ static void wm831x_irq_unmask(unsigned i
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(unsigned int irq)
+static void wm831x_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	struct wm831x *wm831x = get_irq_chip_data(irq);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
Index: linux-2.6/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-gru/grufile.c
+++ linux-2.6/drivers/misc/sgi-gru/grufile.c
@@ -348,7 +348,7 @@ static unsigned long gru_chiplet_cpu_to_
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(unsigned int irq, struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -1230,7 +1230,7 @@ const char *dmar_get_fault_reason(u8 fau
 	}
 }
 
-void dmar_msi_unmask(unsigned int irq)
+void dmar_msi_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	struct intel_iommu *iommu = get_irq_data(irq);
 	unsigned long flag;
@@ -1243,7 +1243,7 @@ void dmar_msi_unmask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_mask(unsigned int irq)
+void dmar_msi_mask(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long flag;
 	struct intel_iommu *iommu = get_irq_data(irq);
Index: linux-2.6/drivers/pci/htirq.c
===================================================================
--- linux-2.6.orig/drivers/pci/htirq.c
+++ linux-2.6/drivers/pci/htirq.c
@@ -58,7 +58,7 @@ void fetch_ht_irq_msg(unsigned int irq,
 	*msg = cfg->msg;
 }
 
-void mask_ht_irq(unsigned int irq)
+void mask_ht_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
@@ -70,7 +70,7 @@ void mask_ht_irq(unsigned int irq)
 	write_ht_irq_msg(irq, &msg);
 }
 
-void unmask_ht_irq(unsigned int irq)
+void unmask_ht_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -182,12 +182,12 @@ static void msi_set_mask_bit(unsigned ir
 	}
 }
 
-void mask_msi_irq(unsigned int irq)
+void mask_msi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	msi_set_mask_bit(irq, 1);
 }
 
-void unmask_msi_irq(unsigned int irq)
+void unmask_msi_irq(unsigned int irq, struct irq_desc *desc)
 {
 	msi_set_mask_bit(irq, 0);
 }
Index: linux-2.6/drivers/vlynq/vlynq.c
===================================================================
--- linux-2.6.orig/drivers/vlynq/vlynq.c
+++ linux-2.6/drivers/vlynq/vlynq.c
@@ -133,7 +133,7 @@ static void vlynq_reset(struct vlynq_dev
 	msleep(5);
 }
 
-static void vlynq_irq_unmask(unsigned int irq)
+static void vlynq_irq_unmask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 val;
 	struct vlynq_device *dev = get_irq_chip_data(irq);
@@ -146,7 +146,7 @@ static void vlynq_irq_unmask(unsigned in
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static void vlynq_irq_mask(unsigned int irq)
+static void vlynq_irq_mask(unsigned int irq, struct irq_desc *desc)
 {
 	u32 val;
 	struct vlynq_device *dev = get_irq_chip_data(irq);
@@ -190,7 +190,7 @@ static int vlynq_irq_type(unsigned int i
 	return 0;
 }
 
-static void vlynq_local_ack(unsigned int irq)
+static void vlynq_local_ack(unsigned int irq, struct irq_desc *desc)
 {
 	struct vlynq_device *dev = get_irq_chip_data(irq);
 
@@ -201,7 +201,7 @@ static void vlynq_local_ack(unsigned int
 	writel(status, &dev->local->status);
 }
 
-static void vlynq_remote_ack(unsigned int irq)
+static void vlynq_remote_ack(unsigned int irq, struct irq_desc *desc)
 {
 	struct vlynq_device *dev = get_irq_chip_data(irq);
 
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -756,6 +756,12 @@ static void enable_dynirq(unsigned int i
 		unmask_evtchn(evtchn);
 }
 
+static void unmask_dynirq(unsigned int irq, struct irq_desc *desc)
+{
+	enable_dynirq(irq);
+}
+
+
 static void disable_dynirq(unsigned int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
@@ -764,7 +770,12 @@ static void disable_dynirq(unsigned int
 		mask_evtchn(evtchn);
 }
 
-static void ack_dynirq(unsigned int irq)
+static void mask_dynirq(unsigned int irq, struct irq_desc *desc)
+{
+	disable_dynirq(irq);
+}
+
+static void ack_dynirq(unsigned int irq, struct irq_desc *desc)
 {
 	int evtchn = evtchn_from_irq(irq);
 
@@ -924,10 +935,11 @@ static struct irq_chip xen_dynamic_chip
 	.name		= "xen-dyn",
 
 	.disable	= disable_dynirq,
-	.mask		= disable_dynirq,
-	.unmask		= enable_dynirq,
 
+	.mask		= mask_dynirq,
+	.unmask		= unmask_dynirq,
 	.ack		= ack_dynirq,
+
 	.set_affinity	= set_affinity_irq,
 	.retrigger	= retrigger_dynirq,
 };
Index: linux-2.6/include/linux/dmar.h
===================================================================
--- linux-2.6.orig/include/linux/dmar.h
+++ linux-2.6/include/linux/dmar.h
@@ -187,8 +187,8 @@ static inline int set_msi_sid(struct irt
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */
-extern void dmar_msi_unmask(unsigned int irq);
-extern void dmar_msi_mask(unsigned int irq);
+extern void dmar_msi_unmask(unsigned int irq, struct irq_desc *);
+extern void dmar_msi_mask(unsigned int irq, struct irq_desc *);
 extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
Index: linux-2.6/include/linux/htirq.h
===================================================================
--- linux-2.6.orig/include/linux/htirq.h
+++ linux-2.6/include/linux/htirq.h
@@ -9,8 +9,9 @@ struct ht_irq_msg {
 /* Helper functions.. */
 void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
 void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void mask_ht_irq(unsigned int irq);
-void unmask_ht_irq(unsigned int irq);
+struct irq_desc;
+void mask_ht_irq(unsigned int irq, struct irq_desc *);
+void unmask_ht_irq(unsigned int irq, struct irq_desc *);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -115,11 +115,11 @@ struct irq_chip {
 	void		(*enable)(unsigned int irq);
 	void		(*disable)(unsigned int irq);
 
-	void		(*ack)(unsigned int irq);
-	void		(*mask)(unsigned int irq);
-	void		(*mask_ack)(unsigned int irq);
-	void		(*unmask)(unsigned int irq);
-	void		(*eoi)(unsigned int irq);
+	void		(*ack)(unsigned int irq, struct irq_desc *desc);
+	void		(*mask)(unsigned int irq, struct irq_desc *desc);
+	void		(*mask_ack)(unsigned int irq, struct irq_desc *desc);
+	void		(*unmask)(unsigned int irq, struct irq_desc *desc);
+	void		(*eoi)(unsigned int irq, struct irq_desc *desc);
 
 	void		(*end)(unsigned int irq);
 	int		(*set_affinity)(unsigned int irq,
@@ -241,8 +241,8 @@ extern void remove_irq(unsigned int irq,
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void move_native_irq(int irq);
-void move_masked_irq(int irq);
+void move_native_irq(int irq, struct irq_desc *desc);
+void move_masked_irq(int irq, struct irq_desc *desc);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
@@ -250,11 +250,11 @@ static inline void move_irq(int irq)
 {
 }
 
-static inline void move_native_irq(int irq)
+static inline void move_native_irq(int irq, struct irq_desc *desc)
 {
 }
 
-static inline void move_masked_irq(int irq)
+static inline void move_masked_irq(int irq, struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/include/linux/msi.h
===================================================================
--- linux-2.6.orig/include/linux/msi.h
+++ linux-2.6/include/linux/msi.h
@@ -11,8 +11,8 @@ struct msi_msg {
 
 /* Helper functions */
 struct irq_desc;
-extern void mask_msi_irq(unsigned int irq);
-extern void unmask_msi_irq(unsigned int irq);
+extern void mask_msi_irq(unsigned int irq, struct irq_desc *);
+extern void unmask_msi_irq(unsigned int irq, struct irq_desc *);
 extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -291,7 +291,7 @@ static void default_enable(unsigned int
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(irq, desc);
 	desc->status &= ~IRQ_MASKED;
 }
 
@@ -320,7 +320,7 @@ static void default_shutdown(unsigned in
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->chip->mask(irq);
+	desc->chip->mask(irq, desc);
 	desc->status |= IRQ_MASKED;
 }
 
@@ -353,11 +353,11 @@ void irq_chip_set_defaults(struct irq_ch
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 {
 	if (desc->chip->mask_ack)
-		desc->chip->mask_ack(irq);
+		desc->chip->mask_ack(irq, desc);
 	else {
-		desc->chip->mask(irq);
+		desc->chip->mask(irq, desc);
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc->chip->ack(irq, desc);
 	}
 }
 
@@ -487,7 +487,7 @@ handle_level_irq(unsigned int irq, struc
 	if (unlikely(desc->status & IRQ_ONESHOT))
 		desc->status |= IRQ_MASKED;
 	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(irq);
+		desc->chip->unmask(irq, desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -525,7 +525,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
 		if (desc->chip->mask)
-			desc->chip->mask(irq);
+			desc->chip->mask(irq, desc);
 		goto out;
 	}
 
@@ -540,7 +540,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->chip->eoi(irq);
+	desc->chip->eoi(irq, desc);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -583,7 +583,7 @@ handle_edge_irq(unsigned int irq, struct
 
 	/* Start handling the irq */
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -593,7 +593,7 @@ handle_edge_irq(unsigned int irq, struct
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			desc->chip->mask(irq);
+			desc->chip->mask(irq, desc);
 			goto out_unlock;
 		}
 
@@ -605,7 +605,7 @@ handle_edge_irq(unsigned int irq, struct
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			desc->chip->unmask(irq);
+			desc->chip->unmask(irq, desc);
 			desc->status &= ~IRQ_MASKED;
 		}
 
@@ -638,14 +638,14 @@ handle_percpu_irq(unsigned int irq, stru
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(irq, desc);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
 	if (desc->chip->eoi)
-		desc->chip->eoi(irq);
+		desc->chip->eoi(irq, desc);
 }
 
 void
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -292,10 +292,8 @@ void clear_kstat_irqs(struct irq_desc *d
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
-static void ack_bad(unsigned int irq)
+static void ack_bad(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	print_irq_desc(irq, desc);
 	ack_bad_irq(irq);
 }
@@ -307,6 +305,10 @@ static void noop(unsigned int irq)
 {
 }
 
+static void noop_desc(unsigned int irq, struct irq_desc *desc)
+{
+}
+
 static unsigned int noop_ret(unsigned int irq)
 {
 	return 0;
@@ -335,9 +337,9 @@ struct irq_chip dummy_irq_chip = {
 	.shutdown	= noop,
 	.enable		= noop,
 	.disable	= noop,
-	.ack		= noop,
-	.mask		= noop,
-	.unmask		= noop,
+	.ack		= noop_desc,
+	.mask		= noop_desc,
+	.unmask		= noop_desc,
 	.end		= noop,
 };
 
@@ -461,7 +463,7 @@ unsigned int __do_IRQ(unsigned int irq)
 		 * No locking required for CPU-local interrupts:
 		 */
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc->chip->ack(irq, desc);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -473,7 +475,7 @@ unsigned int __do_IRQ(unsigned int irq)
 
 	raw_spin_lock(&desc->lock);
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(irq, desc);
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -487,7 +487,7 @@ static void irq_finalize_oneshot(unsigne
 	raw_spin_lock_irq(&desc->lock);
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->chip->unmask(irq);
+		desc->chip->unmask(irq, desc);
 	}
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(irq, desc);
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -4,10 +4,8 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void move_masked_irq(int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
@@ -51,18 +49,16 @@ void move_masked_irq(int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_native_irq(int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->chip->mask(irq);
-	move_masked_irq(irq);
-	desc->chip->unmask(irq);
+	desc->chip->mask(irq, desc);
+	move_masked_irq(irq, desc);
+	desc->chip->unmask(irq, desc);
 }
 
