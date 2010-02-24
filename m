Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0BXJbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:31:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:33266 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab0BXJbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:31:33 -0500
Message-ID: <4B84F0D2.4030807@kernel.org>
Date: Wed, 24 Feb 2010 01:26:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-arch@vger.kernel.org
Subject: [PATCH -v3 2/2] genericirq: change ack/mask in irq_chip to take irq_desc
 instead of irq
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org>	<m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org>	<4B7CAADD.2060000@kernel.org> <m1mxz6v4pm.fsf@fess.ebiederm.org> <4B83781B.20307@kernel.org> <4B84F013.9040708@kernel.org>
In-Reply-To: <4B84F013.9040708@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



will have
void            (*ack)(struct irq_desc *desc);
void            (*mask)(struct irq_desc *desc);
void            (*mask_ack)(struct irq_desc *desc);
void            (*unmask)(struct irq_desc *desc);
void            (*eoi)(struct irq_desc *desc);

so for sparseirq with raidix tree, we don't call extra irq_to_desc, and could use desc directly

-v2: change all member of irq_chip to use desc only.
-v3: update after legacy_pic

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/DocBook/genericirq.tmpl            |   24 ++--
 arch/alpha/kernel/irq.c                          |    7 -
 arch/alpha/kernel/irq_alpha.c                    |    4 
 arch/alpha/kernel/irq_i8259.c                    |   22 ++--
 arch/alpha/kernel/irq_pyxis.c                    |   21 ++-
 arch/alpha/kernel/irq_srm.c                      |   18 +--
 arch/alpha/kernel/sys_alcor.c                    |   28 ++---
 arch/alpha/kernel/sys_cabriolet.c                |   18 ++-
 arch/alpha/kernel/sys_dp264.c                    |   50 +++++----
 arch/alpha/kernel/sys_eb64p.c                    |   18 ++-
 arch/alpha/kernel/sys_eiger.c                    |   18 ++-
 arch/alpha/kernel/sys_jensen.c                   |   40 +++----
 arch/alpha/kernel/sys_marvel.c                   |   26 ++--
 arch/alpha/kernel/sys_mikasa.c                   |   18 +--
 arch/alpha/kernel/sys_noritake.c                 |   18 ++-
 arch/alpha/kernel/sys_rawhide.c                  |   19 ++-
 arch/alpha/kernel/sys_rx164.c                    |   18 +--
 arch/alpha/kernel/sys_sable.c                    |   26 ++--
 arch/alpha/kernel/sys_takara.c                   |   18 ++-
 arch/alpha/kernel/sys_titan.c                    |   22 ++--
 arch/alpha/kernel/sys_wildfire.c                 |   32 +++--
 arch/arm/common/gic.c                            |   20 ++-
 arch/arm/common/it8152.c                         |    8 +
 arch/arm/common/locomo.c                         |  103 ++++++++++++------
 arch/arm/common/sa1111.c                         |   56 ++++++----
 arch/arm/common/vic.c                            |   21 ++-
 arch/arm/kernel/ecard.c                          |   12 +-
 arch/arm/kernel/irq.c                            |    2 
 arch/arm/mach-aaec2000/core.c                    |    6 -
 arch/arm/mach-at91/gpio.c                        |   15 +-
 arch/arm/mach-at91/irq.c                         |   15 ++
 arch/arm/mach-bcmring/irq.c                      |   24 +++-
 arch/arm/mach-clps711x/irq.c                     |   18 ++-
 arch/arm/mach-davinci/cp_intc.c                  |   14 +-
 arch/arm/mach-davinci/gpio.c                     |   32 ++---
 arch/arm/mach-davinci/irq.c                      |    9 +
 arch/arm/mach-dove/irq.c                         |    9 +
 arch/arm/mach-ebsa110/core.c                     |    6 -
 arch/arm/mach-ep93xx/core.c                      |   16 +-
 arch/arm/mach-footbridge/common.c                |    6 -
 arch/arm/mach-footbridge/isa-irq.c               |   18 ++-
 arch/arm/mach-gemini/gpio.c                      |   12 +-
 arch/arm/mach-gemini/irq.c                       |    9 +
 arch/arm/mach-h720x/common.c                     |   15 +-
 arch/arm/mach-h720x/cpu-h7202.c                  |    6 -
 arch/arm/mach-integrator/integrator_ap.c         |    6 -
 arch/arm/mach-integrator/integrator_cp.c         |   18 ++-
 arch/arm/mach-iop13xx/irq.c                      |   24 ++--
 arch/arm/mach-iop13xx/msi.c                      |    2 
 arch/arm/mach-iop32x/irq.c                       |    6 -
 arch/arm/mach-ixp2000/core.c                     |   30 +++--
 arch/arm/mach-ixp2000/ixdp2x00.c                 |   10 +
 arch/arm/mach-ixp2000/ixdp2x01.c                 |   10 +
 arch/arm/mach-ixp23xx/core.c                     |   25 ++--
 arch/arm/mach-ixp23xx/ixdp2351.c                 |   20 ++-
 arch/arm/mach-ixp4xx/common.c                    |   14 +-
 arch/arm/mach-ks8695/irq.c                       |   28 ++---
 arch/arm/mach-l7200/core.c                       |    6 -
 arch/arm/mach-lh7a40x/arch-kev7a400.c            |    9 +
 arch/arm/mach-lh7a40x/arch-lpd7a40x.c            |   13 +-
 arch/arm/mach-lh7a40x/irq-lh7a400.c              |    9 +
 arch/arm/mach-lh7a40x/irq-lh7a404.c              |   18 ++-
 arch/arm/mach-lh7a40x/irq-lpd7a40x.c             |   12 +-
 arch/arm/mach-mmp/irq.c                          |    8 -
 arch/arm/mach-mx3/mx31ads.c                      |    9 +
 arch/arm/mach-mx3/mx31pdk.c                      |    9 +
 arch/arm/mach-netx/generic.c                     |   12 +-
 arch/arm/mach-nomadik/gpio.c                     |   26 ++--
 arch/arm/mach-ns9xxx/board-a9m9750dev.c          |   15 +-
 arch/arm/mach-ns9xxx/irq.c                       |   15 +-
 arch/arm/mach-omap1/fpga.c                       |   13 +-
 arch/arm/mach-omap1/irq.c                        |   24 ++--
 arch/arm/mach-pnx4008/irq.c                      |   12 +-
 arch/arm/mach-pxa/balloon3.c                     |    8 -
 arch/arm/mach-pxa/irq.c                          |   18 ++-
 arch/arm/mach-pxa/lpd270.c                       |    6 -
 arch/arm/mach-pxa/lubbock.c                      |    6 -
 arch/arm/mach-pxa/mainstone.c                    |    6 -
 arch/arm/mach-pxa/pcm990-baseboard.c             |    6 -
 arch/arm/mach-pxa/pxa3xx.c                       |    9 +
 arch/arm/mach-pxa/viper.c                        |    9 +
 arch/arm/mach-pxa/zeus.c                         |   11 +-
 arch/arm/mach-rpc/irq.c                          |   27 +++-
 arch/arm/mach-s3c2410/bast-irq.c                 |   20 +--
 arch/arm/mach-s3c2412/irq.c                      |   35 +++---
 arch/arm/mach-s3c2440/irq.c                      |   15 +-
 arch/arm/mach-s3c2443/irq.c                      |   71 +++++++------
 arch/arm/mach-sa1100/irq.c                       |   36 ++++--
 arch/arm/mach-sa1100/neponset.c                  |    8 -
 arch/arm/mach-shark/irq.c                        |   10 +
 arch/arm/mach-stmp378x/stmp378x.c                |    9 +
 arch/arm/mach-stmp37xx/stmp37xx.c                |    9 +
 arch/arm/mach-versatile/core.c                   |    6 -
 arch/arm/mach-w90x900/irq.c                      |    8 -
 arch/arm/oprofile/op_model_mpcore.c              |    4 
 arch/arm/plat-mxc/gpio.c                         |   12 +-
 arch/arm/plat-mxc/irq.c                          |    6 -
 arch/arm/plat-omap/gpio.c                        |   36 ++++--
 arch/arm/plat-orion/gpio.c                       |   21 ++-
 arch/arm/plat-orion/irq.c                        |   10 +
 arch/arm/plat-pxa/gpio.c                         |   12 +-
 arch/arm/plat-s3c24xx/irq.c                      |  112 ++++++++++++--------
 arch/arm/plat-s3c24xx/s3c244x-irq.c              |   15 +-
 arch/arm/plat-s3c64xx/irq-eint.c                 |   19 ++-
 arch/arm/plat-s3c64xx/irq.c                      |   21 ++-
 arch/arm/plat-s5pc1xx/irq-eint.c                 |   42 ++++---
 arch/arm/plat-s5pc1xx/irq-gpio.c                 |   18 ++-
 arch/arm/plat-s5pc1xx/irq.c                      |   21 ++-
 arch/arm/plat-stmp3xxx/irq.c                     |    2 
 arch/arm/plat-stmp3xxx/pinmux.c                  |   12 +-
 arch/avr32/mach-at32ap/extint.c                  |   26 ++--
 arch/avr32/mach-at32ap/pio.c                     |    9 +
 arch/blackfin/include/asm/ipipe.h                |    4 
 arch/blackfin/mach-common/ints-priority.c        |   53 ++++++---
 arch/blackfin/mach-common/smp.c                  |    2 
 arch/cris/arch-v10/kernel/irq.c                  |   16 +-
 arch/frv/kernel/irq-mb93091.c                    |   12 +-
 arch/frv/kernel/irq-mb93093.c                    |   12 +-
 arch/frv/kernel/irq-mb93493.c                    |    8 -
 arch/frv/kernel/irq.c                            |   27 ++--
 arch/h8300/kernel/irq.c                          |   14 +-
 arch/ia64/hp/sim/hpsim_irq.c                     |    6 -
 arch/ia64/kernel/iosapic.c                       |   45 ++++----
 arch/ia64/kernel/irq.c                           |    6 -
 arch/ia64/kernel/irq_lsapic.c                    |    8 -
 arch/ia64/kernel/msi_ia64.c                      |   18 ++-
 arch/ia64/kernel/smpboot.c                       |    6 -
 arch/ia64/sn/kernel/irq.c                        |   25 ++--
 arch/ia64/sn/kernel/msi_sn.c                     |   10 +
 arch/m32r/platforms/m32104ut/setup.c             |   19 ++-
 arch/m32r/platforms/m32700ut/setup.c             |   92 +++++++++-------
 arch/m32r/platforms/mappi/setup.c                |   21 ++-
 arch/m32r/platforms/mappi2/setup.c               |   21 ++-
 arch/m32r/platforms/mappi3/setup.c               |   21 ++-
 arch/m32r/platforms/oaks32r/setup.c              |   21 ++-
 arch/m32r/platforms/opsput/setup.c               |   88 +++++++++-------
 arch/m32r/platforms/usrv/setup.c                 |   42 ++++---
 arch/m68knommu/platform/5249/intc2.c             |    9 +
 arch/m68knommu/platform/5272/intc.c              |   11 +-
 arch/m68knommu/platform/68328/ints.c             |    6 -
 arch/m68knommu/platform/68360/ints.c             |    9 +
 arch/m68knommu/platform/coldfire/intc-2.c        |    6 -
 arch/m68knommu/platform/coldfire/intc-simr.c     |    7 -
 arch/m68knommu/platform/coldfire/intc.c          |    8 -
 arch/microblaze/kernel/intc.c                    |   15 +-
 arch/mips/alchemy/common/irq.c                   |   43 ++++---
 arch/mips/alchemy/devboards/pb1200/irqmap.c      |   23 ++--
 arch/mips/ar7/irq.c                              |   18 ++-
 arch/mips/bcm63xx/irq.c                          |   42 ++++---
 arch/mips/cavium-octeon/octeon-irq.c             |   70 ++++++++----
 arch/mips/dec/ioasic-irq.c                       |   21 ++-
 arch/mips/dec/kn02-irq.c                         |   10 +
 arch/mips/emma/markeins/irq.c                    |   20 ++-
 arch/mips/jazz/irq.c                             |    6 -
 arch/mips/kernel/i8259.c                         |   15 +-
 arch/mips/kernel/irq-gic.c                       |   17 ++-
 arch/mips/kernel/irq-gt641xx.c                   |   11 +-
 arch/mips/kernel/irq-msc01.c                     |   22 ++--
 arch/mips/kernel/irq-rm7000.c                    |    6 -
 arch/mips/kernel/irq-rm9000.c                    |   24 ++--
 arch/mips/kernel/irq_cpu.c                       |   14 +-
 arch/mips/kernel/irq_txx9.c                      |   14 +-
 arch/mips/lasat/interrupt.c                      |   14 +-
 arch/mips/loongson/common/bonito-irq.c           |    6 -
 arch/mips/nxp/pnx833x/common/interrupts.c        |   33 +++---
 arch/mips/nxp/pnx8550/common/int.c               |   10 +
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c       |   10 +
 arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c       |    9 +
 arch/mips/powertv/asic/irq_asic.c                |    6 -
 arch/mips/rb532/irq.c                            |   32 +++--
 arch/mips/sgi-ip22/ip22-int.c                    |   24 ++--
 arch/mips/sgi-ip27/ip27-irq.c                    |   12 +-
 arch/mips/sgi-ip27/ip27-timer.c                  |    4 
 arch/mips/sgi-ip32/ip32-irq.c                    |   68 +++++++-----
 arch/mips/sibyte/bcm1480/irq.c                   |   28 ++---
 arch/mips/sibyte/sb1250/irq.c                    |   28 ++---
 arch/mips/sni/a20r.c                             |   12 +-
 arch/mips/sni/pcimt.c                            |   14 +-
 arch/mips/sni/pcit.c                             |   12 +-
 arch/mips/sni/rm200.c                            |   21 ++-
 arch/mips/txx9/generic/irq_tx4939.c              |   14 +-
 arch/mips/txx9/jmr3927/irq.c                     |    6 -
 arch/mips/txx9/rbtx4927/irq.c                    |   10 +
 arch/mips/txx9/rbtx4938/irq.c                    |   10 +
 arch/mips/txx9/rbtx4939/irq.c                    |    6 -
 arch/mips/vr41xx/common/icu.c                    |   12 +-
 arch/mips/vr41xx/common/irq.c                    |    8 -
 arch/mn10300/kernel/irq.c                        |   19 ++-
 arch/mn10300/kernel/mn10300-serial.c             |    5 
 arch/parisc/include/asm/irq.h                    |    4 
 arch/parisc/kernel/irq.c                         |   31 +++--
 arch/powerpc/include/asm/mpic.h                  |    6 -
 arch/powerpc/include/asm/qe_ic.h                 |    6 -
 arch/powerpc/kernel/crash.c                      |    4 
 arch/powerpc/kernel/irq.c                        |    2 
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    6 -
 arch/powerpc/platforms/52xx/media5200.c          |   16 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   35 ++++--
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    6 -
 arch/powerpc/platforms/85xx/ksi8560.c            |    2 
 arch/powerpc/platforms/85xx/mpc85xx_ads.c        |    2 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c         |    2 
 arch/powerpc/platforms/85xx/sbc8560.c            |    2 
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   20 ++-
 arch/powerpc/platforms/85xx/stx_gp3.c            |    2 
 arch/powerpc/platforms/85xx/tqm85xx.c            |    2 
 arch/powerpc/platforms/86xx/gef_pic.c            |   11 +-
 arch/powerpc/platforms/86xx/pic.c                |    2 
 arch/powerpc/platforms/8xx/m8xx_setup.c          |    4 
 arch/powerpc/platforms/cell/axon_msi.c           |    9 +
 arch/powerpc/platforms/cell/beat_interrupt.c     |   12 +-
 arch/powerpc/platforms/cell/interrupt.c          |   12 +-
 arch/powerpc/platforms/cell/setup.c              |    2 
 arch/powerpc/platforms/cell/spider-pic.c         |   15 +-
 arch/powerpc/platforms/chrp/setup.c              |    2 
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |   12 +-
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |   26 ++--
 arch/powerpc/platforms/iseries/irq.c             |   19 ++-
 arch/powerpc/platforms/powermac/pic.c            |   20 ++-
 arch/powerpc/platforms/ps3/interrupt.c           |   15 +-
 arch/powerpc/platforms/pseries/setup.c           |    2 
 arch/powerpc/platforms/pseries/xics.c            |   28 +++--
 arch/powerpc/sysdev/cpm1.c                       |    9 +
 arch/powerpc/sysdev/cpm2_pic.c                   |   18 +--
 arch/powerpc/sysdev/fsl_msi.c                    |   12 +-
 arch/powerpc/sysdev/i8259.c                      |   35 +++---
 arch/powerpc/sysdev/ipic.c                       |   15 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                 |   16 +-
 arch/powerpc/sysdev/mpic.c                       |   35 ++++--
 arch/powerpc/sysdev/mpic.h                       |    4 
 arch/powerpc/sysdev/mpic_pasemi_msi.c            |   14 +-
 arch/powerpc/sysdev/mpic_u3msi.c                 |   19 ++-
 arch/powerpc/sysdev/mv64x60_pic.c                |   21 ++-
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |    6 -
 arch/powerpc/sysdev/tsi108_pci.c                 |   14 +-
 arch/powerpc/sysdev/uic.c                        |   36 +++---
 arch/powerpc/sysdev/xilinx_intc.c                |   26 ++--
 arch/score/kernel/irq.c                          |   10 +
 arch/sh/boards/mach-cayman/irq.c                 |   10 +
 arch/sh/boards/mach-dreamcast/irq.c              |    9 +
 arch/sh/boards/mach-landisk/irq.c                |    6 -
 arch/sh/boards/mach-microdev/irq.c               |   19 ++-
 arch/sh/boards/mach-se/7206/irq.c                |    9 +
 arch/sh/boards/mach-se/7343/irq.c                |    6 -
 arch/sh/boards/mach-se/7722/irq.c                |    8 -
 arch/sh/boards/mach-se/7724/irq.c                |    6 -
 arch/sh/boards/mach-systemh/irq.c                |   16 +-
 arch/sh/cchips/hd6446x/hd64461.c                 |   11 +-
 arch/sh/kernel/cpu/irq/imask.c                   |    6 -
 arch/sh/kernel/cpu/irq/intc-sh5.c                |   34 +++---
 arch/sparc/kernel/irq_64.c                       |   62 ++++++-----
 arch/sparc/kernel/pci_msi.c                      |   13 ++
 arch/um/kernel/irq.c                             |    2 
 arch/x86/include/asm/hardirq.h                   |    2 
 arch/x86/include/asm/hpet.h                      |    8 -
 arch/x86/include/asm/i8259.h                     |    2 
 arch/x86/kernel/apic/io_apic.c                   |  125 +++++++++--------------
 arch/x86/kernel/hpet.c                           |   16 +-
 arch/x86/kernel/i8259.c                          |   31 +++--
 arch/x86/kernel/irq.c                            |   12 +-
 arch/x86/kernel/uv_irq.c                         |   12 +-
 arch/x86/kernel/visws_quirks.c                   |   29 ++---
 arch/x86/kernel/vmiclock_32.c                    |    8 -
 arch/x86/lguest/boot.c                           |    8 -
 arch/xtensa/kernel/irq.c                         |   22 ++--
 arch/xtensa/variants/s6000/gpio.c                |   18 ++-
 drivers/dma/ipu/ipu_irq.c                        |   18 +--
 drivers/gpio/langwell_gpio.c                     |   11 +-
 drivers/gpio/pl061.c                             |   19 ++-
 drivers/gpio/timbgpio.c                          |   17 +--
 drivers/gpio/vr41xx_giu.c                        |   32 ++---
 drivers/mfd/asic3.c                              |   27 ++--
 drivers/mfd/ezx-pcap.c                           |   12 +-
 drivers/mfd/htc-egpio.c                          |   12 +-
 drivers/mfd/t7l66xb.c                            |    8 -
 drivers/mfd/tc6393xb.c                           |   15 +-
 drivers/mfd/twl4030-irq.c                        |   16 +-
 drivers/mfd/wm831x-irq.c                         |   18 +--
 drivers/misc/sgi-gru/grufile.c                   |    2 
 drivers/parisc/dino.c                            |   12 +-
 drivers/parisc/eisa.c                            |   10 +
 drivers/parisc/gsc.c                             |   12 +-
 drivers/parisc/iosapic.c                         |   16 +-
 drivers/parisc/superio.c                         |   10 +
 drivers/pci/dmar.c                               |   16 +-
 drivers/pci/htirq.c                              |   22 ++--
 drivers/pci/msi.c                                |   13 +-
 drivers/vlynq/vlynq.c                            |   23 ++--
 drivers/xen/events.c                             |   38 ++++--
 include/linux/dmar.h                             |    8 -
 include/linux/htirq.h                            |   11 +-
 include/linux/irq.h                              |   47 ++++----
 include/linux/msi.h                              |    4 
 kernel/irq/autoprobe.c                           |   12 +-
 kernel/irq/chip.c                                |   60 ++++-------
 kernel/irq/handle.c                              |   24 ++--
 kernel/irq/internals.h                           |   16 +-
 kernel/irq/manage.c                              |   65 +++++------
 kernel/irq/migration.c                           |   16 +-
 kernel/irq/pm.c                                  |    4 
 kernel/irq/resend.c                              |    8 -
 kernel/irq/spurious.c                            |    4 
 302 files changed, 3131 insertions(+), 2194 deletions(-)

Index: linux-2.6/Documentation/DocBook/genericirq.tmpl
===================================================================
--- linux-2.6.orig/Documentation/DocBook/genericirq.tmpl
+++ linux-2.6/Documentation/DocBook/genericirq.tmpl
@@ -233,33 +233,33 @@
 		are used by the default flow implementations.
 		The following helper functions are implemented (simplified excerpt):
 		<programlisting>
-default_enable(irq)
+default_enable(desc)
 {
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
-default_disable(irq)
+default_disable(desc)
 {
-	if (!delay_disable(irq))
-		desc->chip->mask(irq);
+	if (!delay_disable(desc->irq))
+		desc->chip->mask(desc);
 }
 
-default_ack(irq)
+default_ack(desc)
 {
-	chip->ack(irq);
+	chip->ack(desc);
 }
 
-default_mask_ack(irq)
+default_mask_ack(desc)
 {
 	if (chip->mask_ack) {
-		chip->mask_ack(irq);
+		chip->mask_ack(desc);
 	} else {
-		chip->mask(irq);
-		chip->ack(irq);
+		chip->mask(desc);
+		chip->ack(desc);
 	}
 }
 
-noop(irq)
+noop(desc)
 {
 }
 
Index: linux-2.6/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq.c
+++ linux-2.6/arch/alpha/kernel/irq.c
@@ -46,8 +46,9 @@ int irq_select_affinity(unsigned int irq
 {
 	static int last_cpu;
 	int cpu = last_cpu + 1;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (!irq_desc[irq].chip->set_affinity || irq_user_affinity[irq])
+	if (!desc->chip->set_affinity || irq_user_affinity[irq])
 		return 1;
 
 	while (!cpu_possible(cpu) ||
@@ -55,8 +56,8 @@ int irq_select_affinity(unsigned int irq
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
-	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
-	irq_desc[irq].chip->set_affinity(irq, cpumask_of(cpu));
+	cpumask_copy(desc->affinity, cpumask_of(cpu));
+	desc->chip->set_affinity(irq, cpumask_of(cpu));
 	return 0;
 }
 #endif /* CONFIG_SMP */
Index: linux-2.6/arch/alpha/kernel/irq_alpha.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_alpha.c
+++ linux-2.6/arch/alpha/kernel/irq_alpha.c
@@ -218,8 +218,8 @@ process_mcheck_info(unsigned long vector
  * processed by PALcode, and comes in via entInt vector 1.
  */
 
-static void rtc_enable_disable(unsigned int irq) { }
-static unsigned int rtc_startup(unsigned int irq) { return 0; }
+static void rtc_enable_disable(struct irq_desc *desc) { }
+static unsigned int rtc_startup(struct irq_desc *desc) { return 0; }
 
 struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
Index: linux-2.6/arch/alpha/kernel/irq_i8259.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_i8259.c
+++ linux-2.6/arch/alpha/kernel/irq_i8259.c
@@ -33,8 +33,10 @@ i8259_update_irq_hw(unsigned int irq, un
 }
 
 inline void
-i8259a_enable_irq(unsigned int irq)
+i8259a_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	spin_lock(&i8259_irq_lock);
 	i8259_update_irq_hw(irq, cached_irq_mask &= ~(1 << irq));
 	spin_unlock(&i8259_irq_lock);
@@ -47,16 +49,18 @@ __i8259a_disable_irq(unsigned int irq)
 }
 
 void
-i8259a_disable_irq(unsigned int irq)
+i8259a_disable_irq(struct irq_desc *desc)
 {
 	spin_lock(&i8259_irq_lock);
-	__i8259a_disable_irq(irq);
+	__i8259a_disable_irq(desc->irq);
 	spin_unlock(&i8259_irq_lock);
 }
 
 void
-i8259a_mask_and_ack_irq(unsigned int irq)
+i8259a_mask_and_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	spin_lock(&i8259_irq_lock);
 	__i8259a_disable_irq(irq);
 
@@ -70,17 +74,17 @@ i8259a_mask_and_ack_irq(unsigned int irq
 }
 
 unsigned int
-i8259a_startup_irq(unsigned int irq)
+i8259a_startup_irq(struct irq_desc *desc)
 {
-	i8259a_enable_irq(irq);
+	i8259a_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 void
-i8259a_end_irq(unsigned int irq)
+i8259a_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		i8259a_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		i8259a_enable_irq(desc);
 }
 
 struct irq_chip i8259a_irq_type = {
Index: linux-2.6/arch/alpha/kernel/irq_pyxis.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_pyxis.c
+++ linux-2.6/arch/alpha/kernel/irq_pyxis.c
@@ -29,34 +29,35 @@ pyxis_update_irq_hw(unsigned long mask)
 }
 
 static inline void
-pyxis_enable_irq(unsigned int irq)
+pyxis_enable_irq(struct irq_desc *desc)
 {
-	pyxis_update_irq_hw(cached_irq_mask |= 1UL << (irq - 16));
+	pyxis_update_irq_hw(cached_irq_mask |= 1UL << (desc->irq - 16));
 }
 
 static void
-pyxis_disable_irq(unsigned int irq)
+pyxis_disable_irq(struct irq_desc *desc)
 {
-	pyxis_update_irq_hw(cached_irq_mask &= ~(1UL << (irq - 16)));
+	pyxis_update_irq_hw(cached_irq_mask &= ~(1UL << (desc->irq - 16)));
 }
 
 static unsigned int
-pyxis_startup_irq(unsigned int irq)
+pyxis_startup_irq(struct irq_desc *desc)
 {
-	pyxis_enable_irq(irq);
+	pyxis_enable_irq(desc);
 	return 0;
 }
 
 static void
-pyxis_end_irq(unsigned int irq)
+pyxis_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		pyxis_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		pyxis_enable_irq(desc);
 }
 
 static void
-pyxis_mask_and_ack_irq(unsigned int irq)
+pyxis_mask_and_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long bit = 1UL << (irq - 16);
 	unsigned long mask = cached_irq_mask &= ~bit;
 
Index: linux-2.6/arch/alpha/kernel/irq_srm.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_srm.c
+++ linux-2.6/arch/alpha/kernel/irq_srm.c
@@ -18,33 +18,33 @@
 DEFINE_SPINLOCK(srm_irq_lock);
 
 static inline void
-srm_enable_irq(unsigned int irq)
+srm_enable_irq(struct irq_desc *desc)
 {
 	spin_lock(&srm_irq_lock);
-	cserve_ena(irq - 16);
+	cserve_ena(desc->irq - 16);
 	spin_unlock(&srm_irq_lock);
 }
 
 static void
-srm_disable_irq(unsigned int irq)
+srm_disable_irq(struct irq_desc *desc)
 {
 	spin_lock(&srm_irq_lock);
-	cserve_dis(irq - 16);
+	cserve_dis(desc->irq - 16);
 	spin_unlock(&srm_irq_lock);
 }
 
 static unsigned int
-srm_startup_irq(unsigned int irq)
+srm_startup_irq(struct irq_desc *desc)
 {
-	srm_enable_irq(irq);
+	srm_enable_irq(desc);
 	return 0;
 }
 
 static void
-srm_end_irq(unsigned int irq)
+srm_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		srm_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		srm_enable_irq(desc);
 }
 
 /* Handle interrupts from the SRM, assuming no additional weirdness.  */
Index: linux-2.6/arch/alpha/kernel/sys_alcor.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_alcor.c
+++ linux-2.6/arch/alpha/kernel/sys_alcor.c
@@ -44,38 +44,38 @@ alcor_update_irq_hw(unsigned long mask)
 }
 
 static inline void
-alcor_enable_irq(unsigned int irq)
+alcor_enable_irq(struct irq_desc *desc)
 {
-	alcor_update_irq_hw(cached_irq_mask |= 1UL << (irq - 16));
+	alcor_update_irq_hw(cached_irq_mask |= 1UL << (desc->irq - 16));
 }
 
 static void
-alcor_disable_irq(unsigned int irq)
+alcor_disable_irq(struct irq_desc *desc)
 {
-	alcor_update_irq_hw(cached_irq_mask &= ~(1UL << (irq - 16)));
+	alcor_update_irq_hw(cached_irq_mask &= ~(1UL << (desc->irq - 16)));
 }
 
 static void
-alcor_mask_and_ack_irq(unsigned int irq)
+alcor_mask_and_ack_irq(struct irq_desc *desc)
 {
-	alcor_disable_irq(irq);
+	alcor_disable_irq(desc);
 
 	/* On ALCOR/XLT, need to dismiss interrupt via GRU. */
-	*(vuip)GRU_INT_CLEAR = 1 << (irq - 16); mb();
+	*(vuip)GRU_INT_CLEAR = 1 << (desc->irq - 16); mb();
 	*(vuip)GRU_INT_CLEAR = 0; mb();
 }
 
 static unsigned int
-alcor_startup_irq(unsigned int irq)
+alcor_startup_irq(struct irq_desc *desc)
 {
-	alcor_enable_irq(irq);
+	alcor_enable_irq(desc);
 	return 0;
 }
 
 static void
-alcor_isa_mask_and_ack_irq(unsigned int irq)
+alcor_isa_mask_and_ack_irq(struct irq_desc *desc)
 {
-	i8259a_mask_and_ack_irq(irq);
+	i8259a_mask_and_ack_irq(desc);
 
 	/* On ALCOR/XLT, need to dismiss interrupt via GRU. */
 	*(vuip)GRU_INT_CLEAR = 0x80000000; mb();
@@ -83,10 +83,10 @@ alcor_isa_mask_and_ack_irq(unsigned int
 }
 
 static void
-alcor_end_irq(unsigned int irq)
+alcor_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		alcor_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		alcor_enable_irq(desc);
 }
 
 static struct irq_chip alcor_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_cabriolet.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_cabriolet.c
+++ linux-2.6/arch/alpha/kernel/sys_cabriolet.c
@@ -46,29 +46,33 @@ cabriolet_update_irq_hw(unsigned int irq
 }
 
 static inline void
-cabriolet_enable_irq(unsigned int irq)
+cabriolet_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	cabriolet_update_irq_hw(irq, cached_irq_mask &= ~(1UL << irq));
 }
 
 static void
-cabriolet_disable_irq(unsigned int irq)
+cabriolet_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	cabriolet_update_irq_hw(irq, cached_irq_mask |= 1UL << irq);
 }
 
 static unsigned int
-cabriolet_startup_irq(unsigned int irq)
+cabriolet_startup_irq(struct irq_desc *desc)
 { 
-	cabriolet_enable_irq(irq);
+	cabriolet_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 static void
-cabriolet_end_irq(unsigned int irq)
+cabriolet_end_irq(struct irq_desc *desc)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		cabriolet_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		cabriolet_enable_irq(desc);
 }
 
 static struct irq_chip cabriolet_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_dp264.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_dp264.c
+++ linux-2.6/arch/alpha/kernel/sys_dp264.c
@@ -98,67 +98,73 @@ tsunami_update_irq_hw(unsigned long mask
 }
 
 static void
-dp264_enable_irq(unsigned int irq)
+dp264_enable_irq(struct irq_desc *desc)
 {
 	spin_lock(&dp264_irq_lock);
-	cached_irq_mask |= 1UL << irq;
+	cached_irq_mask |= 1UL << desc->irq;
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 }
 
 static void
-dp264_disable_irq(unsigned int irq)
+dp264_disable_irq(struct irq_desc *desc)
 {
 	spin_lock(&dp264_irq_lock);
-	cached_irq_mask &= ~(1UL << irq);
+	cached_irq_mask &= ~(1UL << desc->irq);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 }
 
 static unsigned int
-dp264_startup_irq(unsigned int irq)
+dp264_startup_irq(struct irq_desc *desc)
 { 
-	dp264_enable_irq(irq);
+	dp264_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 static void
-dp264_end_irq(unsigned int irq)
+dp264_end_irq(struct irq_desc *desc)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		dp264_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		dp264_enable_irq(desc);
 }
 
 static void
-clipper_enable_irq(unsigned int irq)
+clipper_enable_irq(struct irq_desc *desc)
 {
 	spin_lock(&dp264_irq_lock);
-	cached_irq_mask |= 1UL << (irq - 16);
+	cached_irq_mask |= 1UL << (desc->irq - 16);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 }
 
 static void
-clipper_disable_irq(unsigned int irq)
+clipper_disable_irq(struct irq_desc *desc)
 {
 	spin_lock(&dp264_irq_lock);
-	cached_irq_mask &= ~(1UL << (irq - 16));
+	cached_irq_mask &= ~(1UL << (desc->irq - 16));
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 }
 
+static void
+clipper_disable_irq_desc(struct irq_desc *desc)
+{
+	clipper_disable_irq(desc);
+}
+
 static unsigned int
-clipper_startup_irq(unsigned int irq)
+clipper_startup_irq(struct irq_desc *desc)
 { 
-	clipper_enable_irq(irq);
+	clipper_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 static void
-clipper_end_irq(unsigned int irq)
+clipper_end_irq(struct irq_desc *desc)
 { 
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		clipper_enable_irq(irq);
+	if (!(irq_desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		clipper_enable_irq(desc);
 }
 
 static void
@@ -177,10 +183,10 @@ cpu_set_irq_affinity(unsigned int irq, c
 }
 
 static int
-dp264_set_affinity(unsigned int irq, const struct cpumask *affinity)
+dp264_set_affinity(struct irq_desc *desc, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
-	cpu_set_irq_affinity(irq, *affinity);
+	cpu_set_irq_affinity(desc->irq, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 
@@ -188,10 +194,10 @@ dp264_set_affinity(unsigned int irq, con
 }
 
 static int
-clipper_set_affinity(unsigned int irq, const struct cpumask *affinity)
+clipper_set_affinity(struct irq_desc, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
-	cpu_set_irq_affinity(irq - 16, *affinity);
+	cpu_set_irq_affinity(desc->irq - 16, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
 
Index: linux-2.6/arch/alpha/kernel/sys_eb64p.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eb64p.c
+++ linux-2.6/arch/alpha/kernel/sys_eb64p.c
@@ -44,29 +44,33 @@ eb64p_update_irq_hw(unsigned int irq, un
 }
 
 static inline void
-eb64p_enable_irq(unsigned int irq)
+eb64p_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	eb64p_update_irq_hw(irq, cached_irq_mask &= ~(1 << irq));
 }
 
 static void
-eb64p_disable_irq(unsigned int irq)
+eb64p_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	eb64p_update_irq_hw(irq, cached_irq_mask |= 1 << irq);
 }
 
 static unsigned int
-eb64p_startup_irq(unsigned int irq)
+eb64p_startup_irq(struct irq_desc *desc)
 {
-	eb64p_enable_irq(irq);
+	eb64p_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 static void
-eb64p_end_irq(unsigned int irq)
+eb64p_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		eb64p_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		eb64p_enable_irq(desc);
 }
 
 static struct irq_chip eb64p_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_eiger.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eiger.c
+++ linux-2.6/arch/alpha/kernel/sys_eiger.c
@@ -51,33 +51,37 @@ eiger_update_irq_hw(unsigned long irq, u
 }
 
 static inline void
-eiger_enable_irq(unsigned int irq)
+eiger_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
+
 	mask = (cached_irq_mask[irq >= 64] &= ~(1UL << (irq & 63)));
 	eiger_update_irq_hw(irq, mask);
 }
 
 static void
-eiger_disable_irq(unsigned int irq)
+eiger_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
+
 	mask = (cached_irq_mask[irq >= 64] |= 1UL << (irq & 63));
 	eiger_update_irq_hw(irq, mask);
 }
 
 static unsigned int
-eiger_startup_irq(unsigned int irq)
+eiger_startup_irq(struct irq_desc *desc)
 {
-	eiger_enable_irq(irq);
+	eiger_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 static void
-eiger_end_irq(unsigned int irq)
+eiger_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		eiger_enable_irq(irq);
+	if (!(irq_desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		eiger_enable_irq(desc);
 }
 
 static struct irq_chip eiger_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_jensen.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_jensen.c
+++ linux-2.6/arch/alpha/kernel/sys_jensen.c
@@ -63,59 +63,59 @@
  */
 
 static unsigned int
-jensen_local_startup(unsigned int irq)
+jensen_local_startup(struct irq_desc *desc)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_startup_irq(1);
+	if (desc->irq == 7)
+		i8259a_startup_irq(irq_to_desc(1));
 	else
 		/*
 		 * For all true local interrupts, set the flag that prevents
 		 * the IPL from being dropped during handler processing.
 		 */
-		if (irq_desc[irq].action)
-			irq_desc[irq].action->flags |= IRQF_DISABLED;
+		if (desc->action)
+			desc->action->flags |= IRQF_DISABLED;
 	return 0;
 }
 
 static void
-jensen_local_shutdown(unsigned int irq)
+jensen_local_shutdown(struct irq_desc *desc)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_disable_irq(1);
+	if (desc->irq == 7)
+		i8259a_disable_irq(irq_to_desc(1));
 }
 
 static void
-jensen_local_enable(unsigned int irq)
+jensen_local_enable(struct irq_desc *desc)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_enable_irq(1);
+	if (desc->irq == 7)
+		i8259a_enable_irq(irq_to_desc(1));
 }
 
 static void
-jensen_local_disable(unsigned int irq)
+jensen_local_disable(struct irq_desc *desc)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_disable_irq(1);
+	if (desc->irq == 7)
+		i8259a_disable_irq(irq_to_desc(1));
 }
 
 static void
-jensen_local_ack(unsigned int irq)
+jensen_local_ack(struct irq_desc *desc)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_mask_and_ack_irq(1);
+	if (desc->irq == 7)
+		i8259a_mask_and_ack_irq(irq_to_desc(1));
 }
 
 static void
-jensen_local_end(unsigned int irq)
+jensen_local_end(struct irq_desc *desc)
 {
 	/* the parport is really hw IRQ 1, silly Jensen.  */
-	if (irq == 7)
-		i8259a_end_irq(1);
+	if (desc->irq == 7)
+		i8259a_end_irq(irq_to_desc(1));
 }
 
 static struct irq_chip jensen_local_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_marvel.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_marvel.c
+++ linux-2.6/arch/alpha/kernel/sys_marvel.c
@@ -104,15 +104,15 @@ io7_get_irq_ctl(unsigned int irq, struct
 }
 
 static void
-io7_enable_irq(unsigned int irq)
+io7_enable_irq(struct irq_desc *desc)
 {
 	volatile unsigned long *ctl;
 	struct io7 *io7;
 
-	ctl = io7_get_irq_ctl(irq, &io7);
+	ctl = io7_get_irq_ctl(desc->irq, &io7);
 	if (!ctl || !io7) {
 		printk(KERN_ERR "%s: get_ctl failed for irq %x\n",
-		       __func__, irq);
+		       __func__, desc->irq);
 		return;
 	}
 		
@@ -124,15 +124,15 @@ io7_enable_irq(unsigned int irq)
 }
 
 static void
-io7_disable_irq(unsigned int irq)
+io7_disable_irq(struct irq_desc *desc)
 {
 	volatile unsigned long *ctl;
 	struct io7 *io7;
 
-	ctl = io7_get_irq_ctl(irq, &io7);
+	ctl = io7_get_irq_ctl(desc->irq, &io7);
 	if (!ctl || !io7) {
 		printk(KERN_ERR "%s: get_ctl failed for irq %x\n",
-		       __func__, irq);
+		       __func__, desc->irq);
 		return;
 	}
 		
@@ -144,27 +144,27 @@ io7_disable_irq(unsigned int irq)
 }
 
 static unsigned int
-io7_startup_irq(unsigned int irq)
+io7_startup_irq(struct irq_desc *desc)
 {
-	io7_enable_irq(irq);
+	io7_enable_irq(desc);
 	return 0;	/* never anything pending */
 }
 
 static void
-io7_end_irq(unsigned int irq)
+io7_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		io7_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		io7_enable_irq(desc);
 }
 
 static void
-marvel_irq_noop(unsigned int irq) 
+marvel_irq_noop(struct irq_desc *desc)
 { 
 	return; 
 }
 
 static unsigned int
-marvel_irq_noop_return(unsigned int irq) 
+marvel_irq_noop_return(struct irq_desc *desc)
 { 
 	return 0; 
 }
Index: linux-2.6/arch/alpha/kernel/sys_mikasa.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_mikasa.c
+++ linux-2.6/arch/alpha/kernel/sys_mikasa.c
@@ -43,29 +43,29 @@ mikasa_update_irq_hw(int mask)
 }
 
 static inline void
-mikasa_enable_irq(unsigned int irq)
+mikasa_enable_irq(struct irq_desc *desc)
 {
-	mikasa_update_irq_hw(cached_irq_mask |= 1 << (irq - 16));
+	mikasa_update_irq_hw(cached_irq_mask |= 1 << (desc->irq - 16));
 }
 
 static void
-mikasa_disable_irq(unsigned int irq)
+mikasa_disable_irq(struct irq_desc *desc)
 {
-	mikasa_update_irq_hw(cached_irq_mask &= ~(1 << (irq - 16)));
+	mikasa_update_irq_hw(cached_irq_mask &= ~(1 << (desc->irq - 16)));
 }
 
 static unsigned int
-mikasa_startup_irq(unsigned int irq)
+mikasa_startup_irq(struct irq_desc *desc)
 {
-	mikasa_enable_irq(irq);
+	mikasa_enable_irq(desc);
 	return 0;
 }
 
 static void
-mikasa_end_irq(unsigned int irq)
+mikasa_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		mikasa_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		mikasa_enable_irq(desc);
 }
 
 static struct irq_chip mikasa_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_noritake.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_noritake.c
+++ linux-2.6/arch/alpha/kernel/sys_noritake.c
@@ -48,29 +48,33 @@ noritake_update_irq_hw(int irq, int mask
 }
 
 static void
-noritake_enable_irq(unsigned int irq)
+noritake_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	noritake_update_irq_hw(irq, cached_irq_mask |= 1 << (irq - 16));
 }
 
 static void
-noritake_disable_irq(unsigned int irq)
+noritake_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	noritake_update_irq_hw(irq, cached_irq_mask &= ~(1 << (irq - 16)));
 }
 
 static unsigned int
-noritake_startup_irq(unsigned int irq)
+noritake_startup_irq(struct irq_desc *desc)
 {
-	noritake_enable_irq(irq);
+	noritake_enable_irq(desc);
 	return 0;
 }
 
 static void
-noritake_end_irq(unsigned int irq)
+noritake_end_irq(struct irq_desc *desc)
 {
-        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-                noritake_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		noritake_enable_irq(desc);
 }
 
 static struct irq_chip noritake_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_rawhide.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rawhide.c
+++ linux-2.6/arch/alpha/kernel/sys_rawhide.c
@@ -56,8 +56,9 @@ rawhide_update_irq_hw(int hose, int mask
   (((h) < MCPCIA_MAX_HOSES) && (cached_irq_masks[(h)] != 0))
 
 static inline void 
-rawhide_enable_irq(unsigned int irq)
+rawhide_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask, hose;
 
 	irq -= 16;
@@ -76,8 +77,9 @@ rawhide_enable_irq(unsigned int irq)
 }
 
 static void 
-rawhide_disable_irq(unsigned int irq)
+rawhide_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask, hose;
 
 	irq -= 16;
@@ -96,8 +98,9 @@ rawhide_disable_irq(unsigned int irq)
 }
 
 static void
-rawhide_mask_and_ack_irq(unsigned int irq)
+rawhide_mask_and_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask, mask1, hose;
 
 	irq -= 16;
@@ -122,17 +125,17 @@ rawhide_mask_and_ack_irq(unsigned int ir
 }
 
 static unsigned int
-rawhide_startup_irq(unsigned int irq)
+rawhide_startup_irq(struct irq_desc *desc)
 {
-	rawhide_enable_irq(irq);
+	rawhide_enable_irq(desc);
 	return 0;
 }
 
 static void
-rawhide_end_irq(unsigned int irq)
+rawhide_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		rawhide_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		rawhide_enable_irq(desc);
 }
 
 static struct irq_chip rawhide_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_rx164.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rx164.c
+++ linux-2.6/arch/alpha/kernel/sys_rx164.c
@@ -47,29 +47,29 @@ rx164_update_irq_hw(unsigned long mask)
 }
 
 static inline void
-rx164_enable_irq(unsigned int irq)
+rx164_enable_irq(struct irq_desc *desc)
 {
-	rx164_update_irq_hw(cached_irq_mask |= 1UL << (irq - 16));
+	rx164_update_irq_hw(cached_irq_mask |= 1UL << (desc->irq - 16));
 }
 
 static void
-rx164_disable_irq(unsigned int irq)
+rx164_disable_irq(struct irq_desc *desc)
 {
-	rx164_update_irq_hw(cached_irq_mask &= ~(1UL << (irq - 16)));
+	rx164_update_irq_hw(cached_irq_mask &= ~(1UL << (desc->irq - 16)));
 }
 
 static unsigned int
-rx164_startup_irq(unsigned int irq)
+rx164_startup_irq(struct irq_desc *desc)
 {
-	rx164_enable_irq(irq);
+	rx164_enable_irq(desc);
 	return 0;
 }
 
 static void
-rx164_end_irq(unsigned int irq)
+rx164_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		rx164_enable_irq(irq);
+	if (!(desc_.status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		rx164_enable_irq(desc);
 }
 
 static struct irq_chip rx164_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_sable.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_sable.c
+++ linux-2.6/arch/alpha/kernel/sys_sable.c
@@ -443,57 +443,57 @@ lynx_swizzle(struct pci_dev *dev, u8 *pi
 /* GENERIC irq routines */
 
 static inline void
-sable_lynx_enable_irq(unsigned int irq)
+sable_lynx_enable_irq(struct irq_desc *desc)
 {
 	unsigned long bit, mask;
 
-	bit = sable_lynx_irq_swizzle->irq_to_mask[irq];
+	bit = sable_lynx_irq_swizzle->irq_to_mask[desc->irq];
 	spin_lock(&sable_lynx_irq_lock);
 	mask = sable_lynx_irq_swizzle->shadow_mask &= ~(1UL << bit);
 	sable_lynx_irq_swizzle->update_irq_hw(bit, mask);
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
 	printk("%s: mask 0x%lx bit 0x%lx irq 0x%x\n",
-	       __func__, mask, bit, irq);
+	       __func__, mask, bit, desc->irq);
 #endif
 }
 
 static void
-sable_lynx_disable_irq(unsigned int irq)
+sable_lynx_disable_irq(struct irq_desc *desc)
 {
 	unsigned long bit, mask;
 
-	bit = sable_lynx_irq_swizzle->irq_to_mask[irq];
+	bit = sable_lynx_irq_swizzle->irq_to_mask[desc->irq];
 	spin_lock(&sable_lynx_irq_lock);
 	mask = sable_lynx_irq_swizzle->shadow_mask |= 1UL << bit;
 	sable_lynx_irq_swizzle->update_irq_hw(bit, mask);
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
 	printk("%s: mask 0x%lx bit 0x%lx irq 0x%x\n",
-	       __func__, mask, bit, irq);
+	       __func__, mask, bit, desc->irq);
 #endif
 }
 
 static unsigned int
-sable_lynx_startup_irq(unsigned int irq)
+sable_lynx_startup_irq(struct irq_desc *desc)
 {
-	sable_lynx_enable_irq(irq);
+	sable_lynx_enable_irq(desc);
 	return 0;
 }
 
 static void
-sable_lynx_end_irq(unsigned int irq)
+sable_lynx_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		sable_lynx_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		sable_lynx_enable_irq(desc);
 }
 
 static void
-sable_lynx_mask_and_ack_irq(unsigned int irq)
+sable_lynx_mask_and_ack_irq(struct irq_desc *desc)
 {
 	unsigned long bit, mask;
 
-	bit = sable_lynx_irq_swizzle->irq_to_mask[irq];
+	bit = sable_lynx_irq_swizzle->irq_to_mask[desc->irq];
 	spin_lock(&sable_lynx_irq_lock);
 	mask = sable_lynx_irq_swizzle->shadow_mask |= 1UL << bit;
 	sable_lynx_irq_swizzle->update_irq_hw(bit, mask);
Index: linux-2.6/arch/alpha/kernel/sys_takara.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_takara.c
+++ linux-2.6/arch/alpha/kernel/sys_takara.c
@@ -45,33 +45,37 @@ takara_update_irq_hw(unsigned long irq,
 }
 
 static inline void
-takara_enable_irq(unsigned int irq)
+takara_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
+
 	mask = (cached_irq_mask[irq >= 64] &= ~(1UL << (irq & 63)));
 	takara_update_irq_hw(irq, mask);
 }
 
 static void
-takara_disable_irq(unsigned int irq)
+takara_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
+
 	mask = (cached_irq_mask[irq >= 64] |= 1UL << (irq & 63));
 	takara_update_irq_hw(irq, mask);
 }
 
 static unsigned int
-takara_startup_irq(unsigned int irq)
+takara_startup_irq(struct irq_desc *desc)
 {
-	takara_enable_irq(irq);
+	takara_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 static void
-takara_end_irq(unsigned int irq)
+takara_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		takara_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		takara_enable_irq(desc);
 }
 
 static struct irq_chip takara_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_titan.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_titan.c
+++ linux-2.6/arch/alpha/kernel/sys_titan.c
@@ -112,35 +112,35 @@ titan_update_irq_hw(unsigned long mask)
 }
 
 static inline void
-titan_enable_irq(unsigned int irq)
+titan_enable_irq(struct irq_desc *desc)
 {
 	spin_lock(&titan_irq_lock);
-	titan_cached_irq_mask |= 1UL << (irq - 16);
+	titan_cached_irq_mask |= 1UL << (desc->irq - 16);
 	titan_update_irq_hw(titan_cached_irq_mask);
 	spin_unlock(&titan_irq_lock);
 }
 
 static inline void
-titan_disable_irq(unsigned int irq)
+titan_disable_irq(struct irq_desc *desc)
 {
 	spin_lock(&titan_irq_lock);
-	titan_cached_irq_mask &= ~(1UL << (irq - 16));
+	titan_cached_irq_mask &= ~(1UL << (desc->irq - 16));
 	titan_update_irq_hw(titan_cached_irq_mask);
 	spin_unlock(&titan_irq_lock);
 }
 
 static unsigned int
-titan_startup_irq(unsigned int irq)
+titan_startup_irq(struct irq_desc *desc)
 {
-	titan_enable_irq(irq);
+	titan_enable_irq(desc);
 	return 0;	/* never anything pending */
 }
 
 static void
-titan_end_irq(unsigned int irq)
+titan_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		titan_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		titan_enable_irq(desc);
 }
 
 static void
@@ -158,10 +158,10 @@ titan_cpu_set_irq_affinity(unsigned int
 }
 
 static int
-titan_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
+titan_set_irq_affinity(struct irq_desc *desc, const struct cpumask *affinity)
 { 
 	spin_lock(&titan_irq_lock);
-	titan_cpu_set_irq_affinity(irq - 16, *affinity);
+	titan_cpu_set_irq_affinity(desc->irq - 16, *affinity);
 	titan_update_irq_hw(titan_cached_irq_mask);
 	spin_unlock(&titan_irq_lock);
 
Index: linux-2.6/arch/alpha/kernel/sys_wildfire.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_wildfire.c
+++ linux-2.6/arch/alpha/kernel/sys_wildfire.c
@@ -104,10 +104,12 @@ wildfire_init_irq_hw(void)
 }
 
 static void
-wildfire_enable_irq(unsigned int irq)
+wildfire_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	if (irq < 16)
-		i8259a_enable_irq(irq);
+		i8259a_enable_irq(desc);
 
 	spin_lock(&wildfire_irq_lock);
 	set_bit(irq, &cached_irq_mask);
@@ -116,10 +118,12 @@ wildfire_enable_irq(unsigned int irq)
 }
 
 static void
-wildfire_disable_irq(unsigned int irq)
+wildfire_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	if (irq < 16)
-		i8259a_disable_irq(irq);
+		i8259a_disable_irq(desc);
 
 	spin_lock(&wildfire_irq_lock);
 	clear_bit(irq, &cached_irq_mask);
@@ -128,10 +132,12 @@ wildfire_disable_irq(unsigned int irq)
 }
 
 static void
-wildfire_mask_and_ack_irq(unsigned int irq)
+wildfire_mask_and_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	if (irq < 16)
-		i8259a_mask_and_ack_irq(irq);
+		i8259a_mask_and_ack_irq(desc);
 
 	spin_lock(&wildfire_irq_lock);
 	clear_bit(irq, &cached_irq_mask);
@@ -140,21 +146,21 @@ wildfire_mask_and_ack_irq(unsigned int i
 }
 
 static unsigned int
-wildfire_startup_irq(unsigned int irq)
+wildfire_startup_irq(struct irq_desc *desc)
 { 
-	wildfire_enable_irq(irq);
+	wildfire_enable_irq(desc);
 	return 0; /* never anything pending */
 }
 
 static void
-wildfire_end_irq(unsigned int irq)
+wildfire_end_irq(struct irq_desc *desc)
 { 
 #if 0
-	if (!irq_desc[irq].action)
-		printk("got irq %d\n", irq);
+	if (!desc->action)
+		printk("got irq %d\n", desc->irq);
 #endif
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		wildfire_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		wildfire_enable_irq(desc);
 }
 
 static struct irq_chip wildfire_irq_type = {
Index: linux-2.6/arch/arm/common/gic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/gic.c
+++ linux-2.6/arch/arm/common/gic.c
@@ -80,8 +80,9 @@ static inline unsigned int gic_irq(unsig
  * our "acknowledge" routine disable the interrupt, then mark it as
  * complete.
  */
-static void gic_ack_irq(unsigned int irq)
+static void gic_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask = 1 << (irq % 32);
 
 	spin_lock(&irq_controller_lock);
@@ -90,8 +91,9 @@ static void gic_ack_irq(unsigned int irq
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_mask_irq(unsigned int irq)
+static void gic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask = 1 << (irq % 32);
 
 	spin_lock(&irq_controller_lock);
@@ -99,8 +101,9 @@ static void gic_mask_irq(unsigned int ir
 	spin_unlock(&irq_controller_lock);
 }
 
-static void gic_unmask_irq(unsigned int irq)
+static void gic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask = 1 << (irq % 32);
 
 	spin_lock(&irq_controller_lock);
@@ -109,8 +112,9 @@ static void gic_unmask_irq(unsigned int
 }
 
 #ifdef CONFIG_SMP
-static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
+static int gic_set_cpu(struct irq_desc *desc, const struct cpumask *mask_val)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *reg = gic_dist_base(irq) + GIC_DIST_TARGET + (gic_irq(irq) & ~3);
 	unsigned int shift = (irq % 4) * 8;
 	unsigned int cpu = cpumask_first(mask_val);
@@ -129,13 +133,13 @@ static int gic_set_cpu(unsigned int irq,
 
 static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct gic_chip_data *chip_data = get_irq_data(irq);
-	struct irq_chip *chip = get_irq_chip(irq);
+	struct gic_chip_data *chip_data = get_irq_desc_data(desc);
+	struct irq_chip *chip = get_irq_desc_chip(desc);
 	unsigned int cascade_irq, gic_irq;
 	unsigned long status;
 
 	/* primary controller ack'ing */
-	chip->ack(irq);
+	chip->ack(desc);
 
 	spin_lock(&irq_controller_lock);
 	status = readl(chip_data->cpu_base + GIC_CPU_INTACK);
@@ -153,7 +157,7 @@ static void gic_handle_cascade_irq(unsig
 
  out:
 	/* primary controller unmasking */
-	chip->unmask(irq);
+	chip->unmask(desc);
 }
 
 static struct irq_chip gic_chip = {
Index: linux-2.6/arch/arm/common/it8152.c
===================================================================
--- linux-2.6.orig/arch/arm/common/it8152.c
+++ linux-2.6/arch/arm/common/it8152.c
@@ -32,8 +32,10 @@
 
 #define MAX_SLOTS		21
 
-static void it8152_mask_irq(unsigned int irq)
+static void it8152_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
        if (irq >= IT8152_LD_IRQ(0)) {
 	       __raw_writel((__raw_readl(IT8152_INTC_LDCNIMR) |
 			    (1 << (irq - IT8152_LD_IRQ(0)))),
@@ -49,8 +51,10 @@ static void it8152_mask_irq(unsigned int
        }
 }
 
-static void it8152_unmask_irq(unsigned int irq)
+static void it8152_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
        if (irq >= IT8152_LD_IRQ(0)) {
 	       __raw_writel((__raw_readl(IT8152_INTC_LDCNIMR) &
 			     ~(1 << (irq - IT8152_LD_IRQ(0)))),
Index: linux-2.6/arch/arm/common/locomo.c
===================================================================
--- linux-2.6.orig/arch/arm/common/locomo.c
+++ linux-2.6/arch/arm/common/locomo.c
@@ -169,10 +169,10 @@ static struct locomo_dev_info locomo_dev
 static void locomo_handler(unsigned int irq, struct irq_desc *desc)
 {
 	int req, i;
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 
 	/* Acknowledge the parent IRQ */
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
 	/* check why this interrupt was generated */
 	req = locomo_readl(mapbase + LOCOMO_ICR) & 0x0f00;
@@ -189,23 +189,27 @@ static void locomo_handler(unsigned int
 	}
 }
 
-static void locomo_ack_irq(unsigned int irq)
+static void locomo_ack_irq(struct irq_desc *desc)
 {
 }
 
-static void locomo_mask_irq(unsigned int irq)
+static void locomo_mask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_ICR);
 	r &= ~(0x0010 << (irq - LOCOMO_IRQ_START));
 	locomo_writel(r, mapbase + LOCOMO_ICR);
 }
 
-static void locomo_unmask_irq(unsigned int irq)
+static void locomo_unmask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_ICR);
 	r |= (0x0010 << (irq - LOCOMO_IRQ_START));
 	locomo_writel(r, mapbase + LOCOMO_ICR);
@@ -220,35 +224,41 @@ static struct irq_chip locomo_chip = {
 
 static void locomo_key_handler(unsigned int irq, struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 
 	if (locomo_readl(mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC) & 0x0001) {
 		generic_handle_irq(LOCOMO_IRQ_KEY_START);
 	}
 }
 
-static void locomo_key_ack_irq(unsigned int irq)
+static void locomo_key_ack_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
 	r &= ~(0x0100 << (irq - LOCOMO_IRQ_KEY_START));
 	locomo_writel(r, mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
 }
 
-static void locomo_key_mask_irq(unsigned int irq)
+static void locomo_key_mask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
 	r &= ~(0x0010 << (irq - LOCOMO_IRQ_KEY_START));
 	locomo_writel(r, mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
 }
 
-static void locomo_key_unmask_irq(unsigned int irq)
+static void locomo_key_unmask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
 	r |= (0x0010 << (irq - LOCOMO_IRQ_KEY_START));
 	locomo_writel(r, mapbase + LOCOMO_KEYBOARD + LOCOMO_KIC);
@@ -264,7 +274,7 @@ static struct irq_chip locomo_key_chip =
 static void locomo_gpio_handler(unsigned int irq, struct irq_desc *desc)
 {
 	int req, i;
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 
 	req = 	locomo_readl(mapbase + LOCOMO_GIR) &
 		locomo_readl(mapbase + LOCOMO_GPD) &
@@ -280,10 +290,12 @@ static void locomo_gpio_handler(unsigned
 	}
 }
 
-static void locomo_gpio_ack_irq(unsigned int irq)
+static void locomo_gpio_ack_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_GWE);
 	r |= (0x0001 << (irq - LOCOMO_IRQ_GPIO_START));
 	locomo_writel(r, mapbase + LOCOMO_GWE);
@@ -297,19 +309,23 @@ static void locomo_gpio_ack_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_GWE);
 }
 
-static void locomo_gpio_mask_irq(unsigned int irq)
+static void locomo_gpio_mask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_GIE);
 	r &= ~(0x0001 << (irq - LOCOMO_IRQ_GPIO_START));
 	locomo_writel(r, mapbase + LOCOMO_GIE);
 }
 
-static void locomo_gpio_unmask_irq(unsigned int irq)
+static void locomo_gpio_unmask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_GIE);
 	r |= (0x0001 << (irq - LOCOMO_IRQ_GPIO_START));
 	locomo_writel(r, mapbase + LOCOMO_GIE);
@@ -318,10 +334,11 @@ static void locomo_gpio_unmask_irq(unsig
 static int GPIO_IRQ_rising_edge;
 static int GPIO_IRQ_falling_edge;
 
-static int locomo_gpio_type(unsigned int irq, unsigned int type)
+static int locomo_gpio_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 
 	mask = 1 << (irq - LOCOMO_IRQ_GPIO_START);
 
@@ -355,35 +372,41 @@ static struct irq_chip locomo_gpio_chip
 
 static void locomo_lt_handler(unsigned int irq, struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 
 	if (locomo_readl(mapbase + LOCOMO_LTINT) & 0x0001) {
 		generic_handle_irq(LOCOMO_IRQ_LT_START);
 	}
 }
 
-static void locomo_lt_ack_irq(unsigned int irq)
+static void locomo_lt_ack_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_LTINT);
 	r &= ~(0x0100 << (irq - LOCOMO_IRQ_LT_START));
 	locomo_writel(r, mapbase + LOCOMO_LTINT);
 }
 
-static void locomo_lt_mask_irq(unsigned int irq)
+static void locomo_lt_mask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_LTINT);
 	r &= ~(0x0010 << (irq - LOCOMO_IRQ_LT_START));
 	locomo_writel(r, mapbase + LOCOMO_LTINT);
 }
 
-static void locomo_lt_unmask_irq(unsigned int irq)
+static void locomo_lt_unmask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_LTINT);
 	r |= (0x0010 << (irq - LOCOMO_IRQ_LT_START));
 	locomo_writel(r, mapbase + LOCOMO_LTINT);
@@ -399,7 +422,7 @@ static struct irq_chip locomo_lt_chip =
 static void locomo_spi_handler(unsigned int irq, struct irq_desc *desc)
 {
 	int req, i;
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 
 	req = locomo_readl(mapbase + LOCOMO_SPI + LOCOMO_SPIIR) & 0x000F;
 	if (req) {
@@ -413,10 +436,12 @@ static void locomo_spi_handler(unsigned
 	}
 }
 
-static void locomo_spi_ack_irq(unsigned int irq)
+static void locomo_spi_ack_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_SPI + LOCOMO_SPIWE);
 	r |= (0x0001 << (irq - LOCOMO_IRQ_SPI_START));
 	locomo_writel(r, mapbase + LOCOMO_SPI + LOCOMO_SPIWE);
@@ -430,19 +455,23 @@ static void locomo_spi_ack_irq(unsigned
 	locomo_writel(r, mapbase + LOCOMO_SPI + LOCOMO_SPIWE);
 }
 
-static void locomo_spi_mask_irq(unsigned int irq)
+static void locomo_spi_mask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_SPI + LOCOMO_SPIIE);
 	r &= ~(0x0001 << (irq - LOCOMO_IRQ_SPI_START));
 	locomo_writel(r, mapbase + LOCOMO_SPI + LOCOMO_SPIIE);
 }
 
-static void locomo_spi_unmask_irq(unsigned int irq)
+static void locomo_spi_unmask_irq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned int r;
+
 	r = locomo_readl(mapbase + LOCOMO_SPI + LOCOMO_SPIIE);
 	r |= (0x0001 << (irq - LOCOMO_IRQ_SPI_START));
 	locomo_writel(r, mapbase + LOCOMO_SPI + LOCOMO_SPIIE);
Index: linux-2.6/arch/arm/common/sa1111.c
===================================================================
--- linux-2.6.orig/arch/arm/common/sa1111.c
+++ linux-2.6/arch/arm/common/sa1111.c
@@ -159,7 +159,7 @@ sa1111_irq_handler(unsigned int irq, str
 
 	sa1111_writel(stat0, base + SA1111_INTSTATCLR0);
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
 	sa1111_writel(stat1, base + SA1111_INTSTATCLR1);
 
@@ -177,19 +177,20 @@ sa1111_irq_handler(unsigned int irq, str
 			handle_edge_irq(i, irq_desc + i);
 
 	/* For level-based interrupts */
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 #define SA1111_IRQMASK_LO(x)	(1 << (x - IRQ_SA1111_START))
 #define SA1111_IRQMASK_HI(x)	(1 << (x - IRQ_SA1111_START - 32))
 
-static void sa1111_ack_irq(unsigned int irq)
+static void sa1111_ack_irq(struct irq_desc *desc)
 {
 }
 
-static void sa1111_mask_lowirq(unsigned int irq)
+static void sa1111_mask_lowirq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ie0;
 
 	ie0 = sa1111_readl(mapbase + SA1111_INTEN0);
@@ -197,9 +198,10 @@ static void sa1111_mask_lowirq(unsigned
 	writel(ie0, mapbase + SA1111_INTEN0);
 }
 
-static void sa1111_unmask_lowirq(unsigned int irq)
+static void sa1111_unmask_lowirq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ie0;
 
 	ie0 = sa1111_readl(mapbase + SA1111_INTEN0);
@@ -214,10 +216,11 @@ static void sa1111_unmask_lowirq(unsigne
  * be triggered.  In fact, its very difficult, if not impossible to get
  * INTSET to re-trigger the interrupt.
  */
-static int sa1111_retrigger_lowirq(unsigned int irq)
+static int sa1111_retrigger_lowirq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = SA1111_IRQMASK_LO(irq);
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ip0;
 	int i;
 
@@ -235,10 +238,11 @@ static int sa1111_retrigger_lowirq(unsig
 	return i == 8 ? -1 : 0;
 }
 
-static int sa1111_type_lowirq(unsigned int irq, unsigned int flags)
+static int sa1111_type_lowirq(struct irq_desc *desc, unsigned int flags)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = SA1111_IRQMASK_LO(irq);
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ip0;
 
 	if (flags == IRQ_TYPE_PROBE)
@@ -258,10 +262,11 @@ static int sa1111_type_lowirq(unsigned i
 	return 0;
 }
 
-static int sa1111_wake_lowirq(unsigned int irq, unsigned int on)
+static int sa1111_wake_lowirq(struct irq_desc *desc, unsigned int on)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = SA1111_IRQMASK_LO(irq);
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long we0;
 
 	we0 = sa1111_readl(mapbase + SA1111_WAKEEN0);
@@ -284,9 +289,10 @@ static struct irq_chip sa1111_low_chip =
 	.set_wake	= sa1111_wake_lowirq,
 };
 
-static void sa1111_mask_highirq(unsigned int irq)
+static void sa1111_mask_highirq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ie1;
 
 	ie1 = sa1111_readl(mapbase + SA1111_INTEN1);
@@ -294,9 +300,10 @@ static void sa1111_mask_highirq(unsigned
 	sa1111_writel(ie1, mapbase + SA1111_INTEN1);
 }
 
-static void sa1111_unmask_highirq(unsigned int irq)
+static void sa1111_unmask_highirq(struct irq_desc *desc)
 {
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ie1;
 
 	ie1 = sa1111_readl(mapbase + SA1111_INTEN1);
@@ -311,10 +318,11 @@ static void sa1111_unmask_highirq(unsign
  * be triggered.  In fact, its very difficult, if not impossible to get
  * INTSET to re-trigger the interrupt.
  */
-static int sa1111_retrigger_highirq(unsigned int irq)
+static int sa1111_retrigger_highirq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = SA1111_IRQMASK_HI(irq);
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ip1;
 	int i;
 
@@ -332,10 +340,11 @@ static int sa1111_retrigger_highirq(unsi
 	return i == 8 ? -1 : 0;
 }
 
-static int sa1111_type_highirq(unsigned int irq, unsigned int flags)
+static int sa1111_type_highirq(struct irq_desc *desc, unsigned int flags)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = SA1111_IRQMASK_HI(irq);
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long ip1;
 
 	if (flags == IRQ_TYPE_PROBE)
@@ -355,10 +364,11 @@ static int sa1111_type_highirq(unsigned
 	return 0;
 }
 
-static int sa1111_wake_highirq(unsigned int irq, unsigned int on)
+static int sa1111_wake_highirq(struct irq_desc *desc, unsigned int on)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = SA1111_IRQMASK_HI(irq);
-	void __iomem *mapbase = get_irq_chip_data(irq);
+	void __iomem *mapbase = get_irq_desc_chip_data(desc);
 	unsigned long we1;
 
 	we1 = sa1111_readl(mapbase + SA1111_WAKEEN1);
Index: linux-2.6/arch/arm/common/vic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/vic.c
+++ linux-2.6/arch/arm/common/vic.c
@@ -28,25 +28,31 @@
 #include <asm/mach/irq.h>
 #include <asm/hardware/vic.h>
 
-static void vic_ack_irq(unsigned int irq)
+static void vic_ack_irq(struct irq_desc *desc)
 {
-	void __iomem *base = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *base = get_irq_desc_chip_data(desc);
+
 	irq &= 31;
 	writel(1 << irq, base + VIC_INT_ENABLE_CLEAR);
 	/* moreover, clear the soft-triggered, in case it was the reason */
 	writel(1 << irq, base + VIC_INT_SOFT_CLEAR);
 }
 
-static void vic_mask_irq(unsigned int irq)
+static void vic_mask_irq(struct irq_desc *desc)
 {
-	void __iomem *base = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *base = get_irq_desc_chip_data(desc);
+
 	irq &= 31;
 	writel(1 << irq, base + VIC_INT_ENABLE_CLEAR);
 }
 
-static void vic_unmask_irq(unsigned int irq)
+static void vic_unmask_irq(struct irq_desc *desc)
 {
-	void __iomem *base = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *base = get_irq_desc_chip_data(irq);
+
 	irq &= 31;
 	writel(1 << irq, base + VIC_INT_ENABLE);
 }
@@ -236,8 +242,9 @@ static struct vic_device *vic_from_irq(u
 	return NULL;
 }
 
-static int vic_set_wake(unsigned int irq, unsigned int on)
+static int vic_set_wake(struct irq_desc *desc, unsigned int on)
 {
+	unsigned int irq = desc->irq;
 	struct vic_device *v = vic_from_irq(irq);
 	unsigned int off = irq & 31;
 	u32 bit = 1 << off;
Index: linux-2.6/arch/arm/kernel/ecard.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/ecard.c
+++ linux-2.6/arch/arm/kernel/ecard.c
@@ -443,8 +443,9 @@ static expansioncard_ops_t ecard_default
  *
  * They are not meant to be called directly, but via enable/disable_irq.
  */
-static void ecard_irq_unmask(unsigned int irqnr)
+static void ecard_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irqnr = desc->irq;
 	ecard_t *ec = slot_to_ecard(irqnr - 32);
 
 	if (ec) {
@@ -459,8 +460,9 @@ static void ecard_irq_unmask(unsigned in
 	}
 }
 
-static void ecard_irq_mask(unsigned int irqnr)
+static void ecard_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irqnr = desc->irq;
 	ecard_t *ec = slot_to_ecard(irqnr - 32);
 
 	if (ec) {
@@ -551,7 +553,7 @@ static void ecard_check_lockup(struct ir
 			printk(KERN_ERR "\nInterrupt lockup detected - "
 			       "disabling all expansion card interrupts\n");
 
-			desc->chip->mask(IRQ_EXPANSIONCARD);
+			desc->chip->mask(irq_to_desc(IRQ_EXPANSIONCARD));
 			ecard_dump_irq_state();
 		}
 	} else
@@ -574,7 +576,7 @@ ecard_irq_handler(unsigned int irq, stru
 	ecard_t *ec;
 	int called = 0;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(desc);
 	for (ec = cards; ec; ec = ec->next) {
 		int pending;
 
@@ -591,7 +593,7 @@ ecard_irq_handler(unsigned int irq, stru
 			called ++;
 		}
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 
 	if (called == 0)
 		ecard_check_lockup(desc);
Index: linux-2.6/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/irq.c
+++ linux-2.6/arch/arm/kernel/irq.c
@@ -167,7 +167,7 @@ static void route_irq(struct irq_desc *d
 	pr_debug("IRQ%u: moving from cpu%u to cpu%u\n", irq, desc->node, cpu);
 
 	raw_spin_lock_irq(&desc->lock);
-	desc->chip->set_affinity(irq, cpumask_of(cpu));
+	desc->chip->set_affinity(desc, cpumask_of(cpu));
 	raw_spin_unlock_irq(&desc->lock);
 }
 
Index: linux-2.6/arch/arm/mach-aaec2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-aaec2000/core.c
+++ linux-2.6/arch/arm/mach-aaec2000/core.c
@@ -67,17 +67,17 @@ void __init aaec2000_map_io(void)
 /*
  * Interrupt handling routines
  */
-static void aaec2000_int_ack(unsigned int irq)
+static void aaec2000_int_ack(struct irq_desc *desc)
 {
 	IRQ_INTSR = 1 << irq;
 }
 
-static void aaec2000_int_mask(unsigned int irq)
+static void aaec2000_int_mask(struct irq_desc *desc)
 {
 	IRQ_INTENC |= (1 << irq);
 }
 
-static void aaec2000_int_unmask(unsigned int irq)
+static void aaec2000_int_unmask(struct irq_desc *desc)
 {
 	IRQ_INTENS |= (1 << irq);
 }
Index: linux-2.6/arch/arm/mach-at91/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/gpio.c
+++ linux-2.6/arch/arm/mach-at91/gpio.c
@@ -274,8 +274,9 @@ EXPORT_SYMBOL(at91_get_gpio_value);
 static u32 wakeups[MAX_GPIO_BANKS];
 static u32 backups[MAX_GPIO_BANKS];
 
-static int gpio_irq_set_wake(unsigned pin, unsigned state)
+static int gpio_irq_set_wake(struct irq_desc *desc, unsigned state)
 {
+	unsigned int pin = desc->irq;
 	unsigned	mask = pin_to_mask(pin);
 	unsigned	bank = (pin - PIN_BASE) / 32;
 
@@ -344,8 +345,9 @@ void at91_gpio_resume(void)
  * IRQ0..IRQ6 should be configurable, e.g. level vs edge triggering.
  */
 
-static void gpio_irq_mask(unsigned pin)
+static void gpio_irq_mask(struct irq_desc *desc)
 {
+	unsigned int pin = desc->irq;
 	void __iomem	*pio = pin_to_controller(pin);
 	unsigned	mask = pin_to_mask(pin);
 
@@ -353,8 +355,9 @@ static void gpio_irq_mask(unsigned pin)
 		__raw_writel(mask, pio + PIO_IDR);
 }
 
-static void gpio_irq_unmask(unsigned pin)
+static void gpio_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int pin = desc->irq;
 	void __iomem	*pio = pin_to_controller(pin);
 	unsigned	mask = pin_to_mask(pin);
 
@@ -362,7 +365,7 @@ static void gpio_irq_unmask(unsigned pin
 		__raw_writel(mask, pio + PIO_IER);
 }
 
-static int gpio_irq_type(unsigned pin, unsigned type)
+static int gpio_irq_type(struct irq_desc *desc, unsigned type)
 {
 	switch (type) {
 	case IRQ_TYPE_NONE:
@@ -393,7 +396,7 @@ static void gpio_irq_handler(unsigned ir
 	pio = at91_gpio->regbase;
 
 	/* temporarily mask (level sensitive) parent IRQ */
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 	for (;;) {
 		/* Reading ISR acks pending (edge triggered) GPIO interrupts.
 		 * When there none are pending, we're finished unless we need
@@ -429,7 +432,7 @@ static void gpio_irq_handler(unsigned ir
 			isr >>= 1;
 		}
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 	/* now it may re-trigger */
 }
 
Index: linux-2.6/arch/arm/mach-at91/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/irq.c
+++ linux-2.6/arch/arm/mach-at91/irq.c
@@ -34,14 +34,18 @@
 #include <asm/mach/map.h>
 
 
-static void at91_aic_mask_irq(unsigned int irq)
+static void at91_aic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	/* Disable interrupt on AIC */
 	at91_sys_write(AT91_AIC_IDCR, 1 << irq);
 }
 
-static void at91_aic_unmask_irq(unsigned int irq)
+static void at91_aic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	/* Enable interrupt on AIC */
 	at91_sys_write(AT91_AIC_IECR, 1 << irq);
 }
@@ -50,8 +54,9 @@ unsigned int at91_extern_irq;
 
 #define is_extern_irq(irq) ((1 << (irq)) & at91_extern_irq)
 
-static int at91_aic_set_type(unsigned irq, unsigned type)
+static int at91_aic_set_type(struct irq_desc *desc, unsigned type)
 {
+	unsigned int irq = desc->irq;
 	unsigned int smr, srctype;
 
 	switch (type) {
@@ -87,8 +92,10 @@ static int at91_aic_set_type(unsigned ir
 static u32 wakeups;
 static u32 backups;
 
-static int at91_aic_set_wake(unsigned irq, unsigned value)
+static int at91_aic_set_wake(struct irq_desc *desc, unsigned value)
 {
+	unsigned int irq = desc->irq;
+
 	if (unlikely(irq >= 32))
 		return -EINVAL;
 
Index: linux-2.6/arch/arm/mach-bcmring/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-bcmring/irq.c
+++ linux-2.6/arch/arm/mach-bcmring/irq.c
@@ -30,38 +30,50 @@
 #include <mach/csp/intcHw_reg.h>
 #include <mach/csp/mm_io.h>
 
-static void bcmring_mask_irq0(unsigned int irq)
+static void bcmring_mask_irq0(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	writel(1 << (irq - IRQ_INTC0_START),
 	       MM_IO_BASE_INTC0 + INTCHW_INTENCLEAR);
 }
 
-static void bcmring_unmask_irq0(unsigned int irq)
+static void bcmring_unmask_irq0(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	writel(1 << (irq - IRQ_INTC0_START),
 	       MM_IO_BASE_INTC0 + INTCHW_INTENABLE);
 }
 
-static void bcmring_mask_irq1(unsigned int irq)
+static void bcmring_mask_irq1(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	writel(1 << (irq - IRQ_INTC1_START),
 	       MM_IO_BASE_INTC1 + INTCHW_INTENCLEAR);
 }
 
-static void bcmring_unmask_irq1(unsigned int irq)
+static void bcmring_unmask_irq1(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	writel(1 << (irq - IRQ_INTC1_START),
 	       MM_IO_BASE_INTC1 + INTCHW_INTENABLE);
 }
 
-static void bcmring_mask_irq2(unsigned int irq)
+static void bcmring_mask_irq2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	writel(1 << (irq - IRQ_SINTC_START),
 	       MM_IO_BASE_SINTC + INTCHW_INTENCLEAR);
 }
 
-static void bcmring_unmask_irq2(unsigned int irq)
+static void bcmring_unmask_irq2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	writel(1 << (irq - IRQ_SINTC_START),
 	       MM_IO_BASE_SINTC + INTCHW_INTENABLE);
 }
Index: linux-2.6/arch/arm/mach-clps711x/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-clps711x/irq.c
+++ linux-2.6/arch/arm/mach-clps711x/irq.c
@@ -27,8 +27,9 @@
 
 #include <asm/hardware/clps7111.h>
 
-static void int1_mask(unsigned int irq)
+static void int1_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 intmr1;
 
 	intmr1 = clps_readl(INTMR1);
@@ -36,8 +37,9 @@ static void int1_mask(unsigned int irq)
 	clps_writel(intmr1, INTMR1);
 }
 
-static void int1_ack(unsigned int irq)
+static void int1_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 intmr1;
 
 	intmr1 = clps_readl(INTMR1);
@@ -54,8 +56,9 @@ static void int1_ack(unsigned int irq)
 	}
 }
 
-static void int1_unmask(unsigned int irq)
+static void int1_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 intmr1;
 
 	intmr1 = clps_readl(INTMR1);
@@ -69,8 +72,9 @@ static struct irq_chip int1_chip = {
 	.unmask = int1_unmask,
 };
 
-static void int2_mask(unsigned int irq)
+static void int2_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 intmr2;
 
 	intmr2 = clps_readl(INTMR2);
@@ -78,8 +82,9 @@ static void int2_mask(unsigned int irq)
 	clps_writel(intmr2, INTMR2);
 }
 
-static void int2_ack(unsigned int irq)
+static void int2_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 intmr2;
 
 	intmr2 = clps_readl(INTMR2);
@@ -91,8 +96,9 @@ static void int2_ack(unsigned int irq)
 	}
 }
 
-static void int2_unmask(unsigned int irq)
+static void int2_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 intmr2;
 
 	intmr2 = clps_readl(INTMR2);
Index: linux-2.6/arch/arm/mach-davinci/cp_intc.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/cp_intc.c
+++ linux-2.6/arch/arm/mach-davinci/cp_intc.c
@@ -27,14 +27,16 @@ static inline void cp_intc_write(unsigne
 	__raw_writel(value, cp_intc_base + offset);
 }
 
-static void cp_intc_ack_irq(unsigned int irq)
+static void cp_intc_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	cp_intc_write(irq, CP_INTC_SYS_STAT_IDX_CLR);
 }
 
 /* Disable interrupt */
-static void cp_intc_mask_irq(unsigned int irq)
+static void cp_intc_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* XXX don't know why we need to disable nIRQ here... */
 	cp_intc_write(1, CP_INTC_HOST_ENABLE_IDX_CLR);
 	cp_intc_write(irq, CP_INTC_SYS_ENABLE_IDX_CLR);
@@ -42,13 +44,15 @@ static void cp_intc_mask_irq(unsigned in
 }
 
 /* Enable interrupt */
-static void cp_intc_unmask_irq(unsigned int irq)
+static void cp_intc_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	cp_intc_write(irq, CP_INTC_SYS_ENABLE_IDX_SET);
 }
 
-static int cp_intc_set_irq_type(unsigned int irq, unsigned int flow_type)
+static int cp_intc_set_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int irq = desc->irq;
 	unsigned reg		= BIT_WORD(irq);
 	unsigned mask		= BIT_MASK(irq);
 	unsigned polarity	= cp_intc_read(CP_INTC_SYS_POLARITY(reg));
@@ -86,7 +90,7 @@ static int cp_intc_set_irq_type(unsigned
  * generic drivers which call {enable|disable}_irq_wake for
  * wake up interrupt sources (eg RTC on DA850).
  */
-static int cp_intc_set_wake(unsigned int irq, unsigned int on)
+static int cp_intc_set_wake(struct irq_desc *desc, unsigned int on)
 {
 	return 0;
 }
Index: linux-2.6/arch/arm/mach-davinci/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/gpio.c
+++ linux-2.6/arch/arm/mach-davinci/gpio.c
@@ -159,20 +159,20 @@ pure_initcall(davinci_gpio_setup);
  * serve as EDMA event triggers.
  */
 
-static void gpio_irq_disable(unsigned irq)
+static void gpio_irq_disable(struct irq_desc *desc)
 {
-	struct gpio_controller *__iomem g = get_irq_chip_data(irq);
-	u32 mask = (u32) get_irq_data(irq);
+	struct gpio_controller *__iomem g = get_irq_desc_chip_data(desc);
+	u32 mask = (u32) get_irq_desc_data(desc);
 
 	__raw_writel(mask, &g->clr_falling);
 	__raw_writel(mask, &g->clr_rising);
 }
 
-static void gpio_irq_enable(unsigned irq)
+static void gpio_irq_enable(struct irq_desc *desc)
 {
-	struct gpio_controller *__iomem g = get_irq_chip_data(irq);
-	u32 mask = (u32) get_irq_data(irq);
-	unsigned status = irq_desc[irq].status;
+	struct gpio_controller *__iomem g = get_irq_desc_chip_data(desc);
+	u32 mask = (u32) get_irq_desc_data(desc);
+	unsigned status = desc->status;
 
 	status &= IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING;
 	if (!status)
@@ -184,19 +184,19 @@ static void gpio_irq_enable(unsigned irq
 		__raw_writel(mask, &g->set_rising);
 }
 
-static int gpio_irq_type(unsigned irq, unsigned trigger)
+static int gpio_irq_type(struct irq_desc *desc, unsigned trigger)
 {
-	struct gpio_controller *__iomem g = get_irq_chip_data(irq);
-	u32 mask = (u32) get_irq_data(irq);
+	struct gpio_controller *__iomem g = get_irq_desc_chip_data(desc);
+	u32 mask = (u32) get_irq_desc_data(desc);
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
-	irq_desc[irq].status &= ~IRQ_TYPE_SENSE_MASK;
-	irq_desc[irq].status |= trigger;
+	desc->status &= ~IRQ_TYPE_SENSE_MASK;
+	desc->status |= trigger;
 
 	/* don't enable the IRQ if it's currently disabled */
-	if (irq_desc[irq].depth == 0) {
+	if (desc->depth == 0) {
 		__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_FALLING)
 			     ? &g->set_falling : &g->clr_falling);
 		__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_RISING)
@@ -223,8 +223,8 @@ gpio_irq_handler(unsigned irq, struct ir
 		mask <<= 16;
 
 	/* temporarily mask (level sensitive) parent IRQ */
-	desc->chip->mask(irq);
-	desc->chip->ack(irq);
+	desc->chip->mask(desc);
+	desc->chip->ack(desc);
 	while (1) {
 		u32		status;
 		int		n;
@@ -247,7 +247,7 @@ gpio_irq_handler(unsigned irq, struct ir
 			status >>= res;
 		}
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 	/* now it may re-trigger */
 }
 
Index: linux-2.6/arch/arm/mach-davinci/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/irq.c
+++ linux-2.6/arch/arm/mach-davinci/irq.c
@@ -53,8 +53,9 @@ static inline void davinci_irq_writel(un
 }
 
 /* Disable interrupt */
-static void davinci_mask_irq(unsigned int irq)
+static void davinci_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	u32 l;
 
@@ -72,8 +73,9 @@ static void davinci_mask_irq(unsigned in
 }
 
 /* Enable interrupt */
-static void davinci_unmask_irq(unsigned int irq)
+static void davinci_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	u32 l;
 
@@ -91,8 +93,9 @@ static void davinci_unmask_irq(unsigned
 }
 
 /* EOI interrupt */
-static void davinci_ack_irq(unsigned int irq)
+static void davinci_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 
 	mask = 1 << IRQ_BIT(irq);
Index: linux-2.6/arch/arm/mach-dove/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-dove/irq.c
+++ linux-2.6/arch/arm/mach-dove/irq.c
@@ -36,8 +36,9 @@ static void gpio_irq_handler(unsigned in
 	}
 }
 
-static void pmu_irq_mask(unsigned int irq)
+static void pmu_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq_to_pmu(irq);
 	u32 u;
 
@@ -46,8 +47,9 @@ static void pmu_irq_mask(unsigned int ir
 	writel(u, PMU_INTERRUPT_MASK);
 }
 
-static void pmu_irq_unmask(unsigned int irq)
+static void pmu_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq_to_pmu(irq);
 	u32 u;
 
@@ -56,8 +58,9 @@ static void pmu_irq_unmask(unsigned int
 	writel(u, PMU_INTERRUPT_MASK);
 }
 
-static void pmu_irq_ack(unsigned int irq)
+static void pmu_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq_to_pmu(irq);
 	u32 u;
 
Index: linux-2.6/arch/arm/mach-ebsa110/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ebsa110/core.c
+++ linux-2.6/arch/arm/mach-ebsa110/core.c
@@ -35,13 +35,15 @@
 #define IRQ_STAT		0xff000000	/* read */
 #define IRQ_MCLR		0xff000000	/* write */
 
-static void ebsa110_mask_irq(unsigned int irq)
+static void ebsa110_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writeb(1 << irq, IRQ_MCLR);
 }
 
-static void ebsa110_unmask_irq(unsigned int irq)
+static void ebsa110_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writeb(1 << irq, IRQ_MSET);
 }
 
Index: linux-2.6/arch/arm/mach-ep93xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ep93xx/core.c
+++ linux-2.6/arch/arm/mach-ep93xx/core.c
@@ -225,8 +225,9 @@ static void ep93xx_gpio_f_irq_handler(un
 	generic_handle_irq(gpio_irq);
 }
 
-static void ep93xx_gpio_irq_ack(unsigned int irq)
+static void ep93xx_gpio_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
@@ -239,8 +240,9 @@ static void ep93xx_gpio_irq_ack(unsigned
 	__raw_writeb(port_mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
 }
 
-static void ep93xx_gpio_irq_mask_ack(unsigned int irq)
+static void ep93xx_gpio_irq_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
 	int port_mask = 1 << (line & 7);
@@ -254,8 +256,9 @@ static void ep93xx_gpio_irq_mask_ack(uns
 	__raw_writeb(port_mask, EP93XX_GPIO_REG(eoi_register_offset[port]));
 }
 
-static void ep93xx_gpio_irq_mask(unsigned int irq)
+static void ep93xx_gpio_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
 
@@ -263,8 +266,9 @@ static void ep93xx_gpio_irq_mask(unsigne
 	ep93xx_gpio_update_int_params(port);
 }
 
-static void ep93xx_gpio_irq_unmask(unsigned int irq)
+static void ep93xx_gpio_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int line = irq_to_gpio(irq);
 	int port = line >> 3;
 
@@ -278,9 +282,9 @@ static void ep93xx_gpio_irq_unmask(unsig
  * edge (1) triggered, while gpio_int_type2 controls whether it
  * triggers on low/falling (0) or high/rising (1).
  */
-static int ep93xx_gpio_irq_type(unsigned int irq, unsigned int type)
+static int ep93xx_gpio_irq_type(struct irq_desc *desc, unsigned int type)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	unsigned int irq = desc->irq;
 	const int gpio = irq_to_gpio(irq);
 	const int port = gpio >> 3;
 	const int port_mask = 1 << (gpio & 7);
Index: linux-2.6/arch/arm/mach-footbridge/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/common.c
+++ linux-2.6/arch/arm/mach-footbridge/common.c
@@ -74,13 +74,15 @@ static const int fb_irq_mask[] = {
 	IRQ_MASK_PCI_PERR,	/* 19 */
 };
 
-static void fb_mask_irq(unsigned int irq)
+static void fb_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	*CSR_IRQ_DISABLE = fb_irq_mask[_DC21285_INR(irq)];
 }
 
-static void fb_unmask_irq(unsigned int irq)
+static void fb_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	*CSR_IRQ_ENABLE = fb_irq_mask[_DC21285_INR(irq)];
 }
 
Index: linux-2.6/arch/arm/mach-footbridge/isa-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/isa-irq.c
+++ linux-2.6/arch/arm/mach-footbridge/isa-irq.c
@@ -30,23 +30,26 @@
 
 #include "common.h"
 
-static void isa_mask_pic_lo_irq(unsigned int irq)
+static void isa_mask_pic_lo_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_LO) | mask, PIC_MASK_LO);
 }
 
-static void isa_ack_pic_lo_irq(unsigned int irq)
+static void isa_ack_pic_lo_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_LO) | mask, PIC_MASK_LO);
 	outb(0x20, PIC_LO);
 }
 
-static void isa_unmask_pic_lo_irq(unsigned int irq)
+static void isa_unmask_pic_lo_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_LO) & ~mask, PIC_MASK_LO);
@@ -58,15 +61,17 @@ static struct irq_chip isa_lo_chip = {
 	.unmask = isa_unmask_pic_lo_irq,
 };
 
-static void isa_mask_pic_hi_irq(unsigned int irq)
+static void isa_mask_pic_hi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_HI) | mask, PIC_MASK_HI);
 }
 
-static void isa_ack_pic_hi_irq(unsigned int irq)
+static void isa_ack_pic_hi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_HI) | mask, PIC_MASK_HI);
@@ -74,8 +79,9 @@ static void isa_ack_pic_hi_irq(unsigned
 	outb(0x20, PIC_HI);
 }
 
-static void isa_unmask_pic_hi_irq(unsigned int irq)
+static void isa_unmask_pic_hi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq & 7);
 
 	outb(inb(PIC_MASK_HI) & ~mask, PIC_MASK_HI);
Index: linux-2.6/arch/arm/mach-gemini/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-gemini/gpio.c
+++ linux-2.6/arch/arm/mach-gemini/gpio.c
@@ -54,24 +54,27 @@ static void _set_gpio_irqenable(unsigned
 	__raw_writel(reg, base + GPIO_INT_EN);
 }
 
-static void gpio_ack_irq(unsigned int irq)
+static void gpio_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq_to_gpio(irq);
 	unsigned int base = GPIO_BASE(gpio / 32);
 
 	__raw_writel(1 << (gpio % 32), base + GPIO_INT_CLR);
 }
 
-static void gpio_mask_irq(unsigned int irq)
+static void gpio_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq_to_gpio(irq);
 	unsigned int base = GPIO_BASE(gpio / 32);
 
 	_set_gpio_irqenable(base, gpio % 32, 0);
 }
 
-static void gpio_unmask_irq(unsigned int irq)
+static void gpio_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq_to_gpio(irq);
 	unsigned int base = GPIO_BASE(gpio / 32);
 
@@ -80,6 +83,7 @@ static void gpio_unmask_irq(unsigned int
 
 static int gpio_set_irq_type(unsigned int irq, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq_to_gpio(irq);
 	unsigned int gpio_mask = 1 << (gpio % 32);
 	unsigned int base = GPIO_BASE(gpio / 32);
@@ -120,7 +124,7 @@ static int gpio_set_irq_type(unsigned in
 	__raw_writel(reg_level, base + GPIO_INT_LEVEL);
 	__raw_writel(reg_both, base + GPIO_INT_BOTH_EDGE);
 
-	gpio_ack_irq(irq);
+	gpio_ack_irq(desc);
 
 	return 0;
 }
Index: linux-2.6/arch/arm/mach-gemini/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-gemini/irq.c
+++ linux-2.6/arch/arm/mach-gemini/irq.c
@@ -32,13 +32,15 @@
 #define FIQ_LEVEL(base_addr)	(base_addr + 0x30)
 #define FIQ_STATUS(base_addr)	(base_addr + 0x34)
 
-static void gemini_ack_irq(unsigned int irq)
+static void gemini_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(1 << irq, IRQ_CLEAR(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
 }
 
-static void gemini_mask_irq(unsigned int irq)
+static void gemini_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 
 	mask = __raw_readl(IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
@@ -46,8 +48,9 @@ static void gemini_mask_irq(unsigned int
 	__raw_writel(mask, IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
 }
 
-static void gemini_unmask_irq(unsigned int irq)
+static void gemini_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 
 	mask = __raw_readl(IRQ_MASK(IO_ADDRESS(GEMINI_INTERRUPT_BASE)));
Index: linux-2.6/arch/arm/mach-h720x/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/common.c
+++ linux-2.6/arch/arm/mach-h720x/common.c
@@ -53,16 +53,18 @@ unsigned long h720x_gettimeoffset(void)
 /*
  * mask Global irq's
  */
-static void mask_global_irq (unsigned int irq )
+static void mask_global_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	CPU_REG (IRQC_VIRT, IRQC_IER) &= ~(1 << irq);
 }
 
 /*
  * unmask Global irq's
  */
-static void unmask_global_irq (unsigned int irq )
+static void unmask_global_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	CPU_REG (IRQC_VIRT, IRQC_IER) |= (1 << irq);
 }
 
@@ -71,8 +73,9 @@ static void unmask_global_irq (unsigned
  * ack GPIO irq's
  * Ack only for edge triggered int's valid
  */
-static void inline ack_gpio_irq(u32 irq)
+static inline void ack_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(irq));
 	u32 bit = IRQ_TO_BIT(irq);
 	if ( (CPU_REG (reg_base, GPIO_EDGE) & bit))
@@ -82,8 +85,9 @@ static void inline ack_gpio_irq(u32 irq)
 /*
  * mask GPIO irq's
  */
-static void inline mask_gpio_irq(u32 irq)
+static inline void mask_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(irq));
 	u32 bit = IRQ_TO_BIT(irq);
 	CPU_REG (reg_base, GPIO_MASK) &= ~bit;
@@ -92,8 +96,9 @@ static void inline mask_gpio_irq(u32 irq
 /*
  * unmask GPIO irq's
  */
-static void inline unmask_gpio_irq(u32 irq)
+static inline void unmask_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg_base = GPIO_VIRT(IRQ_TO_REGNO(irq));
 	u32 bit = IRQ_TO_BIT(irq);
 	CPU_REG (reg_base, GPIO_MASK) |= bit;
Index: linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/cpu-h7202.c
+++ linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
@@ -141,8 +141,9 @@ h7202_timer_interrupt(int irq, void *dev
 /*
  * mask multiplexed timer IRQs
  */
-static void inline mask_timerx_irq (u32 irq)
+static inline void mask_timerx_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit;
 	bit = 2 << ((irq == IRQ_TIMER64B) ? 4 : (irq - IRQ_TIMER1));
 	CPU_REG (TIMER_VIRT, TIMER_TOPCTRL) &= ~bit;
@@ -151,8 +152,9 @@ static void inline mask_timerx_irq (u32
 /*
  * unmask multiplexed timer IRQs
  */
-static void inline unmask_timerx_irq (u32 irq)
+static inline void unmask_timerx_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit;
 	bit = 2 << ((irq == IRQ_TIMER64B) ? 4 : (irq - IRQ_TIMER1));
 	CPU_REG (TIMER_VIRT, TIMER_TOPCTRL) |= bit;
Index: linux-2.6/arch/arm/mach-integrator/integrator_ap.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/integrator_ap.c
+++ linux-2.6/arch/arm/mach-integrator/integrator_ap.c
@@ -151,13 +151,15 @@ static void __init ap_map_io(void)
 
 #define INTEGRATOR_SC_VALID_INT	0x003fffff
 
-static void sc_mask_irq(unsigned int irq)
+static void sc_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << irq, VA_IC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void sc_unmask_irq(unsigned int irq)
+static void sc_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << irq, VA_IC_BASE + IRQ_ENABLE_SET);
 }
 
Index: linux-2.6/arch/arm/mach-integrator/integrator_cp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/integrator_cp.c
+++ linux-2.6/arch/arm/mach-integrator/integrator_cp.c
@@ -145,14 +145,16 @@ static void __init intcp_map_io(void)
 #define sic_writel	__raw_writel
 #define sic_readl	__raw_readl
 
-static void cic_mask_irq(unsigned int irq)
+static void cic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_CIC_START;
 	cic_writel(1 << irq, INTCP_VA_CIC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void cic_unmask_irq(unsigned int irq)
+static void cic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_CIC_START;
 	cic_writel(1 << irq, INTCP_VA_CIC_BASE + IRQ_ENABLE_SET);
 }
@@ -164,14 +166,16 @@ static struct irq_chip cic_chip = {
 	.unmask	= cic_unmask_irq,
 };
 
-static void pic_mask_irq(unsigned int irq)
+static void pic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_PIC_START;
 	pic_writel(1 << irq, INTCP_VA_PIC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void pic_unmask_irq(unsigned int irq)
+static void pic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_PIC_START;
 	pic_writel(1 << irq, INTCP_VA_PIC_BASE + IRQ_ENABLE_SET);
 }
@@ -183,14 +187,16 @@ static struct irq_chip pic_chip = {
 	.unmask = pic_unmask_irq,
 };
 
-static void sic_mask_irq(unsigned int irq)
+static void sic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_SIC_START;
 	sic_writel(1 << irq, INTCP_VA_SIC_BASE + IRQ_ENABLE_CLEAR);
 }
 
-static void sic_unmask_irq(unsigned int irq)
+static void sic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_SIC_START;
 	sic_writel(1 << irq, INTCP_VA_SIC_BASE + IRQ_ENABLE_SET);
 }
Index: linux-2.6/arch/arm/mach-iop13xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop13xx/irq.c
+++ linux-2.6/arch/arm/mach-iop13xx/irq.c
@@ -123,50 +123,58 @@ static void write_intsize(u32 val)
 
 /* 0 = Interrupt Masked and 1 = Interrupt not masked */
 static void
-iop13xx_irq_mask0 (unsigned int irq)
+iop13xx_irq_mask0(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	write_intctl_0(read_intctl_0() & ~(1 << (irq - 0)));
 }
 
 static void
-iop13xx_irq_mask1 (unsigned int irq)
+iop13xx_irq_mask1(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	write_intctl_1(read_intctl_1() & ~(1 << (irq - 32)));
 }
 
 static void
-iop13xx_irq_mask2 (unsigned int irq)
+iop13xx_irq_mask2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	write_intctl_2(read_intctl_2() & ~(1 << (irq - 64)));
 }
 
 static void
-iop13xx_irq_mask3 (unsigned int irq)
+iop13xx_irq_mask3(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	write_intctl_3(read_intctl_3() & ~(1 << (irq - 96)));
 }
 
 static void
-iop13xx_irq_unmask0(unsigned int irq)
+iop13xx_irq_unmask0(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	write_intctl_0(read_intctl_0() | (1 << (irq - 0)));
 }
 
 static void
-iop13xx_irq_unmask1(unsigned int irq)
+iop13xx_irq_unmask1(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	write_intctl_1(read_intctl_1() | (1 << (irq - 32)));
 }
 
 static void
-iop13xx_irq_unmask2(unsigned int irq)
+iop13xx_irq_unmask2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	write_intctl_2(read_intctl_2() | (1 << (irq - 64)));
 }
 
 static void
-iop13xx_irq_unmask3(unsigned int irq)
+iop13xx_irq_unmask3(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
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
+static void iop13xx_msi_nop(struct irq_desc *desc)
 {
 	return;
 }
Index: linux-2.6/arch/arm/mach-iop32x/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-iop32x/irq.c
+++ linux-2.6/arch/arm/mach-iop32x/irq.c
@@ -32,15 +32,17 @@ static void intstr_write(u32 val)
 }
 
 static void
-iop32x_irq_mask(unsigned int irq)
+iop32x_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	iop32x_mask &= ~(1 << irq);
 	intctl_write(iop32x_mask);
 }
 
 static void
-iop32x_irq_unmask(unsigned int irq)
+iop32x_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	iop32x_mask |= 1 << irq;
 	intctl_write(iop32x_mask);
 }
Index: linux-2.6/arch/arm/mach-ixp2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/core.c
+++ linux-2.6/arch/arm/mach-ixp2000/core.c
@@ -309,8 +309,9 @@ static void ixp2000_GPIO_irq_handler(uns
 	}
 }
 
-static int ixp2000_GPIO_irq_type(unsigned int irq, unsigned int type)
+static int ixp2000_GPIO_irq_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int line = irq - IRQ_IXP2000_GPIO0;
 
 	/*
@@ -342,8 +343,9 @@ static int ixp2000_GPIO_irq_type(unsigne
 	return 0;
 }
 
-static void ixp2000_GPIO_irq_mask_ack(unsigned int irq)
+static void ixp2000_GPIO_irq_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_write(IXP2000_GPIO_INCR, (1 << (irq - IRQ_IXP2000_GPIO0)));
 
 	ixp2000_reg_write(IXP2000_GPIO_EDSR, (1 << (irq - IRQ_IXP2000_GPIO0)));
@@ -351,13 +353,15 @@ static void ixp2000_GPIO_irq_mask_ack(un
 	ixp2000_reg_wrb(IXP2000_GPIO_INST, (1 << (irq - IRQ_IXP2000_GPIO0)));
 }
 
-static void ixp2000_GPIO_irq_mask(unsigned int irq)
+static void ixp2000_GPIO_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_wrb(IXP2000_GPIO_INCR, (1 << (irq - IRQ_IXP2000_GPIO0)));
 }
 
-static void ixp2000_GPIO_irq_unmask(unsigned int irq)
+static void ixp2000_GPIO_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_write(IXP2000_GPIO_INSR, (1 << (irq - IRQ_IXP2000_GPIO0)));
 }
 
@@ -368,8 +372,9 @@ static struct irq_chip ixp2000_GPIO_irq_
 	.set_type	= ixp2000_GPIO_irq_type,
 };
 
-static void ixp2000_pci_irq_mask(unsigned int irq)
+static void ixp2000_pci_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long temp = *IXP2000_PCI_XSCALE_INT_ENABLE;
 	if (irq == IRQ_IXP2000_PCIA)
 		ixp2000_reg_wrb(IXP2000_PCI_XSCALE_INT_ENABLE, (temp & ~(1 << 26)));
@@ -377,8 +382,9 @@ static void ixp2000_pci_irq_mask(unsigne
 		ixp2000_reg_wrb(IXP2000_PCI_XSCALE_INT_ENABLE, (temp & ~(1 << 27)));
 }
 
-static void ixp2000_pci_irq_unmask(unsigned int irq)
+static void ixp2000_pci_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long temp = *IXP2000_PCI_XSCALE_INT_ENABLE;
 	if (irq == IRQ_IXP2000_PCIA)
 		ixp2000_reg_write(IXP2000_PCI_XSCALE_INT_ENABLE, (temp | (1 << 26)));
@@ -401,14 +407,16 @@ static void ixp2000_err_irq_handler(unsi
 	}
 }
 
-static void ixp2000_err_irq_mask(unsigned int irq)
+static void ixp2000_err_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_write(IXP2000_IRQ_ERR_ENABLE_CLR,
 			(1 << (irq - IRQ_IXP2000_DRAM0_MIN_ERR)));
 }
 
-static void ixp2000_err_irq_unmask(unsigned int irq)
+static void ixp2000_err_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_write(IXP2000_IRQ_ERR_ENABLE_SET,
 			(1 << (irq - IRQ_IXP2000_DRAM0_MIN_ERR)));
 }
@@ -425,13 +433,15 @@ static struct irq_chip ixp2000_pci_irq_c
 	.unmask	= ixp2000_pci_irq_unmask
 };
 
-static void ixp2000_irq_mask(unsigned int irq)
+static void ixp2000_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_wrb(IXP2000_IRQ_ENABLE_CLR, (1 << irq));
 }
 
-static void ixp2000_irq_unmask(unsigned int irq)
+static void ixp2000_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_write(IXP2000_IRQ_ENABLE_SET, (1 << irq));
 }
 
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2x00.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -64,8 +64,9 @@ static struct slowport_cfg slowport_cpld
 };
 #endif
 
-static void ixdp2x00_irq_mask(unsigned int irq)
+static void ixdp2x00_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long dummy;
 	static struct slowport_cfg old_cfg;
 
@@ -88,8 +89,9 @@ static void ixdp2x00_irq_mask(unsigned i
 #endif
 }
 
-static void ixdp2x00_irq_unmask(unsigned int irq)
+static void ixdp2x00_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long dummy;
 	static struct slowport_cfg old_cfg;
 
@@ -112,7 +114,7 @@ static void ixdp2x00_irq_handler(unsigne
 	static struct slowport_cfg old_cfg;
 	int i;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(desc);
 
 #ifdef CONFIG_ARCH_IXDP2400
 	if (machine_is_ixdp2400())
@@ -134,7 +136,7 @@ static void ixdp2x00_irq_handler(unsigne
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static struct irq_chip ixdp2x00_cpld_irq_chip = {
Index: linux-2.6/arch/arm/mach-ixp2000/ixdp2x01.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/ixdp2x01.c
+++ linux-2.6/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -49,14 +49,16 @@
 /*************************************************************************
  * IXDP2x01 IRQ Handling
  *************************************************************************/
-static void ixdp2x01_irq_mask(unsigned int irq)
+static void ixdp2x01_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_wrb(IXDP2X01_INT_MASK_SET_REG,
 				IXP2000_BOARD_IRQ_MASK(irq));
 }
 
-static void ixdp2x01_irq_unmask(unsigned int irq)
+static void ixdp2x01_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ixp2000_reg_write(IXDP2X01_INT_MASK_CLR_REG,
 				IXP2000_BOARD_IRQ_MASK(irq));
 }
@@ -68,7 +70,7 @@ static void ixdp2x01_irq_handler(unsigne
 	u32 ex_interrupt;
 	int i;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(desc);
 
 	ex_interrupt = *IXDP2X01_INT_STAT_REG & valid_irq_mask;
 
@@ -84,7 +86,7 @@ static void ixdp2x01_irq_handler(unsigne
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static struct irq_chip ixdp2x01_irq_chip = {
Index: linux-2.6/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp23xx/core.c
+++ linux-2.6/arch/arm/mach-ixp23xx/core.c
@@ -111,8 +111,9 @@ enum ixp23xx_irq_type {
 
 static void ixp23xx_config_irq(unsigned int, enum ixp23xx_irq_type);
 
-static int ixp23xx_irq_set_type(unsigned int irq, unsigned int type)
+static int ixp23xx_irq_set_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int line = irq - IRQ_IXP23XX_GPIO6 + 6;
 	u32 int_style;
 	enum ixp23xx_irq_type irq_type;
@@ -173,8 +174,9 @@ static int ixp23xx_irq_set_type(unsigned
 	return 0;
 }
 
-static void ixp23xx_irq_mask(unsigned int irq)
+static void ixp23xx_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	volatile unsigned long *intr_reg;
 
 	if (irq >= 56)
@@ -184,8 +186,9 @@ static void ixp23xx_irq_mask(unsigned in
 	*intr_reg &= ~(1 << (irq % 32));
 }
 
-static void ixp23xx_irq_ack(unsigned int irq)
+static void ixp23xx_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int line = irq - IRQ_IXP23XX_GPIO6 + 6;
 
 	if ((line < 6) || (line > 15))
@@ -198,11 +201,12 @@ static void ixp23xx_irq_ack(unsigned int
  * Level triggered interrupts on GPIO lines can only be cleared when the
  * interrupt condition disappears.
  */
-static void ixp23xx_irq_level_unmask(unsigned int irq)
+static void ixp23xx_irq_level_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	volatile unsigned long *intr_reg;
 
-	ixp23xx_irq_ack(irq);
+	ixp23xx_irq_ack(desc);
 
 	if (irq >= 56)
 		irq += 8;
@@ -211,8 +215,9 @@ static void ixp23xx_irq_level_unmask(uns
 	*intr_reg |= (1 << (irq % 32));
 }
 
-static void ixp23xx_irq_edge_unmask(unsigned int irq)
+static void ixp23xx_irq_edge_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	volatile unsigned long *intr_reg;
 
 	if (irq >= 56)
@@ -236,12 +241,12 @@ static struct irq_chip ixp23xx_irq_edge_
 	.set_type	= ixp23xx_irq_set_type
 };
 
-static void ixp23xx_pci_irq_mask(unsigned int irq)
+static void ixp23xx_pci_irq_mask(struct irq_desc *desc)
 {
 	*IXP23XX_PCI_XSCALE_INT_ENABLE &= ~(1 << (IRQ_IXP23XX_INTA + 27 - irq));
 }
 
-static void ixp23xx_pci_irq_unmask(unsigned int irq)
+static void ixp23xx_pci_irq_unmask(struct irq_desc *desc)
 {
 	*IXP23XX_PCI_XSCALE_INT_ENABLE |= (1 << (IRQ_IXP23XX_INTA + 27 - irq));
 }
@@ -256,7 +261,7 @@ static void pci_handler(unsigned int irq
 
 	pci_interrupt = *IXP23XX_PCI_XSCALE_INT_STATUS;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
 	/* See which PCI_INTA, or PCI_INTB interrupted */
 	if (pci_interrupt & (1 << 26)) {
@@ -269,7 +274,7 @@ static void pci_handler(unsigned int irq
 
 	generic_handle_irq(irqno);
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static struct irq_chip ixp23xx_pci_irq_chip = {
Index: linux-2.6/arch/arm/mach-ixp23xx/ixdp2351.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp23xx/ixdp2351.c
+++ linux-2.6/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -48,13 +48,15 @@
 /*
  * IXDP2351 Interrupt Handling
  */
-static void ixdp2351_inta_mask(unsigned int irq)
+static void ixdp2351_inta_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	*IXDP2351_CPLD_INTA_MASK_SET_REG = IXDP2351_INTA_IRQ_MASK(irq);
 }
 
-static void ixdp2351_inta_unmask(unsigned int irq)
+static void ixdp2351_inta_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	*IXDP2351_CPLD_INTA_MASK_CLR_REG = IXDP2351_INTA_IRQ_MASK(irq);
 }
 
@@ -64,7 +66,7 @@ static void ixdp2351_inta_handler(unsign
 		*IXDP2351_CPLD_INTA_STAT_REG & IXDP2351_INTA_IRQ_VALID;
 	int i;
 
-	desc->chip->mask(irq);
+	desc->chip->mask(desc);
 
 	for (i = 0; i < IXDP2351_INTA_IRQ_NUM; i++) {
 		if (ex_interrupt & (1 << i)) {
@@ -74,7 +76,7 @@ static void ixdp2351_inta_handler(unsign
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static struct irq_chip ixdp2351_inta_chip = {
@@ -83,13 +85,15 @@ static struct irq_chip ixdp2351_inta_chi
 	.unmask	= ixdp2351_inta_unmask
 };
 
-static void ixdp2351_intb_mask(unsigned int irq)
+static void ixdp2351_intb_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	*IXDP2351_CPLD_INTB_MASK_SET_REG = IXDP2351_INTB_IRQ_MASK(irq);
 }
 
-static void ixdp2351_intb_unmask(unsigned int irq)
+static void ixdp2351_intb_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	*IXDP2351_CPLD_INTB_MASK_CLR_REG = IXDP2351_INTB_IRQ_MASK(irq);
 }
 
@@ -99,7 +103,7 @@ static void ixdp2351_intb_handler(unsign
 		*IXDP2351_CPLD_INTB_STAT_REG & IXDP2351_INTB_IRQ_VALID;
 	int i;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
 	for (i = 0; i < IXDP2351_INTB_IRQ_NUM; i++) {
 		if (ex_interrupt & (1 << i)) {
@@ -109,7 +113,7 @@ static void ixdp2351_intb_handler(unsign
 		}
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static struct irq_chip ixdp2351_intb_chip = {
Index: linux-2.6/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6/arch/arm/mach-ixp4xx/common.c
@@ -128,8 +128,9 @@ int irq_to_gpio(unsigned int irq)
 }
 EXPORT_SYMBOL(irq_to_gpio);
 
-static int ixp4xx_set_irq_type(unsigned int irq, unsigned int type)
+static int ixp4xx_set_irq_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int line = irq2gpio[irq];
 	u32 int_style;
 	enum ixp4xx_irq_type irq_type;
@@ -193,16 +194,18 @@ static int ixp4xx_set_irq_type(unsigned
 	return 0;
 }
 
-static void ixp4xx_irq_mask(unsigned int irq)
+static void ixp4xx_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if ((cpu_is_ixp46x() || cpu_is_ixp43x()) && irq >= 32)
 		*IXP4XX_ICMR2 &= ~(1 << (irq - 32));
 	else
 		*IXP4XX_ICMR &= ~(1 << irq);
 }
 
-static void ixp4xx_irq_ack(unsigned int irq)
+static void ixp4xx_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int line = (irq < 32) ? irq2gpio[irq] : -1;
 
 	if (line >= 0)
@@ -213,10 +216,11 @@ static void ixp4xx_irq_ack(unsigned int
  * Level triggered interrupts on GPIO lines can only be cleared when the
  * interrupt condition disappears.
  */
-static void ixp4xx_irq_unmask(unsigned int irq)
+static void ixp4xx_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (!(ixp4xx_irq_edge & (1 << irq)))
-		ixp4xx_irq_ack(irq);
+		ixp4xx_irq_ack(desc);
 
 	if ((cpu_is_ixp46x() || cpu_is_ixp43x()) && irq >= 32)
 		*IXP4XX_ICMR2 |= (1 << (irq - 32));
Index: linux-2.6/arch/arm/mach-ks8695/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ks8695/irq.c
+++ linux-2.6/arch/arm/mach-ks8695/irq.c
@@ -34,29 +34,32 @@
 #include <mach/regs-irq.h>
 #include <mach/regs-gpio.h>
 
-static void ks8695_irq_mask(unsigned int irqno)
+static void ks8695_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long inten;
 
 	inten = __raw_readl(KS8695_IRQ_VA + KS8695_INTEN);
-	inten &= ~(1 << irqno);
+	inten &= ~(1 << irq);
 
 	__raw_writel(inten, KS8695_IRQ_VA + KS8695_INTEN);
 }
 
-static void ks8695_irq_unmask(unsigned int irqno)
+static void ks8695_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long inten;
 
 	inten = __raw_readl(KS8695_IRQ_VA + KS8695_INTEN);
-	inten |= (1 << irqno);
+	inten |= (1 << irq);
 
 	__raw_writel(inten, KS8695_IRQ_VA + KS8695_INTEN);
 }
 
-static void ks8695_irq_ack(unsigned int irqno)
+static void ks8695_irq_ack(struct irq_desc *desc)
 {
-	__raw_writel((1 << irqno), KS8695_IRQ_VA + KS8695_INTST);
+	unsigned int irq = desc->irq;
+	__raw_writel((1 << irq), KS8695_IRQ_VA + KS8695_INTST);
 }
 
 
@@ -64,8 +67,9 @@ static struct irq_chip ks8695_irq_level_
 static struct irq_chip ks8695_irq_edge_chip;
 
 
-static int ks8695_irq_set_type(unsigned int irqno, unsigned int type)
+static int ks8695_irq_set_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	unsigned long ctrl, mode;
 	unsigned short level_triggered = 0;
 
@@ -93,7 +97,7 @@ static int ks8695_irq_set_type(unsigned
 			return -EINVAL;
 	}
 
-	switch (irqno) {
+	switch (irq) {
 		case KS8695_IRQ_EXTERN0:
 			ctrl &= ~IOPC_IOEINT0TM;
 			ctrl |= IOPC_IOEINT0_MODE(mode);
@@ -115,12 +119,12 @@ static int ks8695_irq_set_type(unsigned
 	}
 
 	if (level_triggered) {
-		set_irq_chip(irqno, &ks8695_irq_level_chip);
-		set_irq_handler(irqno, handle_level_irq);
+		set_irq_chip(irq, &ks8695_irq_level_chip);
+		set_irq_handler(irq, handle_level_irq);
 	}
 	else {
-		set_irq_chip(irqno, &ks8695_irq_edge_chip);
-		set_irq_handler(irqno, handle_edge_irq);
+		set_irq_chip(irq, &ks8695_irq_edge_chip);
+		set_irq_handler(irq, handle_edge_irq);
 	}
 
 	__raw_writel(ctrl, KS8695_GPIO_VA + KS8695_IOPC);
Index: linux-2.6/arch/arm/mach-l7200/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-l7200/core.c
+++ linux-2.6/arch/arm/mach-l7200/core.c
@@ -45,13 +45,15 @@
 #define FIQ_SOFT	(*(volatile unsigned long *) (IRQ_BASE + 0x110))
 #define FIQ_SOURCESEL	(*(volatile unsigned long *) (IRQ_BASE + 0x118))
 
-static void l7200_mask_irq(unsigned int irq)
+static void l7200_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	IRQ_ENABLECLEAR = 1 << irq;
 }
 
-static void l7200_unmask_irq(unsigned int irq)
+static void l7200_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	IRQ_ENABLE = 1 << irq;
 }
 
Index: linux-2.6/arch/arm/mach-lh7a40x/arch-kev7a400.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/arch-kev7a400.c
+++ linux-2.6/arch/arm/mach-lh7a40x/arch-kev7a400.c
@@ -46,19 +46,22 @@ void __init kev7a400_map_io(void)
 
 static u16 CPLD_IRQ_mask;	/* Mask for CPLD IRQs, 1 == unmasked */
 
-static void kev7a400_ack_cpld_irq (u32 irq)
+static void kev7a400_ack_cpld_irq(u32 irq, struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	CPLD_CL_INT = 1 << (irq - IRQ_KEV7A400_CPLD);
 }
 
-static void kev7a400_mask_cpld_irq (u32 irq)
+static void kev7a400_mask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	CPLD_IRQ_mask &= ~(1 << (irq - IRQ_KEV7A400_CPLD));
 	CPLD_WR_PB_INT_MASK = CPLD_IRQ_mask;
 }
 
-static void kev7a400_unmask_cpld_irq (u32 irq)
+static void kev7a400_unmask_cpld_irq(u32 irq, struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	CPLD_IRQ_mask |= 1 << (irq - IRQ_KEV7A400_CPLD);
 	CPLD_WR_PB_INT_MASK = CPLD_IRQ_mask;
 }
Index: linux-2.6/arch/arm/mach-lh7a40x/arch-lpd7a40x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/arch-lpd7a40x.c
+++ linux-2.6/arch/arm/mach-lh7a40x/arch-lpd7a40x.c
@@ -159,8 +159,9 @@ static void __init lpd7a40x_init (void)
 #endif
 }
 
-static void lh7a40x_ack_cpld_irq (u32 irq)
+static void lh7a40x_ack_cpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* CPLD doesn't have ack capability, but some devices may */
 
 #if defined (CPLD_INTMASK_TOUCH)
@@ -172,8 +173,9 @@ static void lh7a40x_ack_cpld_irq (u32 ir
 #endif
 }
 
-static void lh7a40x_mask_cpld_irq (u32 irq)
+static void lh7a40x_mask_cpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
 		CPLD_INTERRUPTS |= CPLD_INTMASK_ETHERNET;
@@ -186,8 +188,9 @@ static void lh7a40x_mask_cpld_irq (u32 i
 	}
 }
 
-static void lh7a40x_unmask_cpld_irq (u32 irq)
+static void lh7a40x_unmask_cpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
 		CPLD_INTERRUPTS &= ~CPLD_INTMASK_ETHERNET;
@@ -211,7 +214,7 @@ static void lpd7a40x_cpld_handler (unsig
 {
 	unsigned int mask = CPLD_INTERRUPTS;
 
-	desc->chip->ack (irq);
+	desc->chip->ack(desc);
 
 	if ((mask & (1<<0)) == 0)	/* WLAN */
 		generic_handle_irq(IRQ_LPD7A40X_ETH_INT);
@@ -221,7 +224,7 @@ static void lpd7a40x_cpld_handler (unsig
 		generic_handle_irq(IRQ_TOUCH);
 #endif
 
-	desc->chip->unmask (irq); /* Level-triggered need this */
+	desc->chip->unmask(desc); /* Level-triggered need this */
 }
 
 
Index: linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a400.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/irq-lh7a400.c
+++ linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a400.c
@@ -21,18 +21,21 @@
 
   /* CPU IRQ handling */
 
-static void lh7a400_mask_irq (u32 irq)
+static void lh7a400_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	INTC_INTENC = (1 << irq);
 }
 
-static void lh7a400_unmask_irq (u32 irq)
+static void lh7a400_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	INTC_INTENS = (1 << irq);
 }
 
-static void lh7a400_ack_gpio_irq (u32 irq)
+static void lh7a400_ack_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	GPIO_GPIOFEOI = (1 << IRQ_TO_GPIO (irq));
 	INTC_INTENC = (1 << irq);
 }
Index: linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a404.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/irq-lh7a404.c
+++ linux-2.6/arch/arm/mach-lh7a40x/irq-lh7a404.c
@@ -43,34 +43,40 @@ static unsigned char irq_pri_vic2[] = {
 
   /* CPU IRQ handling */
 
-static void lh7a404_vic1_mask_irq (u32 irq)
+static void lh7a404_vic1_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	VIC1_INTENCLR = (1 << irq);
 }
 
-static void lh7a404_vic1_unmask_irq (u32 irq)
+static void lh7a404_vic1_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	VIC1_INTEN = (1 << irq);
 }
 
-static void lh7a404_vic2_mask_irq (u32 irq)
+static void lh7a404_vic2_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	VIC2_INTENCLR = (1 << (irq - 32));
 }
 
-static void lh7a404_vic2_unmask_irq (u32 irq)
+static void lh7a404_vic2_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	VIC2_INTEN = (1 << (irq - 32));
 }
 
-static void lh7a404_vic1_ack_gpio_irq (u32 irq)
+static void lh7a404_vic1_ack_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	GPIO_GPIOFEOI = (1 << IRQ_TO_GPIO (irq));
 	VIC1_INTENCLR = (1 << irq);
 }
 
-static void lh7a404_vic2_ack_gpio_irq (u32 irq)
+static void lh7a404_vic2_ack_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	GPIO_GPIOFEOI = (1 << IRQ_TO_GPIO (irq));
 	VIC2_INTENCLR = (1 << irq);
 }
Index: linux-2.6/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
+++ linux-2.6/arch/arm/mach-lh7a40x/irq-lpd7a40x.c
@@ -20,13 +20,14 @@
 
 #include "common.h"
 
-static void lh7a40x_ack_cpld_irq (u32 irq)
+static void lh7a40x_ack_cpld_irq(struct irq_desc *desc)
 {
 	/* CPLD doesn't have ack capability */
 }
 
-static void lh7a40x_mask_cpld_irq (u32 irq)
+static void lh7a40x_mask_cpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
 		CPLD_INTERRUPTS = CPLD_INTERRUPTS | 0x4;
@@ -37,8 +38,9 @@ static void lh7a40x_mask_cpld_irq (u32 i
 	}
 }
 
-static void lh7a40x_unmask_cpld_irq (u32 irq)
+static void lh7a40x_unmask_cpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	switch (irq) {
 	case IRQ_LPD7A40X_ETH_INT:
 		CPLD_INTERRUPTS = CPLD_INTERRUPTS & ~ 0x4;
@@ -60,7 +62,7 @@ static void lh7a40x_cpld_handler (unsign
 {
 	unsigned int mask = CPLD_INTERRUPTS;
 
-	desc->chip->ack (irq);
+	desc->chip->ack(desc);
 
 	if ((mask & 0x1) == 0)	/* WLAN */
 		generic_handle_irq(IRQ_LPD7A40X_ETH_INT);
@@ -68,7 +70,7 @@ static void lh7a40x_cpld_handler (unsign
 	if ((mask & 0x2) == 0)	/* Touch */
 		generic_handle_irq(IRQ_LPD7A400_TS);
 
-	desc->chip->unmask (irq); /* Level-triggered need this */
+	desc->chip->unmask(desc); /* Level-triggered need this */
 }
 
 
Index: linux-2.6/arch/arm/mach-mmp/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-mmp/irq.c
+++ linux-2.6/arch/arm/mach-mmp/irq.c
@@ -25,13 +25,15 @@
 #define PRIORITY_DEFAULT	0x1
 #define PRIORITY_NONE		0x0	/* means IRQ disabled */
 
-static void icu_mask_irq(unsigned int irq)
+static void icu_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(PRIORITY_NONE, ICU_INT_CONF(irq));
 }
 
-static void icu_unmask_irq(unsigned int irq)
+static void icu_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(IRQ_ROUTE_TO_AP | PRIORITY_DEFAULT, ICU_INT_CONF(irq));
 }
 
@@ -47,7 +49,7 @@ void __init icu_init_irq(void)
 	int irq;
 
 	for (irq = 0; irq < 64; irq++) {
-		icu_mask_irq(irq);
+		icu_mask_irq(irq_to_desc(irq));
 		set_irq_chip(irq, &icu_irq_chip);
 		set_irq_handler(irq, handle_level_irq);
 		set_irq_flags(irq, IRQF_VALID);
Index: linux-2.6/arch/arm/mach-mx3/mx31ads.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-mx3/mx31ads.c
+++ linux-2.6/arch/arm/mach-mx3/mx31ads.c
@@ -142,8 +142,9 @@ static void mx31ads_expio_irq_handler(u3
  * Disable an expio pin's interrupt by setting the bit in the imr.
  * @param irq           an expio virtual irq number
  */
-static void expio_mask_irq(u32 irq)
+static void expio_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 expio = MXC_IRQ_TO_EXPIO(irq);
 	/* mask the interrupt */
 	__raw_writew(1 << expio, PBC_INTMASK_CLEAR_REG);
@@ -154,8 +155,9 @@ static void expio_mask_irq(u32 irq)
  * Acknowledge an expanded io pin's interrupt by clearing the bit in the isr.
  * @param irq           an expanded io virtual irq number
  */
-static void expio_ack_irq(u32 irq)
+static void expio_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 expio = MXC_IRQ_TO_EXPIO(irq);
 	/* clear the interrupt status */
 	__raw_writew(1 << expio, PBC_INTSTATUS_REG);
@@ -165,8 +167,9 @@ static void expio_ack_irq(u32 irq)
  * Enable a expio pin's interrupt by clearing the bit in the imr.
  * @param irq           a expio virtual irq number
  */
-static void expio_unmask_irq(u32 irq)
+static void expio_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 expio = MXC_IRQ_TO_EXPIO(irq);
 	/* unmask the interrupt */
 	__raw_writew(1 << expio, PBC_INTMASK_SET_REG);
Index: linux-2.6/arch/arm/mach-mx3/mx31pdk.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-mx3/mx31pdk.c
+++ linux-2.6/arch/arm/mach-mx3/mx31pdk.c
@@ -116,8 +116,9 @@ static void mx31pdk_expio_irq_handler(ui
  * Disable an expio pin's interrupt by setting the bit in the imr.
  * @param irq           an expio virtual irq number
  */
-static void expio_mask_irq(uint32_t irq)
+static void expio_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t reg;
 	uint32_t expio = MXC_IRQ_TO_EXPIO(irq);
 
@@ -131,8 +132,9 @@ static void expio_mask_irq(uint32_t irq)
  * Acknowledge an expanded io pin's interrupt by clearing the bit in the isr.
  * @param irq           an expanded io virtual irq number
  */
-static void expio_ack_irq(uint32_t irq)
+static void expio_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint32_t expio = MXC_IRQ_TO_EXPIO(irq);
 
 	/* clear the interrupt status */
@@ -146,8 +148,9 @@ static void expio_ack_irq(uint32_t irq)
  * Enable a expio pin's interrupt by clearing the bit in the imr.
  * @param irq           a expio virtual irq number
  */
-static void expio_unmask_irq(uint32_t irq)
+static void expio_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t reg;
 	uint32_t expio = MXC_IRQ_TO_EXPIO(irq);
 
Index: linux-2.6/arch/arm/mach-netx/generic.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-netx/generic.c
+++ linux-2.6/arch/arm/mach-netx/generic.c
@@ -88,8 +88,9 @@ netx_hif_demux_handler(unsigned int irq_
 }
 
 static int
-netx_hif_irq_type(unsigned int _irq, unsigned int type)
+netx_hif_irq_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int _irq = desc->irq;
 	unsigned int val, irq;
 
 	val = readl(NETX_DPMAS_IF_CONF1);
@@ -119,8 +120,9 @@ netx_hif_irq_type(unsigned int _irq, uns
 }
 
 static void
-netx_hif_ack_irq(unsigned int _irq)
+netx_hif_ack_irq(struct irq_desc *desc)
 {
+	unsigned int _irq = desc->irq;
 	unsigned int val, irq;
 
 	irq = _irq - NETX_IRQ_HIF_CHAINED(0);
@@ -134,8 +136,9 @@ netx_hif_ack_irq(unsigned int _irq)
 }
 
 static void
-netx_hif_mask_irq(unsigned int _irq)
+netx_hif_mask_irq(struct irq_desc *desc)
 {
+	unsigned int _irq = desc->irq;
 	unsigned int val, irq;
 
 	irq = _irq - NETX_IRQ_HIF_CHAINED(0);
@@ -146,8 +149,9 @@ netx_hif_mask_irq(unsigned int _irq)
 }
 
 static void
-netx_hif_unmask_irq(unsigned int _irq)
+netx_hif_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int _irq = desc->irq;
 	unsigned int val, irq;
 
 	irq = _irq - NETX_IRQ_HIF_CHAINED(0);
Index: linux-2.6/arch/arm/mach-nomadik/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-nomadik/gpio.c
+++ linux-2.6/arch/arm/mach-nomadik/gpio.c
@@ -95,27 +95,29 @@ static inline int nmk_gpio_get_bitmask(i
 	return 1 << (gpio % 32);
 }
 
-static void nmk_gpio_irq_ack(unsigned int irq)
+static void nmk_gpio_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
 
 	gpio = NOMADIK_IRQ_TO_GPIO(irq);
-	nmk_chip = get_irq_chip_data(irq);
+	nmk_chip = get_irq_desc_chip_data(desc);
 	if (!nmk_chip)
 		return;
 	writel(nmk_gpio_get_bitmask(gpio), nmk_chip->addr + NMK_GPIO_IC);
 }
 
-static void nmk_gpio_irq_mask(unsigned int irq)
+static void nmk_gpio_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
 	u32 bitmask, reg;
 
 	gpio = NOMADIK_IRQ_TO_GPIO(irq);
-	nmk_chip = get_irq_chip_data(irq);
+	nmk_chip = get_irq_desc_chip_data(desc);
 	bitmask = nmk_gpio_get_bitmask(gpio);
 	if (!nmk_chip)
 		return;
@@ -135,15 +137,16 @@ static void nmk_gpio_irq_mask(unsigned i
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
 };
 
-static void nmk_gpio_irq_unmask(unsigned int irq)
+static void nmk_gpio_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
 	u32 bitmask, reg;
 
 	gpio = NOMADIK_IRQ_TO_GPIO(irq);
-	nmk_chip = get_irq_chip_data(irq);
+	nmk_chip = get_irq_desc_chip_data(desc);
 	bitmask = nmk_gpio_get_bitmask(gpio);
 	if (!nmk_chip)
 		return;
@@ -163,15 +166,16 @@ static void nmk_gpio_irq_unmask(unsigned
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
 }
 
-static int nmk_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int nmk_gpio_irq_set_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int gpio;
 	struct nmk_gpio_chip *nmk_chip;
 	unsigned long flags;
 	u32 bitmask;
 
 	gpio = NOMADIK_IRQ_TO_GPIO(irq);
-	nmk_chip = get_irq_chip_data(irq);
+	nmk_chip = get_irq_desc_chip_data(desc);
 	bitmask = nmk_gpio_get_bitmask(gpio);
 	if (!nmk_chip)
 		return -EINVAL;
@@ -195,7 +199,7 @@ static int nmk_gpio_irq_set_type(unsigne
 
 	spin_unlock_irqrestore(&nmk_chip->lock, flags);
 
-	nmk_gpio_irq_unmask(irq);
+	nmk_gpio_irq_unmask(desc);
 
 	return 0;
 }
@@ -216,7 +220,7 @@ static void nmk_gpio_irq_handler(unsigne
 	u32 pending;
 	unsigned int first_irq;
 
-	nmk_chip = get_irq_data(irq);
+	nmk_chip = get_irq_desc_data(desc);
 	first_irq = NOMADIK_GPIO_TO_IRQ(nmk_chip->chip.base);
 	while ( (pending = readl(nmk_chip->addr + NMK_GPIO_IS)) ) {
 		gpio_irq = first_irq + __ffs(pending);
@@ -224,7 +228,7 @@ static void nmk_gpio_irq_handler(unsigne
 	}
 	if (0) {/* don't ack parent irq, as ack == disable */
 		host_chip = get_irq_chip(irq);
-		host_chip->ack(irq);
+		host_chip->ack(desc);
 	}
 }
 
Index: linux-2.6/arch/arm/mach-ns9xxx/board-a9m9750dev.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/board-a9m9750dev.c
+++ linux-2.6/arch/arm/mach-ns9xxx/board-a9m9750dev.c
@@ -37,13 +37,14 @@ void __init board_a9m9750dev_map_io(void
 		     ARRAY_SIZE(board_a9m9750dev_io_desc));
 }
 
-static void a9m9750dev_fpga_ack_irq(unsigned int irq)
+static void a9m9750dev_fpga_ack_irq(struct irq_desc *desc)
 {
 	/* nothing */
 }
 
-static void a9m9750dev_fpga_mask_irq(unsigned int irq)
+static void a9m9750dev_fpga_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 ier;
 
 	ier = __raw_readb(FPGA_IER);
@@ -53,14 +54,16 @@ static void a9m9750dev_fpga_mask_irq(uns
 	__raw_writeb(ier, FPGA_IER);
 }
 
-static void a9m9750dev_fpga_maskack_irq(unsigned int irq)
+static void a9m9750dev_fpga_maskack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	a9m9750dev_fpga_mask_irq(irq);
 	a9m9750dev_fpga_ack_irq(irq);
 }
 
-static void a9m9750dev_fpga_unmask_irq(unsigned int irq)
+static void a9m9750dev_fpga_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 ier;
 
 	ier = __raw_readb(FPGA_IER);
@@ -82,7 +85,7 @@ static void a9m9750dev_fpga_demux_handle
 {
 	u8 stat = __raw_readb(FPGA_ISR);
 
-	desc->chip->mask_ack(irq);
+	desc->chip->mask_ack(desc);
 
 	while (stat != 0) {
 		int irqno = fls(stat) - 1;
@@ -92,7 +95,7 @@ static void a9m9750dev_fpga_demux_handle
 		generic_handle_irq(FPGA_IRQ(irqno));
 	}
 
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 void __init board_a9m9750dev_init_irq(void)
Index: linux-2.6/arch/arm/mach-ns9xxx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/irq.c
+++ linux-2.6/arch/arm/mach-ns9xxx/irq.c
@@ -22,8 +22,9 @@
 #define irq2prio(i) (i)
 #define prio2irq(p) (p)
 
-static void ns9xxx_mask_irq(unsigned int irq)
+static void ns9xxx_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* XXX: better use cpp symbols */
 	int prio = irq2prio(irq);
 	u32 ic = __raw_readl(SYS_IC(prio / 4));
@@ -31,19 +32,21 @@ static void ns9xxx_mask_irq(unsigned int
 	__raw_writel(ic, SYS_IC(prio / 4));
 }
 
-static void ns9xxx_ack_irq(unsigned int irq)
+static void ns9xxx_ack_irq(struct irq_desc *desc)
 {
 	__raw_writel(0, SYS_ISRADDR);
 }
 
-static void ns9xxx_maskack_irq(unsigned int irq)
+static void ns9xxx_maskack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ns9xxx_mask_irq(irq);
 	ns9xxx_ack_irq(irq);
 }
 
-static void ns9xxx_unmask_irq(unsigned int irq)
+static void ns9xxx_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* XXX: better use cpp symbols */
 	int prio = irq2prio(irq);
 	u32 ic = __raw_readl(SYS_IC(prio / 4));
@@ -92,10 +95,10 @@ static void handle_prio_irq(unsigned int
 
 	if (desc->status & IRQ_DISABLED)
 out_mask:
-		desc->chip->mask(irq);
+		desc->chip->mask(desc);
 
 	/* ack unconditionally to unmask lower prio irqs */
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
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
+static void fpga_mask_irq(struct irq_desc *desc)
 {
 	irq -= OMAP_FPGA_IRQ_BASE;
 
@@ -58,13 +58,14 @@ static inline u32 get_fpga_unmasked_irqs
 }
 
 
-static void fpga_ack_irq(unsigned int irq)
+static void fpga_ack_irq(struct irq_desc *desc)
 {
 	/* Don't need to explicitly ACK FPGA interrupts */
 }
 
-static void fpga_unmask_irq(unsigned int irq)
+static void fpga_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= OMAP_FPGA_IRQ_BASE;
 
 	if (irq < 8)
@@ -78,10 +79,10 @@ static void fpga_unmask_irq(unsigned int
 			      | (1 << (irq - 16))), INNOVATOR_FPGA_IMR2);
 }
 
-static void fpga_mask_ack_irq(unsigned int irq)
+static void fpga_mask_ack_irq(struct irq_desc *desc)
 {
-	fpga_mask_irq(irq);
-	fpga_ack_irq(irq);
+	fpga_mask_irq(desc);
+	fpga_ack_irq(desc);
 }
 
 void innovator_fpga_IRQ_demux(unsigned int irq, struct irq_desc *desc)
Index: linux-2.6/arch/arm/mach-omap1/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/irq.c
+++ linux-2.6/arch/arm/mach-omap1/irq.c
@@ -70,16 +70,18 @@ static inline void irq_bank_writel(unsig
 	omap_writel(value, irq_banks[bank].base_reg + offset);
 }
 
-static void omap_ack_irq(unsigned int irq)
+static void omap_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq > 31)
 		omap_writel(0x1, OMAP_IH2_BASE + IRQ_CONTROL_REG_OFFSET);
 
 	omap_writel(0x1, OMAP_IH1_BASE + IRQ_CONTROL_REG_OFFSET);
 }
 
-static void omap_mask_irq(unsigned int irq)
+static void omap_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int bank = IRQ_BANK(irq);
 	u32 l;
 
@@ -88,8 +90,9 @@ static void omap_mask_irq(unsigned int i
 	omap_writel(l, irq_banks[bank].base_reg + IRQ_MIR_REG_OFFSET);
 }
 
-static void omap_unmask_irq(unsigned int irq)
+static void omap_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int bank = IRQ_BANK(irq);
 	u32 l;
 
@@ -98,14 +101,15 @@ static void omap_unmask_irq(unsigned int
 	omap_writel(l, irq_banks[bank].base_reg + IRQ_MIR_REG_OFFSET);
 }
 
-static void omap_mask_ack_irq(unsigned int irq)
+static void omap_mask_ack_irq(struct irq_desc *desc)
 {
-	omap_mask_irq(irq);
-	omap_ack_irq(irq);
+	omap_mask_irq(desc);
+	omap_ack_irq(desc);
 }
 
-static int omap_wake_irq(unsigned int irq, unsigned int enable)
+static int omap_wake_irq(struct irq_desc *desc, unsigned int enable)
 {
+	unsigned int irq = desc->irq;
 	int bank = IRQ_BANK(irq);
 
 	if (enable)
@@ -234,9 +238,9 @@ void __init omap_init_irq(void)
 	/* Unmask level 2 handler */
 
 	if (cpu_is_omap7xx())
-		omap_unmask_irq(INT_7XX_IH2_IRQ);
+		omap_unmask_irq(irq_to_desc(INT_7XX_IH2_IRQ));
 	else if (cpu_is_omap15xx())
-		omap_unmask_irq(INT_1510_IH2_IRQ);
+		omap_unmask_irq(irq_to_desc(INT_1510_IH2_IRQ));
 	else if (cpu_is_omap16xx())
-		omap_unmask_irq(INT_1610_IH2_IRQ);
+		omap_unmask_irq(irq_to_desc(INT_1610_IH2_IRQ));
 }
Index: linux-2.6/arch/arm/mach-pnx4008/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pnx4008/irq.c
+++ linux-2.6/arch/arm/mach-pnx4008/irq.c
@@ -36,24 +36,28 @@
 
 static u8 pnx4008_irq_type[NR_IRQS] = PNX4008_IRQ_TYPES;
 
-static void pnx4008_mask_irq(unsigned int irq)
+static void pnx4008_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(__raw_readl(INTC_ER(irq)) & ~INTC_BIT(irq), INTC_ER(irq));	/* mask interrupt */
 }
 
-static void pnx4008_unmask_irq(unsigned int irq)
+static void pnx4008_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(__raw_readl(INTC_ER(irq)) | INTC_BIT(irq), INTC_ER(irq));	/* unmask interrupt */
 }
 
-static void pnx4008_mask_ack_irq(unsigned int irq)
+static void pnx4008_mask_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(__raw_readl(INTC_ER(irq)) & ~INTC_BIT(irq), INTC_ER(irq));	/* mask interrupt */
 	__raw_writel(INTC_BIT(irq), INTC_SR(irq));	/* clear interrupt status */
 }
 
-static int pnx4008_set_irq_type(unsigned int irq, unsigned int type)
+static int pnx4008_set_irq_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
 		__raw_writel(__raw_readl(INTC_ATR(irq)) | INTC_BIT(irq), INTC_ATR(irq));	/*edge sensitive */
Index: linux-2.6/arch/arm/mach-pxa/balloon3.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/balloon3.c
+++ linux-2.6/arch/arm/mach-pxa/balloon3.c
@@ -73,15 +73,17 @@ int __init parse_balloon3_features(char
 }
 early_param("balloon3_features", parse_balloon3_features);
 
-static void balloon3_mask_irq(unsigned int irq)
+static void balloon3_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int balloon3_irq = (irq - BALLOON3_IRQ(0));
 	balloon3_irq_enabled &= ~(1 << balloon3_irq);
 	__raw_writel(~balloon3_irq_enabled, BALLOON3_INT_CONTROL_REG);
 }
 
-static void balloon3_unmask_irq(unsigned int irq)
+static void balloon3_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int balloon3_irq = (irq - BALLOON3_IRQ(0));
 	balloon3_irq_enabled |= (1 << balloon3_irq);
 	__raw_writel(~balloon3_irq_enabled, BALLOON3_INT_CONTROL_REG);
@@ -102,7 +104,7 @@ static void balloon3_irq_handler(unsigne
 	do {
 		/* clear useless edge notification */
 		if (desc->chip->ack)
-			desc->chip->ack(BALLOON3_AUX_NIRQ);
+			desc->chip->ack(irq_to_desc(BALLOON3_AUX_NIRQ));
 		while (pending) {
 			irq = BALLOON3_IRQ(0) + __ffs(pending);
 			generic_handle_irq(irq);
Index: linux-2.6/arch/arm/mach-pxa/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/irq.c
+++ linux-2.6/arch/arm/mach-pxa/irq.c
@@ -37,13 +37,15 @@
 
 static int pxa_internal_irq_nr;
 
-static void pxa_mask_irq(unsigned int irq)
+static void pxa_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	_ICMR(irq) &= ~(1 << IRQ_BIT(irq));
 }
 
-static void pxa_unmask_irq(unsigned int irq)
+static void pxa_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	_ICMR(irq) |= 1 << IRQ_BIT(irq);
 }
 
@@ -57,8 +59,9 @@ static struct irq_chip pxa_internal_irq_
 /*
  * GPIO IRQs for GPIO 0 and 1
  */
-static int pxa_set_low_gpio_type(unsigned int irq, unsigned int type)
+static int pxa_set_low_gpio_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int gpio = irq - IRQ_GPIO0;
 
 	if (__gpio_is_occupied(gpio)) {
@@ -79,18 +82,21 @@ static int pxa_set_low_gpio_type(unsigne
 	return 0;
 }
 
-static void pxa_ack_low_gpio(unsigned int irq)
+static void pxa_ack_low_gpio(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	GEDR0 = (1 << (irq - IRQ_GPIO0));
 }
 
-static void pxa_mask_low_gpio(unsigned int irq)
+static void pxa_mask_low_gpio(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR &= ~(1 << (irq - PXA_IRQ(0)));
 }
 
-static void pxa_unmask_low_gpio(unsigned int irq)
+static void pxa_unmask_low_gpio(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR |= 1 << (irq - PXA_IRQ(0));
 }
 
Index: linux-2.6/arch/arm/mach-pxa/lpd270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lpd270.c
+++ linux-2.6/arch/arm/mach-pxa/lpd270.c
@@ -90,8 +90,9 @@ static unsigned long lpd270_pin_config[]
 
 static unsigned int lpd270_irq_enabled;
 
-static void lpd270_mask_irq(unsigned int irq)
+static void lpd270_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int lpd270_irq = irq - LPD270_IRQ(0);
 
 	__raw_writew(~(1 << lpd270_irq), LPD270_INT_STATUS);
@@ -100,8 +101,9 @@ static void lpd270_mask_irq(unsigned int
 	__raw_writew(lpd270_irq_enabled, LPD270_INT_MASK);
 }
 
-static void lpd270_unmask_irq(unsigned int irq)
+static void lpd270_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int lpd270_irq = irq - LPD270_IRQ(0);
 
 	lpd270_irq_enabled |= 1 << lpd270_irq;
Index: linux-2.6/arch/arm/mach-pxa/lubbock.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/lubbock.c
+++ linux-2.6/arch/arm/mach-pxa/lubbock.c
@@ -133,14 +133,16 @@ EXPORT_SYMBOL(lubbock_set_misc_wr);
 
 static unsigned long lubbock_irq_enabled;
 
-static void lubbock_mask_irq(unsigned int irq)
+static void lubbock_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int lubbock_irq = (irq - LUBBOCK_IRQ(0));
 	LUB_IRQ_MASK_EN = (lubbock_irq_enabled &= ~(1 << lubbock_irq));
 }
 
-static void lubbock_unmask_irq(unsigned int irq)
+static void lubbock_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int lubbock_irq = (irq - LUBBOCK_IRQ(0));
 	/* the irq can be acknowledged only if deasserted, so it's done here */
 	LUB_IRQ_SET_CLR &= ~(1 << lubbock_irq);
Index: linux-2.6/arch/arm/mach-pxa/mainstone.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mainstone.c
+++ linux-2.6/arch/arm/mach-pxa/mainstone.c
@@ -137,14 +137,16 @@ static unsigned long mainstone_pin_confi
 
 static unsigned long mainstone_irq_enabled;
 
-static void mainstone_mask_irq(unsigned int irq)
+static void mainstone_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int mainstone_irq = (irq - MAINSTONE_IRQ(0));
 	MST_INTMSKENA = (mainstone_irq_enabled &= ~(1 << mainstone_irq));
 }
 
-static void mainstone_unmask_irq(unsigned int irq)
+static void mainstone_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int mainstone_irq = (irq - MAINSTONE_IRQ(0));
 	/* the irq can be acknowledged only if deasserted, so it's done here */
 	MST_INTSETCLR &= ~(1 << mainstone_irq);
Index: linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pcm990-baseboard.c
+++ linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -235,14 +235,16 @@ static struct platform_device pcm990_bac
 
 static unsigned long pcm990_irq_enabled;
 
-static void pcm990_mask_ack_irq(unsigned int irq)
+static void pcm990_mask_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pcm990_irq = (irq - PCM027_IRQ(0));
 	PCM990_INTMSKENA = (pcm990_irq_enabled &= ~(1 << pcm990_irq));
 }
 
-static void pcm990_unmask_irq(unsigned int irq)
+static void pcm990_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pcm990_irq = (irq - PCM027_IRQ(0));
 	/* the irq can be acknowledged only if deasserted, so it's done here */
 	PCM990_INTSETCLR |= 1 << pcm990_irq;
Index: linux-2.6/arch/arm/mach-pxa/pxa3xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pxa3xx.c
+++ linux-2.6/arch/arm/mach-pxa/pxa3xx.c
@@ -536,19 +536,22 @@ static inline void pxa3xx_init_pm(void)
 #define pxa3xx_set_wake	NULL
 #endif
 
-static void pxa_ack_ext_wakeup(unsigned int irq)
+static void pxa_ack_ext_wakeup(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	PECR |= PECR_IS(irq - IRQ_WAKEUP0);
 }
 
-static void pxa_mask_ext_wakeup(unsigned int irq)
+static void pxa_mask_ext_wakeup(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR2 &= ~(1 << ((irq - PXA_IRQ(0)) & 0x1f));
 	PECR &= ~PECR_IE(irq - IRQ_WAKEUP0);
 }
 
-static void pxa_unmask_ext_wakeup(unsigned int irq)
+static void pxa_unmask_ext_wakeup(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR2 |= 1 << ((irq - PXA_IRQ(0)) & 0x1f);
 	PECR |= PECR_IE(irq - IRQ_WAKEUP0);
 }
Index: linux-2.6/arch/arm/mach-pxa/viper.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/viper.c
+++ linux-2.6/arch/arm/mach-pxa/viper.c
@@ -247,8 +247,9 @@ static inline int viper_bit_to_irq(int b
 	return viper_isa_irqs[bit] + PXA_ISA_IRQ(0);
 }
 
-static void viper_ack_irq(unsigned int irq)
+static void viper_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int viper_irq = viper_irq_to_bitmask(irq);
 
 	if (viper_irq & 0xff)
@@ -257,13 +258,15 @@ static void viper_ack_irq(unsigned int i
 		VIPER_HI_IRQ_STATUS = (viper_irq >> 8);
 }
 
-static void viper_mask_irq(unsigned int irq)
+static void viper_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	viper_irq_enabled_mask &= ~(viper_irq_to_bitmask(irq));
 }
 
-static void viper_unmask_irq(unsigned int irq)
+static void viper_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	viper_irq_enabled_mask |= viper_irq_to_bitmask(irq);
 }
 
Index: linux-2.6/arch/arm/mach-pxa/zeus.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/zeus.c
+++ linux-2.6/arch/arm/mach-pxa/zeus.c
@@ -81,18 +81,21 @@ static inline int zeus_bit_to_irq(int bi
 	return zeus_isa_irqs[bit] + PXA_ISA_IRQ(0);
 }
 
-static void zeus_ack_irq(unsigned int irq)
+static void zeus_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writew(zeus_irq_to_bitmask(irq), ZEUS_CPLD_ISA_IRQ);
 }
 
-static void zeus_mask_irq(unsigned int irq)
+static void zeus_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	zeus_irq_enabled_mask &= ~(zeus_irq_to_bitmask(irq));
 }
 
-static void zeus_unmask_irq(unsigned int irq)
+static void zeus_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	zeus_irq_enabled_mask |= zeus_irq_to_bitmask(irq);
 }
 
@@ -109,7 +112,7 @@ static void zeus_irq_handler(unsigned in
 	do {
 		/* we're in a chained irq handler,
 		 * so ack the interrupt by hand */
-		desc->chip->ack(gpio_to_irq(ZEUS_ISA_GPIO));
+		desc->chip->ack(irq_to_desc(gipo_to_irq(ZEUS_ISA_GPIO));
 
 		if (likely(pending)) {
 			irq = zeus_bit_to_irq(__ffs(pending));
Index: linux-2.6/arch/arm/mach-rpc/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-rpc/irq.c
+++ linux-2.6/arch/arm/mach-rpc/irq.c
@@ -6,8 +6,9 @@
 #include <asm/hardware/iomd.h>
 #include <asm/irq.h>
 
-static void iomd_ack_irq_a(unsigned int irq)
+static void iomd_ack_irq_a(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << irq;
@@ -16,8 +17,9 @@ static void iomd_ack_irq_a(unsigned int
 	iomd_writeb(mask, IOMD_IRQCLRA);
 }
 
-static void iomd_mask_irq_a(unsigned int irq)
+static void iomd_mask_irq_a(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << irq;
@@ -25,8 +27,9 @@ static void iomd_mask_irq_a(unsigned int
 	iomd_writeb(val & ~mask, IOMD_IRQMASKA);
 }
 
-static void iomd_unmask_irq_a(unsigned int irq)
+static void iomd_unmask_irq_a(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << irq;
@@ -40,8 +43,9 @@ static struct irq_chip iomd_a_chip = {
 	.unmask = iomd_unmask_irq_a,
 };
 
-static void iomd_mask_irq_b(unsigned int irq)
+static void iomd_mask_irq_b(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << (irq & 7);
@@ -49,8 +53,9 @@ static void iomd_mask_irq_b(unsigned int
 	iomd_writeb(val & ~mask, IOMD_IRQMASKB);
 }
 
-static void iomd_unmask_irq_b(unsigned int irq)
+static void iomd_unmask_irq_b(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << (irq & 7);
@@ -64,8 +69,9 @@ static struct irq_chip iomd_b_chip = {
 	.unmask = iomd_unmask_irq_b,
 };
 
-static void iomd_mask_irq_dma(unsigned int irq)
+static void iomd_mask_irq_dma(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << (irq & 7);
@@ -73,8 +79,9 @@ static void iomd_mask_irq_dma(unsigned i
 	iomd_writeb(val & ~mask, IOMD_DMAMASK);
 }
 
-static void iomd_unmask_irq_dma(unsigned int irq)
+static void iomd_unmask_irq_dma(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << (irq & 7);
@@ -88,8 +95,9 @@ static struct irq_chip iomd_dma_chip = {
 	.unmask = iomd_unmask_irq_dma,
 };
 
-static void iomd_mask_irq_fiq(unsigned int irq)
+static void iomd_mask_irq_fiq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << (irq & 7);
@@ -97,8 +105,9 @@ static void iomd_mask_irq_fiq(unsigned i
 	iomd_writeb(val & ~mask, IOMD_FIQMASK);
 }
 
-static void iomd_unmask_irq_fiq(unsigned int irq)
+static void iomd_unmask_irq_fiq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int val, mask;
 
 	mask = 1 << (irq & 7);
Index: linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/bast-irq.c
+++ linux-2.6/arch/arm/mach-s3c2410/bast-irq.c
@@ -75,31 +75,31 @@ static unsigned char bast_pc104_irqmasks
 static unsigned char bast_pc104_irqs[] = { 3, 5, 7, 10 };
 
 static void
-bast_pc104_mask(unsigned int irqno)
+bast_pc104_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long temp;
 
 	temp = __raw_readb(BAST_VA_PC104_IRQMASK);
-	temp &= ~bast_pc104_irqmasks[irqno];
+	temp &= ~bast_pc104_irqmasks[irq];
 	__raw_writeb(temp, BAST_VA_PC104_IRQMASK);
 }
 
 static void
-bast_pc104_maskack(unsigned int irqno)
+bast_pc104_maskack(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc + IRQ_ISA;
-
-	bast_pc104_mask(irqno);
-	desc->chip->ack(IRQ_ISA);
+	bast_pc104_mask(desc);
+	desc->chip->ack(desc);
 }
 
 static void
-bast_pc104_unmask(unsigned int irqno)
+bast_pc104_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long temp;
 
 	temp = __raw_readb(BAST_VA_PC104_IRQMASK);
-	temp |= bast_pc104_irqmasks[irqno];
+	temp |= bast_pc104_irqmasks[irq];
 	__raw_writeb(temp, BAST_VA_PC104_IRQMASK);
 }
 
@@ -123,7 +123,7 @@ bast_irq_pc104_demux(unsigned int irq,
 		/* ack if we get an irq with nothing (ie, startup) */
 
 		desc = irq_desc + IRQ_ISA;
-		desc->chip->ack(IRQ_ISA);
+		desc->chip->ack(desc);
 	} else {
 		/* handle the IRQ */
 
Index: linux-2.6/arch/arm/mach-s3c2412/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2412/irq.c
+++ linux-2.6/arch/arm/mach-s3c2412/irq.c
@@ -49,9 +49,10 @@
 */
 
 static void
-s3c2412_irq_mask(unsigned int irqno)
+s3c2412_irq_mask(struct irq_desc *desc)
 {
-	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
+	unsigned int irq = desc->irq;
+	unsigned long bitval = 1UL << (irq - IRQ_EINT0);
 	unsigned long mask;
 
 	mask = __raw_readl(S3C2410_INTMSK);
@@ -62,9 +63,10 @@ s3c2412_irq_mask(unsigned int irqno)
 }
 
 static inline void
-s3c2412_irq_ack(unsigned int irqno)
+s3c2412_irq_ack(struct irq_desc *desc)
 {
-	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
+	unsigned int irq = desc->irq;
+	unsigned long bitval = 1UL << (irq - IRQ_EINT0);
 
 	__raw_writel(bitval, S3C2412_EINTPEND);
 	__raw_writel(bitval, S3C2410_SRCPND);
@@ -72,9 +74,10 @@ s3c2412_irq_ack(unsigned int irqno)
 }
 
 static inline void
-s3c2412_irq_maskack(unsigned int irqno)
+s3c2412_irq_maskack(struct irq_desc *desc)
 {
-	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
+	unsigned int irq = desc->irq;
+	unsigned long bitval = 1UL << (irq - IRQ_EINT0);
 	unsigned long mask;
 
 	mask = __raw_readl(S3C2410_INTMSK);
@@ -89,9 +92,10 @@ s3c2412_irq_maskack(unsigned int irqno)
 }
 
 static void
-s3c2412_irq_unmask(unsigned int irqno)
+s3c2412_irq_unmask(struct irq_desc *desc)
 {
-	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
+	unsigned int irq = desc->irq;
+	unsigned long bitval = 1UL << (irq - IRQ_EINT0);
 	unsigned long mask;
 
 	mask = __raw_readl(S3C2412_EINTMASK);
@@ -132,19 +136,22 @@ static void s3c2412_irq_demux_cfsdi(unsi
 #define INTMSK_CFSDI	(1UL << (IRQ_S3C2412_CFSDI - IRQ_EINT0))
 #define SUBMSK_CFSDI	INTMSK_SUB(IRQ_S3C2412_SDI, IRQ_S3C2412_CF)
 
-static void s3c2412_irq_cfsdi_mask(unsigned int irqno)
+static void s3c2412_irq_cfsdi_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_CFSDI, SUBMSK_CFSDI);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_CFSDI, SUBMSK_CFSDI);
 }
 
-static void s3c2412_irq_cfsdi_unmask(unsigned int irqno)
+static void s3c2412_irq_cfsdi_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_CFSDI);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_CFSDI);
 }
 
-static void s3c2412_irq_cfsdi_ack(unsigned int irqno)
+static void s3c2412_irq_cfsdi_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_CFSDI, SUBMSK_CFSDI);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_CFSDI, SUBMSK_CFSDI);
 }
 
 static struct irq_chip s3c2412_irq_cfsdi = {
Index: linux-2.6/arch/arm/mach-s3c2440/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2440/irq.c
+++ linux-2.6/arch/arm/mach-s3c2440/irq.c
@@ -69,21 +69,24 @@ static void s3c_irq_demux_wdtac97(unsign
 #define INTMSK_WDT	 (1UL << (IRQ_WDT - IRQ_EINT0))
 
 static void
-s3c_irq_wdtac97_mask(unsigned int irqno)
+s3c_irq_wdtac97_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_WDT, 3<<13);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_WDT, 3<<13);
 }
 
 static void
-s3c_irq_wdtac97_unmask(unsigned int irqno)
+s3c_irq_wdtac97_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_WDT);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_WDT);
 }
 
 static void
-s3c_irq_wdtac97_ack(unsigned int irqno)
+s3c_irq_wdtac97_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_WDT, 3<<13);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_WDT, 3<<13);
 }
 
 static struct irq_chip s3c_irq_wdtac97 = {
Index: linux-2.6/arch/arm/mach-s3c2443/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2443/irq.c
+++ linux-2.6/arch/arm/mach-s3c2443/irq.c
@@ -75,19 +75,22 @@ static void s3c2443_irq_demux_wdtac97(un
 #define INTMSK_WDTAC97	(1UL << (IRQ_WDT - IRQ_EINT0))
 #define SUBMSK_WDTAC97	INTMSK(IRQ_S3C2443_WDT, IRQ_S3C2443_AC97)
 
-static void s3c2443_irq_wdtac97_mask(unsigned int irqno)
+static void s3c2443_irq_wdtac97_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_WDTAC97, SUBMSK_WDTAC97);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_WDTAC97, SUBMSK_WDTAC97);
 }
 
-static void s3c2443_irq_wdtac97_unmask(unsigned int irqno)
+static void s3c2443_irq_wdtac97_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_WDTAC97);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_WDTAC97);
 }
 
-static void s3c2443_irq_wdtac97_ack(unsigned int irqno)
+static void s3c2443_irq_wdtac97_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_WDTAC97, SUBMSK_WDTAC97);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_WDTAC97, SUBMSK_WDTAC97);
 }
 
 static struct irq_chip s3c2443_irq_wdtac97 = {
@@ -107,19 +110,22 @@ static void s3c2443_irq_demux_lcd(unsign
 #define INTMSK_LCD	(1UL << (IRQ_LCD - IRQ_EINT0))
 #define SUBMSK_LCD	INTMSK(IRQ_S3C2443_LCD1, IRQ_S3C2443_LCD4)
 
-static void s3c2443_irq_lcd_mask(unsigned int irqno)
+static void s3c2443_irq_lcd_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_LCD, SUBMSK_LCD);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_LCD, SUBMSK_LCD);
 }
 
-static void s3c2443_irq_lcd_unmask(unsigned int irqno)
+static void s3c2443_irq_lcd_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_LCD);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_LCD);
 }
 
-static void s3c2443_irq_lcd_ack(unsigned int irqno)
+static void s3c2443_irq_lcd_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_LCD, SUBMSK_LCD);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_LCD, SUBMSK_LCD);
 }
 
 static struct irq_chip s3c2443_irq_lcd = {
@@ -140,19 +146,22 @@ static void s3c2443_irq_demux_dma(unsign
 #define SUBMSK_DMA	INTMSK(IRQ_S3C2443_DMA0, IRQ_S3C2443_DMA5)
 
 
-static void s3c2443_irq_dma_mask(unsigned int irqno)
+static void s3c2443_irq_dma_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_DMA, SUBMSK_DMA);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_DMA, SUBMSK_DMA);
 }
 
-static void s3c2443_irq_dma_unmask(unsigned int irqno)
+static void s3c2443_irq_dma_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_DMA);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_DMA);
 }
 
-static void s3c2443_irq_dma_ack(unsigned int irqno)
+static void s3c2443_irq_dma_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_DMA, SUBMSK_DMA);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_DMA, SUBMSK_DMA);
 }
 
 static struct irq_chip s3c2443_irq_dma = {
@@ -173,19 +182,22 @@ static void s3c2443_irq_demux_uart3(unsi
 #define SUBMSK_UART3	(0xf << (IRQ_S3C2443_RX3 - S3C2410_IRQSUB(0)))
 
 
-static void s3c2443_irq_uart3_mask(unsigned int irqno)
+static void s3c2443_irq_uart3_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	s3c_irqsub_mask(irqno, INTMSK_UART3, SUBMSK_UART3);
 }
 
-static void s3c2443_irq_uart3_unmask(unsigned int irqno)
+static void s3c2443_irq_uart3_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_UART3);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_UART3);
 }
 
-static void s3c2443_irq_uart3_ack(unsigned int irqno)
+static void s3c2443_irq_uart3_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_UART3, SUBMSK_UART3);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_UART3, SUBMSK_UART3);
 }
 
 static struct irq_chip s3c2443_irq_uart3 = {
@@ -205,19 +217,22 @@ static void s3c2443_irq_demux_cam(unsign
 #define INTMSK_CAM	(1UL << (IRQ_CAM - IRQ_EINT0))
 #define SUBMSK_CAM	INTMSK(IRQ_S3C2440_CAM_C, IRQ_S3C2440_CAM_P)
 
-static void s3c2443_irq_cam_mask(unsigned int irqno)
+static void s3c2443_irq_cam_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	s3c_irqsub_mask(irqno, INTMSK_CAM, SUBMSK_CAM);
 }
 
-static void s3c2443_irq_cam_unmask(unsigned int irqno)
+static void s3c2443_irq_cam_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_CAM);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_CAM);
 }
 
-static void s3c2443_irq_cam_ack(unsigned int irqno)
+static void s3c2443_irq_cam_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_CAM, SUBMSK_CAM);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_CAM, SUBMSK_CAM);
 }
 
 static struct irq_chip s3c2443_irq_cam = {
Index: linux-2.6/arch/arm/mach-sa1100/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/irq.c
+++ linux-2.6/arch/arm/mach-sa1100/irq.c
@@ -37,8 +37,9 @@ static int GPIO_IRQ_mask = (1 << 11) - 1
 #define GPIO_11_27_IRQ(i)	((i) - 21)
 #define GPIO11_27_MASK(irq)	(1 << GPIO_11_27_IRQ(irq))
 
-static int sa1100_gpio_type(unsigned int irq, unsigned int type)
+static int sa1100_gpio_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 
 	if (irq <= 10)
@@ -70,23 +71,27 @@ static int sa1100_gpio_type(unsigned int
 /*
  * GPIO IRQs must be acknowledged.  This is for IRQs from 0 to 10.
  */
-static void sa1100_low_gpio_ack(unsigned int irq)
+static void sa1100_low_gpio_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	GEDR = (1 << irq);
 }
 
-static void sa1100_low_gpio_mask(unsigned int irq)
+static void sa1100_low_gpio_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR &= ~(1 << irq);
 }
 
-static void sa1100_low_gpio_unmask(unsigned int irq)
+static void sa1100_low_gpio_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR |= 1 << irq;
 }
 
-static int sa1100_low_gpio_wake(unsigned int irq, unsigned int on)
+static int sa1100_low_gpio_wake(struct irq_desc *desc, unsigned int on)
 {
+	unsigned int irq = desc->irq;
 	if (on)
 		PWER |= 1 << irq;
 	else
@@ -139,15 +144,17 @@ sa1100_high_gpio_handler(unsigned int ir
  * In addition, the IRQs are all collected up into one bit in the
  * interrupt controller registers.
  */
-static void sa1100_high_gpio_ack(unsigned int irq)
+static void sa1100_high_gpio_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = GPIO11_27_MASK(irq);
 
 	GEDR = mask;
 }
 
-static void sa1100_high_gpio_mask(unsigned int irq)
+static void sa1100_high_gpio_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = GPIO11_27_MASK(irq);
 
 	GPIO_IRQ_mask &= ~mask;
@@ -156,8 +163,9 @@ static void sa1100_high_gpio_mask(unsign
 	GFER &= ~mask;
 }
 
-static void sa1100_high_gpio_unmask(unsigned int irq)
+static void sa1100_high_gpio_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = GPIO11_27_MASK(irq);
 
 	GPIO_IRQ_mask |= mask;
@@ -166,8 +174,9 @@ static void sa1100_high_gpio_unmask(unsi
 	GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
 }
 
-static int sa1100_high_gpio_wake(unsigned int irq, unsigned int on)
+static int sa1100_high_gpio_wake(struct irq_desc *desc, unsigned int on)
 {
+	unsigned int irq = desc->irq;
 	if (on)
 		PWER |= GPIO11_27_MASK(irq);
 	else
@@ -188,21 +197,24 @@ static struct irq_chip sa1100_high_gpio_
  * We don't need to ACK IRQs on the SA1100 unless they're GPIOs
  * this is for internal IRQs i.e. from 11 to 31.
  */
-static void sa1100_mask_irq(unsigned int irq)
+static void sa1100_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR &= ~(1 << irq);
 }
 
-static void sa1100_unmask_irq(unsigned int irq)
+static void sa1100_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ICMR |= (1 << irq);
 }
 
 /*
  * Apart form GPIOs, only the RTC alarm can be a wakeup event.
  */
-static int sa1100_set_wake(unsigned int irq, unsigned int on)
+static int sa1100_set_wake(struct irq_desc *desc, unsigned int on)
 {
+	unsigned int irq = desc->irq;
 	if (irq == IRQ_RTCAlrm) {
 		if (on)
 			PWER |= PWER_RTC;
Index: linux-2.6/arch/arm/mach-sa1100/neponset.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/neponset.c
+++ linux-2.6/arch/arm/mach-sa1100/neponset.c
@@ -36,7 +36,7 @@ neponset_irq_handler(unsigned int irq, s
 		/*
 		 * Acknowledge the parent IRQ.
 		 */
-		desc->chip->ack(irq);
+		desc->chip->ack(desc);
 
 		/*
 		 * Read the interrupt reason register.  Let's have all
@@ -54,7 +54,7 @@ neponset_irq_handler(unsigned int irq, s
 		 * recheck the register for any pending IRQs.
 		 */
 		if (irr & (IRR_ETHERNET | IRR_USAR)) {
-			desc->chip->mask(irq);
+			desc->chip->mask(desc);
 
 			/*
 			 * Ack the interrupt now to prevent re-entering
@@ -62,7 +62,7 @@ neponset_irq_handler(unsigned int irq, s
 			 * since we'll check the IRR register prior to
 			 * leaving.
 			 */
-			desc->chip->ack(irq);
+			desc->chip->ack(desc);
 
 			if (irr & IRR_ETHERNET) {
 				generic_handle_irq(IRQ_NEPONSET_SMC9196);
@@ -72,7 +72,7 @@ neponset_irq_handler(unsigned int irq, s
 				generic_handle_irq(IRQ_NEPONSET_USAR);
 			}
 
-			desc->chip->unmask(irq);
+			desc->chip->unmask(desc);
 		}
 
 		if (irr & IRR_SA1111) {
Index: linux-2.6/arch/arm/mach-shark/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shark/irq.c
+++ linux-2.6/arch/arm/mach-shark/irq.c
@@ -30,8 +30,9 @@ static unsigned char cached_irq_mask[2]
  * These have to be protected by the irq controller spinlock
  * before being called.
  */
-static void shark_disable_8259A_irq(unsigned int irq)
+static void shark_disable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	if (irq<8) {
 	  mask = 1 << irq;
@@ -44,8 +45,9 @@ static void shark_disable_8259A_irq(unsi
 	}
 }
 
-static void shark_enable_8259A_irq(unsigned int irq)
+static void shark_enable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	if (irq<8) {
 	  mask = ~(1 << irq);
@@ -58,7 +60,9 @@ static void shark_enable_8259A_irq(unsig
 	}
 }
 
-static void shark_ack_8259A_irq(unsigned int irq){}
+static void shark_ack_8259A_irq(struct irq_desc *desc)
+{
+}
 
 static irqreturn_t bogus_int(int irq, void *dev_id)
 {
Index: linux-2.6/arch/arm/mach-stmp378x/stmp378x.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-stmp378x/stmp378x.c
+++ linux-2.6/arch/arm/mach-stmp378x/stmp378x.c
@@ -47,8 +47,9 @@
 /*
  * IRQ handling
  */
-static void stmp378x_ack_irq(unsigned int irq)
+static void stmp378x_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* Tell ICOLL to release IRQ line */
 	__raw_writel(0, REGS_ICOLL_BASE + HW_ICOLL_VECTOR);
 
@@ -60,15 +61,17 @@ static void stmp378x_ack_irq(unsigned in
 	(void)__raw_readl(REGS_ICOLL_BASE + HW_ICOLL_STAT);
 }
 
-static void stmp378x_mask_irq(unsigned int irq)
+static void stmp378x_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* IRQ disable */
 	stmp3xxx_clearl(BM_ICOLL_INTERRUPTn_ENABLE,
 			REGS_ICOLL_BASE + HW_ICOLL_INTERRUPTn + irq * 0x10);
 }
 
-static void stmp378x_unmask_irq(unsigned int irq)
+static void stmp378x_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* IRQ enable */
 	stmp3xxx_setl(BM_ICOLL_INTERRUPTn_ENABLE,
 		      REGS_ICOLL_BASE + HW_ICOLL_INTERRUPTn + irq * 0x10);
Index: linux-2.6/arch/arm/mach-stmp37xx/stmp37xx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-stmp37xx/stmp37xx.c
+++ linux-2.6/arch/arm/mach-stmp37xx/stmp37xx.c
@@ -43,8 +43,9 @@
 /*
  * IRQ handling
  */
-static void stmp37xx_ack_irq(unsigned int irq)
+static void stmp37xx_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* Disable IRQ */
 	stmp3xxx_clearl(0x04 << ((irq % 4) * 8),
 		REGS_ICOLL_BASE + HW_ICOLL_PRIORITYn + irq / 4 * 0x10);
@@ -56,15 +57,17 @@ static void stmp37xx_ack_irq(unsigned in
 	(void)__raw_readl(REGS_ICOLL_BASE + HW_ICOLL_STAT);
 }
 
-static void stmp37xx_mask_irq(unsigned int irq)
+static void stmp37xx_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* IRQ disable */
 	stmp3xxx_clearl(0x04 << ((irq % 4) * 8),
 		REGS_ICOLL_BASE + HW_ICOLL_PRIORITYn + irq / 4 * 0x10);
 }
 
-static void stmp37xx_unmask_irq(unsigned int irq)
+static void stmp37xx_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* IRQ enable */
 	stmp3xxx_setl(0x04 << ((irq % 4) * 8),
 		REGS_ICOLL_BASE + HW_ICOLL_PRIORITYn + irq / 4 * 0x10);
Index: linux-2.6/arch/arm/mach-versatile/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-versatile/core.c
+++ linux-2.6/arch/arm/mach-versatile/core.c
@@ -62,14 +62,16 @@
 #define VA_VIC_BASE		__io_address(VERSATILE_VIC_BASE)
 #define VA_SIC_BASE		__io_address(VERSATILE_SIC_BASE)
 
-static void sic_mask_irq(unsigned int irq)
+static void sic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_SIC_START;
 	writel(1 << irq, VA_SIC_BASE + SIC_IRQ_ENABLE_CLEAR);
 }
 
-static void sic_unmask_irq(unsigned int irq)
+static void sic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= IRQ_SIC_START;
 	writel(1 << irq, VA_SIC_BASE + SIC_IRQ_ENABLE_SET);
 }
Index: linux-2.6/arch/arm/mach-w90x900/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-w90x900/irq.c
+++ linux-2.6/arch/arm/mach-w90x900/irq.c
@@ -92,8 +92,9 @@ static void nuc900_group_enable(struct g
 	__raw_writel(regval, REG_AIC_GEN);
 }
 
-static void nuc900_irq_mask(unsigned int irq)
+static void nuc900_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct group_irq *group_irq;
 
 	group_irq = NULL;
@@ -143,13 +144,14 @@ static void nuc900_irq_mask(unsigned int
  * to REG_AIC_EOSCR for ACK
  */
 
-static void nuc900_irq_ack(unsigned int irq)
+static void nuc900_irq_ack(struct irq_desc *desc)
 {
 	__raw_writel(0x01, REG_AIC_EOSCR);
 }
 
-static void nuc900_irq_unmask(unsigned int irq)
+static void nuc900_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct group_irq *group_irq;
 
 	group_irq = NULL;
Index: linux-2.6/arch/arm/oprofile/op_model_mpcore.c
===================================================================
--- linux-2.6.orig/arch/arm/oprofile/op_model_mpcore.c
+++ linux-2.6/arch/arm/oprofile/op_model_mpcore.c
@@ -260,12 +260,12 @@ static void em_stop(void)
  */
 static void em_route_irq(int irq, unsigned int cpu)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	const struct cpumask *mask = cpumask_of(cpu);
 
 	spin_lock_irq(&desc->lock);
 	cpumask_copy(desc->affinity, mask);
-	desc->chip->set_affinity(irq, mask);
+	desc->chip->set_affinity(desc, mask);
 	spin_unlock_irq(&desc->lock);
 }
 
Index: linux-2.6/arch/arm/plat-mxc/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/gpio.c
+++ linux-2.6/arch/arm/plat-mxc/gpio.c
@@ -63,28 +63,32 @@ static void _set_gpio_irqenable(struct m
 	__raw_writel(l, port->base + GPIO_IMR);
 }
 
-static void gpio_ack_irq(u32 irq)
+static void gpio_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 gpio = irq_to_gpio(irq);
 	_clear_gpio_irqstatus(&mxc_gpio_ports[gpio / 32], gpio & 0x1f);
 }
 
-static void gpio_mask_irq(u32 irq)
+static void gpio_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 gpio = irq_to_gpio(irq);
 	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 0);
 }
 
-static void gpio_unmask_irq(u32 irq)
+static void gpio_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 gpio = irq_to_gpio(irq);
 	_set_gpio_irqenable(&mxc_gpio_ports[gpio / 32], gpio & 0x1f, 1);
 }
 
 static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset);
 
-static int gpio_set_irq_type(u32 irq, u32 type)
+static int gpio_set_irq_type(struct irq_desc *desc, u32 type)
 {
+	unsigned int irq = desc->irq;
 	u32 gpio = irq_to_gpio(irq);
 	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
 	u32 bit, val;
Index: linux-2.6/arch/arm/plat-mxc/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/irq.c
+++ linux-2.6/arch/arm/plat-mxc/irq.c
@@ -91,14 +91,16 @@ EXPORT_SYMBOL(mxc_set_irq_fiq);
 #endif /* CONFIG_FIQ */
 
 /* Disable interrupt number "irq" in the AVIC */
-static void mxc_mask_irq(unsigned int irq)
+static void mxc_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(irq, avic_base + AVIC_INTDISNUM);
 }
 
 /* Enable interrupt number "irq" in the AVIC */
-static void mxc_unmask_irq(unsigned int irq)
+static void mxc_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(irq, avic_base + AVIC_INTENNUM);
 }
 
Index: linux-2.6/arch/arm/plat-omap/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/gpio.c
+++ linux-2.6/arch/arm/plat-omap/gpio.c
@@ -871,8 +871,9 @@ bad:
 	return -EINVAL;
 }
 
-static int gpio_irq_type(unsigned irq, unsigned type)
+static int gpio_irq_type(struct irq_desc *desc, unsigned type)
 {
+	unsigned int irq = desc->irq;
 	struct gpio_bank *bank;
 	unsigned gpio;
 	int retval;
@@ -894,7 +895,7 @@ static int gpio_irq_type(unsigned irq, u
 			&& (type & (IRQ_TYPE_LEVEL_LOW|IRQ_TYPE_LEVEL_HIGH)))
 		return -EINVAL;
 
-	bank = get_irq_chip_data(irq);
+	bank = get_irq_desc_chip_data(desc);
 	spin_lock_irqsave(&bank->lock, flags);
 	retval = _set_gpio_triggering(bank, get_gpio_index(gpio), type);
 	if (retval == 0) {
@@ -1164,15 +1165,16 @@ static void _reset_gpio(struct gpio_bank
 }
 
 /* Use disable_irq_wake() and enable_irq_wake() functions from drivers */
-static int gpio_wake_enable(unsigned int irq, unsigned int enable)
+static int gpio_wake_enable(struct irq_desc *desc, unsigned int enable)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank;
 	int retval;
 
 	if (check_gpio(gpio) < 0)
 		return -ENODEV;
-	bank = get_irq_chip_data(irq);
+	bank = get_irq_desc_chip_data(desc);
 	retval = _set_gpio_wakeup(bank, get_gpio_index(gpio), enable);
 
 	return retval;
@@ -1267,7 +1269,7 @@ static void gpio_irq_handler(unsigned in
 	u32 retrigger = 0;
 	int unmasked = 0;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
 	bank = get_irq_data(irq);
 #ifdef CONFIG_ARCH_OMAP1
@@ -1319,7 +1321,7 @@ static void gpio_irq_handler(unsigned in
 		configured, we could unmask GPIO bank interrupt immediately */
 		if (!level_mask && !unmasked) {
 			unmasked = 1;
-			desc->chip->unmask(irq);
+			desc->chip->unmask(desc);
 		}
 
 		isr |= retrigger;
@@ -1354,28 +1356,31 @@ static void gpio_irq_handler(unsigned in
 	handler(s) are executed in order to avoid spurious bank
 	interrupt */
 	if (!unmasked)
-		desc->chip->unmask(irq);
+		desc->chip->unmask(desc);
 
 }
 
-static void gpio_irq_shutdown(unsigned int irq)
+static void gpio_irq_shutdown(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_reset_gpio(bank, gpio);
 }
 
-static void gpio_ack_irq(unsigned int irq)
+static void gpio_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_clear_gpio_irqstatus(bank, gpio);
 }
 
-static void gpio_mask_irq(unsigned int irq)
+static void gpio_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = get_irq_chip_data(irq);
 
@@ -1383,8 +1388,9 @@ static void gpio_mask_irq(unsigned int i
 	_set_gpio_triggering(bank, get_gpio_index(gpio), IRQ_TYPE_NONE);
 }
 
-static void gpio_unmask_irq(unsigned int irq)
+static void gpio_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	struct gpio_bank *bank = get_irq_chip_data(irq);
 	unsigned int irq_mask = 1 << get_gpio_index(gpio);
@@ -1420,21 +1426,23 @@ static struct irq_chip gpio_irq_chip = {
 
 /* MPUIO uses the always-on 32k clock */
 
-static void mpuio_ack_irq(unsigned int irq)
+static void mpuio_ack_irq(struct irq_desc *desc)
 {
 	/* The ISR is reset automatically, so do nothing here. */
 }
 
-static void mpuio_mask_irq(unsigned int irq)
+static void mpuio_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = OMAP_MPUIO(irq - IH_MPUIO_BASE);
 	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_set_gpio_irqenable(bank, gpio, 0);
 }
 
-static void mpuio_unmask_irq(unsigned int irq)
+static void mpuio_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int gpio = OMAP_MPUIO(irq - IH_MPUIO_BASE);
 	struct gpio_bank *bank = get_irq_chip_data(irq);
 
Index: linux-2.6/arch/arm/plat-orion/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-orion/gpio.c
+++ linux-2.6/arch/arm/plat-orion/gpio.c
@@ -233,19 +233,21 @@ EXPORT_SYMBOL(orion_gpio_set_blink);
  *
  ****************************************************************************/
 
-static void gpio_irq_ack(u32 irq)
+static void gpio_irq_ack(struct irq_desc *desc)
 {
-	int type = irq_desc[irq].status & IRQ_TYPE_SENSE_MASK;
+	unsigned int irq = desc->irq;
+	int type = desc->status & IRQ_TYPE_SENSE_MASK;
 	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
 		int pin = irq_to_gpio(irq);
 		writel(~(1 << (pin & 31)), GPIO_EDGE_CAUSE(pin));
 	}
 }
 
-static void gpio_irq_mask(u32 irq)
+static void gpio_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq_to_gpio(irq);
-	int type = irq_desc[irq].status & IRQ_TYPE_SENSE_MASK;
+	int type = desc->status & IRQ_TYPE_SENSE_MASK;
 	u32 reg = (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) ?
 		GPIO_EDGE_MASK(pin) : GPIO_LEVEL_MASK(pin);
 	u32 u = readl(reg);
@@ -253,10 +255,11 @@ static void gpio_irq_mask(u32 irq)
 	writel(u, reg);
 }
 
-static void gpio_irq_unmask(u32 irq)
+static void gpio_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq_to_gpio(irq);
-	int type = irq_desc[irq].status & IRQ_TYPE_SENSE_MASK;
+	int type = desc->status & IRQ_TYPE_SENSE_MASK;
 	u32 reg = (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) ?
 		GPIO_EDGE_MASK(pin) : GPIO_LEVEL_MASK(pin);
 	u32 u = readl(reg);
@@ -264,10 +267,10 @@ static void gpio_irq_unmask(u32 irq)
 	writel(u, reg);
 }
 
-static int gpio_irq_set_type(u32 irq, u32 type)
+static int gpio_irq_set_type(struct irq_desc *desc, u32 type)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq_to_gpio(irq);
-	struct irq_desc *desc;
 	u32 u;
 
 	u = readl(GPIO_IO_CONF(pin)) & (1 << (pin & 31));
@@ -277,8 +280,6 @@ static int gpio_irq_set_type(u32 irq, u3
 		return -EINVAL;
 	}
 
-	desc = irq_desc + irq;
-
 	/*
 	 * Set edge/level type.
 	 */
Index: linux-2.6/arch/arm/plat-orion/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-orion/irq.c
+++ linux-2.6/arch/arm/plat-orion/irq.c
@@ -14,9 +14,10 @@
 #include <linux/io.h>
 #include <plat/irq.h>
 
-static void orion_irq_mask(u32 irq)
+static void orion_irq_mask(struct irq_desc *desc)
 {
-	void __iomem *maskaddr = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *maskaddr = get_irq_desc_chip_data(desc);
 	u32 mask;
 
 	mask = readl(maskaddr);
@@ -24,9 +25,10 @@ static void orion_irq_mask(u32 irq)
 	writel(mask, maskaddr);
 }
 
-static void orion_irq_unmask(u32 irq)
+static void orion_irq_unmask(struct irq_desc *desc)
 {
-	void __iomem *maskaddr = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *maskaddr = get_irq_desc_chip_data(desc);
 	u32 mask;
 
 	mask = readl(maskaddr);
Index: linux-2.6/arch/arm/plat-pxa/gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-pxa/gpio.c
+++ linux-2.6/arch/arm/plat-pxa/gpio.c
@@ -155,8 +155,9 @@ static inline void update_edge_detect(st
 	__raw_writel(gfer, c->regbase + GFER_OFFSET);
 }
 
-static int pxa_gpio_irq_type(unsigned int irq, unsigned int type)
+static int pxa_gpio_irq_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	struct pxa_gpio_chip *c;
 	int gpio = irq_to_gpio(irq);
 	unsigned long gpdr, mask = GPIO_bit(gpio);
@@ -227,16 +228,18 @@ static void pxa_gpio_demux_handler(unsig
 	} while (loop);
 }
 
-static void pxa_ack_muxed_gpio(unsigned int irq)
+static void pxa_ack_muxed_gpio(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int gpio = irq_to_gpio(irq);
 	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
 
 	__raw_writel(GPIO_bit(gpio), c->regbase + GEDR_OFFSET);
 }
 
-static void pxa_mask_muxed_gpio(unsigned int irq)
+static void pxa_mask_muxed_gpio(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int gpio = irq_to_gpio(irq);
 	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
 	uint32_t grer, gfer;
@@ -249,8 +252,9 @@ static void pxa_mask_muxed_gpio(unsigned
 	__raw_writel(gfer, c->regbase + GFER_OFFSET);
 }
 
-static void pxa_unmask_muxed_gpio(unsigned int irq)
+static void pxa_unmask_muxed_gpio(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int gpio = irq_to_gpio(irq);
 	struct pxa_gpio_chip *c = gpio_to_chip(gpio);
 
Index: linux-2.6/arch/arm/plat-s3c24xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/irq.c
+++ linux-2.6/arch/arm/plat-s3c24xx/irq.c
@@ -34,30 +34,33 @@
 #include <plat/irq.h>
 
 static void
-s3c_irq_mask(unsigned int irqno)
+s3c_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
 
-	irqno -= IRQ_EINT0;
+	irq -= IRQ_EINT0;
 
 	mask = __raw_readl(S3C2410_INTMSK);
-	mask |= 1UL << irqno;
+	mask |= 1UL << irq;
 	__raw_writel(mask, S3C2410_INTMSK);
 }
 
 static inline void
-s3c_irq_ack(unsigned int irqno)
+s3c_irq_ack(struct irq_desc *desc)
 {
-	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
+	unsigned int irq = desc->irq;
+	unsigned long bitval = 1UL << (irq - IRQ_EINT0);
 
 	__raw_writel(bitval, S3C2410_SRCPND);
 	__raw_writel(bitval, S3C2410_INTPND);
 }
 
 static inline void
-s3c_irq_maskack(unsigned int irqno)
+s3c_irq_maskack(struct irq_desc *desc)
 {
-	unsigned long bitval = 1UL << (irqno - IRQ_EINT0);
+	unsigned int irq = desc->irq;
+	unsigned long bitval = 1UL << (irq - IRQ_EINT0);
 	unsigned long mask;
 
 	mask = __raw_readl(S3C2410_INTMSK);
@@ -69,17 +72,18 @@ s3c_irq_maskack(unsigned int irqno)
 
 
 static void
-s3c_irq_unmask(unsigned int irqno)
+s3c_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
 
-	if (irqno != IRQ_TIMER4 && irqno != IRQ_EINT8t23)
-		irqdbf2("s3c_irq_unmask %d\n", irqno);
+	if (irq != IRQ_TIMER4 && irq != IRQ_EINT8t23)
+		irqdbf2("s3c_irq_unmask %d\n", irq);
 
-	irqno -= IRQ_EINT0;
+	irq -= IRQ_EINT0;
 
 	mask = __raw_readl(S3C2410_INTMSK);
-	mask &= ~(1UL << irqno);
+	mask &= ~(1UL << irq);
 	__raw_writel(mask, S3C2410_INTMSK);
 }
 
@@ -100,25 +104,27 @@ struct irq_chip s3c_irq_chip = {
 };
 
 static void
-s3c_irqext_mask(unsigned int irqno)
+s3c_irqext_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
 
-	irqno -= EXTINT_OFF;
+	irq -= EXTINT_OFF;
 
 	mask = __raw_readl(S3C24XX_EINTMASK);
-	mask |= ( 1UL << irqno);
+	mask |= (1UL << irq);
 	__raw_writel(mask, S3C24XX_EINTMASK);
 }
 
 static void
-s3c_irqext_ack(unsigned int irqno)
+s3c_irqext_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long req;
 	unsigned long bit;
 	unsigned long mask;
 
-	bit = 1UL << (irqno - EXTINT_OFF);
+	bit = 1UL << (irq - EXTINT_OFF);
 
 	mask = __raw_readl(S3C24XX_EINTMASK);
 
@@ -129,7 +135,7 @@ s3c_irqext_ack(unsigned int irqno)
 
 	/* not sure if we should be acking the parent irq... */
 
-	if (irqno <= IRQ_EINT7 ) {
+	if (irq <= IRQ_EINT7) {
 		if ((req & 0xf0) == 0)
 			s3c_irq_ack(IRQ_EINT4t7);
 	} else {
@@ -139,20 +145,22 @@ s3c_irqext_ack(unsigned int irqno)
 }
 
 static void
-s3c_irqext_unmask(unsigned int irqno)
+s3c_irqext_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask;
 
-	irqno -= EXTINT_OFF;
+	irq -= EXTINT_OFF;
 
 	mask = __raw_readl(S3C24XX_EINTMASK);
-	mask &= ~( 1UL << irqno);
+	mask &= ~(1UL << irq);
 	__raw_writel(mask, S3C24XX_EINTMASK);
 }
 
 int
-s3c_irqext_type(unsigned int irq, unsigned int type)
+s3c_irqext_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *extint_reg;
 	void __iomem *gpcon_reg;
 	unsigned long gpcon_offset, extint_offset;
@@ -261,21 +269,24 @@ static struct irq_chip s3c_irq_eint0t4 =
 /* UART0 */
 
 static void
-s3c_irq_uart0_mask(unsigned int irqno)
+s3c_irq_uart0_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_UART0, 7);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_UART0, 7);
 }
 
 static void
-s3c_irq_uart0_unmask(unsigned int irqno)
+s3c_irq_uart0_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_UART0);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_UART0);
 }
 
 static void
-s3c_irq_uart0_ack(unsigned int irqno)
+s3c_irq_uart0_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_UART0, 7);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_UART0, 7);
 }
 
 static struct irq_chip s3c_irq_uart0 = {
@@ -288,21 +299,24 @@ static struct irq_chip s3c_irq_uart0 = {
 /* UART1 */
 
 static void
-s3c_irq_uart1_mask(unsigned int irqno)
+s3c_irq_uart1_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_UART1, 7 << 3);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_UART1, 7 << 3);
 }
 
 static void
-s3c_irq_uart1_unmask(unsigned int irqno)
+s3c_irq_uart1_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_UART1);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_UART1);
 }
 
 static void
-s3c_irq_uart1_ack(unsigned int irqno)
+s3c_irq_uart1_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_UART1, 7 << 3);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_UART1, 7 << 3);
 }
 
 static struct irq_chip s3c_irq_uart1 = {
@@ -315,21 +329,24 @@ static struct irq_chip s3c_irq_uart1 = {
 /* UART2 */
 
 static void
-s3c_irq_uart2_mask(unsigned int irqno)
+s3c_irq_uart2_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_UART2, 7 << 6);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_UART2, 7 << 6);
 }
 
 static void
-s3c_irq_uart2_unmask(unsigned int irqno)
+s3c_irq_uart2_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_UART2);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_UART2);
 }
 
 static void
-s3c_irq_uart2_ack(unsigned int irqno)
+s3c_irq_uart2_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_UART2, 7 << 6);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_UART2, 7 << 6);
 }
 
 static struct irq_chip s3c_irq_uart2 = {
@@ -342,21 +359,24 @@ static struct irq_chip s3c_irq_uart2 = {
 /* ADC and Touchscreen */
 
 static void
-s3c_irq_adc_mask(unsigned int irqno)
+s3c_irq_adc_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_ADCPARENT, 3 << 9);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_ADCPARENT, 3 << 9);
 }
 
 static void
-s3c_irq_adc_unmask(unsigned int irqno)
+s3c_irq_adc_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_ADCPARENT);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_ADCPARENT);
 }
 
 static void
-s3c_irq_adc_ack(unsigned int irqno)
+s3c_irq_adc_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_ack(irqno, INTMSK_ADCPARENT, 3 << 9);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_ack(irq, INTMSK_ADCPARENT, 3 << 9);
 }
 
 static struct irq_chip s3c_irq_adc = {
Index: linux-2.6/arch/arm/plat-s3c24xx/s3c244x-irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/s3c244x-irq.c
+++ linux-2.6/arch/arm/plat-s3c24xx/s3c244x-irq.c
@@ -68,21 +68,24 @@ static void s3c_irq_demux_cam(unsigned i
 #define INTMSK_CAM (1UL << (IRQ_CAM - IRQ_EINT0))
 
 static void
-s3c_irq_cam_mask(unsigned int irqno)
+s3c_irq_cam_mask(struct irq_desc *desc)
 {
-	s3c_irqsub_mask(irqno, INTMSK_CAM, 3<<11);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_mask(irq, INTMSK_CAM, 3<<11);
 }
 
 static void
-s3c_irq_cam_unmask(unsigned int irqno)
+s3c_irq_cam_unmask(struct irq_desc *desc)
 {
-	s3c_irqsub_unmask(irqno, INTMSK_CAM);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_unmask(irq, INTMSK_CAM);
 }
 
 static void
-s3c_irq_cam_ack(unsigned int irqno)
+s3c_irq_cam_ack(struct irq_desc *desc)
 {
-	s3c_irqsub_maskack(irqno, INTMSK_CAM, 3<<11);
+	unsigned int irq = desc->irq;
+	s3c_irqsub_maskack(irq, INTMSK_CAM, 3<<11);
 }
 
 static struct irq_chip s3c_irq_cam = {
Index: linux-2.6/arch/arm/plat-s3c64xx/irq-eint.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c64xx/irq-eint.c
+++ linux-2.6/arch/arm/plat-s3c64xx/irq-eint.c
@@ -32,8 +32,9 @@
 #define eint_offset(irq)	((irq) - IRQ_EINT(0))
 #define eint_irq_to_bit(irq)	(1 << eint_offset(irq))
 
-static inline void s3c_irq_eint_mask(unsigned int irq)
+static inline void s3c_irq_eint_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask;
 
 	mask = __raw_readl(S3C64XX_EINT0MASK);
@@ -41,8 +42,9 @@ static inline void s3c_irq_eint_mask(uns
 	__raw_writel(mask, S3C64XX_EINT0MASK);
 }
 
-static void s3c_irq_eint_unmask(unsigned int irq)
+static void s3c_irq_eint_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask;
 
 	mask = __raw_readl(S3C64XX_EINT0MASK);
@@ -50,20 +52,23 @@ static void s3c_irq_eint_unmask(unsigned
 	__raw_writel(mask, S3C64XX_EINT0MASK);
 }
 
-static inline void s3c_irq_eint_ack(unsigned int irq)
+static inline void s3c_irq_eint_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__raw_writel(eint_irq_to_bit(irq), S3C64XX_EINT0PEND);
 }
 
-static void s3c_irq_eint_maskack(unsigned int irq)
+static void s3c_irq_eint_maskack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* compiler should in-line these */
-	s3c_irq_eint_mask(irq);
-	s3c_irq_eint_ack(irq);
+	s3c_irq_eint_mask(irq, desc);
+	s3c_irq_eint_ack(irq, desc);
 }
 
-static int s3c_irq_eint_set_type(unsigned int irq, unsigned int type)
+static int s3c_irq_eint_set_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int offs = eint_offset(irq);
 	int pin, pin_val;
 	int shift;
Index: linux-2.6/arch/arm/plat-s3c64xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c64xx/irq.c
+++ linux-2.6/arch/arm/plat-s3c64xx/irq.c
@@ -59,8 +59,9 @@ static void s3c_irq_demux_timer4(unsigne
 
 /* We assume the IRQ_TIMER0..IRQ_TIMER4 range is continuous. */
 
-static void s3c_irq_timer_mask(unsigned int irq)
+static void s3c_irq_timer_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
 	reg &= 0x1f;  /* mask out pending interrupts */
@@ -68,8 +69,9 @@ static void s3c_irq_timer_mask(unsigned
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_unmask(unsigned int irq)
+static void s3c_irq_timer_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
 	reg &= 0x1f;  /* mask out pending interrupts */
@@ -77,8 +79,9 @@ static void s3c_irq_timer_unmask(unsigne
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_ack(unsigned int irq)
+static void s3c_irq_timer_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
 	reg &= 0x1f;
@@ -138,8 +141,9 @@ static inline unsigned int s3c_irq_uart_
 
 /* UART interrupt registers, not worth adding to seperate include header */
 
-static void s3c_irq_uart_mask(unsigned int irq)
+static void s3c_irq_uart_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
 	u32 reg;
@@ -149,8 +153,9 @@ static void s3c_irq_uart_mask(unsigned i
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_maskack(unsigned int irq)
+static void s3c_irq_uart_maskack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
 	u32 reg;
@@ -161,8 +166,9 @@ static void s3c_irq_uart_maskack(unsigne
 	__raw_writel(1 << bit, regs + S3C64XX_UINTP);
 }
 
-static void s3c_irq_uart_unmask(unsigned int irq)
+static void s3c_irq_uart_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
 	u32 reg;
@@ -172,8 +178,9 @@ static void s3c_irq_uart_unmask(unsigned
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_ack(unsigned int irq)
+static void s3c_irq_uart_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
 
Index: linux-2.6/arch/arm/plat-s5pc1xx/irq-eint.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s5pc1xx/irq-eint.c
+++ linux-2.6/arch/arm/plat-s5pc1xx/irq-eint.c
@@ -67,8 +67,9 @@ static inline int s3c_eint_to_bit(unsign
 	return bit;
 }
 
-static inline void s3c_irq_eint_mask(unsigned int irq)
+static inline void s3c_irq_eint_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask;
 	u32 bank = s3c_get_bank(irq);
 
@@ -77,8 +78,9 @@ static inline void s3c_irq_eint_mask(uns
 	__raw_writel(mask, S5PC1XX_WKUP_INT_MASK(bank));
 }
 
-static void s3c_irq_eint_unmask(unsigned int irq)
+static void s3c_irq_eint_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask;
 	u32 bank = s3c_get_bank(irq);
 
@@ -87,22 +89,25 @@ static void s3c_irq_eint_unmask(unsigned
 	__raw_writel(mask, S5PC1XX_WKUP_INT_MASK(bank));
 }
 
-static inline void s3c_irq_eint_ack(unsigned int irq)
+static inline void s3c_irq_eint_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 bank = s3c_get_bank(irq);
 
 	__raw_writel(s3c_eint_to_bit(irq), S5PC1XX_WKUP_INT_PEND(bank));
 }
 
-static void s3c_irq_eint_maskack(unsigned int irq)
+static void s3c_irq_eint_maskack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* compiler should in-line these */
-	s3c_irq_eint_mask(irq);
-	s3c_irq_eint_ack(irq);
+	s3c_irq_eint_mask(irq, desc);
+	s3c_irq_eint_ack(irq, desc);
 }
 
-static int s3c_irq_eint_set_type(unsigned int irq, unsigned int type)
+static int s3c_irq_eint_set_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	u32 bank = s3c_get_bank(irq);
 	int real = s3c_get_eint(irq);
 	int gpio, shift, sfn;
@@ -211,28 +216,31 @@ static void s3c_irq_demux_eint16_31(unsi
 /*
  * Handle EINT0 ... EINT15 at VIC directly
  */
-static void s3c_irq_vic_eint_mask(unsigned int irq)
+static void s3c_irq_vic_eint_mask(struct irq_desc *desc)
 {
-	void __iomem *base = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *base = get_irq_desc_chip_data(desc);
 	unsigned int real;
 
-	s3c_irq_eint_mask(irq);
+	s3c_irq_eint_mask(desc);
 	real = s3c_get_eint(irq);
 	writel(1 << real, base + VIC_INT_ENABLE_CLEAR);
 }
 
-static void s3c_irq_vic_eint_unmask(unsigned int irq)
+static void s3c_irq_vic_eint_unmask(struct irq_desc *desc)
 {
-	void __iomem *base = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	void __iomem *base = get_irq_desc_chip_data(desc);
 	unsigned int real;
 
-	s3c_irq_eint_unmask(irq);
+	s3c_irq_eint_unmask(desc);
 	real = s3c_get_eint(irq);
 	writel(1 << real, base + VIC_INT_ENABLE);
 }
 
-static inline void s3c_irq_vic_eint_ack(unsigned int irq)
+static inline void s3c_irq_vic_eint_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 bit;
 	u32 bank = s3c_get_bank(irq);
 
@@ -240,11 +248,11 @@ static inline void s3c_irq_vic_eint_ack(
 	__raw_writel(bit, S5PC1XX_WKUP_INT_PEND(bank));
 }
 
-static void s3c_irq_vic_eint_maskack(unsigned int irq)
+static void s3c_irq_vic_eint_maskack(struct irq_desc *desc)
 {
 	/* compiler should in-line these */
-	s3c_irq_vic_eint_mask(irq);
-	s3c_irq_vic_eint_ack(irq);
+	s3c_irq_vic_eint_mask(desc);
+	s3c_irq_vic_eint_ack(desc);
 }
 
 static struct irq_chip s3c_irq_vic_eint = {
Index: linux-2.6/arch/arm/plat-s5pc1xx/irq-gpio.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s5pc1xx/irq-gpio.c
+++ linux-2.6/arch/arm/plat-s5pc1xx/irq-gpio.c
@@ -140,8 +140,9 @@ static int s5pc1xx_get_offset(unsigned i
 	return irq - S3C_IRQ_GPIO(chip->base);
 }
 
-static void s5pc1xx_gpioint_ack(unsigned int irq)
+static void s5pc1xx_gpioint_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int group, offset, pend_offset;
 	unsigned int value;
 
@@ -154,8 +155,9 @@ static void s5pc1xx_gpioint_ack(unsigned
 	__raw_writel(value, S5PC1XX_GPIOREG(PEND_OFFSET) + pend_offset);
 }
 
-static void s5pc1xx_gpioint_mask(unsigned int irq)
+static void s5pc1xx_gpioint_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int group, offset, mask_offset;
 	unsigned int value;
 
@@ -168,8 +170,9 @@ static void s5pc1xx_gpioint_mask(unsigne
 	__raw_writel(value, S5PC1XX_GPIOREG(MASK_OFFSET) + mask_offset);
 }
 
-static void s5pc1xx_gpioint_unmask(unsigned int irq)
+static void s5pc1xx_gpioint_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int group, offset, mask_offset;
 	unsigned int value;
 
@@ -182,14 +185,15 @@ static void s5pc1xx_gpioint_unmask(unsig
 	__raw_writel(value, S5PC1XX_GPIOREG(MASK_OFFSET) + mask_offset);
 }
 
-static void s5pc1xx_gpioint_mask_ack(unsigned int irq)
+static void s5pc1xx_gpioint_mask_ack(struct irq_desc *desc)
 {
-	s5pc1xx_gpioint_mask(irq);
-	s5pc1xx_gpioint_ack(irq);
+	s5pc1xx_gpioint_mask(desc);
+	s5pc1xx_gpioint_ack(desc);
 }
 
-static int s5pc1xx_gpioint_set_type(unsigned int irq, unsigned int type)
+static int s5pc1xx_gpioint_set_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int group, offset, con_offset;
 	unsigned int value;
 
Index: linux-2.6/arch/arm/plat-s5pc1xx/irq.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s5pc1xx/irq.c
+++ linux-2.6/arch/arm/plat-s5pc1xx/irq.c
@@ -57,8 +57,9 @@ static void s3c_irq_demux_timer4(unsigne
 
 /* We assume the IRQ_TIMER0..IRQ_TIMER4 range is continuous. */
 
-static void s3c_irq_timer_mask(unsigned int irq)
+static void s3c_irq_timer_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
 	reg &= 0x1f;  /* mask out pending interrupts */
@@ -66,8 +67,9 @@ static void s3c_irq_timer_mask(unsigned
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_unmask(unsigned int irq)
+static void s3c_irq_timer_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
 	reg &= 0x1f;  /* mask out pending interrupts */
@@ -75,8 +77,9 @@ static void s3c_irq_timer_unmask(unsigne
 	__raw_writel(reg, S3C64XX_TINT_CSTAT);
 }
 
-static void s3c_irq_timer_ack(unsigned int irq)
+static void s3c_irq_timer_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg = __raw_readl(S3C64XX_TINT_CSTAT);
 
 	reg &= 0x1f;  /* mask out pending interrupts */
@@ -139,8 +142,9 @@ static inline unsigned int s3c_irq_uart_
 #define S3C64XX_UINTSP	0x34
 #define S3C64XX_UINTM	0x38
 
-static void s3c_irq_uart_mask(unsigned int irq)
+static void s3c_irq_uart_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
 	u32 reg;
@@ -150,8 +154,9 @@ static void s3c_irq_uart_mask(unsigned i
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_maskack(unsigned int irq)
+static void s3c_irq_uart_maskack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
 	u32 reg;
@@ -162,8 +167,9 @@ static void s3c_irq_uart_maskack(unsigne
 	__raw_writel(1 << bit, regs + S3C64XX_UINTP);
 }
 
-static void s3c_irq_uart_unmask(unsigned int irq)
+static void s3c_irq_uart_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	void __iomem *regs = s3c_irq_uart_base(irq);
 	unsigned int bit = s3c_irq_uart_bit(irq);
 	u32 reg;
@@ -173,8 +179,9 @@ static void s3c_irq_uart_unmask(unsigned
 	__raw_writel(reg, regs + S3C64XX_UINTM);
 }
 
-static void s3c_irq_uart_ack(unsigned int irq)
+static void s3c_irq_uart_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
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
+		chip->mask(irq_to_desc(i));
 		set_irq_chip(i, chip);
 		set_irq_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
Index: linux-2.6/arch/arm/plat-stmp3xxx/pinmux.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-stmp3xxx/pinmux.c
+++ linux-2.6/arch/arm/plat-stmp3xxx/pinmux.c
@@ -365,8 +365,9 @@ static int stmp3xxx_irq_to_gpio(int irq,
 	return -ENOENT;
 }
 
-static int stmp3xxx_set_irqtype(unsigned irq, unsigned type)
+static int stmp3xxx_set_irqtype(struct irq_desc *desc, unsigned type)
 {
+	unsigned int irq = desc->irq;
 	struct stmp3xxx_pinmux_bank *pm;
 	unsigned gpio;
 	int l, p;
@@ -398,8 +399,9 @@ static int stmp3xxx_set_irqtype(unsigned
 	return 0;
 }
 
-static void stmp3xxx_pin_ack_irq(unsigned irq)
+static void stmp3xxx_pin_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 stat;
 	struct stmp3xxx_pinmux_bank *pm;
 	unsigned gpio;
@@ -409,8 +411,9 @@ static void stmp3xxx_pin_ack_irq(unsigne
 	stmp3xxx_clearl(stat, pm->irqstat);
 }
 
-static void stmp3xxx_pin_mask_irq(unsigned irq)
+static void stmp3xxx_pin_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct stmp3xxx_pinmux_bank *pm;
 	unsigned gpio;
 
@@ -419,8 +422,9 @@ static void stmp3xxx_pin_mask_irq(unsign
 	stmp3xxx_clearl(1 << gpio, pm->pin2irq);
 }
 
-static void stmp3xxx_pin_unmask_irq(unsigned irq)
+static void stmp3xxx_pin_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct stmp3xxx_pinmux_bank *pm;
 	unsigned gpio;
 
Index: linux-2.6/arch/avr32/mach-at32ap/extint.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/extint.c
+++ linux-2.6/arch/avr32/mach-at32ap/extint.c
@@ -60,35 +60,39 @@ struct eic {
 static struct eic *nmi_eic;
 static bool nmi_enabled;
 
-static void eic_ack_irq(unsigned int irq)
+static void eic_ack_irq(struct irq_desc *desc)
 {
-	struct eic *eic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct eic *eic = get_irq_desc_chip_data(desc);
 	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
 }
 
-static void eic_mask_irq(unsigned int irq)
+static void eic_mask_irq(struct irq_desc *desc)
 {
-	struct eic *eic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct eic *eic = get_irq_desc_chip_data(desc);
 	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
 }
 
-static void eic_mask_ack_irq(unsigned int irq)
+static void eic_mask_ack_irq(struct irq_desc *desc)
 {
-	struct eic *eic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct eic *eic = get_irq_desc_chip_data(desc);
 	eic_writel(eic, ICR, 1 << (irq - eic->first_irq));
 	eic_writel(eic, IDR, 1 << (irq - eic->first_irq));
 }
 
-static void eic_unmask_irq(unsigned int irq)
+static void eic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct eic *eic = get_irq_chip_data(irq);
 	eic_writel(eic, IER, 1 << (irq - eic->first_irq));
 }
 
-static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
+static int eic_set_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
-	struct eic *eic = get_irq_chip_data(irq);
-	struct irq_desc *desc;
+	unsigned int irq = desc->irq;
+	struct eic *eic = get_irq_desc_chip_data(desc);
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
 	int ret = 0;
@@ -97,8 +101,6 @@ static int eic_set_irq_type(unsigned int
 	if (flow_type == IRQ_TYPE_NONE)
 		flow_type = IRQ_TYPE_LEVEL_LOW;
 
-	desc = &irq_desc[irq];
-
 	mode = eic_readl(eic, MODE);
 	edge = eic_readl(eic, EDGE);
 	level = eic_readl(eic, LEVEL);
Index: linux-2.6/arch/avr32/mach-at32ap/pio.c
===================================================================
--- linux-2.6.orig/arch/avr32/mach-at32ap/pio.c
+++ linux-2.6/arch/avr32/mach-at32ap/pio.c
@@ -249,24 +249,27 @@ static void gpio_set(struct gpio_chip *c
 
 /* GPIO IRQ support */
 
-static void gpio_irq_mask(unsigned irq)
+static void gpio_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned		gpio = irq_to_gpio(irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
 
 	pio_writel(pio, IDR, 1 << (gpio & 0x1f));
 }
 
-static void gpio_irq_unmask(unsigned irq)
+static void gpio_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned		gpio = irq_to_gpio(irq);
 	struct pio_device	*pio = &pio_dev[gpio >> 5];
 
 	pio_writel(pio, IER, 1 << (gpio & 0x1f));
 }
 
-static int gpio_irq_type(unsigned irq, unsigned type)
+static int gpio_irq_type(struct irq_desc *desc, unsigned type)
 {
+	unsigned int irq = desc->irq;
 	if (type != IRQ_TYPE_EDGE_BOTH && type != IRQ_TYPE_NONE)
 		return -EINVAL;
 
Index: linux-2.6/arch/blackfin/include/asm/ipipe.h
===================================================================
--- linux-2.6.orig/arch/blackfin/include/asm/ipipe.h
+++ linux-2.6/arch/blackfin/include/asm/ipipe.h
@@ -115,9 +115,9 @@ void __ipipe_enable_irqdesc(struct ipipe
 void __ipipe_disable_irqdesc(struct ipipe_domain *ipd,
 			     unsigned irq);
 
-#define __ipipe_enable_irq(irq)		(irq_desc[irq].chip->unmask(irq))
+#define __ipipe_enable_irq(irq)		(irq_desc[irq].chip->unmask(irq_to_desc(irq)))
 
-#define __ipipe_disable_irq(irq)	(irq_desc[irq].chip->mask(irq))
+#define __ipipe_disable_irq(irq)	(irq_desc[irq].chip->mask(irq_to_desc(irq)))
 
 static inline int __ipipe_check_tickdev(const char *devname)
 {
Index: linux-2.6/arch/blackfin/mach-common/ints-priority.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/ints-priority.c
+++ linux-2.6/arch/blackfin/mach-common/ints-priority.c
@@ -120,20 +120,22 @@ static void __init search_IAR(void)
  * This is for core internal IRQs
  */
 
-static void bfin_ack_noop(unsigned int irq)
+static void bfin_ack_noop(struct irq_desc *desc)
 {
 	/* Dummy function.  */
 }
 
-static void bfin_core_mask_irq(unsigned int irq)
+static void bfin_core_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	bfin_irq_flags &= ~(1 << irq);
 	if (!irqs_disabled_hw())
 		local_irq_enable_hw();
 }
 
-static void bfin_core_unmask_irq(unsigned int irq)
+static void bfin_core_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	bfin_irq_flags |= 1 << irq;
 	/*
 	 * If interrupts are enabled, IMASK must contain the same value
@@ -149,8 +151,9 @@ static void bfin_core_unmask_irq(unsigne
 	return;
 }
 
-static void bfin_internal_mask_irq(unsigned int irq)
+static void bfin_internal_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 
 #ifdef CONFIG_BF53x
@@ -172,8 +175,9 @@ static void bfin_internal_mask_irq(unsig
 	local_irq_restore_hw(flags);
 }
 
-static void bfin_internal_unmask_irq(unsigned int irq)
+static void bfin_internal_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 
 #ifdef CONFIG_BF53x
@@ -196,8 +200,9 @@ static void bfin_internal_unmask_irq(uns
 }
 
 #ifdef CONFIG_PM
-int bfin_internal_set_wake(unsigned int irq, unsigned int state)
+int bfin_internal_set_wake(struct irq_desc *desc, unsigned int state)
 {
+	unsigned int irq = desc->irq;
 	u32 bank, bit, wakeup = 0;
 	unsigned long flags;
 	bank = SIC_SYSIRQ(irq) / 32;
@@ -291,16 +296,18 @@ static void bfin_handle_irq(unsigned irq
 #ifdef BF537_GENERIC_ERROR_INT_DEMUX
 static int error_int_mask;
 
-static void bfin_generic_error_mask_irq(unsigned int irq)
+static void bfin_generic_error_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	error_int_mask &= ~(1L << (irq - IRQ_PPI_ERROR));
 
 	if (!error_int_mask)
 		bfin_internal_mask_irq(IRQ_GENERIC_ERROR);
 }
 
-static void bfin_generic_error_unmask_irq(unsigned int irq)
+static void bfin_generic_error_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	bfin_internal_unmask_irq(IRQ_GENERIC_ERROR);
 	error_int_mask |= 1L << (irq - IRQ_PPI_ERROR);
 }
@@ -675,7 +682,7 @@ void init_pint_lut(void)
 	}
 }
 
-static void bfin_gpio_ack_irq(unsigned int irq)
+static void bfin_gpio_ack_irq(struct irq_desc *desc)
 {
 	struct irq_desc *desc = irq_desc + irq;
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
@@ -692,9 +699,9 @@ static void bfin_gpio_ack_irq(unsigned i
 
 }
 
-static void bfin_gpio_mask_ack_irq(unsigned int irq)
+static void bfin_gpio_mask_ack_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	unsigned int irq = desc->irq;
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
 	u32 pintbit = PINT_BIT(pint_val);
 	u32 bank = PINT_2_BANK(pint_val);
@@ -710,15 +717,17 @@ static void bfin_gpio_mask_ack_irq(unsig
 	pint[bank]->mask_clear = pintbit;
 }
 
-static void bfin_gpio_mask_irq(unsigned int irq)
+static void bfin_gpio_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
 
 	pint[PINT_2_BANK(pint_val)]->mask_clear = PINT_BIT(pint_val);
 }
 
-static void bfin_gpio_unmask_irq(unsigned int irq)
+static void bfin_gpio_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
 	u32 pintbit = PINT_BIT(pint_val);
 	u32 bank = PINT_2_BANK(pint_val);
@@ -727,8 +736,9 @@ static void bfin_gpio_unmask_irq(unsigne
 	pint[bank]->mask_set = pintbit;
 }
 
-static unsigned int bfin_gpio_irq_startup(unsigned int irq)
+static unsigned int bfin_gpio_irq_startup(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 gpionr = irq_to_gpio(irq);
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
 
@@ -742,22 +752,24 @@ static unsigned int bfin_gpio_irq_startu
 	if (__test_and_set_bit(gpionr, gpio_enabled))
 		bfin_gpio_irq_prepare(gpionr);
 
-	bfin_gpio_unmask_irq(irq);
+	bfin_gpio_unmask_irq(desc);
 
 	return 0;
 }
 
-static void bfin_gpio_irq_shutdown(unsigned int irq)
+static void bfin_gpio_irq_shutdown(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 gpionr = irq_to_gpio(irq);
 
-	bfin_gpio_mask_irq(irq);
+	bfin_gpio_mask_irq(desc);
 	__clear_bit(gpionr, gpio_enabled);
 	bfin_gpio_irq_free(gpionr);
 }
 
-static int bfin_gpio_irq_type(unsigned int irq, unsigned int type)
+static int bfin_gpio_irq_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	int ret;
 	char buf[16];
 	u32 gpionr = irq_to_gpio(irq);
@@ -819,8 +831,9 @@ static int bfin_gpio_irq_type(unsigned i
 u32 pint_saved_masks[NR_PINT_SYS_IRQS];
 u32 pint_wakeup_masks[NR_PINT_SYS_IRQS];
 
-int bfin_gpio_set_wake(unsigned int irq, unsigned int state)
+int bfin_gpio_set_wake(struct irq_desc *desc, unsigned int state)
 {
+	unsigned int irq = desc->irq;
 	u32 pint_irq;
 	u32 pint_val = irq2pint_lut[irq - SYS_IRQS];
 	u32 bank = PINT_2_BANK(pint_val);
@@ -925,7 +938,7 @@ static void bfin_demux_gpio_irq(unsigned
 static struct irq_chip bfin_gpio_irqchip = {
 	.name = "GPIO",
 	.ack = bfin_gpio_ack_irq,
-	.mask = bfin_gpio_mask_irq,
+	.mask = bfin_gpio_mask_irq_desc,
 	.mask_ack = bfin_gpio_mask_ack_irq,
 	.unmask = bfin_gpio_unmask_irq,
 	.disable = bfin_gpio_mask_irq,
Index: linux-2.6/arch/blackfin/mach-common/smp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/smp.c
+++ linux-2.6/arch/blackfin/mach-common/smp.c
@@ -369,7 +369,7 @@ static void __cpuinit setup_secondary(un
 #else
 	timer_desc = irq_desc + IRQ_CORETMR;
 	setup_core_timer();
-	timer_desc->chip->enable(IRQ_CORETMR);
+	timer_desc->chip->enable(timer_desc);
 #endif
 }
 
Index: linux-2.6/arch/cris/arch-v10/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v10/kernel/irq.c
@@ -104,31 +104,33 @@ static void (*interrupt[NR_IRQS])(void)
 	IRQ31_interrupt
 };
 
-static void enable_crisv10_irq(unsigned int irq);
+static void enable_crisv10_irq(struct irq_desc *desc);
 
-static unsigned int startup_crisv10_irq(unsigned int irq)
+static unsigned int startup_crisv10_irq(struct irq_desc *desc)
 {
-	enable_crisv10_irq(irq);
+	enable_crisv10_irq(desc);
 	return 0;
 }
 
 #define shutdown_crisv10_irq	disable_crisv10_irq
 
-static void enable_crisv10_irq(unsigned int irq)
+static void enable_crisv10_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unmask_irq(irq);
 }
 
-static void disable_crisv10_irq(unsigned int irq)
+static void disable_crisv10_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	mask_irq(irq);
 }
 
-static void ack_crisv10_irq(unsigned int irq)
+static void ack_crisv10_irq(struct irq_desc *desc)
 {
 }
 
-static void end_crisv10_irq(unsigned int irq)
+static void end_crisv10_irq(struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/frv/kernel/irq-mb93091.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93091.c
+++ linux-2.6/arch/frv/kernel/irq-mb93091.c
@@ -36,8 +36,9 @@
 /*
  * on-motherboard FPGA PIC operations
  */
-static void frv_fpga_mask(unsigned int irq)
+static void frv_fpga_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t imr = __get_IMR();
 
 	imr |= 1 << (irq - IRQ_BASE_FPGA);
@@ -45,13 +46,15 @@ static void frv_fpga_mask(unsigned int i
 	__set_IMR(imr);
 }
 
-static void frv_fpga_ack(unsigned int irq)
+static void frv_fpga_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_mask_ack(unsigned int irq)
+static void frv_fpga_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t imr = __get_IMR();
 
 	imr |= 1 << (irq - IRQ_BASE_FPGA);
@@ -60,8 +63,9 @@ static void frv_fpga_mask_ack(unsigned i
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_unmask(unsigned int irq)
+static void frv_fpga_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t imr = __get_IMR();
 
 	imr &= ~(1 << (irq - IRQ_BASE_FPGA));
Index: linux-2.6/arch/frv/kernel/irq-mb93093.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93093.c
+++ linux-2.6/arch/frv/kernel/irq-mb93093.c
@@ -35,21 +35,24 @@
 /*
  * off-CPU FPGA PIC operations
  */
-static void frv_fpga_mask(unsigned int irq)
+static void frv_fpga_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t imr = __get_IMR();
 
 	imr |= 1 << (irq - IRQ_BASE_FPGA);
 	__set_IMR(imr);
 }
 
-static void frv_fpga_ack(unsigned int irq)
+static void frv_fpga_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_mask_ack(unsigned int irq)
+static void frv_fpga_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t imr = __get_IMR();
 
 	imr |= 1 << (irq - IRQ_BASE_FPGA);
@@ -58,8 +61,9 @@ static void frv_fpga_mask_ack(unsigned i
 	__clr_IFR(1 << (irq - IRQ_BASE_FPGA));
 }
 
-static void frv_fpga_unmask(unsigned int irq)
+static void frv_fpga_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint16_t imr = __get_IMR();
 
 	imr &= ~(1 << (irq - IRQ_BASE_FPGA));
Index: linux-2.6/arch/frv/kernel/irq-mb93493.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93493.c
+++ linux-2.6/arch/frv/kernel/irq-mb93493.c
@@ -45,8 +45,9 @@
  * daughter board PIC operations
  * - there is no way to ACK interrupts in the MB93493 chip
  */
-static void frv_mb93493_mask(unsigned int irq)
+static void frv_mb93493_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint32_t iqsr;
 	volatile void *piqsr;
 
@@ -60,12 +61,13 @@ static void frv_mb93493_mask(unsigned in
 	writel(iqsr, piqsr);
 }
 
-static void frv_mb93493_ack(unsigned int irq)
+static void frv_mb93493_ack(struct irq_desc *desc)
 {
 }
 
-static void frv_mb93493_unmask(unsigned int irq)
+static void frv_mb93493_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	uint32_t iqsr;
 	volatile void *piqsr;
 
Index: linux-2.6/arch/frv/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq.c
+++ linux-2.6/arch/frv/kernel/irq.c
@@ -96,32 +96,37 @@ int show_interrupts(struct seq_file *p,
 /*
  * on-CPU PIC operations
  */
-static void frv_cpupic_ack(unsigned int irqlevel)
+static void frv_cpupic_ack(struct irq_desc *desc)
 {
-	__clr_RC(irqlevel);
+	unsigned int irq = desc->irq;
+	__clr_RC(irq);
 	__clr_IRL();
 }
 
-static void frv_cpupic_mask(unsigned int irqlevel)
+static void frv_cpupic_mask(struct irq_desc *desc)
 {
-	__set_MASK(irqlevel);
+	unsigned int irq = desc->irq;
+	__set_MASK(irq);
 }
 
-static void frv_cpupic_mask_ack(unsigned int irqlevel)
+static void frv_cpupic_mask_ack(struct irq_desc *desc)
 {
-	__set_MASK(irqlevel);
-	__clr_RC(irqlevel);
+	unsigned int irq = desc->irq;
+	__set_MASK(irq);
+	__clr_RC(irq);
 	__clr_IRL();
 }
 
-static void frv_cpupic_unmask(unsigned int irqlevel)
+static void frv_cpupic_unmask(struct irq_desc *desc)
 {
-	__clr_MASK(irqlevel);
+	unsigned int irq = desc->irq;
+	__clr_MASK(irq);
 }
 
-static void frv_cpupic_end(unsigned int irqlevel)
+static void frv_cpupic_end(struct irq_desc *desc)
 {
-	__clr_MASK(irqlevel);
+	unsigned int irq = desc->irq;
+	__clr_MASK(irq);
 }
 
 static struct irq_chip frv_cpu_pic = {
Index: linux-2.6/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/irq.c
+++ linux-2.6/arch/h8300/kernel/irq.c
@@ -38,32 +38,36 @@ static inline int is_ext_irq(unsigned in
 	return (irq >= EXT_IRQ0 && irq <= (EXT_IRQ0 + EXT_IRQS));
 }
 
-static void h8300_enable_irq(unsigned int irq)
+static void h8300_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (is_ext_irq(irq))
 		IER_REGS |= 1 << (irq - EXT_IRQ0);
 }
 
-static void h8300_disable_irq(unsigned int irq)
+static void h8300_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (is_ext_irq(irq))
 		IER_REGS &= ~(1 << (irq - EXT_IRQ0));
 }
 
-static void h8300_end_irq(unsigned int irq)
+static void h8300_end_irq(struct irq_desc *desc)
 {
 }
 
-static unsigned int h8300_startup_irq(unsigned int irq)
+static unsigned int h8300_startup_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (is_ext_irq(irq))
 		return h8300_enable_irq_pin(irq);
 	else
 		return 0;
 }
 
-static void h8300_shutdown_irq(unsigned int irq)
+static void h8300_shutdown_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (is_ext_irq(irq))
 		h8300_disable_irq_pin(irq);
 }
Index: linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
@@ -11,18 +11,18 @@
 #include <linux/irq.h>
 
 static unsigned int
-hpsim_irq_startup (unsigned int irq)
+hpsim_irq_startup(struct irq_desc *desc)
 {
 	return 0;
 }
 
 static void
-hpsim_irq_noop (unsigned int irq)
+hpsim_irq_noop(struct irq_desc *desc)
 {
 }
 
 static int
-hpsim_set_affinity_noop(unsigned int a, const struct cpumask *b)
+hpsim_set_affinity_noop(struct irq_desc *desc, const struct cpumask *b)
 {
 	return 0;
 }
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -267,6 +267,10 @@ static void
 nop (unsigned int irq)
 {
 	/* do nothing... */
+static void
+nop_desc(struct irq_desc *desc)
+{
+	/* do nothing... */
 }
 
 
@@ -294,8 +298,9 @@ kexec_disable_iosapic(void)
 #endif
 
 static void
-mask_irq (unsigned int irq)
+mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 low32;
 	int rte_index;
 	struct iosapic_rte_info *rte;
@@ -312,8 +317,9 @@ mask_irq (unsigned int irq)
 }
 
 static void
-unmask_irq (unsigned int irq)
+unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 low32;
 	int rte_index;
 	struct iosapic_rte_info *rte;
@@ -328,11 +334,11 @@ unmask_irq (unsigned int irq)
 	}
 }
 
-
 static int
-iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
+iosapic_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
+	unsigned int irq = desc->irq;
 	u32 high32, low32;
 	int cpu, dest, rte_index;
 	int redir = (irq & IA64_IRQ_REDIRECTED) ? 1 : 0;
@@ -386,38 +392,39 @@ iosapic_set_affinity(unsigned int irq, c
  */
 
 static unsigned int
-iosapic_startup_level_irq (unsigned int irq)
+iosapic_startup_level_irq (struct irq_desc *desc)
 {
-	unmask_irq(irq);
+	unmask_irq(desc);
 	return 0;
 }
 
 static void
-iosapic_end_level_irq (unsigned int irq)
+iosapic_end_level_irq (struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	ia64_vector vec = irq_to_vector(irq);
 	struct iosapic_rte_info *rte;
 	int do_unmask_irq = 0;
 
 	irq_complete_move(irq);
-	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
+	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
-		mask_irq(irq);
+		mask_irq(desc);
 	}
 
 	list_for_each_entry(rte, &iosapic_intr_info[irq].rtes, rte_list)
 		iosapic_eoi(rte->iosapic->addr, vec);
 
 	if (unlikely(do_unmask_irq)) {
-		move_masked_irq(irq);
-		unmask_irq(irq);
+		move_masked_irq(desc);
+		unmask_irq(desc);
 	}
 }
 
 #define iosapic_shutdown_level_irq	mask_irq
 #define iosapic_enable_level_irq	unmask_irq
 #define iosapic_disable_level_irq	mask_irq
-#define iosapic_ack_level_irq		nop
+#define iosapic_ack_level_irq		nop_desc
 
 static struct irq_chip irq_type_iosapic_level = {
 	.name =		"IO-SAPIC-level",
@@ -437,9 +444,9 @@ static struct irq_chip irq_type_iosapic_
  */
 
 static unsigned int
-iosapic_startup_edge_irq (unsigned int irq)
+iosapic_startup_edge_irq (struct irq_desc *desc)
 {
-	unmask_irq(irq);
+	unmask_irq(desc);
 	/*
 	 * IOSAPIC simply drops interrupts pended while the
 	 * corresponding pin was masked, so we can't know if an
@@ -449,12 +456,12 @@ iosapic_startup_edge_irq (unsigned int i
 }
 
 static void
-iosapic_ack_edge_irq (unsigned int irq)
+iosapic_ack_edge_irq (struct irq_desc *desc)
 {
-	struct irq_desc *idesc = irq_desc + irq;
+	unsigned int irq = desc->irq;
 
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(desc);
 	/*
 	 * Once we have recorded IRQ_PENDING already, we can mask the
 	 * interrupt for real. This prevents IRQ storms from unhandled
@@ -462,12 +469,12 @@ iosapic_ack_edge_irq (unsigned int irq)
 	 */
 	if ((idesc->status & (IRQ_PENDING|IRQ_DISABLED)) ==
 	    (IRQ_PENDING|IRQ_DISABLED))
-		mask_irq(irq);
+		mask_irq(desc);
 }
 
 #define iosapic_enable_edge_irq		unmask_irq
 #define iosapic_disable_edge_irq	nop
-#define iosapic_end_edge_irq		nop
+#define iosapic_end_edge_irq		nop_desc
 
 static struct irq_chip irq_type_iosapic_edge = {
 	.name =		"IO-SAPIC-edge",
Index: linux-2.6/arch/ia64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq.c
+++ linux-2.6/arch/ia64/kernel/irq.c
@@ -162,10 +162,10 @@ static void migrate_irqs(void)
 			 */
 			if (desc->chip && desc->chip->disable &&
 				desc->chip->enable && desc->chip->set_affinity) {
-				desc->chip->disable(irq);
-				desc->chip->set_affinity(irq,
+				desc->chip->disable(desc);
+				desc->chip->set_affinity(desc,
 							 cpumask_of(new_cpu));
-				desc->chip->enable(irq);
+				desc->chip->enable(desc);
 			} else {
 				WARN_ON((!(desc->chip) || !(desc->chip->disable) ||
 						!(desc->chip->enable) ||
Index: linux-2.6/arch/ia64/kernel/irq_lsapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_lsapic.c
+++ linux-2.6/arch/ia64/kernel/irq_lsapic.c
@@ -15,19 +15,21 @@
 #include <linux/irq.h>
 
 static unsigned int
-lsapic_noop_startup (unsigned int irq)
+lsapic_noop_startup (struct irq_desc *desc)
 {
 	return 0;
 }
 
 static void
-lsapic_noop (unsigned int irq)
+lsapic_noop (struct irq_desc *desc)
 {
 	/* nothing to do... */
 }
 
-static int lsapic_retrigger(unsigned int irq)
+static int lsapic_retrigger(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
+
 	ia64_resend_irq(irq);
 
 	return 1;
Index: linux-2.6/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6/arch/ia64/kernel/msi_ia64.c
@@ -12,9 +12,10 @@
 static struct irq_chip	ia64_msi_chip;
 
 #ifdef CONFIG_SMP
-static int ia64_set_msi_irq_affinity(unsigned int irq,
+static int ia64_set_msi_irq_affinity(struct irq_desc *desc,
 				      const cpumask_t *cpu_mask)
 {
+	unsigned int irq = desc->irq;
 	struct msi_msg msg;
 	u32 addr, data;
 	int cpu = first_cpu(*cpu_mask);
@@ -38,7 +39,7 @@ static int ia64_set_msi_irq_affinity(uns
 	msg.data = data;
 
 	write_msi_msg(irq, &msg);
-	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
+	cpumask_copy(desc->affinity, cpumask_of(cpu));
 
 	return 0;
 }
@@ -84,15 +85,17 @@ void ia64_teardown_msi_irq(unsigned int
 	destroy_irq(irq);
 }
 
-static void ia64_ack_msi_irq(unsigned int irq)
+static void ia64_ack_msi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(desc);
 	ia64_eoi();
 }
 
-static int ia64_msi_retrigger_irq(unsigned int irq)
+static int ia64_msi_retrigger_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int vector = irq_to_vector(irq);
 	ia64_resend_irq(vector);
 
@@ -132,8 +135,9 @@ void arch_teardown_msi_irq(unsigned int
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = irq_cfg + irq;
 	struct msi_msg msg;
 	int cpu = cpumask_first(mask);
@@ -152,7 +156,7 @@ static int dmar_msi_set_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID_CPU(cpu_physical_id(cpu));
 
 	dmar_msi_write(irq, &msg);
-	cpumask_copy(irq_desc[irq].affinity, mask);
+	cpumask_copy(desc->affinity, mask);
 
 	return 0;
 }
Index: linux-2.6/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6/arch/ia64/kernel/smpboot.c
@@ -701,9 +701,9 @@ int migrate_platform_irqs(unsigned int c
 			 * polling before making changes.
 			 */
 			if (desc) {
-				desc->chip->disable(ia64_cpe_irq);
-				desc->chip->set_affinity(ia64_cpe_irq, mask);
-				desc->chip->enable(ia64_cpe_irq);
+				desc->chip->disable(desc);
+				desc->chip->set_affinity(desc, mask);
+				desc->chip->enable(desc);
 				printk ("Re-targetting CPEI to cpu %d\n", new_cpei_cpu);
 			}
 		}
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -77,31 +77,34 @@ u64 sn_intr_redirect(nasid_t local_nasid
 	return ret_stuff.status;
 }
 
-static unsigned int sn_startup_irq(unsigned int irq)
+static unsigned int sn_startup_irq(struct irq_desc *desc)
 {
 	return 0;
 }
 
-static void sn_shutdown_irq(unsigned int irq)
+static void sn_shutdown_irq(struct irq_desc *desc)
 {
 }
 
 extern void ia64_mca_register_cpev(int);
 
-static void sn_disable_irq(unsigned int irq)
+static void sn_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq == local_vector_to_irq(IA64_CPE_VECTOR))
 		ia64_mca_register_cpev(0);
 }
 
-static void sn_enable_irq(unsigned int irq)
+static void sn_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq == local_vector_to_irq(IA64_CPE_VECTOR))
 		ia64_mca_register_cpev(irq);
 }
 
-static void sn_ack_irq(unsigned int irq)
+static void sn_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u64 event_occurred, mask;
 
 	irq = irq & 0xff;
@@ -110,11 +113,12 @@ static void sn_ack_irq(unsigned int irq)
 	HUB_S((u64*)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED_ALIAS), mask);
 	__set_bit(irq, (volatile void *)pda->sn_in_service_ivecs);
 
-	move_native_irq(irq);
+	move_native_irq(desc);
 }
 
-static void sn_end_irq(unsigned int irq)
+static void sn_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int ivec;
 	u64 event_occurred;
 
@@ -227,8 +231,9 @@ finish_up:
 	return new_irq_info;
 }
 
-static int sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
+static int sn_set_affinity_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
+	unsigned int irq = desc->irq;
 	struct sn_irq_info *sn_irq_info, *sn_irq_info_safe;
 	nasid_t nasid;
 	int slice;
@@ -258,12 +263,12 @@ void sn_set_err_irq_affinity(unsigned in
 #endif
 
 static void
-sn_mask_irq(unsigned int irq)
+sn_mask_irq(struct irq_desc *desc)
 {
 }
 
 static void
-sn_unmask_irq(unsigned int irq)
+sn_unmask_irq(struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6/arch/ia64/sn/kernel/msi_sn.c
@@ -151,9 +151,10 @@ int sn_setup_msi_irq(struct pci_dev *pde
 }
 
 #ifdef CONFIG_SMP
-static int sn_set_msi_irq_affinity(unsigned int irq,
+static int sn_set_msi_irq_affinity(struct irq_desc *desc,
 				    const struct cpumask *cpu_mask)
 {
+	unsigned int irq = desc->irq;
 	struct msi_msg msg;
 	int slice;
 	nasid_t nasid;
@@ -205,20 +206,21 @@ static int sn_set_msi_irq_affinity(unsig
 	msg.address_lo = (u32)(bus_addr & 0x00000000ffffffff);
 
 	write_msi_msg(irq, &msg);
-	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
+	cpumask_copy(desc->affinity, cpu_mask);
 
 	return 0;
 }
 #endif /* CONFIG_SMP */
 
-static void sn_ack_msi_irq(unsigned int irq)
+static void sn_ack_msi_irq(struct irq_desc *desc)
 {
 	move_native_irq(irq);
 	ia64_eoi();
 }
 
-static int sn_msi_retrigger_irq(unsigned int irq)
+static int sn_msi_retrigger_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int vector = irq;
 	ia64_resend_irq(vector);
 
Index: linux-2.6/arch/m32r/platforms/m32104ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32104ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32104ut/setup.c
@@ -21,8 +21,9 @@
 
 icu_data_t icu_data[NR_IRQS];
 
-static void disable_m32104ut_irq(unsigned int irq)
+static void disable_m32104ut_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -30,8 +31,9 @@ static void disable_m32104ut_irq(unsigne
 	outl(data, port);
 }
 
-static void enable_m32104ut_irq(unsigned int irq)
+static void enable_m32104ut_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -39,24 +41,25 @@ static void enable_m32104ut_irq(unsigned
 	outl(data, port);
 }
 
-static void mask_and_ack_m32104ut(unsigned int irq)
+static void mask_and_ack_m32104ut(struct irq_desc *desc)
 {
-	disable_m32104ut_irq(irq);
+	disable_m32104ut_irq(desc);
 }
 
 static void end_m32104ut_irq(unsigned int irq)
 {
-	enable_m32104ut_irq(irq);
+	enable_m32104ut_irq(desc);
 }
 
-static unsigned int startup_m32104ut_irq(unsigned int irq)
+static unsigned int startup_m32104ut_irq(struct irq_desc *desc)
 {
-	enable_m32104ut_irq(irq);
+	enable_m32104ut_irq(desc);
 	return (0);
 }
 
-static void shutdown_m32104ut_irq(unsigned int irq)
+static void shutdown_m32104ut_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
Index: linux-2.6/arch/m32r/platforms/m32700ut/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/m32700ut/setup.c
+++ linux-2.6/arch/m32r/platforms/m32700ut/setup.c
@@ -27,8 +27,9 @@
 
 icu_data_t icu_data[M32700UT_NUM_CPU_IRQ];
 
-static void disable_m32700ut_irq(unsigned int irq)
+static void disable_m32700ut_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -36,8 +37,9 @@ static void disable_m32700ut_irq(unsigne
 	outl(data, port);
 }
 
-static void enable_m32700ut_irq(unsigned int irq)
+static void enable_m32700ut_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -45,24 +47,25 @@ static void enable_m32700ut_irq(unsigned
 	outl(data, port);
 }
 
-static void mask_and_ack_m32700ut(unsigned int irq)
+static void mask_and_ack_m32700ut(struct irq_desc *desc)
 {
-	disable_m32700ut_irq(irq);
+	disable_m32700ut_irq(desc);
 }
 
-static void end_m32700ut_irq(unsigned int irq)
+static void end_m32700ut_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_irq(irq);
+	enable_m32700ut_irq(desc);
 }
 
-static unsigned int startup_m32700ut_irq(unsigned int irq)
+static unsigned int startup_m32700ut_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_irq(irq);
+	enable_m32700ut_irq(desc);
 	return (0);
 }
 
-static void shutdown_m32700ut_irq(unsigned int irq)
+static void shutdown_m32700ut_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
@@ -93,8 +96,9 @@ typedef struct {
 
 static pld_icu_data_t pld_icu_data[M32700UT_NUM_PLD_IRQ];
 
-static void disable_m32700ut_pld_irq(unsigned int irq)
+static void disable_m32700ut_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -105,8 +109,9 @@ static void disable_m32700ut_pld_irq(uns
 	outw(data, port);
 }
 
-static void enable_m32700ut_pld_irq(unsigned int irq)
+static void enable_m32700ut_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -117,26 +122,27 @@ static void enable_m32700ut_pld_irq(unsi
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_pld(unsigned int irq)
+static void mask_and_ack_m32700ut_pld(struct irq_desc *desc)
 {
-	disable_m32700ut_pld_irq(irq);
+	disable_m32700ut_pld_irq(desc);
 //	mask_and_ack_m32700ut(M32R_IRQ_INT1);
 }
 
-static void end_m32700ut_pld_irq(unsigned int irq)
+static void end_m32700ut_pld_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_pld_irq(irq);
-	end_m32700ut_irq(M32R_IRQ_INT1);
+	enable_m32700ut_pld_irq(desc);
+	end_m32700ut_irq(irq_to_desc(M32R_IRQ_INT1));
 }
 
-static unsigned int startup_m32700ut_pld_irq(unsigned int irq)
+static unsigned int startup_m32700ut_pld_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_pld_irq(irq);
+	enable_m32700ut_pld_irq(desc);
 	return (0);
 }
 
-static void shutdown_m32700ut_pld_irq(unsigned int irq)
+static void shutdown_m32700ut_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 	unsigned int pldirq;
 
@@ -166,8 +172,9 @@ static struct irq_chip m32700ut_pld_irq_
 
 static pld_icu_data_t lanpld_icu_data[M32700UT_NUM_LAN_PLD_IRQ];
 
-static void disable_m32700ut_lanpld_irq(unsigned int irq)
+static void disable_m32700ut_lanpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -177,8 +184,9 @@ static void disable_m32700ut_lanpld_irq(
 	outw(data, port);
 }
 
-static void enable_m32700ut_lanpld_irq(unsigned int irq)
+static void enable_m32700ut_lanpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -188,29 +196,30 @@ static void enable_m32700ut_lanpld_irq(u
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_lanpld(unsigned int irq)
+static void mask_and_ack_m32700ut_lanpld(struct irq_desc *desc)
 {
-	disable_m32700ut_lanpld_irq(irq);
+	disable_m32700ut_lanpld_irq(desc);
 }
 
-static void end_m32700ut_lanpld_irq(unsigned int irq)
+static void end_m32700ut_lanpld_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_lanpld_irq(irq);
-	end_m32700ut_irq(M32R_IRQ_INT0);
+	enable_m32700ut_lanpld_irq(desc);
+	end_m32700ut_irq(irq_to_desc(M32R_IRQ_INT0));
 }
 
-static unsigned int startup_m32700ut_lanpld_irq(unsigned int irq)
+static unsigned int startup_m32700ut_lanpld_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_lanpld_irq(irq);
+	enable_m32700ut_lanpld_irq(desc);
 	return (0);
 }
 
-static void shutdown_m32700ut_lanpld_irq(unsigned int irq)
+static void shutdown_m32700ut_lanpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 	unsigned int pldirq;
 
-	pldirq = irq2lanpldirq(irq);
+	pldirq = irq2lanpldirq(desc);
 	port = lanpldirq2port(pldirq);
 	outw(PLD_ICUCR_ILEVEL7, port);
 }
@@ -235,8 +244,9 @@ static struct irq_chip m32700ut_lanpld_i
 
 static pld_icu_data_t lcdpld_icu_data[M32700UT_NUM_LCD_PLD_IRQ];
 
-static void disable_m32700ut_lcdpld_irq(unsigned int irq)
+static void disable_m32700ut_lcdpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -246,8 +256,9 @@ static void disable_m32700ut_lcdpld_irq(
 	outw(data, port);
 }
 
-static void enable_m32700ut_lcdpld_irq(unsigned int irq)
+static void enable_m32700ut_lcdpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -257,25 +268,26 @@ static void enable_m32700ut_lcdpld_irq(u
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_lcdpld(unsigned int irq)
+static void mask_and_ack_m32700ut_lcdpld(struct irq_desc *desc)
 {
-	disable_m32700ut_lcdpld_irq(irq);
+	disable_m32700ut_lcdpld_irq(desc);
 }
 
-static void end_m32700ut_lcdpld_irq(unsigned int irq)
+static void end_m32700ut_lcdpld_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_lcdpld_irq(irq);
-	end_m32700ut_irq(M32R_IRQ_INT2);
+	enable_m32700ut_lcdpld_irq(desc);
+	end_m32700ut_irq(irq_to_desc(M32R_IRQ_INT2));
 }
 
-static unsigned int startup_m32700ut_lcdpld_irq(unsigned int irq)
+static unsigned int startup_m32700ut_lcdpld_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_lcdpld_irq(irq);
+	enable_m32700ut_lcdpld_irq(desc);
 	return (0);
 }
 
-static void shutdown_m32700ut_lcdpld_irq(unsigned int irq)
+static void shutdown_m32700ut_lcdpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 	unsigned int pldirq;
 
Index: linux-2.6/arch/m32r/platforms/mappi/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi/setup.c
@@ -20,8 +20,9 @@
 
 icu_data_t icu_data[NR_IRQS];
 
-static void disable_mappi_irq(unsigned int irq)
+static void disable_mappi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -29,8 +30,9 @@ static void disable_mappi_irq(unsigned i
 	outl(data, port);
 }
 
-static void enable_mappi_irq(unsigned int irq)
+static void enable_mappi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -38,25 +40,26 @@ static void enable_mappi_irq(unsigned in
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_and_ack_mappi(struct irq_desc *desc)
 {
-	disable_mappi_irq(irq);
+	disable_mappi_irq(desc);
 }
 
-static void end_mappi_irq(unsigned int irq)
+static void end_mappi_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_mappi_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		enable_mappi_irq(desc);
 }
 
-static unsigned int startup_mappi_irq(unsigned int irq)
+static unsigned int startup_mappi_irq(struct irq_desc *desc)
 {
 	enable_mappi_irq(irq);
 	return (0);
 }
 
-static void shutdown_mappi_irq(unsigned int irq)
+static void shutdown_mappi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
Index: linux-2.6/arch/m32r/platforms/mappi2/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi2/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi2/setup.c
@@ -20,8 +20,9 @@
 
 icu_data_t icu_data[NR_IRQS];
 
-static void disable_mappi2_irq(unsigned int irq)
+static void disable_mappi2_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	if ((irq == 0) ||(irq >= NR_IRQS))  {
@@ -33,8 +34,9 @@ static void disable_mappi2_irq(unsigned
 	outl(data, port);
 }
 
-static void enable_mappi2_irq(unsigned int irq)
+static void enable_mappi2_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	if ((irq == 0) ||(irq >= NR_IRQS))  {
@@ -46,24 +48,25 @@ static void enable_mappi2_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi2(unsigned int irq)
+static void mask_and_ack_mappi2(struct irq_desc *desc)
 {
-	disable_mappi2_irq(irq);
+	disable_mappi2_irq(desc);
 }
 
-static void end_mappi2_irq(unsigned int irq)
+static void end_mappi2_irq(struct irq_desc *desc)
 {
-	enable_mappi2_irq(irq);
+	enable_mappi2_irq(desc);
 }
 
-static unsigned int startup_mappi2_irq(unsigned int irq)
+static unsigned int startup_mappi2_irq(struct irq_desc *desc)
 {
-	enable_mappi2_irq(irq);
+	enable_mappi2_irq(desc);
 	return (0);
 }
 
-static void shutdown_mappi2_irq(unsigned int irq)
+static void shutdown_mappi2_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
Index: linux-2.6/arch/m32r/platforms/mappi3/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/mappi3/setup.c
+++ linux-2.6/arch/m32r/platforms/mappi3/setup.c
@@ -20,8 +20,9 @@
 
 icu_data_t icu_data[NR_IRQS];
 
-static void disable_mappi3_irq(unsigned int irq)
+static void disable_mappi3_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	if ((irq == 0) ||(irq >= NR_IRQS))  {
@@ -33,8 +34,9 @@ static void disable_mappi3_irq(unsigned
 	outl(data, port);
 }
 
-static void enable_mappi3_irq(unsigned int irq)
+static void enable_mappi3_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	if ((irq == 0) ||(irq >= NR_IRQS))  {
@@ -46,24 +48,25 @@ static void enable_mappi3_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi3(unsigned int irq)
+static void mask_and_ack_mappi3(struct irq_desc *desc)
 {
-	disable_mappi3_irq(irq);
+	disable_mappi3_irq(desc);
 }
 
-static void end_mappi3_irq(unsigned int irq)
+static void end_mappi3_irq(struct irq_desc *desc)
 {
-	enable_mappi3_irq(irq);
+	enable_mappi3_irq(desc);
 }
 
-static unsigned int startup_mappi3_irq(unsigned int irq)
+static unsigned int startup_mappi3_irq(struct irq_desc *desc)
 {
-	enable_mappi3_irq(irq);
+	enable_mappi3_irq(desc);
 	return (0);
 }
 
-static void shutdown_mappi3_irq(unsigned int irq)
+static void shutdown_mappi3_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
Index: linux-2.6/arch/m32r/platforms/oaks32r/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/oaks32r/setup.c
+++ linux-2.6/arch/m32r/platforms/oaks32r/setup.c
@@ -19,8 +19,9 @@
 
 icu_data_t icu_data[NR_IRQS];
 
-static void disable_oaks32r_irq(unsigned int irq)
+static void disable_oaks32r_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -28,8 +29,9 @@ static void disable_oaks32r_irq(unsigned
 	outl(data, port);
 }
 
-static void enable_oaks32r_irq(unsigned int irq)
+static void enable_oaks32r_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -37,24 +39,25 @@ static void enable_oaks32r_irq(unsigned
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_and_ack_mappi(struct irq_desc *desc)
 {
-	disable_oaks32r_irq(irq);
+	disable_oaks32r_irq(desc);
 }
 
-static void end_oaks32r_irq(unsigned int irq)
+static void end_oaks32r_irq(struct irq_desc *desc)
 {
-	enable_oaks32r_irq(irq);
+	enable_oaks32r_irq(desc);
 }
 
-static unsigned int startup_oaks32r_irq(unsigned int irq)
+static unsigned int startup_oaks32r_irq(struct irq_desc *desc)
 {
-	enable_oaks32r_irq(irq);
+	enable_oaks32r_irq(desc);
 	return (0);
 }
 
-static void shutdown_oaks32r_irq(unsigned int irq)
+static void shutdown_oaks32r_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
Index: linux-2.6/arch/m32r/platforms/opsput/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/opsput/setup.c
+++ linux-2.6/arch/m32r/platforms/opsput/setup.c
@@ -28,8 +28,9 @@
 
 icu_data_t icu_data[OPSPUT_NUM_CPU_IRQ];
 
-static void disable_opsput_irq(unsigned int irq)
+static void disable_opsput_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -37,8 +38,9 @@ static void disable_opsput_irq(unsigned
 	outl(data, port);
 }
 
-static void enable_opsput_irq(unsigned int irq)
+static void enable_opsput_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -46,24 +48,25 @@ static void enable_opsput_irq(unsigned i
 	outl(data, port);
 }
 
-static void mask_and_ack_opsput(unsigned int irq)
+static void mask_and_ack_opsput(struct irq_desc *desc)
 {
-	disable_opsput_irq(irq);
+	disable_opsput_irq(desc);
 }
 
-static void end_opsput_irq(unsigned int irq)
+static void end_opsput_irq(struct irq_desc *desc)
 {
-	enable_opsput_irq(irq);
+	enable_opsput_irq(desc);
 }
 
-static unsigned int startup_opsput_irq(unsigned int irq)
+static unsigned int startup_opsput_irq(struct irq_desc *desc)
 {
-	enable_opsput_irq(irq);
+	enable_opsput_irq(desc);
 	return (0);
 }
 
-static void shutdown_opsput_irq(unsigned int irq)
+static void shutdown_opsput_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
@@ -94,8 +97,9 @@ typedef struct {
 
 static pld_icu_data_t pld_icu_data[OPSPUT_NUM_PLD_IRQ];
 
-static void disable_opsput_pld_irq(unsigned int irq)
+static void disable_opsput_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -106,8 +110,9 @@ static void disable_opsput_pld_irq(unsig
 	outw(data, port);
 }
 
-static void enable_opsput_pld_irq(unsigned int irq)
+static void enable_opsput_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -118,26 +123,27 @@ static void enable_opsput_pld_irq(unsign
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_pld(unsigned int irq)
+static void mask_and_ack_opsput_pld(struct irq_desc *desc)
 {
-	disable_opsput_pld_irq(irq);
+	disable_opsput_pld_irq(desc);
 //	mask_and_ack_opsput(M32R_IRQ_INT1);
 }
 
 static void end_opsput_pld_irq(unsigned int irq)
 {
-	enable_opsput_pld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT1);
+	enable_opsput_pld_irq(desc);
+	end_opsput_irq(irq_to_desc(M32R_IRQ_INT1));
 }
 
-static unsigned int startup_opsput_pld_irq(unsigned int irq)
+static unsigned int startup_opsput_pld_irq(struct irq_desc *desc)
 {
-	enable_opsput_pld_irq(irq);
+	enable_opsput_pld_irq(desc);
 	return (0);
 }
 
-static void shutdown_opsput_pld_irq(unsigned int irq)
+static void shutdown_opsput_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 	unsigned int pldirq;
 
@@ -167,8 +173,9 @@ static struct irq_chip opsput_pld_irq_ty
 
 static pld_icu_data_t lanpld_icu_data[OPSPUT_NUM_LAN_PLD_IRQ];
 
-static void disable_opsput_lanpld_irq(unsigned int irq)
+static void disable_opsput_lanpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -178,8 +185,9 @@ static void disable_opsput_lanpld_irq(un
 	outw(data, port);
 }
 
-static void enable_opsput_lanpld_irq(unsigned int irq)
+static void enable_opsput_lanpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -189,25 +197,26 @@ static void enable_opsput_lanpld_irq(uns
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_lanpld(unsigned int irq)
+static void mask_and_ack_opsput_lanpld(struct irq_desc *desc)
 {
-	disable_opsput_lanpld_irq(irq);
+	disable_opsput_lanpld_irq(desc);
 }
 
-static void end_opsput_lanpld_irq(unsigned int irq)
+static void end_opsput_lanpld_irq(struct irq_desc *desc)
 {
-	enable_opsput_lanpld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT0);
+	enable_opsput_lanpld_irq(desc);
+	end_opsput_irq(irq_to_desc(M32R_IRQ_INT0));
 }
 
-static unsigned int startup_opsput_lanpld_irq(unsigned int irq)
+static unsigned int startup_opsput_lanpld_irq(struct irq_desc *desc)
 {
-	enable_opsput_lanpld_irq(irq);
+	enable_opsput_lanpld_irq(desc);
 	return (0);
 }
 
-static void shutdown_opsput_lanpld_irq(unsigned int irq)
+static void shutdown_opsput_lanpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 	unsigned int pldirq;
 
@@ -236,8 +245,9 @@ static struct irq_chip opsput_lanpld_irq
 
 static pld_icu_data_t lcdpld_icu_data[OPSPUT_NUM_LCD_PLD_IRQ];
 
-static void disable_opsput_lcdpld_irq(unsigned int irq)
+static void disable_opsput_lcdpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -247,8 +257,9 @@ static void disable_opsput_lcdpld_irq(un
 	outw(data, port);
 }
 
-static void enable_opsput_lcdpld_irq(unsigned int irq)
+static void enable_opsput_lcdpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -258,25 +269,26 @@ static void enable_opsput_lcdpld_irq(uns
 	outw(data, port);
 }
 
-static void mask_and_ack_opsput_lcdpld(unsigned int irq)
+static void mask_and_ack_opsput_lcdpld(struct irq_desc *desc)
 {
-	disable_opsput_lcdpld_irq(irq);
+	disable_opsput_lcdpld_irq(desc);
 }
 
-static void end_opsput_lcdpld_irq(unsigned int irq)
+static void end_opsput_lcdpld_irq(struct irq_desc *desc)
 {
-	enable_opsput_lcdpld_irq(irq);
-	end_opsput_irq(M32R_IRQ_INT2);
+	enable_opsput_lcdpld_irq(desc);
+	end_opsput_irq(irq_to_desc(M32R_IRQ_INT2));
 }
 
-static unsigned int startup_opsput_lcdpld_irq(unsigned int irq)
+static unsigned int startup_opsput_lcdpld_irq(struct irq_desc *desc)
 {
-	enable_opsput_lcdpld_irq(irq);
+	enable_opsput_lcdpld_irq(desc);
 	return (0);
 }
 
-static void shutdown_opsput_lcdpld_irq(unsigned int irq)
+static void shutdown_opsput_lcdpld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 	unsigned int pldirq;
 
Index: linux-2.6/arch/m32r/platforms/usrv/setup.c
===================================================================
--- linux-2.6.orig/arch/m32r/platforms/usrv/setup.c
+++ linux-2.6/arch/m32r/platforms/usrv/setup.c
@@ -19,8 +19,9 @@
 
 icu_data_t icu_data[M32700UT_NUM_CPU_IRQ];
 
-static void disable_mappi_irq(unsigned int irq)
+static void disable_mappi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -28,8 +29,9 @@ static void disable_mappi_irq(unsigned i
 	outl(data, port);
 }
 
-static void enable_mappi_irq(unsigned int irq)
+static void enable_mappi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 
 	port = irq2port(irq);
@@ -37,24 +39,25 @@ static void enable_mappi_irq(unsigned in
 	outl(data, port);
 }
 
-static void mask_and_ack_mappi(unsigned int irq)
+static void mask_and_ack_mappi(struct irq_desc *desc)
 {
-	disable_mappi_irq(irq);
+	disable_mappi_irq(desc);
 }
 
-static void end_mappi_irq(unsigned int irq)
+static void end_mappi_irq(struct irq_desc *desc)
 {
-	enable_mappi_irq(irq);
+	enable_mappi_irq(desc);
 }
 
-static unsigned int startup_mappi_irq(unsigned int irq)
+static unsigned int startup_mappi_irq(struct irq_desc *desc)
 {
-	enable_mappi_irq(irq);
+	enable_mappi_irq(desc);
 	return 0;
 }
 
-static void shutdown_mappi_irq(unsigned int irq)
+static void shutdown_mappi_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 
 	port = irq2port(irq);
@@ -85,8 +88,9 @@ typedef struct {
 
 static pld_icu_data_t pld_icu_data[M32700UT_NUM_PLD_IRQ];
 
-static void disable_m32700ut_pld_irq(unsigned int irq)
+static void disable_m32700ut_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -96,8 +100,9 @@ static void disable_m32700ut_pld_irq(uns
 	outw(data, port);
 }
 
-static void enable_m32700ut_pld_irq(unsigned int irq)
+static void enable_m32700ut_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port, data;
 	unsigned int pldirq;
 
@@ -107,25 +112,26 @@ static void enable_m32700ut_pld_irq(unsi
 	outw(data, port);
 }
 
-static void mask_and_ack_m32700ut_pld(unsigned int irq)
+static void mask_and_ack_m32700ut_pld(struct irq_desc *desc)
 {
-	disable_m32700ut_pld_irq(irq);
+	disable_m32700ut_pld_irq(desc);
 }
 
-static void end_m32700ut_pld_irq(unsigned int irq)
+static void end_m32700ut_pld_irq(struct irq_desc *desc)
 {
-	enable_m32700ut_pld_irq(irq);
-	end_mappi_irq(M32R_IRQ_INT1);
+	enable_m32700ut_pld_irq(desc);
+	end_mappi_irq(irq_to_desc(M32R_IRQ_INT1));
 }
 
 static unsigned int startup_m32700ut_pld_irq(unsigned int irq)
 {
-	enable_m32700ut_pld_irq(irq);
+	enable_m32700ut_pld_irq(desc);
 	return 0;
 }
 
-static void shutdown_m32700ut_pld_irq(unsigned int irq)
+static void shutdown_m32700ut_pld_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long port;
 	unsigned int pldirq;
 
Index: linux-2.6/arch/m68knommu/platform/5249/intc2.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/5249/intc2.c
+++ linux-2.6/arch/m68knommu/platform/5249/intc2.c
@@ -17,24 +17,27 @@
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 
-static void intc2_irq_gpio_mask(unsigned int irq)
+static void intc2_irq_gpio_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 imr;
 	imr = readl(MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 	imr &= ~(0x1 << (irq - MCFINTC2_GPIOIRQ0));
 	writel(imr, MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 }
 
-static void intc2_irq_gpio_unmask(unsigned int irq)
+static void intc2_irq_gpio_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 imr;
 	imr = readl(MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 	imr |= (0x1 << (irq - MCFINTC2_GPIOIRQ0));
 	writel(imr, MCF_MBAR2 + MCFSIM2_GPIOINTENABLE);
 }
 
-static void intc2_irq_gpio_ack(unsigned int irq)
+static void intc2_irq_gpio_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(0x1 << (irq - MCFINTC2_GPIOIRQ0), MCF_MBAR2 + MCFSIM2_GPIOINTCLEAR);
 }
 
Index: linux-2.6/arch/m68knommu/platform/5272/intc.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/5272/intc.c
+++ linux-2.6/arch/m68knommu/platform/5272/intc.c
@@ -68,8 +68,9 @@ static struct irqmap intc_irqmap[MCFINT_
 	/*MCF_IRQ_SWTO*/	{ .icr = MCFSIM_ICR4, .index = 16, .ack = 0, },
 };
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		u32 v;
 		irq -= MCFINT_VECBASE;
@@ -78,8 +79,9 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		u32 v;
 		irq -= MCFINT_VECBASE;
@@ -88,8 +90,9 @@ static void intc_irq_unmask(unsigned int
 	}
 }
 
-static void intc_irq_ack(unsigned int irq)
+static void intc_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* Only external interrupts are acked */
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECMAX)) {
 		irq -= MCFINT_VECBASE;
@@ -101,7 +104,7 @@ static void intc_irq_ack(unsigned int ir
 	}
 }
 
-static int intc_irq_set_type(unsigned int irq, unsigned int type)
+static int intc_irq_set_type(struct irq_desc *desc, unsigned int type)
 {
 	/* We can set the edge type here for external interrupts */
 	return 0;
Index: linux-2.6/arch/m68knommu/platform/68328/ints.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/68328/ints.c
+++ linux-2.6/arch/m68knommu/platform/68328/ints.c
@@ -135,13 +135,15 @@ void process_int(int vec, struct pt_regs
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	IMR &= ~(1<<irq);
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	IMR |= (1<<irq);
 }
 
Index: linux-2.6/arch/m68knommu/platform/68360/ints.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/68360/ints.c
+++ linux-2.6/arch/m68knommu/platform/68360/ints.c
@@ -37,18 +37,21 @@ extern void *_ramvec[];
 /* The number of spurious interrupts */
 volatile unsigned int num_spurious;
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	pquicc->intr_cimr |= (1 << irq);
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	pquicc->intr_cimr &= ~(1 << irq);
 }
 
-static void intc_irq_ack(unsigned int irq)
+static void intc_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	pquicc->intr_cisr = (1 << irq);
 }
 
Index: linux-2.6/arch/m68knommu/platform/coldfire/intc-2.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/intc-2.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/intc-2.c
@@ -25,8 +25,9 @@
  */
 static u8 intc_intpri = 0x36;
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECBASE + 128)) {
 		unsigned long imraddr;
 		u32 val, imrbit;
@@ -42,8 +43,9 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if ((irq >= MCFINT_VECBASE) && (irq <= MCFINT_VECBASE + 128)) {
 		unsigned long intaddr, imraddr, icraddr;
 		u32 val, imrbit;
Index: linux-2.6/arch/m68knommu/platform/coldfire/intc-simr.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/intc-simr.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/intc-simr.c
@@ -18,8 +18,9 @@
 #include <asm/mcfsim.h>
 #include <asm/traps.h>
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
 			__raw_writeb(irq - MCFINT_VECBASE, MCFINTC0_SIMR);
@@ -28,8 +29,9 @@ static void intc_irq_mask(unsigned int i
 	}
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
 			__raw_writeb(irq - MCFINT_VECBASE, MCFINTC0_CIMR);
@@ -40,6 +42,7 @@ static void intc_irq_unmask(unsigned int
 
 static int intc_irq_set_type(unsigned int irq, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	if (irq >= MCFINT_VECBASE) {
 		if (irq < MCFINT_VECBASE + 64)
 			__raw_writeb(5, MCFINTC0_ICR0 + irq - MCFINT_VECBASE);
Index: linux-2.6/arch/m68knommu/platform/coldfire/intc.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/intc.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/intc.c
@@ -111,19 +111,21 @@ void mcf_autovector(int irq)
 #endif
 }
 
-static void intc_irq_mask(unsigned int irq)
+static void intc_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (mcf_irq2imr[irq])
 		mcf_setimr(mcf_irq2imr[irq]);
 }
 
-static void intc_irq_unmask(unsigned int irq)
+static void intc_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (mcf_irq2imr[irq])
 		mcf_clrimr(mcf_irq2imr[irq]);
 }
 
-static int intc_irq_set_type(unsigned int irq, unsigned int type)
+static int intc_irq_set_type(struct irq_desc *desc, unsigned int type)
 {
 	return 0;
 }
Index: linux-2.6/arch/microblaze/kernel/intc.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/intc.c
+++ linux-2.6/arch/microblaze/kernel/intc.c
@@ -40,8 +40,9 @@ unsigned int nr_irq;
 #define MER_ME (1<<0)
 #define MER_HIE (1<<1)
 
-static void intc_enable_or_unmask(unsigned int irq)
+static void intc_enable_or_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask = 1 << irq;
 	pr_debug("enable_or_unmask: %d\n", irq);
 	out_be32(INTC_BASE + SIE, mask);
@@ -54,28 +55,32 @@ static void intc_enable_or_unmask(unsign
 		out_be32(INTC_BASE + IAR, mask);
 }
 
-static void intc_disable_or_mask(unsigned int irq)
+static void intc_disable_or_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	pr_debug("disable: %d\n", irq);
 	out_be32(INTC_BASE + CIE, 1 << irq);
 }
 
-static void intc_ack(unsigned int irq)
+static void intc_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	pr_debug("ack: %d\n", irq);
 	out_be32(INTC_BASE + IAR, 1 << irq);
 }
 
-static void intc_mask_ack(unsigned int irq)
+static void intc_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask = 1 << irq;
 	pr_debug("disable_and_ack: %d\n", irq);
 	out_be32(INTC_BASE + CIE, mask);
 	out_be32(INTC_BASE + IAR, mask);
 }
 
-static void intc_end(unsigned int irq)
+static void intc_end(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask = 1 << irq;
 	pr_debug("end: %d\n", irq);
 	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
Index: linux-2.6/arch/mips/alchemy/common/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/alchemy/common/irq.c
+++ linux-2.6/arch/mips/alchemy/common/irq.c
@@ -288,17 +288,19 @@ void restore_au1xxx_intctl(void)
 #endif /* CONFIG_PM */
 
 
-static void au1x_ic0_unmask(unsigned int irq_nr)
+static void au1x_ic0_unmask(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq_ - AU1000_INTC0_INT_BASE;
 	au_writel(1 << bit, IC0_MASKSET);
 	au_writel(1 << bit, IC0_WAKESET);
 	au_sync();
 }
 
-static void au1x_ic1_unmask(unsigned int irq_nr)
+static void au1x_ic1_unmask(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq - AU1000_INTC1_INT_BASE;
 	au_writel(1 << bit, IC1_MASKSET);
 	au_writel(1 << bit, IC1_WAKESET);
 
@@ -312,25 +314,28 @@ static void au1x_ic1_unmask(unsigned int
 	au_sync();
 }
 
-static void au1x_ic0_mask(unsigned int irq_nr)
+static void au1x_ic0_mask(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq - AU1000_INTC0_INT_BASE;
 	au_writel(1 << bit, IC0_MASKCLR);
 	au_writel(1 << bit, IC0_WAKECLR);
 	au_sync();
 }
 
-static void au1x_ic1_mask(unsigned int irq_nr)
+static void au1x_ic1_mask(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq - AU1000_INTC1_INT_BASE;
 	au_writel(1 << bit, IC1_MASKCLR);
 	au_writel(1 << bit, IC1_WAKECLR);
 	au_sync();
 }
 
-static void au1x_ic0_ack(unsigned int irq_nr)
+static void au1x_ic0_ack(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq - AU1000_INTC0_INT_BASE;
 
 	/*
 	 * This may assume that we don't get interrupts from
@@ -341,9 +346,10 @@ static void au1x_ic0_ack(unsigned int ir
 	au_sync();
 }
 
-static void au1x_ic1_ack(unsigned int irq_nr)
+static void au1x_ic1_ack(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq - AU1000_INTC1_INT_BASE;
 
 	/*
 	 * This may assume that we don't get interrupts from
@@ -354,9 +360,10 @@ static void au1x_ic1_ack(unsigned int ir
 	au_sync();
 }
 
-static void au1x_ic0_maskack(unsigned int irq_nr)
+static void au1x_ic0_maskack(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC0_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq - AU1000_INTC0_INT_BASE;
 
 	au_writel(1 << bit, IC0_WAKECLR);
 	au_writel(1 << bit, IC0_MASKCLR);
@@ -365,9 +372,10 @@ static void au1x_ic0_maskack(unsigned in
 	au_sync();
 }
 
-static void au1x_ic1_maskack(unsigned int irq_nr)
+static void au1x_ic1_maskack(struct irq_desc *desc)
 {
-	unsigned int bit = irq_nr - AU1000_INTC1_INT_BASE;
+	unsigned int irq = desc->irq;
+	unsigned int bit = irq - AU1000_INTC1_INT_BASE;
 
 	au_writel(1 << bit, IC1_WAKECLR);
 	au_writel(1 << bit, IC1_MASKCLR);
@@ -376,8 +384,9 @@ static void au1x_ic1_maskack(unsigned in
 	au_sync();
 }
 
-static int au1x_ic1_setwake(unsigned int irq, unsigned int on)
+static int au1x_ic1_setwake(struct irq_desc *desc, unsigned int on)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - AU1000_INTC1_INT_BASE;
 	unsigned long wakemsk, flags;
 
Index: linux-2.6/arch/mips/alchemy/devboards/pb1200/irqmap.c
===================================================================
--- linux-2.6.orig/arch/mips/alchemy/devboards/pb1200/irqmap.c
+++ linux-2.6/arch/mips/alchemy/devboards/pb1200/irqmap.c
@@ -59,25 +59,28 @@ static void pb1200_cascade_handler(unsig
 /* NOTE: both the enable and mask bits must be cleared, otherwise the
  * CPLD generates tons of spurious interrupts (at least on the DB1200).
  */
-static void pb1200_mask_irq(unsigned int irq_nr)
+static void pb1200_mask_irq(struct irq_desc *desc)
 {
-	bcsr->intclr_mask = 1 << (irq_nr - PB1200_INT_BEGIN);
-	bcsr->intclr = 1 << (irq_nr - PB1200_INT_BEGIN);
+	unsigned int irq = desc->irq;
+	bcsr->intclr_mask = 1 << (irq - PB1200_INT_BEGIN);
+	bcsr->intclr = 1 << (irq - PB1200_INT_BEGIN);
 	au_sync();
 }
 
-static void pb1200_maskack_irq(unsigned int irq_nr)
+static void pb1200_maskack_irq(struct irq_desc *desc)
 {
-	bcsr->intclr_mask = 1 << (irq_nr - PB1200_INT_BEGIN);
-	bcsr->intclr = 1 << (irq_nr - PB1200_INT_BEGIN);
-	bcsr->int_status = 1 << (irq_nr - PB1200_INT_BEGIN);	/* ack */
+	unsigned int irq = desc->irq;
+	bcsr->intclr_mask = 1 << (irq - PB1200_INT_BEGIN);
+	bcsr->intclr = 1 << (irq - PB1200_INT_BEGIN);
+	bcsr->int_status = 1 << (irq - PB1200_INT_BEGIN);	/* ack */
 	au_sync();
 }
 
-static void pb1200_unmask_irq(unsigned int irq_nr)
+static void pb1200_unmask_irq(struct irq_desc *desc)
 {
-	bcsr->intset = 1 << (irq_nr - PB1200_INT_BEGIN);
-	bcsr->intset_mask = 1 << (irq_nr - PB1200_INT_BEGIN);
+	unsigned int irq = desc->irq;
+	bcsr->intset = 1 << (irq - PB1200_INT_BEGIN);
+	bcsr->intset_mask = 1 << (irq - PB1200_INT_BEGIN);
 	au_sync();
 }
 
Index: linux-2.6/arch/mips/ar7/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/ar7/irq.c
+++ linux-2.6/arch/mips/ar7/irq.c
@@ -48,36 +48,42 @@
 
 static int ar7_irq_base;
 
-static void ar7_unmask_irq(unsigned int irq)
+static void ar7_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << ((irq - ar7_irq_base) % 32),
 	       REG(ESR_OFFSET(irq - ar7_irq_base)));
 }
 
-static void ar7_mask_irq(unsigned int irq)
+static void ar7_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << ((irq - ar7_irq_base) % 32),
 	       REG(ECR_OFFSET(irq - ar7_irq_base)));
 }
 
-static void ar7_ack_irq(unsigned int irq)
+static void ar7_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << ((irq - ar7_irq_base) % 32),
 	       REG(CR_OFFSET(irq - ar7_irq_base)));
 }
 
-static void ar7_unmask_sec_irq(unsigned int irq)
+static void ar7_unmask_sec_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << (irq - ar7_irq_base - 40), REG(SEC_ESR_OFFSET));
 }
 
-static void ar7_mask_sec_irq(unsigned int irq)
+static void ar7_mask_sec_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << (irq - ar7_irq_base - 40), REG(SEC_ECR_OFFSET));
 }
 
-static void ar7_ack_sec_irq(unsigned int irq)
+static void ar7_ack_sec_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writel(1 << (irq - ar7_irq_base - 40), REG(SEC_CR_OFFSET));
 }
 
Index: linux-2.6/arch/mips/bcm63xx/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/bcm63xx/irq.c
+++ linux-2.6/arch/mips/bcm63xx/irq.c
@@ -75,8 +75,9 @@ asmlinkage void plat_irq_dispatch(void)
  * internal IRQs operations: only mask/unmask on PERF irq mask
  * register.
  */
-static inline void bcm63xx_internal_irq_mask(unsigned int irq)
+static inline void bcm63xx_internal_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask;
 
 	irq -= IRQ_INTERNAL_BASE;
@@ -84,9 +85,15 @@ static inline void bcm63xx_internal_irq_
 	mask &= ~(1 << irq);
 	bcm_perf_writel(mask, PERF_IRQMASK_REG);
 }
+static void
+bcm63xx_internal_irq_mask_desc(struct irq_desc *desc)
+{
+	bcm63xx_internal_irq_mask(desc);
+}
 
-static void bcm63xx_internal_irq_unmask(unsigned int irq)
+static void bcm63xx_internal_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask;
 
 	irq -= IRQ_INTERNAL_BASE;
@@ -95,9 +102,9 @@ static void bcm63xx_internal_irq_unmask(
 	bcm_perf_writel(mask, PERF_IRQMASK_REG);
 }
 
-static unsigned int bcm63xx_internal_irq_startup(unsigned int irq)
+static unsigned int bcm63xx_internal_irq_startup(struct irq_desc *desc)
 {
-	bcm63xx_internal_irq_unmask(irq);
+	bcm63xx_internal_irq_unmask(desc);
 	return 0;
 }
 
@@ -105,8 +112,9 @@ static unsigned int bcm63xx_internal_irq
  * external IRQs operations: mask/unmask and clear on PERF external
  * irq control register.
  */
-static void bcm63xx_external_irq_mask(unsigned int irq)
+static void bcm63xx_external_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg;
 
 	irq -= IRQ_EXT_BASE;
@@ -115,8 +123,9 @@ static void bcm63xx_external_irq_mask(un
 	bcm_perf_writel(reg, PERF_EXTIRQ_CFG_REG);
 }
 
-static void bcm63xx_external_irq_unmask(unsigned int irq)
+static void bcm63xx_external_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg;
 
 	irq -= IRQ_EXT_BASE;
@@ -125,8 +134,9 @@ static void bcm63xx_external_irq_unmask(
 	bcm_perf_writel(reg, PERF_EXTIRQ_CFG_REG);
 }
 
-static void bcm63xx_external_irq_clear(unsigned int irq)
+static void bcm63xx_external_irq_clear(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg;
 
 	irq -= IRQ_EXT_BASE;
@@ -135,26 +145,28 @@ static void bcm63xx_external_irq_clear(u
 	bcm_perf_writel(reg, PERF_EXTIRQ_CFG_REG);
 }
 
-static unsigned int bcm63xx_external_irq_startup(unsigned int irq)
+static unsigned int bcm63xx_external_irq_startup(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_c0_status(0x100 << (irq - IRQ_MIPS_BASE));
 	irq_enable_hazard();
-	bcm63xx_external_irq_unmask(irq);
+	bcm63xx_external_irq_unmask(desc);
 	return 0;
 }
 
-static void bcm63xx_external_irq_shutdown(unsigned int irq)
+static void bcm63xx_external_irq_shutdown(struct irq_desc *desc)
 {
-	bcm63xx_external_irq_mask(irq);
+	unsigned int irq = desc->irq;
+	bcm63xx_external_irq_mask(desc);
 	clear_c0_status(0x100 << (irq - IRQ_MIPS_BASE));
 	irq_disable_hazard();
 }
 
-static int bcm63xx_external_irq_set_type(unsigned int irq,
+static int bcm63xx_external_irq_set_type(struct irq_desc *desc,
 					 unsigned int flow_type)
 {
+	unsigned int irq = desc->irq;
 	u32 reg;
-	struct irq_desc *desc = irq_desc + irq;
 
 	irq -= IRQ_EXT_BASE;
 
@@ -213,8 +225,8 @@ static struct irq_chip bcm63xx_internal_
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
@@ -26,8 +26,9 @@ static int octeon_coreid_for_cpu(int cpu
 #endif
 }
 
-static void octeon_irq_core_ack(unsigned int irq)
+static void octeon_irq_core_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - OCTEON_IRQ_SW0;
 	/*
 	 * We don't need to disable IRQs to make these atomic since
@@ -40,9 +41,9 @@ static void octeon_irq_core_ack(unsigned
 		clear_c0_cause(0x100 << bit);
 }
 
-static void octeon_irq_core_eoi(unsigned int irq)
+static void octeon_irq_core_eoi(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - OCTEON_IRQ_SW0;
 	/*
 	 * If an IRQ is being processed while we are disabling it the
@@ -62,8 +63,9 @@ static void octeon_irq_core_eoi(unsigned
 	set_c0_status(0x100 << bit);
 }
 
-static void octeon_irq_core_enable(unsigned int irq)
+static void octeon_irq_core_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	unsigned int bit = irq - OCTEON_IRQ_SW0;
 
@@ -89,8 +91,9 @@ static void octeon_irq_core_disable_loca
 	local_irq_restore(flags);
 }
 
-static void octeon_irq_core_disable(unsigned int irq)
+static void octeon_irq_core_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 #ifdef CONFIG_SMP
 	on_each_cpu((void (*)(void *)) octeon_irq_core_disable_local,
 		    (void *) (long) irq, 1);
@@ -108,7 +111,7 @@ static struct irq_chip octeon_irq_chip_c
 };
 
 
-static void octeon_irq_ciu0_ack(unsigned int irq)
+static void octeon_irq_ciu0_ack(struct irq_desc *desc)
 {
 	/*
 	 * In order to avoid any locking accessing the CIU, we
@@ -124,7 +127,7 @@ static void octeon_irq_ciu0_ack(unsigned
 	clear_c0_status(0x100 << 2);
 }
 
-static void octeon_irq_ciu0_eoi(unsigned int irq)
+static void octeon_irq_ciu0_eoi(struct irq_desc *desc)
 {
 	/*
 	 * Enable all CIU interrupts again.  We don't need to disable
@@ -134,8 +137,9 @@ static void octeon_irq_ciu0_eoi(unsigned
 	set_c0_status(0x100 << 2);
 }
 
-static void octeon_irq_ciu0_enable(unsigned int irq)
+static void octeon_irq_ciu0_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int coreid = cvmx_get_core_num();
 	unsigned long flags;
 	uint64_t en0;
@@ -156,8 +160,9 @@ static void octeon_irq_ciu0_enable(unsig
 	read_unlock_irqrestore(&octeon_irq_ciu0_rwlock, flags);
 }
 
-static void octeon_irq_ciu0_disable(unsigned int irq)
+static void octeon_irq_ciu0_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
 	unsigned long flags;
 	uint64_t en0;
@@ -181,8 +186,9 @@ static void octeon_irq_ciu0_disable(unsi
  * Enable the irq on the current core for chips that have the EN*_W1{S,C}
  * registers.
  */
-static void octeon_irq_ciu0_enable_v2(unsigned int irq)
+static void octeon_irq_ciu0_enable_v2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int index = cvmx_get_core_num() * 2;
 	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
 
@@ -193,8 +199,9 @@ static void octeon_irq_ciu0_enable_v2(un
  * Disable the irq on the current core for chips that have the EN*_W1{S,C}
  * registers.
  */
-static void octeon_irq_ciu0_disable_v2(unsigned int irq)
+static void octeon_irq_ciu0_disable_v2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int index = cvmx_get_core_num() * 2;
 	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
 
@@ -205,7 +212,7 @@ static void octeon_irq_ciu0_disable_v2(u
  * Disable the irq on the all cores for chips that have the EN*_W1{S,C}
  * registers.
  */
-static void octeon_irq_ciu0_disable_all_v2(unsigned int irq)
+static void octeon_irq_ciu0_disable_all_v2(struct irq_desc *desc)
 {
 	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
 	int index;
@@ -217,8 +224,9 @@ static void octeon_irq_ciu0_disable_all_
 }
 
 #ifdef CONFIG_SMP
-static int octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu0_set_affinity(struct irq_desc *desc, const struct cpumask *dest)
 {
+	unsigned int irq = desc->irq;
 	int cpu;
 	unsigned long flags;
 	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
@@ -248,9 +256,10 @@ static int octeon_irq_ciu0_set_affinity(
  * Set affinity for the irq for chips that have the EN*_W1{S,C}
  * registers.
  */
-static int octeon_irq_ciu0_set_affinity_v2(unsigned int irq,
+static int octeon_irq_ciu0_set_affinity_v2(struct irq_desc *desc,
 					   const struct cpumask *dest)
 {
+	unsigned int irq = desc->irq;
 	int cpu;
 	int index;
 	u64 mask = 1ull << (irq - OCTEON_IRQ_WORKQ0);
@@ -291,7 +300,7 @@ static struct irq_chip octeon_irq_chip_c
 };
 
 
-static void octeon_irq_ciu1_ack(unsigned int irq)
+static void octeon_irq_ciu1_ack(struct irq_desc *desc)
 {
 	/*
 	 * In order to avoid any locking accessing the CIU, we
@@ -305,7 +314,7 @@ static void octeon_irq_ciu1_ack(unsigned
 	clear_c0_status(0x100 << 3);
 }
 
-static void octeon_irq_ciu1_eoi(unsigned int irq)
+static void octeon_irq_ciu1_eoi(struct irq_desc *desc)
 {
 	/*
 	 * Enable all CIU interrupts again.  We don't need to disable
@@ -315,8 +324,9 @@ static void octeon_irq_ciu1_eoi(unsigned
 	set_c0_status(0x100 << 3);
 }
 
-static void octeon_irq_ciu1_enable(unsigned int irq)
+static void octeon_irq_ciu1_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int coreid = cvmx_get_core_num();
 	unsigned long flags;
 	uint64_t en1;
@@ -337,8 +347,9 @@ static void octeon_irq_ciu1_enable(unsig
 	read_unlock_irqrestore(&octeon_irq_ciu1_rwlock, flags);
 }
 
-static void octeon_irq_ciu1_disable(unsigned int irq)
+static void octeon_irq_ciu1_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
 	unsigned long flags;
 	uint64_t en1;
@@ -362,8 +373,9 @@ static void octeon_irq_ciu1_disable(unsi
  * Enable the irq on the current core for chips that have the EN*_W1{S,C}
  * registers.
  */
-static void octeon_irq_ciu1_enable_v2(unsigned int irq)
+static void octeon_irq_ciu1_enable_v2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int index = cvmx_get_core_num() * 2 + 1;
 	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
 
@@ -374,8 +386,9 @@ static void octeon_irq_ciu1_enable_v2(un
  * Disable the irq on the current core for chips that have the EN*_W1{S,C}
  * registers.
  */
-static void octeon_irq_ciu1_disable_v2(unsigned int irq)
+static void octeon_irq_ciu1_disable_v2(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int index = cvmx_get_core_num() * 2 + 1;
 	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
 
@@ -398,9 +411,10 @@ static void octeon_irq_ciu1_disable_all_
 }
 
 #ifdef CONFIG_SMP
-static int octeon_irq_ciu1_set_affinity(unsigned int irq,
+static int octeon_irq_ciu1_set_affinity(struct irq_desc *desc,
 					const struct cpumask *dest)
 {
+	unsigned int irq = desc->irq;
 	int cpu;
 	unsigned long flags;
 	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
@@ -431,9 +445,10 @@ static int octeon_irq_ciu1_set_affinity(
  * Set affinity for the irq for chips that have the EN*_W1{S,C}
  * registers.
  */
-static int octeon_irq_ciu1_set_affinity_v2(unsigned int irq,
+static int octeon_irq_ciu1_set_affinity_v2(struct irq_desc *desc,
 					   const struct cpumask *dest)
 {
+	unsigned int irq = desc->irq;
 	int cpu;
 	int index;
 	u64 mask = 1ull << (irq - OCTEON_IRQ_WDOG0);
@@ -475,8 +490,9 @@ static struct irq_chip octeon_irq_chip_c
 
 #ifdef CONFIG_PCI_MSI
 
-static void octeon_irq_msi_ack(unsigned int irq)
+static void octeon_irq_msi_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (!octeon_has_feature(OCTEON_FEATURE_PCIE)) {
 		/* These chips have PCI */
 		cvmx_write_csr(CVMX_NPI_NPI_MSI_RCV,
@@ -491,13 +507,14 @@ static void octeon_irq_msi_ack(unsigned
 	}
 }
 
-static void octeon_irq_msi_eoi(unsigned int irq)
+static void octeon_irq_msi_eoi(struct irq_desc *desc)
 {
 	/* Nothing needed */
 }
 
-static void octeon_irq_msi_enable(unsigned int irq)
+static void octeon_irq_msi_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (!octeon_has_feature(OCTEON_FEATURE_PCIE)) {
 		/*
 		 * Octeon PCI doesn't have the ability to mask/unmask
@@ -524,8 +541,9 @@ static void octeon_irq_msi_enable(unsign
 	}
 }
 
-static void octeon_irq_msi_disable(unsigned int irq)
+static void octeon_irq_msi_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (!octeon_has_feature(OCTEON_FEATURE_PCIE)) {
 		/* See comment in enable */
 	} else {
Index: linux-2.6/arch/mips/dec/ioasic-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/dec/ioasic-irq.c
+++ linux-2.6/arch/mips/dec/ioasic-irq.c
@@ -21,8 +21,9 @@
 static int ioasic_irq_base;
 
 
-static inline void unmask_ioasic_irq(unsigned int irq)
+static inline void unmask_ioasic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 simr;
 
 	simr = ioasic_read(IO_REG_SIMR);
@@ -30,8 +31,9 @@ static inline void unmask_ioasic_irq(uns
 	ioasic_write(IO_REG_SIMR, simr);
 }
 
-static inline void mask_ioasic_irq(unsigned int irq)
+static inline void mask_ioasic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 simr;
 
 	simr = ioasic_read(IO_REG_SIMR);
@@ -47,16 +49,16 @@ static inline void clear_ioasic_irq(unsi
 	ioasic_write(IO_REG_SIR, sir);
 }
 
-static inline void ack_ioasic_irq(unsigned int irq)
+static inline void ack_ioasic_irq(struct irq_desc *desc)
 {
-	mask_ioasic_irq(irq);
+	mask_ioasic_irq(desc);
 	fast_iob();
 }
 
-static inline void end_ioasic_irq(unsigned int irq)
+static inline void end_ioasic_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		unmask_ioasic_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		unmask_ioasic_irq(desc);
 }
 
 static struct irq_chip ioasic_irq_type = {
@@ -74,11 +76,12 @@ static struct irq_chip ioasic_irq_type =
 
 #define ack_ioasic_dma_irq ack_ioasic_irq
 
-static inline void end_ioasic_dma_irq(unsigned int irq)
+static inline void end_ioasic_dma_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	clear_ioasic_irq(irq);
 	fast_iob();
-	end_ioasic_irq(irq);
+	end_ioasic_irq(desc);
 }
 
 static struct irq_chip ioasic_dma_irq_type = {
Index: linux-2.6/arch/mips/dec/kn02-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/dec/kn02-irq.c
+++ linux-2.6/arch/mips/dec/kn02-irq.c
@@ -31,8 +31,9 @@ u32 cached_kn02_csr;
 static int kn02_irq_base;
 
 
-static inline void unmask_kn02_irq(unsigned int irq)
+static inline void unmask_kn02_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	volatile u32 *csr = (volatile u32 *)CKSEG1ADDR(KN02_SLOT_BASE +
 						       KN02_CSR);
 
@@ -40,8 +41,9 @@ static inline void unmask_kn02_irq(unsig
 	*csr = cached_kn02_csr;
 }
 
-static inline void mask_kn02_irq(unsigned int irq)
+static inline void mask_kn02_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	volatile u32 *csr = (volatile u32 *)CKSEG1ADDR(KN02_SLOT_BASE +
 						       KN02_CSR);
 
@@ -49,9 +51,9 @@ static inline void mask_kn02_irq(unsigne
 	*csr = cached_kn02_csr;
 }
 
-static void ack_kn02_irq(unsigned int irq)
+static void ack_kn02_irq(struct irq_desc *desc)
 {
-	mask_kn02_irq(irq);
+	mask_kn02_irq(desc);
 	iob();
 }
 
Index: linux-2.6/arch/mips/emma/markeins/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/emma/markeins/irq.c
+++ linux-2.6/arch/mips/emma/markeins/irq.c
@@ -34,8 +34,9 @@
 
 #include <asm/emma/emma2rh.h>
 
-static void emma2rh_irq_enable(unsigned int irq)
+static void emma2rh_irq_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg_value;
 	u32 reg_bitmask;
 	u32 reg_index;
@@ -49,8 +50,9 @@ static void emma2rh_irq_enable(unsigned
 	emma2rh_out32(reg_index, reg_value | reg_bitmask);
 }
 
-static void emma2rh_irq_disable(unsigned int irq)
+static void emma2rh_irq_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg_value;
 	u32 reg_bitmask;
 	u32 reg_index;
@@ -82,8 +84,9 @@ void emma2rh_irq_init(void)
 					      handle_level_irq, "level");
 }
 
-static void emma2rh_sw_irq_enable(unsigned int irq)
+static void emma2rh_sw_irq_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg;
 
 	irq -= EMMA2RH_SW_IRQ_BASE;
@@ -93,8 +96,9 @@ static void emma2rh_sw_irq_enable(unsign
 	emma2rh_out32(EMMA2RH_BHIF_SW_INT_EN, reg);
 }
 
-static void emma2rh_sw_irq_disable(unsigned int irq)
+static void emma2rh_sw_irq_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 reg;
 
 	irq -= EMMA2RH_SW_IRQ_BASE;
@@ -122,7 +126,7 @@ void emma2rh_sw_irq_init(void)
 					      handle_level_irq, "level");
 }
 
-static void emma2rh_gpio_irq_enable(unsigned int irq)
+static void emma2rh_gpio_irq_enable(struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -133,7 +137,7 @@ static void emma2rh_gpio_irq_enable(unsi
 	emma2rh_out32(EMMA2RH_GPIO_INT_MASK, reg);
 }
 
-static void emma2rh_gpio_irq_disable(unsigned int irq)
+static void emma2rh_gpio_irq_disable(struct irq_desc *desc)
 {
 	u32 reg;
 
@@ -144,13 +148,13 @@ static void emma2rh_gpio_irq_disable(uns
 	emma2rh_out32(EMMA2RH_GPIO_INT_MASK, reg);
 }
 
-static void emma2rh_gpio_irq_ack(unsigned int irq)
+static void emma2rh_gpio_irq_ack(struct irq_desc *desc)
 {
 	irq -= EMMA2RH_GPIO_IRQ_BASE;
 	emma2rh_out32(EMMA2RH_GPIO_INT_ST, ~(1 << irq));
 }
 
-static void emma2rh_gpio_irq_mask_ack(unsigned int irq)
+static void emma2rh_gpio_irq_mask_ack(struct irq_desc *desc)
 {
 	u32 reg;
 
Index: linux-2.6/arch/mips/jazz/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/jazz/irq.c
+++ linux-2.6/arch/mips/jazz/irq.c
@@ -22,8 +22,9 @@
 
 static DEFINE_SPINLOCK(r4030_lock);
 
-static void enable_r4030_irq(unsigned int irq)
+static void enable_r4030_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq - JAZZ_IRQ_START);
 	unsigned long flags;
 
@@ -33,8 +34,9 @@ static void enable_r4030_irq(unsigned in
 	spin_unlock_irqrestore(&r4030_lock, flags);
 }
 
-void disable_r4030_irq(unsigned int irq)
+void disable_r4030_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = ~(1 << (irq - JAZZ_IRQ_START));
 	unsigned long flags;
 
Index: linux-2.6/arch/mips/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/i8259.c
+++ linux-2.6/arch/mips/kernel/i8259.c
@@ -30,9 +30,9 @@
 
 static int i8259A_auto_eoi = -1;
 DEFINE_SPINLOCK(i8259A_lock);
-static void disable_8259A_irq(unsigned int irq);
-static void enable_8259A_irq(unsigned int irq);
-static void mask_and_ack_8259A(unsigned int irq);
+static void disable_8259A_irq(struct irq_desc *desc);
+static void enable_8259A_irq(struct irq_desc *desc);
+static void mask_and_ack_8259A(struct irq_desc *desc);
 static void init_8259A(int auto_eoi);
 
 static struct irq_chip i8259A_chip = {
@@ -58,8 +58,9 @@ static unsigned int cached_irq_mask = 0x
 #define cached_master_mask	(cached_irq_mask)
 #define cached_slave_mask	(cached_irq_mask >> 8)
 
-static void disable_8259A_irq(unsigned int irq)
+static void disable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	unsigned long flags;
 
@@ -74,8 +75,9 @@ static void disable_8259A_irq(unsigned i
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static void enable_8259A_irq(unsigned int irq)
+static void enable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	unsigned long flags;
 
@@ -144,8 +146,9 @@ static inline int i8259A_irq_real(unsign
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-static void mask_and_ack_8259A(unsigned int irq)
+static void mask_and_ack_8259A(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irqmask;
 	unsigned long flags;
 
Index: linux-2.6/arch/mips/kernel/irq-gic.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-gic.c
+++ linux-2.6/arch/mips/kernel/irq-gic.c
@@ -88,16 +88,18 @@ unsigned int gic_get_int(void)
 	return i;
 }
 
-static unsigned int gic_irq_startup(unsigned int irq)
+static unsigned int gic_irq_startup(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= _irqbase;
 	pr_debug("CPU%d: %s: irq%d\n", smp_processor_id(), __func__, irq);
 	GIC_SET_INTR_MASK(irq);
 	return 0;
 }
 
-static void gic_irq_ack(unsigned int irq)
+static void gic_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= _irqbase;
 	pr_debug("CPU%d: %s: irq%d\n", smp_processor_id(), __func__, irq);
 	GIC_CLR_INTR_MASK(irq);
@@ -106,15 +108,17 @@ static void gic_irq_ack(unsigned int irq
 		GICWRITE(GIC_REG(SHARED, GIC_SH_WEDGE), irq);
 }
 
-static void gic_mask_irq(unsigned int irq)
+static void gic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= _irqbase;
 	pr_debug("CPU%d: %s: irq%d\n", smp_processor_id(), __func__, irq);
 	GIC_CLR_INTR_MASK(irq);
 }
 
-static void gic_unmask_irq(unsigned int irq)
+static void gic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	irq -= _irqbase;
 	pr_debug("CPU%d: %s: irq%d\n", smp_processor_id(), __func__, irq);
 	GIC_SET_INTR_MASK(irq);
@@ -124,8 +128,9 @@ static void gic_unmask_irq(unsigned int
 
 static DEFINE_SPINLOCK(gic_lock);
 
-static int gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+static int gic_set_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
 {
+	unsigned int irq = desc->irq;
 	cpumask_t	tmp = CPU_MASK_NONE;
 	unsigned long	flags;
 	int		i;
@@ -148,7 +153,7 @@ static int gic_set_affinity(unsigned int
 		set_bit(irq, pcpu_masks[first_cpu(tmp)].pcpu_mask);
 
 	}
-	cpumask_copy(irq_desc[irq].affinity, cpumask);
+	cpumask_copy(desc->affinity, cpumask);
 	spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
Index: linux-2.6/arch/mips/kernel/irq-gt641xx.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-gt641xx.c
+++ linux-2.6/arch/mips/kernel/irq-gt641xx.c
@@ -29,7 +29,7 @@
 
 static DEFINE_SPINLOCK(gt641xx_irq_lock);
 
-static void ack_gt641xx_irq(unsigned int irq)
+static void ack_gt641xx_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 	u32 cause;
@@ -41,8 +41,9 @@ static void ack_gt641xx_irq(unsigned int
 	spin_unlock_irqrestore(&gt641xx_irq_lock, flags);
 }
 
-static void mask_gt641xx_irq(unsigned int irq)
+static void mask_gt641xx_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	u32 mask;
 
@@ -53,8 +54,9 @@ static void mask_gt641xx_irq(unsigned in
 	spin_unlock_irqrestore(&gt641xx_irq_lock, flags);
 }
 
-static void mask_ack_gt641xx_irq(unsigned int irq)
+static void mask_ack_gt641xx_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	u32 cause, mask;
 
@@ -69,8 +71,9 @@ static void mask_ack_gt641xx_irq(unsigne
 	spin_unlock_irqrestore(&gt641xx_irq_lock, flags);
 }
 
-static void unmask_gt641xx_irq(unsigned int irq)
+static void unmask_gt641xx_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	u32 mask;
 
Index: linux-2.6/arch/mips/kernel/irq-msc01.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-msc01.c
+++ linux-2.6/arch/mips/kernel/irq-msc01.c
@@ -28,8 +28,9 @@ static unsigned long _icctrl_msc;
 static unsigned int irq_base;
 
 /* mask off an interrupt */
-static inline void mask_msc_irq(unsigned int irq)
+static inline void mask_msc_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq < (irq_base + 32))
 		MSCIC_WRITE(MSC01_IC_DISL, 1<<(irq - irq_base));
 	else
@@ -37,8 +38,9 @@ static inline void mask_msc_irq(unsigned
 }
 
 /* unmask an interrupt */
-static inline void unmask_msc_irq(unsigned int irq)
+static inline void unmask_msc_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (irq < (irq_base + 32))
 		MSCIC_WRITE(MSC01_IC_ENAL, 1<<(irq - irq_base));
 	else
@@ -48,9 +50,10 @@ static inline void unmask_msc_irq(unsign
 /*
  * Masks and ACKs an IRQ
  */
-static void level_mask_and_ack_msc_irq(unsigned int irq)
+static void level_mask_and_ack_msc_irq(struct irq_desc *desc)
 {
-	mask_msc_irq(irq);
+	unsigned int irq = desc->irq;
+	mask_msc_irq(desc);
 	if (!cpu_has_veic)
 		MSCIC_WRITE(MSC01_IC_EOI, 0);
 	/* This actually needs to be a call into platform code */
@@ -60,9 +63,10 @@ static void level_mask_and_ack_msc_irq(u
 /*
  * Masks and ACKs an IRQ
  */
-static void edge_mask_and_ack_msc_irq(unsigned int irq)
+static void edge_mask_and_ack_msc_irq(struct irq_desc *desc)
 {
-	mask_msc_irq(irq);
+	unsigned int irq = desc->irq;
+	mask_msc_irq(desc);
 	if (!cpu_has_veic)
 		MSCIC_WRITE(MSC01_IC_EOI, 0);
 	else {
@@ -77,10 +81,10 @@ static void edge_mask_and_ack_msc_irq(un
 /*
  * End IRQ processing
  */
-static void end_msc_irq(unsigned int irq)
+static void end_msc_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		unmask_msc_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		unmask_msc_irq(desc);
 }
 
 /*
Index: linux-2.6/arch/mips/kernel/irq-rm7000.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-rm7000.c
+++ linux-2.6/arch/mips/kernel/irq-rm7000.c
@@ -17,13 +17,15 @@
 #include <asm/mipsregs.h>
 #include <asm/system.h>
 
-static inline void unmask_rm7k_irq(unsigned int irq)
+static inline void unmask_rm7k_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_c0_intcontrol(0x100 << (irq - RM7K_CPU_IRQ_BASE));
 }
 
-static inline void mask_rm7k_irq(unsigned int irq)
+static inline void mask_rm7k_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	clear_c0_intcontrol(0x100 << (irq - RM7K_CPU_IRQ_BASE));
 }
 
Index: linux-2.6/arch/mips/kernel/irq-rm9000.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-rm9000.c
+++ linux-2.6/arch/mips/kernel/irq-rm9000.c
@@ -18,22 +18,24 @@
 #include <asm/mipsregs.h>
 #include <asm/system.h>
 
-static inline void unmask_rm9k_irq(unsigned int irq)
+static inline void unmask_rm9k_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_c0_intcontrol(0x1000 << (irq - RM9K_CPU_IRQ_BASE));
 }
 
 static inline void mask_rm9k_irq(unsigned int irq)
 {
+	unsigned int irq = desc->irq;
 	clear_c0_intcontrol(0x1000 << (irq - RM9K_CPU_IRQ_BASE));
 }
 
-static inline void rm9k_cpu_irq_enable(unsigned int irq)
+static inline void rm9k_cpu_irq_enable(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	local_irq_save(flags);
-	unmask_rm9k_irq(irq);
+	unmask_rm9k_irq(desc);
 	local_irq_restore(flags);
 }
 
@@ -42,31 +44,31 @@ static inline void rm9k_cpu_irq_enable(u
  */
 static void local_rm9k_perfcounter_irq_startup(void *args)
 {
-	unsigned int irq = (unsigned int) args;
+	struct irq_desc *desc = (struct irq_desc *) args;
 
-	rm9k_cpu_irq_enable(irq);
+	rm9k_cpu_irq_enable(desc);
 }
 
-static unsigned int rm9k_perfcounter_irq_startup(unsigned int irq)
+static unsigned int rm9k_perfcounter_irq_startup(struct irq_desc *desc)
 {
-	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *) irq, 1);
+	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *)desc, 1);
 
 	return 0;
 }
 
 static void local_rm9k_perfcounter_irq_shutdown(void *args)
 {
-	unsigned int irq = (unsigned int) args;
+	struct irq_desc *desc = (struct irq_desc *) args;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	mask_rm9k_irq(irq);
+	mask_rm9k_irq(desc);
 	local_irq_restore(flags);
 }
 
-static void rm9k_perfcounter_irq_shutdown(unsigned int irq)
+static void rm9k_perfcounter_irq_shutdown(struct irq_desc *desc)
 {
-	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *) irq, 1);
+	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *)desc, 1);
 }
 
 static struct irq_chip rm9k_irq_controller = {
Index: linux-2.6/arch/mips/kernel/irq_cpu.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq_cpu.c
+++ linux-2.6/arch/mips/kernel/irq_cpu.c
@@ -36,14 +36,16 @@
 #include <asm/mipsmtregs.h>
 #include <asm/system.h>
 
-static inline void unmask_mips_irq(unsigned int irq)
+static inline void unmask_mips_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_c0_status(0x100 << (irq - MIPS_CPU_IRQ_BASE));
 	irq_enable_hazard();
 }
 
-static inline void mask_mips_irq(unsigned int irq)
+static inline void mask_mips_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	clear_c0_status(0x100 << (irq - MIPS_CPU_IRQ_BASE));
 	irq_disable_hazard();
 }
@@ -64,13 +66,14 @@ static struct irq_chip mips_cpu_irq_cont
 #define unmask_mips_mt_irq	unmask_mips_irq
 #define mask_mips_mt_irq	mask_mips_irq
 
-static unsigned int mips_mt_cpu_irq_startup(unsigned int irq)
+static unsigned int mips_mt_cpu_irq_startup(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int vpflags = dvpe();
 
 	clear_c0_cause(0x100 << (irq - MIPS_CPU_IRQ_BASE));
 	evpe(vpflags);
-	unmask_mips_mt_irq(irq);
+	unmask_mips_mt_irq(desc);
 
 	return 0;
 }
@@ -79,8 +82,9 @@ static unsigned int mips_mt_cpu_irq_star
  * While we ack the interrupt interrupts are disabled and thus we don't need
  * to deal with concurrency issues.  Same for mips_cpu_irq_end.
  */
-static void mips_mt_cpu_irq_ack(unsigned int irq)
+static void mips_mt_cpu_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int vpflags = dvpe();
 	clear_c0_cause(0x100 << (irq - MIPS_CPU_IRQ_BASE));
 	evpe(vpflags);
Index: linux-2.6/arch/mips/kernel/irq_txx9.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq_txx9.c
+++ linux-2.6/arch/mips/kernel/irq_txx9.c
@@ -62,8 +62,9 @@ static struct {
 	unsigned char mode;
 } txx9irq[TXx9_MAX_IR] __read_mostly;
 
-static void txx9_irq_unmask(unsigned int irq)
+static void txx9_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *ilrp = &txx9_ircptr->ilr[(irq_nr % 16 ) / 2];
 	int ofs = irq_nr / 16 * 16 + (irq_nr & 1) * 8;
@@ -78,8 +79,9 @@ static void txx9_irq_unmask(unsigned int
 #endif
 }
 
-static inline void txx9_irq_mask(unsigned int irq)
+static inline void txx9_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *ilrp = &txx9_ircptr->ilr[(irq_nr % 16) / 2];
 	int ofs = irq_nr / 16 * 16 + (irq_nr & 1) * 8;
@@ -98,18 +100,20 @@ static inline void txx9_irq_mask(unsigne
 #endif
 }
 
-static void txx9_irq_mask_ack(unsigned int irq)
+static void txx9_irq_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 
-	txx9_irq_mask(irq);
+	txx9_irq_mask(desc);
 	/* clear edge detection */
 	if (unlikely(TXx9_IRCR_EDGE(txx9irq[irq_nr].mode)))
 		__raw_writel(TXx9_IRSCR_EIClrE | irq_nr, &txx9_ircptr->scr);
 }
 
-static int txx9_irq_set_type(unsigned int irq, unsigned int flow_type)
+static int txx9_irq_set_type(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 cr;
 	u32 __iomem *crp;
Index: linux-2.6/arch/mips/lasat/interrupt.c
===================================================================
--- linux-2.6.orig/arch/mips/lasat/interrupt.c
+++ linux-2.6/arch/mips/lasat/interrupt.c
@@ -32,16 +32,18 @@ static volatile int *lasat_int_status;
 static volatile int *lasat_int_mask;
 static volatile int lasat_int_mask_shift;
 
-void disable_lasat_irq(unsigned int irq_nr)
+void disable_lasat_irq(struct irq_desc *desc)
 {
-	irq_nr -= LASAT_IRQ_BASE;
-	*lasat_int_mask &= ~(1 << irq_nr) << lasat_int_mask_shift;
+	unsigned int irq = desc->irq;
+	irq -= LASAT_IRQ_BASE;
+	*lasat_int_mask &= ~(1 << irq) << lasat_int_mask_shift;
 }
 
-void enable_lasat_irq(unsigned int irq_nr)
+void enable_lasat_irq(struct irq_desc *desc)
 {
-	irq_nr -= LASAT_IRQ_BASE;
-	*lasat_int_mask |= (1 << irq_nr) << lasat_int_mask_shift;
+	unsigned int irq = desc->irq;
+	irq -= LASAT_IRQ_BASE;
+	*lasat_int_mask |= (1 << irq) << lasat_int_mask_shift;
 }
 
 static struct irq_chip lasat_irq_type = {
Index: linux-2.6/arch/mips/loongson/common/bonito-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/loongson/common/bonito-irq.c
+++ linux-2.6/arch/mips/loongson/common/bonito-irq.c
@@ -16,14 +16,16 @@
 
 #include <loongson.h>
 
-static inline void bonito_irq_enable(unsigned int irq)
+static inline void bonito_irq_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	LOONGSON_INTENSET = (1 << (irq - LOONGSON_IRQ_BASE));
 	mmiowb();
 }
 
-static inline void bonito_irq_disable(unsigned int irq)
+static inline void bonito_irq_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	LOONGSON_INTENCLR = (1 << (irq - LOONGSON_IRQ_BASE));
 	mmiowb();
 }
Index: linux-2.6/arch/mips/nxp/pnx833x/common/interrupts.c
===================================================================
--- linux-2.6.orig/arch/mips/nxp/pnx833x/common/interrupts.c
+++ linux-2.6/arch/mips/nxp/pnx833x/common/interrupts.c
@@ -158,8 +158,9 @@ static int irqflags[PNX833X_PIC_NUM_IRQ]
 
 static DEFINE_SPINLOCK(pnx833x_irq_lock);
 
-static unsigned int pnx833x_startup_pic_irq(unsigned int irq)
+static unsigned int pnx833x_startup_pic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	unsigned int pic_irq = irq - PNX833X_PIC_IRQ_BASE;
 
@@ -172,8 +173,9 @@ static unsigned int pnx833x_startup_pic_
 	return 0;
 }
 
-static void pnx833x_shutdown_pic_irq(unsigned int irq)
+static void pnx833x_shutdown_pic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	unsigned int pic_irq = irq - PNX833X_PIC_IRQ_BASE;
 
@@ -185,8 +187,9 @@ static void pnx833x_shutdown_pic_irq(uns
 	spin_unlock_irqrestore(&pnx833x_irq_lock, flags);
 }
 
-static void pnx833x_enable_pic_irq(unsigned int irq)
+static void pnx833x_enable_pic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	unsigned int pic_irq = irq - PNX833X_PIC_IRQ_BASE;
 
@@ -199,8 +202,9 @@ static void pnx833x_enable_pic_irq(unsig
 	spin_unlock_irqrestore(&pnx833x_irq_lock, flags);
 }
 
-static void pnx833x_disable_pic_irq(unsigned int irq)
+static void pnx833x_disable_pic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	unsigned int pic_irq = irq - PNX833X_PIC_IRQ_BASE;
 
@@ -212,18 +216,19 @@ static void pnx833x_disable_pic_irq(unsi
 	spin_unlock_irqrestore(&pnx833x_irq_lock, flags);
 }
 
-static void pnx833x_ack_pic_irq(unsigned int irq)
+static void pnx833x_ack_pic_irq(struct irq_desc *desc)
 {
 }
 
-static void pnx833x_end_pic_irq(unsigned int irq)
+static void pnx833x_end_pic_irq(struct irq_desc *desc)
 {
 }
 
 static DEFINE_SPINLOCK(pnx833x_gpio_pnx833x_irq_lock);
 
-static unsigned int pnx833x_startup_gpio_irq(unsigned int irq)
+static unsigned int pnx833x_startup_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq - PNX833X_GPIO_IRQ_BASE;
 	unsigned long flags;
 	spin_lock_irqsave(&pnx833x_gpio_pnx833x_irq_lock, flags);
@@ -232,8 +237,9 @@ static unsigned int pnx833x_startup_gpio
 	return 0;
 }
 
-static void pnx833x_enable_gpio_irq(unsigned int irq)
+static void pnx833x_enable_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq - PNX833X_GPIO_IRQ_BASE;
 	unsigned long flags;
 	spin_lock_irqsave(&pnx833x_gpio_pnx833x_irq_lock, flags);
@@ -241,8 +247,9 @@ static void pnx833x_enable_gpio_irq(unsi
 	spin_unlock_irqrestore(&pnx833x_gpio_pnx833x_irq_lock, flags);
 }
 
-static void pnx833x_disable_gpio_irq(unsigned int irq)
+static void pnx833x_disable_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq - PNX833X_GPIO_IRQ_BASE;
 	unsigned long flags;
 	spin_lock_irqsave(&pnx833x_gpio_pnx833x_irq_lock, flags);
@@ -250,12 +257,13 @@ static void pnx833x_disable_gpio_irq(uns
 	spin_unlock_irqrestore(&pnx833x_gpio_pnx833x_irq_lock, flags);
 }
 
-static void pnx833x_ack_gpio_irq(unsigned int irq)
+static void pnx833x_ack_gpio_irq(struct irq_desc *desc)
 {
 }
 
-static void pnx833x_end_gpio_irq(unsigned int irq)
+static void pnx833x_end_gpio_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq - PNX833X_GPIO_IRQ_BASE;
 	unsigned long flags;
 	spin_lock_irqsave(&pnx833x_gpio_pnx833x_irq_lock, flags);
@@ -263,8 +271,9 @@ static void pnx833x_end_gpio_irq(unsigne
 	spin_unlock_irqrestore(&pnx833x_gpio_pnx833x_irq_lock, flags);
 }
 
-static int pnx833x_set_type_gpio_irq(unsigned int irq, unsigned int flow_type)
+static int pnx833x_set_type_gpio_irq(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int irq = desc->irq;
 	int pin = irq - PNX833X_GPIO_IRQ_BASE;
 	int gpio_mode;
 
Index: linux-2.6/arch/mips/nxp/pnx8550/common/int.c
===================================================================
--- linux-2.6.orig/arch/mips/nxp/pnx8550/common/int.c
+++ linux-2.6/arch/mips/nxp/pnx8550/common/int.c
@@ -115,9 +115,10 @@ static inline void unmask_gic_int(unsign
 	PNX8550_GIC_REQ(irq_nr) = (1<<26 | 1<<16) | (1<<28) | gic_prio[irq_nr];
 }
 
-static inline void mask_irq(unsigned int irq_nr)
+static inline void mask_irq(struct irq_desc *desc)
 {
-	if ((PNX8550_INT_CP0_MIN <= irq_nr) && (irq_nr <= PNX8550_INT_CP0_MAX)) {
+	unsigned int irq_nr = desc->irq;
+	if ((PNX8550_INT_CP0_MIN <= irq_nr) && (irqi_nr <= PNX8550_INT_CP0_MAX)) {
 		modify_cp0_intmask(1 << irq_nr, 0);
 	} else if ((PNX8550_INT_GIC_MIN <= irq_nr) &&
 		(irq_nr <= PNX8550_INT_GIC_MAX)) {
@@ -130,12 +131,13 @@ static inline void mask_irq(unsigned int
 	}
 }
 
-static inline void unmask_irq(unsigned int irq_nr)
+static inline void unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq_nr = desc->irq;
 	if ((PNX8550_INT_CP0_MIN <= irq_nr) && (irq_nr <= PNX8550_INT_CP0_MAX)) {
 		modify_cp0_intmask(0, 1 << irq_nr);
 	} else if ((PNX8550_INT_GIC_MIN <= irq_nr) &&
-		(irq_nr <= PNX8550_INT_GIC_MAX)) {
+		(irq <= PNX8550_INT_GIC_MAX)) {
 		unmask_gic_int(irq_nr - PNX8550_INT_GIC_MIN);
 	} else if ((PNX8550_INT_TIMER_MIN <= irq_nr) &&
 		(irq_nr <= PNX8550_INT_TIMER_MAX)) {
Index: linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
===================================================================
--- linux-2.6.orig/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
+++ linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
@@ -24,9 +24,9 @@
  * NOTE: We are only enabling support for VPE0 right now.
  */
 
-static inline void unmask_msp_cic_irq(unsigned int irq)
+static inline void unmask_msp_cic_irq(struct irq_desc *desc)
 {
-
+	unsigned int irq = desc->irq;
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
 		*CIC_VPE0_MSK_REG |= (1 << (irq - MSP_CIC_INTBASE));
@@ -36,6 +36,7 @@ static inline void unmask_msp_cic_irq(un
 
 static inline void mask_msp_cic_irq(unsigned int irq)
 {
+	unsigned int irq = desc->irq;
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
 		*CIC_VPE0_MSK_REG &= ~(1 << (irq - MSP_CIC_INTBASE));
@@ -47,9 +48,10 @@ static inline void mask_msp_cic_irq(unsi
  * While we ack the interrupt interrupts are disabled and thus we don't need
  * to deal with concurrency issues.  Same for msp_cic_irq_end.
  */
-static inline void ack_msp_cic_irq(unsigned int irq)
+static inline void ack_msp_cic_irq(struct irq_desc *desc)
 {
-	mask_msp_cic_irq(irq);
+	unsigned int irq = desc->irq;
+	mask_msp_cic_irq(desc);
 
 	/*
 	 * only really necessary for 18, 16-14 and sometimes 3:0 (since
Index: linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
===================================================================
--- linux-2.6.orig/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
+++ linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
@@ -21,8 +21,9 @@
 #include <msp_slp_int.h>
 #include <msp_regs.h>
 
-static inline void unmask_msp_slp_irq(unsigned int irq)
+static inline void unmask_msp_slp_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
 		*SLP_INT_MSK_REG |= (1 << (irq - MSP_SLP_INTBASE));
@@ -30,8 +31,9 @@ static inline void unmask_msp_slp_irq(un
 		*PER_INT_MSK_REG |= (1 << (irq - MSP_PER_INTBASE));
 }
 
-static inline void mask_msp_slp_irq(unsigned int irq)
+static inline void mask_msp_slp_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
 		*SLP_INT_MSK_REG &= ~(1 << (irq - MSP_SLP_INTBASE));
@@ -43,8 +45,9 @@ static inline void mask_msp_slp_irq(unsi
  * While we ack the interrupt interrupts are disabled and thus we don't need
  * to deal with concurrency issues.  Same for msp_slp_irq_end.
  */
-static inline void ack_msp_slp_irq(unsigned int irq)
+static inline void ack_msp_slp_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* check for PER interrupt range */
 	if (irq < MSP_PER_INTBASE)
 		*SLP_INT_STS_REG = (1 << (irq - MSP_SLP_INTBASE));
Index: linux-2.6/arch/mips/powertv/asic/irq_asic.c
===================================================================
--- linux-2.6.orig/arch/mips/powertv/asic/irq_asic.c
+++ linux-2.6/arch/mips/powertv/asic/irq_asic.c
@@ -20,8 +20,9 @@
 
 #include <asm/mach-powertv/asic_regs.h>
 
-static inline void unmask_asic_irq(unsigned int irq)
+static inline void unmask_asic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long enable_bit;
 
 	enable_bit = (1 << (irq & 0x1f));
@@ -44,8 +45,9 @@ static inline void unmask_asic_irq(unsig
 	}
 }
 
-static inline void mask_asic_irq(unsigned int irq)
+static inline void mask_asic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long disable_mask;
 
 	disable_mask = ~(1 << (irq & 0x1f));
Index: linux-2.6/arch/mips/rb532/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/rb532/irq.c
+++ linux-2.6/arch/mips/rb532/irq.c
@@ -112,14 +112,15 @@ static inline void ack_local_irq(unsigne
 	clear_c0_cause(ipnum);
 }
 
-static void rb532_enable_irq(unsigned int irq_nr)
+static void rb532_enable_irq(struct irq_desc *desc)
 {
-	int ip = irq_nr - GROUP0_IRQ_BASE;
+	unsigned int irq = desc->irq;
+	int ip = irq - GROUP0_IRQ_BASE;
 	unsigned int group, intr_bit;
 	volatile unsigned int *addr;
 
 	if (ip < 0)
-		enable_local_irq(irq_nr);
+		enable_local_irq(irq);
 	else {
 		group = ip >> 5;
 
@@ -133,14 +134,15 @@ static void rb532_enable_irq(unsigned in
 	}
 }
 
-static void rb532_disable_irq(unsigned int irq_nr)
+static void rb532_disable_irq(struct irq_desc *desc)
 {
-	int ip = irq_nr - GROUP0_IRQ_BASE;
+	unsigned int irq = desc->irq;
+	int ip = irq - GROUP0_IRQ_BASE;
 	unsigned int group, intr_bit, mask;
 	volatile unsigned int *addr;
 
 	if (ip < 0) {
-		disable_local_irq(irq_nr);
+		disable_local_irq(irq);
 	} else {
 		group = ip >> 5;
 
@@ -152,8 +154,8 @@ static void rb532_disable_irq(unsigned i
 		WRITE_MASK(addr, mask);
 
 		/* There is a maximum of 14 GPIO interrupts */
-		if (group == GPIO_MAPPED_IRQ_GROUP && irq_nr <= (GROUP4_IRQ_BASE + 13))
-			rb532_gpio_set_istat(0, irq_nr - GPIO_MAPPED_IRQ_BASE);
+		if (group == GPIO_MAPPED_IRQ_GROUP && irq <= (GROUP4_IRQ_BASE + 13))
+			rb532_gpio_set_istat(0, irq - GPIO_MAPPED_IRQ_BASE);
 
 		/*
 		 * if there are no more interrupts enabled in this
@@ -164,16 +166,18 @@ static void rb532_disable_irq(unsigned i
 	}
 }
 
-static void rb532_mask_and_ack_irq(unsigned int irq_nr)
+static void rb532_mask_and_ack_irq(struct irq_desc *desc)
 {
-	rb532_disable_irq(irq_nr);
-	ack_local_irq(group_to_ip(irq_to_group(irq_nr)));
+	unsigned int irq = desc->irq;
+	rb532_disable_irq(desc);
+	ack_local_irq(group_to_ip(irq_to_group(irq)));
 }
 
-static int rb532_set_type(unsigned int irq_nr, unsigned type)
+static int rb532_set_type(struct irq_desc *desc, unsigned type)
 {
-	int gpio = irq_nr - GPIO_MAPPED_IRQ_BASE;
-	int group = irq_to_group(irq_nr);
+	unsigned int irq = desc->irq;
+	int gpio = irq - GPIO_MAPPED_IRQ_BASE;
+	int group = irq_to_group(irq);
 
 	if (group != GPIO_MAPPED_IRQ_GROUP || irq_nr > (GROUP4_IRQ_BASE + 13))
 		return (type == IRQ_TYPE_LEVEL_HIGH) ? 0 : -EINVAL;
Index: linux-2.6/arch/mips/sgi-ip22/ip22-int.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip22/ip22-int.c
+++ linux-2.6/arch/mips/sgi-ip22/ip22-int.c
@@ -31,16 +31,18 @@ static char lc3msk_to_irqnr[256];
 
 extern int ip22_eisa_init(void);
 
-static void enable_local0_irq(unsigned int irq)
+static void enable_local0_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* don't allow mappable interrupt to be enabled from setup_irq,
 	 * we have our own way to do so */
 	if (irq != SGI_MAP_0_IRQ)
 		sgint->imask0 |= (1 << (irq - SGINT_LOCAL0));
 }
 
-static void disable_local0_irq(unsigned int irq)
+static void disable_local0_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sgint->imask0 &= ~(1 << (irq - SGINT_LOCAL0));
 }
 
@@ -52,16 +54,18 @@ static struct irq_chip ip22_local0_irq_t
 	.unmask		= enable_local0_irq,
 };
 
-static void enable_local1_irq(unsigned int irq)
+static void enable_local1_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* don't allow mappable interrupt to be enabled from setup_irq,
 	 * we have our own way to do so */
 	if (irq != SGI_MAP_1_IRQ)
 		sgint->imask1 |= (1 << (irq - SGINT_LOCAL1));
 }
 
-static void disable_local1_irq(unsigned int irq)
+static void disable_local1_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sgint->imask1 &= ~(1 << (irq - SGINT_LOCAL1));
 }
 
@@ -73,14 +77,16 @@ static struct irq_chip ip22_local1_irq_t
 	.unmask		= enable_local1_irq,
 };
 
-static void enable_local2_irq(unsigned int irq)
+static void enable_local2_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sgint->imask0 |= (1 << (SGI_MAP_0_IRQ - SGINT_LOCAL0));
 	sgint->cmeimask0 |= (1 << (irq - SGINT_LOCAL2));
 }
 
-static void disable_local2_irq(unsigned int irq)
+static void disable_local2_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sgint->cmeimask0 &= ~(1 << (irq - SGINT_LOCAL2));
 	if (!sgint->cmeimask0)
 		sgint->imask0 &= ~(1 << (SGI_MAP_0_IRQ - SGINT_LOCAL0));
@@ -94,14 +100,16 @@ static struct irq_chip ip22_local2_irq_t
 	.unmask		= enable_local2_irq,
 };
 
-static void enable_local3_irq(unsigned int irq)
+static void enable_local3_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sgint->imask1 |= (1 << (SGI_MAP_1_IRQ - SGINT_LOCAL1));
 	sgint->cmeimask1 |= (1 << (irq - SGINT_LOCAL3));
 }
 
-static void disable_local3_irq(unsigned int irq)
+static void disable_local3_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sgint->cmeimask1 &= ~(1 << (irq - SGINT_LOCAL3));
 	if (!sgint->cmeimask1)
 		sgint->imask1 &= ~(1 << (SGI_MAP_1_IRQ - SGINT_LOCAL1));
Index: linux-2.6/arch/mips/sgi-ip27/ip27-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip27/ip27-irq.c
+++ linux-2.6/arch/mips/sgi-ip27/ip27-irq.c
@@ -241,8 +241,9 @@ static int intr_disconnect_level(int cpu
 }
 
 /* Startup one of the (PCI ...) IRQs routes over a bridge.  */
-static unsigned int startup_bridge_irq(unsigned int irq)
+static unsigned int startup_bridge_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct bridge_controller *bc;
 	bridgereg_t device;
 	bridge_t *bridge;
@@ -289,8 +290,9 @@ static unsigned int startup_bridge_irq(u
 }
 
 /* Shutdown one of the (PCI ...) IRQs routes over a bridge.  */
-static void shutdown_bridge_irq(unsigned int irq)
+static void shutdown_bridge_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct bridge_controller *bc = IRQ_TO_BRIDGE(irq);
 	bridge_t *bridge = bc->base;
 	int pin, swlevel;
@@ -310,8 +312,9 @@ static void shutdown_bridge_irq(unsigned
 	bridge->b_wid_tflush;
 }
 
-static inline void enable_bridge_irq(unsigned int irq)
+static inline void enable_bridge_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	cpuid_t cpu;
 	int swlevel;
 
@@ -319,8 +322,9 @@ static inline void enable_bridge_irq(uns
 	intr_connect_level(cpu, swlevel);
 }
 
-static inline void disable_bridge_irq(unsigned int irq)
+static inline void disable_bridge_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
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
+static void enable_rt_irq(struct irq_desc *desc)
 {
 }
 
-static void disable_rt_irq(unsigned int irq)
+static void disable_rt_irq(struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip32/ip32-irq.c
+++ linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
@@ -131,16 +131,18 @@ static struct irqaction cpuerr_irq = {
 
 static uint64_t crime_mask;
 
-static inline void crime_enable_irq(unsigned int irq)
+static inline void crime_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
 	crime_mask |= 1 << bit;
 	crime->imask = crime_mask;
 }
 
-static inline void crime_disable_irq(unsigned int irq)
+static inline void crime_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
 	crime_mask &= ~(1 << bit);
@@ -148,15 +150,15 @@ static inline void crime_disable_irq(uns
 	flush_crime_bus();
 }
 
-static void crime_level_mask_and_ack_irq(unsigned int irq)
+static void crime_level_mask_and_ack_irq(struct irq_desc *desc)
 {
-	crime_disable_irq(irq);
+	crime_disable_irq(desc);
 }
 
-static void crime_level_end_irq(unsigned int irq)
+static void crime_level_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		crime_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		crime_enable_irq(desc);
 }
 
 static struct irq_chip crime_level_interrupt = {
@@ -168,8 +170,9 @@ static struct irq_chip crime_level_inter
 	.end		= crime_level_end_irq,
 };
 
-static void crime_edge_mask_and_ack_irq(unsigned int irq)
+static void crime_edge_mask_and_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 	uint64_t crime_int;
 
@@ -179,13 +182,13 @@ static void crime_edge_mask_and_ack_irq(
 	crime_int &= ~(1 << bit);
 	crime->hard_int = crime_int;
 
-	crime_disable_irq(irq);
+	crime_disable_irq(desc);
 }
 
-static void crime_edge_end_irq(unsigned int irq)
+static void crime_edge_end_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		crime_enable_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		crime_enable_irq(desc);
 }
 
 static struct irq_chip crime_edge_interrupt = {
@@ -205,16 +208,18 @@ static struct irq_chip crime_edge_interr
 
 static unsigned long macepci_mask;
 
-static void enable_macepci_irq(unsigned int irq)
+static void enable_macepci_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	macepci_mask |= MACEPCI_CONTROL_INT(irq - MACEPCI_SCSI0_IRQ);
 	mace->pci.control = macepci_mask;
 	crime_mask |= 1 << (irq - CRIME_IRQ_BASE);
 	crime->imask = crime_mask;
 }
 
-static void disable_macepci_irq(unsigned int irq)
+static void disable_macepci_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	crime_mask &= ~(1 << (irq - CRIME_IRQ_BASE));
 	crime->imask = crime_mask;
 	flush_crime_bus();
@@ -223,10 +228,10 @@ static void disable_macepci_irq(unsigned
 	flush_mace_bus();
 }
 
-static void end_macepci_irq(unsigned int irq)
+static void end_macepci_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_macepci_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		enable_macepci_irq(desc);
 }
 
 static struct irq_chip ip32_macepci_interrupt = {
@@ -277,8 +282,9 @@ static struct irq_chip ip32_macepci_inte
 
 static unsigned long maceisa_mask;
 
-static void enable_maceisa_irq(unsigned int irq)
+static void enable_maceisa_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int crime_int = 0;
 
 	pr_debug("maceisa enable: %u\n", irq);
@@ -301,8 +307,9 @@ static void enable_maceisa_irq(unsigned
 	mace->perif.ctrl.imask = maceisa_mask;
 }
 
-static void disable_maceisa_irq(unsigned int irq)
+static void disable_maceisa_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int crime_int = 0;
 
 	maceisa_mask &= ~(1 << (irq - MACEISA_AUDIO_SW_IRQ));
@@ -319,8 +326,9 @@ static void disable_maceisa_irq(unsigned
 	flush_mace_bus();
 }
 
-static void mask_and_ack_maceisa_irq(unsigned int irq)
+static void mask_and_ack_maceisa_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mace_int;
 
 	/* edge triggered */
@@ -328,13 +336,13 @@ static void mask_and_ack_maceisa_irq(uns
 	mace_int &= ~(1 << (irq - MACEISA_AUDIO_SW_IRQ));
 	mace->perif.ctrl.istat = mace_int;
 
-	disable_maceisa_irq(irq);
+	disable_maceisa_irq(desc);
 }
 
-static void end_maceisa_irq(unsigned irq)
+static void end_maceisa_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_maceisa_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		enable_maceisa_irq(desc);
 }
 
 static struct irq_chip ip32_maceisa_level_interrupt = {
@@ -359,16 +367,18 @@ static struct irq_chip ip32_maceisa_edge
  * bits 0-3 and 7 in the CRIME register.
  */
 
-static void enable_mace_irq(unsigned int irq)
+static void enable_mace_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
 	crime_mask |= (1 << bit);
 	crime->imask = crime_mask;
 }
 
-static void disable_mace_irq(unsigned int irq)
+static void disable_mace_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - CRIME_IRQ_BASE;
 
 	crime_mask &= ~(1 << bit);
@@ -376,10 +386,10 @@ static void disable_mace_irq(unsigned in
 	flush_crime_bus();
 }
 
-static void end_mace_irq(unsigned int irq)
+static void end_mace_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_mace_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		enable_mace_irq(desc);
 }
 
 static struct irq_chip ip32_mace_interrupt = {
Index: linux-2.6/arch/mips/sibyte/bcm1480/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/irq.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/irq.c
@@ -46,12 +46,12 @@
  */
 
 
-static void end_bcm1480_irq(unsigned int irq);
-static void enable_bcm1480_irq(unsigned int irq);
-static void disable_bcm1480_irq(unsigned int irq);
-static void ack_bcm1480_irq(unsigned int irq);
+static void end_bcm1480_irq(struct irq_desc *desc);
+static void enable_bcm1480_irq(struct irq_desc *desc);
+static void disable_bcm1480_irq(struct irq_desc *desc);
+static void ack_bcm1480_irq(struct irq_desc *desc);
 #ifdef CONFIG_SMP
-static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
+static int bcm1480_set_affinity(struct irq_desc *desc, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_PCI
@@ -110,8 +110,9 @@ void bcm1480_unmask_irq(int cpu, int irq
 }
 
 #ifdef CONFIG_SMP
-static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int bcm1480_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
+	unsigned int irq = desc->irq;
 	int i = 0, old_cpu, cpu, int_on, k;
 	u64 cur_ints;
 	unsigned long flags;
@@ -157,19 +158,22 @@ static int bcm1480_set_affinity(unsigned
 
 /*****************************************************************************/
 
-static void disable_bcm1480_irq(unsigned int irq)
+static void disable_bcm1480_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	bcm1480_mask_irq(bcm1480_irq_owner[irq], irq);
 }
 
-static void enable_bcm1480_irq(unsigned int irq)
+static void enable_bcm1480_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	bcm1480_unmask_irq(bcm1480_irq_owner[irq], irq);
 }
 
 
-static void ack_bcm1480_irq(unsigned int irq)
+static void ack_bcm1480_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u64 pending;
 	unsigned int irq_dirty;
 	int k;
@@ -219,11 +223,11 @@ static void ack_bcm1480_irq(unsigned int
 }
 
 
-static void end_bcm1480_irq(unsigned int irq)
+static void end_bcm1480_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+	unsigned int irq = desc->irq;
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		bcm1480_unmask_irq(bcm1480_irq_owner[irq], irq);
-	}
 }
 
 
Index: linux-2.6/arch/mips/sibyte/sb1250/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/irq.c
+++ linux-2.6/arch/mips/sibyte/sb1250/irq.c
@@ -45,12 +45,12 @@
  */
 
 
-static void end_sb1250_irq(unsigned int irq);
-static void enable_sb1250_irq(unsigned int irq);
-static void disable_sb1250_irq(unsigned int irq);
-static void ack_sb1250_irq(unsigned int irq);
+static void end_sb1250_irq(struct irq_desc *desc);
+static void enable_sb1250_irq(struct irq_desc *desc);
+static void disable_sb1250_irq(struct irq_desc *desc);
+static void ack_sb1250_irq(struct irq_desc *desc);
 #ifdef CONFIG_SMP
-static int sb1250_set_affinity(unsigned int irq, const struct cpumask *mask);
+static int sb1250_set_affinity(struct irq_desc *desc, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_SIBYTE_HAS_LDT
@@ -103,8 +103,9 @@ void sb1250_unmask_irq(int cpu, int irq)
 }
 
 #ifdef CONFIG_SMP
-static int sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int sb1250_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
+	unsigned int irq = desc->irq;
 	int i = 0, old_cpu, cpu, int_on;
 	u64 cur_ints;
 	unsigned long flags;
@@ -145,19 +146,22 @@ static int sb1250_set_affinity(unsigned
 
 /*****************************************************************************/
 
-static void disable_sb1250_irq(unsigned int irq)
+static void disable_sb1250_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sb1250_mask_irq(sb1250_irq_owner[irq], irq);
 }
 
-static void enable_sb1250_irq(unsigned int irq)
+static void enable_sb1250_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	sb1250_unmask_irq(sb1250_irq_owner[irq], irq);
 }
 
 
-static void ack_sb1250_irq(unsigned int irq)
+static void ack_sb1250_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 #ifdef CONFIG_SIBYTE_HAS_LDT
 	u64 pending;
 
@@ -201,11 +205,11 @@ static void ack_sb1250_irq(unsigned int
 }
 
 
-static void end_sb1250_irq(unsigned int irq)
+static void end_sb1250_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+	unsigned int irq = desc->irq;
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
 		sb1250_unmask_irq(sb1250_irq_owner[irq], irq);
-	}
 }
 
 
Index: linux-2.6/arch/mips/sni/a20r.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/a20r.c
+++ linux-2.6/arch/mips/sni/a20r.c
@@ -167,23 +167,25 @@ static u32 a20r_ack_hwint(void)
 	return status;
 }
 
-static inline void unmask_a20r_irq(unsigned int irq)
+static inline void unmask_a20r_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_c0_status(0x100 << (irq - SNI_A20R_IRQ_BASE));
 	irq_enable_hazard();
 }
 
-static inline void mask_a20r_irq(unsigned int irq)
+static inline void mask_a20r_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	clear_c0_status(0x100 << (irq - SNI_A20R_IRQ_BASE));
 	irq_disable_hazard();
 }
 
-static void end_a20r_irq(unsigned int irq)
+static void end_a20r_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
+	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS))) {
 		a20r_ack_hwint();
-		unmask_a20r_irq(irq);
+		unmask_a20r_irq(desc);
 	}
 }
 
Index: linux-2.6/arch/mips/sni/pcimt.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/pcimt.c
+++ linux-2.6/arch/mips/sni/pcimt.c
@@ -193,24 +193,26 @@ static struct pci_controller sni_control
 	.io_map_base    = SNI_PORT_BASE
 };
 
-static void enable_pcimt_irq(unsigned int irq)
+static void enable_pcimt_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq - PCIMT_IRQ_INT2);
 
 	*(volatile u8 *) PCIMT_IRQSEL |= mask;
 }
 
-void disable_pcimt_irq(unsigned int irq)
+void disable_pcimt_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = ~(1 << (irq - PCIMT_IRQ_INT2));
 
 	*(volatile u8 *) PCIMT_IRQSEL &= mask;
 }
 
-static void end_pcimt_irq(unsigned int irq)
-{
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_pcimt_irq(irq);
+static void end_pcimt_irq(struct irq_desc *desc)
+
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		enable_pcimt_irq(desc);
 }
 
 static struct irq_chip pcimt_irq_type = {
Index: linux-2.6/arch/mips/sni/pcit.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/pcit.c
+++ linux-2.6/arch/mips/sni/pcit.c
@@ -155,24 +155,26 @@ static struct pci_controller sni_pcit_co
 	.io_map_base    = SNI_PORT_BASE
 };
 
-static void enable_pcit_irq(unsigned int irq)
+static void enable_pcit_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask = 1 << (irq - SNI_PCIT_INT_START + 24);
 
 	*(volatile u32 *)SNI_PCIT_INT_REG |= mask;
 }
 
-void disable_pcit_irq(unsigned int irq)
+void disable_pcit_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 mask = 1 << (irq - SNI_PCIT_INT_START + 24);
 
 	*(volatile u32 *)SNI_PCIT_INT_REG &= ~mask;
 }
 
-void end_pcit_irq(unsigned int irq)
+void end_pcit_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_pcit_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		enable_pcit_irq(desc);
 }
 
 static struct irq_chip pcit_irq_type = {
Index: linux-2.6/arch/mips/sni/rm200.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/rm200.c
+++ linux-2.6/arch/mips/sni/rm200.c
@@ -154,8 +154,9 @@ static __iomem u8 *rm200_pic_slave;
 #define cached_master_mask	(rm200_cached_irq_mask)
 #define cached_slave_mask	(rm200_cached_irq_mask >> 8)
 
-static void sni_rm200_disable_8259A_irq(unsigned int irq)
+static void sni_rm200_disable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	unsigned long flags;
 
@@ -170,8 +171,9 @@ static void sni_rm200_disable_8259A_irq(
 	spin_unlock_irqrestore(&sni_rm200_i8259A_lock, flags);
 }
 
-static void sni_rm200_enable_8259A_irq(unsigned int irq)
+static void sni_rm200_enable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask;
 	unsigned long flags;
 
@@ -209,8 +211,9 @@ static inline int sni_rm200_i8259A_irq_r
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-void sni_rm200_mask_and_ack_8259A(unsigned int irq)
+void sni_rm200_mask_and_ack_8259A(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irqmask;
 	unsigned long flags;
 
@@ -428,24 +431,26 @@ void __init sni_rm200_i8259_irqs(void)
 #define SNI_RM200_INT_START  24
 #define SNI_RM200_INT_END    28
 
-static void enable_rm200_irq(unsigned int irq)
+static void enable_rm200_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq - SNI_RM200_INT_START);
 
 	*(volatile u8 *)SNI_RM200_INT_ENA_REG &= ~mask;
 }
 
-void disable_rm200_irq(unsigned int irq)
+void disable_rm200_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << (irq - SNI_RM200_INT_START);
 
 	*(volatile u8 *)SNI_RM200_INT_ENA_REG |= mask;
 }
 
-void end_rm200_irq(unsigned int irq)
+void end_rm200_irq(struct irq_desc *desc)
 {
-	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
-		enable_rm200_irq(irq);
+	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+		enable_rm200_irq(desc);
 }
 
 static struct irq_chip rm200_irq_type = {
Index: linux-2.6/arch/mips/txx9/generic/irq_tx4939.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/generic/irq_tx4939.c
+++ linux-2.6/arch/mips/txx9/generic/irq_tx4939.c
@@ -49,8 +49,9 @@ static struct {
 	unsigned char mode;
 } tx4939irq[TX4939_NUM_IR] __read_mostly;
 
-static void tx4939_irq_unmask(unsigned int irq)
+static void tx4939_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *lvlp;
 	int ofs;
@@ -67,8 +68,9 @@ static void tx4939_irq_unmask(unsigned i
 		     lvlp);
 }
 
-static inline void tx4939_irq_mask(unsigned int irq)
+static inline void tx4939_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 __iomem *lvlp;
 	int ofs;
@@ -86,11 +88,12 @@ static inline void tx4939_irq_mask(unsig
 	mmiowb();
 }
 
-static void tx4939_irq_mask_ack(unsigned int irq)
+static void tx4939_irq_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 
-	tx4939_irq_mask(irq);
+	tx4939_irq_mask(desc);
 	if (TXx9_IRCR_EDGE(tx4939irq[irq_nr].mode)) {
 		irq_nr--;
 		/* clear edge detection */
@@ -100,8 +103,9 @@ static void tx4939_irq_mask_ack(unsigned
 	}
 }
 
-static int tx4939_irq_set_type(unsigned int irq, unsigned int flow_type)
+static int tx4939_irq_set_type(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irq_nr = irq - TXX9_IRQ_BASE;
 	u32 cr;
 	u32 __iomem *crp;
Index: linux-2.6/arch/mips/txx9/jmr3927/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/jmr3927/irq.c
+++ linux-2.6/arch/mips/txx9/jmr3927/irq.c
@@ -46,8 +46,9 @@
  * CP0_STATUS is a thread's resource (saved/restored on context switch).
  * So disable_irq/enable_irq MUST handle IOC/IRC registers.
  */
-static void mask_irq_ioc(unsigned int irq)
+static void mask_irq_ioc(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* 0: mask */
 	unsigned int irq_nr = irq - JMR3927_IRQ_IOC;
 	unsigned char imask = jmr3927_ioc_reg_in(JMR3927_IOC_INTM_ADDR);
@@ -56,8 +57,9 @@ static void mask_irq_ioc(unsigned int ir
 	/* flush write buffer */
 	(void)jmr3927_ioc_reg_in(JMR3927_IOC_REV_ADDR);
 }
-static void unmask_irq_ioc(unsigned int irq)
+static void unmask_irq_ioc(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* 0: mask */
 	unsigned int irq_nr = irq - JMR3927_IRQ_IOC;
 	unsigned char imask = jmr3927_ioc_reg_in(JMR3927_IOC_INTM_ADDR);
Index: linux-2.6/arch/mips/txx9/rbtx4927/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/rbtx4927/irq.c
+++ linux-2.6/arch/mips/txx9/rbtx4927/irq.c
@@ -116,8 +116,8 @@
 #include <asm/txx9/generic.h>
 #include <asm/txx9/rbtx4927.h>
 
-static void toshiba_rbtx4927_irq_ioc_enable(unsigned int irq);
-static void toshiba_rbtx4927_irq_ioc_disable(unsigned int irq);
+static void toshiba_rbtx4927_irq_ioc_enable(struct irq_desc *desc);
+static void toshiba_rbtx4927_irq_ioc_disable(struct irq_desc *desc);
 
 #define TOSHIBA_RBTX4927_IOC_NAME "RBTX4927-IOC"
 static struct irq_chip toshiba_rbtx4927_irq_ioc_type = {
@@ -154,8 +154,9 @@ static void __init toshiba_rbtx4927_irq_
 	set_irq_chained_handler(RBTX4927_IRQ_IOCINT, handle_simple_irq);
 }
 
-static void toshiba_rbtx4927_irq_ioc_enable(unsigned int irq)
+static void toshiba_rbtx4927_irq_ioc_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned char v;
 
 	v = readb(rbtx4927_imask_addr);
@@ -163,8 +164,9 @@ static void toshiba_rbtx4927_irq_ioc_ena
 	writeb(v, rbtx4927_imask_addr);
 }
 
-static void toshiba_rbtx4927_irq_ioc_disable(unsigned int irq)
+static void toshiba_rbtx4927_irq_ioc_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned char v;
 
 	v = readb(rbtx4927_imask_addr);
Index: linux-2.6/arch/mips/txx9/rbtx4938/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/rbtx4938/irq.c
+++ linux-2.6/arch/mips/txx9/rbtx4938/irq.c
@@ -68,8 +68,8 @@
 #include <asm/txx9/generic.h>
 #include <asm/txx9/rbtx4938.h>
 
-static void toshiba_rbtx4938_irq_ioc_enable(unsigned int irq);
-static void toshiba_rbtx4938_irq_ioc_disable(unsigned int irq);
+static void toshiba_rbtx4938_irq_ioc_enable(struct irq_desc *desc);
+static void toshiba_rbtx4938_irq_ioc_disable(struct irq_desc *desc);
 
 #define TOSHIBA_RBTX4938_IOC_NAME "RBTX4938-IOC"
 static struct irq_chip toshiba_rbtx4938_irq_ioc_type = {
@@ -105,8 +105,9 @@ toshiba_rbtx4938_irq_ioc_init(void)
 }
 
 static void
-toshiba_rbtx4938_irq_ioc_enable(unsigned int irq)
+toshiba_rbtx4938_irq_ioc_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned char v;
 
 	v = readb(rbtx4938_imask_addr);
@@ -116,8 +117,9 @@ toshiba_rbtx4938_irq_ioc_enable(unsigned
 }
 
 static void
-toshiba_rbtx4938_irq_ioc_disable(unsigned int irq)
+toshiba_rbtx4938_irq_ioc_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned char v;
 
 	v = readb(rbtx4938_imask_addr);
Index: linux-2.6/arch/mips/txx9/rbtx4939/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/rbtx4939/irq.c
+++ linux-2.6/arch/mips/txx9/rbtx4939/irq.c
@@ -18,15 +18,17 @@
  * RBTX4939 IOC controller definition
  */
 
-static void rbtx4939_ioc_irq_unmask(unsigned int irq)
+static void rbtx4939_ioc_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int ioc_nr = irq - RBTX4939_IRQ_IOC;
 
 	writeb(readb(rbtx4939_ien_addr) | (1 << ioc_nr), rbtx4939_ien_addr);
 }
 
-static void rbtx4939_ioc_irq_mask(unsigned int irq)
+static void rbtx4939_ioc_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	int ioc_nr = irq - RBTX4939_IRQ_IOC;
 
 	writeb(readb(rbtx4939_ien_addr) & ~(1 << ioc_nr), rbtx4939_ien_addr);
Index: linux-2.6/arch/mips/vr41xx/common/icu.c
===================================================================
--- linux-2.6.orig/arch/mips/vr41xx/common/icu.c
+++ linux-2.6/arch/mips/vr41xx/common/icu.c
@@ -442,13 +442,15 @@ void vr41xx_disable_bcuint(void)
 
 EXPORT_SYMBOL(vr41xx_disable_bcuint);
 
-static void disable_sysint1_irq(unsigned int irq)
+static void disable_sysint1_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	icu1_clear(MSYSINT1REG, 1 << SYSINT1_IRQ_TO_PIN(irq));
 }
 
-static void enable_sysint1_irq(unsigned int irq)
+static void enable_sysint1_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	icu1_set(MSYSINT1REG, 1 << SYSINT1_IRQ_TO_PIN(irq));
 }
 
@@ -460,13 +462,15 @@ static struct irq_chip sysint1_irq_type
 	.unmask		= enable_sysint1_irq,
 };
 
-static void disable_sysint2_irq(unsigned int irq)
+static void disable_sysint2_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	icu2_clear(MSYSINT2REG, 1 << SYSINT2_IRQ_TO_PIN(irq));
 }
 
-static void enable_sysint2_irq(unsigned int irq)
+static void enable_sysint2_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
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
+			desc->chip->mask_ack(desc);
 		else {
-			desc->chip->mask(source_irq);
-			desc->chip->ack(source_irq);
+			desc->chip->mask(desc);
+			desc->chip->ack(desc);
 		}
 		ret = cascade->get_irq(irq);
 		irq = ret;
@@ -86,7 +86,7 @@ static void irq_dispatch(unsigned int ir
 		else
 			irq_dispatch(irq);
 		if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-			desc->chip->unmask(source_irq);
+			desc->chip->unmask(desc);
 	} else
 		do_IRQ(irq);
 }
Index: linux-2.6/arch/mn10300/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/irq.c
+++ linux-2.6/arch/mn10300/kernel/irq.c
@@ -22,36 +22,45 @@ atomic_t irq_err_count;
 /*
  * MN10300 interrupt controller operations
  */
-static void mn10300_cpupic_ack(unsigned int irq)
+static void mn10300_cpupic_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u16 tmp;
 	*(volatile u8 *) &GxICR(irq) = GxICR_DETECT;
 	tmp = GxICR(irq);
 }
 
-static void mn10300_cpupic_mask(unsigned int irq)
+static void mn10300_cpupic_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u16 tmp = GxICR(irq);
 	GxICR(irq) = (tmp & GxICR_LEVEL);
 	tmp = GxICR(irq);
 }
+static void mn10300_cpupic_mask_desc(struct irq_desc *desc)
+{
+	mn10300_cpupic_mask(desc);
+}
 
-static void mn10300_cpupic_mask_ack(unsigned int irq)
+static void mn10300_cpupic_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u16 tmp = GxICR(irq);
 	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
 	tmp = GxICR(irq);
 }
 
-static void mn10300_cpupic_unmask(unsigned int irq)
+static void mn10300_cpupic_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u16 tmp = GxICR(irq);
 	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
 	tmp = GxICR(irq);
 }
 
-static void mn10300_cpupic_unmask_clear(unsigned int irq)
+static void mn10300_cpupic_unmask_clear(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	/* the MN10300 PIC latches its interrupt request bit, even after the
 	 * device has ceased to assert its interrupt line and the interrupt
 	 * channel has been disabled in the PIC, so for level-triggered
Index: linux-2.6/arch/mn10300/kernel/mn10300-serial.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/mn10300-serial.c
+++ linux-2.6/arch/mn10300/kernel/mn10300-serial.c
@@ -325,14 +325,15 @@ struct mn10300_serial_port *mn10300_seri
  * note that we can't just leave the line enabled as the baud rate timer *also*
  * generates interrupts
  */
-static void mn10300_serial_mask_ack(unsigned int irq)
+static void mn10300_serial_mask_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u16 tmp;
 	GxICR(irq) = GxICR_LEVEL_6;
 	tmp = GxICR(irq); /* flush write buffer */
 }
 
-static void mn10300_serial_nop(unsigned int irq)
+static void mn10300_serial_nop(struct irq_desc *desc)
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
+void no_ack_irq(struct irq_desc *desc);
 void no_end_irq(unsigned int irq);
-void cpu_ack_irq(unsigned int irq);
+void cpu_ack_irq(struct irq_desc *desc);
 void cpu_end_irq(unsigned int irq);
 
 extern int txn_alloc_irq(unsigned int nbits);
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -52,8 +52,9 @@ static volatile unsigned long cpu_eiem =
 */
 static DEFINE_PER_CPU(unsigned long, local_ack_eiem) = ~0UL;
 
-static void cpu_disable_irq(unsigned int irq)
+static void cpu_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long eirr_bit = EIEM_MASK(irq);
 
 	cpu_eiem &= ~eirr_bit;
@@ -63,8 +64,9 @@ static void cpu_disable_irq(unsigned int
 	 * then gets disabled */
 }
 
-static void cpu_enable_irq(unsigned int irq)
+static void cpu_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long eirr_bit = EIEM_MASK(irq);
 
 	cpu_eiem |= eirr_bit;
@@ -75,17 +77,18 @@ static void cpu_enable_irq(unsigned int
 	smp_send_all_nop();
 }
 
-static unsigned int cpu_startup_irq(unsigned int irq)
+static unsigned int cpu_startup_irq(struct irq_desc *desc)
 {
-	cpu_enable_irq(irq);
+	cpu_enable_irq(desc);
 	return 0;
 }
 
-void no_ack_irq(unsigned int irq) { }
-void no_end_irq(unsigned int irq) { }
+void no_ack_irq(struct irq_desc *desc) { }
+void no_end_irq(struct irq_desc *desc) { }
 
-void cpu_ack_irq(unsigned int irq)
+void cpu_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask = EIEM_MASK(irq);
 	int cpu = smp_processor_id();
 
@@ -99,8 +102,9 @@ void cpu_ack_irq(unsigned int irq)
 	mtctl(mask, 23);
 }
 
-void cpu_end_irq(unsigned int irq)
+void cpu_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long mask = EIEM_MASK(irq);
 	int cpu = smp_processor_id();
 
@@ -112,15 +116,16 @@ void cpu_end_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-int cpu_check_affinity(unsigned int irq, const struct cpumask *dest)
+int cpu_check_affinity(struct irq_desc *desc, const struct cpumask *dest)
 {
+	unsigned int irq = desc->irq;
 	int cpu_dest;
 
 	/* timer and ipi have to always be received on all CPUs */
 	if (CHECK_IRQ_PER_CPU(irq)) {
 		/* Bad linux design decision.  The mask has already
 		 * been set; we must reset it */
-		cpumask_setall(irq_desc[irq].affinity);
+		cpumask_setall(desc->affinity);
 		return -EINVAL;
 	}
 
@@ -130,15 +135,15 @@ int cpu_check_affinity(unsigned int irq,
 	return cpu_dest;
 }
 
-static int cpu_set_affinity_irq(unsigned int irq, const struct cpumask *dest)
+static int cpu_set_affinity_irq(struct irq_desc *desc, const struct cpumask *dest)
 {
 	int cpu_dest;
 
-	cpu_dest = cpu_check_affinity(irq, dest);
+	cpu_dest = cpu_check_affinity(desc, dest);
 	if (cpu_dest < 0)
 		return -1;
 
-	cpumask_copy(irq_desc[irq].affinity, dest);
+	cpumask_copy(desc->affinity, dest);
 
 	return 0;
 }
Index: linux-2.6/arch/powerpc/include/asm/mpic.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/mpic.h
+++ linux-2.6/arch/powerpc/include/asm/mpic.h
@@ -470,11 +470,11 @@ extern void mpic_send_ipi(unsigned int i
 void smp_mpic_message_pass(int target, int msg);
 
 /* Unmask a specific virq */
-extern void mpic_unmask_irq(unsigned int irq);
+extern void mpic_unmask_irq(struct irq_desc *desc);
 /* Mask a specific virq */
-extern void mpic_mask_irq(unsigned int irq);
+extern void mpic_mask_irq(struct irq_desc *desc);
 /* EOI a specific virq */
-extern void mpic_end_irq(unsigned int irq);
+extern void mpic_end_irq(struct irq_desc *desc);
 
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
+	desc->chip->eoi(desc);
 }
 
 static inline void qe_ic_cascade_high_mpic(unsigned int irq,
@@ -119,7 +119,7 @@ static inline void qe_ic_cascade_high_mp
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
 
 static inline void qe_ic_cascade_muxed_mpic(unsigned int irq,
@@ -135,7 +135,7 @@ static inline void qe_ic_cascade_muxed_m
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
 
 #endif /* _ASM_POWERPC_QE_IC_H */
Index: linux-2.6/arch/powerpc/kernel/crash.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/crash.c
+++ linux-2.6/arch/powerpc/kernel/crash.c
@@ -376,10 +376,10 @@ void default_machine_crash_shutdown(stru
 		struct irq_desc *desc = irq_to_desc(i);
 
 		if (desc->status & IRQ_INPROGRESS)
-			desc->chip->eoi(i);
+			desc->chip->eoi(desc);
 
 		if (!(desc->status & IRQ_DISABLED))
-			desc->chip->disable(i);
+			desc->chip->disable(desc);
 	}
 
 	/*
Index: linux-2.6/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6/arch/powerpc/kernel/irq.c
@@ -262,7 +262,7 @@ void fixup_irqs(cpumask_t map)
 			mask = map;
 		}
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, &mask);
+			desc->chip->set_affinity(desc, &mask);
 		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
Index: linux-2.6/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
+++ linux-2.6/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
@@ -59,8 +59,9 @@ irq_to_pic_bit(unsigned int irq)
 }
 
 static void
-cpld_mask_irq(unsigned int irq)
+cpld_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int cpld_irq = (unsigned int)irq_map[irq].hwirq;
 	void __iomem *pic_mask = irq_to_pic_mask(cpld_irq);
 
@@ -69,8 +70,9 @@ cpld_mask_irq(unsigned int irq)
 }
 
 static void
-cpld_unmask_irq(unsigned int irq)
+cpld_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int cpld_irq = (unsigned int)irq_map[irq].hwirq;
 	void __iomem *pic_mask = irq_to_pic_mask(cpld_irq);
 
Index: linux-2.6/arch/powerpc/platforms/52xx/media5200.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/52xx/media5200.c
+++ linux-2.6/arch/powerpc/platforms/52xx/media5200.c
@@ -49,26 +49,28 @@ struct media5200_irq {
 };
 struct media5200_irq media5200_irq;
 
-static void media5200_irq_unmask(unsigned int virq)
+static void media5200_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	u32 val;
 
 	spin_lock_irqsave(&media5200_irq.lock, flags);
 	val = in_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE);
-	val |= 1 << (MEDIA5200_IRQ_SHIFT + irq_map[virq].hwirq);
+	val |= 1 << (MEDIA5200_IRQ_SHIFT + irq_map[irq].hwirq);
 	out_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE, val);
 	spin_unlock_irqrestore(&media5200_irq.lock, flags);
 }
 
-static void media5200_irq_mask(unsigned int virq)
+static void media5200_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	u32 val;
 
 	spin_lock_irqsave(&media5200_irq.lock, flags);
 	val = in_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE);
-	val &= ~(1 << (MEDIA5200_IRQ_SHIFT + irq_map[virq].hwirq));
+	val &= ~(1 << (MEDIA5200_IRQ_SHIFT + irq_map[irq].hwirq));
 	out_be32(media5200_irq.regs + MEDIA5200_IRQ_ENABLE, val);
 	spin_unlock_irqrestore(&media5200_irq.lock, flags);
 }
@@ -87,7 +89,7 @@ void media5200_irq_cascade(unsigned int
 
 	/* Mask off the cascaded IRQ */
 	raw_spin_lock(&desc->lock);
-	desc->chip->mask(virq);
+	desc->chip->mask(desc);
 	raw_spin_unlock(&desc->lock);
 
 	/* Ask the FPGA for IRQ status.  If 'val' is 0, then no irqs
@@ -105,9 +107,9 @@ void media5200_irq_cascade(unsigned int
 
 	/* Processing done; can reenable the cascade now */
 	raw_spin_lock(&desc->lock);
-	desc->chip->ack(virq);
+	desc->chip->ack(desc);
 	if (!(desc->status & IRQ_DISABLED))
-		desc->chip->unmask(virq);
+		desc->chip->unmask(desc);
 	raw_spin_unlock(&desc->lock);
 }
 
Index: linux-2.6/arch/powerpc/platforms/52xx/mpc52xx_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/52xx/mpc52xx_pic.c
+++ linux-2.6/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -155,8 +155,9 @@ static inline void io_be_clrbit(u32 __io
 /*
  * IRQ[0-3] interrupt irq_chip
  */
-static void mpc52xx_extirq_mask(unsigned int virq)
+static void mpc52xx_extirq_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -166,8 +167,9 @@ static void mpc52xx_extirq_mask(unsigned
 	io_be_clrbit(&intr->ctrl, 11 - l2irq);
 }
 
-static void mpc52xx_extirq_unmask(unsigned int virq)
+static void mpc52xx_extirq_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -177,8 +179,9 @@ static void mpc52xx_extirq_unmask(unsign
 	io_be_setbit(&intr->ctrl, 11 - l2irq);
 }
 
-static void mpc52xx_extirq_ack(unsigned int virq)
+static void mpc52xx_extirq_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -188,8 +191,9 @@ static void mpc52xx_extirq_ack(unsigned
 	io_be_setbit(&intr->ctrl, 27-l2irq);
 }
 
-static int mpc52xx_extirq_set_type(unsigned int virq, unsigned int flow_type)
+static int mpc52xx_extirq_set_type(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int virq = desc->irq;
 	u32 ctrl_reg, type;
 	int irq;
 	int l2irq;
@@ -230,13 +234,14 @@ static struct irq_chip mpc52xx_extirq_ir
 /*
  * Main interrupt irq_chip
  */
-static int mpc52xx_null_set_type(unsigned int virq, unsigned int flow_type)
+static int mpc52xx_null_set_type(struct irq_desc *desc, unsigned int flow_type)
 {
 	return 0; /* Do nothing so that the sense mask will get updated */
 }
 
-static void mpc52xx_main_mask(unsigned int virq)
+static void mpc52xx_main_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -246,8 +251,9 @@ static void mpc52xx_main_mask(unsigned i
 	io_be_setbit(&intr->main_mask, 16 - l2irq);
 }
 
-static void mpc52xx_main_unmask(unsigned int virq)
+static void mpc52xx_main_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -268,8 +274,9 @@ static struct irq_chip mpc52xx_main_irqc
 /*
  * Peripherals interrupt irq_chip
  */
-static void mpc52xx_periph_mask(unsigned int virq)
+static void mpc52xx_periph_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -279,8 +286,9 @@ static void mpc52xx_periph_mask(unsigned
 	io_be_setbit(&intr->per_mask, 31 - l2irq);
 }
 
-static void mpc52xx_periph_unmask(unsigned int virq)
+static void mpc52xx_periph_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -301,8 +309,9 @@ static struct irq_chip mpc52xx_periph_ir
 /*
  * SDMA interrupt irq_chip
  */
-static void mpc52xx_sdma_mask(unsigned int virq)
+static void mpc52xx_sdma_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -312,8 +321,9 @@ static void mpc52xx_sdma_mask(unsigned i
 	io_be_setbit(&sdma->IntMask, l2irq);
 }
 
-static void mpc52xx_sdma_unmask(unsigned int virq)
+static void mpc52xx_sdma_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
@@ -323,8 +333,9 @@ static void mpc52xx_sdma_unmask(unsigned
 	io_be_clrbit(&sdma->IntMask, l2irq);
 }
 
-static void mpc52xx_sdma_ack(unsigned int virq)
+static void mpc52xx_sdma_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq;
 	int l2irq;
 
Index: linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
+++ linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
@@ -38,8 +38,9 @@ struct pq2ads_pci_pic {
 
 #define NUM_IRQS 32
 
-static void pq2ads_pci_mask_irq(unsigned int virq)
+static void pq2ads_pci_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct pq2ads_pci_pic *priv = get_irq_chip_data(virq);
 	int irq = NUM_IRQS - virq_to_hw(virq) - 1;
 
@@ -54,8 +55,9 @@ static void pq2ads_pci_mask_irq(unsigned
 	}
 }
 
-static void pq2ads_pci_unmask_irq(unsigned int virq)
+static void pq2ads_pci_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
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
+	desc->chip->eoi(desc);
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
+	desc->chip->eoi(desc);
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
+	desc->chip->eoi(desc);
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
+	desc->chip->eoi(desc);
 }
 
 #endif /* CONFIG_CPM2 */
Index: linux-2.6/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
+++ linux-2.6/arch/powerpc/platforms/85xx/socrates_fpga_pic.c
@@ -103,12 +103,13 @@ void socrates_fpga_pic_cascade(unsigned
 
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 
 }
 
-static void socrates_fpga_pic_ack(unsigned int virq)
+static void socrates_fpga_pic_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq, irq_line;
 	uint32_t mask;
@@ -124,8 +125,9 @@ static void socrates_fpga_pic_ack(unsign
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_mask(unsigned int virq)
+static void socrates_fpga_pic_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq;
 	int irq_line;
@@ -142,8 +144,9 @@ static void socrates_fpga_pic_mask(unsig
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_mask_ack(unsigned int virq)
+static void socrates_fpga_pic_mask_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq;
 	int irq_line;
@@ -161,8 +164,9 @@ static void socrates_fpga_pic_mask_ack(u
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_unmask(unsigned int virq)
+static void socrates_fpga_pic_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq;
 	int irq_line;
@@ -179,8 +183,9 @@ static void socrates_fpga_pic_unmask(uns
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static void socrates_fpga_pic_eoi(unsigned int virq)
+static void socrates_fpga_pic_eoi(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq;
 	int irq_line;
@@ -197,9 +202,10 @@ static void socrates_fpga_pic_eoi(unsign
 	spin_unlock_irqrestore(&socrates_fpga_pic_lock, flags);
 }
 
-static int socrates_fpga_pic_set_type(unsigned int virq,
+static int socrates_fpga_pic_set_type(struct irq_desc *desc,
 		unsigned int flow_type)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq;
 	int polarity;
Index: linux-2.6/arch/powerpc/platforms/85xx/stx_gp3.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/85xx/stx_gp3.c
+++ linux-2.6/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -51,7 +51,7 @@ static void cpm2_cascade(unsigned int ir
 	while ((cascade_irq = cpm2_get_irq()) >= 0)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
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
+	desc->chip->eoi(desc);
 }
 #endif /* CONFIG_CPM2 */
 
Index: linux-2.6/arch/powerpc/platforms/86xx/gef_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/86xx/gef_pic.c
+++ linux-2.6/arch/powerpc/platforms/86xx/gef_pic.c
@@ -106,12 +106,13 @@ void gef_pic_cascade(unsigned int irq, s
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
 
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 
 }
 
-static void gef_pic_mask(unsigned int virq)
+static void gef_pic_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq;
 	u32 mask;
@@ -125,16 +126,18 @@ static void gef_pic_mask(unsigned int vi
 	spin_unlock_irqrestore(&gef_pic_lock, flags);
 }
 
-static void gef_pic_mask_ack(unsigned int virq)
+static void gef_pic_mask_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	/* Don't think we actually have to do anything to ack an interrupt,
 	 * we just need to clear down the devices interrupt and it will go away
 	 */
 	gef_pic_mask(virq);
 }
 
-static void gef_pic_unmask(unsigned int virq)
+static void gef_pic_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int hwirq;
 	u32 mask;
Index: linux-2.6/arch/powerpc/platforms/86xx/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/86xx/pic.c
+++ linux-2.6/arch/powerpc/platforms/86xx/pic.c
@@ -22,7 +22,7 @@ static void mpc86xx_8259_cascade(unsigne
 	unsigned int cascade_irq = i8259_irq();
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
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
+		cdesc->chip->eoi(cdesc);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
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
+	desc->chip->eoi(desc);
 }
 
 static struct axon_msic *find_msi_translator(struct pci_dev *dev)
@@ -308,10 +308,15 @@ static void axon_msi_teardown_msi_irqs(s
 	}
 }
 
+static void axon_unmask_msi_irq(struct irq_desc *desc)
+{
+	unmask_msi_irq(desc);
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
@@ -61,8 +61,9 @@ static inline void beatic_update_irq_mas
 		panic("Failed to set mask IRQ!");
 }
 
-static void beatic_mask_irq(unsigned int irq_plug)
+static void beatic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq_plug = desc->irq;
 	unsigned long flags;
 
 	spin_lock_irqsave(&beatic_irq_mask_lock, flags);
@@ -71,8 +72,9 @@ static void beatic_mask_irq(unsigned int
 	spin_unlock_irqrestore(&beatic_irq_mask_lock, flags);
 }
 
-static void beatic_unmask_irq(unsigned int irq_plug)
+static void beatic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq_plug = desc->irq;
 	unsigned long flags;
 
 	spin_lock_irqsave(&beatic_irq_mask_lock, flags);
@@ -81,8 +83,9 @@ static void beatic_unmask_irq(unsigned i
 	spin_unlock_irqrestore(&beatic_irq_mask_lock, flags);
 }
 
-static void beatic_ack_irq(unsigned int irq_plug)
+static void beatic_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq_plug = desc->irq;
 	unsigned long flags;
 
 	spin_lock_irqsave(&beatic_irq_mask_lock, flags);
@@ -91,8 +94,9 @@ static void beatic_ack_irq(unsigned int
 	spin_unlock_irqrestore(&beatic_irq_mask_lock, flags);
 }
 
-static void beatic_end_irq(unsigned int irq_plug)
+static void beatic_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq_plug = desc->irq;
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
+static void iic_mask(struct irq_desc *desc)
 {
 }
 
-static void iic_unmask(unsigned int irq)
+static void iic_unmask(struct irq_desc *desc)
 {
 }
 
-static void iic_eoi(unsigned int irq)
+static void iic_eoi(struct irq_desc *desc)
 {
 	struct iic *iic = &__get_cpu_var(cpu_iic);
 	out_be64(&iic->regs->prio, iic->eoi_stack[--iic->eoi_ptr]);
@@ -95,7 +95,7 @@ static struct irq_chip iic_chip = {
 };
 
 
-static void iic_ioexc_eoi(unsigned int irq)
+static void iic_ioexc_eoi(struct irq_desc *desc)
 {
 }
 
@@ -128,7 +128,7 @@ static void iic_ioexc_cascade(unsigned i
 		if (ack)
 			out_be64(&node_iic->iic_is, ack);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
 
 
@@ -275,7 +275,7 @@ static void handle_iic_irq(unsigned int
 
 	desc->status &= ~IRQ_INPROGRESS;
 out_eoi:
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
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
+	desc->chip->eoi(desc);
 }
 
 static void __init mpic_init_IRQ(void)
Index: linux-2.6/arch/powerpc/platforms/cell/spider-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spider-pic.c
+++ linux-2.6/arch/powerpc/platforms/cell/spider-pic.c
@@ -79,24 +79,27 @@ static void __iomem *spider_get_irq_conf
 	return pic->regs + TIR_CFGA + 8 * src;
 }
 
-static void spider_unmask_irq(unsigned int virq)
+static void spider_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct spider_pic *pic = spider_virq_to_pic(virq);
 	void __iomem *cfg = spider_get_irq_config(pic, irq_map[virq].hwirq);
 
 	out_be32(cfg, in_be32(cfg) | 0x30000000u);
 }
 
-static void spider_mask_irq(unsigned int virq)
+static void spider_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct spider_pic *pic = spider_virq_to_pic(virq);
 	void __iomem *cfg = spider_get_irq_config(pic, irq_map[virq].hwirq);
 
 	out_be32(cfg, in_be32(cfg) & ~0x30000000u);
 }
 
-static void spider_ack_irq(unsigned int virq)
+static void spider_ack_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct spider_pic *pic = spider_virq_to_pic(virq);
 	unsigned int src = irq_map[virq].hwirq;
 
@@ -113,13 +116,13 @@ static void spider_ack_irq(unsigned int
 	out_be32(pic->regs + TIR_EDC, 0x100 | (src & 0xf));
 }
 
-static int spider_set_irq_type(unsigned int virq, unsigned int type)
+static int spider_set_irq_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int virq = desc->irq;
 	unsigned int sense = type & IRQ_TYPE_SENSE_MASK;
 	struct spider_pic *pic = spider_virq_to_pic(virq);
 	unsigned int hw = irq_map[virq].hwirq;
 	void __iomem *cfg = spider_get_irq_config(pic, hw);
-	struct irq_desc *desc = irq_to_desc(virq);
 	u32 old_mask;
 	u32 ic;
 
@@ -217,7 +220,7 @@ static void spider_irq_cascade(unsigned
 		virq = irq_linear_revmap(pic->host, cs);
 	if (virq != NO_IRQ)
 		generic_handle_irq(virq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
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
+	desc->chip->eoi(desc);
 }
 
 /*
Index: linux-2.6/arch/powerpc/platforms/embedded6xx/flipper-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/embedded6xx/flipper-pic.c
+++ linux-2.6/arch/powerpc/platforms/embedded6xx/flipper-pic.c
@@ -46,8 +46,9 @@
  *
  */
 
-static void flipper_pic_mask_and_ack(unsigned int virq)
+static void flipper_pic_mask_and_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
 	u32 mask = 1 << irq;
@@ -57,8 +58,9 @@ static void flipper_pic_mask_and_ack(uns
 	out_be32(io_base + FLIPPER_ICR, mask);
 }
 
-static void flipper_pic_ack(unsigned int virq)
+static void flipper_pic_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
 
@@ -66,16 +68,18 @@ static void flipper_pic_ack(unsigned int
 	out_be32(io_base + FLIPPER_ICR, 1 << irq);
 }
 
-static void flipper_pic_mask(unsigned int virq)
+static void flipper_pic_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
 
 	clrbits32(io_base + FLIPPER_IMR, 1 << irq);
 }
 
-static void flipper_pic_unmask(unsigned int virq)
+static void flipper_pic_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
 	void __iomem *io_base = get_irq_chip_data(virq);
 
Index: linux-2.6/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
+++ linux-2.6/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
@@ -41,36 +41,40 @@
  *
  */
 
-static void hlwd_pic_mask_and_ack(unsigned int virq)
+static void hlwd_pic_mask_and_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void __iomem *io_base = get_irq_chip_data(virq);
+	void __iomem *io_base = get_irq_desc_chip_data(desc);
 	u32 mask = 1 << irq;
 
 	clrbits32(io_base + HW_BROADWAY_IMR, mask);
 	out_be32(io_base + HW_BROADWAY_ICR, mask);
 }
 
-static void hlwd_pic_ack(unsigned int virq)
+static void hlwd_pic_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void __iomem *io_base = get_irq_chip_data(virq);
+	void __iomem *io_base = get_irq_desc_chip_data(desc);
 
 	out_be32(io_base + HW_BROADWAY_ICR, 1 << irq);
 }
 
-static void hlwd_pic_mask(unsigned int virq)
+static void hlwd_pic_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void __iomem *io_base = get_irq_chip_data(virq);
+	void __iomem *io_base = get_irq_desc_chip_data(desc);
 
 	clrbits32(io_base + HW_BROADWAY_IMR, 1 << irq);
 }
 
-static void hlwd_pic_unmask(unsigned int virq)
+static void hlwd_pic_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void __iomem *io_base = get_irq_chip_data(virq);
+	void __iomem *io_base = get_irq_desc_chip_data(desc);
 
 	setbits32(io_base + HW_BROADWAY_IMR, 1 << irq);
 }
@@ -133,7 +137,7 @@ static void hlwd_pic_irq_cascade(unsigne
 	unsigned int virq;
 
 	raw_spin_lock(&desc->lock);
-	desc->chip->mask(cascade_virq); /* IRQ_LEVEL */
+	desc->chip->mask(desc); /* IRQ_LEVEL */
 	raw_spin_unlock(&desc->lock);
 
 	virq = __hlwd_pic_get_irq(irq_host);
@@ -143,9 +147,9 @@ static void hlwd_pic_irq_cascade(unsigne
 		pr_err("spurious interrupt!\n");
 
 	raw_spin_lock(&desc->lock);
-	desc->chip->ack(cascade_virq); /* IRQ_LEVEL */
+	desc->chip->ack(desc); /* IRQ_LEVEL */
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(cascade_virq);
+		desc->chip->unmask(desc);
 	raw_spin_unlock(&desc->lock);
 }
 
Index: linux-2.6/arch/powerpc/platforms/iseries/irq.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/iseries/irq.c
+++ linux-2.6/arch/powerpc/platforms/iseries/irq.c
@@ -167,8 +167,9 @@ static void pci_event_handler(struct HvL
  * This will be called by device drivers (via enable_IRQ)
  * to enable INTA in the bridge interrupt status register.
  */
-static void iseries_enable_IRQ(unsigned int irq)
+static void iseries_enable_IRQ(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
 	unsigned int rirq = (unsigned int)irq_map[irq].hwirq;
@@ -184,8 +185,9 @@ static void iseries_enable_IRQ(unsigned
 }
 
 /* This is called by iseries_activate_IRQs */
-static unsigned int iseries_startup_IRQ(unsigned int irq)
+static unsigned int iseries_startup_IRQ(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
 	unsigned int rirq = (unsigned int)irq_map[irq].hwirq;
@@ -200,7 +202,7 @@ static unsigned int iseries_startup_IRQ(
 	/* Unmask bridge interrupts in the FISR */
 	mask = 0x01010000 << function;
 	HvCallPci_unmaskFisr(bus, sub_bus, dev_id, mask);
-	iseries_enable_IRQ(irq);
+	iseries_enable_IRQ(desc);
 	return 0;
 }
 
@@ -218,15 +220,16 @@ void __init iSeries_activate_IRQs()
 
 		if (desc && desc->chip && desc->chip->startup) {
 			raw_spin_lock_irqsave(&desc->lock, flags);
-			desc->chip->startup(irq);
+			desc->chip->startup(desc);
 			raw_spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
 }
 
 /*  this is not called anywhere currently */
-static void iseries_shutdown_IRQ(unsigned int irq)
+static void iseries_shutdown_IRQ(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
 	unsigned int rirq = (unsigned int)irq_map[irq].hwirq;
@@ -248,8 +251,9 @@ static void iseries_shutdown_IRQ(unsigne
  * This will be called by device drivers (via disable_IRQ)
  * to disable INTA in the bridge interrupt status register.
  */
-static void iseries_disable_IRQ(unsigned int irq)
+static void iseries_disable_IRQ(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u32 bus, dev_id, function, mask;
 	const u32 sub_bus = 0;
 	unsigned int rirq = (unsigned int)irq_map[irq].hwirq;
@@ -264,8 +268,9 @@ static void iseries_disable_IRQ(unsigned
 	HvCallPci_maskInterrupts(bus, sub_bus, dev_id, mask);
 }
 
-static void iseries_end_IRQ(unsigned int irq)
+static void iseries_end_IRQ(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int rirq = (unsigned int)irq_map[irq].hwirq;
 
 	HvCallPci_eoi(REAL_IRQ_TO_BUS(rirq), REAL_IRQ_TO_SUBBUS(rirq),
Index: linux-2.6/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6/arch/powerpc/platforms/powermac/pic.c
@@ -78,8 +78,9 @@ static void __pmac_retrigger(unsigned in
 	}
 }
 
-static void pmac_mask_and_ack_irq(unsigned int virq)
+static void pmac_mask_and_ack_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned int src = irq_map[virq].hwirq;
         unsigned long bit = 1UL << (src & 0x1f);
         int i = src >> 5;
@@ -100,8 +101,9 @@ static void pmac_mask_and_ack_irq(unsign
 	spin_unlock_irqrestore(&pmac_pic_lock, flags);
 }
 
-static void pmac_ack_irq(unsigned int virq)
+static void pmac_ack_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned int src = irq_map[virq].hwirq;
         unsigned long bit = 1UL << (src & 0x1f);
         int i = src >> 5;
@@ -145,8 +147,9 @@ static void __pmac_set_irq_mask(unsigned
 /* When an irq gets requested for the first client, if it's an
  * edge interrupt, we clear any previous one on the controller
  */
-static unsigned int pmac_startup_irq(unsigned int virq)
+static unsigned int pmac_startup_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int src = irq_map[virq].hwirq;
         unsigned long bit = 1UL << (src & 0x1f);
@@ -162,8 +165,9 @@ static unsigned int pmac_startup_irq(uns
 	return 0;
 }
 
-static void pmac_mask_irq(unsigned int virq)
+static void pmac_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int src = irq_map[virq].hwirq;
 
@@ -173,8 +177,9 @@ static void pmac_mask_irq(unsigned int v
   	spin_unlock_irqrestore(&pmac_pic_lock, flags);
 }
 
-static void pmac_unmask_irq(unsigned int virq)
+static void pmac_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 	unsigned int src = irq_map[virq].hwirq;
 
@@ -184,8 +189,9 @@ static void pmac_unmask_irq(unsigned int
   	spin_unlock_irqrestore(&pmac_pic_lock, flags);
 }
 
-static int pmac_retrigger(unsigned int virq)
+static int pmac_retrigger(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned long flags;
 
   	spin_lock_irqsave(&pmac_pic_lock, flags);
@@ -437,7 +443,7 @@ static void pmac_u3_cascade(unsigned int
 	unsigned int cascade_irq = mpic_get_one_irq(mpic);
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
 
 static void __init pmac_pic_setup_mpic_nmi(struct mpic *mpic)
Index: linux-2.6/arch/powerpc/platforms/ps3/interrupt.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/ps3/interrupt.c
+++ linux-2.6/arch/powerpc/platforms/ps3/interrupt.c
@@ -99,9 +99,10 @@ static DEFINE_PER_CPU(struct ps3_private
  * Sets ps3_bmp.mask and calls lv1_did_update_interrupt_mask().
  */
 
-static void ps3_chip_mask(unsigned int virq)
+static void ps3_chip_mask(struct irq_desc *desc)
 {
-	struct ps3_private *pd = get_irq_chip_data(virq);
+	unsigned int virq = desc->irq;
+	struct ps3_private *pd = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	pr_debug("%s:%d: thread_id %llu, virq %d\n", __func__, __LINE__,
@@ -120,9 +121,10 @@ static void ps3_chip_mask(unsigned int v
  * Clears ps3_bmp.mask and calls lv1_did_update_interrupt_mask().
  */
 
-static void ps3_chip_unmask(unsigned int virq)
+static void ps3_chip_unmask(struct irq_desc *desc)
 {
-	struct ps3_private *pd = get_irq_chip_data(virq);
+	unsigned int virq = desc->irq;
+	struct ps3_private *pd = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	pr_debug("%s:%d: thread_id %llu, virq %d\n", __func__, __LINE__,
@@ -141,9 +143,10 @@ static void ps3_chip_unmask(unsigned int
  * Calls lv1_end_of_interrupt_ext().
  */
 
-static void ps3_chip_eoi(unsigned int virq)
+static void ps3_chip_eoi(struct irq_desc *desc)
 {
-	const struct ps3_private *pd = get_irq_chip_data(virq);
+	unsigned int virq = desc->irq;
+	struct ps3_private *pd = get_irq_desc_chip_data(desc);
 	lv1_end_of_interrupt_ext(pd->ppe_id, pd->thread_id, virq);
 }
 
Index: linux-2.6/arch/powerpc/platforms/pseries/setup.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/setup.c
+++ linux-2.6/arch/powerpc/platforms/pseries/setup.c
@@ -118,7 +118,7 @@ static void pseries_8259_cascade(unsigne
 	unsigned int cascade_irq = i8259_irq();
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
 
 static void __init pseries_setup_i8259_cascade(void)
Index: linux-2.6/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6/arch/powerpc/platforms/pseries/xics.c
@@ -194,8 +194,9 @@ static int get_irq_server(unsigned int v
 #define get_irq_server(virq, cpumask, strict_check) (default_server)
 #endif
 
-static void xics_unmask_irq(unsigned int virq)
+static void xics_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned int irq;
 	int call_status;
 	int server;
@@ -227,18 +228,19 @@ static void xics_unmask_irq(unsigned int
 	}
 }
 
-static unsigned int xics_startup(unsigned int virq)
+static unsigned int xics_startup(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	/*
 	 * The generic MSI code returns with the interrupt disabled on the
 	 * card, using the MSI mask bits. Firmware doesn't appear to unmask
 	 * at that level, so we do it here by hand.
 	 */
-	if (irq_to_desc(virq)->msi_desc)
-		unmask_msi_irq(virq);
+	if (desc->msi_desc)
+		unmask_msi_irq(desc);
 
 	/* unmask it */
-	xics_unmask_irq(virq);
+	xics_unmask_irq(desc);
 	return 0;
 }
 
@@ -266,8 +268,9 @@ static void xics_mask_real_irq(unsigned
 	}
 }
 
-static void xics_mask_irq(unsigned int virq)
+static void xics_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned int irq;
 
 	pr_devel("xics: mask virq %d\n", virq);
@@ -362,24 +365,27 @@ static unsigned char pop_cppr(void)
 	return os_cppr->stack[--os_cppr->index];
 }
 
-static void xics_eoi_direct(unsigned int virq)
+static void xics_eoi_direct(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned int irq = (unsigned int)irq_map[virq].hwirq;
 
 	iosync();
 	direct_xirr_info_set((pop_cppr() << 24) | irq);
 }
 
-static void xics_eoi_lpar(unsigned int virq)
+static void xics_eoi_lpar(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	unsigned int irq = (unsigned int)irq_map[virq].hwirq;
 
 	iosync();
 	lpar_xirr_info_set((pop_cppr() << 24) | irq);
 }
 
-static int xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
+static int xics_set_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
 {
+	unsigned int virq = desc->irq;
 	unsigned int irq;
 	int status;
 	int xics_status[2];
@@ -933,8 +939,8 @@ void xics_migrate_irqs_away(void)
 		       virq, cpu);
 
 		/* Reset affinity to all cpus */
-		cpumask_setall(irq_to_desc(virq)->affinity);
-		desc->chip->set_affinity(virq, cpu_all_mask);
+		cpumask_setall(desc->affinity);
+		desc->chip->set_affinity(desc, cpu_all_mask);
 unlock:
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
Index: linux-2.6/arch/powerpc/sysdev/cpm1.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/cpm1.c
+++ linux-2.6/arch/powerpc/sysdev/cpm1.c
@@ -55,22 +55,25 @@ static cpic8xx_t __iomem *cpic_reg;
 
 static struct irq_host *cpm_pic_host;
 
-static void cpm_mask_irq(unsigned int irq)
+static void cpm_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int cpm_vec = (unsigned int)irq_map[irq].hwirq;
 
 	clrbits32(&cpic_reg->cpic_cimr, (1 << cpm_vec));
 }
 
-static void cpm_unmask_irq(unsigned int irq)
+static void cpm_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int cpm_vec = (unsigned int)irq_map[irq].hwirq;
 
 	setbits32(&cpic_reg->cpic_cimr, (1 << cpm_vec));
 }
 
-static void cpm_end_irq(unsigned int irq)
+static void cpm_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int cpm_vec = (unsigned int)irq_map[irq].hwirq;
 
 	out_be32(&cpic_reg->cpic_cisr, (1 << cpm_vec));
Index: linux-2.6/arch/powerpc/sysdev/cpm2_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/cpm2_pic.c
+++ linux-2.6/arch/powerpc/sysdev/cpm2_pic.c
@@ -78,8 +78,9 @@ static const u_char irq_to_siubit[] = {
 	24, 25, 26, 27, 28, 29, 30, 31,
 };
 
-static void cpm2_mask_irq(unsigned int virq)
+static void cpm2_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
 
@@ -90,8 +91,9 @@ static void cpm2_mask_irq(unsigned int v
 	out_be32(&cpm2_intctl->ic_simrh + word, ppc_cached_irq_mask[word]);
 }
 
-static void cpm2_unmask_irq(unsigned int virq)
+static void cpm2_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
 
@@ -102,8 +104,9 @@ static void cpm2_unmask_irq(unsigned int
 	out_be32(&cpm2_intctl->ic_simrh + word, ppc_cached_irq_mask[word]);
 }
 
-static void cpm2_ack(unsigned int virq)
+static void cpm2_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
 
@@ -113,13 +116,12 @@ static void cpm2_ack(unsigned int virq)
 	out_be32(&cpm2_intctl->ic_sipnrh + word, 1 << bit);
 }
 
-static void cpm2_end_irq(unsigned int virq)
+static void cpm2_end_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc;
+	unsigned int virq = desc->irq;
 	int	bit, word;
 	unsigned int irq_nr = virq_to_hw(virq);
 
-	desc = irq_to_desc(irq_nr);
 	if (!(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS))
 			&& desc->action) {
 
@@ -137,10 +139,10 @@ static void cpm2_end_irq(unsigned int vi
 	}
 }
 
-static int cpm2_set_irq_type(unsigned int virq, unsigned int flow_type)
+static int cpm2_set_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int virq = desc->irq;
 	unsigned int src = virq_to_hw(virq);
-	struct irq_desc *desc = irq_to_desc(virq);
 	unsigned int vold, vnew, edibit;
 
 	/* Port C interrupts are either IRQ_TYPE_EDGE_FALLING or
Index: linux-2.6/arch/powerpc/sysdev/fsl_msi.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/fsl_msi.c
+++ linux-2.6/arch/powerpc/sysdev/fsl_msi.c
@@ -39,7 +39,7 @@ static inline u32 fsl_msi_read(u32 __iom
  * We do not need this actually. The MSIR register has been read once
  * in the cascade interrupt. So, this MSI interrupt has been acked
 */
-static void fsl_msi_end_irq(unsigned int virq)
+static void fsl_msi_end_irq(struct irq_desc *desc)
 {
 }
 
@@ -176,10 +176,10 @@ static void fsl_msi_cascade(unsigned int
 	raw_spin_lock(&desc->lock);
 	if ((msi_data->feature &  FSL_PIC_IP_MASK) == FSL_PIC_IP_IPIC) {
 		if (desc->chip->mask_ack)
-			desc->chip->mask_ack(irq);
+			desc->chip->mask_ack(desc);
 		else {
-			desc->chip->mask(irq);
-			desc->chip->ack(irq);
+			desc->chip->mask(desc);
+			desc->chip->ack(desc);
 		}
 	}
 
@@ -217,11 +217,11 @@ static void fsl_msi_cascade(unsigned int
 
 	switch (msi_data->feature & FSL_PIC_IP_MASK) {
 	case FSL_PIC_IP_MPIC:
-		desc->chip->eoi(irq);
+		desc->chip->eoi(desc);
 		break;
 	case FSL_PIC_IP_IPIC:
 		if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-			desc->chip->unmask(irq);
+			desc->chip->unmask(desc);
 		break;
 	}
 unlock:
Index: linux-2.6/arch/powerpc/sysdev/i8259.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/i8259.c
+++ linux-2.6/arch/powerpc/sysdev/i8259.c
@@ -78,19 +78,20 @@ unsigned int i8259_irq(void)
 	return irq;
 }
 
-static void i8259_mask_and_ack_irq(unsigned int irq_nr)
+static void i8259_mask_and_ack_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 
 	spin_lock_irqsave(&i8259_lock, flags);
-	if (irq_nr > 7) {
-		cached_A1 |= 1 << (irq_nr-8);
+	if (irq > 7) {
+		cached_A1 |= 1 << (irq-8);
 		inb(0xA1); 	/* DUMMY */
 		outb(cached_A1, 0xA1);
 		outb(0x20, 0xA0);	/* Non-specific EOI */
 		outb(0x20, 0x20);	/* Non-specific EOI to cascade */
 	} else {
-		cached_21 |= 1 << irq_nr;
+		cached_21 |= 1 << irq;
 		inb(0x21); 	/* DUMMY */
 		outb(cached_21, 0x21);
 		outb(0x20, 0x20);	/* Non-specific EOI */
@@ -104,33 +105,35 @@ static void i8259_set_irq_mask(int irq_n
 	outb(cached_21,0x21);
 }
 
-static void i8259_mask_irq(unsigned int irq_nr)
+static void i8259_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 
-	pr_debug("i8259_mask_irq(%d)\n", irq_nr);
+	pr_debug("i8259_mask_irq(%d)\n", irq);
 
 	spin_lock_irqsave(&i8259_lock, flags);
-	if (irq_nr < 8)
-		cached_21 |= 1 << irq_nr;
+	if (irq < 8)
+		cached_21 |= 1 << irq;
 	else
-		cached_A1 |= 1 << (irq_nr-8);
-	i8259_set_irq_mask(irq_nr);
+		cached_A1 |= 1 << (irq-8);
+	i8259_set_irq_mask(irq);
 	spin_unlock_irqrestore(&i8259_lock, flags);
 }
 
-static void i8259_unmask_irq(unsigned int irq_nr)
+static void i8259_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 
-	pr_debug("i8259_unmask_irq(%d)\n", irq_nr);
+	pr_debug("i8259_unmask_irq(%d)\n", irq);
 
 	spin_lock_irqsave(&i8259_lock, flags);
-	if (irq_nr < 8)
-		cached_21 &= ~(1 << irq_nr);
+	if (irq < 8)
+		cached_21 &= ~(1 << irq);
 	else
-		cached_A1 &= ~(1 << (irq_nr-8));
-	i8259_set_irq_mask(irq_nr);
+		cached_A1 &= ~(1 << (irq-8));
+	i8259_set_irq_mask(irq);
 	spin_unlock_irqrestore(&i8259_lock, flags);
 }
 
Index: linux-2.6/arch/powerpc/sysdev/ipic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/ipic.c
+++ linux-2.6/arch/powerpc/sysdev/ipic.c
@@ -523,8 +523,9 @@ static inline struct ipic * ipic_from_ir
 
 #define ipic_irq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
 
-static void ipic_unmask_irq(unsigned int virq)
+static void ipic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
 	unsigned long flags;
@@ -539,8 +540,9 @@ static void ipic_unmask_irq(unsigned int
 	spin_unlock_irqrestore(&ipic_lock, flags);
 }
 
-static void ipic_mask_irq(unsigned int virq)
+static void ipic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
 	unsigned long flags;
@@ -559,8 +561,9 @@ static void ipic_mask_irq(unsigned int v
 	spin_unlock_irqrestore(&ipic_lock, flags);
 }
 
-static void ipic_ack_irq(unsigned int virq)
+static void ipic_ack_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
 	unsigned long flags;
@@ -578,8 +581,9 @@ static void ipic_ack_irq(unsigned int vi
 	spin_unlock_irqrestore(&ipic_lock, flags);
 }
 
-static void ipic_mask_irq_and_ack(unsigned int virq)
+static void ipic_mask_irq_and_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
 	unsigned long flags;
@@ -601,8 +605,9 @@ static void ipic_mask_irq_and_ack(unsign
 	spin_unlock_irqrestore(&ipic_lock, flags);
 }
 
-static int ipic_set_irq_type(unsigned int virq, unsigned int flow_type)
+static int ipic_set_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int virq = desc->irq;
 	struct ipic *ipic = ipic_from_irq(virq);
 	unsigned int src = ipic_irq_to_hw(virq);
 	struct irq_desc *desc = irq_to_desc(virq);
Index: linux-2.6/arch/powerpc/sysdev/mpc8xx_pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpc8xx_pic.c
+++ linux-2.6/arch/powerpc/sysdev/mpc8xx_pic.c
@@ -25,8 +25,9 @@ static sysconf8xx_t __iomem *siu_reg;
 
 int cpm_get_irq(struct pt_regs *regs);
 
-static void mpc8xx_unmask_irq(unsigned int virq)
+static void mpc8xx_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int	bit, word;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
 
@@ -37,8 +38,9 @@ static void mpc8xx_unmask_irq(unsigned i
 	out_be32(&siu_reg->sc_simask, ppc_cached_irq_mask[word]);
 }
 
-static void mpc8xx_mask_irq(unsigned int virq)
+static void mpc8xx_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int	bit, word;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
 
@@ -49,8 +51,9 @@ static void mpc8xx_mask_irq(unsigned int
 	out_be32(&siu_reg->sc_simask, ppc_cached_irq_mask[word]);
 }
 
-static void mpc8xx_ack(unsigned int virq)
+static void mpc8xx_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int	bit;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
 
@@ -58,8 +61,9 @@ static void mpc8xx_ack(unsigned int virq
 	out_be32(&siu_reg->sc_sipend, 1 << (31-bit));
 }
 
-static void mpc8xx_end_irq(unsigned int virq)
+static void mpc8xx_end_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int bit, word;
 	unsigned int irq_nr = (unsigned int)irq_map[virq].hwirq;
 
@@ -70,9 +74,9 @@ static void mpc8xx_end_irq(unsigned int
 	out_be32(&siu_reg->sc_simask, ppc_cached_irq_mask[word]);
 }
 
-static int mpc8xx_set_irq_type(unsigned int virq, unsigned int flow_type)
+static int mpc8xx_set_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
-	struct irq_desc *desc = irq_to_desc(virq);
+	unsigned int virq = desc->irq;
 
 	desc->status &= ~(IRQ_TYPE_SENSE_MASK | IRQ_LEVEL);
 	desc->status |= flow_type & IRQ_TYPE_SENSE_MASK;
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -663,8 +663,9 @@ static inline void mpic_eoi(struct mpic
  */
 
 
-void mpic_unmask_irq(unsigned int irq)
+void mpic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int loops = 100000;
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -683,8 +684,9 @@ void mpic_unmask_irq(unsigned int irq)
 	} while(mpic_irq_read(src, MPIC_INFO(IRQ_VECTOR_PRI)) & MPIC_VECPRI_MASK);
 }
 
-void mpic_mask_irq(unsigned int irq)
+void mpic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int loops = 100000;
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -704,8 +706,9 @@ void mpic_mask_irq(unsigned int irq)
 	} while(!(mpic_irq_read(src, MPIC_INFO(IRQ_VECTOR_PRI)) & MPIC_VECPRI_MASK));
 }
 
-void mpic_end_irq(unsigned int irq)
+void mpic_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_irq(irq);
 
 #ifdef DEBUG_IRQ
@@ -721,8 +724,9 @@ void mpic_end_irq(unsigned int irq)
 
 #ifdef CONFIG_MPIC_U3_HT_IRQS
 
-static void mpic_unmask_ht_irq(unsigned int irq)
+static void mpic_unmask_ht_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
@@ -732,8 +736,9 @@ static void mpic_unmask_ht_irq(unsigned
 		mpic_ht_end_irq(mpic, src);
 }
 
-static unsigned int mpic_startup_ht_irq(unsigned int irq)
+static unsigned int mpic_startup_ht_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
@@ -743,8 +748,9 @@ static unsigned int mpic_startup_ht_irq(
 	return 0;
 }
 
-static void mpic_shutdown_ht_irq(unsigned int irq)
+static void mpic_shutdown_ht_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
@@ -752,8 +758,9 @@ static void mpic_shutdown_ht_irq(unsigne
 	mpic_mask_irq(irq);
 }
 
-static void mpic_end_ht_irq(unsigned int irq)
+static void mpic_end_ht_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
@@ -773,8 +780,9 @@ static void mpic_end_ht_irq(unsigned int
 
 #ifdef CONFIG_SMP
 
-static void mpic_unmask_ipi(unsigned int irq)
+static void mpic_unmask_ipi(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_ipi(irq);
 	unsigned int src = mpic_irq_to_hw(irq) - mpic->ipi_vecs[0];
 
@@ -782,13 +790,14 @@ static void mpic_unmask_ipi(unsigned int
 	mpic_ipi_write(src, mpic_ipi_read(src) & ~MPIC_VECPRI_MASK);
 }
 
-static void mpic_mask_ipi(unsigned int irq)
+static void mpic_mask_ipi(struct irq_desc *desc)
 {
 	/* NEVER disable an IPI... that's just plain wrong! */
 }
 
-static void mpic_end_ipi(unsigned int irq)
+static void mpic_end_ipi(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_ipi(irq);
 
 	/*
@@ -803,8 +812,9 @@ static void mpic_end_ipi(unsigned int ir
 
 #endif /* CONFIG_SMP */
 
-int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+int mpic_set_affinity(struct irq_desc *desc, const struct cpumask *cpumask)
 {
+	unsigned int irq = desc->irq;
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
 
@@ -845,8 +855,9 @@ static unsigned int mpic_type_to_vecpri(
 	}
 }
 
-int mpic_set_irq_type(unsigned int virq, unsigned int flow_type)
+int mpic_set_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
+	unsigned int virq = desc->irq;
 	struct mpic *mpic = mpic_from_irq(virq);
 	unsigned int src = mpic_irq_to_hw(virq);
 	struct irq_desc *desc = irq_to_desc(virq);
Index: linux-2.6/arch/powerpc/sysdev/mpic.h
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.h
+++ linux-2.6/arch/powerpc/sysdev/mpic.h
@@ -34,8 +34,8 @@ static inline int mpic_pasemi_msi_init(s
 }
 #endif
 
-extern int mpic_set_irq_type(unsigned int virq, unsigned int flow_type);
+extern int mpic_set_irq_type(struct irq_desc *desc, unsigned int flow_type);
 extern void mpic_set_vector(unsigned int virq, unsigned int vector);
-extern int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+extern int mpic_set_affinity(struct irq_desc *desc, const struct cpumask *cpumask);
 
 #endif /* _POWERPC_SYSDEV_MPIC_H */
Index: linux-2.6/arch/powerpc/sysdev/mpic_pasemi_msi.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ linux-2.6/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -39,18 +39,20 @@
 static struct mpic *msi_mpic;
 
 
-static void mpic_pasemi_msi_mask_irq(unsigned int irq)
+static void mpic_pasemi_msi_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	pr_debug("mpic_pasemi_msi_mask_irq %d\n", irq);
-	mask_msi_irq(irq);
-	mpic_mask_irq(irq);
+	mask_msi_irq(desc);
+	mpic_mask_irq(desc);
 }
 
-static void mpic_pasemi_msi_unmask_irq(unsigned int irq)
+static void mpic_pasemi_msi_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	pr_debug("mpic_pasemi_msi_unmask_irq %d\n", irq);
-	mpic_unmask_irq(irq);
-	unmask_msi_irq(irq);
+	mpic_unmask_irq(desc);
+	unmask_msi_irq(desc);
 }
 
 static struct irq_chip mpic_pasemi_msi_chip = {
Index: linux-2.6/arch/powerpc/sysdev/mpic_u3msi.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic_u3msi.c
+++ linux-2.6/arch/powerpc/sysdev/mpic_u3msi.c
@@ -23,20 +23,25 @@
 /* A bit ugly, can we get this from the pci_dev somehow? */
 static struct mpic *msi_mpic;
 
-static void mpic_u3msi_mask_irq(unsigned int irq)
+static void mpic_u3msi_mask_irq(struct irq_desc *desc)
 {
-	mask_msi_irq(irq);
-	mpic_mask_irq(irq);
+	mask_msi_irq(desc);
+	mpic_mask_irq(desc);
 }
 
-static void mpic_u3msi_unmask_irq(unsigned int irq)
+static void mpic_u3msi_shutdown_irq(struct irq_desc *desc)
 {
-	mpic_unmask_irq(irq);
-	unmask_msi_irq(irq);
+	mpic_u3msi_mask_irq(desc);
+}
+
+static void mpic_u3msi_unmask_irq(struct irq_desc *desc)
+{
+	mpic_unmask_irq(desc);
+	unmask_msi_irq(desc);
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
@@ -76,8 +76,9 @@ static struct irq_host *mv64x60_irq_host
  * mv64x60_chip_low functions
  */
 
-static void mv64x60_mask_low(unsigned int virq)
+static void mv64x60_mask_low(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
@@ -89,8 +90,9 @@ static void mv64x60_mask_low(unsigned in
 	(void)in_le32(mv64x60_irq_reg_base + MV64X60_IC_CPU0_INTR_MASK_LO);
 }
 
-static void mv64x60_unmask_low(unsigned int virq)
+static void mv64x60_unmask_low(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
@@ -113,8 +115,9 @@ static struct irq_chip mv64x60_chip_low
  * mv64x60_chip_high functions
  */
 
-static void mv64x60_mask_high(unsigned int virq)
+static void mv64x60_mask_high(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
@@ -126,8 +129,9 @@ static void mv64x60_mask_high(unsigned i
 	(void)in_le32(mv64x60_irq_reg_base + MV64X60_IC_CPU0_INTR_MASK_HI);
 }
 
-static void mv64x60_unmask_high(unsigned int virq)
+static void mv64x60_unmask_high(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
@@ -150,8 +154,9 @@ static struct irq_chip mv64x60_chip_high
  * mv64x60_chip_gpp functions
  */
 
-static void mv64x60_mask_gpp(unsigned int virq)
+static void mv64x60_mask_gpp(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
@@ -163,8 +168,9 @@ static void mv64x60_mask_gpp(unsigned in
 	(void)in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_INTR_MASK);
 }
 
-static void mv64x60_mask_ack_gpp(unsigned int virq)
+static void mv64x60_mask_ack_gpp(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
@@ -178,8 +184,9 @@ static void mv64x60_mask_ack_gpp(unsigne
 	(void)in_le32(mv64x60_gpp_reg_base + MV64x60_GPP_INTR_CAUSE);
 }
 
-static void mv64x60_unmask_gpp(unsigned int virq)
+static void mv64x60_unmask_gpp(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int level2 = irq_map[virq].hwirq & MV64x60_LEVEL2_MASK;
 	unsigned long flags;
 
Index: linux-2.6/arch/powerpc/sysdev/qe_lib/qe_ic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/qe_lib/qe_ic.c
+++ linux-2.6/arch/powerpc/sysdev/qe_lib/qe_ic.c
@@ -194,8 +194,9 @@ static inline struct qe_ic *qe_ic_from_i
 
 #define virq_to_hw(virq)	((unsigned int)irq_map[virq].hwirq)
 
-static void qe_ic_unmask_irq(unsigned int virq)
+static void qe_ic_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct qe_ic *qe_ic = qe_ic_from_irq(virq);
 	unsigned int src = virq_to_hw(virq);
 	unsigned long flags;
@@ -210,8 +211,9 @@ static void qe_ic_unmask_irq(unsigned in
 	spin_unlock_irqrestore(&qe_ic_lock, flags);
 }
 
-static void qe_ic_mask_irq(unsigned int virq)
+static void qe_ic_mask_irq(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	struct qe_ic *qe_ic = qe_ic_from_irq(virq);
 	unsigned int src = virq_to_hw(virq);
 	unsigned long flags;
Index: linux-2.6/arch/powerpc/sysdev/tsi108_pci.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/tsi108_pci.c
+++ linux-2.6/arch/powerpc/sysdev/tsi108_pci.c
@@ -344,23 +344,27 @@ static inline unsigned int get_pci_sourc
  * Linux descriptor level callbacks
  */
 
-static void tsi108_pci_irq_enable(u_int irq)
+static void tsi108_pci_irq_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	tsi108_pci_int_unmask(irq);
 }
 
-static void tsi108_pci_irq_disable(u_int irq)
+static void tsi108_pci_irq_disable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	tsi108_pci_int_mask(irq);
 }
 
-static void tsi108_pci_irq_ack(u_int irq)
+static void tsi108_pci_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	tsi108_pci_int_mask(irq);
 }
 
-static void tsi108_pci_irq_end(u_int irq)
+static void tsi108_pci_irq_end(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	tsi108_pci_int_unmask(irq);
 
 	/* Enable interrupts from PCI block */
@@ -441,5 +445,5 @@ void tsi108_irq_cascade(unsigned int irq
 	unsigned int cascade_irq = get_pci_source();
 	if (cascade_irq != NO_IRQ)
 		generic_handle_irq(cascade_irq);
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
Index: linux-2.6/arch/powerpc/sysdev/uic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/uic.c
+++ linux-2.6/arch/powerpc/sysdev/uic.c
@@ -55,10 +55,10 @@ struct uic {
 	struct irq_host	*irqhost;
 };
 
-static void uic_unmask_irq(unsigned int virq)
+static void uic_unmask_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(virq);
-	struct uic *uic = get_irq_chip_data(virq);
+	unsigned int virq = des->irq;
+	struct uic *uic = get_irq_desc_chip_data(desc);
 	unsigned int src = uic_irq_to_hw(virq);
 	unsigned long flags;
 	u32 er, sr;
@@ -74,9 +74,10 @@ static void uic_unmask_irq(unsigned int
 	spin_unlock_irqrestore(&uic->lock, flags);
 }
 
-static void uic_mask_irq(unsigned int virq)
+static void uic_mask_irq(struct irq_desc *desc)
 {
-	struct uic *uic = get_irq_chip_data(virq);
+	unsigned int virq = des->irq;
+	struct uic *uic = get_irq_desc_chip_data(desc);
 	unsigned int src = uic_irq_to_hw(virq);
 	unsigned long flags;
 	u32 er;
@@ -88,9 +89,10 @@ static void uic_mask_irq(unsigned int vi
 	spin_unlock_irqrestore(&uic->lock, flags);
 }
 
-static void uic_ack_irq(unsigned int virq)
+static void uic_ack_irq(struct irq_desc *desc)
 {
-	struct uic *uic = get_irq_chip_data(virq);
+	unsigned int virq = des->irq;
+	struct uic *uic = get_irq_desc_chip_data(desc);
 	unsigned int src = uic_irq_to_hw(virq);
 	unsigned long flags;
 
@@ -99,10 +101,10 @@ static void uic_ack_irq(unsigned int vir
 	spin_unlock_irqrestore(&uic->lock, flags);
 }
 
-static void uic_mask_ack_irq(unsigned int virq)
+static void uic_mask_ack_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(virq);
-	struct uic *uic = get_irq_chip_data(virq);
+	unsigned int virq = des->irq;
+	struct uic *uic = get_irq_desc_chip_data(desc);
 	unsigned int src = uic_irq_to_hw(virq);
 	unsigned long flags;
 	u32 er, sr;
@@ -125,11 +127,11 @@ static void uic_mask_ack_irq(unsigned in
 	spin_unlock_irqrestore(&uic->lock, flags);
 }
 
-static int uic_set_irq_type(unsigned int virq, unsigned int flow_type)
+static int uic_set_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
-	struct uic *uic = get_irq_chip_data(virq);
+	unsigned int virq = des->irq;
+	struct uic *uic = get_irq_desc_chip_data(desc);
 	unsigned int src = uic_irq_to_hw(virq);
-	struct irq_desc *desc = irq_to_desc(virq);
 	unsigned long flags;
 	int trigger, polarity;
 	u32 tr, pr, mask;
@@ -227,9 +229,9 @@ void uic_irq_cascade(unsigned int virq,
 
 	raw_spin_lock(&desc->lock);
 	if (desc->status & IRQ_LEVEL)
-		desc->chip->mask(virq);
+		desc->chip->mask(desc);
 	else
-		desc->chip->mask_ack(virq);
+		desc->chip->mask_ack(desc);
 	raw_spin_unlock(&desc->lock);
 
 	msr = mfdcr(uic->dcrbase + UIC_MSR);
@@ -244,9 +246,9 @@ void uic_irq_cascade(unsigned int virq,
 uic_irq_ret:
 	raw_spin_lock(&desc->lock);
 	if (desc->status & IRQ_LEVEL)
-		desc->chip->ack(virq);
+		desc->chip->ack(desc);
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(virq);
+		desc->chip->unmask(desc);
 	raw_spin_unlock(&desc->lock);
 }
 
Index: linux-2.6/arch/powerpc/sysdev/xilinx_intc.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/xilinx_intc.c
+++ linux-2.6/arch/powerpc/sysdev/xilinx_intc.c
@@ -69,17 +69,18 @@ static unsigned char xilinx_intc_map_sen
  *
  * IRQ Chip common (across level and edge) operations
  */
-static void xilinx_intc_mask(unsigned int virq)
+static void xilinx_intc_mask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void * regs = get_irq_chip_data(virq);
+	void *regs = get_irq_desc_chip_data(desc);
 	pr_debug("mask: %d\n", irq);
 	out_be32(regs + XINTC_CIE, 1 << irq);
 }
 
-static int xilinx_intc_set_type(unsigned int virq, unsigned int flow_type)
+static int xilinx_intc_set_type(struct irq_desc *desc, unsigned int flow_type)
 {
-	struct irq_desc *desc = irq_to_desc(virq);
+	unsigned int virq = desc->irq;
 
 	desc->status &= ~(IRQ_TYPE_SENSE_MASK | IRQ_LEVEL);
 	desc->status |= flow_type & IRQ_TYPE_SENSE_MASK;
@@ -91,10 +92,11 @@ static int xilinx_intc_set_type(unsigned
 /*
  * IRQ Chip level operations
  */
-static void xilinx_intc_level_unmask(unsigned int virq)
+static void xilinx_intc_level_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void * regs = get_irq_chip_data(virq);
+	void *regs = get_irq_desc_chip_data(desc);
 	pr_debug("unmask: %d\n", irq);
 	out_be32(regs + XINTC_SIE, 1 << irq);
 
@@ -116,18 +118,20 @@ static struct irq_chip xilinx_intc_level
 /*
  * IRQ Chip edge operations
  */
-static void xilinx_intc_edge_unmask(unsigned int virq)
+static void xilinx_intc_edge_unmask(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void *regs = get_irq_chip_data(virq);
+	void *regs = get_irq_desc_chip_data(desc);
 	pr_debug("unmask: %d\n", irq);
 	out_be32(regs + XINTC_SIE, 1 << irq);
 }
 
-static void xilinx_intc_edge_ack(unsigned int virq)
+static void xilinx_intc_edge_ack(struct irq_desc *desc)
 {
+	unsigned int virq = desc->irq;
 	int irq = virq_to_hw(virq);
-	void * regs = get_irq_chip_data(virq);
+	void *regs = get_irq_desc_chip_data(desc);
 	pr_debug("ack: %d\n", irq);
 	out_be32(regs + XINTC_IAR, 1 << irq);
 }
@@ -234,7 +238,7 @@ static void xilinx_i8259_cascade(unsigne
 		generic_handle_irq(cascade_irq);
 
 	/* Let xilinx_intc end the interrupt */
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static void __init xilinx_i8259_setup_cascade(void)
Index: linux-2.6/arch/score/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/score/kernel/irq.c
+++ linux-2.6/arch/score/kernel/irq.c
@@ -52,9 +52,10 @@ asmlinkage void do_IRQ(int irq)
 	irq_exit();
 }
 
-static void score_mask(unsigned int irq_nr)
+static void score_mask(struct irq_desc *desc)
 {
-	unsigned int irq_source = 63 - irq_nr;
+	unsigned int irq = desc->irq;
+	unsigned int irq_source = 63 - irq;
 
 	if (irq_source < 32)
 		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) | \
@@ -64,9 +65,10 @@ static void score_mask(unsigned int irq_
 			(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
 }
 
-static void score_unmask(unsigned int irq_nr)
+static void score_unmask(struct irq_desc *desc)
 {
-	unsigned int irq_source = 63 - irq_nr;
+	unsigned int irq = desc->irq;
+	unsigned int irq_source = 63 - irq;
 
 	if (irq_source < 32)
 		__raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) & \
Index: linux-2.6/arch/sh/boards/mach-cayman/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-cayman/irq.c
+++ linux-2.6/arch/sh/boards/mach-cayman/irq.c
@@ -55,8 +55,9 @@ static struct irqaction cayman_action_pc
 	.flags		= IRQF_DISABLED,
 };
 
-static void enable_cayman_irq(unsigned int irq)
+static void enable_cayman_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	unsigned long mask;
 	unsigned int reg;
@@ -72,8 +73,9 @@ static void enable_cayman_irq(unsigned i
 	local_irq_restore(flags);
 }
 
-void disable_cayman_irq(unsigned int irq)
+void disable_cayman_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	unsigned long mask;
 	unsigned int reg;
@@ -89,9 +91,9 @@ void disable_cayman_irq(unsigned int irq
 	local_irq_restore(flags);
 }
 
-static void ack_cayman_irq(unsigned int irq)
+static void ack_cayman_irq(struct irq_desc *desc)
 {
-	disable_cayman_irq(irq);
+	disable_cayman_irq(desc);
 }
 
 struct irq_chip cayman_irq_type = {
Index: linux-2.6/arch/sh/boards/mach-dreamcast/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-dreamcast/irq.c
+++ linux-2.6/arch/sh/boards/mach-dreamcast/irq.c
@@ -60,8 +60,9 @@
  */
 
 /* Disable the hardware event by masking its bit in its EMR */
-static inline void disable_systemasic_irq(unsigned int irq)
+static inline void disable_systemasic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__u32 emr = EMR_BASE + (LEVEL(irq) << 4) + (LEVEL(irq) << 2);
 	__u32 mask;
 
@@ -71,8 +72,9 @@ static inline void disable_systemasic_ir
 }
 
 /* Enable the hardware event by setting its bit in its EMR */
-static inline void enable_systemasic_irq(unsigned int irq)
+static inline void enable_systemasic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__u32 emr = EMR_BASE + (LEVEL(irq) << 4) + (LEVEL(irq) << 2);
 	__u32 mask;
 
@@ -82,8 +84,9 @@ static inline void enable_systemasic_irq
 }
 
 /* Acknowledge a hardware event by writing its bit back to its ESR */
-static void mask_ack_systemasic_irq(unsigned int irq)
+static void mask_ack_systemasic_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	__u32 esr = ESR_BASE + (LEVEL(irq) << 2);
 	disable_systemasic_irq(irq);
 	outl((1 << EVENT_BIT(irq)), esr);
Index: linux-2.6/arch/sh/boards/mach-landisk/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-landisk/irq.c
+++ linux-2.6/arch/sh/boards/mach-landisk/irq.c
@@ -18,15 +18,17 @@
 #include <linux/io.h>
 #include <mach-landisk/mach/iodata_landisk.h>
 
-static void disable_landisk_irq(unsigned int irq)
+static void disable_landisk_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned char mask = 0xff ^ (0x01 << (irq - 5));
 
 	ctrl_outb(ctrl_inb(PA_IMASK) & mask, PA_IMASK);
 }
 
-static void enable_landisk_irq(unsigned int irq)
+static void enable_landisk_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned char value = (0x01 << (irq - 5));
 
 	ctrl_outb(ctrl_inb(PA_IMASK) | value, PA_IMASK);
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
+static void enable_microdev_irq(struct irq_desc *desc);
+static void disable_microdev_irq(struct irq_desc *desc);
+static void mask_and_ack_microdev(struct irq_desc *desc);
 
 static struct irq_chip microdev_irq_type = {
 	.name = "MicroDev-IRQ",
@@ -76,8 +76,9 @@ static struct irq_chip microdev_irq_type
 	.ack = mask_and_ack_microdev,
 };
 
-static void disable_microdev_irq(unsigned int irq)
+static void disable_microdev_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int fpgaIrq;
 
 	if (irq >= NUM_EXTERNAL_IRQS)
@@ -91,8 +92,9 @@ static void disable_microdev_irq(unsigne
 	ctrl_outl(MICRODEV_FPGA_INTC_MASK(fpgaIrq), MICRODEV_FPGA_INTDSB_REG);
 }
 
-static void enable_microdev_irq(unsigned int irq)
+static void enable_microdev_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long priorityReg, priorities, pri;
 	unsigned int fpgaIrq;
 
@@ -119,14 +121,15 @@ static void enable_microdev_irq(unsigned
 /* This function sets the desired irq handler to be a MicroDev type */
 static void __init make_microdev_irq(unsigned int irq)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	disable_irq_nosync(irq);
 	set_irq_chip_and_handler(irq, &microdev_irq_type, handle_level_irq);
-	disable_microdev_irq(irq);
+	disable_microdev_irq(desc);
 }
 
-static void mask_and_ack_microdev(unsigned int irq)
+static void mask_and_ack_microdev(struct irq_desc *desc)
 {
-	disable_microdev_irq(irq);
+	disable_microdev_irq(desc);
 }
 
 extern void __init init_microdev_irq(void)
Index: linux-2.6/arch/sh/boards/mach-se/7206/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7206/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7206/irq.c
@@ -25,8 +25,9 @@
 #define INTC_IPR01 0xfffe0818
 #define INTC_ICR1  0xfffe0802
 
-static void disable_se7206_irq(unsigned int irq)
+static void disable_se7206_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned short val;
 	unsigned short mask = 0xffff ^ (0x0f << 4 * (3 - (IRQ0_IRQ - irq)));
 	unsigned short msk0,msk1;
@@ -55,8 +56,9 @@ static void disable_se7206_irq(unsigned
 	ctrl_outw(msk1, INTMSK1);
 }
 
-static void enable_se7206_irq(unsigned int irq)
+static void enable_se7206_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned short val;
 	unsigned short value = (0x0001 << 4 * (3 - (IRQ0_IRQ - irq)));
 	unsigned short msk0,msk1;
@@ -86,8 +88,9 @@ static void enable_se7206_irq(unsigned i
 	ctrl_outw(msk1, INTMSK1);
 }
 
-static void eoi_se7206_irq(unsigned int irq)
+static void eoi_se7206_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned short sts0,sts1;
 
 	if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
Index: linux-2.6/arch/sh/boards/mach-se/7343/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7343/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7343/irq.c
@@ -16,14 +16,16 @@
 #include <linux/io.h>
 #include <mach-se/mach/se7343.h>
 
-static void disable_se7343_irq(unsigned int irq)
+static void disable_se7343_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - SE7343_FPGA_IRQ_BASE;
 	ctrl_outw(ctrl_inw(PA_CPLD_IMSK) | 1 << bit, PA_CPLD_IMSK);
 }
 
-static void enable_se7343_irq(unsigned int irq)
+static void enable_se7343_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int bit = irq - SE7343_FPGA_IRQ_BASE;
 	ctrl_outw(ctrl_inw(PA_CPLD_IMSK) & ~(1 << bit), PA_CPLD_IMSK);
 }
Index: linux-2.6/arch/sh/boards/mach-se/7722/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7722/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7722/irq.c
@@ -18,15 +18,15 @@
 
 unsigned int se7722_fpga_irq[SE7722_FPGA_IRQ_NR] = { 0, };
 
-static void disable_se7722_irq(unsigned int irq)
+static void disable_se7722_irq(struct irq_desc *desc)
 {
-	unsigned int bit = (unsigned int)get_irq_chip_data(irq);
+	unsigned int bit = (unsigned int)get_irq_desc_chip_data(desc);
 	ctrl_outw(ctrl_inw(IRQ01_MASK) | 1 << bit, IRQ01_MASK);
 }
 
-static void enable_se7722_irq(unsigned int irq)
+static void enable_se7722_irq(struct irq_desc *desc)
 {
-	unsigned int bit = (unsigned int)get_irq_chip_data(irq);
+	unsigned int bit = (unsigned int)get_irq_desc_chip_data(desc);
 	ctrl_outw(ctrl_inw(IRQ01_MASK) & ~(1 << bit), IRQ01_MASK);
 }
 
Index: linux-2.6/arch/sh/boards/mach-se/7724/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-se/7724/irq.c
+++ linux-2.6/arch/sh/boards/mach-se/7724/irq.c
@@ -68,15 +68,17 @@ static struct fpga_irq get_fpga_irq(unsi
 	return set;
 }
 
-static void disable_se7724_irq(unsigned int irq)
+static void disable_se7724_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct fpga_irq set = get_fpga_irq(fpga2irq(irq));
 	unsigned int bit = irq - set.base;
 	ctrl_outw(ctrl_inw(set.mraddr) | 0x0001 << bit, set.mraddr);
 }
 
-static void enable_se7724_irq(unsigned int irq)
+static void enable_se7724_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct fpga_irq set = get_fpga_irq(fpga2irq(irq));
 	unsigned int bit = irq - set.base;
 	ctrl_outw(ctrl_inw(set.mraddr) & ~(0x0001 << bit), set.mraddr);
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
+static void enable_systemh_irq(struct irq_desc *desc);
+static void disable_systemh_irq(struct irq_desc *desc);
+static void mask_and_ack_systemh(struct irq_desc *desc);
 
 static struct irq_chip systemh_irq_type = {
 	.name = " SystemH Register",
@@ -35,8 +35,9 @@ static struct irq_chip systemh_irq_type
 	.ack = mask_and_ack_systemh,
 };
 
-static void disable_systemh_irq(unsigned int irq)
+static void disable_systemh_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (systemh_irq_mask_register) {
 		unsigned long val, mask = 0x01 << 1;
 
@@ -51,8 +52,9 @@ static void disable_systemh_irq(unsigned
 	}
 }
 
-static void enable_systemh_irq(unsigned int irq)
+static void enable_systemh_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	if (systemh_irq_mask_register) {
 		unsigned long val, mask = 0x01 << 1;
 
@@ -63,9 +65,9 @@ static void enable_systemh_irq(unsigned
 	}
 }
 
-static void mask_and_ack_systemh(unsigned int irq)
+static void mask_and_ack_systemh(struct irq_desc *desc)
 {
-	disable_systemh_irq(irq);
+	disable_systemh_irq(desc);
 }
 
 void make_systemh_irq(unsigned int irq)
Index: linux-2.6/arch/sh/cchips/hd6446x/hd64461.c
===================================================================
--- linux-2.6.orig/arch/sh/cchips/hd6446x/hd64461.c
+++ linux-2.6/arch/sh/cchips/hd6446x/hd64461.c
@@ -17,8 +17,9 @@
 /* This belongs in cpu specific */
 #define INTC_ICR1 0xA4140010UL
 
-static void hd64461_mask_irq(unsigned int irq)
+static void hd64461_mask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned short nimr;
 	unsigned short mask = 1 << (irq - HD64461_IRQBASE);
 
@@ -27,8 +28,9 @@ static void hd64461_mask_irq(unsigned in
 	__raw_writew(nimr, HD64461_NIMR);
 }
 
-static void hd64461_unmask_irq(unsigned int irq)
+static void hd64461_unmask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned short nimr;
 	unsigned short mask = 1 << (irq - HD64461_IRQBASE);
 
@@ -37,9 +39,10 @@ static void hd64461_unmask_irq(unsigned
 	__raw_writew(nimr, HD64461_NIMR);
 }
 
-static void hd64461_mask_and_ack_irq(unsigned int irq)
+static void hd64461_mask_and_ack_irq(struct irq_desc *desc)
 {
-	hd64461_mask_irq(irq);
+	unsigned int irq = desc->irq;
+	hd64461_mask_irq(desc);
 #ifdef CONFIG_HD64461_ENABLER
 	if (irq == HD64461_IRQBASE + 13)
 		__raw_writeb(0x00, HD64461_PCC1CSCR);
Index: linux-2.6/arch/sh/kernel/cpu/irq/imask.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/imask.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/imask.c
@@ -51,16 +51,18 @@ static inline void set_interrupt_registe
 		     : "t");
 }
 
-static void mask_imask_irq(unsigned int irq)
+static void mask_imask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	clear_bit(irq, imask_mask);
 	if (interrupt_priority < IMASK_PRIORITY - irq)
 		interrupt_priority = IMASK_PRIORITY - irq;
 	set_interrupt_registers(interrupt_priority);
 }
 
-static void unmask_imask_irq(unsigned int irq)
+static void unmask_imask_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_bit(irq, imask_mask);
 	interrupt_priority = IMASK_PRIORITY -
 		find_first_zero_bit(imask_mask, IMASK_PRIORITY);
Index: linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/irq/intc-sh5.c
+++ linux-2.6/arch/sh/kernel/cpu/irq/intc-sh5.c
@@ -77,12 +77,12 @@ int intc_evt_to_irq[(0xE20/0x20)+1] = {
 
 static unsigned long intc_virt;
 
-static unsigned int startup_intc_irq(unsigned int irq);
-static void shutdown_intc_irq(unsigned int irq);
-static void enable_intc_irq(unsigned int irq);
-static void disable_intc_irq(unsigned int irq);
-static void mask_and_ack_intc(unsigned int);
-static void end_intc_irq(unsigned int irq);
+static unsigned int startup_intc_irq(struct irq_desc *desc);
+static void shutdown_intc_irq(struct irq_desc *desc);
+static void enable_intc_irq(struct irq_desc *desc);
+static void disable_intc_irq(struct irq_desc *desc);
+static void mask_and_ack_intc(struct irq_desc *desc);
+static void end_intc_irq(struct irq_desc *desc);
 
 static struct irq_chip intc_irq_type = {
 	.name = "INTC",
@@ -96,19 +96,20 @@ static struct irq_chip intc_irq_type = {
 
 static int irlm;		/* IRL mode */
 
-static unsigned int startup_intc_irq(unsigned int irq)
+static unsigned int startup_intc_irq(struct irq_desc *desc)
 {
-	enable_intc_irq(irq);
+	enable_intc_irq(desc);
 	return 0; /* never anything pending */
 }
 
-static void shutdown_intc_irq(unsigned int irq)
+static void shutdown_intc_irq(struct irq_desc *desc)
 {
-	disable_intc_irq(irq);
+	disable_intc_irq(desc);
 }
 
-static void enable_intc_irq(unsigned int irq)
+static void enable_intc_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long reg;
 	unsigned long bitmask;
 
@@ -126,8 +127,9 @@ static void enable_intc_irq(unsigned int
 	ctrl_outl(bitmask, reg);
 }
 
-static void disable_intc_irq(unsigned int irq)
+static void disable_intc_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long reg;
 	unsigned long bitmask;
 
@@ -142,14 +144,14 @@ static void disable_intc_irq(unsigned in
 	ctrl_outl(bitmask, reg);
 }
 
-static void mask_and_ack_intc(unsigned int irq)
+static void mask_and_ack_intc(struct irq_desc *desc)
 {
-	disable_intc_irq(irq);
+	disable_intc_irq(desc);
 }
 
-static void end_intc_irq(unsigned int irq)
+static void end_intc_irq(struct irq_desc *desc)
 {
-	enable_intc_irq(irq);
+	enable_intc_irq(desc);
 }
 
 void __init plat_irq_setup(void)
Index: linux-2.6/arch/sparc/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/irq_64.c
+++ linux-2.6/arch/sparc/kernel/irq_64.c
@@ -250,7 +250,7 @@ struct irq_handler_data {
 };
 
 #ifdef CONFIG_SMP
-static int irq_choose_cpu(unsigned int virt_irq, const struct cpumask *affinity)
+static int irq_choose_cpu(struct irq_desc *desc, const struct cpumask *affinity)
 {
 	cpumask_t mask;
 	int cpuid;
@@ -272,9 +272,10 @@ static int irq_choose_cpu(unsigned int v
 	real_hard_smp_processor_id()
 #endif
 
-static void sun4u_irq_enable(unsigned int virt_irq)
+static void sun4u_irq_enable(struct irq_desc *desc)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
+	unsigned int virt_irq = desc->irq;
+	struct irq_handler_data *data = get_irq_desc_chip_data(desc);
 
 	if (likely(data)) {
 		unsigned long cpuid, imap, val;
@@ -295,10 +296,11 @@ static void sun4u_irq_enable(unsigned in
 	}
 }
 
-static int sun4u_set_affinity(unsigned int virt_irq,
+static int sun4u_set_affinity(struct irq_desc *desc,
 			       const struct cpumask *mask)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
+	unsigned int virt_irq = desc->irq;
+	struct irq_handler_data *data = get_irq_desc_chip_data(desc);
 
 	if (likely(data)) {
 		unsigned long cpuid, imap, val;
@@ -337,14 +339,14 @@ static int sun4u_set_affinity(unsigned i
  * sees that, it also hooks up a default ->shutdown method which
  * invokes ->mask() which we do not want.  See irq_chip_set_defaults().
  */
-static void sun4u_irq_disable(unsigned int virt_irq)
+static void sun4u_irq_disable(struct irq_desc *desc)
 {
 }
 
-static void sun4u_irq_eoi(unsigned int virt_irq)
+static void sun4u_irq_eoi(unsigned int virt_irq, struct irq_desc *desc)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
-	struct irq_desc *desc = irq_desc + virt_irq;
+	unsigned int virt_irq = desc->irq;
+	struct irq_handler_data *data = get_irq_desc_chip_data(desc);
 
 	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		return;
@@ -353,8 +355,9 @@ static void sun4u_irq_eoi(unsigned int v
 		upa_writeq(ICLR_IDLE, data->iclr);
 }
 
-static void sun4v_irq_enable(unsigned int virt_irq)
+static void sun4v_irq_enable(struct irq_desc *desc)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	unsigned long cpuid = irq_choose_cpu(virt_irq,
 					     irq_desc[virt_irq].affinity);
@@ -374,9 +377,10 @@ static void sun4v_irq_enable(unsigned in
 		       ino, err);
 }
 
-static int sun4v_set_affinity(unsigned int virt_irq,
+static int sun4v_set_affinity(struct irq_desc *desc,
 			       const struct cpumask *mask)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	unsigned long cpuid = irq_choose_cpu(virt_irq, mask);
 	int err;
@@ -389,8 +393,9 @@ static int sun4v_set_affinity(unsigned i
 	return 0;
 }
 
-static void sun4v_irq_disable(unsigned int virt_irq)
+static void sun4v_irq_disable(struct irq_desc *desc)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	int err;
 
@@ -400,8 +405,9 @@ static void sun4v_irq_disable(unsigned i
 		       "err(%d)\n", ino, err);
 }
 
-static void sun4v_irq_eoi(unsigned int virt_irq)
+static void sun4v_irq_eoi(unsigned int virt_irq, struct irq_desc *desc)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	struct irq_desc *desc = irq_desc + virt_irq;
 	int err;
@@ -415,12 +421,13 @@ static void sun4v_irq_eoi(unsigned int v
 		       "err(%d)\n", ino, err);
 }
 
-static void sun4v_virq_enable(unsigned int virt_irq)
+static void sun4v_virq_enable(struct irq_desc *desc)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned long cpuid, dev_handle, dev_ino;
 	int err;
 
-	cpuid = irq_choose_cpu(virt_irq, irq_desc[virt_irq].affinity);
+	cpuid = irq_choose_cpu(virt_irq, desc->affinity);
 
 	dev_handle = virt_irq_table[virt_irq].dev_handle;
 	dev_ino = virt_irq_table[virt_irq].dev_ino;
@@ -444,9 +451,10 @@ static void sun4v_virq_enable(unsigned i
 		       dev_handle, dev_ino, err);
 }
 
-static int sun4v_virt_set_affinity(unsigned int virt_irq,
+static int sun4v_virt_set_affinity(struct irq_desc *desc,
 				    const struct cpumask *mask)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned long cpuid, dev_handle, dev_ino;
 	int err;
 
@@ -464,8 +472,9 @@ static int sun4v_virt_set_affinity(unsig
 	return 0;
 }
 
-static void sun4v_virq_disable(unsigned int virt_irq)
+static void sun4v_virq_disable(struct irq_desc *desc)
 {
+	unsigned int virt_irq = desc->irq;
 	unsigned long dev_handle, dev_ino;
 	int err;
 
@@ -480,9 +489,9 @@ static void sun4v_virq_disable(unsigned
 		       dev_handle, dev_ino, err);
 }
 
-static void sun4v_virq_eoi(unsigned int virt_irq)
+static void sun4v_virq_eoi(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_desc + virt_irq;
+	unsigned int virt_irq = desc->irq;
 	unsigned long dev_handle, dev_ino;
 	int err;
 
@@ -801,15 +810,16 @@ void fixup_irqs(void)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		unsigned long flags;
+		struct irq_desc *desc = irq_to_desc(irq);
 
-		raw_spin_lock_irqsave(&irq_desc[irq].lock, flags);
-		if (irq_desc[irq].action &&
-		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
-			if (irq_desc[irq].chip->set_affinity)
-				irq_desc[irq].chip->set_affinity(irq,
-					irq_desc[irq].affinity);
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		if (desc->action &&
+		    !(desc->status & IRQ_PER_CPU)) {
+			if (desc->chip->set_affinity)
+				desc->chip->set_affinity(desc,
+					desc->affinity);
 		}
-		raw_spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
 	tick_ops->disable_irq();
Index: linux-2.6/arch/sparc/kernel/pci_msi.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/pci_msi.c
+++ linux-2.6/arch/sparc/kernel/pci_msi.c
@@ -111,12 +111,21 @@ static void free_msi(struct pci_pbm_info
 	clear_bit(msi_num, pbm->msi_bitmap);
 }
 
+static void sparc64_enable_msi_irq(struct irq_desc *desc)
+{
+	unmask_msi_irq(desc);
+}
+static void sparc64_diable_msi_irq(struct irq_desc *desc)
+{
+	mask_msi_irq(desc);
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
@@ -362,7 +362,7 @@ EXPORT_SYMBOL(reactivate_fd);
  * irq_chip must define (startup || enable) &&
  * (shutdown || disable) && end
  */
-static void dummy(unsigned int irq)
+static void dummy(struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/arch/x86/include/asm/hardirq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hardirq.h
+++ linux-2.6/arch/x86/include/asm/hardirq.h
@@ -44,7 +44,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 #define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
 #define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
 
-extern void ack_bad_irq(unsigned int irq);
+extern void ack_bad_irq(struct irq_desc *desc);
 
 extern u64 arch_irq_stat_cpu(unsigned int cpu);
 #define arch_irq_stat_cpu	arch_irq_stat_cpu
Index: linux-2.6/arch/x86/include/asm/hpet.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hpet.h
+++ linux-2.6/arch/x86/include/asm/hpet.h
@@ -74,10 +74,10 @@ extern void hpet_disable(void);
 extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
-extern void hpet_msi_unmask(unsigned int irq);
-extern void hpet_msi_mask(unsigned int irq);
-extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
-extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
+extern void hpet_msi_unmask(struct irq_desc *);
+extern void hpet_msi_mask(struct irq_desc *);
+extern void hpet_msi_write(struct irq_desc *desc, struct msi_msg *msg);
+extern void hpet_msi_read(struct irq_desc *desc, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
 extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
Index: linux-2.6/arch/x86/include/asm/i8259.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/i8259.h
+++ linux-2.6/arch/x86/include/asm/i8259.h
@@ -58,7 +58,7 @@ struct legacy_pic {
 	void (*mask_all)(void);
 	void (*restore_mask)(void);
 	void (*init)(int auto_eoi);
-	int (*irq_pending)(unsigned int irq);
+	int (*irq_pending)(struct irq_desc *desc);
 	void (*make_irq)(unsigned int irq);
 };
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -608,16 +608,12 @@ static void unmask_IO_APIC_irq_desc(stru
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_IO_APIC_irq(unsigned int irq)
+static void mask_IO_APIC_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	mask_IO_APIC_irq_desc(desc);
 }
-static void unmask_IO_APIC_irq(unsigned int irq)
+static void unmask_IO_APIC_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	unmask_IO_APIC_irq_desc(desc);
 }
 
@@ -1471,7 +1467,7 @@ static void setup_IO_APIC_irq(int apic_i
 
 	ioapic_register_intr(irq, desc, trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
-		legacy_pic->chip->mask(irq);
+		legacy_pic->chip->mask(desc);
 
 	ioapic_write_entry(apic_id, pin, entry);
 }
@@ -2260,29 +2256,29 @@ static int __init timer_irq_works(void)
  * an edge even if it isn't on the 8259A...
  */
 
-static unsigned int startup_ioapic_irq(unsigned int irq)
+static unsigned int startup_ioapic_irq(struct irq_desc *desc)
 {
 	int was_pending = 0;
 	unsigned long flags;
 	struct irq_cfg *cfg;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < legacy_pic->nr_legacy_irqs) {
-		legacy_pic->chip->mask(irq);
-		if (legacy_pic->irq_pending(irq))
+	if (desc->irq < legacy_pic->nr_legacy_irqs) {
+		legacy_pic->chip->mask(desc);
+		if (legacy_pic->irq_pending(desc))
 			was_pending = 1;
 	}
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 	__unmask_IO_APIC_irq(cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
 }
 
-static int ioapic_retrigger_irq(unsigned int irq)
+static int ioapic_retrigger_irq(struct irq_desc *desc)
 {
 
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
@@ -2391,12 +2387,8 @@ set_ioapic_affinity_irq_desc(struct irq_
 }
 
 static int
-set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
+set_ioapic_affinity_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
 	return set_ioapic_affinity_irq_desc(desc, mask);
 }
 
@@ -2459,11 +2451,9 @@ static int set_ir_ioapic_affinity_irq_de
 {
 	return migrate_ioapic_irq_desc(desc, mask);
 }
-static int set_ir_ioapic_affinity_irq(unsigned int irq,
+static int set_ir_ioapic_affinity_irq(struct irq_desc *desc,
 				       const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	return set_ir_ioapic_affinity_irq_desc(desc, mask);
 }
 #else
@@ -2556,12 +2546,10 @@ void irq_force_complete_move(int irq)
 static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
 
-static void ack_apic_edge(unsigned int irq)
+static void ack_apic_edge(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	irq_complete_move(&desc);
-	move_native_irq(irq);
+	move_native_irq(desc);
 	ack_APIC_irq();
 }
 
@@ -2620,9 +2608,8 @@ static void eoi_ioapic_irq(struct irq_de
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void ack_apic_level(unsigned int irq)
+static void ack_apic_level(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 	int i;
 	struct irq_cfg *cfg;
@@ -2722,21 +2709,19 @@ static void ack_apic_level(unsigned int
 		 */
 		cfg = desc->chip_data;
 		if (!io_apic_level_ack_pending(cfg))
-			move_masked_irq(irq);
+			move_masked_irq(desc);
 		unmask_IO_APIC_irq_desc(desc);
 	}
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void ir_ack_apic_edge(unsigned int irq)
+static void ir_ack_apic_edge(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
-static void ir_ack_apic_level(unsigned int irq)
+static void ir_ack_apic_level(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	ack_APIC_irq();
 	eoi_ioapic_irq(desc);
 }
@@ -2808,7 +2793,7 @@ static inline void init_IO_APIC_traps(vo
  * The local APIC irq-chip implementation:
  */
 
-static void mask_lapic_irq(unsigned int irq)
+static void mask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2816,7 +2801,7 @@ static void mask_lapic_irq(unsigned int
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2824,7 +2809,7 @@ static void unmask_lapic_irq(unsigned in
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq(unsigned int irq)
+static void ack_lapic_irq(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
@@ -2953,7 +2938,7 @@ static inline void __init check_timer(vo
 	/*
 	 * get/set the timer IRQ vector:
 	 */
-	legacy_pic->chip->mask(0);
+	legacy_pic->chip->mask(desc);
 	assign_irq_vector(desc, cfg, apic->target_cpus());
 
 	/*
@@ -3025,7 +3010,7 @@ static inline void __init check_timer(vo
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				legacy_pic->chip->unmask(desc);
 			}
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(0, pin1);
@@ -3048,14 +3033,14 @@ static inline void __init check_timer(vo
 		 */
 		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		legacy_pic->chip->unmask(0);
+		legacy_pic->chip->unmask(desc);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
-				legacy_pic->chip->mask(0);
+				legacy_pic->chip->mask(desc);
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				legacy_pic->chip->unmask(desc);
 			}
 			goto out;
 		}
@@ -3063,7 +3048,7 @@ static inline void __init check_timer(vo
 		 * Cleanup, just in case ...
 		 */
 		local_irq_disable();
-		legacy_pic->chip->mask(0);
+		legacy_pic->chip->mask(desc);
 		clear_IO_APIC_pin(apic2, pin2);
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
@@ -3082,14 +3067,14 @@ static inline void __init check_timer(vo
 
 	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
-	legacy_pic->chip->unmask(0);
+	legacy_pic->chip->unmask(desc);
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
 	local_irq_disable();
-	legacy_pic->chip->mask(0);
+	legacy_pic->chip->mask(desc);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
@@ -3330,10 +3315,10 @@ void destroy_irq(unsigned int irq)
  * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+static int msi_compose_msg(struct pci_dev *pdev, struct irq_desc *desc,
 			   struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_desc *desc;
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
@@ -3341,7 +3326,6 @@ static int msi_compose_msg(struct pci_de
 	if (disable_apic)
 		return -ENXIO;
 
-	desc = irq_to_desc(irq);
 	cfg = desc->chip_data;
 	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (err)
@@ -3409,9 +3393,8 @@ static int msi_compose_msg(struct pci_de
 }
 
 #ifdef CONFIG_SMP
-static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3438,9 +3421,9 @@ static int set_msi_irq_affinity(unsigned
  * done in the process context using interrupt-remapping hardware.
  */
 static int
-ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+ir_set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	struct irte irte;
@@ -3532,8 +3515,9 @@ static int setup_msi_irq(struct pci_dev
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
+	ret = msi_compose_msg(dev, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
 
@@ -3541,7 +3525,6 @@ static int setup_msi_irq(struct pci_dev
 	write_msi_msg(irq, &msg);
 
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_to_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -3623,9 +3606,8 @@ void arch_teardown_msi_irq(unsigned int
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3635,14 +3617,14 @@ static int dmar_msi_set_affinity(unsigne
 
 	cfg = desc->chip_data;
 
-	dmar_msi_read(irq, &msg);
+	dmar_msi_read(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	dmar_msi_write(irq, &msg);
+	dmar_msi_write(desc, &msg);
 
 	return 0;
 }
@@ -3664,11 +3646,12 @@ int arch_setup_dmar_msi(unsigned int irq
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
+	ret = msi_compose_msg(NULL, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
-	dmar_msi_write(irq, &msg);
+	dmar_msi_write(desc, &msg);
 	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 		"edge");
 	return 0;
@@ -3678,9 +3661,8 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3690,14 +3672,14 @@ static int hpet_msi_set_affinity(unsigne
 
 	cfg = desc->chip_data;
 
-	hpet_msi_read(irq, &msg);
+	hpet_msi_read(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write(desc, &msg);
 
 	return 0;
 }
@@ -3746,11 +3728,11 @@ int arch_setup_hpet_msi(unsigned int irq
 			return -1;
 	}
 
-	ret = msi_compose_msg(NULL, irq, &msg, id);
+	ret = msi_compose_msg(NULL, desc, &msg, id);
 	if (ret < 0)
 		return ret;
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write(desc, &msg);
 	desc->status |= IRQ_MOVE_PCNTXT;
 	if (irq_remapped(irq))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
@@ -3771,10 +3753,10 @@ int arch_setup_hpet_msi(unsigned int irq
 
 #ifdef CONFIG_SMP
 
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
+static void target_ht_irq(struct irq_desc *desc, unsigned int dest, u8 vector)
 {
 	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
+	fetch_ht_irq_msg(desc, &msg);
 
 	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
 	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
@@ -3782,12 +3764,11 @@ static void target_ht_irq(unsigned int i
 	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
 	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
 
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
-static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_ht_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
@@ -3796,7 +3777,7 @@ static int set_ht_irq_affinity(unsigned
 
 	cfg = desc->chip_data;
 
-	target_ht_irq(irq, dest, cfg->vector);
+	target_ht_irq(desc, dest, cfg->vector);
 
 	return 0;
 }
@@ -3848,7 +3829,7 @@ int arch_setup_ht_irq(unsigned int irq,
 				HT_IRQ_LOW_MT_ARBITRATED) |
 			HT_IRQ_LOW_IRQ_MASKED;
 
-		write_ht_irq_msg(irq, &msg);
+		write_ht_irq_msg(desc, &msg);
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -426,9 +426,9 @@ static int hpet_legacy_next_event(unsign
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
-void hpet_msi_unmask(unsigned int irq)
+void hpet_msi_unmask(struct irq_desc *desc)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 	unsigned int cfg;
 
 	/* unmask it */
@@ -437,10 +437,10 @@ void hpet_msi_unmask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_mask(unsigned int irq)
+void hpet_msi_mask(struct irq_desc *desc)
 {
 	unsigned int cfg;
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
@@ -448,17 +448,17 @@ void hpet_msi_mask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_write(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	hpet_writel(msg->data, HPET_Tn_ROUTE(hdev->num));
 	hpet_writel(msg->address_lo, HPET_Tn_ROUTE(hdev->num) + 4);
 }
 
-void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_read(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	msg->data = hpet_readl(HPET_Tn_ROUTE(hdev->num));
 	msg->address_lo = hpet_readl(HPET_Tn_ROUTE(hdev->num) + 4);
Index: linux-2.6/arch/x86/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259.c
+++ linux-2.6/arch/x86/kernel/i8259.c
@@ -33,13 +33,13 @@
 
 static int i8259A_auto_eoi;
 DEFINE_RAW_SPINLOCK(i8259A_lock);
-static void mask_and_ack_8259A(unsigned int);
+static void mask_and_ack_8259A(struct irq_desc *desc);
 static void mask_8259A(void);
 static void unmask_8259A(void);
-static void disable_8259A_irq(unsigned int irq);
-static void enable_8259A_irq(unsigned int irq);
+static void disable_8259A_irq(struct irq_desc *desc);
+static void enable_8259A_irq(struct irq_desc *desc);
 static void init_8259A(int auto_eoi);
-static int i8259A_irq_pending(unsigned int irq);
+static int i8259A_irq_pending(struct irq_desc *desc);
 
 struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
@@ -69,8 +69,9 @@ unsigned int cached_irq_mask = 0xffff;
  */
 unsigned long io_apic_irqs;
 
-static void disable_8259A_irq(unsigned int irq)
+static void disable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << irq;
 	unsigned long flags;
 
@@ -83,8 +84,9 @@ static void disable_8259A_irq(unsigned i
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static void enable_8259A_irq(unsigned int irq)
+static void enable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
 
@@ -97,8 +99,9 @@ static void enable_8259A_irq(unsigned in
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static int i8259A_irq_pending(unsigned int irq)
+static int i8259A_irq_pending(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1<<irq;
 	unsigned long flags;
 	int ret;
@@ -151,8 +154,9 @@ static inline int i8259A_irq_real(unsign
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-static void mask_and_ack_8259A(unsigned int irq)
+static void mask_and_ack_8259A(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irqmask = 1 << irq;
 	unsigned long flags;
 
@@ -372,17 +376,18 @@ static void init_8259A(int auto_eoi)
  */
 
 static void legacy_pic_noop(void) { };
+static void legacy_pic_desc_noop(struct irq_desc *desc) { };
 static void legacy_pic_uint_noop(unsigned int unused) { };
 static void legacy_pic_int_noop(int unused) { };
 
 static struct irq_chip dummy_pic_chip  = {
 	.name = "dummy pic",
-	.mask = legacy_pic_uint_noop,
-	.unmask = legacy_pic_uint_noop,
-	.disable = legacy_pic_uint_noop,
-	.mask_ack = legacy_pic_uint_noop,
+	.mask = legacy_pic_desc_noop,
+	.unmask = legacy_pic_desc_noop,
+	.disable = legacy_pic_desc_noop,
+	.mask_ack = legacy_pic_desc_noop,
 };
-static int legacy_pic_irq_pending_noop(unsigned int irq)
+static int legacy_pic_irq_pending_noop(struct irq_desc *desc)
 {
 	return 0;
 }
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -24,10 +24,10 @@ void (*x86_platform_ipi_callback)(void)
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
  */
-void ack_bad_irq(unsigned int irq)
+void ack_bad_irq(struct irq_desc *desc)
 {
 	if (printk_ratelimit())
-		pr_err("unexpected IRQ trap at vector %02x\n", irq);
+		pr_err("unexpected IRQ trap at irq %02x\n", desc->irq);
 
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
@@ -316,15 +316,15 @@ void fixup_irqs(void)
 		}
 
 		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
-			desc->chip->mask(irq);
+			desc->chip->mask(desc);
 
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, affinity);
+			desc->chip->set_affinity(desc, affinity);
 		else if (!(warned++))
 			set_affinity = 0;
 
 		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
-			desc->chip->unmask(irq);
+			desc->chip->unmask(desc);
 
 		raw_spin_unlock(&desc->lock);
 
@@ -357,7 +357,7 @@ void fixup_irqs(void)
 
 			raw_spin_lock(&desc->lock);
 			if (desc->chip->retrigger)
-				desc->chip->retrigger(irq);
+				desc->chip->retrigger(desc);
 			raw_spin_unlock(&desc->lock);
 		}
 	}
Index: linux-2.6/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6/arch/x86/kernel/uv_irq.c
@@ -27,18 +27,18 @@ struct uv_irq_2_mmr_pnode{
 static spinlock_t		uv_irq_lock;
 static struct rb_root		uv_irq_root;
 
-static int uv_set_irq_affinity(unsigned int, const struct cpumask *);
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *);
 
-static void uv_noop(unsigned int irq)
+static void uv_noop(struct irq_desc *desc)
 {
 }
 
-static unsigned int uv_noop_ret(unsigned int irq)
+static unsigned int uv_noop_ret(struct irq_desc *desc)
 {
 	return 0;
 }
 
-static void uv_ack_apic(unsigned int irq)
+static void uv_ack_apic(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
@@ -205,9 +205,9 @@ static void arch_disable_uv_irq(int mmr_
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 }
 
-static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	unsigned long mmr_value;
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -430,14 +430,15 @@ static int is_co_apic(unsigned int irq)
  * This is the SGI Cobalt (IO-)APIC:
  */
 
-static void enable_cobalt_irq(unsigned int irq)
+static void enable_cobalt_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	co_apic_set(is_co_apic(irq), irq);
 }
 
-static void disable_cobalt_irq(unsigned int irq)
+static void disable_cobalt_irq(struct irq_desc *desc)
 {
-	int entry = is_co_apic(irq);
+	int entry = is_co_apic(desc->irq);
 
 	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
 	co_apic_read(CO_APIC_LO(entry));
@@ -448,37 +449,35 @@ static void disable_cobalt_irq(unsigned
  * map this to the Cobalt APIC entry where it's physically wired.
  * This is called via request_irq -> setup_irq -> irq_desc->startup()
  */
-static unsigned int startup_cobalt_irq(unsigned int irq)
+static unsigned int startup_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
 		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 	return 0;
 }
 
-static void ack_cobalt_irq(unsigned int irq)
+static void ack_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	disable_cobalt_irq(irq);
+	disable_cobalt_irq(desc);
 	apic_write(APIC_EOI, APIC_EIO_ACK);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
-static void end_cobalt_irq(unsigned int irq)
+static void end_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_cobalt_irq(irq);
+		enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
@@ -503,19 +502,19 @@ static struct irq_chip cobalt_irq_type =
  * interrupt controller type, and through a special virtual interrupt-
  * controller. Device drivers only see the virtual interrupt sources.
  */
-static unsigned int startup_piix4_master_irq(unsigned int irq)
+static unsigned int startup_piix4_master_irq(struct irq_desc *desc)
 {
 	legacy_pic->init(0);
 
-	return startup_cobalt_irq(irq);
+	return startup_cobalt_irq(desc);
 }
 
-static void end_piix4_master_irq(unsigned int irq)
+static void end_piix4_master_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
Index: linux-2.6/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmiclock_32.c
+++ linux-2.6/arch/x86/kernel/vmiclock_32.c
@@ -84,7 +84,7 @@ static inline unsigned int vmi_get_timer
 
 /** vmi clockchip */
 #ifdef CONFIG_X86_LOCAL_APIC
-static unsigned int startup_timer_irq(unsigned int irq)
+static unsigned int startup_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, vmi_get_timer_vector());
@@ -92,19 +92,19 @@ static unsigned int startup_timer_irq(un
 	return (val & APIC_SEND_PENDING);
 }
 
-static void mask_timer_irq(unsigned int irq)
+static void mask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val | APIC_LVT_MASKED);
 }
 
-static void unmask_timer_irq(unsigned int irq)
+static void unmask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val & ~APIC_LVT_MASKED);
 }
 
-static void ack_timer_irq(unsigned int irq)
+static void ack_timer_irq(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -789,14 +789,14 @@ static void lguest_flush_tlb_kernel(void
  * simple as setting a bit.  We don't actually "ack" interrupts as such, we
  * just mask and unmask them.  I wonder if we should be cleverer?
  */
-static void disable_lguest_irq(unsigned int irq)
+static void disable_lguest_irq(struct irq_desc *desc)
 {
-	set_bit(irq, lguest_data.blocked_interrupts);
+	set_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
-static void enable_lguest_irq(unsigned int irq)
+static void enable_lguest_irq(struct irq_desc *desc)
 {
-	clear_bit(irq, lguest_data.blocked_interrupts);
+	clear_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
 /* This structure describes the lguest IRQ controller. */
Index: linux-2.6/arch/xtensa/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/irq.c
+++ linux-2.6/arch/xtensa/kernel/irq.c
@@ -120,37 +120,43 @@ skip:
 	return 0;
 }
 
-static void xtensa_irq_mask(unsigned int irq)
+static void xtensa_irq_mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	cached_irq_mask &= ~(1 << irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_unmask(unsigned int irq)
+static void xtensa_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	cached_irq_mask |= 1 << irq;
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_enable(unsigned int irq)
+static void xtensa_irq_enable(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	variant_irq_enable(irq);
-	xtensa_irq_unmask(irq);
+	xtensa_irq_unmask(desc);
 }
 
-static void xtensa_irq_disable(unsigned int irq)
+static void xtensa_irq_disable(struct irq_desc *desc)
 {
-	xtensa_irq_mask(irq);
+	unsigned int irq = desc->irq;
+	xtensa_irq_mask(desc);
 	variant_irq_disable(irq);
 }
 
-static void xtensa_irq_ack(unsigned int irq)
+static void xtensa_irq_ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_sr(1 << irq, INTCLEAR);
 }
 
-static int xtensa_irq_retrigger(unsigned int irq)
+static int xtensa_irq_retrigger(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	set_sr (1 << irq, INTSET);
 	return 1;
 }
Index: linux-2.6/arch/xtensa/variants/s6000/gpio.c
===================================================================
--- linux-2.6.orig/arch/xtensa/variants/s6000/gpio.c
+++ linux-2.6/arch/xtensa/variants/s6000/gpio.c
@@ -85,27 +85,31 @@ int s6_gpio_init(u32 afsel)
 	return gpiochip_add(&gpiochip);
 }
 
-static void ack(unsigned int irq)
+static void ack(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	writeb(1 << (irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
 }
 
-static void mask(unsigned int irq)
+static void mask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 r = readb(S6_REG_GPIO + S6_GPIO_IE);
 	r &= ~(1 << (irq - IRQ_BASE));
 	writeb(r, S6_REG_GPIO + S6_GPIO_IE);
 }
 
-static void unmask(unsigned int irq)
+static void unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 m = readb(S6_REG_GPIO + S6_GPIO_IE);
 	m |= 1 << (irq - IRQ_BASE);
 	writeb(m, S6_REG_GPIO + S6_GPIO_IE);
 }
 
-static int set_type(unsigned int irq, unsigned int type)
+static int set_type(struct irq_desc *desc, unsigned int type)
 {
+	unsigned int irq = desc->irq;
 	const u8 m = 1 << (irq - IRQ_BASE);
 	irq_flow_handler_t handler;
 	struct irq_desc *desc;
@@ -164,8 +168,8 @@ static void demux_irqs(unsigned int irq,
 	u8 pending;
 	int cirq;
 
-	desc->chip->mask(irq);
-	desc->chip->ack(irq);
+	desc->chip->mask(desc);
+	desc->chip->ack(desc);
 	pending = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_MIS) & *mask;
 	cirq = IRQ_BASE - 1;
 	while (pending) {
@@ -174,7 +178,7 @@ static void demux_irqs(unsigned int irq,
 		pending >>= n;
 		generic_handle_irq(cirq);
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 extern const signed char *platform_irq_mappings[XTENSA_NR_IRQS];
Index: linux-2.6/drivers/dma/ipu/ipu_irq.c
===================================================================
--- linux-2.6.orig/drivers/dma/ipu/ipu_irq.c
+++ linux-2.6/drivers/dma/ipu/ipu_irq.c
@@ -94,9 +94,9 @@ static struct ipu_irq_map *src2map(unsig
 	return NULL;
 }
 
-static void ipu_irq_unmask(unsigned int irq)
+static void ipu_irq_unmask(struct irq_desc *desc)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = get_irq_desc_chip_data(desc);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -106,7 +106,7 @@ static void ipu_irq_unmask(unsigned int
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, desc->irq);
 		return;
 	}
 
@@ -117,9 +117,9 @@ static void ipu_irq_unmask(unsigned int
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_mask(unsigned int irq)
+static void ipu_irq_mask(struct irq_desc *desc)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = get_irq_desc_chip_data(desc);
 	struct ipu_irq_bank *bank;
 	uint32_t reg;
 	unsigned long lock_flags;
@@ -129,7 +129,7 @@ static void ipu_irq_mask(unsigned int ir
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, desc->irq);
 		return;
 	}
 
@@ -140,9 +140,9 @@ static void ipu_irq_mask(unsigned int ir
 	spin_unlock_irqrestore(&bank_lock, lock_flags);
 }
 
-static void ipu_irq_ack(unsigned int irq)
+static void ipu_irq_ack(struct irq_desc *desc)
 {
-	struct ipu_irq_map *map = get_irq_chip_data(irq);
+	struct ipu_irq_map *map = get_irq_desc_chip_data(desc);
 	struct ipu_irq_bank *bank;
 	unsigned long lock_flags;
 
@@ -151,7 +151,7 @@ static void ipu_irq_ack(unsigned int irq
 	bank = map->bank;
 	if (!bank) {
 		spin_unlock_irqrestore(&bank_lock, lock_flags);
-		pr_err("IPU: %s(%u) - unmapped!\n", __func__, irq);
+		pr_err("IPU: %s(%u) - unmapped!\n", __func__, desc->irq);
 		return;
 	}
 
Index: linux-2.6/drivers/gpio/langwell_gpio.c
===================================================================
--- linux-2.6.orig/drivers/gpio/langwell_gpio.c
+++ linux-2.6/drivers/gpio/langwell_gpio.c
@@ -113,9 +113,10 @@ static int lnw_gpio_to_irq(struct gpio_c
 	return lnw->irq_base + offset;
 }
 
-static int lnw_irq_type(unsigned irq, unsigned type)
+static int lnw_irq_type(struct irq_desc *desc, unsigned type)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct lnw_gpio *lnw = get_irq_desc_chip_data(desc);
 	u32 gpio = irq - lnw->irq_base;
 	u8 reg = gpio / 32;
 	unsigned long flags;
@@ -142,11 +143,11 @@ static int lnw_irq_type(unsigned irq, un
 	return 0;
 };
 
-static void lnw_irq_unmask(unsigned irq)
+static void lnw_irq_unmask(struct irq_desc *desc)
 {
 };
 
-static void lnw_irq_mask(unsigned irq)
+static void lnw_irq_mask(struct irq_desc *desc)
 {
 };
 
@@ -184,7 +185,7 @@ static void lnw_irq_handler(unsigned irq
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 }
 
 static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
Index: linux-2.6/drivers/gpio/pl061.c
===================================================================
--- linux-2.6.orig/drivers/gpio/pl061.c
+++ linux-2.6/drivers/gpio/pl061.c
@@ -122,9 +122,10 @@ static int pl061_to_irq(struct gpio_chip
 /*
  * PL061 GPIO IRQ
  */
-static void pl061_irq_disable(unsigned irq)
+static void pl061_irq_disable(struct irq_desc *desc)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pl061_gpio *chip = get_irq_desc_chip_data(desc);
 	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
@@ -136,9 +137,10 @@ static void pl061_irq_disable(unsigned i
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static void pl061_irq_enable(unsigned irq)
+static void pl061_irq_enable(struct irq_desc *desc)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pl061_gpio *chip = get_irq_desc_chip_data(desc);
 	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
@@ -150,9 +152,10 @@ static void pl061_irq_enable(unsigned ir
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static int pl061_irq_type(unsigned irq, unsigned trigger)
+static int pl061_irq_type(struct irq_desc *desc, unsigned trigger)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pl061_gpio *chip = get_irq_desc_chip_data(desc);
 	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
@@ -207,7 +210,7 @@ static void pl061_irq_handler(unsigned i
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
 		int offset;
@@ -222,7 +225,7 @@ static void pl061_irq_handler(unsigned i
 		for_each_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 }
 
 static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
Index: linux-2.6/drivers/gpio/timbgpio.c
===================================================================
--- linux-2.6.orig/drivers/gpio/timbgpio.c
+++ linux-2.6/drivers/gpio/timbgpio.c
@@ -104,25 +104,28 @@ static int timbgpio_to_irq(struct gpio_c
 /*
  * GPIO IRQ
  */
-static void timbgpio_irq_disable(unsigned irq)
+static void timbgpio_irq_disable(struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 
 	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 0);
 }
 
-static void timbgpio_irq_enable(unsigned irq)
+static void timbgpio_irq_enable(struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 
 	timbgpio_update_bit(&tgpio->gpio, offset, TGPIO_IER, 1);
 }
 
-static int timbgpio_irq_type(unsigned irq, unsigned trigger)
+static int timbgpio_irq_type(struct irq_desc *desc, unsigned trigger)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct timbgpio *tgpio = get_irq_desc_chip_data(desc);
 	int offset = irq - tgpio->irq_base;
 	unsigned long flags;
 	u32 lvr, flr;
@@ -170,7 +173,7 @@ static void timbgpio_irq(unsigned int ir
 	unsigned long ipr;
 	int offset;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
Index: linux-2.6/drivers/gpio/vr41xx_giu.c
===================================================================
--- linux-2.6.orig/drivers/gpio/vr41xx_giu.c
+++ linux-2.6/drivers/gpio/vr41xx_giu.c
@@ -111,28 +111,28 @@ static inline u16 giu_clear(u16 offset,
 	return data;
 }
 
-static void ack_giuint_low(unsigned int irq)
+static void ack_giuint_low(struct irq_desc *desc)
 {
-	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(desc->irq));
 }
 
-static void mask_giuint_low(unsigned int irq)
+static void mask_giuint_low(struct irq_desc *desc)
 {
-	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(desc->irq));
 }
 
-static void mask_ack_giuint_low(unsigned int irq)
+static void mask_ack_giuint_low(struct irq_desc *desc)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq);
+	pin = GPIO_PIN_OF_IRQ(desc->irq);
 	giu_clear(GIUINTENL, 1 << pin);
 	giu_write(GIUINTSTATL, 1 << pin);
 }
 
-static void unmask_giuint_low(unsigned int irq)
+static void unmask_giuint_low(struct irq_desc *desc)
 {
-	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(desc->irq));
 }
 
 static struct irq_chip giuint_low_irq_chip = {
@@ -143,29 +143,29 @@ static struct irq_chip giuint_low_irq_ch
 	.unmask		= unmask_giuint_low,
 };
 
-static void ack_giuint_high(unsigned int irq)
+static void ack_giuint_high(struct irq_desc *desc)
 {
 	giu_write(GIUINTSTATH,
-		  1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+		  1 << (GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_giuint_high(unsigned int irq)
+static void mask_giuint_high(struct irq_desc *desc)
 {
-	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_ack_giuint_high(unsigned int irq)
+static void mask_ack_giuint_high(struct irq_desc *desc)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET;
+	pin = GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET;
 	giu_clear(GIUINTENH, 1 << pin);
 	giu_write(GIUINTSTATH, 1 << pin);
 }
 
-static void unmask_giuint_high(unsigned int irq)
+static void unmask_giuint_high(struct irq_desc *desc)
 {
-	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(desc->irq) - GIUINT_HIGH_OFFSET));
 }
 
 static struct irq_chip giuint_high_irq_chip = {
Index: linux-2.6/drivers/mfd/asic3.c
===================================================================
--- linux-2.6.orig/drivers/mfd/asic3.c
+++ linux-2.6/drivers/mfd/asic3.c
@@ -142,7 +142,7 @@ static void asic3_irq_demux(unsigned int
 	unsigned long flags;
 	struct asic3 *asic;
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 
 	asic = desc->handler_data;
 
@@ -225,9 +225,10 @@ static inline int asic3_irq_to_index(str
 	return (irq - asic->irq_base) & 0xf;
 }
 
-static void asic3_mask_gpio_irq(unsigned int irq)
+static void asic3_mask_gpio_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	u32 val, bank, index;
 	unsigned long flags;
 
@@ -241,9 +242,10 @@ static void asic3_mask_gpio_irq(unsigned
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_mask_irq(unsigned int irq)
+static void asic3_mask_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	int regval;
 	unsigned long flags;
 
@@ -262,9 +264,10 @@ static void asic3_mask_irq(unsigned int
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_gpio_irq(unsigned int irq)
+static void asic3_unmask_gpio_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	u32 val, bank, index;
 	unsigned long flags;
 
@@ -278,9 +281,10 @@ static void asic3_unmask_gpio_irq(unsign
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_irq(unsigned int irq)
+static void asic3_unmask_irq(struct irq_desc *desc)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	int regval;
 	unsigned long flags;
 
@@ -299,9 +303,10 @@ static void asic3_unmask_irq(unsigned in
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
+static int asic3_gpio_irq_type(struct irq_desc *desc, unsigned int type)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct asic3 *asic = get_irq_desc_chip_data(desc);
 	u32 bank, index;
 	u16 trigger, level, edge, bit;
 	unsigned long flags;
Index: linux-2.6/drivers/mfd/ezx-pcap.c
===================================================================
--- linux-2.6.orig/drivers/mfd/ezx-pcap.c
+++ linux-2.6/drivers/mfd/ezx-pcap.c
@@ -143,17 +143,19 @@ int pcap_to_irq(struct pcap_chip *pcap,
 }
 EXPORT_SYMBOL_GPL(pcap_to_irq);
 
-static void pcap_mask_irq(unsigned int irq)
+static void pcap_mask_irq(struct irq_desc *desc)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pcap_chip *pcap = get_irq_desc_chip_data(desc);
 
 	pcap->msr |= 1 << irq_to_pcap(pcap, irq);
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
 
-static void pcap_unmask_irq(unsigned int irq)
+static void pcap_unmask_irq(struct irq_desc *desc)
 {
-	struct pcap_chip *pcap = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct pcap_chip *pcap = get_irq_desc_chip_data(desc);
 
 	pcap->msr &= ~(1 << irq_to_pcap(pcap, irq));
 	queue_work(pcap->workqueue, &pcap->msr_work);
@@ -217,7 +219,7 @@ static void pcap_irq_handler(unsigned in
 {
 	struct pcap_chip *pcap = get_irq_data(irq);
 
-	desc->chip->ack(irq);
+	desc->chip->ack(desc);
 	queue_work(pcap->workqueue, &pcap->isr_work);
 	return;
 }
Index: linux-2.6/drivers/mfd/htc-egpio.c
===================================================================
--- linux-2.6.orig/drivers/mfd/htc-egpio.c
+++ linux-2.6/drivers/mfd/htc-egpio.c
@@ -69,22 +69,24 @@ static inline void ack_irqs(struct egpio
 			ei->ack_write, ei->ack_register << ei->bus_shift);
 }
 
-static void egpio_ack(unsigned int irq)
+static void egpio_ack(struct irq_desc *desc)
 {
 }
 
 /* There does not appear to be a way to proactively mask interrupts
  * on the egpio chip itself.  So, we simply ignore interrupts that
  * aren't desired. */
-static void egpio_mask(unsigned int irq)
+static void egpio_mask(struct irq_desc *desc)
 {
-	struct egpio_info *ei = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct egpio_info *ei = get_irq_desc_chip_data(desc);
 	ei->irqs_enabled &= ~(1 << (irq - ei->irq_start));
 	pr_debug("EGPIO mask %d %04x\n", irq, ei->irqs_enabled);
 }
-static void egpio_unmask(unsigned int irq)
+static void egpio_unmask(struct irq_desc *desc)
 {
-	struct egpio_info *ei = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct egpio_info *ei = get_irq_desc_chip_data(desc);
 	ei->irqs_enabled |= 1 << (irq - ei->irq_start);
 	pr_debug("EGPIO unmask %d %04x\n", irq, ei->irqs_enabled);
 }
Index: linux-2.6/drivers/mfd/t7l66xb.c
===================================================================
--- linux-2.6.orig/drivers/mfd/t7l66xb.c
+++ linux-2.6/drivers/mfd/t7l66xb.c
@@ -198,9 +198,10 @@ static void t7l66xb_irq(unsigned int irq
 				generic_handle_irq(irq_base + i);
 }
 
-static void t7l66xb_irq_mask(unsigned int irq)
+static void t7l66xb_irq_mask(struct irq_desc *desc)
 {
-	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct t7l66xb *t7l66xb = get_irq_desc_chip_data(desc);
 	unsigned long			flags;
 	u8 imr;
 
@@ -211,8 +212,9 @@ static void t7l66xb_irq_mask(unsigned in
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 }
 
-static void t7l66xb_irq_unmask(unsigned int irq)
+static void t7l66xb_irq_unmask(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
 	unsigned long flags;
 	u8 imr;
Index: linux-2.6/drivers/mfd/tc6393xb.c
===================================================================
--- linux-2.6.orig/drivers/mfd/tc6393xb.c
+++ linux-2.6/drivers/mfd/tc6393xb.c
@@ -512,7 +512,8 @@ static int tc6393xb_register_gpio(struct
 static void
 tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct tc6393xb *tc6393xb = get_irq_data(irq);
+	unsigned int irq = desc->irq;
+	struct tc6393xb *tc6393xb = get_irq_desc_chip_data(desc);
 	unsigned int isr;
 	unsigned int i, irq_base;
 
@@ -526,13 +527,14 @@ tc6393xb_irq(unsigned int irq, struct ir
 		}
 }
 
-static void tc6393xb_irq_ack(unsigned int irq)
+static void tc6393xb_irq_ack(struct irq_desc *desc)
 {
 }
 
-static void tc6393xb_irq_mask(unsigned int irq)
+static void tc6393xb_irq_mask(struct irq_desc *desc)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct tc6393xb *tc6393xb = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 	u8 imr;
 
@@ -543,9 +545,10 @@ static void tc6393xb_irq_mask(unsigned i
 	spin_unlock_irqrestore(&tc6393xb->lock, flags);
 }
 
-static void tc6393xb_irq_unmask(unsigned int irq)
+static void tc6393xb_irq_unmask(struct irq_desc *desc)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct tc6393xb *tc6393xb = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 	u8 imr;
 
Index: linux-2.6/drivers/mfd/twl4030-irq.c
===================================================================
--- linux-2.6.orig/drivers/mfd/twl4030-irq.c
+++ linux-2.6/drivers/mfd/twl4030-irq.c
@@ -595,9 +595,10 @@ static void twl4030_sih_do_edge(struct w
  * completion, potentially including some re-ordering, of these requests.
  */
 
-static void twl4030_sih_mask(unsigned irq)
+static void twl4030_sih_mask(struct irq_desc *desc)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
@@ -607,9 +608,10 @@ static void twl4030_sih_mask(unsigned ir
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static void twl4030_sih_unmask(unsigned irq)
+static void twl4030_sih_unmask(struct irq_desc *desc)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	spin_lock_irqsave(&sih_agent_lock, flags);
@@ -619,10 +621,10 @@ static void twl4030_sih_unmask(unsigned
 	spin_unlock_irqrestore(&sih_agent_lock, flags);
 }
 
-static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
+static int twl4030_sih_set_type(struct irq_desc *desc, unsigned trigger)
 {
-	struct sih_agent *sih = get_irq_chip_data(irq);
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
+	struct sih_agent *sih = get_irq_desc_chip_data(desc);
 	unsigned long flags;
 
 	if (!desc) {
Index: linux-2.6/drivers/mfd/wm831x-irq.c
===================================================================
--- linux-2.6.orig/drivers/mfd/wm831x-irq.c
+++ linux-2.6/drivers/mfd/wm831x-irq.c
@@ -346,16 +346,16 @@ static inline struct wm831x_irq_data *ir
 	return &wm831x_irqs[irq - wm831x->irq_base];
 }
 
-static void wm831x_irq_lock(unsigned int irq)
+static void wm831x_irq_lock(struct irq_desc *desc)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 
 	mutex_lock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_sync_unlock(unsigned int irq)
+static void wm831x_irq_sync_unlock(struct irq_desc *des)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(wm831x->irq_masks_cur); i++) {
@@ -372,17 +372,19 @@ static void wm831x_irq_sync_unlock(unsig
 	mutex_unlock(&wm831x->irq_lock);
 }
 
-static void wm831x_irq_unmask(unsigned int irq)
+static void wm831x_irq_unmask(struct irq_desc *desc)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void wm831x_irq_mask(unsigned int irq)
+static void wm831x_irq_mask(struct irq_desc *desc)
 {
-	struct wm831x *wm831x = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct wm831x *wm831x = get_irq_desc_chip_data(desc);
 	struct wm831x_irq_data *irq_data = irq_to_wm831x_irq(wm831x, irq);
 
 	wm831x->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
Index: linux-2.6/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-gru/grufile.c
+++ linux-2.6/drivers/misc/sgi-gru/grufile.c
@@ -348,7 +348,7 @@ static unsigned long gru_chiplet_cpu_to_
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(struct irq_desc *desc)
 {
 }
 
Index: linux-2.6/drivers/parisc/dino.c
===================================================================
--- linux-2.6.orig/drivers/parisc/dino.c
+++ linux-2.6/drivers/parisc/dino.c
@@ -296,9 +296,9 @@ static struct pci_port_ops dino_port_ops
 	.outl	= dino_out32
 };
 
-static void dino_disable_irq(unsigned int irq)
+static void dino_disable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
@@ -309,9 +309,9 @@ static void dino_disable_irq(unsigned in
 	__raw_writel(dino_dev->imr, dino_dev->hba.base_addr+DINO_IMR);
 }
 
-static void dino_enable_irq(unsigned int irq)
+static void dino_enable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct dino_device *dino_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
@@ -347,9 +347,9 @@ static void dino_enable_irq(unsigned int
 	}
 }
 
-static unsigned int dino_startup_irq(unsigned int irq)
+static unsigned int dino_startup_irq(struct irq_desc *desc)
 {
-	dino_enable_irq(irq);
+	dino_enable_irq(desc);
 	return 0;
 }
 
Index: linux-2.6/drivers/parisc/eisa.c
===================================================================
--- linux-2.6.orig/drivers/parisc/eisa.c
+++ linux-2.6/drivers/parisc/eisa.c
@@ -144,8 +144,9 @@ static unsigned int eisa_irq_level __rea
 
 
 /* called by free irq */
-static void eisa_disable_irq(unsigned int irq)
+static void eisa_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 
 	EISA_DBG("disable irq %d\n", irq);
@@ -164,8 +165,9 @@ static void eisa_disable_irq(unsigned in
 }
 
 /* called by request irq */
-static void eisa_enable_irq(unsigned int irq)
+static void eisa_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	EISA_DBG("enable irq %d\n", irq);
 		
@@ -182,9 +184,9 @@ static void eisa_enable_irq(unsigned int
 	EISA_DBG("pic1 mask %02x\n", eisa_in8(0xa1));
 }
 
-static unsigned int eisa_startup_irq(unsigned int irq)
+static unsigned int eisa_startup_irq(struct irq_desc *desc)
 {
-	eisa_enable_irq(irq);
+	eisa_enable_irq(desc);
 	return 0;
 }
 
Index: linux-2.6/drivers/parisc/gsc.c
===================================================================
--- linux-2.6.orig/drivers/parisc/gsc.c
+++ linux-2.6/drivers/parisc/gsc.c
@@ -106,9 +106,9 @@ int gsc_find_local_irq(unsigned int irq,
 	return NO_IRQ;
 }
 
-static void gsc_asic_disable_irq(unsigned int irq)
+static void gsc_asic_disable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
@@ -122,9 +122,9 @@ static void gsc_asic_disable_irq(unsigne
 	gsc_writel(imr, irq_dev->hpa + OFFSET_IMR);
 }
 
-static void gsc_asic_enable_irq(unsigned int irq)
+static void gsc_asic_enable_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct gsc_asic *irq_dev = desc->chip_data;
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
@@ -142,9 +142,9 @@ static void gsc_asic_enable_irq(unsigned
 	 */
 }
 
-static unsigned int gsc_asic_startup_irq(unsigned int irq)
+static unsigned int gsc_asic_startup_irq(struct irq_desc *desc)
 {
-	gsc_asic_enable_irq(irq);
+	gsc_asic_enable_irq(desc);
 	return 0;
 }
 
Index: linux-2.6/drivers/parisc/iosapic.c
===================================================================
--- linux-2.6.orig/drivers/parisc/iosapic.c
+++ linux-2.6/drivers/parisc/iosapic.c
@@ -622,8 +622,9 @@ static struct vector_info *iosapic_get_v
 	return desc->chip_data;
 }
 
-static void iosapic_disable_irq(unsigned int irq)
+static void iosapic_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned long flags;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1;
@@ -635,8 +636,9 @@ static void iosapic_disable_irq(unsigned
 	spin_unlock_irqrestore(&iosapic_lock, flags);
 }
 
-static void iosapic_enable_irq(unsigned int irq)
+static void iosapic_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1;
 
@@ -686,8 +688,9 @@ printk("\n");
  * i386/ia64 support ISA devices and have to deal with
  * edge-triggered interrupts too.
  */
-static void iosapic_end_irq(unsigned int irq)
+static void iosapic_end_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	DBG(KERN_DEBUG "end_irq(%d): eoi(%p, 0x%x)\n", irq,
 			vi->eoi_addr, vi->eoi_data);
@@ -695,16 +698,17 @@ static void iosapic_end_irq(unsigned int
 	cpu_end_irq(irq);
 }
 
-static unsigned int iosapic_startup_irq(unsigned int irq)
+static unsigned int iosapic_startup_irq(struct irq_desc *desc)
 {
-	iosapic_enable_irq(irq);
+	iosapic_enable_irq(desc);
 	return 0;
 }
 
 #ifdef CONFIG_SMP
-static int iosapic_set_affinity_irq(unsigned int irq,
+static int iosapic_set_affinity_irq(struct irq_desc *desc,
 				     const struct cpumask *dest)
 {
+	unsigned int irq = desc->irq;
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1, dummy_d0;
 	unsigned long flags;
Index: linux-2.6/drivers/parisc/superio.c
===================================================================
--- linux-2.6.orig/drivers/parisc/superio.c
+++ linux-2.6/drivers/parisc/superio.c
@@ -286,8 +286,9 @@ superio_init(struct pci_dev *pcidev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_87560_LIO, superio_init);
 
-static void superio_disable_irq(unsigned int irq)
+static void superio_disable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 r8;
 
 	if ((irq < 1) || (irq == 2) || (irq > 7)) {
@@ -303,8 +304,9 @@ static void superio_disable_irq(unsigned
 	outb (r8,IC_PIC1+1);
 }
 
-static void superio_enable_irq(unsigned int irq)
+static void superio_enable_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	u8 r8;
 
 	if ((irq < 1) || (irq == 2) || (irq > 7)) {
@@ -319,9 +321,9 @@ static void superio_enable_irq(unsigned
 	outb (r8,IC_PIC1+1);
 }
 
-static unsigned int superio_startup_irq(unsigned int irq)
+static unsigned int superio_startup_irq(struct irq_desc *desc)
 {
-	superio_enable_irq(irq);
+	superio_enable_irq(desc);
 	return 0;
 }
 
Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -1230,9 +1230,9 @@ const char *dmar_get_fault_reason(u8 fau
 	}
 }
 
-void dmar_msi_unmask(unsigned int irq)
+void dmar_msi_unmask(struct irq_desc *desc)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	/* unmask it */
@@ -1243,10 +1243,10 @@ void dmar_msi_unmask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_mask(unsigned int irq)
+void dmar_msi_mask(struct irq_desc *desc)
 {
 	unsigned long flag;
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 
 	/* mask it */
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1256,9 +1256,9 @@ void dmar_msi_mask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_write(int irq, struct msi_msg *msg)
+void dmar_msi_write(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1268,9 +1268,9 @@ void dmar_msi_write(int irq, struct msi_
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_read(int irq, struct msi_msg *msg)
+void dmar_msi_read(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
Index: linux-2.6/drivers/pci/htirq.c
===================================================================
--- linux-2.6.orig/drivers/pci/htirq.c
+++ linux-2.6/drivers/pci/htirq.c
@@ -33,9 +33,9 @@ struct ht_irq_cfg {
 };
 
 
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void write_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	unsigned long flags;
 	spin_lock_irqsave(&ht_irq_lock, flags);
 	if (cfg->msg.address_lo != msg->address_lo) {
@@ -47,39 +47,39 @@ void write_ht_irq_msg(unsigned int irq,
 		pci_write_config_dword(cfg->dev, cfg->pos + 4, msg->address_hi);
 	}
 	if (cfg->update)
-		cfg->update(cfg->dev, irq, msg);
+		cfg->update(cfg->dev, desc, msg);
 	spin_unlock_irqrestore(&ht_irq_lock, flags);
 	cfg->msg = *msg;
 }
 
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void fetch_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	*msg = cfg->msg;
 }
 
-void mask_ht_irq(unsigned int irq)
+void mask_ht_irq(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo |= 1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
-void unmask_ht_irq(unsigned int irq)
+void unmask_ht_irq(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo &= ~1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
 /**
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -169,9 +169,10 @@ static void msix_mask_irq(struct msi_des
 	desc->masked = __msix_mask_irq(desc, flag);
 }
 
-static void msi_set_mask_bit(unsigned irq, u32 flag)
+static void msi_set_mask_bit(struct irq_desc *descx, u32 flag)
 {
-	struct msi_desc *desc = get_irq_msi(irq);
+	unsigned int irq = descx->irq;
+	struct msi_desc *desc = get_irq_desc_msi(descx);
 
 	if (desc->msi_attrib.is_msix) {
 		msix_mask_irq(desc, flag);
@@ -182,14 +183,14 @@ static void msi_set_mask_bit(unsigned ir
 	}
 }
 
-void mask_msi_irq(unsigned int irq)
+void mask_msi_irq(struct irq_desc *desc)
 {
-	msi_set_mask_bit(irq, 1);
+	msi_set_mask_bit(desc, 1);
 }
 
-void unmask_msi_irq(unsigned int irq)
+void unmask_msi_irq(struct irq_desc *desc)
 {
-	msi_set_mask_bit(irq, 0);
+	msi_set_mask_bit(desc, 0);
 }
 
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
Index: linux-2.6/drivers/vlynq/vlynq.c
===================================================================
--- linux-2.6.orig/drivers/vlynq/vlynq.c
+++ linux-2.6/drivers/vlynq/vlynq.c
@@ -133,10 +133,11 @@ static void vlynq_reset(struct vlynq_dev
 	msleep(5);
 }
 
-static void vlynq_irq_unmask(unsigned int irq)
+static void vlynq_irq_unmask(struct irq_desc *desc)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 	int virq;
 
 	BUG_ON(!dev);
@@ -146,10 +147,11 @@ static void vlynq_irq_unmask(unsigned in
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static void vlynq_irq_mask(unsigned int irq)
+static void vlynq_irq_mask(struct irq_desc *desc)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 	int virq;
 
 	BUG_ON(!dev);
@@ -159,10 +161,11 @@ static void vlynq_irq_mask(unsigned int
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
+static int vlynq_irq_type(struct irq_desc *desc, unsigned int flow_type)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	unsigned int irq = desc->irq;
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 	int virq;
 
 	BUG_ON(!dev);
@@ -190,9 +193,9 @@ static int vlynq_irq_type(unsigned int i
 	return 0;
 }
 
-static void vlynq_local_ack(unsigned int irq)
+static void vlynq_local_ack(struct irq_desc *desc)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 
 	u32 status = readl(&dev->local->status);
 
@@ -201,9 +204,9 @@ static void vlynq_local_ack(unsigned int
 	writel(status, &dev->local->status);
 }
 
-static void vlynq_remote_ack(unsigned int irq)
+static void vlynq_remote_ack(struct irq_desc *desc)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = get_irq_desc_chip_data(desc);
 
 	u32 status = readl(&dev->remote->status);
 
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -725,11 +725,11 @@ static int rebind_irq_to_cpu(unsigned ir
 	return 0;
 }
 
-static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(struct irq_desc *desc, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
 
-	return rebind_irq_to_cpu(irq, tcpu);
+	return rebind_irq_to_cpu(desc->irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
@@ -748,35 +748,46 @@ int resend_irq_on_evtchn(unsigned int ir
 	return 1;
 }
 
-static void enable_dynirq(unsigned int irq)
+static void enable_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
 }
 
-static void disable_dynirq(unsigned int irq)
+static void unmask_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	enable_dynirq(desc);
+}
+
+
+static void disable_dynirq(struct irq_desc *desc)
+{
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		mask_evtchn(evtchn);
 }
 
-static void ack_dynirq(unsigned int irq)
+static void mask_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	disable_dynirq(desc);
+}
+
+static void ack_dynirq(struct irq_desc *desc)
+{
+	int evtchn = evtchn_from_irq(desc->irq);
 
-	move_native_irq(irq);
+	move_native_irq(desc);
 
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
 
-static int retrigger_dynirq(unsigned int irq)
+static int retrigger_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
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
@@ -187,10 +187,10 @@ static inline int set_msi_sid(struct irt
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */
-extern void dmar_msi_unmask(unsigned int irq);
-extern void dmar_msi_mask(unsigned int irq);
-extern void dmar_msi_read(int irq, struct msi_msg *msg);
-extern void dmar_msi_write(int irq, struct msi_msg *msg);
+extern void dmar_msi_unmask(struct irq_desc *);
+extern void dmar_msi_mask(struct irq_desc *);
+extern void dmar_msi_read(struct irq_desc *desc, struct msi_msg *msg);
+extern void dmar_msi_write(struct irq_desc *desc, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
Index: linux-2.6/include/linux/htirq.h
===================================================================
--- linux-2.6.orig/include/linux/htirq.h
+++ linux-2.6/include/linux/htirq.h
@@ -7,16 +7,17 @@ struct ht_irq_msg {
 };
 
 /* Helper functions.. */
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void mask_ht_irq(unsigned int irq);
-void unmask_ht_irq(unsigned int irq);
+struct irq_desc;
+void fetch_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void write_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void mask_ht_irq(struct irq_desc *);
+void unmask_ht_irq(struct irq_desc *);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
 
 /* For drivers of buggy hardware */
-typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
+typedef void (ht_irq_update_t)(struct pci_dev *dev, struct irq_desc *desc,
 			       struct ht_irq_msg *msg);
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update);
 
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -110,30 +110,31 @@ struct msi_desc;
  */
 struct irq_chip {
 	const char	*name;
-	unsigned int	(*startup)(unsigned int irq);
-	void		(*shutdown)(unsigned int irq);
-	void		(*enable)(unsigned int irq);
-	void		(*disable)(unsigned int irq);
-
-	void		(*ack)(unsigned int irq);
-	void		(*mask)(unsigned int irq);
-	void		(*mask_ack)(unsigned int irq);
-	void		(*unmask)(unsigned int irq);
-	void		(*eoi)(unsigned int irq);
+	unsigned int	(*startup)(struct irq_desc *desc);
+	void		(*shutdown)(struct irq_desc *desc);
+	void		(*enable)(struct irq_desc *desc);
+	void		(*disable)(struct irq_desc *desc);
+
+	void		(*ack)(struct irq_desc *desc);
+	void		(*mask)(struct irq_desc *desc);
+	void		(*mask_ack)(struct irq_desc *desc);
+	void		(*unmask)(struct irq_desc *desc);
+	void		(*eoi)(struct irq_desc *desc);
 
-	void		(*end)(unsigned int irq);
-	int		(*set_affinity)(unsigned int irq,
+	void		(*end)(struct irq_desc *desc);
+	int		(*set_affinity)(struct irq_desc *desc,
 					const struct cpumask *dest);
-	int		(*retrigger)(unsigned int irq);
-	int		(*set_type)(unsigned int irq, unsigned int flow_type);
-	int		(*set_wake)(unsigned int irq, unsigned int on);
+	int		(*retrigger)(struct irq_desc *desc);
 
-	void		(*bus_lock)(unsigned int irq);
-	void		(*bus_sync_unlock)(unsigned int irq);
+	int		(*set_type)(struct irq_desc *desc, unsigned int flow_type);
+	int		(*set_wake)(struct irq_desc *desc, unsigned int on);
+
+	void		(*bus_lock)(struct irq_desc *desc);
+	void		(*bus_sync_unlock)(struct irq_desc *desc);
 
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
-	void		(*release)(unsigned int irq, void *dev_id);
+	void		(*release)(struct irq_desc *desc, void *dev_id);
 #endif
 	/*
 	 * For compatibility, ->typename is copied into ->name.
@@ -241,8 +242,8 @@ extern void remove_irq(unsigned int irq,
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void move_native_irq(int irq);
-void move_masked_irq(int irq);
+void move_native_irq(struct irq_desc *desc);
+void move_masked_irq(struct irq_desc *desc);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
@@ -250,11 +251,11 @@ static inline void move_irq(int irq)
 {
 }
 
-static inline void move_native_irq(int irq)
+static inline void move_native_irq(struct irq_desc *desc)
 {
 }
 
-static inline void move_masked_irq(int irq)
+static inline void move_masked_irq(struct irq_desc *desc)
 {
 }
 
@@ -327,7 +328,7 @@ extern void note_interrupt(unsigned int
 			   irqreturn_t action_ret);
 
 /* Resending of interrupts :*/
-void check_irq_resend(struct irq_desc *desc, unsigned int irq);
+void check_irq_resend(struct irq_desc *desc);
 
 /* Enable/disable irq debugging output: */
 extern int noirqdebug_setup(char *str);
Index: linux-2.6/include/linux/msi.h
===================================================================
--- linux-2.6.orig/include/linux/msi.h
+++ linux-2.6/include/linux/msi.h
@@ -11,8 +11,8 @@ struct msi_msg {
 
 /* Helper functions */
 struct irq_desc;
-extern void mask_msi_irq(unsigned int irq);
-extern void unmask_msi_irq(unsigned int irq);
+extern void mask_msi_irq(struct irq_desc *);
+extern void unmask_msi_irq(struct irq_desc *);
 extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
Index: linux-2.6/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6.orig/kernel/irq/autoprobe.c
+++ linux-2.6/kernel/irq/autoprobe.c
@@ -58,8 +58,8 @@ unsigned long probe_irq_on(void)
 			 * progress:
 			 */
 			if (desc->chip->set_type)
-				desc->chip->set_type(i, IRQ_TYPE_PROBE);
-			desc->chip->startup(i);
+				desc->chip->set_type(desc, IRQ_TYPE_PROBE);
+			desc->chip->startup(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -76,7 +76,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->chip->startup(i))
+			if (desc->chip->startup(desc))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -98,7 +98,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->chip->shutdown(i);
+				desc->chip->shutdown(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -137,7 +137,7 @@ unsigned int probe_irq_mask(unsigned lon
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -181,7 +181,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc->chip->shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -131,7 +131,7 @@ int set_irq_chip(unsigned int irq, struc
 	unsigned long flags;
 
 	if (!desc) {
-		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
+		WARN(1, KERN_ERR "Trying to install chip for IRQ\n");
 		return -EINVAL;
 	}
 
@@ -287,40 +287,34 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread)
 /*
  * default enable function
  */
-static void default_enable(unsigned int irq)
+static void default_enable(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	desc->chip->unmask(irq);
+	desc->chip->unmask(desc);
 	desc->status &= ~IRQ_MASKED;
 }
 
 /*
  * default disable function
  */
-static void default_disable(unsigned int irq)
+static void default_disable(struct irq_desc *desc)
 {
 }
 
 /*
  * default startup function
  */
-static unsigned int default_startup(unsigned int irq)
+static unsigned int default_startup(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	desc->chip->enable(irq);
+	desc->chip->enable(desc);
 	return 0;
 }
 
 /*
  * default shutdown function
  */
-static void default_shutdown(unsigned int irq)
+static void default_shutdown(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	desc->chip->mask(irq);
+	desc->chip->mask(desc);
 	desc->status |= IRQ_MASKED;
 }
 
@@ -350,14 +344,14 @@ void irq_chip_set_defaults(struct irq_ch
 		chip->end = dummy_irq_chip.end;
 }
 
-static inline void mask_ack_irq(struct irq_desc *desc, int irq)
+static inline void mask_ack_irq(struct irq_desc *desc)
 {
 	if (desc->chip->mask_ack)
-		desc->chip->mask_ack(irq);
+		desc->chip->mask_ack(desc);
 	else {
-		desc->chip->mask(irq);
+		desc->chip->mask(desc);
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc->chip->ack(desc);
 	}
 }
 
@@ -459,7 +453,7 @@ handle_level_irq(unsigned int irq, struc
 	irqreturn_t action_ret;
 
 	raw_spin_lock(&desc->lock);
-	mask_ack_irq(desc, irq);
+	mask_ack_irq(desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -487,7 +481,7 @@ handle_level_irq(unsigned int irq, struc
 	if (unlikely(desc->status & IRQ_ONESHOT))
 		desc->status |= IRQ_MASKED;
 	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(irq);
+		desc->chip->unmask(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -525,7 +519,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
 		if (desc->chip->mask)
-			desc->chip->mask(irq);
+			desc->chip->mask(desc);
 		goto out;
 	}
 
@@ -540,7 +534,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->chip->eoi(irq);
+	desc->chip->eoi(desc);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -576,14 +570,14 @@ handle_edge_irq(unsigned int irq, struct
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		mask_ack_irq(desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -593,7 +587,7 @@ handle_edge_irq(unsigned int irq, struct
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			desc->chip->mask(irq);
+			desc->chip->mask(desc);
 			goto out_unlock;
 		}
 
@@ -605,7 +599,7 @@ handle_edge_irq(unsigned int irq, struct
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			desc->chip->unmask(irq);
+			desc->chip->unmask(desc);
 			desc->status &= ~IRQ_MASKED;
 		}
 
@@ -638,14 +632,14 @@ handle_percpu_irq(unsigned int irq, stru
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(desc);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
 	if (desc->chip->eoi)
-		desc->chip->eoi(irq);
+		desc->chip->eoi(desc);
 }
 
 void
@@ -657,7 +651,7 @@ __set_irq_handler(unsigned int irq, irq_
 
 	if (!desc) {
 		printk(KERN_ERR
-		       "Trying to install type control for IRQ%d\n", irq);
+		       "Trying to install type control for IRQ\n");
 		return;
 	}
 
@@ -676,13 +670,13 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->chip = &dummy_irq_chip;
 	}
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
 		if (desc->chip != &no_irq_chip)
-			mask_ack_irq(desc, irq);
+			mask_ack_irq(desc);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
@@ -693,10 +687,10 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->startup(irq);
+		desc->chip->startup(desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -38,9 +38,9 @@ struct lock_class_key irq_desc_lock_clas
  */
 void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
-	print_irq_desc(irq, desc);
+	print_irq_desc(desc);
 	kstat_incr_irqs_this_cpu(irq, desc);
-	ack_bad_irq(irq);
+	ack_bad_irq(desc);
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
@@ -292,22 +292,20 @@ void clear_kstat_irqs(struct irq_desc *d
  * What should we do if we get a hw irq event on an illegal vector?
  * Each architecture has to answer this themself.
  */
-static void ack_bad(unsigned int irq)
+static void ack_bad(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	print_irq_desc(irq, desc);
-	ack_bad_irq(irq);
+	print_irq_desc(desc);
+	ack_bad_irq(desc);
 }
 
 /*
  * NOP functions
  */
-static void noop(unsigned int irq)
+static void noop(struct irq_desc *desc)
 {
 }
 
-static unsigned int noop_ret(unsigned int irq)
+static unsigned int noop_ret(struct irq_desc *des)
 {
 	return 0;
 }
@@ -461,19 +459,19 @@ unsigned int __do_IRQ(unsigned int irq)
 		 * No locking required for CPU-local interrupts:
 		 */
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc->chip->ack(desc);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
 				note_interrupt(irq, desc, action_ret);
 		}
-		desc->chip->end(irq);
+		desc->chip->end(desc);
 		return 1;
 	}
 
 	raw_spin_lock(&desc->lock);
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc->chip->ack(desc);
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
@@ -533,7 +531,7 @@ out:
 	 * The ->end() handler has to deal with interrupts which got
 	 * disabled while the handler was running.
 	 */
-	desc->chip->end(irq);
+	desc->chip->end(desc);
 	raw_spin_unlock(&desc->lock);
 
 	return 1;
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -12,8 +12,8 @@ extern void compat_irq_chip_set_default_
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
-extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
-extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+extern void __disable_irq(struct irq_desc *desc, bool susp);
+extern void __enable_irq(struct irq_desc *desc, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
@@ -41,16 +41,16 @@ extern int irq_select_affinity_usr(unsig
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
 /* Inline functions for support of irq chips on slow busses */
-static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_lock(struct irq_desc *desc)
 {
 	if (unlikely(desc->chip->bus_lock))
-		desc->chip->bus_lock(irq);
+		desc->chip->bus_lock(desc);
 }
 
-static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 {
 	if (unlikely(desc->chip->bus_sync_unlock))
-		desc->chip->bus_sync_unlock(irq);
+		desc->chip->bus_sync_unlock(desc);
 }
 
 /*
@@ -61,10 +61,10 @@ static inline void chip_bus_sync_unlock(
 
 #define P(f) if (desc->status & f) printk("%14s set\n", #f)
 
-static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+static inline void print_irq_desc(struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+		desc->irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 	printk("->chip(): %p, ", desc->chip);
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -118,7 +118,7 @@ int irq_set_affinity(unsigned int irq, c
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!desc->chip->set_affinity(irq, cpumask)) {
+		if (!desc->chip->set_affinity(desc, cpumask)) {
 			cpumask_copy(desc->affinity, cpumask);
 			irq_set_thread_affinity(desc);
 		}
@@ -128,7 +128,7 @@ int irq_set_affinity(unsigned int irq, c
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	if (!desc->chip->set_affinity(irq, cpumask)) {
+	if (!desc->chip->set_affinity(desc, cpumask)) {
 		cpumask_copy(desc->affinity, cpumask);
 		irq_set_thread_affinity(desc);
 	}
@@ -161,7 +161,7 @@ static int setup_affinity(unsigned int i
 
 	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, desc->affinity);
+	desc->chip->set_affinity(desc, desc->affinity);
 
 	return 0;
 }
@@ -197,7 +197,7 @@ static inline int setup_affinity(unsigne
 }
 #endif
 
-void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+void __disable_irq(struct irq_desc *desc, bool suspend)
 {
 	if (suspend) {
 		if (!desc->action || (desc->action->flags & IRQF_TIMER))
@@ -207,7 +207,7 @@ void __disable_irq(struct irq_desc *desc
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		desc->chip->disable(desc);
 	}
 }
 
@@ -230,11 +230,11 @@ void disable_irq_nosync(unsigned int irq
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__disable_irq(desc, irq, false);
+	__disable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -263,7 +263,7 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
-void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
+void __enable_irq(struct irq_desc *desc, bool resume)
 {
 	if (resume)
 		desc->status &= ~IRQ_SUSPENDED;
@@ -271,7 +271,7 @@ void __enable_irq(struct irq_desc *desc,
 	switch (desc->depth) {
 	case 0:
  err_out:
-		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", desc->irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
@@ -280,7 +280,7 @@ void __enable_irq(struct irq_desc *desc,
 			goto err_out;
 		/* Prevent probing on this irq: */
 		desc->status = status | IRQ_NOPROBE;
-		check_irq_resend(desc, irq);
+		check_irq_resend(desc);
 		/* fall-through */
 	}
 	default:
@@ -307,21 +307,20 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__enable_irq(desc, irq, false);
+	__enable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
-static int set_irq_wake_real(unsigned int irq, unsigned int on)
+static int set_irq_wake_real(struct irq_desc *desc, unsigned int on)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
-		ret = desc->chip->set_wake(irq, on);
+		ret = desc->chip->set_wake(desc, on);
 
 	return ret;
 }
@@ -350,7 +349,7 @@ int set_irq_wake(unsigned int irq, unsig
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
 		if (desc->wake_depth++ == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 0;
 			else
@@ -360,7 +359,7 @@ int set_irq_wake(unsigned int irq, unsig
 		if (desc->wake_depth == 0) {
 			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 1;
 			else
@@ -425,7 +424,7 @@ int __irq_set_trigger(struct irq_desc *d
 	}
 
 	/* caller masked out all except trigger mode flags */
-	ret = chip->set_type(irq, flags);
+	ret = chip->set_type(desc, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
@@ -481,16 +480,16 @@ static int irq_wait_for_interrupt(struct
  * handler finished. unmask if the interrupt has not been disabled and
  * is marked MASKED.
  */
-static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+static void irq_finalize_oneshot(struct irq_desc *desc)
 {
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->chip->unmask(irq);
+		desc->chip->unmask(desc);
 	}
 	raw_spin_unlock_irq(&desc->lock);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 
 #ifdef CONFIG_SMP
@@ -562,7 +561,7 @@ static int irq_thread(void *data)
 			action->thread_fn(action->irq, action->dev_id);
 
 			if (oneshot)
-				irq_finalize_oneshot(action->irq, desc);
+				irq_finalize_oneshot(desc);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -738,7 +737,7 @@ __setup_irq(unsigned int irq, struct irq
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			desc->chip->startup(irq);
+			desc->chip->startup(desc);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
@@ -772,7 +771,7 @@ __setup_irq(unsigned int irq, struct irq
 	 */
 	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
 		desc->status &= ~IRQ_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq, false);
+		__enable_irq(desc, false);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -879,9 +878,9 @@ static struct irqaction *__free_irq(unsi
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
 		if (desc->chip->shutdown)
-			desc->chip->shutdown(irq);
+			desc->chip->shutdown(desc);
 		else
-			desc->chip->disable(irq);
+			desc->chip->disable(desc);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -950,9 +949,9 @@ void free_irq(unsigned int irq, void *de
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1059,9 +1058,9 @@ int request_threaded_irq(unsigned int ir
 	action->name = devname;
 	action->dev_id = dev_id;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 
 	if (retval)
 		kfree(action);
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -4,10 +4,8 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void move_masked_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
@@ -43,7 +41,7 @@ void move_masked_irq(int irq)
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids))
-		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+		if (!desc->chip->set_affinity(desc, desc->pending_mask)) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc);
 		}
@@ -51,18 +49,16 @@ void move_masked_irq(int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_native_irq(struct irq_desc *desc)
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
+	desc->chip->mask(desc);
+	move_masked_irq(desc);
+	desc->chip->unmask(desc);
 }
 
Index: linux-2.6/kernel/irq/pm.c
===================================================================
--- linux-2.6.orig/kernel/irq/pm.c
+++ linux-2.6/kernel/irq/pm.c
@@ -29,7 +29,7 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		__disable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
@@ -57,7 +57,7 @@ void resume_device_irqs(void)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__enable_irq(desc, irq, true);
+		__enable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
Index: linux-2.6/kernel/irq/resend.c
===================================================================
--- linux-2.6.orig/kernel/irq/resend.c
+++ linux-2.6/kernel/irq/resend.c
@@ -53,14 +53,14 @@ static DECLARE_TASKLET(resend_tasklet, r
  *
  * Is called with interrupts disabled and desc->lock held.
  */
-void check_irq_resend(struct irq_desc *desc, unsigned int irq)
+void check_irq_resend(struct irq_desc *desc)
 {
 	unsigned int status = desc->status;
 
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->chip->enable(irq);
+	desc->chip->enable(desc);
 
 	/*
 	 * We do not resend level type interrupts. Level type
@@ -70,10 +70,10 @@ void check_irq_resend(struct irq_desc *d
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
+		if (!desc->chip->retrigger || !desc->chip->retrigger(desc)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
-			set_bit(irq, irqs_resend);
+			set_bit(desc->irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
 #endif
 		}
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -79,7 +79,7 @@ static int try_one_irq(int irq, struct i
 	 * IRQ controller clean up too
 	 */
 	if (work && desc->chip && desc->chip->end)
-		desc->chip->end(irq);
+		desc->chip->end(desc);
 	raw_spin_unlock(&desc->lock);
 
 	return ok;
@@ -254,7 +254,7 @@ void note_interrupt(unsigned int irq, st
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->chip->disable(irq);
+		desc->chip->disable(desc);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
