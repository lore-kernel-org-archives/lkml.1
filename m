Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZCBMWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZCBMWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbZCBMWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:22:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:42979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZCBMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:21:46 -0500
Subject: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 13:21:17 +0100
Message-Id: <1235996477.5330.174.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Would you be willing to take such a patch?

Its a rather big one, but if you think its a good idea, I can generate
one against whatever tree is needed.

Provided I didn't break any !genirq stuff.. then again, that might be a
nice incentive to fix up those last few archs.

---
Subject: irq: remove IRQF_DISABLED
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Mar 02 10:45:53 CET 2009

People are playing odd games with IRQF_DISABLED, remove it.

Its not reliable, since shared interrupt lines could disable it for you,
and its possible and allowed for archs to disable IRQs to limit IRQ nesting.

Therefore, simply mandate that _ALL_ IRQ handlers are run with IRQs disabled.

[ This _should_ not break anything, since we've mandated that IRQ handlers
  _must_ be able to deal with this for a _long_ time ]

IRQ handlers should be fast, no if buts and any other exceptions. We also have
plenty instrumentation to find any offending IRQ latency sources.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/scsi/ChangeLog.ncr53c8xx         |    2 -
 Documentation/scsi/tmscsim.txt                 |    2 -
 arch/alpha/include/asm/floppy.h                |    2 -
 arch/alpha/kernel/irq.c                        |    8 +---
 arch/alpha/kernel/irq_alpha.c                  |    2 -
 arch/alpha/kernel/sys_jensen.c                 |    7 ---
 arch/alpha/kernel/sys_titan.c                  |   14 +++----
 arch/arm/common/time-acorn.c                   |    2 -
 arch/arm/include/asm/floppy.h                  |    2 -
 arch/arm/mach-aaec2000/core.c                  |    2 -
 arch/arm/mach-at91/at91rm9200_time.c           |    2 -
 arch/arm/mach-at91/at91sam926x_time.c          |    2 -
 arch/arm/mach-at91/at91x40_time.c              |    2 -
 arch/arm/mach-clps711x/time.c                  |    2 -
 arch/arm/mach-davinci/time.c                   |    4 +-
 arch/arm/mach-ebsa110/core.c                   |    2 -
 arch/arm/mach-ep93xx/core.c                    |    2 -
 arch/arm/mach-footbridge/dc21285-timer.c       |    2 -
 arch/arm/mach-footbridge/dc21285.c             |   10 ++---
 arch/arm/mach-footbridge/isa-timer.c           |    2 -
 arch/arm/mach-h720x/cpu-h7201.c                |    2 -
 arch/arm/mach-h720x/cpu-h7202.c                |    2 -
 arch/arm/mach-imx/time.c                       |    2 -
 arch/arm/mach-integrator/core.c                |    2 -
 arch/arm/mach-ixp2000/core.c                   |    2 -
 arch/arm/mach-ixp23xx/core.c                   |    2 -
 arch/arm/mach-ixp4xx/common.c                  |    2 -
 arch/arm/mach-ixp4xx/dsmg600-setup.c           |    2 -
 arch/arm/mach-ixp4xx/fsg-setup.c               |    4 +-
 arch/arm/mach-ixp4xx/nas100d-setup.c           |    2 -
 arch/arm/mach-ixp4xx/nslu2-setup.c             |    4 +-
 arch/arm/mach-ks8695/time.c                    |    2 -
 arch/arm/mach-lh7a40x/time.c                   |    2 -
 arch/arm/mach-msm/timer.c                      |    4 +-
 arch/arm/mach-netx/time.c                      |    2 -
 arch/arm/mach-ns9xxx/time-ns9360.c             |    2 -
 arch/arm/mach-omap1/pm.c                       |    2 -
 arch/arm/mach-omap1/time.c                     |    4 +-
 arch/arm/mach-omap1/timer32k.c                 |    2 -
 arch/arm/mach-omap2/timer-gp.c                 |    2 -
 arch/arm/mach-pnx4008/time.c                   |    2 -
 arch/arm/mach-pxa/am200epd.c                   |    2 -
 arch/arm/mach-pxa/cm-x270.c                    |    2 -
 arch/arm/mach-pxa/corgi.c                      |    2 -
 arch/arm/mach-pxa/dma.c                        |    2 -
 arch/arm/mach-pxa/em-x270.c                    |    2 -
 arch/arm/mach-pxa/magician.c                   |    2 -
 arch/arm/mach-pxa/mainstone.c                  |    2 -
 arch/arm/mach-pxa/mioa701.c                    |    2 -
 arch/arm/mach-pxa/palmtx.c                     |    2 -
 arch/arm/mach-pxa/palmz72.c                    |    2 -
 arch/arm/mach-pxa/pcm990-baseboard.c           |    2 -
 arch/arm/mach-pxa/poodle.c                     |    2 -
 arch/arm/mach-pxa/sharpsl_pm.c                 |    8 ++--
 arch/arm/mach-pxa/spitz.c                      |    2 -
 arch/arm/mach-pxa/time.c                       |    2 -
 arch/arm/mach-pxa/tosa.c                       |    2 -
 arch/arm/mach-pxa/trizeps4.c                   |    2 -
 arch/arm/mach-realview/core.c                  |    2 -
 arch/arm/mach-rpc/dma.c                        |    2 -
 arch/arm/mach-s3c2410/usb-simtec.c             |    2 -
 arch/arm/mach-sa1100/collie_pm.c               |    4 +-
 arch/arm/mach-sa1100/dma.c                     |    2 -
 arch/arm/mach-sa1100/h3600.c                   |    2 -
 arch/arm/mach-sa1100/time.c                    |    2 -
 arch/arm/mach-shark/core.c                     |    2 -
 arch/arm/mach-versatile/core.c                 |    2 -
 arch/arm/mach-w90x900/time.c                   |    2 -
 arch/arm/oprofile/op_model_arm11_core.c        |    2 -
 arch/arm/oprofile/op_model_mpcore.c            |    2 -
 arch/arm/oprofile/op_model_v7.c                |    2 -
 arch/arm/oprofile/op_model_xscale.c            |    2 -
 arch/arm/plat-iop/time.c                       |    2 -
 arch/arm/plat-mxc/time.c                       |    2 -
 arch/arm/plat-omap/dma.c                       |    2 -
 arch/arm/plat-omap/mailbox.c                   |    2 -
 arch/arm/plat-orion/time.c                     |    2 -
 arch/arm/plat-s3c/time.c                       |    2 -
 arch/arm/plat-s3c24xx/dma.c                    |    2 -
 arch/avr32/kernel/time.c                       |    2 -
 arch/blackfin/kernel/bfin_dma_5xx.c            |    2 -
 arch/blackfin/kernel/time-ts.c                 |    2 -
 arch/blackfin/kernel/time.c                    |    4 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c     |    2 -
 arch/blackfin/mach-bf537/boards/stamp.c        |    2 -
 arch/blackfin/mach-bf537/boards/tcm_bf537.c    |    2 -
 arch/blackfin/mach-bf561/boards/cm_bf561.c     |    2 -
 arch/blackfin/mach-bf561/smp.c                 |    2 -
 arch/cris/arch-v10/drivers/gpio.c              |    4 +-
 arch/cris/arch-v10/drivers/sync_serial.c       |    4 +-
 arch/cris/arch-v10/kernel/time.c               |    2 -
 arch/cris/arch-v32/drivers/mach-a3/gpio.c      |    2 -
 arch/cris/arch-v32/drivers/mach-fs/gpio.c      |    4 +-
 arch/cris/arch-v32/kernel/fasttimer.c          |    2 -
 arch/cris/arch-v32/kernel/smp.c                |    2 -
 arch/cris/arch-v32/kernel/time.c               |    2 -
 arch/cris/arch-v32/mach-a3/arbiter.c           |    4 +-
 arch/cris/arch-v32/mach-fs/arbiter.c           |    2 -
 arch/frv/kernel/irq-mb93091.c                  |    8 ++--
 arch/frv/kernel/irq-mb93093.c                  |    2 -
 arch/frv/kernel/irq-mb93493.c                  |    4 +-
 arch/frv/kernel/time.c                         |    2 -
 arch/h8300/kernel/timer/itu.c                  |    2 -
 arch/h8300/kernel/timer/timer16.c              |    2 -
 arch/h8300/kernel/timer/timer8.c               |    2 -
 arch/h8300/kernel/timer/tpu.c                  |    2 -
 arch/ia64/hp/sim/simserial.c                   |    2 -
 arch/ia64/kernel/irq_ia64.c                    |    8 ++--
 arch/ia64/kernel/mca.c                         |   12 +++---
 arch/ia64/kernel/perfmon.c                     |    2 -
 arch/ia64/kernel/time.c                        |    2 -
 arch/ia64/xen/irq_xen.c                        |    6 +--
 arch/m32r/kernel/time.c                        |    2 -
 arch/m68k/include/asm/floppy.h                 |    2 -
 arch/m68k/include/asm/sun3xflop.h              |    2 -
 arch/m68knommu/platform/68328/timers.c         |    2 -
 arch/m68knommu/platform/68360/config.c         |    2 -
 arch/m68knommu/platform/coldfire/pit.c         |    2 -
 arch/m68knommu/platform/coldfire/timers.c      |    4 +-
 arch/mips/alchemy/common/dbdma.c               |    2 -
 arch/mips/alchemy/common/time.c                |    2 -
 arch/mips/basler/excite/excite_iodev.c         |    2 -
 arch/mips/dec/setup.c                          |    2 -
 arch/mips/include/asm/mach-generic/floppy.h    |    2 -
 arch/mips/include/asm/mach-jazz/floppy.h       |    2 -
 arch/mips/jazz/irq.c                           |    2 -
 arch/mips/kernel/cevt-bcm1480.c                |    2 -
 arch/mips/kernel/cevt-ds1287.c                 |    2 -
 arch/mips/kernel/cevt-gt641xx.c                |    2 -
 arch/mips/kernel/cevt-r4k.c                    |    2 -
 arch/mips/kernel/cevt-sb1250.c                 |    2 -
 arch/mips/kernel/cevt-txx9.c                   |    2 -
 arch/mips/kernel/i8253.c                       |    2 -
 arch/mips/kernel/rtlx.c                        |    2 -
 arch/mips/kernel/smtc.c                        |    2 -
 arch/mips/mti-malta/malta-int.c                |    4 +-
 arch/mips/nxp/pnx8550/common/int.c             |    4 +-
 arch/mips/nxp/pnx8550/common/time.c            |    4 +-
 arch/mips/pci/ops-pmcmsp.c                     |    2 -
 arch/mips/pci/ops-tx3927.c                     |    2 -
 arch/mips/pci/pci-tx4927.c                     |    2 -
 arch/mips/pci/pci-tx4938.c                     |    2 -
 arch/mips/pci/pci-tx4939.c                     |    2 -
 arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c    |    2 -
 arch/mips/sgi-ip22/ip22-int.c                  |   10 ++---
 arch/mips/sgi-ip27/ip27-timer.c                |    2 -
 arch/mips/sgi-ip32/ip32-irq.c                  |    4 +-
 arch/mips/sni/irq.c                            |    2 -
 arch/mips/sni/time.c                           |    2 -
 arch/mips/txx9/generic/pci.c                   |    2 -
 arch/mn10300/kernel/mn10300-serial.c           |    6 +--
 arch/mn10300/kernel/time.c                     |    2 -
 arch/parisc/include/asm/floppy.h               |    4 +-
 arch/parisc/kernel/irq.c                       |    4 +-
 arch/powerpc/include/asm/floppy.h              |    4 +-
 arch/powerpc/kernel/smp.c                      |    2 -
 arch/powerpc/platforms/cell/beat.c             |    2 -
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 -
 arch/powerpc/platforms/cell/interrupt.c        |    2 -
 arch/powerpc/platforms/cell/iommu.c            |    2 -
 arch/powerpc/platforms/cell/pmu.c              |    2 -
 arch/powerpc/platforms/cell/spu_base.c         |    6 +--
 arch/powerpc/platforms/powermac/pic.c          |    2 -
 arch/powerpc/platforms/powermac/smp.c          |    2 -
 arch/powerpc/platforms/ps3/device-init.c       |    2 -
 arch/powerpc/platforms/ps3/smp.c               |    2 -
 arch/powerpc/platforms/pseries/xics.c          |    4 +-
 arch/powerpc/sysdev/ppc4xx_soc.c               |    2 -
 arch/sh/boards/mach-cayman/irq.c               |    4 +-
 arch/sh/boards/mach-hp6xx/hp6xx_apm.c          |    2 -
 arch/sh/boards/mach-snapgear/setup.c           |    2 -
 arch/sh/drivers/dma/dma-g2.c                   |    2 -
 arch/sh/drivers/dma/dma-pvr2.c                 |    2 -
 arch/sh/drivers/dma/dma-sh.c                   |    4 +-
 arch/sh/drivers/dma/dmabrg.c                   |    6 +--
 arch/sh/drivers/pci/pci-sh5.c                  |    4 +-
 arch/sh/drivers/push-switch.c                  |    2 -
 arch/sh/kernel/cpu/sh4a/smp-shx3.c             |    2 -
 arch/sh/kernel/time_64.c                       |    2 -
 arch/sh/kernel/timers/timer-cmt.c              |    2 -
 arch/sh/kernel/timers/timer-mtu2.c             |    2 -
 arch/sh/kernel/timers/timer-tmu.c              |    2 -
 arch/sparc/include/asm/floppy_32.h             |    2 -
 arch/sparc/include/asm/floppy_64.h             |    2 -
 arch/sparc/kernel/irq_32.c                     |   13 +-----
 arch/sparc/kernel/pcic.c                       |    2 -
 arch/sparc/kernel/sun4c_irq.c                  |    2 -
 arch/sparc/kernel/sun4d_irq.c                  |   15 +------
 arch/sparc/kernel/sun4m_irq.c                  |    2 -
 arch/um/drivers/line.c                         |    4 +-
 arch/um/drivers/mconsole_kern.c                |    2 -
 arch/um/drivers/net_kern.c                     |    2 -
 arch/um/drivers/port_kern.c                    |    4 +-
 arch/um/drivers/random.c                       |    2 -
 arch/um/drivers/ubd_kern.c                     |    2 -
 arch/um/drivers/xterm_kern.c                   |    2 -
 arch/um/kernel/sigio.c                         |    2 -
 arch/um/kernel/time.c                          |    2 -
 arch/x86/include/asm/floppy.h                  |    4 +-
 arch/x86/kernel/hpet.c                         |    2 -
 arch/x86/kernel/mfgpt_32.c                     |    2 -
 arch/x86/kernel/setup.c                        |    2 -
 arch/x86/kernel/time_64.c                      |    2 -
 arch/x86/kernel/vmiclock_32.c                  |    2 -
 arch/x86/xen/smp.c                             |    8 ++--
 arch/x86/xen/spinlock.c                        |    2 -
 arch/x86/xen/time.c                            |    2 -
 arch/xtensa/kernel/time.c                      |    2 -
 drivers/ata/pata_mpc52xx.c                     |    2 -
 drivers/atm/he.c                               |    2 -
 drivers/atm/idt77252.c                         |    2 -
 drivers/atm/nicstar.c                          |    2 -
 drivers/atm/solos-pci.c                        |    2 -
 drivers/block/cciss.c                          |    2 -
 drivers/block/cpqarray.c                       |    2 -
 drivers/block/hd.c                             |    2 -
 drivers/cdrom/gdrom.c                          |    4 +-
 drivers/char/amiserial.c                       |    2 -
 drivers/char/cyclades.c                        |    2 -
 drivers/char/hpet.c                            |    3 -
 drivers/char/hvc_irq.c                         |    2 -
 drivers/char/hvcs.c                            |    2 -
 drivers/char/hvsi.c                            |    2 -
 drivers/char/ipmi/ipmi_si_intf.c               |    4 +-
 drivers/char/isicom.c                          |    2 -
 drivers/char/nwbutton.c                        |    2 -
 drivers/char/riscom8.c                         |    2 -
 drivers/char/rtc.c                             |    2 -
 drivers/char/snsc.c                            |    2 -
 drivers/char/snsc_event.c                      |    2 -
 drivers/char/specialix.c                       |    4 +-
 drivers/char/sx.c                              |    4 +-
 drivers/char/tlclk.c                           |    2 -
 drivers/char/vme_scc.c                         |   48 ++++++++++++-------------
 drivers/clocksource/tcb_clksrc.c               |    2 -
 drivers/edac/mpc85xx_edac.c                    |    6 +--
 drivers/edac/mv64x60_edac.c                    |    8 ++--
 drivers/i2c/busses/i2c-bfin-twi.c              |    4 +-
 drivers/i2c/busses/i2c-highlander.c            |    2 -
 drivers/i2c/busses/i2c-pmcmsp.c                |    2 -
 drivers/i2c/busses/i2c-pxa.c                   |    2 -
 drivers/i2c/busses/i2c-s3c2410.c               |    2 -
 drivers/i2c/busses/i2c-sh7760.c                |    2 -
 drivers/i2c/busses/i2c-sh_mobile.c             |    2 -
 drivers/infiniband/hw/ehca/ehca_eq.c           |    4 +-
 drivers/input/keyboard/corgikbd.c              |    2 -
 drivers/input/keyboard/jornada720_kbd.c        |    2 -
 drivers/input/keyboard/pxa27x_keypad.c         |    2 -
 drivers/input/keyboard/pxa930_rotary.c         |    2 -
 drivers/input/keyboard/spitzkbd.c              |   12 +++---
 drivers/input/keyboard/tosakbd.c               |    2 -
 drivers/input/misc/ixp4xx-beeper.c             |    2 -
 drivers/input/mouse/pxa930_trkball.c           |    2 -
 drivers/input/touchscreen/atmel_tsadcc.c       |    2 -
 drivers/input/touchscreen/corgi_ts.c           |    2 -
 drivers/input/touchscreen/h3600_ts_input.c     |    4 +-
 drivers/input/touchscreen/hp680_ts_input.c     |    2 -
 drivers/input/touchscreen/jornada720_ts.c      |    2 -
 drivers/isdn/hardware/eicon/divasmain.c        |    2 -
 drivers/isdn/sc/init.c                         |    2 -
 drivers/media/common/saa7146_core.c            |    2 -
 drivers/media/dvb/bt8xx/bt878.c                |    2 -
 drivers/media/video/bt8xx/bttv-driver.c        |    2 -
 drivers/media/video/cx18/cx18-driver.c         |    2 -
 drivers/media/video/cx23885/cx23885-core.c     |    2 -
 drivers/media/video/cx88/cx88-alsa.c           |    2 -
 drivers/media/video/cx88/cx88-mpeg.c           |    2 -
 drivers/media/video/cx88/cx88-video.c          |    2 -
 drivers/media/video/ivtv/ivtv-driver.c         |    2 -
 drivers/media/video/meye.c                     |    2 -
 drivers/media/video/saa7134/saa7134-alsa.c     |    2 -
 drivers/media/video/saa7134/saa7134-core.c     |    2 -
 drivers/media/video/sh_mobile_ceu_camera.c     |    2 -
 drivers/media/video/stradis.c                  |    2 -
 drivers/media/video/zoran/zoran_card.c         |    2 -
 drivers/mfd/da903x.c                           |    2 -
 drivers/mfd/menelaus.c                         |    2 -
 drivers/misc/phantom.c                         |    2 -
 drivers/mmc/host/omap_hsmmc.c                  |    4 +-
 drivers/mmc/host/tmio_mmc.c                    |    2 -
 drivers/mtd/nand/pxa3xx_nand.c                 |    2 -
 drivers/mtd/nand/tmio_nand.c                   |    2 -
 drivers/net/bfin_mac.c                         |    2 -
 drivers/net/ehea/ehea_main.c                   |    6 +--
 drivers/net/fec.c                              |    8 ++--
 drivers/net/hamradio/baycom_ser_fdx.c          |    2 -
 drivers/net/hamradio/baycom_ser_hdx.c          |    2 -
 drivers/net/hamradio/scc.c                     |    2 -
 drivers/net/hamradio/yam.c                     |    2 -
 drivers/net/hp100.c                            |    2 -
 drivers/net/irda/donauboe.c                    |    4 +-
 drivers/net/jazzsonic.c                        |    2 -
 drivers/net/korina.c                           |    8 ++--
 drivers/net/pasemi_mac.c                       |    4 +-
 drivers/net/ps3_gelic_net.c                    |    2 -
 drivers/net/smsc911x.c                         |    2 -
 drivers/net/smsc9420.c                         |    2 -
 drivers/net/sun3lance.c                        |    2 -
 drivers/net/tulip/de4x5.c                      |    2 -
 drivers/net/wan/hostess_sv11.c                 |    2 -
 drivers/net/wan/sealevel.c                     |    2 -
 drivers/net/xtsonic.c                          |    2 -
 drivers/parisc/superio.c                       |    2 -
 drivers/pcmcia/soc_common.c                    |    2 -
 drivers/pnp/resource.c                         |    2 -
 drivers/ps3/ps3-vuart.c                        |    2 -
 drivers/ps3/ps3stor_lib.c                      |    2 -
 drivers/rtc/rtc-at91rm9200.c                   |    2 -
 drivers/rtc/rtc-at91sam9.c                     |    2 -
 drivers/rtc/rtc-cmos.c                         |    2 -
 drivers/rtc/rtc-ds1511.c                       |    2 -
 drivers/rtc/rtc-ds1553.c                       |    2 -
 drivers/rtc/rtc-omap.c                         |    4 +-
 drivers/rtc/rtc-pl030.c                        |    2 -
 drivers/rtc/rtc-pl031.c                        |    2 -
 drivers/rtc/rtc-pxa.c                          |    4 +-
 drivers/rtc/rtc-s3c.c                          |    4 +-
 drivers/rtc/rtc-sa1100.c                       |    6 +--
 drivers/rtc/rtc-sh.c                           |    6 +--
 drivers/rtc/rtc-stk17ta8.c                     |    2 -
 drivers/rtc/rtc-tx4939.c                       |    2 -
 drivers/rtc/rtc-vr41xx.c                       |    4 +-
 drivers/scsi/NCR5380.c                         |    2 -
 drivers/scsi/aacraid/rx.c                      |    2 -
 drivers/scsi/aacraid/sa.c                      |    2 -
 drivers/scsi/aha152x.c                         |    4 +-
 drivers/scsi/aic7xxx_old.c                     |    2 -
 drivers/scsi/arm/acornscsi.c                   |    2 -
 drivers/scsi/arm/cumana_1.c                    |    2 -
 drivers/scsi/arm/cumana_2.c                    |    2 -
 drivers/scsi/arm/powertec.c                    |    2 -
 drivers/scsi/dtc.c                             |    2 -
 drivers/scsi/eata.c                            |    2 -
 drivers/scsi/eata_pio.c                        |    4 +-
 drivers/scsi/g_NCR5380.c                       |    2 -
 drivers/scsi/gdth.c                            |    6 +--
 drivers/scsi/ibmvscsi/ibmvstgt.c               |    2 -
 drivers/scsi/in2000.c                          |    2 -
 drivers/scsi/initio.c                          |    2 -
 drivers/scsi/pas16.c                           |    2 -
 drivers/scsi/qla1280.c                         |    2 -
 drivers/scsi/qla2xxx/qla_isr.c                 |    2 -
 drivers/scsi/qla4xxx/ql4_os.c                  |    2 -
 drivers/scsi/t128.c                            |    2 -
 drivers/scsi/u14-34f.c                         |    2 -
 drivers/scsi/wd7000.c                          |    2 -
 drivers/serial/68328serial.c                   |    2 -
 drivers/serial/bfin_5xx.c                      |    4 +-
 drivers/serial/crisv10.c                       |   18 ++++-----
 drivers/serial/icom.c                          |    2 -
 drivers/serial/jsm/jsm_driver.c                |    2 -
 drivers/serial/mcf.c                           |    2 -
 drivers/serial/mpc52xx_uart.c                  |    2 -
 drivers/serial/serial_ks8695.c                 |    8 ++--
 drivers/serial/sh-sci.c                        |    4 +-
 drivers/serial/sn_console.c                    |    2 -
 drivers/serial/uartlite.c                      |    2 -
 drivers/spi/spi_imx.c                          |    2 -
 drivers/staging/me4000/me4000.c                |    6 +--
 drivers/staging/meilhaus/me0600_ext_irq.c      |    6 ---
 drivers/staging/meilhaus/me1400_ext_irq.c      |    6 ---
 drivers/staging/meilhaus/me4600_ai.c           |    6 ---
 drivers/staging/meilhaus/me4600_ao.c           |    6 ---
 drivers/staging/meilhaus/me4600_ext_irq.c      |    6 ---
 drivers/staging/meilhaus/me6000_ao.c           |    6 ---
 drivers/staging/meilhaus/me8100_di.c           |    6 ---
 drivers/staging/meilhaus/me8200_di.c           |   12 +-----
 drivers/staging/meilhaus/me8200_do.c           |    6 ---
 drivers/uio/uio_cif.c                          |    2 -
 drivers/uio/uio_pdrv_genirq.c                  |    1 
 drivers/uio/uio_sercos3.c                      |    2 -
 drivers/usb/core/hcd-pci.c                     |    2 -
 drivers/usb/core/hcd.c                         |    7 ---
 drivers/usb/gadget/at91_udc.c                  |    4 +-
 drivers/usb/gadget/imx_udc.c                   |    2 -
 drivers/usb/gadget/lh7a40x_udc.c               |    2 -
 drivers/usb/gadget/m66592-udc.c                |    2 -
 drivers/usb/gadget/omap_udc.c                  |    2 -
 drivers/usb/gadget/pxa25x_udc.c                |    8 ++--
 drivers/usb/gadget/s3c2410_udc.c               |    4 +-
 drivers/usb/host/ehci-au1xxx.c                 |    2 -
 drivers/usb/host/ehci-fsl.c                    |    2 -
 drivers/usb/host/ehci-orion.c                  |    2 -
 drivers/usb/host/ehci-ps3.c                    |    2 -
 drivers/usb/host/fhci-hcd.c                    |    4 +-
 drivers/usb/host/isp116x-hcd.c                 |    2 -
 drivers/usb/host/isp1760-if.c                  |    4 +-
 drivers/usb/host/ohci-at91.c                   |    2 -
 drivers/usb/host/ohci-au1xxx.c                 |    2 -
 drivers/usb/host/ohci-ep93xx.c                 |    2 -
 drivers/usb/host/ohci-lh7a404.c                |    2 -
 drivers/usb/host/ohci-omap.c                   |    2 -
 drivers/usb/host/ohci-pnx4008.c                |    2 -
 drivers/usb/host/ohci-pnx8550.c                |    2 -
 drivers/usb/host/ohci-ppc-of.c                 |    2 -
 drivers/usb/host/ohci-ppc-soc.c                |    2 -
 drivers/usb/host/ohci-ps3.c                    |    2 -
 drivers/usb/host/ohci-pxa27x.c                 |    2 -
 drivers/usb/host/ohci-s3c2410.c                |    2 -
 drivers/usb/host/ohci-sa1111.c                 |    2 -
 drivers/usb/host/ohci-sh.c                     |    2 -
 drivers/usb/host/ohci-sm501.c                  |    2 -
 drivers/usb/host/ohci-ssb.c                    |    2 -
 drivers/usb/host/ohci-tmio.c                   |    2 -
 drivers/usb/host/r8a66597-hcd.c                |    2 -
 drivers/usb/host/sl811-hcd.c                   |    2 -
 drivers/usb/musb/musbhsdma.c                   |    2 -
 drivers/usb/otg/isp1301_omap.c                 |    2 -
 drivers/video/au1200fb.c                       |    2 -
 drivers/video/bf54x-lq043fb.c                  |    2 -
 drivers/video/bfin-t350mcqb-fb.c               |    2 -
 drivers/video/mb862xx/mb862xxfb.c              |    4 +-
 drivers/video/ps3fb.c                          |    2 -
 drivers/video/pxafb.c                          |    2 -
 drivers/video/s3c2410fb.c                      |    2 -
 drivers/video/sa1100fb.c                       |    2 -
 drivers/video/sh_mobile_lcdcfb.c               |    2 -
 drivers/video/tmiofb.c                         |    2 -
 drivers/w1/masters/ds1wm.c                     |    2 -
 drivers/w1/masters/omap_hdq.c                  |    2 -
 drivers/watchdog/eurotechwdt.c                 |    2 -
 drivers/watchdog/mpcore_wdt.c                  |    2 -
 drivers/watchdog/rm9k_wdt.c                    |    2 -
 drivers/watchdog/sb_wdog.c                     |    4 +-
 drivers/watchdog/wdt.c                         |    2 -
 drivers/watchdog/wdt_pci.c                     |    2 -
 include/linux/interrupt.h                      |    2 -
 include/net/irda/irda_device.h                 |    2 -
 include/sound/initval.h                        |    2 -
 kernel/irq/handle.c                            |    4 --
 kernel/irq/manage.c                            |   20 ----------
 sound/arm/aaci.c                               |    2 -
 sound/arm/pxa2xx-ac97-lib.c                    |    2 -
 sound/drivers/ml403-ac97cr.c                   |    4 +-
 sound/drivers/mpu401/mpu401.c                  |    3 -
 sound/drivers/mtpav.c                          |    2 -
 sound/drivers/serial-u16550.c                  |    2 -
 sound/isa/ad1816a/ad1816a.c                    |    2 -
 sound/isa/ad1816a/ad1816a_lib.c                |    2 -
 sound/isa/als100.c                             |    2 -
 sound/isa/azt2320.c                            |    2 -
 sound/isa/cs423x/cs4231.c                      |    3 -
 sound/isa/cs423x/cs4236.c                      |    2 -
 sound/isa/dt019x.c                             |    3 -
 sound/isa/es1688/es1688.c                      |    2 -
 sound/isa/es1688/es1688_lib.c                  |    2 -
 sound/isa/es18xx.c                             |    2 -
 sound/isa/gus/gus_main.c                       |    2 -
 sound/isa/gus/gusextreme.c                     |    2 -
 sound/isa/gus/gusmax.c                         |    2 -
 sound/isa/gus/interwave.c                      |    2 -
 sound/isa/opl3sa2.c                            |    2 -
 sound/isa/opti9xx/miro.c                       |    2 -
 sound/isa/opti9xx/opti92x-ad1848.c             |    4 +-
 sound/isa/sb/sb_common.c                       |    2 -
 sound/isa/sc6000.c                             |    2 -
 sound/isa/sgalaxy.c                            |    2 -
 sound/isa/sscape.c                             |    2 -
 sound/isa/wavefront/wavefront.c                |    4 +-
 sound/isa/wss/wss_lib.c                        |    2 -
 sound/mips/au1x00.c                            |    4 +-
 sound/oss/sh_dac_audio.c                       |    2 -
 sound/pci/sis7019.c                            |    4 +-
 sound/ppc/snd_ps3.c                            |    2 -
 sound/soc/s3c24xx/s3c2443-ac97.c               |    2 -
 sound/sparc/amd7930.c                          |    2 -
 466 files changed, 623 insertions(+), 730 deletions(-)

Index: linux-2.6/Documentation/scsi/ChangeLog.ncr53c8xx
===================================================================
--- linux-2.6.orig/Documentation/scsi/ChangeLog.ncr53c8xx
+++ linux-2.6/Documentation/scsi/ChangeLog.ncr53c8xx
@@ -196,7 +196,7 @@ Sun Feb  14:00 1999 Gerard Roudier (grou
 	- Allow to tune request_irq() flags from the boot command line using 
 	  ncr53c8xx=irqm:??, as follows:
 	  a) If bit 0x10 is set in irqm, IRQF_SHARED flag is not used.
-	  b) If bit 0x20 is set in irqm, IRQF_DISABLED flag is not used.
+	  b) If bit 0x20 is set in irqm, 0 flag is not used.
 	  By default the driver uses both IRQF_SHARED and IRQF_DISABLED.
 	  Option 'ncr53c8xx=irqm:0x20' may be used when an IRQ is shared by 
 	  a 53C8XX adapter and a network board.
Index: linux-2.6/Documentation/scsi/tmscsim.txt
===================================================================
--- linux-2.6.orig/Documentation/scsi/tmscsim.txt
+++ linux-2.6/Documentation/scsi/tmscsim.txt
@@ -109,7 +109,7 @@ than the 33.33 MHz being in the PCI spec
 
 If you want to share the IRQ with another device and the driver refuses to
 do so, you might succeed with changing the DC390_IRQ type in tmscsim.c to 
-IRQF_SHARED | IRQF_DISABLED.
+IRQF_SHARED .
 
 
 3.Features
Index: linux-2.6/arch/alpha/include/asm/floppy.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/floppy.h
+++ linux-2.6/arch/alpha/include/asm/floppy.h
@@ -26,7 +26,7 @@
 #define fd_disable_irq()        disable_irq(FLOPPY_IRQ)
 #define fd_cacheflush(addr,size) /* nothing */
 #define fd_request_irq()        request_irq(FLOPPY_IRQ, floppy_interrupt,\
-					    IRQF_DISABLED, "floppy", NULL)
+					    0, "floppy", NULL)
 #define fd_free_irq()           free_irq(FLOPPY_IRQ, NULL);
 
 #ifdef CONFIG_PCI
Index: linux-2.6/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq.c
+++ linux-2.6/arch/alpha/kernel/irq.c
@@ -93,14 +93,10 @@ show_interrupts(struct seq_file *p, void
 			seq_printf(p, "%10u ", kstat_irqs_cpu(irq, j));
 #endif
 		seq_printf(p, " %14s", irq_desc[irq].chip->typename);
-		seq_printf(p, "  %c%s",
-			(action->flags & IRQF_DISABLED)?'+':' ',
-			action->name);
+		seq_printf(p, "  %c%s", '+', action->name);
 
 		for (action=action->next; action; action = action->next) {
-			seq_printf(p, ", %c%s",
-				  (action->flags & IRQF_DISABLED)?'+':' ',
-				   action->name);
+			seq_printf(p, ", %c%s", '+', action->name);
 		}
 
 		seq_putc(p, '\n');
Index: linux-2.6/arch/alpha/kernel/irq_alpha.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_alpha.c
+++ linux-2.6/arch/alpha/kernel/irq_alpha.c
@@ -223,7 +223,7 @@ static unsigned int rtc_startup(unsigned
 
 struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "timer",
 };
 
Index: linux-2.6/arch/alpha/kernel/sys_jensen.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_jensen.c
+++ linux-2.6/arch/alpha/kernel/sys_jensen.c
@@ -68,13 +68,6 @@ jensen_local_startup(unsigned int irq)
 	/* the parport is really hw IRQ 1, silly Jensen.  */
 	if (irq == 7)
 		i8259a_startup_irq(1);
-	else
-		/*
-		 * For all true local interrupts, set the flag that prevents
-		 * the IPL from being dropped during handler processing.
-		 */
-		if (irq_desc[irq].action)
-			irq_desc[irq].action->flags |= IRQF_DISABLED;
 	return 0;
 }
 
Index: linux-2.6/arch/alpha/kernel/sys_titan.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_titan.c
+++ linux-2.6/arch/alpha/kernel/sys_titan.c
@@ -291,15 +291,15 @@ titan_late_init(void)
 	 * all reported to the kernel as machine checks, so the handler
 	 * is a nop so it can be called to count the individual events.
 	 */
-	titan_request_irq(63+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(63+16, titan_intr_nop, 0,
 		    "CChip Error", NULL);
-	titan_request_irq(62+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(62+16, titan_intr_nop, 0,
 		    "PChip 0 H_Error", NULL);
-	titan_request_irq(61+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(61+16, titan_intr_nop, 0,
 		    "PChip 1 H_Error", NULL);
-	titan_request_irq(60+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(60+16, titan_intr_nop, 0,
 		    "PChip 0 C_Error", NULL);
-	titan_request_irq(59+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(59+16, titan_intr_nop, 0,
 		    "PChip 1 C_Error", NULL);
 
 	/* 
@@ -358,9 +358,9 @@ privateer_init_pci(void)
 	 * Hook a couple of extra err interrupts that the
 	 * common titan code won't.
 	 */
-	titan_request_irq(53+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(53+16, titan_intr_nop, 0,
 		    "NMI", NULL);
-	titan_request_irq(50+16, titan_intr_nop, IRQF_DISABLED,
+	titan_request_irq(50+16, titan_intr_nop, 0,
 		    "Temperature Warning", NULL);
 
 	/*
Index: linux-2.6/arch/arm/common/time-acorn.c
===================================================================
--- linux-2.6.orig/arch/arm/common/time-acorn.c
+++ linux-2.6/arch/arm/common/time-acorn.c
@@ -75,7 +75,7 @@ ioc_timer_interrupt(int irq, void *dev_i
 
 static struct irqaction ioc_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.handler	= ioc_timer_interrupt
 };
 
Index: linux-2.6/arch/arm/include/asm/floppy.h
===================================================================
--- linux-2.6.orig/arch/arm/include/asm/floppy.h
+++ linux-2.6/arch/arm/include/asm/floppy.h
@@ -25,7 +25,7 @@
 
 #define fd_inb(port)		inb((port))
 #define fd_request_irq()	request_irq(IRQ_FLOPPYDISK,floppy_interrupt,\
-					    IRQF_DISABLED,"floppy",NULL)
+					    0,"floppy",NULL)
 #define fd_free_irq()		free_irq(IRQ_FLOPPYDISK,NULL)
 #define fd_disable_irq()	disable_irq(IRQ_FLOPPYDISK)
 #define fd_enable_irq()		enable_irq(IRQ_FLOPPYDISK)
Index: linux-2.6/arch/arm/mach-aaec2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-aaec2000/core.c
+++ linux-2.6/arch/arm/mach-aaec2000/core.c
@@ -138,7 +138,7 @@ aaec2000_timer_interrupt(int irq, void *
 
 static struct irqaction aaec2000_timer_irq = {
 	.name		= "AAEC-2000 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= aaec2000_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-at91/at91rm9200_time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/at91rm9200_time.c
+++ linux-2.6/arch/arm/mach-at91/at91rm9200_time.c
@@ -81,7 +81,7 @@ static irqreturn_t at91rm9200_timer_inte
 
 static struct irqaction at91rm9200_timer_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= at91rm9200_timer_interrupt
 };
 
Index: linux-2.6/arch/arm/mach-at91/at91sam926x_time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/at91sam926x_time.c
+++ linux-2.6/arch/arm/mach-at91/at91sam926x_time.c
@@ -122,7 +122,7 @@ static irqreturn_t at91sam926x_pit_inter
 
 static struct irqaction at91sam926x_pit_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_SHARED | IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_SHARED | IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= at91sam926x_pit_interrupt
 };
 
Index: linux-2.6/arch/arm/mach-at91/at91x40_time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/at91x40_time.c
+++ linux-2.6/arch/arm/mach-at91/at91x40_time.c
@@ -49,7 +49,7 @@ static irqreturn_t at91x40_timer_interru
 
 static struct irqaction at91x40_timer_irq = {
 	.name		= "at91_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= at91x40_timer_interrupt
 };
 
Index: linux-2.6/arch/arm/mach-clps711x/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-clps711x/time.c
+++ linux-2.6/arch/arm/mach-clps711x/time.c
@@ -56,7 +56,7 @@ p720t_timer_interrupt(int irq, void *dev
 
 static struct irqaction clps711x_timer_irq = {
 	.name		= "CLPS711x Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= p720t_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-davinci/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-davinci/time.c
+++ linux-2.6/arch/arm/mach-davinci/time.c
@@ -159,7 +159,7 @@ static struct timer_s timers[] = {
 		.name      = "clockevent",
 		.opts      = TIMER_OPTS_DISABLED,
 		.irqaction = {
-			.flags   = IRQF_DISABLED | IRQF_TIMER,
+			.flags   = IRQF_TIMER,
 			.handler = timer_interrupt,
 		}
 	},
@@ -168,7 +168,7 @@ static struct timer_s timers[] = {
 		.period     = ~0,
 		.opts       = TIMER_OPTS_PERIODIC,
 		.irqaction = {
-			.flags   = IRQF_DISABLED | IRQF_TIMER,
+			.flags   = IRQF_TIMER,
 			.handler = freerun_interrupt,
 		}
 	},
Index: linux-2.6/arch/arm/mach-ebsa110/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ebsa110/core.c
+++ linux-2.6/arch/arm/mach-ebsa110/core.c
@@ -195,7 +195,7 @@ ebsa110_timer_interrupt(int irq, void *d
 
 static struct irqaction ebsa110_timer_irq = {
 	.name		= "EBSA110 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ebsa110_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-ep93xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ep93xx/core.c
+++ linux-2.6/arch/arm/mach-ep93xx/core.c
@@ -115,7 +115,7 @@ static int ep93xx_timer_interrupt(int ir
 
 static struct irqaction ep93xx_timer_irq = {
 	.name		= "ep93xx timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ep93xx_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-footbridge/dc21285-timer.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/dc21285-timer.c
+++ linux-2.6/arch/arm/mach-footbridge/dc21285-timer.c
@@ -41,7 +41,7 @@ timer1_interrupt(int irq, void *dev_id)
 static struct irqaction footbridge_timer_irq = {
 	.name		= "Timer1 timer tick",
 	.handler	= timer1_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 /*
Index: linux-2.6/arch/arm/mach-footbridge/dc21285.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/dc21285.c
+++ linux-2.6/arch/arm/mach-footbridge/dc21285.c
@@ -338,15 +338,15 @@ void __init dc21285_preinit(void)
 	/*
 	 * We don't care if these fail.
 	 */
-	dc21285_request_irq(IRQ_PCI_SERR, dc21285_serr_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_SERR, dc21285_serr_irq, 0,
 			    "PCI system error", &serr_timer);
-	dc21285_request_irq(IRQ_PCI_PERR, dc21285_parity_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_PERR, dc21285_parity_irq, 0,
 			    "PCI parity error", &perr_timer);
-	dc21285_request_irq(IRQ_PCI_ABORT, dc21285_abort_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_ABORT, dc21285_abort_irq, 0,
 			    "PCI abort", NULL);
-	dc21285_request_irq(IRQ_DISCARD_TIMER, dc21285_discard_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_DISCARD_TIMER, dc21285_discard_irq, 0,
 			    "Discard timer", NULL);
-	dc21285_request_irq(IRQ_PCI_DPERR, dc21285_dparity_irq, IRQF_DISABLED,
+	dc21285_request_irq(IRQ_PCI_DPERR, dc21285_dparity_irq, 0,
 			    "PCI data parity", NULL);
 
 	if (cfn_mode) {
Index: linux-2.6/arch/arm/mach-footbridge/isa-timer.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-footbridge/isa-timer.c
+++ linux-2.6/arch/arm/mach-footbridge/isa-timer.c
@@ -71,7 +71,7 @@ isa_timer_interrupt(int irq, void *dev_i
 static struct irqaction isa_timer_irq = {
 	.name		= "ISA timer tick",
 	.handler	= isa_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 static void __init isa_timer_init(void)
Index: linux-2.6/arch/arm/mach-h720x/cpu-h7201.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/cpu-h7201.c
+++ linux-2.6/arch/arm/mach-h720x/cpu-h7201.c
@@ -37,7 +37,7 @@ h7201_timer_interrupt(int irq, void *dev
 
 static struct irqaction h7201_timer_irq = {
 	.name		= "h7201 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= h7201_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-h720x/cpu-h7202.c
+++ linux-2.6/arch/arm/mach-h720x/cpu-h7202.c
@@ -166,7 +166,7 @@ static struct irq_chip h7202_timerx_chip
 
 static struct irqaction h7202_timer_irq = {
 	.name		= "h7202 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= h7202_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-imx/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-imx/time.c
+++ linux-2.6/arch/arm/mach-imx/time.c
@@ -55,7 +55,7 @@ imx_timer_interrupt(int irq, void *dev_i
 
 static struct irqaction imx_timer_irq = {
 	.name		= "i.MX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= imx_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-integrator/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/core.c
+++ linux-2.6/arch/arm/mach-integrator/core.c
@@ -297,7 +297,7 @@ integrator_timer_interrupt(int irq, void
 
 static struct irqaction integrator_timer_irq = {
 	.name		= "Integrator Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= integrator_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-ixp2000/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp2000/core.c
+++ linux-2.6/arch/arm/mach-ixp2000/core.c
@@ -213,7 +213,7 @@ static int ixp2000_timer_interrupt(int i
 
 static struct irqaction ixp2000_timer_irq = {
 	.name		= "IXP2000 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ixp2000_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-ixp23xx/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp23xx/core.c
+++ linux-2.6/arch/arm/mach-ixp23xx/core.c
@@ -359,7 +359,7 @@ ixp23xx_timer_interrupt(int irq, void *d
 static struct irqaction ixp23xx_timer_irq = {
 	.name		= "IXP23xx Timer Tick",
 	.handler	= ixp23xx_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 void __init ixp23xx_init_timer(void)
Index: linux-2.6/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6/arch/arm/mach-ixp4xx/common.c
@@ -279,7 +279,7 @@ static irqreturn_t ixp4xx_timer_interrup
 
 static struct irqaction ixp4xx_timer_irq = {
 	.name		= "timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ixp4xx_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-ixp4xx/dsmg600-setup.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/dsmg600-setup.c
+++ linux-2.6/arch/arm/mach-ixp4xx/dsmg600-setup.c
@@ -239,7 +239,7 @@ static void __init dsmg600_init(void)
 	pm_power_off = dsmg600_power_off;
 
 	if (request_irq(gpio_to_irq(DSMG600_RB_GPIO), &dsmg600_reset_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_LOW,
+		 IRQF_TRIGGER_LOW,
 		"DSM-G600 reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
Index: linux-2.6/arch/arm/mach-ixp4xx/fsg-setup.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/fsg-setup.c
+++ linux-2.6/arch/arm/mach-ixp4xx/fsg-setup.c
@@ -203,7 +203,7 @@ static void __init fsg_init(void)
 	platform_add_devices(fsg_devices, ARRAY_SIZE(fsg_devices));
 
 	if (request_irq(gpio_to_irq(FSG_RB_GPIO), &fsg_reset_handler,
-			IRQF_DISABLED | IRQF_TRIGGER_LOW,
+			 IRQF_TRIGGER_LOW,
 			"FSG reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
@@ -211,7 +211,7 @@ static void __init fsg_init(void)
 	}
 
 	if (request_irq(gpio_to_irq(FSG_SB_GPIO), &fsg_power_handler,
-			IRQF_DISABLED | IRQF_TRIGGER_LOW,
+			 IRQF_TRIGGER_LOW,
 			"FSG power button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Power Button IRQ %d not available\n",
Index: linux-2.6/arch/arm/mach-ixp4xx/nas100d-setup.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/nas100d-setup.c
+++ linux-2.6/arch/arm/mach-ixp4xx/nas100d-setup.c
@@ -258,7 +258,7 @@ static void __init nas100d_init(void)
 	pm_power_off = nas100d_power_off;
 
 	if (request_irq(gpio_to_irq(NAS100D_RB_GPIO), &nas100d_reset_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_LOW,
+		 IRQF_TRIGGER_LOW,
 		"NAS100D reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
Index: linux-2.6/arch/arm/mach-ixp4xx/nslu2-setup.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ixp4xx/nslu2-setup.c
+++ linux-2.6/arch/arm/mach-ixp4xx/nslu2-setup.c
@@ -244,7 +244,7 @@ static void __init nslu2_init(void)
 	pm_power_off = nslu2_power_off;
 
 	if (request_irq(gpio_to_irq(NSLU2_RB_GPIO), &nslu2_reset_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_LOW,
+		 IRQF_TRIGGER_LOW,
 		"NSLU2 reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
@@ -252,7 +252,7 @@ static void __init nslu2_init(void)
 	}
 
 	if (request_irq(gpio_to_irq(NSLU2_PB_GPIO), &nslu2_power_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_HIGH,
+		 IRQF_TRIGGER_HIGH,
 		"NSLU2 power button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Power Button IRQ %d not available\n",
Index: linux-2.6/arch/arm/mach-ks8695/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ks8695/time.c
+++ linux-2.6/arch/arm/mach-ks8695/time.c
@@ -76,7 +76,7 @@ static irqreturn_t ks8695_timer_interrup
 
 static struct irqaction ks8695_timer_irq = {
 	.name		= "ks8695_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		=  IRQF_TIMER,
 	.handler	= ks8695_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-lh7a40x/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-lh7a40x/time.c
+++ linux-2.6/arch/arm/mach-lh7a40x/time.c
@@ -49,7 +49,7 @@ lh7a40x_timer_interrupt(int irq, void *d
 
 static struct irqaction lh7a40x_timer_irq = {
 	.name		= "LHA740x Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= lh7a40x_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-msm/timer.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-msm/timer.c
+++ linux-2.6/arch/arm/mach-msm/timer.c
@@ -125,7 +125,7 @@ static struct msm_clock msm_clocks[] = {
 		},
 		.irq = {
 			.name    = "gp_timer",
-			.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_RISING,
+			.flags   =  IRQF_TIMER | IRQF_TRIGGER_RISING,
 			.handler = msm_timer_interrupt,
 			.dev_id  = &msm_clocks[0].clockevent,
 			.irq     = INT_GP_TIMER_EXP
@@ -152,7 +152,7 @@ static struct msm_clock msm_clocks[] = {
 		},
 		.irq = {
 			.name    = "dg_timer",
-			.flags   = IRQF_DISABLED | IRQF_TIMER | IRQF_TRIGGER_RISING,
+			.flags   =  IRQF_TIMER | IRQF_TRIGGER_RISING,
 			.handler = msm_timer_interrupt,
 			.dev_id  = &msm_clocks[1].clockevent,
 			.irq     = INT_DEBUG_TIMER_EXP
Index: linux-2.6/arch/arm/mach-netx/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-netx/time.c
+++ linux-2.6/arch/arm/mach-netx/time.c
@@ -100,7 +100,7 @@ netx_timer_interrupt(int irq, void *dev_
 
 static struct irqaction netx_timer_irq = {
 	.name		= "NetX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= netx_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-ns9xxx/time-ns9360.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-ns9xxx/time-ns9360.c
+++ linux-2.6/arch/arm/mach-ns9xxx/time-ns9360.c
@@ -121,7 +121,7 @@ static irqreturn_t ns9360_clockevent_han
 
 static struct irqaction ns9360_clockevent_action = {
 	.name		= "ns9360-timer" __stringify(TIMER_CLOCKEVENT),
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ns9360_clockevent_handler,
 };
 
Index: linux-2.6/arch/arm/mach-omap1/pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/pm.c
+++ linux-2.6/arch/arm/mach-omap1/pm.c
@@ -640,7 +640,7 @@ static irqreturn_t omap_wakeup_interrupt
 
 static struct irqaction omap_wakeup_irq = {
 	.name		= "peripheral wakeup",
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.handler	= omap_wakeup_interrupt
 };
 
Index: linux-2.6/arch/arm/mach-omap1/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/time.c
+++ linux-2.6/arch/arm/mach-omap1/time.c
@@ -157,7 +157,7 @@ static irqreturn_t omap_mpu_timer1_inter
 
 static struct irqaction omap_mpu_timer1_irq = {
 	.name		= "mpu_timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_mpu_timer1_interrupt,
 };
 
@@ -194,7 +194,7 @@ static irqreturn_t omap_mpu_timer2_inter
 
 static struct irqaction omap_mpu_timer2_irq = {
 	.name		= "mpu_timer2",
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.handler	= omap_mpu_timer2_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-omap1/timer32k.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap1/timer32k.c
+++ linux-2.6/arch/arm/mach-omap1/timer32k.c
@@ -171,7 +171,7 @@ static irqreturn_t omap_32k_timer_interr
 
 static struct irqaction omap_32k_timer_irq = {
 	.name		= "32KHz timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_32k_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-omap2/timer-gp.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/timer-gp.c
+++ linux-2.6/arch/arm/mach-omap2/timer-gp.c
@@ -52,7 +52,7 @@ static irqreturn_t omap2_gp_timer_interr
 
 static struct irqaction omap2_gp_timer_irq = {
 	.name		= "gp timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap2_gp_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-pnx4008/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pnx4008/time.c
+++ linux-2.6/arch/arm/mach-pnx4008/time.c
@@ -78,7 +78,7 @@ static irqreturn_t pnx4008_timer_interru
 
 static struct irqaction pnx4008_timer_irq = {
 	.name = "PNX4008 Tick Timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags =  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler = pnx4008_timer_interrupt
 };
 
Index: linux-2.6/arch/arm/mach-pxa/am200epd.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/am200epd.c
+++ linux-2.6/arch/arm/mach-pxa/am200epd.c
@@ -293,7 +293,7 @@ static int am200_setup_irq(struct fb_inf
 	int ret;
 
 	ret = request_irq(IRQ_GPIO(RDY_GPIO_PIN), am200_handle_irq,
-				IRQF_DISABLED|IRQF_TRIGGER_FALLING,
+				IRQF_TRIGGER_FALLING,
 				"AM200", info->par);
 	if (ret)
 		dev_err(&am200_device->dev, "request_irq failed: %d\n", ret);
Index: linux-2.6/arch/arm/mach-pxa/cm-x270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/cm-x270.c
+++ linux-2.6/arch/arm/mach-pxa/cm-x270.c
@@ -286,7 +286,7 @@ static int cmx270_mci_init(struct device
 	gpio_direction_output(GPIO105_MMC_POWER, 0);
 
 	err = request_irq(CMX270_MMC_IRQ, cmx270_detect_int,
-			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+			   IRQF_TRIGGER_FALLING,
 			  "MMC card detect", data);
 	if (err) {
 		gpio_free(GPIO105_MMC_POWER);
Index: linux-2.6/arch/arm/mach-pxa/corgi.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/corgi.c
+++ linux-2.6/arch/arm/mach-pxa/corgi.c
@@ -333,7 +333,7 @@ static int corgi_mci_init(struct device 
 	corgi_mci_platform_data.detect_delay = msecs_to_jiffies(250);
 
 	err = request_irq(CORGI_IRQ_GPIO_nSD_DETECT, corgi_detect_int,
-				IRQF_DISABLED | IRQF_TRIGGER_RISING |
+				 IRQF_TRIGGER_RISING |
 				IRQF_TRIGGER_FALLING,
 				"MMC card detect", data);
 	if (err) {
Index: linux-2.6/arch/arm/mach-pxa/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/dma.c
+++ linux-2.6/arch/arm/mach-pxa/dma.c
@@ -131,7 +131,7 @@ int __init pxa_init_dma(int num_ch)
 		dma_channels[i].prio = min((i & 0xf) >> 2, DMA_PRIO_LOW);
 	}
 
-	ret = request_irq(IRQ_DMA, dma_irq_handler, IRQF_DISABLED, "DMA", NULL);
+	ret = request_irq(IRQ_DMA, dma_irq_handler, 0, "DMA", NULL);
 	if (ret) {
 		printk (KERN_CRIT "Wow!  Can't register IRQ for DMA\n");
 		kfree(dma_channels);
Index: linux-2.6/arch/arm/mach-pxa/em-x270.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/em-x270.c
+++ linux-2.6/arch/arm/mach-pxa/em-x270.c
@@ -400,7 +400,7 @@ static int em_x270_mci_init(struct devic
 			    void *data)
 {
 	int err = request_irq(EM_X270_MMC_CD, em_x270_detect_int,
-			      IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+			       IRQF_TRIGGER_FALLING,
 			      "MMC card detect", data);
 	if (err) {
 		printk(KERN_ERR "%s: can't request MMC card detect IRQ: %d\n",
Index: linux-2.6/arch/arm/mach-pxa/magician.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/magician.c
+++ linux-2.6/arch/arm/mach-pxa/magician.c
@@ -619,7 +619,7 @@ static int magician_mci_init(struct devi
 	int err;
 
 	err = request_irq(IRQ_MAGICIAN_SD, detect_irq,
-				IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
+				 IRQF_SAMPLE_RANDOM,
 				"MMC card detect", data);
 	if (err)
 		goto err_request_irq;
Index: linux-2.6/arch/arm/mach-pxa/mainstone.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mainstone.c
+++ linux-2.6/arch/arm/mach-pxa/mainstone.c
@@ -423,7 +423,7 @@ static int mainstone_mci_init(struct dev
 	 */
 	MST_MSCWR1 &= ~MST_MSCWR1_MS_SEL;
 
-	err = request_irq(MAINSTONE_MMC_IRQ, mstone_detect_int, IRQF_DISABLED,
+	err = request_irq(MAINSTONE_MMC_IRQ, mstone_detect_int, 0,
 			     "MMC card detect", data);
 	if (err)
 		printk(KERN_ERR "mainstone_mci_init: MMC/SD: can't request MMC card detect IRQ\n");
Index: linux-2.6/arch/arm/mach-pxa/mioa701.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/mioa701.c
+++ linux-2.6/arch/arm/mach-pxa/mioa701.c
@@ -497,7 +497,7 @@ static int mci_init(struct device *dev, 
 		goto err_gpio;
 	/* enable RE/FE interrupt on card insertion and removal */
 	rc = request_irq(irq, detect_int,
-			 IRQF_DISABLED | IRQF_TRIGGER_RISING |
+			  IRQF_TRIGGER_RISING |
 			 IRQF_TRIGGER_FALLING,
 			 "MMC card detect", data);
 	if (rc)
Index: linux-2.6/arch/arm/mach-pxa/palmtx.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/palmtx.c
+++ linux-2.6/arch/arm/mach-pxa/palmtx.c
@@ -146,7 +146,7 @@ static int palmtx_mci_init(struct device
 	if (err)
 		goto err2;
 	err = request_irq(gpio_to_irq(GPIO_NR_PALMTX_SD_DETECT_N),
-			palmtx_detect_int, IRQF_DISABLED | IRQF_SAMPLE_RANDOM |
+			palmtx_detect_int,  IRQF_SAMPLE_RANDOM |
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			"SD/MMC card detect", data);
 	if (err) {
Index: linux-2.6/arch/arm/mach-pxa/palmz72.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/palmz72.c
+++ linux-2.6/arch/arm/mach-pxa/palmz72.c
@@ -139,7 +139,7 @@ static int palmz72_mci_init(struct devic
 	if (err)
 		goto err2;
 	err = request_irq(gpio_to_irq(GPIO_NR_PALMZ72_SD_DETECT_N),
-			palmz72_detect_int, IRQF_DISABLED | IRQF_SAMPLE_RANDOM |
+			palmz72_detect_int,  IRQF_SAMPLE_RANDOM |
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			"SD/MMC card detect", data);
 	if (err) {
Index: linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/pcm990-baseboard.c
+++ linux-2.6/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -293,7 +293,7 @@ static int pcm990_mci_init(struct device
 {
 	int err;
 
-	err = request_irq(PCM027_MMCDET_IRQ, mci_detect_int, IRQF_DISABLED,
+	err = request_irq(PCM027_MMCDET_IRQ, mci_detect_int, 0,
 			     "MMC card detect", data);
 	if (err)
 		printk(KERN_ERR "pcm990_mci_init: MMC/SD: can't request MMC "
Index: linux-2.6/arch/arm/mach-pxa/poodle.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/poodle.c
+++ linux-2.6/arch/arm/mach-pxa/poodle.c
@@ -290,7 +290,7 @@ static int poodle_mci_init(struct device
 	poodle_mci_platform_data.detect_delay = msecs_to_jiffies(250);
 
 	err = request_irq(POODLE_IRQ_GPIO_nSD_DETECT, poodle_detect_int,
-			  IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+			   IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 			  "MMC card detect", data);
 	if (err) {
 		pr_err("%s: MMC/SD: can't request MMC card detect IRQ\n",
Index: linux-2.6/arch/arm/mach-pxa/sharpsl_pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/sharpsl_pm.c
+++ linux-2.6/arch/arm/mach-pxa/sharpsl_pm.c
@@ -152,18 +152,18 @@ void sharpsl_pm_pxa_init(void)
 	pxa_gpio_mode(sharpsl_pm.machinfo->gpio_batlock | GPIO_IN);
 
 	/* Register interrupt handlers */
-	if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_acin), sharpsl_ac_isr, IRQF_DISABLED, "AC Input Detect", sharpsl_ac_isr)) {
+	if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_acin), sharpsl_ac_isr, 0, "AC Input Detect", sharpsl_ac_isr)) {
 		dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", IRQ_GPIO(sharpsl_pm.machinfo->gpio_acin));
 	}
 	else set_irq_type(IRQ_GPIO(sharpsl_pm.machinfo->gpio_acin),IRQ_TYPE_EDGE_BOTH);
 
-	if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batlock), sharpsl_fatal_isr, IRQF_DISABLED, "Battery Cover", sharpsl_fatal_isr)) {
+	if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batlock), sharpsl_fatal_isr, 0, "Battery Cover", sharpsl_fatal_isr)) {
 		dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", IRQ_GPIO(sharpsl_pm.machinfo->gpio_batlock));
 	}
 	else set_irq_type(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batlock),IRQ_TYPE_EDGE_FALLING);
 
 	if (sharpsl_pm.machinfo->gpio_fatal) {
-		if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_fatal), sharpsl_fatal_isr, IRQF_DISABLED, "Fatal Battery", sharpsl_fatal_isr)) {
+		if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_fatal), sharpsl_fatal_isr, 0, "Fatal Battery", sharpsl_fatal_isr)) {
 			dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", IRQ_GPIO(sharpsl_pm.machinfo->gpio_fatal));
 		}
 		else set_irq_type(IRQ_GPIO(sharpsl_pm.machinfo->gpio_fatal),IRQ_TYPE_EDGE_FALLING);
@@ -172,7 +172,7 @@ void sharpsl_pm_pxa_init(void)
 	if (sharpsl_pm.machinfo->batfull_irq)
 	{
 		/* Register interrupt handler. */
-		if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull), sharpsl_chrg_full_isr, IRQF_DISABLED, "CO", sharpsl_chrg_full_isr)) {
+		if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull), sharpsl_chrg_full_isr, 0, "CO", sharpsl_chrg_full_isr)) {
 			dev_err(sharpsl_pm.dev, "Could not get irq %d.\n", IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull));
 		}
 		else set_irq_type(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull),IRQ_TYPE_EDGE_RISING);
Index: linux-2.6/arch/arm/mach-pxa/spitz.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/spitz.c
+++ linux-2.6/arch/arm/mach-pxa/spitz.c
@@ -449,7 +449,7 @@ static int spitz_mci_init(struct device 
 	spitz_mci_platform_data.detect_delay = msecs_to_jiffies(250);
 
 	err = request_irq(SPITZ_IRQ_GPIO_nSD_DETECT, spitz_detect_int,
-			  IRQF_DISABLED | IRQF_TRIGGER_RISING |
+			   IRQF_TRIGGER_RISING |
 			  IRQF_TRIGGER_FALLING,
 			  "MMC card detect", data);
 	if (err) {
Index: linux-2.6/arch/arm/mach-pxa/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/time.c
+++ linux-2.6/arch/arm/mach-pxa/time.c
@@ -142,7 +142,7 @@ static struct clocksource cksrc_pxa_oscr
 
 static struct irqaction pxa_ost0_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= pxa_ost0_interrupt,
 	.dev_id		= &ckevt_pxa_osmr0,
 };
Index: linux-2.6/arch/arm/mach-pxa/tosa.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/tosa.c
+++ linux-2.6/arch/arm/mach-pxa/tosa.c
@@ -265,7 +265,7 @@ static int tosa_mci_init(struct device *
 		goto err_gpio_detect_dir;
 
 	err = request_irq(TOSA_IRQ_GPIO_nSD_DETECT, tosa_detect_int,
-			  IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+			   IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				"MMC/SD card detect", data);
 	if (err) {
 		printk(KERN_ERR "tosa_mci_init: MMC/SD: can't request MMC card detect IRQ\n");
Index: linux-2.6/arch/arm/mach-pxa/trizeps4.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-pxa/trizeps4.c
+++ linux-2.6/arch/arm/mach-pxa/trizeps4.c
@@ -348,7 +348,7 @@ static int trizeps4_mci_init(struct devi
 	int err;
 
 	err = request_irq(TRIZEPS4_MMC_IRQ, mci_detect_int,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_SAMPLE_RANDOM,
+		 IRQF_TRIGGER_RISING | IRQF_SAMPLE_RANDOM,
 		"MMC card detect", data);
 	if (err) {
 		printk(KERN_ERR "trizeps4_mci_init: MMC/SD: can't request"
Index: linux-2.6/arch/arm/mach-realview/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-realview/core.c
+++ linux-2.6/arch/arm/mach-realview/core.c
@@ -657,7 +657,7 @@ static irqreturn_t realview_timer_interr
 
 static struct irqaction realview_timer_irq = {
 	.name		= "RealView Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= realview_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-rpc/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-rpc/dma.c
+++ linux-2.6/arch/arm/mach-rpc/dma.c
@@ -128,7 +128,7 @@ static irqreturn_t iomd_dma_handle(int i
 static int iomd_request_dma(dmach_t channel, dma_t *dma)
 {
 	return request_irq(dma->dma_irq, iomd_dma_handle,
-			   IRQF_DISABLED, dma->device_id, dma);
+			   0, dma->device_id, dma);
 }
 
 static void iomd_free_dma(dmach_t channel, dma_t *dma)
Index: linux-2.6/arch/arm/mach-s3c2410/usb-simtec.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-s3c2410/usb-simtec.c
+++ linux-2.6/arch/arm/mach-s3c2410/usb-simtec.c
@@ -79,7 +79,7 @@ static void usb_simtec_enableoc(struct s
 
 	if (on) {
 		ret = request_irq(IRQ_USBOC, usb_simtec_ocirq,
-				  IRQF_DISABLED | IRQF_TRIGGER_RISING |
+				   IRQF_TRIGGER_RISING |
 				   IRQF_TRIGGER_FALLING,
 				  "USB Over-current", info);
 		if (ret != 0) {
Index: linux-2.6/arch/arm/mach-sa1100/collie_pm.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/collie_pm.c
+++ linux-2.6/arch/arm/mach-sa1100/collie_pm.c
@@ -46,12 +46,12 @@ static void collie_charger_init(void)
 		ad_revise = sharpsl_param.adadj;
 
 	/* Register interrupt handler. */
-	if ((err = request_irq(COLLIE_IRQ_GPIO_AC_IN, sharpsl_ac_isr, IRQF_DISABLED,
+	if ((err = request_irq(COLLIE_IRQ_GPIO_AC_IN, sharpsl_ac_isr, 0,
 			       "ACIN", sharpsl_ac_isr))) {
 		printk("Could not get irq %d.\n", COLLIE_IRQ_GPIO_AC_IN);
 		return;
 	}
-	if ((err = request_irq(COLLIE_IRQ_GPIO_CO, sharpsl_chrg_full_isr, IRQF_DISABLED,
+	if ((err = request_irq(COLLIE_IRQ_GPIO_CO, sharpsl_chrg_full_isr, 0,
 			       "CO", sharpsl_chrg_full_isr))) {
 		free_irq(COLLIE_IRQ_GPIO_AC_IN, sharpsl_ac_isr);
 		printk("Could not get irq %d.\n", COLLIE_IRQ_GPIO_CO);
Index: linux-2.6/arch/arm/mach-sa1100/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/dma.c
+++ linux-2.6/arch/arm/mach-sa1100/dma.c
@@ -124,7 +124,7 @@ int sa1100_request_dma (dma_device_t dev
 
 	i = dma - dma_chan;
 	regs = (dma_regs_t *)&DDAR(i);
-	err = request_irq(IRQ_DMA0 + i, dma_irq_handler, IRQF_DISABLED,
+	err = request_irq(IRQ_DMA0 + i, dma_irq_handler, 0,
 			  device_id, regs);
 	if (err) {
 		printk(KERN_ERR
Index: linux-2.6/arch/arm/mach-sa1100/h3600.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/h3600.c
+++ linux-2.6/arch/arm/mach-sa1100/h3600.c
@@ -740,7 +740,7 @@ static void h3800_IRQ_demux(unsigned int
 static struct irqaction h3800_irq = {
 	.name		= "h3800_asic",
 	.handler	= h3800_IRQ_demux,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 u32 kpio_int_shadow = 0;
Index: linux-2.6/arch/arm/mach-sa1100/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-sa1100/time.c
+++ linux-2.6/arch/arm/mach-sa1100/time.c
@@ -93,7 +93,7 @@ static struct clocksource cksrc_sa1100_o
 
 static struct irqaction sa1100_timer_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= sa1100_ost0_interrupt,
 	.dev_id		= &ckevt_sa1100_osmr0,
 };
Index: linux-2.6/arch/arm/mach-shark/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shark/core.c
+++ linux-2.6/arch/arm/mach-shark/core.c
@@ -90,7 +90,7 @@ shark_timer_interrupt(int irq, void *dev
 
 static struct irqaction shark_timer_irq = {
 	.name		= "Shark Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= shark_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-versatile/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-versatile/core.c
+++ linux-2.6/arch/arm/mach-versatile/core.c
@@ -930,7 +930,7 @@ static irqreturn_t versatile_timer_inter
 
 static struct irqaction versatile_timer_irq = {
 	.name		= "Versatile Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= versatile_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/mach-w90x900/time.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-w90x900/time.c
+++ linux-2.6/arch/arm/mach-w90x900/time.c
@@ -48,7 +48,7 @@ w90x900_timer_interrupt(int irq, void *d
 
 static struct irqaction w90x900_timer_irq = {
 	.name		= "w90x900 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= w90x900_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/oprofile/op_model_arm11_core.c
===================================================================
--- linux-2.6.orig/arch/arm/oprofile/op_model_arm11_core.c
+++ linux-2.6/arch/arm/oprofile/op_model_arm11_core.c
@@ -138,7 +138,7 @@ int arm11_request_interrupts(int *irqs, 
 	int ret = 0;
 
 	for(i = 0; i < nr; i++) {
-		ret = request_irq(irqs[i], arm11_pmu_interrupt, IRQF_DISABLED, "CP15 PMU", NULL);
+		ret = request_irq(irqs[i], arm11_pmu_interrupt, 0, "CP15 PMU", NULL);
 		if (ret != 0) {
 			printk(KERN_ERR "oprofile: unable to request IRQ%u for MPCORE-EM\n",
 			       irqs[i]);
Index: linux-2.6/arch/arm/oprofile/op_model_mpcore.c
===================================================================
--- linux-2.6.orig/arch/arm/oprofile/op_model_mpcore.c
+++ linux-2.6/arch/arm/oprofile/op_model_mpcore.c
@@ -119,7 +119,7 @@ static int scu_start(void)
 	 */
 	for (i = 0; i < NUM_SCU_COUNTERS; i++) {
 		if (scu_em_used & (1 << i)) {
-			ret = request_irq(IRQ_EB11MP_PMU_SCU0 + i, scu_em_interrupt, IRQF_DISABLED, "SCU PMU", NULL);
+			ret = request_irq(IRQ_EB11MP_PMU_SCU0 + i, scu_em_interrupt, 0, "SCU PMU", NULL);
 			if (ret) {
 				printk(KERN_ERR "oprofile: unable to request IRQ%u for SCU Event Monitor\n",
 				       IRQ_EB11MP_PMU_SCU0 + i);
Index: linux-2.6/arch/arm/oprofile/op_model_v7.c
===================================================================
--- linux-2.6.orig/arch/arm/oprofile/op_model_v7.c
+++ linux-2.6/arch/arm/oprofile/op_model_v7.c
@@ -306,7 +306,7 @@ int armv7_request_interrupts(int *irqs, 
 
 	for (i = 0; i < nr; i++) {
 		ret = request_irq(irqs[i], armv7_pmnc_interrupt,
-				IRQF_DISABLED, "CP15 PMNC", NULL);
+				0, "CP15 PMNC", NULL);
 		if (ret != 0) {
 			printk(KERN_ERR "oprofile: unable to request IRQ%u"
 				" for ARMv7\n",
Index: linux-2.6/arch/arm/oprofile/op_model_xscale.c
===================================================================
--- linux-2.6.orig/arch/arm/oprofile/op_model_xscale.c
+++ linux-2.6/arch/arm/oprofile/op_model_xscale.c
@@ -382,7 +382,7 @@ static int xscale_pmu_start(void)
 	int ret;
 	u32 pmnc = read_pmnc();
 
-	ret = request_irq(XSCALE_PMU_IRQ, xscale_pmu_interrupt, IRQF_DISABLED,
+	ret = request_irq(XSCALE_PMU_IRQ, xscale_pmu_interrupt, 0,
 			"XScale PMU", (void *)results);
 
 	if (ret < 0) {
Index: linux-2.6/arch/arm/plat-iop/time.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-iop/time.c
+++ linux-2.6/arch/arm/plat-iop/time.c
@@ -71,7 +71,7 @@ iop_timer_interrupt(int irq, void *dev_i
 static struct irqaction iop_timer_irq = {
 	.name		= "IOP Timer Tick",
 	.handler	= iop_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 };
 
 static unsigned long iop_tick_rate;
Index: linux-2.6/arch/arm/plat-mxc/time.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-mxc/time.c
+++ linux-2.6/arch/arm/plat-mxc/time.c
@@ -164,7 +164,7 @@ static irqreturn_t mxc_timer_interrupt(i
 
 static struct irqaction mxc_timer_irq = {
 	.name		= "i.MX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= mxc_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/plat-omap/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/dma.c
+++ linux-2.6/arch/arm/plat-omap/dma.c
@@ -1921,7 +1921,7 @@ static irqreturn_t omap2_dma_irq_handler
 static struct irqaction omap24xx_dma_irq = {
 	.name = "DMA",
 	.handler = omap2_dma_irq_handler,
-	.flags = IRQF_DISABLED
+	.flags = 0,
 };
 
 #else
Index: linux-2.6/arch/arm/plat-omap/mailbox.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/mailbox.c
+++ linux-2.6/arch/arm/plat-omap/mailbox.c
@@ -348,7 +348,7 @@ static int omap_mbox_init(struct omap_mb
 		goto fail_create_mbox;
 	}
 
-	ret = request_irq(mbox->irq, mbox_interrupt, IRQF_DISABLED,
+	ret = request_irq(mbox->irq, mbox_interrupt, 0,
 				mbox->name, mbox);
 	if (unlikely(ret)) {
 		printk(KERN_ERR
Index: linux-2.6/arch/arm/plat-orion/time.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-orion/time.c
+++ linux-2.6/arch/arm/plat-orion/time.c
@@ -166,7 +166,7 @@ static irqreturn_t orion_timer_interrupt
 
 static struct irqaction orion_timer_irq = {
 	.name		= "orion_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		=  IRQF_TIMER,
 	.handler	= orion_timer_interrupt
 };
 
Index: linux-2.6/arch/arm/plat-s3c/time.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c/time.c
+++ linux-2.6/arch/arm/plat-s3c/time.c
@@ -138,7 +138,7 @@ s3c2410_timer_interrupt(int irq, void *d
 
 static struct irqaction s3c2410_timer_irq = {
 	.name		= "S3C2410 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= s3c2410_timer_interrupt,
 };
 
Index: linux-2.6/arch/arm/plat-s3c24xx/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/plat-s3c24xx/dma.c
+++ linux-2.6/arch/arm/plat-s3c24xx/dma.c
@@ -762,7 +762,7 @@ int s3c2410_dma_request(unsigned int cha
 		chan->irq_claimed = 1;
 		local_irq_restore(flags);
 
-		err = request_irq(chan->irq, s3c2410_dma_irq, IRQF_DISABLED,
+		err = request_irq(chan->irq, s3c2410_dma_irq, 0,
 				  client->name, (void *)chan);
 
 		local_irq_save(flags);
Index: linux-2.6/arch/avr32/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/time.c
+++ linux-2.6/arch/avr32/kernel/time.c
@@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction timer_irqaction = {
 	.handler	= timer_interrupt,
 	/* Oprofile uses the same irq as the timer, so allow it to be shared */
-	.flags		= IRQF_TIMER | IRQF_DISABLED | IRQF_SHARED,
+	.flags		= IRQF_TIMER |  IRQF_SHARED,
 	.name		= "avr32_comparator",
 };
 
Index: linux-2.6/arch/blackfin/kernel/bfin_dma_5xx.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/bfin_dma_5xx.c
+++ linux-2.6/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -148,7 +148,7 @@ int set_dma_callback(unsigned int channe
 		int ret;
 		unsigned int irq = channel2irq(channel);
 
-		ret = request_irq(irq, callback, IRQF_DISABLED,
+		ret = request_irq(irq, callback, 0,
 			dma_ch[channel].device_id, data);
 		if (ret)
 			return ret;
Index: linux-2.6/arch/blackfin/kernel/time-ts.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/time-ts.c
+++ linux-2.6/arch/blackfin/kernel/time-ts.c
@@ -168,7 +168,7 @@ static struct clock_event_device clockev
 
 static struct irqaction bfin_timer_irq = {
 	.name		= "Blackfin Core Timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= timer_interrupt,
 	.dev_id		= &clockevent_bfin,
 };
Index: linux-2.6/arch/blackfin/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/blackfin/kernel/time.c
+++ linux-2.6/arch/blackfin/kernel/time.c
@@ -25,9 +25,9 @@
 static struct irqaction bfin_timer_irq = {
 	.name = "Blackfin Timer Tick",
 #ifdef CONFIG_IRQ_PER_CPU
-	.flags = IRQF_DISABLED | IRQF_PERCPU,
+	.flags =  IRQF_PERCPU,
 #else
-	.flags = IRQF_DISABLED
+	.flags = 0,
 #endif
 };
 
Index: linux-2.6/arch/blackfin/mach-bf537/boards/cm_bf537.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -494,7 +494,7 @@ static struct platform_device bfin_mac_d
 
 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 2,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+	.irq_type = IRQF_TRIGGER_HIGH ,
 };
 
 static struct resource bfin_pata_resources[] = {
Index: linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/stamp.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1124,7 +1124,7 @@ static struct platform_device bfin_sport
 
 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 1,
-	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+	.irq_flags = IRQF_TRIGGER_HIGH ,
 };
 
 static struct resource bfin_pata_resources[] = {
Index: linux-2.6/arch/blackfin/mach-bf537/boards/tcm_bf537.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ linux-2.6/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -496,7 +496,7 @@ static struct platform_device bfin_mac_d
 
 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 2,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+	.irq_type = IRQF_TRIGGER_HIGH ,
 };
 
 static struct resource bfin_pata_resources[] = {
Index: linux-2.6/arch/blackfin/mach-bf561/boards/cm_bf561.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ linux-2.6/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -333,7 +333,7 @@ static struct platform_device bfin_sir0_
 
 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 2,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+	.irq_type = IRQF_TRIGGER_HIGH ,
 };
 
 static struct resource bfin_pata_resources[] = {
Index: linux-2.6/arch/blackfin/mach-bf561/smp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-bf561/smp.c
+++ linux-2.6/arch/blackfin/mach-bf561/smp.c
@@ -132,7 +132,7 @@ void __init platform_request_ipi(irq_han
 {
 	int ret;
 
-	ret = request_irq(IRQ_SUPPLE_0, handler, IRQF_DISABLED,
+	ret = request_irq(IRQ_SUPPLE_0, handler, 0,
 			  "SMP interrupt", handler);
 	if (ret)
 		panic("Cannot request supplemental interrupt 0 for IPI service\n");
Index: linux-2.6/arch/cris/arch-v10/drivers/gpio.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/drivers/gpio.c
+++ linux-2.6/arch/cris/arch-v10/drivers/gpio.c
@@ -812,13 +812,13 @@ static int __init gpio_init(void)
 	 * in some tests.
 	 */
 	res = request_irq(TIMER0_IRQ_NBR, gpio_poll_timer_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio poll", gpio_name);
+		IRQF_SHARED , "gpio poll", gpio_name);
 	if (res) {
 		printk(KERN_CRIT "err: timer0 irq for gpio\n");
 		return res;
 	}
 	res = request_irq(PA_IRQ_NBR, gpio_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio PA", gpio_name);
+		IRQF_SHARED , "gpio PA", gpio_name);
 	if (res)
 		printk(KERN_CRIT "err: PA irq for gpio\n");
 
Index: linux-2.6/arch/cris/arch-v10/drivers/sync_serial.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/drivers/sync_serial.c
+++ linux-2.6/arch/cris/arch-v10/drivers/sync_serial.c
@@ -580,7 +580,7 @@ static int sync_serial_open(struct inode
 			if (port == &ports[0]) {
 				if (request_irq(8,
 						manual_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED ,
 						"synchronous serial manual irq",
 						&ports[0])) {
 					printk(KERN_CRIT "Can't alloc "
@@ -590,7 +590,7 @@ static int sync_serial_open(struct inode
 			} else if (port == &ports[1]) {
 				if (request_irq(8,
 						manual_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED ,
 						"synchronous serial manual irq",
 						&ports[1])) {
 					printk(KERN_CRIT "Can't alloc "
Index: linux-2.6/arch/cris/arch-v10/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/time.c
+++ linux-2.6/arch/cris/arch-v10/kernel/time.c
@@ -260,7 +260,7 @@ timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq2  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_SHARED | IRQF_DISABLED,
+	.flags = IRQF_SHARED ,
 	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
Index: linux-2.6/arch/cris/arch-v32/drivers/mach-a3/gpio.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ linux-2.6/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -967,7 +967,7 @@ static int __init gpio_init(void)
 	CRIS_LED_DISK_WRITE(0);
 
 	int res2 = request_irq(GIO_INTR_VECT, gpio_interrupt,
-		IRQF_SHARED | IRQF_DISABLED, "gpio", &alarmlist);
+		IRQF_SHARED , "gpio", &alarmlist);
 	if (res2) {
 		printk(KERN_ERR "err: irq for gpio\n");
 		return res2;
Index: linux-2.6/arch/cris/arch-v32/drivers/mach-fs/gpio.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ linux-2.6/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -955,11 +955,11 @@ gpio_init(void)
 	 * in some tests.
 	 */
 	if (request_irq(TIMER0_INTR_VECT, gpio_poll_timer_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, "gpio poll", &alarmlist))
+			IRQF_SHARED , "gpio poll", &alarmlist))
 		printk(KERN_ERR "timer0 irq for gpio\n");
 
 	if (request_irq(GIO_INTR_VECT, gpio_pa_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, "gpio PA", &alarmlist))
+			IRQF_SHARED , "gpio PA", &alarmlist))
 		printk(KERN_ERR "PA irq for gpio\n");
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
Index: linux-2.6/arch/cris/arch-v32/kernel/fasttimer.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/fasttimer.c
+++ linux-2.6/arch/cris/arch-v32/kernel/fasttimer.c
@@ -822,7 +822,7 @@ int fast_timer_init(void)
       fasttimer_proc_entry->read_proc = proc_fasttimer_read;
 #endif /* PROC_FS */
 		if (request_irq(TIMER0_INTR_VECT, timer_trig_interrupt,
-				IRQF_SHARED | IRQF_DISABLED,
+				IRQF_SHARED ,
 				"fast timer int", &fast_timer_list))
 			printk(KERN_ERR "err: fasttimer irq\n");
     fast_timer_is_init = 1;
Index: linux-2.6/arch/cris/arch-v32/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6/arch/cris/arch-v32/kernel/smp.c
@@ -64,7 +64,7 @@ static irqreturn_t crisv32_ipi_interrupt
 static int send_ipi(int vector, int wait, cpumask_t cpu_mask);
 static struct irqaction irq_ipi  = {
 	.handler = crisv32_ipi_interrupt,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.mask = CPU_MASK_NONE,
 	.name = "ipi",
 };
Index: linux-2.6/arch/cris/arch-v32/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/time.c
+++ linux-2.6/arch/cris/arch-v32/kernel/time.c
@@ -266,7 +266,7 @@ timer_interrupt(int irq, void *dev_id)
  */
 static struct irqaction irq_timer = {
 	.handler = timer_interrupt,
-	.flags = IRQF_SHARED | IRQF_DISABLED,
+	.flags = IRQF_SHARED ,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
Index: linux-2.6/arch/cris/arch-v32/mach-a3/arbiter.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/mach-a3/arbiter.c
+++ linux-2.6/arch/cris/arch-v32/mach-a3/arbiter.c
@@ -256,11 +256,11 @@ static void crisv32_arbiter_init(void)
 	crisv32_arbiter_config(1, EXT_REGION, 0);
 
 	if (request_irq(MEMARB_FOO_INTR_VECT, crisv32_foo_arbiter_irq,
-			IRQF_DISABLED, "arbiter", NULL))
+			0, "arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
 	if (request_irq(MEMARB_BAR_INTR_VECT, crisv32_bar_arbiter_irq,
-			IRQF_DISABLED, "arbiter", NULL))
+			0, "arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
 #ifndef CONFIG_ETRAX_KGDB
Index: linux-2.6/arch/cris/arch-v32/mach-fs/arbiter.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/mach-fs/arbiter.c
+++ linux-2.6/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -184,7 +184,7 @@ static void crisv32_arbiter_init(void)
 	crisv32_arbiter_config(EXT_REGION, 0);
 	crisv32_arbiter_config(INT_REGION, 0);
 
-	if (request_irq(MEMARB_INTR_VECT, crisv32_arbiter_irq, IRQF_DISABLED,
+	if (request_irq(MEMARB_INTR_VECT, crisv32_arbiter_irq, 0,
 			"arbiter", NULL))
 		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
 
Index: linux-2.6/arch/frv/kernel/irq-mb93091.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93091.c
+++ linux-2.6/arch/frv/kernel/irq-mb93091.c
@@ -108,28 +108,28 @@ static irqreturn_t fpga_interrupt(int ir
 static struct irqaction fpga_irq[4]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		=  IRQF_SHARED,
 		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0028UL,
 	},
 	[1] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		=  IRQF_SHARED,
 		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.1",
 		.dev_id		= (void *) 0x0050UL,
 	},
 	[2] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		=  IRQF_SHARED,
 		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.2",
 		.dev_id		= (void *) 0x1c00UL,
 	},
 	[3] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		=  IRQF_SHARED,
 		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.3",
 		.dev_id		= (void *) 0x6386UL,
Index: linux-2.6/arch/frv/kernel/irq-mb93093.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93093.c
+++ linux-2.6/arch/frv/kernel/irq-mb93093.c
@@ -107,7 +107,7 @@ static irqreturn_t fpga_interrupt(int ir
 static struct irqaction fpga_irq[1]  = {
 	[0] = {
 		.handler	= fpga_interrupt,
-		.flags		= IRQF_DISABLED,
+		.flags		= 0,
 		.mask		= CPU_MASK_NONE,
 		.name		= "fpga.0",
 		.dev_id		= (void *) 0x0700UL,
Index: linux-2.6/arch/frv/kernel/irq-mb93493.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/irq-mb93493.c
+++ linux-2.6/arch/frv/kernel/irq-mb93493.c
@@ -119,14 +119,14 @@ static irqreturn_t mb93493_interrupt(int
 static struct irqaction mb93493_irq[2]  = {
 	[0] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		=  IRQF_SHARED,
 		.mask		= CPU_MASK_NONE,
 		.name		= "mb93493.0",
 		.dev_id		= (void *) __addr_MB93493_IQSR(0),
 	},
 	[1] = {
 		.handler	= mb93493_interrupt,
-		.flags		= IRQF_DISABLED | IRQF_SHARED,
+		.flags		=  IRQF_SHARED,
 		.mask		= CPU_MASK_NONE,
 		.name		= "mb93493.1",
 		.dev_id		= (void *) __addr_MB93493_IQSR(1),
Index: linux-2.6/arch/frv/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/frv/kernel/time.c
+++ linux-2.6/arch/frv/kernel/time.c
@@ -44,7 +44,7 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction timer_irq  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
Index: linux-2.6/arch/h8300/kernel/timer/itu.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/timer/itu.c
+++ linux-2.6/arch/h8300/kernel/timer/itu.c
@@ -59,7 +59,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction itu_irq = {
 	.name		= "itu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		=  IRQF_TIMER,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6/arch/h8300/kernel/timer/timer16.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/timer/timer16.c
+++ linux-2.6/arch/h8300/kernel/timer/timer16.c
@@ -54,7 +54,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction timer16_irq = {
 	.name		= "timer-16",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		=  IRQF_TIMER,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6/arch/h8300/kernel/timer/timer8.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/timer/timer8.c
+++ linux-2.6/arch/h8300/kernel/timer/timer8.c
@@ -74,7 +74,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction timer8_irq = {
 	.name		= "timer-8",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		=  IRQF_TIMER,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6/arch/h8300/kernel/timer/tpu.c
===================================================================
--- linux-2.6.orig/arch/h8300/kernel/timer/tpu.c
+++ linux-2.6/arch/h8300/kernel/timer/tpu.c
@@ -64,7 +64,7 @@ static irqreturn_t timer_interrupt(int i
 static struct irqaction tpu_irq = {
 	.name		= "tpu",
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		=  IRQF_TIMER,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6/arch/ia64/hp/sim/simserial.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/simserial.c
+++ linux-2.6/arch/ia64/hp/sim/simserial.c
@@ -42,7 +42,7 @@
 
 #define NR_PORTS	1	/* only one port for now */
 
-#define IRQ_T(info) ((info->flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED : IRQF_DISABLED)
+#define IRQ_T(info) ((info->flags & ASYNC_SHARE_IRQ) ? IRQF_SHARED : 0)
 
 #define SSC_GETCHAR	21
 
Index: linux-2.6/arch/ia64/kernel/irq_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/irq_ia64.c
+++ linux-2.6/arch/ia64/kernel/irq_ia64.c
@@ -365,7 +365,7 @@ static irqreturn_t smp_irq_move_cleanup_
 
 static struct irqaction irq_move_irqaction = {
 	.handler =	smp_irq_move_cleanup_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"irq_move"
 };
 
@@ -607,19 +607,19 @@ static irqreturn_t dummy_handler (int ir
 
 static struct irqaction ipi_irqaction = {
 	.handler =	handle_IPI,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"IPI"
 };
 
 static struct irqaction resched_irqaction = {
 	.handler =	dummy_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"resched"
 };
 
 static struct irqaction tlb_irqaction = {
 	.handler =	dummy_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"tlb_flush"
 };
 
Index: linux-2.6/arch/ia64/kernel/mca.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/mca.c
+++ linux-2.6/arch/ia64/kernel/mca.c
@@ -1737,38 +1737,38 @@ __setup("disable_cpe_poll", ia64_mca_dis
 
 static struct irqaction cmci_irqaction = {
 	.handler =	ia64_mca_cmc_int_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"cmc_hndlr"
 };
 
 static struct irqaction cmcp_irqaction = {
 	.handler =	ia64_mca_cmc_int_caller,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"cmc_poll"
 };
 
 static struct irqaction mca_rdzv_irqaction = {
 	.handler =	ia64_mca_rendez_int_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"mca_rdzv"
 };
 
 static struct irqaction mca_wkup_irqaction = {
 	.handler =	ia64_mca_wakeup_int_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"mca_wkup"
 };
 
 #ifdef CONFIG_ACPI
 static struct irqaction mca_cpe_irqaction = {
 	.handler =	ia64_mca_cpe_int_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"cpe_hndlr"
 };
 
 static struct irqaction mca_cpep_irqaction = {
 	.handler =	ia64_mca_cpe_int_caller,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"cpe_poll"
 };
 #endif /* CONFIG_ACPI */
Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c
+++ linux-2.6/arch/ia64/kernel/perfmon.c
@@ -6434,7 +6434,7 @@ pfm_flush_pmds(struct task_struct *task,
 
 static struct irqaction perfmon_irqaction = {
 	.handler = pfm_interrupt_handler,
-	.flags   = IRQF_DISABLED,
+	.flags   = 0,
 	.name    = "perfmon"
 };
 
Index: linux-2.6/arch/ia64/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/time.c
+++ linux-2.6/arch/ia64/kernel/time.c
@@ -401,7 +401,7 @@ static cycle_t itc_get_cycles(void)
 
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
+	.flags =	 IRQF_IRQPOLL,
 	.name =		"timer"
 };
 
Index: linux-2.6/arch/ia64/xen/irq_xen.c
===================================================================
--- linux-2.6.orig/arch/ia64/xen/irq_xen.c
+++ linux-2.6/arch/ia64/xen/irq_xen.c
@@ -105,19 +105,19 @@ xen_dummy_handler(int irq, void *dev_id)
 
 static struct irqaction xen_ipi_irqaction = {
 	.handler =	handle_IPI,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"IPI"
 };
 
 static struct irqaction xen_resched_irqaction = {
 	.handler =	xen_dummy_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"resched"
 };
 
 static struct irqaction xen_tlb_irqaction = {
 	.handler =	xen_dummy_handler,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"tlb_flush"
 };
 #endif
Index: linux-2.6/arch/m32r/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/time.c
+++ linux-2.6/arch/m32r/kernel/time.c
@@ -229,7 +229,7 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.mask = CPU_MASK_NONE,
 	.name = "MFT2",
 };
Index: linux-2.6/arch/m68k/include/asm/floppy.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/floppy.h
+++ linux-2.6/arch/m68k/include/asm/floppy.h
@@ -85,7 +85,7 @@ static int fd_request_irq(void)
 {
 	if(MACH_IS_Q40)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", floppy_hardint);
+				   0, "floppy", floppy_hardint);
 	else if(MACH_IS_SUN3X)
 		return sun3xflop_request_irq();
 	return -ENXIO;
Index: linux-2.6/arch/m68k/include/asm/sun3xflop.h
===================================================================
--- linux-2.6.orig/arch/m68k/include/asm/sun3xflop.h
+++ linux-2.6/arch/m68k/include/asm/sun3xflop.h
@@ -208,7 +208,7 @@ static int sun3xflop_request_irq(void)
 	if(!once) {
 		once = 1;
 		error = request_irq(FLOPPY_IRQ, sun3xflop_hardint,
-				    IRQF_DISABLED, "floppy", NULL);
+				    0, "floppy", NULL);
 		return ((error == 0) ? 0 : -1);
 	} else return 0;
 }
Index: linux-2.6/arch/m68knommu/platform/68328/timers.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/68328/timers.c
+++ linux-2.6/arch/m68knommu/platform/68328/timers.c
@@ -69,7 +69,7 @@ static irqreturn_t hw_tick(int irq, void
 
 static struct irqaction m68328_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 =  IRQF_TIMER,
 	.handler = hw_tick,
 };
 
Index: linux-2.6/arch/m68knommu/platform/68360/config.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/68360/config.c
+++ linux-2.6/arch/m68knommu/platform/68360/config.c
@@ -58,7 +58,7 @@ static irqreturn_t hw_tick(int irq, void
 
 static struct irqaction m68360_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 =  IRQF_TIMER,
 	.handler = hw_tick,
 };
 
Index: linux-2.6/arch/m68knommu/platform/coldfire/pit.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/pit.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/pit.c
@@ -119,7 +119,7 @@ static irqreturn_t pit_tick(int irq, voi
 
 static struct irqaction pit_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 =  IRQF_TIMER,
 	.handler = pit_tick,
 };
 
Index: linux-2.6/arch/m68knommu/platform/coldfire/timers.c
===================================================================
--- linux-2.6.orig/arch/m68knommu/platform/coldfire/timers.c
+++ linux-2.6/arch/m68knommu/platform/coldfire/timers.c
@@ -72,7 +72,7 @@ static irqreturn_t mcftmr_tick(int irq, 
 
 static struct irqaction mcftmr_timer_irq = {
 	.name	 = "timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 =  IRQF_TIMER,
 	.handler = mcftmr_tick,
 };
 
@@ -162,7 +162,7 @@ irqreturn_t coldfire_profile_tick(int ir
 
 static struct irqaction coldfire_profile_irq = {
 	.name	 = "profile timer",
-	.flags	 = IRQF_DISABLED | IRQF_TIMER,
+	.flags	 =  IRQF_TIMER,
 	.handler = coldfire_profile_tick,
 };
 
Index: linux-2.6/arch/mips/alchemy/common/dbdma.c
===================================================================
--- linux-2.6.orig/arch/mips/alchemy/common/dbdma.c
+++ linux-2.6/arch/mips/alchemy/common/dbdma.c
@@ -885,7 +885,7 @@ static void au1xxx_dbdma_init(void)
 	#error Unknown Au1x00 SOC
 #endif
 
-	if (request_irq(irq_nr, dbdma_interrupt, IRQF_DISABLED,
+	if (request_irq(irq_nr, dbdma_interrupt, 0,
 			"Au1xxx dbdma", (void *)dbdma_gptr))
 		printk(KERN_ERR "Can't get 1550 dbdma irq");
 }
Index: linux-2.6/arch/mips/alchemy/common/time.c
===================================================================
--- linux-2.6.orig/arch/mips/alchemy/common/time.c
+++ linux-2.6/arch/mips/alchemy/common/time.c
@@ -94,7 +94,7 @@ static struct clock_event_device au1x_rt
 
 static struct irqaction au1x_rtcmatch2_irqaction = {
 	.handler	= au1x_rtcmatch2_irq,
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		=  IRQF_TIMER,
 	.name		= "timer",
 	.dev_id		= &au1x_rtcmatch2_clockdev,
 };
Index: linux-2.6/arch/mips/basler/excite/excite_iodev.c
===================================================================
--- linux-2.6.orig/arch/mips/basler/excite/excite_iodev.c
+++ linux-2.6/arch/mips/basler/excite/excite_iodev.c
@@ -114,7 +114,7 @@ static int iodev_open(struct inode *i, s
 	int ret;
 
 	lock_kernel();
-	ret = request_irq(iodev_irq, iodev_irqhdl, IRQF_DISABLED,
+	ret = request_irq(iodev_irq, iodev_irqhdl, 0,
 			   iodev_name, &miscdev);
 	unlock_kernel();
 
Index: linux-2.6/arch/mips/dec/setup.c
===================================================================
--- linux-2.6.orig/arch/mips/dec/setup.c
+++ linux-2.6/arch/mips/dec/setup.c
@@ -107,7 +107,7 @@ static struct irqaction fpuirq = {
 };
 
 static struct irqaction busirq = {
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.name = "bus error",
 };
 
Index: linux-2.6/arch/mips/include/asm/mach-generic/floppy.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/mach-generic/floppy.h
+++ linux-2.6/arch/mips/include/asm/mach-generic/floppy.h
@@ -98,7 +98,7 @@ static inline void fd_disable_irq(void)
 static inline int fd_request_irq(void)
 {
 	return request_irq(FLOPPY_IRQ, floppy_interrupt,
-	                   IRQF_DISABLED, "floppy", NULL);
+	                   0, "floppy", NULL);
 }
 
 static inline void fd_free_irq(void)
Index: linux-2.6/arch/mips/include/asm/mach-jazz/floppy.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/mach-jazz/floppy.h
+++ linux-2.6/arch/mips/include/asm/mach-jazz/floppy.h
@@ -90,7 +90,7 @@ static inline void fd_disable_irq(void)
 static inline int fd_request_irq(void)
 {
 	return request_irq(FLOPPY_IRQ, floppy_interrupt,
-	                   IRQF_DISABLED, "floppy", NULL);
+	                   0, "floppy", NULL);
 }
 
 static inline void fd_free_irq(void)
Index: linux-2.6/arch/mips/jazz/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/jazz/irq.c
+++ linux-2.6/arch/mips/jazz/irq.c
@@ -133,7 +133,7 @@ static irqreturn_t r4030_timer_interrupt
 
 static struct irqaction r4030_timer_irqaction = {
 	.handler	= r4030_timer_interrupt,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.mask		= CPU_MASK_CPU0,
 	.name		= "R4030 timer",
 };
Index: linux-2.6/arch/mips/kernel/cevt-bcm1480.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/cevt-bcm1480.c
+++ linux-2.6/arch/mips/kernel/cevt-bcm1480.c
@@ -143,7 +143,7 @@ void __cpuinit sb1480_clockevent_init(vo
 	bcm1480_unmask_irq(cpu, irq);
 
 	action->handler	= sibyte_counter_handler;
-	action->flags	= IRQF_DISABLED | IRQF_PERCPU;
+	action->flags	=  IRQF_PERCPU;
 	action->mask	= cpumask_of_cpu(cpu);
 	action->name	= name;
 	action->dev_id	= cd;
Index: linux-2.6/arch/mips/kernel/cevt-ds1287.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/cevt-ds1287.c
+++ linux-2.6/arch/mips/kernel/cevt-ds1287.c
@@ -107,7 +107,7 @@ static irqreturn_t ds1287_interrupt(int 
 
 static struct irqaction ds1287_irqaction = {
 	.handler	= ds1287_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		=  IRQF_PERCPU,
 	.name		= "ds1287",
 };
 
Index: linux-2.6/arch/mips/kernel/cevt-gt641xx.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/cevt-gt641xx.c
+++ linux-2.6/arch/mips/kernel/cevt-gt641xx.c
@@ -113,7 +113,7 @@ static irqreturn_t gt641xx_timer0_interr
 
 static struct irqaction gt641xx_timer0_irqaction = {
 	.handler	= gt641xx_timer0_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		=  IRQF_PERCPU,
 	.name		= "gt641xx_timer0",
 };
 
Index: linux-2.6/arch/mips/kernel/cevt-r4k.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/cevt-r4k.c
+++ linux-2.6/arch/mips/kernel/cevt-r4k.c
@@ -82,7 +82,7 @@ out:
 
 struct irqaction c0_compare_irqaction = {
 	.handler = c0_compare_interrupt,
-	.flags = IRQF_DISABLED | IRQF_PERCPU,
+	.flags =  IRQF_PERCPU,
 	.name = "timer",
 };
 
Index: linux-2.6/arch/mips/kernel/cevt-sb1250.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/cevt-sb1250.c
+++ linux-2.6/arch/mips/kernel/cevt-sb1250.c
@@ -142,7 +142,7 @@ void __cpuinit sb1250_clockevent_init(vo
 	sb1250_unmask_irq(cpu, irq);
 
 	action->handler	= sibyte_counter_handler;
-	action->flags	= IRQF_DISABLED | IRQF_PERCPU;
+	action->flags	=  IRQF_PERCPU;
 	action->mask	= cpumask_of_cpu(cpu);
 	action->name	= name;
 	action->dev_id	= cd;
Index: linux-2.6/arch/mips/kernel/cevt-txx9.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/cevt-txx9.c
+++ linux-2.6/arch/mips/kernel/cevt-txx9.c
@@ -128,7 +128,7 @@ static irqreturn_t txx9tmr_interrupt(int
 
 static struct irqaction txx9tmr_irq = {
 	.handler	= txx9tmr_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		=  IRQF_PERCPU,
 	.name		= "txx9tmr",
 };
 
Index: linux-2.6/arch/mips/kernel/i8253.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/i8253.c
+++ linux-2.6/arch/mips/kernel/i8253.c
@@ -97,7 +97,7 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags =  IRQF_NOBALANCING,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
Index: linux-2.6/arch/mips/kernel/rtlx.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/rtlx.c
+++ linux-2.6/arch/mips/kernel/rtlx.c
@@ -482,7 +482,7 @@ static const struct file_operations rtlx
 
 static struct irqaction rtlx_irq = {
 	.handler	= rtlx_interrupt,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "RTLX",
 };
 
Index: linux-2.6/arch/mips/kernel/smtc.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/smtc.c
+++ linux-2.6/arch/mips/kernel/smtc.c
@@ -1093,7 +1093,7 @@ static void ipi_irq_dispatch(void)
 
 static struct irqaction irq_ipi = {
 	.handler	= ipi_interrupt,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "SMTC_IPI",
 	.flags		= IRQF_PERCPU
 };
Index: linux-2.6/arch/mips/mti-malta/malta-int.c
===================================================================
--- linux-2.6.orig/arch/mips/mti-malta/malta-int.c
+++ linux-2.6/arch/mips/mti-malta/malta-int.c
@@ -321,13 +321,13 @@ static irqreturn_t ipi_call_interrupt(in
 
 static struct irqaction irq_resched = {
 	.handler	= ipi_resched_interrupt,
-	.flags		= IRQF_DISABLED|IRQF_PERCPU,
+	.flags		= IRQF_PERCPU,
 	.name		= "IPI_resched"
 };
 
 static struct irqaction irq_call = {
 	.handler	= ipi_call_interrupt,
-	.flags		= IRQF_DISABLED|IRQF_PERCPU,
+	.flags		= IRQF_PERCPU,
 	.name		= "IPI_call"
 };
 #endif /* CONFIG_MIPS_MT_SMP */
Index: linux-2.6/arch/mips/nxp/pnx8550/common/int.c
===================================================================
--- linux-2.6.orig/arch/mips/nxp/pnx8550/common/int.c
+++ linux-2.6/arch/mips/nxp/pnx8550/common/int.c
@@ -166,13 +166,13 @@ static struct irq_chip level_irq_type = 
 
 static struct irqaction gic_action = {
 	.handler =	no_action,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"GIC",
 };
 
 static struct irqaction timer_action = {
 	.handler =	no_action,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"Timer",
 };
 
Index: linux-2.6/arch/mips/nxp/pnx8550/common/time.c
===================================================================
--- linux-2.6.orig/arch/mips/nxp/pnx8550/common/time.c
+++ linux-2.6/arch/mips/nxp/pnx8550/common/time.c
@@ -59,7 +59,7 @@ static irqreturn_t pnx8xxx_timer_interru
 
 static struct irqaction pnx8xxx_timer_irq = {
 	.handler	= pnx8xxx_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		=  IRQF_PERCPU,
 	.name		= "pnx8xxx_timer",
 };
 
@@ -72,7 +72,7 @@ static irqreturn_t monotonic_interrupt(i
 
 static struct irqaction monotonic_irqaction = {
 	.handler = monotonic_interrupt,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.name = "Monotonic timer",
 };
 
Index: linux-2.6/arch/mips/pci/ops-pmcmsp.c
===================================================================
--- linux-2.6.orig/arch/mips/pci/ops-pmcmsp.c
+++ linux-2.6/arch/mips/pci/ops-pmcmsp.c
@@ -404,7 +404,7 @@ int msp_pcibios_config_access(unsigned c
 	if (pciirqflag == 0) {
 		request_irq(MSP_INT_PCI,/* Hardcoded internal MSP7120 wiring */
 				bpci_interrupt,
-				IRQF_SHARED | IRQF_DISABLED,
+				IRQF_SHARED ,
 				"PMC MSP PCI Host",
 				preg);
 		pciirqflag = ~0;
Index: linux-2.6/arch/mips/pci/ops-tx3927.c
===================================================================
--- linux-2.6.orig/arch/mips/pci/ops-tx3927.c
+++ linux-2.6/arch/mips/pci/ops-tx3927.c
@@ -224,7 +224,7 @@ void __init tx3927_setup_pcierr_irq(void
 {
 	if (request_irq(TXX9_IRQ_BASE + TX3927_IR_PCI,
 			tx3927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX3927_PCIC_REG))
 		printk(KERN_WARNING "Failed to request irq for PCIERR\n");
 }
Index: linux-2.6/arch/mips/pci/pci-tx4927.c
===================================================================
--- linux-2.6.orig/arch/mips/pci/pci-tx4927.c
+++ linux-2.6/arch/mips/pci/pci-tx4927.c
@@ -87,7 +87,7 @@ void __init tx4927_setup_pcierr_irq(void
 {
 	if (request_irq(TXX9_IRQ_BASE + TX4927_IR_PCIERR,
 			tx4927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX4927_PCIC_REG))
 		printk(KERN_WARNING "Failed to request irq for PCIERR\n");
 }
Index: linux-2.6/arch/mips/pci/pci-tx4938.c
===================================================================
--- linux-2.6.orig/arch/mips/pci/pci-tx4938.c
+++ linux-2.6/arch/mips/pci/pci-tx4938.c
@@ -138,7 +138,7 @@ void __init tx4938_setup_pcierr_irq(void
 {
 	if (request_irq(TXX9_IRQ_BASE + TX4938_IR_PCIERR,
 			tx4927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX4927_PCIC_REG))
 		printk(KERN_WARNING "Failed to request irq for PCIERR\n");
 }
Index: linux-2.6/arch/mips/pci/pci-tx4939.c
===================================================================
--- linux-2.6.orig/arch/mips/pci/pci-tx4939.c
+++ linux-2.6/arch/mips/pci/pci-tx4939.c
@@ -103,7 +103,7 @@ void __init tx4939_setup_pcierr_irq(void
 {
 	if (request_irq(TXX9_IRQ_BASE + TX4939_IR_PCIERR,
 			tx4927_pcierr_interrupt,
-			IRQF_DISABLED, "PCI error",
+			0, "PCI error",
 			(void *)TX4939_PCIC_REG))
 		pr_warning("Failed to request irq for PCIERR\n");
 }
Index: linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
===================================================================
--- linux-2.6.orig/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
+++ linux-2.6/arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c
@@ -160,7 +160,7 @@ static int msp_hwbutton_register(struct 
 		CIC_EXT_SET_ACTIVE_HI(cic_ext, hirq->eirq);
 	*CIC_EXT_CFG_REG = cic_ext;
 
-	return request_irq(hirq->irq, hwbutton_handler, IRQF_DISABLED,
+	return request_irq(hirq->irq, hwbutton_handler, 0,
 			   hirq->name, hirq);
 }
 
Index: linux-2.6/arch/mips/sgi-ip22/ip22-int.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip22/ip22-int.c
+++ linux-2.6/arch/mips/sgi-ip22/ip22-int.c
@@ -162,32 +162,32 @@ static void indy_buserror_irq(void)
 
 static struct irqaction local0_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "local0 cascade",
 };
 
 static struct irqaction local1_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "local1 cascade",
 };
 
 static struct irqaction buserr = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "Bus Error",
 };
 
 static struct irqaction map0_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "mapable0 cascade",
 };
 
 #ifdef USE_LIO3_IRQ
 static struct irqaction map1_cascade = {
 	.handler	= no_action,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.name		= "mapable1 cascade",
 };
 #define SGI_INTERRUPTS	SGINT_END
Index: linux-2.6/arch/mips/sgi-ip27/ip27-timer.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip27/ip27-timer.c
+++ linux-2.6/arch/mips/sgi-ip27/ip27-timer.c
@@ -104,7 +104,7 @@ static irqreturn_t hub_rt_counter_handle
 
 struct irqaction hub_rt_irqaction = {
 	.handler	= hub_rt_counter_handler,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		=  IRQF_PERCPU,
 	.name		= "hub-rt",
 };
 
Index: linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sgi-ip32/ip32-irq.c
+++ linux-2.6/arch/mips/sgi-ip32/ip32-irq.c
@@ -114,14 +114,14 @@ extern irqreturn_t crime_cpuerr_intr(int
 
 struct irqaction memerr_irq = {
 	.handler = crime_memerr_intr,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.mask = CPU_MASK_NONE,
 	.name = "CRIME memory error",
 };
 
 struct irqaction cpuerr_irq = {
 	.handler = crime_cpuerr_intr,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.mask = CPU_MASK_NONE,
 	.name = "CRIME CPU error",
 };
Index: linux-2.6/arch/mips/sni/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/irq.c
+++ linux-2.6/arch/mips/sni/irq.c
@@ -42,7 +42,7 @@ static irqreturn_t sni_isa_irq_handler(i
 struct irqaction sni_isa_irq = {
 	.handler = sni_isa_irq_handler,
 	.name = "ISA",
-	.flags = IRQF_SHARED | IRQF_DISABLED
+	.flags = IRQF_SHARED
 };
 
 /*
Index: linux-2.6/arch/mips/sni/time.c
===================================================================
--- linux-2.6.orig/arch/mips/sni/time.c
+++ linux-2.6/arch/mips/sni/time.c
@@ -66,7 +66,7 @@ static irqreturn_t a20r_interrupt(int ir
 
 static struct irqaction a20r_irqaction = {
 	.handler	= a20r_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_PERCPU,
+	.flags		=  IRQF_PERCPU,
 	.name		= "a20r-timer",
 };
 
Index: linux-2.6/arch/mips/txx9/generic/pci.c
===================================================================
--- linux-2.6.orig/arch/mips/txx9/generic/pci.c
+++ linux-2.6/arch/mips/txx9/generic/pci.c
@@ -264,7 +264,7 @@ txx9_i8259_irq_setup(int irq)
 	int err;
 
 	init_i8259_irqs();
-	err = request_irq(irq, &i8259_interrupt, IRQF_DISABLED|IRQF_SHARED,
+	err = request_irq(irq, &i8259_interrupt, IRQF_SHARED,
 			  "cascade(i8259)", (void *)(long)irq);
 	if (!err)
 		printk(KERN_INFO "PCI-ISA bridge PIC (irq %d)\n", irq);
Index: linux-2.6/arch/mn10300/kernel/mn10300-serial.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/mn10300-serial.c
+++ linux-2.6/arch/mn10300/kernel/mn10300-serial.c
@@ -851,15 +851,15 @@ static int mn10300_serial_startup(struct
 	set_irq_chip(port->tm_irq, &mn10300_serial_pic);
 
 	if (request_irq(port->rx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED, port->rx_name, port) < 0)
+			0, port->rx_name, port) < 0)
 		goto error;
 
 	if (request_irq(port->tx_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED, port->tx_name, port) < 0)
+			0, port->tx_name, port) < 0)
 		goto error2;
 
 	if (request_irq(port->tm_irq, mn10300_serial_interrupt,
-			IRQF_DISABLED, port->tm_name, port) < 0)
+			0, port->tm_name, port) < 0)
 		goto error3;
 	mn10300_serial_mask_ack(port->tm_irq);
 
Index: linux-2.6/arch/mn10300/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/time.c
+++ linux-2.6/arch/mn10300/kernel/time.c
@@ -36,7 +36,7 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction timer_irq = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_SHARED | IRQF_TIMER,
+	.flags		=  IRQF_SHARED | IRQF_TIMER,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer",
 };
Index: linux-2.6/arch/parisc/include/asm/floppy.h
===================================================================
--- linux-2.6.orig/arch/parisc/include/asm/floppy.h
+++ linux-2.6/arch/parisc/include/asm/floppy.h
@@ -157,10 +157,10 @@ static int fd_request_irq(void)
 {
 	if(can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static unsigned long dma_mem_alloc(unsigned long size)
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -379,14 +379,14 @@ void do_cpu_irq_mask(struct pt_regs *reg
 static struct irqaction timer_action = {
 	.handler = timer_interrupt,
 	.name = "timer",
-	.flags = IRQF_DISABLED | IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
+	.flags =  IRQF_TIMER | IRQF_PERCPU | IRQF_IRQPOLL,
 };
 
 #ifdef CONFIG_SMP
 static struct irqaction ipi_action = {
 	.handler = ipi_interrupt,
 	.name = "IPI",
-	.flags = IRQF_DISABLED | IRQF_PERCPU,
+	.flags =  IRQF_PERCPU,
 };
 #endif
 
Index: linux-2.6/arch/powerpc/include/asm/floppy.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/floppy.h
+++ linux-2.6/arch/powerpc/include/asm/floppy.h
@@ -108,10 +108,10 @@ static int fd_request_irq(void)
 {
 	if (can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static int vdma_dma_setup(char *addr, unsigned long size, int mode, int io)
Index: linux-2.6/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6/arch/powerpc/kernel/smp.c
@@ -169,7 +169,7 @@ int smp_request_message_ipi(int virq, in
 		return 1;
 	}
 #endif
-	err = request_irq(virq, smp_ipi_action[msg], IRQF_DISABLED|IRQF_PERCPU,
+	err = request_irq(virq, smp_ipi_action[msg], IRQF_PERCPU,
 			  smp_ipi_name[msg], 0);
 	WARN(err < 0, "unable to request_irq %d for %s (rc %d)\n",
 		virq, smp_ipi_name[msg], err);
Index: linux-2.6/arch/powerpc/platforms/cell/beat.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/beat.c
+++ linux-2.6/arch/powerpc/platforms/cell/beat.c
@@ -230,7 +230,7 @@ static int __init beat_register_event(vo
 		}
 		ev->virq = virq;
 
-		rc = request_irq(virq, ev->handler, IRQF_DISABLED,
+		rc = request_irq(virq, ev->handler, 0,
 				      ev->typecode, NULL);
 		if (rc != 0) {
 			printk(KERN_ERR "Beat: failed to request virtual IRQ"
Index: linux-2.6/arch/powerpc/platforms/cell/celleb_scc_pciex.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ linux-2.6/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -521,7 +521,7 @@ static __init int celleb_setup_pciex(str
 	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
 				     oirq.size);
 	if (request_irq(virq, pciex_handle_internal_irq,
-			IRQF_DISABLED, "pciex", (void *)phb)) {
+			0, "pciex", (void *)phb)) {
 		pr_err("PCIEXC:Failed to request irq\n");
 		goto error;
 	}
Index: linux-2.6/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/interrupt.c
+++ linux-2.6/arch/powerpc/platforms/cell/interrupt.c
@@ -208,7 +208,7 @@ static void iic_request_ipi(int ipi, con
 		       "iic: failed to map IPI %s\n", name);
 		return;
 	}
-	if (request_irq(virq, iic_ipi_action, IRQF_DISABLED, name,
+	if (request_irq(virq, iic_ipi_action, 0, name,
 			(void *)(long)ipi))
 		printk(KERN_ERR
 		       "iic: failed to request IPI %s\n", name);
Index: linux-2.6/arch/powerpc/platforms/cell/iommu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/iommu.c
+++ linux-2.6/arch/powerpc/platforms/cell/iommu.c
@@ -417,7 +417,7 @@ static void cell_iommu_enable_hardware(s
 			IIC_IRQ_IOEX_ATI | (iommu->nid << IIC_IRQ_NODE_SHIFT));
 	BUG_ON(virq == NO_IRQ);
 
-	ret = request_irq(virq, ioc_interrupt, IRQF_DISABLED,
+	ret = request_irq(virq, ioc_interrupt, 0,
 			iommu->name, iommu);
 	BUG_ON(ret);
 
Index: linux-2.6/arch/powerpc/platforms/cell/pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/pmu.c
+++ linux-2.6/arch/powerpc/platforms/cell/pmu.c
@@ -391,7 +391,7 @@ static int __init cbe_init_pm_irq(void)
 		}
 
 		rc = request_irq(irq, cbe_pm_irq,
-				 IRQF_DISABLED, "cbe-pmu-0", NULL);
+				 0, "cbe-pmu-0", NULL);
 		if (rc) {
 			printk("ERROR: Request for irq on node %d failed\n",
 			       node);
Index: linux-2.6/arch/powerpc/platforms/cell/spu_base.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spu_base.c
+++ linux-2.6/arch/powerpc/platforms/cell/spu_base.c
@@ -440,7 +440,7 @@ static int spu_request_irqs(struct spu *
 		snprintf(spu->irq_c0, sizeof (spu->irq_c0), "spe%02d.0",
 			 spu->number);
 		ret = request_irq(spu->irqs[0], spu_irq_class_0,
-				  IRQF_DISABLED,
+				  0,
 				  spu->irq_c0, spu);
 		if (ret)
 			goto bail0;
@@ -449,7 +449,7 @@ static int spu_request_irqs(struct spu *
 		snprintf(spu->irq_c1, sizeof (spu->irq_c1), "spe%02d.1",
 			 spu->number);
 		ret = request_irq(spu->irqs[1], spu_irq_class_1,
-				  IRQF_DISABLED,
+				  0,
 				  spu->irq_c1, spu);
 		if (ret)
 			goto bail1;
@@ -458,7 +458,7 @@ static int spu_request_irqs(struct spu *
 		snprintf(spu->irq_c2, sizeof (spu->irq_c2), "spe%02d.2",
 			 spu->number);
 		ret = request_irq(spu->irqs[2], spu_irq_class_2,
-				  IRQF_DISABLED,
+				  0,
 				  spu->irq_c2, spu);
 		if (ret)
 			goto bail2;
Index: linux-2.6/arch/powerpc/platforms/powermac/pic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/pic.c
+++ linux-2.6/arch/powerpc/platforms/powermac/pic.c
@@ -273,7 +273,7 @@ static struct irqaction xmon_action = {
 
 static struct irqaction gatwick_cascade_action = {
 	.handler	= gatwick_action,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 	.mask		= CPU_MASK_NONE,
 	.name		= "cascade",
 };
Index: linux-2.6/arch/powerpc/platforms/powermac/smp.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/powermac/smp.c
+++ linux-2.6/arch/powerpc/platforms/powermac/smp.c
@@ -384,7 +384,7 @@ static void __init psurge_dual_sync_tb(i
 
 static struct irqaction psurge_irqaction = {
 	.handler = psurge_primary_intr,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.mask = CPU_MASK_NONE,
 	.name = "primary IPI",
 };
Index: linux-2.6/arch/powerpc/platforms/ps3/device-init.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/ps3/device-init.c
+++ linux-2.6/arch/powerpc/platforms/ps3/device-init.c
@@ -824,7 +824,7 @@ static int ps3_probe_thread(void *data)
 
 	spin_lock_init(&dev.lock);
 
-	res = request_irq(irq, ps3_notification_interrupt, IRQF_DISABLED,
+	res = request_irq(irq, ps3_notification_interrupt, 0,
 			  "ps3_notification", &dev);
 	if (res) {
 		pr_err("%s:%u: request_irq failed %d\n", __func__, __LINE__,
Index: linux-2.6/arch/powerpc/platforms/ps3/smp.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/ps3/smp.c
+++ linux-2.6/arch/powerpc/platforms/ps3/smp.c
@@ -120,7 +120,7 @@ static void __init ps3_smp_setup_cpu(int
 			__func__, __LINE__, cpu, i, virqs[i]);
 
 		result = request_irq(virqs[i], ipi_function_handler,
-			IRQF_DISABLED, names[i], (void*)(long)i);
+			0, names[i], (void*)(long)i);
 
 		if (result)
 			virqs[i] = NO_IRQ;
Index: linux-2.6/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6/arch/powerpc/platforms/pseries/xics.c
@@ -556,10 +556,10 @@ static void xics_request_ipi(void)
 	set_irq_handler(ipi, handle_percpu_irq);
 	if (firmware_has_feature(FW_FEATURE_LPAR))
 		rc = request_irq(ipi, xics_ipi_action_lpar,
-				IRQF_DISABLED|IRQF_PERCPU, "IPI", NULL);
+				IRQF_PERCPU, "IPI", NULL);
 	else
 		rc = request_irq(ipi, xics_ipi_action_direct,
-				IRQF_DISABLED|IRQF_PERCPU, "IPI", NULL);
+				IRQF_PERCPU, "IPI", NULL);
 	BUG_ON(rc);
 }
 
Index: linux-2.6/arch/powerpc/sysdev/ppc4xx_soc.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/ppc4xx_soc.c
+++ linux-2.6/arch/powerpc/sysdev/ppc4xx_soc.c
@@ -115,7 +115,7 @@ static int __init ppc4xx_l2c_probe(void)
 	}
 
 	/* Install error handler */
-	if (request_irq(irq, l2c_error_handler, IRQF_DISABLED, "L2C", 0) < 0) {
+	if (request_irq(irq, l2c_error_handler, 0, "L2C", 0) < 0) {
 		printk(KERN_ERR "Cannot install L2C error handler"
 		       ", cache is not enabled\n");
 		of_node_put(np);
Index: linux-2.6/arch/sh/boards/mach-cayman/irq.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-cayman/irq.c
+++ linux-2.6/arch/sh/boards/mach-cayman/irq.c
@@ -46,13 +46,13 @@ static irqreturn_t cayman_interrupt_pci2
 static struct irqaction cayman_action_smsc = {
 	.name		= "Cayman SMSC Mux",
 	.handler	= cayman_interrupt_smsc,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 };
 
 static struct irqaction cayman_action_pci2 = {
 	.name		= "Cayman PCI2 Mux",
 	.handler	= cayman_interrupt_pci2,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 };
 
 static void enable_cayman_irq(unsigned int irq)
Index: linux-2.6/arch/sh/boards/mach-hp6xx/hp6xx_apm.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-hp6xx/hp6xx_apm.c
+++ linux-2.6/arch/sh/boards/mach-hp6xx/hp6xx_apm.c
@@ -86,7 +86,7 @@ static int __init hp6x0_apm_init(void)
 	int ret;
 
 	ret = request_irq(HP680_BTN_IRQ, hp6x0_apm_interrupt,
-			  IRQF_DISABLED, MODNAME, NULL);
+			  0, MODNAME, NULL);
 	if (unlikely(ret < 0)) {
 		printk(KERN_ERR MODNAME ": IRQ %d request failed\n",
 		       HP680_BTN_IRQ);
Index: linux-2.6/arch/sh/boards/mach-snapgear/setup.c
===================================================================
--- linux-2.6.orig/arch/sh/boards/mach-snapgear/setup.c
+++ linux-2.6/arch/sh/boards/mach-snapgear/setup.c
@@ -41,7 +41,7 @@ static int __init eraseconfig_init(void)
 {
 	printk("SnapGear: EraseConfig init\n");
 	/* Setup "EraseConfig" switch on external IRQ 0 */
-	if (request_irq(IRL0_IRQ, eraseconfig_interrupt, IRQF_DISABLED,
+	if (request_irq(IRL0_IRQ, eraseconfig_interrupt, 0,
 				"Erase Config", NULL))
 		printk("SnapGear: failed to register IRQ%d for Reset witch\n",
 				IRL0_IRQ);
Index: linux-2.6/arch/sh/drivers/dma/dma-g2.c
===================================================================
--- linux-2.6.orig/arch/sh/drivers/dma/dma-g2.c
+++ linux-2.6/arch/sh/drivers/dma/dma-g2.c
@@ -170,7 +170,7 @@ static int __init g2_dma_init(void)
 {
 	int ret;
 
-	ret = request_irq(HW_EVENT_G2_DMA, g2_dma_interrupt, IRQF_DISABLED,
+	ret = request_irq(HW_EVENT_G2_DMA, g2_dma_interrupt, 0,
 			  "g2 DMA handler", &g2_dma_info);
 	if (unlikely(ret))
 		return -EINVAL;
Index: linux-2.6/arch/sh/drivers/dma/dma-pvr2.c
===================================================================
--- linux-2.6.orig/arch/sh/drivers/dma/dma-pvr2.c
+++ linux-2.6/arch/sh/drivers/dma/dma-pvr2.c
@@ -70,7 +70,7 @@ static int pvr2_xfer_dma(struct dma_chan
 static struct irqaction pvr2_dma_irq = {
 	.name		= "pvr2 DMA handler",
 	.handler	= pvr2_dma_interrupt,
-	.flags		= IRQF_DISABLED,
+	.flags		= 0,
 };
 
 static struct dma_ops pvr2_dma_ops = {
Index: linux-2.6/arch/sh/drivers/dma/dma-sh.c
===================================================================
--- linux-2.6.orig/arch/sh/drivers/dma/dma-sh.c
+++ linux-2.6/arch/sh/drivers/dma/dma-sh.c
@@ -94,7 +94,7 @@ static int sh_dmac_request_dma(struct dm
 		return 0;
 
 	return request_irq(get_dmte_irq(chan->chan), dma_tei,
-			   IRQF_DISABLED, chan->dev_id, chan);
+			   0, chan->dev_id, chan);
 }
 
 static void sh_dmac_free_dma(struct dma_channel *chan)
@@ -265,7 +265,7 @@ static int __init sh_dmac_init(void)
 	int i;
 
 #ifdef CONFIG_CPU_SH4
-	i = request_irq(DMAE_IRQ, dma_err, IRQF_DISABLED, "DMAC Address Error", 0);
+	i = request_irq(DMAE_IRQ, dma_err, 0, "DMAC Address Error", 0);
 	if (unlikely(i < 0))
 		return i;
 #endif
Index: linux-2.6/arch/sh/drivers/dma/dmabrg.c
===================================================================
--- linux-2.6.orig/arch/sh/drivers/dma/dmabrg.c
+++ linux-2.6/arch/sh/drivers/dma/dmabrg.c
@@ -173,17 +173,17 @@ static int __init dmabrg_init(void)
 	or = ctrl_inl(DMAOR);
 	ctrl_outl(or | DMAOR_BRG | DMAOR_DMEN, DMAOR);
 
-	ret = request_irq(DMABRGI0, dmabrg_irq, IRQF_DISABLED,
+	ret = request_irq(DMABRGI0, dmabrg_irq, 0,
 			"DMABRG USB address error", NULL);
 	if (ret)
 		goto out0;
 
-	ret = request_irq(DMABRGI1, dmabrg_irq, IRQF_DISABLED,
+	ret = request_irq(DMABRGI1, dmabrg_irq, 0,
 			"DMABRG Transfer End", NULL);
 	if (ret)
 		goto out1;
 
-	ret = request_irq(DMABRGI2, dmabrg_irq, IRQF_DISABLED,
+	ret = request_irq(DMABRGI2, dmabrg_irq, 0,
 			"DMABRG Transfer Half", NULL);
 	if (ret == 0)
 		return ret;
Index: linux-2.6/arch/sh/drivers/pci/pci-sh5.c
===================================================================
--- linux-2.6.orig/arch/sh/drivers/pci/pci-sh5.c
+++ linux-2.6/arch/sh/drivers/pci/pci-sh5.c
@@ -95,13 +95,13 @@ int __init sh5pci_init(unsigned long mem
 	u32 uval;
 
         if (request_irq(IRQ_ERR, pcish5_err_irq,
-                        IRQF_DISABLED, "PCI Error",NULL) < 0) {
+                        0, "PCI Error",NULL) < 0) {
                 printk(KERN_ERR "PCISH5: Cannot hook PCI_PERR interrupt\n");
                 return -EINVAL;
         }
 
         if (request_irq(IRQ_SERR, pcish5_serr_irq,
-                        IRQF_DISABLED, "PCI SERR interrupt", NULL) < 0) {
+                        0, "PCI SERR interrupt", NULL) < 0) {
                 printk(KERN_ERR "PCISH5: Cannot hook PCI_SERR interrupt\n");
                 return -EINVAL;
         }
Index: linux-2.6/arch/sh/drivers/push-switch.c
===================================================================
--- linux-2.6.orig/arch/sh/drivers/push-switch.c
+++ linux-2.6/arch/sh/drivers/push-switch.c
@@ -62,7 +62,7 @@ static int switch_drv_probe(struct platf
 	BUG_ON(!psw_info);
 
 	ret = request_irq(irq, psw_info->irq_handler,
-			  IRQF_DISABLED | psw_info->irq_flags,
+			   psw_info->irq_flags,
 			  psw_info->name ? psw_info->name : DRV_NAME, pdev);
 	if (unlikely(ret < 0))
 		goto err;
Index: linux-2.6/arch/sh/kernel/cpu/sh4a/smp-shx3.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/sh4a/smp-shx3.c
+++ linux-2.6/arch/sh/kernel/cpu/sh4a/smp-shx3.c
@@ -61,7 +61,7 @@ void __init plat_prepare_cpus(unsigned i
 	BUILD_BUG_ON(SMP_MSG_NR >= 8);
 
 	for (i = 0; i < SMP_MSG_NR; i++)
-		request_irq(104 + i, ipi_interrupt_handler, IRQF_DISABLED,
+		request_irq(104 + i, ipi_interrupt_handler, 0,
 			    "IPI", (void *)(long)i);
 }
 
Index: linux-2.6/arch/sh/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/time_64.c
+++ linux-2.6/arch/sh/kernel/time_64.c
@@ -283,7 +283,7 @@ static irqreturn_t timer_interrupt(int i
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
+	.flags = 0,
 	.mask = CPU_MASK_NONE,
 	.name = "timer",
 };
Index: linux-2.6/arch/sh/kernel/timers/timer-cmt.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/timers/timer-cmt.c
+++ linux-2.6/arch/sh/kernel/timers/timer-cmt.c
@@ -108,7 +108,7 @@ static irqreturn_t cmt_timer_interrupt(i
 static struct irqaction cmt_irq = {
 	.name		= "timer",
 	.handler	= cmt_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6/arch/sh/kernel/timers/timer-mtu2.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/timers/timer-mtu2.c
+++ linux-2.6/arch/sh/kernel/timers/timer-mtu2.c
@@ -113,7 +113,7 @@ static irqreturn_t mtu2_timer_interrupt(
 static struct irqaction mtu2_irq = {
 	.name		= "timer",
 	.handler	= mtu2_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6/arch/sh/kernel/timers/timer-tmu.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/timers/timer-tmu.c
+++ linux-2.6/arch/sh/kernel/timers/timer-tmu.c
@@ -154,7 +154,7 @@ static irqreturn_t tmu_timer_interrupt(i
 static struct irqaction tmu0_irq = {
 	.name		= "periodic/oneshot timer",
 	.handler	= tmu_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		=  IRQF_TIMER | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
 };
 
Index: linux-2.6/arch/sparc/include/asm/floppy_32.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/floppy_32.h
+++ linux-2.6/arch/sparc/include/asm/floppy_32.h
@@ -293,7 +293,7 @@ static int sun_fd_request_irq(void)
 	if(!once) {
 		once = 1;
 		error = sparc_floppy_request_irq(FLOPPY_IRQ,
-						 IRQF_DISABLED,
+						 0,
 						 floppy_interrupt);
 		return ((error == 0) ? 0 : -1);
 	} else return 0;
Index: linux-2.6/arch/sparc/include/asm/floppy_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/floppy_64.h
+++ linux-2.6/arch/sparc/include/asm/floppy_64.h
@@ -258,7 +258,7 @@ static int sun_fd_request_irq(void)
 		once = 1;
 
 		error = request_irq(FLOPPY_IRQ, sparc_floppy_irq,
-				    IRQF_DISABLED, "floppy", NULL);
+				    0, "floppy", NULL);
 
 		return ((error == 0) ? 0 : -1);
 	}
Index: linux-2.6/arch/sparc/kernel/irq_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/irq_32.c
+++ linux-2.6/arch/sparc/kernel/irq_32.c
@@ -192,13 +192,9 @@ int show_interrupts(struct seq_file *p, 
 				    kstat_cpu(j).irqs[i]);
 		}
 #endif
-		seq_printf(p, " %c %s",
-			(action->flags & IRQF_DISABLED) ? '+' : ' ',
-			action->name);
+		seq_printf(p, " %c %s", '+', action->name);
 		for (action=action->next; action; action = action->next) {
-			seq_printf(p, ",%s %s",
-				(action->flags & IRQF_DISABLED) ? " +" : "",
-				action->name);
+			seq_printf(p, ",%s %s", '+', action->name);
 		}
 		seq_putc(p, '\n');
 	}
@@ -544,11 +540,6 @@ int request_irq(unsigned int irq,
 			ret = -EBUSY;
 			goto out_unlock;
 		}
-		if ((action->flags & IRQF_DISABLED) != (irqflags & IRQF_DISABLED)) {
-			printk("Attempt to mix fast and slow interrupts on IRQ%d denied\n", irq);
-			ret = -EBUSY;
-			goto out_unlock;
-		}
 		for ( ; action; action = *actionp)
 			actionp = &action->next;
 	}
Index: linux-2.6/arch/sparc/kernel/pcic.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/pcic.c
+++ linux-2.6/arch/sparc/kernel/pcic.c
@@ -738,7 +738,7 @@ void __init pci_time_init(void)
 	writel (PCI_COUNTER_IRQ_SET(timer_irq, 0),
 		pcic->pcic_regs+PCI_COUNTER_IRQ);
 	irq = request_irq(timer_irq, pcic_timer_handler,
-			  (IRQF_DISABLED | SA_STATIC_ALLOC), "timer", NULL);
+			  ( SA_STATIC_ALLOC), "timer", NULL);
 	if (irq) {
 		prom_printf("time_init: unable to attach IRQ%d\n", timer_irq);
 		prom_halt();
Index: linux-2.6/arch/sparc/kernel/sun4c_irq.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sun4c_irq.c
+++ linux-2.6/arch/sparc/kernel/sun4c_irq.c
@@ -175,7 +175,7 @@ static void __init sun4c_init_timers(irq
 	master_l10_counter = &sun4c_timers->l10_count;
 
 	err = request_irq(irq[0].pri, counter_fn,
-			  (IRQF_DISABLED | SA_STATIC_ALLOC),
+			  ( SA_STATIC_ALLOC),
 			  "timer", NULL);
 	if (err) {
 		prom_printf("sun4c_init_timers: request_irq() fails with %d\n", err);
Index: linux-2.6/arch/sparc/kernel/sun4d_irq.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sun4d_irq.c
+++ linux-2.6/arch/sparc/kernel/sun4d_irq.c
@@ -115,15 +115,11 @@ found_it:	seq_printf(p, "%3d: ", i);
 			seq_printf(p, "%10u ",
 			       kstat_cpu(cpu_logical_map(x)).irqs[i]);
 #endif
-		seq_printf(p, "%c %s",
-			(action->flags & IRQF_DISABLED) ? '+' : ' ',
-			action->name);
+		seq_printf(p, "%c %s", '+', action->name);
 		action = action->next;
 		for (;;) {
 			for (; action; action = action->next) {
-				seq_printf(p, ",%s %s",
-					(action->flags & IRQF_DISABLED) ? " +" : "",
-					action->name);
+				seq_printf(p, ",%s %s", '+', action->name);
 			}
 			if (!sbusl) break;
 			k++;
@@ -297,11 +293,6 @@ int sun4d_request_irq(unsigned int irq,
 			ret = -EBUSY;
 			goto out_unlock;
 		}
-		if ((action->flags & IRQF_DISABLED) ^ (irqflags & IRQF_DISABLED)) {
-			printk("Attempt to mix fast and slow interrupts on IRQ%d denied\n", irq);
-			ret = -EBUSY;
-			goto out_unlock;
-		}
 		action = NULL;		/* Or else! */
 	}
 
@@ -529,7 +520,7 @@ static void __init sun4d_init_timers(irq
 	master_l10_counter = &sun4d_timers->l10_cur_count;
 
 	err = request_irq(TIMER_IRQ, counter_fn,
-			  (IRQF_DISABLED | SA_STATIC_ALLOC),
+			  ( SA_STATIC_ALLOC),
 			  "timer", NULL);
 	if (err) {
 		prom_printf("sun4d_init_timers: request_irq() failed with %d\n", err);
Index: linux-2.6/arch/sparc/kernel/sun4m_irq.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/sun4m_irq.c
+++ linux-2.6/arch/sparc/kernel/sun4m_irq.c
@@ -393,7 +393,7 @@ static void __init sun4m_init_timers(irq
 	master_l10_counter = &timers_global->l10_count;
 
 	err = request_irq(TIMER_IRQ, counter_fn,
-			  (IRQF_DISABLED | SA_STATIC_ALLOC), "timer", NULL);
+			  ( SA_STATIC_ALLOC), "timer", NULL);
 	if (err) {
 		printk(KERN_ERR "sun4m_init_timers: Register IRQ error %d.\n",
 			err);
Index: linux-2.6/arch/um/drivers/line.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/line.c
+++ linux-2.6/arch/um/drivers/line.c
@@ -371,7 +371,7 @@ static irqreturn_t line_write_interrupt(
 int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
 {
 	const struct line_driver *driver = line->driver;
-	int err = 0, flags = IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM;
+	int err = 0, flags =  IRQF_SHARED | IRQF_SAMPLE_RANDOM;
 
 	if (input)
 		err = um_request_irq(driver->read_irq, fd, IRQ_READ,
@@ -795,7 +795,7 @@ void register_winch_irq(int fd, int tty_
 				   .stack	= stack });
 
 	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
-			   IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+			    IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			   "winch", winch) < 0) {
 		printk(KERN_ERR "register_winch_irq - failed to register "
 		       "IRQ\n");
Index: linux-2.6/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/mconsole_kern.c
+++ linux-2.6/arch/um/drivers/mconsole_kern.c
@@ -805,7 +805,7 @@ static int __init mconsole_init(void)
 	register_reboot_notifier(&reboot_notifier);
 
 	err = um_request_irq(MCONSOLE_IRQ, sock, IRQ_READ, mconsole_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+			      IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			     "mconsole", (void *)sock);
 	if (err) {
 		printk(KERN_ERR "Failed to get IRQ for management console\n");
Index: linux-2.6/arch/um/drivers/net_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/net_kern.c
+++ linux-2.6/arch/um/drivers/net_kern.c
@@ -165,7 +165,7 @@ static int uml_net_open(struct net_devic
 	}
 
 	err = um_request_irq(dev->irq, lp->fd, IRQ_READ, uml_net_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED, dev->name, dev);
+			      IRQF_SHARED, dev->name, dev);
 	if (err != 0) {
 		printk(KERN_ERR "uml_net_open: failed to get irq(%d)\n", err);
 		err = -ENETUNREACH;
Index: linux-2.6/arch/um/drivers/port_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/port_kern.c
+++ linux-2.6/arch/um/drivers/port_kern.c
@@ -98,7 +98,7 @@ static int port_accept(struct port_list 
 		  .port 	= port });
 
 	if (um_request_irq(TELNETD_IRQ, socket[0], IRQ_READ, pipe_interrupt,
-			  IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+			   IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			  "telnetd", conn)) {
 		printk(KERN_ERR "port_accept : failed to get IRQ for "
 		       "telnetd\n");
@@ -182,7 +182,7 @@ void *port_data(int port_num)
 	}
 
 	if (um_request_irq(ACCEPT_IRQ, fd, IRQ_READ, port_interrupt,
-			  IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+			   IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			  "port", port)) {
 		printk(KERN_ERR "Failed to get IRQ for port %d\n", port_num);
 		goto out_close;
Index: linux-2.6/arch/um/drivers/random.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/random.c
+++ linux-2.6/arch/um/drivers/random.c
@@ -133,7 +133,7 @@ static int __init rng_init (void)
 	random_fd = err;
 
 	err = um_request_irq(RANDOM_IRQ, random_fd, IRQ_READ, random_interrupt,
-			     IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "random",
+			      IRQF_SAMPLE_RANDOM, "random",
 			     NULL);
 	if (err)
 		goto err_out_cleanup_hw;
Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c
+++ linux-2.6/arch/um/drivers/ubd_kern.c
@@ -1104,7 +1104,7 @@ static int __init ubd_driver_init(void){
 		return 0;
 	}
 	err = um_request_irq(UBD_IRQ, thread_fd, IRQ_READ, ubd_intr,
-			     IRQF_DISABLED, "ubd", ubd_devs);
+			     0, "ubd", ubd_devs);
 	if(err != 0)
 		printk(KERN_ERR "um_request_irq failed - errno = %d\n", -err);
 	return 0;
Index: linux-2.6/arch/um/drivers/xterm_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/xterm_kern.c
+++ linux-2.6/arch/um/drivers/xterm_kern.c
@@ -50,7 +50,7 @@ int xterm_fd(int socket, int *pid_out)
 	init_completion(&data->ready);
 
 	err = um_request_irq(XTERM_IRQ, socket, IRQ_READ, xterm_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED | IRQF_SAMPLE_RANDOM,
+			      IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			     "xterm", data);
 	if (err) {
 		printk(KERN_ERR "xterm_fd : failed to get IRQ for xterm, "
Index: linux-2.6/arch/um/kernel/sigio.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/sigio.c
+++ linux-2.6/arch/um/kernel/sigio.c
@@ -25,7 +25,7 @@ int write_sigio_irq(int fd)
 	int err;
 
 	err = um_request_irq(SIGIO_WRITE_IRQ, fd, IRQ_READ, sigio_interrupt,
-			     IRQF_DISABLED|IRQF_SAMPLE_RANDOM, "write sigio",
+			     IRQF_SAMPLE_RANDOM, "write sigio",
 			     NULL);
 	if (err) {
 		printk(KERN_ERR "write_sigio_irq : um_request_irq failed, "
Index: linux-2.6/arch/um/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/time.c
+++ linux-2.6/arch/um/kernel/time.c
@@ -84,7 +84,7 @@ static void __init setup_itimer(void)
 {
 	int err;
 
-	err = request_irq(TIMER_IRQ, um_timer, IRQF_DISABLED, "timer", NULL);
+	err = request_irq(TIMER_IRQ, um_timer, 0, "timer", NULL);
 	if (err != 0)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
Index: linux-2.6/arch/x86/include/asm/floppy.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/floppy.h
+++ linux-2.6/arch/x86/include/asm/floppy.h
@@ -145,10 +145,10 @@ static int fd_request_irq(void)
 {
 	if (can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static unsigned long dma_mem_alloc(unsigned long size)
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -494,7 +494,7 @@ static int hpet_setup_irq(struct hpet_de
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
+			IRQF_NOBALANCING, dev->name, dev))
 		return -1;
 
 	disable_irq(dev->irq);
Index: linux-2.6/arch/x86/kernel/mfgpt_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mfgpt_32.c
+++ linux-2.6/arch/x86/kernel/mfgpt_32.c
@@ -347,7 +347,7 @@ static irqreturn_t mfgpt_tick(int irq, v
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING,
+	.flags =  IRQF_NOBALANCING,
 	.mask = CPU_MASK_NONE,
 	.name = "mfgpt-timer"
 };
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -1025,7 +1025,7 @@ void __init x86_quirk_trap_init(void)
 
 static struct irqaction irq0  = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
+	.flags =  IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER,
 	.mask = CPU_MASK_NONE,
 	.name = "timer"
 };
Index: linux-2.6/arch/x86/kernel/time_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_64.c
+++ linux-2.6/arch/x86/kernel/time_64.c
@@ -115,7 +115,7 @@ unsigned long __init calibrate_cpu(void)
 
 static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_IRQPOLL | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags		=  IRQF_IRQPOLL | IRQF_NOBALANCING | IRQF_TIMER,
 	.mask		= CPU_MASK_NONE,
 	.name		= "timer"
 };
Index: linux-2.6/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmiclock_32.c
+++ linux-2.6/arch/x86/kernel/vmiclock_32.c
@@ -201,7 +201,7 @@ static irqreturn_t vmi_timer_interrupt(i
 static struct irqaction vmi_clock_action  = {
 	.name 		= "vmi-timer",
 	.handler 	= vmi_timer_interrupt,
-	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags 		=  IRQF_NOBALANCING | IRQF_TIMER,
 	.mask 		= CPU_MASK_ALL,
 };
 
Index: linux-2.6/arch/x86/xen/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/smp.c
+++ linux-2.6/arch/x86/xen/smp.c
@@ -98,7 +98,7 @@ static int xen_smp_intr_init(unsigned in
 	rc = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR,
 				    cpu,
 				    xen_reschedule_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    resched_name,
 				    NULL);
 	if (rc < 0)
@@ -109,7 +109,7 @@ static int xen_smp_intr_init(unsigned in
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
 				    cpu,
 				    xen_call_function_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
 	if (rc < 0)
@@ -118,7 +118,7 @@ static int xen_smp_intr_init(unsigned in
 
 	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
 	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
-				     IRQF_DISABLED | IRQF_PERCPU | IRQF_NOBALANCING,
+				      IRQF_PERCPU | IRQF_NOBALANCING,
 				     debug_name, NULL);
 	if (rc < 0)
 		goto fail;
@@ -128,7 +128,7 @@ static int xen_smp_intr_init(unsigned in
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
 				    cpu,
 				    xen_call_function_single_interrupt,
-				    IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				    IRQF_PERCPU|IRQF_NOBALANCING,
 				    callfunc_name,
 				    NULL);
 	if (rc < 0)
Index: linux-2.6/arch/x86/xen/spinlock.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/spinlock.c
+++ linux-2.6/arch/x86/xen/spinlock.c
@@ -345,7 +345,7 @@ void __cpuinit xen_init_lock_cpu(int cpu
 	irq = bind_ipi_to_irqhandler(XEN_SPIN_UNLOCK_VECTOR,
 				     cpu,
 				     dummy_handler,
-				     IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				     IRQF_PERCPU|IRQF_NOBALANCING,
 				     name,
 				     NULL);
 
Index: linux-2.6/arch/x86/xen/time.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/time.c
+++ linux-2.6/arch/x86/xen/time.c
@@ -429,7 +429,7 @@ void xen_setup_timer(int cpu)
 		name = "<timer kasprintf failed>";
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
+				      IRQF_PERCPU|IRQF_NOBALANCING,
 				      name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);
Index: linux-2.6/arch/xtensa/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/time.c
+++ linux-2.6/arch/xtensa/kernel/time.c
@@ -49,7 +49,7 @@ unsigned long long sched_clock(void)
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED,
+	.flags =	0,
 	.name =		"timer",
 };
 
Index: linux-2.6/drivers/ata/pata_mpc52xx.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_mpc52xx.c
+++ linux-2.6/drivers/ata/pata_mpc52xx.c
@@ -780,7 +780,7 @@ mpc52xx_ata_probe(struct of_device *op, 
 	}
 
 	task_irq = bcom_get_task_irq(dmatsk);
-	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, IRQF_DISABLED,
+	ret = request_irq(task_irq, &mpc52xx_ata_task_irq, 0,
 				"ATA task", priv);
 	if (ret) {
 		dev_err(&op->dev, "error requesting DMA IRQ\n");
Index: linux-2.6/drivers/atm/he.c
===================================================================
--- linux-2.6.orig/drivers/atm/he.c
+++ linux-2.6/drivers/atm/he.c
@@ -960,7 +960,7 @@ he_init_irq(struct he_dev *he_dev)
 	he_writel(he_dev, 0x0, GRP_54_MAP);
 	he_writel(he_dev, 0x0, GRP_76_MAP);
 
-	if (request_irq(he_dev->pci_dev->irq, he_irq_handler, IRQF_DISABLED|IRQF_SHARED, DEV_LABEL, he_dev)) {
+	if (request_irq(he_dev->pci_dev->irq, he_irq_handler, IRQF_SHARED, DEV_LABEL, he_dev)) {
 		hprintk("irq %d already in use\n", he_dev->pci_dev->irq);
 		return -EINVAL;
 	}   
Index: linux-2.6/drivers/atm/idt77252.c
===================================================================
--- linux-2.6.orig/drivers/atm/idt77252.c
+++ linux-2.6/drivers/atm/idt77252.c
@@ -3363,7 +3363,7 @@ init_card(struct atm_dev *dev)
 		writel(SAR_STAT_TMROF, SAR_REG_STAT);
 	}
 	IPRINTK("%s: Request IRQ ... ", card->name);
-	if (request_irq(pcidev->irq, idt77252_interrupt, IRQF_DISABLED|IRQF_SHARED,
+	if (request_irq(pcidev->irq, idt77252_interrupt, IRQF_SHARED,
 			card->name, card) != 0) {
 		printk("%s: can't allocate IRQ.\n", card->name);
 		deinit_card(card);
Index: linux-2.6/drivers/atm/nicstar.c
===================================================================
--- linux-2.6.orig/drivers/atm/nicstar.c
+++ linux-2.6/drivers/atm/nicstar.c
@@ -780,7 +780,7 @@ static int __devinit ns_init_card(int i,
    card->efbie = 1;
 
    card->intcnt = 0;
-   if (request_irq(pcidev->irq, &ns_irq_handler, IRQF_DISABLED | IRQF_SHARED, "nicstar", card) != 0)
+   if (request_irq(pcidev->irq, &ns_irq_handler,  IRQF_SHARED, "nicstar", card) != 0)
    {
       printk("nicstar%d: can't allocate IRQ %d.\n", i, pcidev->irq);
       error = 9;
Index: linux-2.6/drivers/atm/solos-pci.c
===================================================================
--- linux-2.6.orig/drivers/atm/solos-pci.c
+++ linux-2.6/drivers/atm/solos-pci.c
@@ -668,7 +668,7 @@ static int fpga_probe(struct pci_dev *de
 	}
 */
 	//dev_dbg(&card->dev->dev, "Requesting IRQ: %d\n",dev->irq);
-	err = request_irq(dev->irq, solos_irq, IRQF_DISABLED|IRQF_SHARED,
+	err = request_irq(dev->irq, solos_irq, IRQF_SHARED,
 			  "solos-pci", card);
 	if (err)
 		dev_dbg(&card->dev->dev, "Failed to request interrupt IRQ: %d\n", dev->irq);
Index: linux-2.6/drivers/block/cciss.c
===================================================================
--- linux-2.6.orig/drivers/block/cciss.c
+++ linux-2.6/drivers/block/cciss.c
@@ -3669,7 +3669,7 @@ static int __devinit cciss_init_one(stru
 	/* make sure the board interrupts are off */
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_OFF);
 	if (request_irq(hba[i]->intr[SIMPLE_MODE_INT], do_cciss_intr,
-			IRQF_DISABLED | IRQF_SHARED, hba[i]->devname, hba[i])) {
+			 IRQF_SHARED, hba[i]->devname, hba[i])) {
 		printk(KERN_ERR "cciss: Unable to get irq %d for %s\n",
 		       hba[i]->intr[SIMPLE_MODE_INT], hba[i]->devname);
 		goto clean2;
Index: linux-2.6/drivers/block/cpqarray.c
===================================================================
--- linux-2.6.orig/drivers/block/cpqarray.c
+++ linux-2.6/drivers/block/cpqarray.c
@@ -407,7 +407,7 @@ static int __init cpqarray_register_ctlr
 	}
 	hba[i]->access.set_intr_mask(hba[i], 0);
 	if (request_irq(hba[i]->intr, do_ida_intr,
-		IRQF_DISABLED|IRQF_SHARED, hba[i]->devname, hba[i]))
+		IRQF_SHARED, hba[i]->devname, hba[i]))
 	{
 		printk(KERN_ERR "cpqarray: Unable to get irq %d for %s\n",
 				hba[i]->intr, hba[i]->devname);
Index: linux-2.6/drivers/block/hd.c
===================================================================
--- linux-2.6.orig/drivers/block/hd.c
+++ linux-2.6/drivers/block/hd.c
@@ -762,7 +762,7 @@ static int __init hd_init(void)
 			p->cyl, p->head, p->sect);
 	}
 
-	if (request_irq(HD_IRQ, hd_interrupt, IRQF_DISABLED, "hd", NULL)) {
+	if (request_irq(HD_IRQ, hd_interrupt, 0, "hd", NULL)) {
 		printk("hd: unable to get IRQ%d for the hard disk driver\n",
 			HD_IRQ);
 		goto out1;
Index: linux-2.6/drivers/cdrom/gdrom.c
===================================================================
--- linux-2.6.orig/drivers/cdrom/gdrom.c
+++ linux-2.6/drivers/cdrom/gdrom.c
@@ -545,11 +545,11 @@ static int __devinit gdrom_set_interrupt
 	int err;
 
 	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt,
-		IRQF_DISABLED, "gdrom_command", &gd);
+		0, "gdrom_command", &gd);
 	if (err)
 		return err;
 	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt,
-		IRQF_DISABLED, "gdrom_dma", &gd);
+		0, "gdrom_dma", &gd);
 	if (err)
 		free_irq(HW_EVENT_GDROM_CMD, &gd);
 	return err;
Index: linux-2.6/drivers/char/amiserial.c
===================================================================
--- linux-2.6.orig/drivers/char/amiserial.c
+++ linux-2.6/drivers/char/amiserial.c
@@ -2033,7 +2033,7 @@ static int __init rs_init(void)
 	if (error)
 		goto fail_unregister;
 
-	error = request_irq(IRQ_AMIGA_RBF, ser_rx_int, IRQF_DISABLED,
+	error = request_irq(IRQ_AMIGA_RBF, ser_rx_int, 0,
 			    "serial RX", state);
 	if (error)
 		goto fail_free_irq;
Index: linux-2.6/drivers/char/cyclades.c
===================================================================
--- linux-2.6.orig/drivers/char/cyclades.c
+++ linux-2.6/drivers/char/cyclades.c
@@ -4611,7 +4611,7 @@ static int __init cy_detect_isa(void)
 
 		/* allocate IRQ */
 		if (request_irq(cy_isa_irq, cyy_interrupt,
-				IRQF_DISABLED, "Cyclom-Y", &cy_card[j])) {
+				0, "Cyclom-Y", &cy_card[j])) {
 			printk(KERN_ERR "Cyclom-Y/ISA found at 0x%lx, but "
 				"could not allocate IRQ#%d.\n",
 				(unsigned long)cy_isa_address, cy_isa_irq);
Index: linux-2.6/drivers/char/hpet.c
===================================================================
--- linux-2.6.orig/drivers/char/hpet.c
+++ linux-2.6/drivers/char/hpet.c
@@ -478,8 +478,7 @@ static int hpet_ioctl_ieon(struct hpet_d
 		unsigned long irq_flags;
 
 		sprintf(devp->hd_name, "hpet%d", (int)(devp - hpetp->hp_dev));
-		irq_flags = devp->hd_flags & HPET_SHARED_IRQ
-						? IRQF_SHARED : IRQF_DISABLED;
+		irq_flags = devp->hd_flags & HPET_SHARED_IRQ ? IRQF_SHARED : 0;
 		if (request_irq(irq, hpet_interrupt, irq_flags,
 				devp->hd_name, (void *)devp)) {
 			printk(KERN_ERR "hpet: IRQ %d is not free\n", irq);
Index: linux-2.6/drivers/char/hvc_irq.c
===================================================================
--- linux-2.6.orig/drivers/char/hvc_irq.c
+++ linux-2.6/drivers/char/hvc_irq.c
@@ -28,7 +28,7 @@ int notifier_add_irq(struct hvc_struct *
 		hp->irq_requested = 0;
 		return 0;
 	}
-	rc = request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED,
+	rc = request_irq(irq, hvc_handle_interrupt, 0,
 			   "hvc_console", hp);
 	if (!rc)
 		hp->irq_requested = 1;
Index: linux-2.6/drivers/char/hvcs.c
===================================================================
--- linux-2.6.orig/drivers/char/hvcs.c
+++ linux-2.6/drivers/char/hvcs.c
@@ -1047,7 +1047,7 @@ static int hvcs_enable_device(struct hvc
 	 * the conn was registered and now.
 	 */
 	if (!(rc = request_irq(irq, &hvcs_handle_interrupt,
-				IRQF_DISABLED, "ibmhvcs", hvcsd))) {
+				0, "ibmhvcs", hvcsd))) {
 		/*
 		 * It is possible the vty-server was removed after the irq was
 		 * requested but before we have time to enable interrupts.
Index: linux-2.6/drivers/char/hvsi.c
===================================================================
--- linux-2.6.orig/drivers/char/hvsi.c
+++ linux-2.6/drivers/char/hvsi.c
@@ -1169,7 +1169,7 @@ static int __init hvsi_init(void)
 		struct hvsi_struct *hp = &hvsi_ports[i];
 		int ret = 1;
 
-		ret = request_irq(hp->virq, hvsi_interrupt, IRQF_DISABLED, "hvsi", hp);
+		ret = request_irq(hp->virq, hvsi_interrupt, 0, "hvsi", hp);
 		if (ret)
 			printk(KERN_ERR "HVSI: couldn't reserve irq 0x%x (error %i)\n",
 				hp->virq, ret);
Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -1233,7 +1233,7 @@ static int std_irq_setup(struct smi_info
 	if (info->si_type == SI_BT) {
 		rv = request_irq(info->irq,
 				 si_bt_irq_handler,
-				 IRQF_SHARED | IRQF_DISABLED,
+				 IRQF_SHARED ,
 				 DEVICE_NAME,
 				 info);
 		if (!rv)
@@ -1243,7 +1243,7 @@ static int std_irq_setup(struct smi_info
 	} else
 		rv = request_irq(info->irq,
 				 si_irq_handler,
-				 IRQF_SHARED | IRQF_DISABLED,
+				 IRQF_SHARED ,
 				 DEVICE_NAME,
 				 info);
 	if (rv) {
Index: linux-2.6/drivers/char/isicom.c
===================================================================
--- linux-2.6.orig/drivers/char/isicom.c
+++ linux-2.6/drivers/char/isicom.c
@@ -1624,7 +1624,7 @@ static int __devinit isicom_probe(struct
 	}
 
 	retval = request_irq(board->irq, isicom_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, ISICOM_NAME, board);
+			IRQF_SHARED , ISICOM_NAME, board);
 	if (retval < 0) {
 		dev_err(&pdev->dev, "Could not install handler at Irq %d. "
 			"Card%d will be disabled.\n", board->irq, index + 1);
Index: linux-2.6/drivers/char/nwbutton.c
===================================================================
--- linux-2.6.orig/drivers/char/nwbutton.c
+++ linux-2.6/drivers/char/nwbutton.c
@@ -219,7 +219,7 @@ static int __init nwbutton_init(void)
 		return -EBUSY;
 	}
 
-	if (request_irq (IRQ_NETWINDER_BUTTON, button_handler, IRQF_DISABLED,
+	if (request_irq (IRQ_NETWINDER_BUTTON, button_handler, 0,
 			"nwbutton", NULL)) {
 		printk (KERN_WARNING "nwbutton: IRQ %d is not free.\n",
 				IRQ_NETWINDER_BUTTON);
Index: linux-2.6/drivers/char/riscom8.c
===================================================================
--- linux-2.6.orig/drivers/char/riscom8.c
+++ linux-2.6/drivers/char/riscom8.c
@@ -597,7 +597,7 @@ static int rc_setup_board(struct riscom_
 	if (bp->flags & RC_BOARD_ACTIVE)
 		return 0;
 
-	error = request_irq(bp->irq, rc_interrupt, IRQF_DISABLED,
+	error = request_irq(bp->irq, rc_interrupt, 0,
 			    "RISCom/8", bp);
 	if (error)
 		return error;
Index: linux-2.6/drivers/char/rtc.c
===================================================================
--- linux-2.6.orig/drivers/char/rtc.c
+++ linux-2.6/drivers/char/rtc.c
@@ -1044,7 +1044,7 @@ no_irq:
 		rtc_int_handler_ptr = rtc_interrupt;
 	}
 
-	if (request_irq(RTC_IRQ, rtc_int_handler_ptr, IRQF_DISABLED,
+	if (request_irq(RTC_IRQ, rtc_int_handler_ptr, 0,
 			"rtc", NULL)) {
 		/* Yeah right, seeing as irq 8 doesn't even hit the bus. */
 		rtc_has_irq = 0;
Index: linux-2.6/drivers/char/snsc.c
===================================================================
--- linux-2.6.orig/drivers/char/snsc.c
+++ linux-2.6/drivers/char/snsc.c
@@ -107,7 +107,7 @@ scdrv_open(struct inode *inode, struct f
 	/* hook this subchannel up to the system controller interrupt */
 	lock_kernel();
 	rv = request_irq(SGI_UART_VECTOR, scdrv_interrupt,
-			 IRQF_SHARED | IRQF_DISABLED,
+			 IRQF_SHARED ,
 			 SYSCTL_BASENAME, sd);
 	if (rv) {
 		ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
Index: linux-2.6/drivers/char/snsc_event.c
===================================================================
--- linux-2.6.orig/drivers/char/snsc_event.c
+++ linux-2.6/drivers/char/snsc_event.c
@@ -291,7 +291,7 @@ scdrv_event_init(struct sysctl_data_s *s
 
 	/* hook event subchannel up to the system controller interrupt */
 	rv = request_irq(SGI_UART_VECTOR, scdrv_event_interrupt,
-			 IRQF_SHARED | IRQF_DISABLED,
+			 IRQF_SHARED ,
 			 "system controller events", event_sd);
 	if (rv) {
 		printk(KERN_WARNING "%s: irq request failed (%d)\n",
Index: linux-2.6/drivers/char/specialix.c
===================================================================
--- linux-2.6.orig/drivers/char/specialix.c
+++ linux-2.6/drivers/char/specialix.c
@@ -909,10 +909,10 @@ static int sx_setup_board(struct special
 
 	if (bp->flags & SX_BOARD_IS_PCI)
 		error = request_irq(bp->irq, sx_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "specialix IO8+", bp);
+			 IRQF_SHARED, "specialix IO8+", bp);
 	else
 		error = request_irq(bp->irq, sx_interrupt,
-			IRQF_DISABLED, "specialix IO8+", bp);
+			0, "specialix IO8+", bp);
 
 	if (error)
 		return error;
Index: linux-2.6/drivers/char/sx.c
===================================================================
--- linux-2.6.orig/drivers/char/sx.c
+++ linux-2.6/drivers/char/sx.c
@@ -2096,7 +2096,7 @@ static int sx_init_board(struct sx_board
 			/* fixed irq, probably PCI */
 			if (sx_irqmask & (1 << board->irq)) {	/* may we use this irq? */
 				if (request_irq(board->irq, sx_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED ,
 						"sx", board)) {
 					printk(KERN_ERR "sx: Cannot allocate "
 						"irq %d.\n", board->irq);
@@ -2112,7 +2112,7 @@ static int sx_init_board(struct sx_board
 			for (irqnr = 15; irqnr > 0; irqnr--)
 				if (irqmask & (1 << irqnr))
 					if (!request_irq(irqnr, sx_interrupt,
-						IRQF_SHARED | IRQF_DISABLED,
+						IRQF_SHARED ,
 						"sx", board))
 						break;
 			if (!irqnr)
Index: linux-2.6/drivers/char/tlclk.c
===================================================================
--- linux-2.6.orig/drivers/char/tlclk.c
+++ linux-2.6/drivers/char/tlclk.c
@@ -221,7 +221,7 @@ static int tlclk_open(struct inode *inod
 	/* This device is wired through the FPGA IO space of the ATCA blade
 	 * we can't share this IRQ */
 	result = request_irq(telclk_interrupt, &tlclk_interrupt,
-			     IRQF_DISABLED, "telco_clock", tlclk_interrupt);
+			     0, "telco_clock", tlclk_interrupt);
 	if (result == -EBUSY)
 		printk(KERN_ERR "tlclk: Interrupt can't be reserved.\n");
 	else
Index: linux-2.6/drivers/char/vme_scc.c
===================================================================
--- linux-2.6.orig/drivers/char/vme_scc.c
+++ linux-2.6/drivers/char/vme_scc.c
@@ -208,20 +208,20 @@ static int mvme147_scc_init(void)
 	port->datap = port->ctrlp + 1;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	error = request_irq(MVME147_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCA_TX, scc_tx_int, 0,
 		            "SCC-A TX", port);
 	if (error)
 		goto fail;
-	error = request_irq(MVME147_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCA_STAT, scc_stat_int, 0,
 		            "SCC-A status", port);
 	if (error)
 		goto fail_free_a_tx;
-	error = request_irq(MVME147_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCA_RX, scc_rx_int, 0,
 		            "SCC-A RX", port);
 	if (error)
 		goto fail_free_a_stat;
 	error = request_irq(MVME147_IRQ_SCCA_SPCOND, scc_spcond_int,
-			    IRQF_DISABLED, "SCC-A special cond", port);
+			    0, "SCC-A special cond", port);
 	if (error)
 		goto fail_free_a_rx;
 
@@ -244,20 +244,20 @@ static int mvme147_scc_init(void)
 	port->datap = port->ctrlp + 1;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	error = request_irq(MVME147_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCB_TX, scc_tx_int, 0,
 		            "SCC-B TX", port);
 	if (error)
 		goto fail_free_a_spcond;
-	error = request_irq(MVME147_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCB_STAT, scc_stat_int, 0,
 		            "SCC-B status", port);
 	if (error)
 		goto fail_free_b_tx;
-	error = request_irq(MVME147_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
+	error = request_irq(MVME147_IRQ_SCCB_RX, scc_rx_int, 0,
 		            "SCC-B RX", port);
 	if (error)
 		goto fail_free_b_stat;
 	error = request_irq(MVME147_IRQ_SCCB_SPCOND, scc_spcond_int,
-			    IRQF_DISABLED, "SCC-B special cond", port);
+			    0, "SCC-B special cond", port);
 	if (error)
 		goto fail_free_b_rx;
 
@@ -314,20 +314,20 @@ static int mvme162_scc_init(void)
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	error = request_irq(MVME162_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCA_TX, scc_tx_int, 0,
 		            "SCC-A TX", port);
 	if (error)
 		goto fail;
-	error = request_irq(MVME162_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCA_STAT, scc_stat_int, 0,
 		            "SCC-A status", port);
 	if (error)
 		goto fail_free_a_tx;
-	error = request_irq(MVME162_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCA_RX, scc_rx_int, 0,
 		            "SCC-A RX", port);
 	if (error)
 		goto fail_free_a_stat;
 	error = request_irq(MVME162_IRQ_SCCA_SPCOND, scc_spcond_int,
-			    IRQF_DISABLED, "SCC-A special cond", port);
+			    0, "SCC-A special cond", port);
 	if (error)
 		goto fail_free_a_rx;
 
@@ -350,20 +350,20 @@ static int mvme162_scc_init(void)
 	port->datap = port->ctrlp + 2;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	error = request_irq(MVME162_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCB_TX, scc_tx_int, 0,
 		            "SCC-B TX", port);
 	if (error)
 		goto fail_free_a_spcond;
-	error = request_irq(MVME162_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCB_STAT, scc_stat_int, 0,
 		            "SCC-B status", port);
 	if (error)
 		goto fail_free_b_tx;
-	error = request_irq(MVME162_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
+	error = request_irq(MVME162_IRQ_SCCB_RX, scc_rx_int, 0,
 		            "SCC-B RX", port);
 	if (error)
 		goto fail_free_b_stat;
 	error = request_irq(MVME162_IRQ_SCCB_SPCOND, scc_spcond_int,
-			    IRQF_DISABLED, "SCC-B special cond", port);
+			    0, "SCC-B special cond", port);
 	if (error)
 		goto fail_free_b_rx;
 
@@ -417,20 +417,20 @@ static int bvme6000_scc_init(void)
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	error = request_irq(BVME_IRQ_SCCA_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCA_TX, scc_tx_int, 0,
 		            "SCC-A TX", port);
 	if (error)
 		goto fail;
-	error = request_irq(BVME_IRQ_SCCA_STAT, scc_stat_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCA_STAT, scc_stat_int, 0,
 		            "SCC-A status", port);
 	if (error)
 		goto fail_free_a_tx;
-	error = request_irq(BVME_IRQ_SCCA_RX, scc_rx_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCA_RX, scc_rx_int, 0,
 		            "SCC-A RX", port);
 	if (error)
 		goto fail_free_a_stat;
 	error = request_irq(BVME_IRQ_SCCA_SPCOND, scc_spcond_int,
-			    IRQF_DISABLED, "SCC-A special cond", port);
+			    0, "SCC-A special cond", port);
 	if (error)
 		goto fail_free_a_rx;
 
@@ -453,20 +453,20 @@ static int bvme6000_scc_init(void)
 	port->datap = port->ctrlp + 4;
 	port->port_a = &scc_ports[0];
 	port->port_b = &scc_ports[1];
-	error = request_irq(BVME_IRQ_SCCB_TX, scc_tx_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCB_TX, scc_tx_int, 0,
 		            "SCC-B TX", port);
 	if (error)
 		goto fail_free_a_spcond;
-	error = request_irq(BVME_IRQ_SCCB_STAT, scc_stat_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCB_STAT, scc_stat_int, 0,
 		            "SCC-B status", port);
 	if (error)
 		goto fail_free_b_tx;
-	error = request_irq(BVME_IRQ_SCCB_RX, scc_rx_int, IRQF_DISABLED,
+	error = request_irq(BVME_IRQ_SCCB_RX, scc_rx_int, 0,
 		            "SCC-B RX", port);
 	if (error)
 		goto fail_free_b_stat;
 	error = request_irq(BVME_IRQ_SCCB_SPCOND, scc_spcond_int,
-			    IRQF_DISABLED, "SCC-B special cond", port);
+			    0, "SCC-B special cond", port);
 	if (error)
 		goto fail_free_b_rx;
 
Index: linux-2.6/drivers/clocksource/tcb_clksrc.c
===================================================================
--- linux-2.6.orig/drivers/clocksource/tcb_clksrc.c
+++ linux-2.6/drivers/clocksource/tcb_clksrc.c
@@ -175,7 +175,7 @@ static irqreturn_t ch2_irq(int irq, void
 
 static struct irqaction tc_irqaction = {
 	.name		= "tc_clkevt",
-	.flags		= IRQF_TIMER | IRQF_DISABLED,
+	.flags		= IRQF_TIMER ,
 	.handler	= ch2_irq,
 };
 
Index: linux-2.6/drivers/edac/mpc85xx_edac.c
===================================================================
--- linux-2.6.orig/drivers/edac/mpc85xx_edac.c
+++ linux-2.6/drivers/edac/mpc85xx_edac.c
@@ -273,7 +273,7 @@ static int __devinit mpc85xx_pci_err_pro
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_pci_isr, IRQF_DISABLED,
+				       mpc85xx_pci_isr, 0,
 				       "[EDAC] PCI err", pci);
 		if (res < 0) {
 			printk(KERN_ERR
@@ -577,7 +577,7 @@ static int __devinit mpc85xx_l2_err_prob
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_l2_isr, IRQF_DISABLED,
+				       mpc85xx_l2_isr, 0,
 				       "[EDAC] L2 err", edac_dev);
 		if (res < 0) {
 			printk(KERN_ERR
@@ -912,7 +912,7 @@ static int __devinit mpc85xx_mc_err_prob
 		pdata->irq = irq_of_parse_and_map(op->node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
 				       mpc85xx_mc_isr,
-					IRQF_DISABLED | IRQF_SHARED,
+					 IRQF_SHARED,
 				       "[EDAC] MC err", mci);
 		if (res < 0) {
 			printk(KERN_ERR "%s: Unable to request irq %d for "
Index: linux-2.6/drivers/edac/mv64x60_edac.c
===================================================================
--- linux-2.6.orig/drivers/edac/mv64x60_edac.c
+++ linux-2.6/drivers/edac/mv64x60_edac.c
@@ -178,7 +178,7 @@ static int __devinit mv64x60_pci_err_pro
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_pci_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] PCI err",
 				       pci);
 		if (res < 0) {
@@ -345,7 +345,7 @@ static int __devinit mv64x60_sram_err_pr
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_sram_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] SRAM err",
 				       edac_dev);
 		if (res < 0) {
@@ -540,7 +540,7 @@ static int __devinit mv64x60_cpu_err_pro
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_cpu_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] CPU err",
 				       edac_dev);
 		if (res < 0) {
@@ -785,7 +785,7 @@ static int __devinit mv64x60_mc_err_prob
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_mc_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] MC err",
 				       mci);
 		if (res < 0) {
Index: linux-2.6/drivers/i2c/busses/i2c-bfin-twi.c
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/i2c-bfin-twi.c
+++ linux-2.6/drivers/i2c/busses/i2c-bfin-twi.c
@@ -593,7 +593,7 @@ static int i2c_bfin_twi_resume(struct pl
 	struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
 
 	int rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		IRQF_DISABLED, pdev->name, iface);
+		0, pdev->name, iface);
 	if (rc) {
 		dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
 		return -ENODEV;
@@ -665,7 +665,7 @@ static int i2c_bfin_twi_probe(struct pla
 	}
 
 	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
-		IRQF_DISABLED, pdev->name, iface);
+		0, pdev->name, iface);
 	if (rc) {
 		dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
 		rc = -ENODEV;
Index: linux-2.6/drivers/i2c/busses/i2c-highlander.c
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/i2c-highlander.c
+++ linux-2.6/drivers/i2c/busses/i2c-highlander.c
@@ -387,7 +387,7 @@ static int __devinit highlander_i2c_prob
 		dev->irq = 0;
 
 	if (dev->irq) {
-		ret = request_irq(dev->irq, highlander_i2c_irq, IRQF_DISABLED,
+		ret = request_irq(dev->irq, highlander_i2c_irq, 0,
 				  pdev->name, dev);
 		if (unlikely(ret))
 			goto err_unmap;
Index: linux-2.6/drivers/i2c/busses/i2c-pmcmsp.c
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/i2c-pmcmsp.c
+++ linux-2.6/drivers/i2c/busses/i2c-pmcmsp.c
@@ -306,7 +306,7 @@ static int __devinit pmcmsptwi_probe(str
 	pmcmsptwi_data.irq = platform_get_irq(pldev, 0);
 	if (pmcmsptwi_data.irq) {
 		rc = request_irq(pmcmsptwi_data.irq, &pmcmsptwi_interrupt,
-			IRQF_SHARED | IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
+			IRQF_SHARED |  IRQF_SAMPLE_RANDOM,
 			pldev->name, &pmcmsptwi_data);
 		if (rc == 0) {
 			/*
Index: linux-2.6/drivers/i2c/busses/i2c-pxa.c
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/i2c-pxa.c
+++ linux-2.6/drivers/i2c/busses/i2c-pxa.c
@@ -1055,7 +1055,7 @@ static int i2c_pxa_probe(struct platform
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
 	} else {
 		i2c->adap.algo = &i2c_pxa_algorithm;
-		ret = request_irq(irq, i2c_pxa_handler, IRQF_DISABLED,
+		ret = request_irq(irq, i2c_pxa_handler, 0,
 				  i2c->adap.name, i2c);
 		if (ret)
 			goto ereqirq;
Index: linux-2.6/drivers/i2c/busses/i2c-s3c2410.c
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/i2c-s3c2410.c
+++ linux-2.6/drivers/i2c/busses/i2c-s3c2410.c
@@ -876,7 +876,7 @@ static int s3c24xx_i2c_probe(struct plat
 		goto err_iomap;
 	}
 
-	ret = request_irq(i2c->irq, s3c24xx_i2c_irq, IRQF_DISABLED,
+	ret = request_irq(i2c->irq, s3c24xx_i2c_irq, 0,
 			  dev_name(&pdev->dev), i2c);
 
 	if (ret != 0) {
Index: linux-2.6/drivers/i2c/busses/i2c-sh7760.c
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/i2c-sh7760.c
+++ linux-2.6/drivers/i2c/busses/i2c-sh7760.c
@@ -502,7 +502,7 @@ static int __devinit sh7760_i2c_probe(st
 	}
 	OUT32(id, I2CCCR, ret);
 
-	if (request_irq(id->irq, sh7760_i2c_irq, IRQF_DISABLED,
+	if (request_irq(id->irq, sh7760_i2c_irq, 0,
 			SH7760_I2C_DEVNAME, id)) {
 		dev_err(&pdev->dev, "cannot get irq %d\n", id->irq);
 		ret = -EBUSY;
Index: linux-2.6/drivers/i2c/busses/i2c-sh_mobile.c
===================================================================
--- linux-2.6.orig/drivers/i2c/busses/i2c-sh_mobile.c
+++ linux-2.6/drivers/i2c/busses/i2c-sh_mobile.c
@@ -499,7 +499,7 @@ static int sh_mobile_i2c_hook_irqs(struc
 
 	while ((res = platform_get_resource(dev, IORESOURCE_IRQ, k))) {
 		for (n = res->start; hook && n <= res->end; n++) {
-			if (request_irq(n, sh_mobile_i2c_isr, IRQF_DISABLED,
+			if (request_irq(n, sh_mobile_i2c_isr, 0,
 					dev_name(&dev->dev), dev))
 				goto rollback;
 		}
Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_eq.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_eq.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -123,7 +123,7 @@ int ehca_create_eq(struct ehca_shca *shc
 	/* register interrupt handlers and initialize work queues */
 	if (type == EHCA_EQ) {
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
-					  IRQF_DISABLED, "ehca_eq",
+					  0, "ehca_eq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
@@ -131,7 +131,7 @@ int ehca_create_eq(struct ehca_shca *shc
 		tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
 	} else if (type == EHCA_NEQ) {
 		ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
-					  IRQF_DISABLED, "ehca_neq",
+					  0, "ehca_neq",
 					  (void *)shca);
 		if (ret < 0)
 			ehca_err(ib_dev, "Can't map interrupt handler.");
Index: linux-2.6/drivers/input/keyboard/corgikbd.c
===================================================================
--- linux-2.6.orig/drivers/input/keyboard/corgikbd.c
+++ linux-2.6/drivers/input/keyboard/corgikbd.c
@@ -349,7 +349,7 @@ static int __init corgikbd_probe(struct 
 	for (i = 0; i < CORGI_KEY_SENSE_NUM; i++) {
 		pxa_gpio_mode(CORGI_GPIO_KEY_SENSE(i) | GPIO_IN);
 		if (request_irq(CORGI_IRQ_GPIO_KEY_SENSE(i), corgikbd_interrupt,
-				IRQF_DISABLED | IRQF_TRIGGER_RISING,
+				 IRQF_TRIGGER_RISING,
 				"corgikbd", corgikbd))
 			printk(KERN_WARNING "corgikbd: Can't get IRQ: %d!\n", i);
 	}
Index: linux-2.6/drivers/input/keyboard/jornada720_kbd.c
===================================================================
--- linux-2.6.orig/drivers/input/keyboard/jornada720_kbd.c
+++ linux-2.6/drivers/input/keyboard/jornada720_kbd.c
@@ -128,7 +128,7 @@ static int __devinit jornada720_kbd_prob
 
 	err = request_irq(IRQ_GPIO0,
 			  jornada720_kbd_interrupt,
-			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+			   IRQF_TRIGGER_FALLING,
 			  "jornadakbd", pdev);
 	if (err) {
 		printk(KERN_INFO "jornadakbd720_kbd: Unable to grab IRQ\n");
Index: linux-2.6/drivers/input/keyboard/pxa27x_keypad.c
===================================================================
--- linux-2.6.orig/drivers/input/keyboard/pxa27x_keypad.c
+++ linux-2.6/drivers/input/keyboard/pxa27x_keypad.c
@@ -510,7 +510,7 @@ static int __devinit pxa27x_keypad_probe
 	pxa27x_keypad_build_keycode(keypad);
 	platform_set_drvdata(pdev, keypad);
 
-	error = request_irq(irq, pxa27x_keypad_irq_handler, IRQF_DISABLED,
+	error = request_irq(irq, pxa27x_keypad_irq_handler, 0,
 			    pdev->name, keypad);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
Index: linux-2.6/drivers/input/keyboard/pxa930_rotary.c
===================================================================
--- linux-2.6.orig/drivers/input/keyboard/pxa930_rotary.c
+++ linux-2.6/drivers/input/keyboard/pxa930_rotary.c
@@ -147,7 +147,7 @@ static int __devinit pxa930_rotary_probe
 	r->input_dev = input_dev;
 	input_set_drvdata(input_dev, r);
 
-	err = request_irq(irq, rotary_irq, IRQF_DISABLED,
+	err = request_irq(irq, rotary_irq, 0,
 			"enhanced rotary", r);
 	if (err) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
Index: linux-2.6/drivers/input/keyboard/spitzkbd.c
===================================================================
--- linux-2.6.orig/drivers/input/keyboard/spitzkbd.c
+++ linux-2.6/drivers/input/keyboard/spitzkbd.c
@@ -407,7 +407,7 @@ static int __init spitzkbd_probe(struct 
 	for (i = 0; i < SPITZ_KEY_SENSE_NUM; i++) {
 		pxa_gpio_mode(spitz_senses[i] | GPIO_IN);
 		if (request_irq(IRQ_GPIO(spitz_senses[i]), spitzkbd_interrupt,
-				IRQF_DISABLED|IRQF_TRIGGER_RISING,
+				IRQF_TRIGGER_RISING,
 				"Spitzkbd Sense", spitzkbd))
 			printk(KERN_WARNING "spitzkbd: Can't get Sense IRQ: %d!\n", i);
 	}
@@ -422,19 +422,19 @@ static int __init spitzkbd_probe(struct 
 	pxa_gpio_mode(SPITZ_GPIO_SWB | GPIO_IN);
 
 	request_irq(SPITZ_IRQ_GPIO_SYNC, spitzkbd_interrupt,
-		    IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		     IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 		    "Spitzkbd Sync", spitzkbd);
 	request_irq(SPITZ_IRQ_GPIO_ON_KEY, spitzkbd_interrupt,
-		    IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		     IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 		    "Spitzkbd PwrOn", spitzkbd);
 	request_irq(SPITZ_IRQ_GPIO_SWA, spitzkbd_hinge_isr,
-		    IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		     IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 		    "Spitzkbd SWA", spitzkbd);
 	request_irq(SPITZ_IRQ_GPIO_SWB, spitzkbd_hinge_isr,
-		    IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		     IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 		    "Spitzkbd SWB", spitzkbd);
 	request_irq(SPITZ_IRQ_GPIO_AK_INT, spitzkbd_hinge_isr,
-		    IRQF_DISABLED | IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+		     IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 		    "Spitzkbd HP", spitzkbd);
 
 	return 0;
Index: linux-2.6/drivers/input/keyboard/tosakbd.c
===================================================================
--- linux-2.6.orig/drivers/input/keyboard/tosakbd.c
+++ linux-2.6/drivers/input/keyboard/tosakbd.c
@@ -317,7 +317,7 @@ static int __devinit tosakbd_probe(struc
 		}
 
 		error = request_irq(irq, tosakbd_interrupt,
-					IRQF_DISABLED | IRQF_TRIGGER_RISING,
+					 IRQF_TRIGGER_RISING,
 					"tosakbd", pdev);
 
 		if (error) {
Index: linux-2.6/drivers/input/misc/ixp4xx-beeper.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/ixp4xx-beeper.c
+++ linux-2.6/drivers/input/misc/ixp4xx-beeper.c
@@ -115,7 +115,7 @@ static int __devinit ixp4xx_spkr_probe(s
 	input_dev->event = ixp4xx_spkr_event;
 
 	err = request_irq(IRQ_IXP4XX_TIMER2, &ixp4xx_spkr_interrupt,
-			  IRQF_DISABLED | IRQF_TIMER, "ixp4xx-beeper", (void *) dev->id);
+			   IRQF_TIMER, "ixp4xx-beeper", (void *) dev->id);
 	if (err)
 		goto err_free_device;
 
Index: linux-2.6/drivers/input/mouse/pxa930_trkball.c
===================================================================
--- linux-2.6.orig/drivers/input/mouse/pxa930_trkball.c
+++ linux-2.6/drivers/input/mouse/pxa930_trkball.c
@@ -183,7 +183,7 @@ static int __devinit pxa930_trkball_prob
 	/* held the module in reset, will be enabled in open() */
 	pxa930_trkball_disable(trkball);
 
-	error = request_irq(irq, pxa930_trkball_interrupt, IRQF_DISABLED,
+	error = request_irq(irq, pxa930_trkball_interrupt, 0,
 			    pdev->name, trkball);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq: %d\n", error);
Index: linux-2.6/drivers/input/touchscreen/atmel_tsadcc.c
===================================================================
--- linux-2.6.orig/drivers/input/touchscreen/atmel_tsadcc.c
+++ linux-2.6/drivers/input/touchscreen/atmel_tsadcc.c
@@ -218,7 +218,7 @@ static int __devinit atmel_tsadcc_probe(
 		goto err_release_mem;
 	}
 
-	err = request_irq(ts_dev->irq, atmel_tsadcc_interrupt, IRQF_DISABLED,
+	err = request_irq(ts_dev->irq, atmel_tsadcc_interrupt, 0,
 			pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
Index: linux-2.6/drivers/input/touchscreen/corgi_ts.c
===================================================================
--- linux-2.6.orig/drivers/input/touchscreen/corgi_ts.c
+++ linux-2.6/drivers/input/touchscreen/corgi_ts.c
@@ -321,7 +321,7 @@ static int __init corgits_probe(struct p
 	corgi_ssp_ads7846_putget((5u << ADSCTRL_ADR_SH) | ADSCTRL_STS);
 	mdelay(5);
 
-	if (request_irq(corgi_ts->irq_gpio, ts_interrupt, IRQF_DISABLED, "ts", corgi_ts)) {
+	if (request_irq(corgi_ts->irq_gpio, ts_interrupt, 0, "ts", corgi_ts)) {
 		err = -EBUSY;
 		goto fail1;
 	}
Index: linux-2.6/drivers/input/touchscreen/h3600_ts_input.c
===================================================================
--- linux-2.6.orig/drivers/input/touchscreen/h3600_ts_input.c
+++ linux-2.6/drivers/input/touchscreen/h3600_ts_input.c
@@ -395,14 +395,14 @@ static int h3600ts_connect(struct serio 
 	set_GPIO_IRQ_edge(GPIO_BITSY_NPOWER_BUTTON, GPIO_RISING_EDGE);
 
 	if (request_irq(IRQ_GPIO_BITSY_ACTION_BUTTON, action_button_handler,
-			IRQF_SHARED | IRQF_DISABLED, "h3600_action", &ts->dev)) {
+			IRQF_SHARED , "h3600_action", &ts->dev)) {
 		printk(KERN_ERR "h3600ts.c: Could not allocate Action Button IRQ!\n");
 		err = -EBUSY;
 		goto fail2;
 	}
 
 	if (request_irq(IRQ_GPIO_BITSY_NPOWER_BUTTON, npower_button_handler,
-			IRQF_SHARED | IRQF_DISABLED, "h3600_suspend", &ts->dev)) {
+			IRQF_SHARED , "h3600_suspend", &ts->dev)) {
 		printk(KERN_ERR "h3600ts.c: Could not allocate Power Button IRQ!\n");
 		err = -EBUSY;
 		goto fail3;
Index: linux-2.6/drivers/input/touchscreen/hp680_ts_input.c
===================================================================
--- linux-2.6.orig/drivers/input/touchscreen/hp680_ts_input.c
+++ linux-2.6/drivers/input/touchscreen/hp680_ts_input.c
@@ -93,7 +93,7 @@ static int __init hp680_ts_init(void)
 	hp680_ts_dev->phys = "hp680_ts/input0";
 
 	if (request_irq(HP680_TS_IRQ, hp680_ts_interrupt,
-			IRQF_DISABLED, MODNAME, 0) < 0) {
+			0, MODNAME, 0) < 0) {
 		printk(KERN_ERR "hp680_touchscreen.c: Can't allocate irq %d\n",
 		       HP680_TS_IRQ);
 		err = -EBUSY;
Index: linux-2.6/drivers/input/touchscreen/jornada720_ts.c
===================================================================
--- linux-2.6.orig/drivers/input/touchscreen/jornada720_ts.c
+++ linux-2.6/drivers/input/touchscreen/jornada720_ts.c
@@ -126,7 +126,7 @@ static int __devinit jornada720_ts_probe
 
 	error = request_irq(IRQ_GPIO9,
 			jornada720_ts_interrupt,
-			IRQF_DISABLED | IRQF_TRIGGER_RISING,
+			 IRQF_TRIGGER_RISING,
 			"HP7XX Touchscreen driver", pdev);
 	if (error) {
 		printk(KERN_INFO "HP7XX TS : Unable to acquire irq!\n");
Index: linux-2.6/drivers/isdn/hardware/eicon/divasmain.c
===================================================================
--- linux-2.6.orig/drivers/isdn/hardware/eicon/divasmain.c
+++ linux-2.6/drivers/isdn/hardware/eicon/divasmain.c
@@ -484,7 +484,7 @@ void __inline__ outpp(void __iomem *addr
 int diva_os_register_irq(void *context, byte irq, const char *name)
 {
 	int result = request_irq(irq, diva_os_irq_wrapper,
-				 IRQF_DISABLED | IRQF_SHARED, name, context);
+				  IRQF_SHARED, name, context);
 	return (result);
 }
 
Index: linux-2.6/drivers/isdn/sc/init.c
===================================================================
--- linux-2.6.orig/drivers/isdn/sc/init.c
+++ linux-2.6/drivers/isdn/sc/init.c
@@ -334,7 +334,7 @@ static int __init sc_init(void)
 		 */
 		sc_adapter[cinst]->interrupt = irq[b];
 		if (request_irq(sc_adapter[cinst]->interrupt, interrupt_handler,
-				IRQF_DISABLED, interface->id,
+				0, interface->id,
 				(void *)(unsigned long) cinst))
 		{
 			kfree(sc_adapter[cinst]->channel);
Index: linux-2.6/drivers/media/common/saa7146_core.c
===================================================================
--- linux-2.6.orig/drivers/media/common/saa7146_core.c
+++ linux-2.6/drivers/media/common/saa7146_core.c
@@ -416,7 +416,7 @@ static int saa7146_init_one(struct pci_d
 	saa7146_write(dev, MC2, 0xf8000000);
 
 	/* request an interrupt for the saa7146 */
-	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED | IRQF_DISABLED,
+	err = request_irq(pci->irq, interrupt_hw, IRQF_SHARED ,
 			  dev->name, dev);
 	if (err < 0) {
 		ERR(("request_irq() failed.\n"));
Index: linux-2.6/drivers/media/dvb/bt8xx/bt878.c
===================================================================
--- linux-2.6.orig/drivers/media/dvb/bt8xx/bt878.c
+++ linux-2.6/drivers/media/dvb/bt8xx/bt878.c
@@ -489,7 +489,7 @@ static int __devinit bt878_probe(struct 
 	btwrite(0, BT848_INT_MASK);
 
 	result = request_irq(bt->irq, bt878_irq,
-			     IRQF_SHARED | IRQF_DISABLED, "bt878",
+			     IRQF_SHARED , "bt878",
 			     (void *) bt);
 	if (result == -EINVAL) {
 		printk(KERN_ERR "bt878(%d): Bad irq number or handler\n",
Index: linux-2.6/drivers/media/video/bt8xx/bttv-driver.c
===================================================================
--- linux-2.6.orig/drivers/media/video/bt8xx/bttv-driver.c
+++ linux-2.6/drivers/media/video/bt8xx/bttv-driver.c
@@ -4379,7 +4379,7 @@ static int __devinit bttv_probe(struct p
 	/* disable irqs, register irq handler */
 	btwrite(0, BT848_INT_MASK);
 	result = request_irq(btv->c.pci->irq, bttv_irq,
-			     IRQF_SHARED | IRQF_DISABLED,btv->c.name,(void *)btv);
+			     IRQF_SHARED ,btv->c.name,(void *)btv);
 	if (result < 0) {
 		printk(KERN_ERR "bttv%d: can't get IRQ %d\n",
 		       bttv_num,btv->c.pci->irq);
Index: linux-2.6/drivers/media/video/cx18/cx18-driver.c
===================================================================
--- linux-2.6.orig/drivers/media/video/cx18/cx18-driver.c
+++ linux-2.6/drivers/media/video/cx18/cx18-driver.c
@@ -882,7 +882,7 @@ static int __devinit cx18_probe(struct p
 
 	/* Register IRQ */
 	retval = request_irq(cx->dev->irq, cx18_irq_handler,
-			     IRQF_SHARED | IRQF_DISABLED, cx->name, (void *)cx);
+			     IRQF_SHARED , cx->name, (void *)cx);
 	if (retval) {
 		CX18_ERR("Failed to register irq %d\n", retval);
 		goto free_i2c;
Index: linux-2.6/drivers/media/video/cx23885/cx23885-core.c
===================================================================
--- linux-2.6.orig/drivers/media/video/cx23885/cx23885-core.c
+++ linux-2.6/drivers/media/video/cx23885/cx23885-core.c
@@ -1751,7 +1751,7 @@ static int __devinit cx23885_initdev(str
 	}
 
 	err = request_irq(pci_dev->irq, cx23885_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+			  IRQF_SHARED , dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
Index: linux-2.6/drivers/media/video/cx88/cx88-alsa.c
===================================================================
--- linux-2.6.orig/drivers/media/video/cx88/cx88-alsa.c
+++ linux-2.6/drivers/media/video/cx88/cx88-alsa.c
@@ -763,7 +763,7 @@ static int __devinit snd_cx88_create(str
 
 	/* get irq */
 	err = request_irq(chip->pci->irq, cx8801_irq,
-			  IRQF_SHARED | IRQF_DISABLED, chip->core->name, chip);
+			  IRQF_SHARED , chip->core->name, chip);
 	if (err < 0) {
 		dprintk(0, "%s: can't get IRQ %d\n",
 		       chip->core->name, chip->pci->irq);
Index: linux-2.6/drivers/media/video/cx88/cx88-mpeg.c
===================================================================
--- linux-2.6.orig/drivers/media/video/cx88/cx88-mpeg.c
+++ linux-2.6/drivers/media/video/cx88/cx88-mpeg.c
@@ -481,7 +481,7 @@ static int cx8802_init_common(struct cx8
 
 	/* get irq */
 	err = request_irq(dev->pci->irq, cx8802_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->core->name, dev);
+			  IRQF_SHARED , dev->core->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->core->name, dev->pci->irq);
Index: linux-2.6/drivers/media/video/cx88/cx88-video.c
===================================================================
--- linux-2.6.orig/drivers/media/video/cx88/cx88-video.c
+++ linux-2.6/drivers/media/video/cx88/cx88-video.c
@@ -1881,7 +1881,7 @@ static int __devinit cx8800_initdev(stru
 
 	/* get irq */
 	err = request_irq(pci_dev->irq, cx8800_irq,
-			  IRQF_SHARED | IRQF_DISABLED, core->name, dev);
+			  IRQF_SHARED , core->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s/0: can't get IRQ %d\n",
 		       core->name,pci_dev->irq);
Index: linux-2.6/drivers/media/video/ivtv/ivtv-driver.c
===================================================================
--- linux-2.6.orig/drivers/media/video/ivtv/ivtv-driver.c
+++ linux-2.6/drivers/media/video/ivtv/ivtv-driver.c
@@ -1155,7 +1155,7 @@ static int __devinit ivtv_probe(struct p
 
 	/* Register IRQ */
 	retval = request_irq(itv->dev->irq, ivtv_irq_handler,
-	     IRQF_SHARED | IRQF_DISABLED, itv->device.name, (void *)itv);
+	     IRQF_SHARED , itv->device.name, (void *)itv);
 	if (retval) {
 		IVTV_ERR("Failed to register irq %d\n", retval);
 		goto free_i2c;
Index: linux-2.6/drivers/media/video/meye.c
===================================================================
--- linux-2.6.orig/drivers/media/video/meye.c
+++ linux-2.6/drivers/media/video/meye.c
@@ -1833,7 +1833,7 @@ static int __devinit meye_probe(struct p
 
 	meye.mchip_irq = pcidev->irq;
 	if (request_irq(meye.mchip_irq, meye_irq,
-			IRQF_DISABLED | IRQF_SHARED, "meye", meye_irq)) {
+			 IRQF_SHARED, "meye", meye_irq)) {
 		printk(KERN_ERR "meye: request_irq failed\n");
 		goto outreqirq;
 	}
Index: linux-2.6/drivers/media/video/saa7134/saa7134-alsa.c
===================================================================
--- linux-2.6.orig/drivers/media/video/saa7134/saa7134-alsa.c
+++ linux-2.6/drivers/media/video/saa7134/saa7134-alsa.c
@@ -1014,7 +1014,7 @@ static int alsa_card_saa7134_create(stru
 
 
 	err = request_irq(dev->pci->irq, saa7134_alsa_irq,
-				IRQF_SHARED | IRQF_DISABLED, dev->name,
+				IRQF_SHARED , dev->name,
 				(void*) &dev->dmasound);
 
 	if (err < 0) {
Index: linux-2.6/drivers/media/video/saa7134/saa7134-core.c
===================================================================
--- linux-2.6.orig/drivers/media/video/saa7134/saa7134-core.c
+++ linux-2.6/drivers/media/video/saa7134/saa7134-core.c
@@ -961,7 +961,7 @@ static int __devinit saa7134_initdev(str
 
 	/* get irq */
 	err = request_irq(pci_dev->irq, saa7134_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+			  IRQF_SHARED , dev->name, dev);
 	if (err < 0) {
 		printk(KERN_ERR "%s: can't get IRQ %d\n",
 		       dev->name,pci_dev->irq);
Index: linux-2.6/drivers/media/video/sh_mobile_ceu_camera.c
===================================================================
--- linux-2.6.orig/drivers/media/video/sh_mobile_ceu_camera.c
+++ linux-2.6/drivers/media/video/sh_mobile_ceu_camera.c
@@ -820,7 +820,7 @@ static int sh_mobile_ceu_probe(struct pl
 	}
 
 	/* request irq */
-	err = request_irq(pcdev->irq, sh_mobile_ceu_irq, IRQF_DISABLED,
+	err = request_irq(pcdev->irq, sh_mobile_ceu_irq, 0,
 			  dev_name(&pdev->dev), pcdev);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
Index: linux-2.6/drivers/media/video/stradis.c
===================================================================
--- linux-2.6.orig/drivers/media/video/stradis.c
+++ linux-2.6/drivers/media/video/stradis.c
@@ -1985,7 +1985,7 @@ static int __devinit configure_saa7146(s
 	memcpy(&saa->video_dev, &saa_template, sizeof(saa_template));
 	saawrite(0, SAA7146_IER);	/* turn off all interrupts */
 
-	retval = request_irq(saa->irq, saa7146_irq, IRQF_SHARED | IRQF_DISABLED,
+	retval = request_irq(saa->irq, saa7146_irq, IRQF_SHARED ,
 		"stradis", saa);
 	if (retval == -EINVAL)
 		dev_err(&pdev->dev, "%d: Bad irq number or handler\n", num);
Index: linux-2.6/drivers/media/video/zoran/zoran_card.c
===================================================================
--- linux-2.6.orig/drivers/media/video/zoran/zoran_card.c
+++ linux-2.6/drivers/media/video/zoran/zoran_card.c
@@ -1368,7 +1368,7 @@ static int __devinit zoran_probe(struct 
 	}
 
 	result = request_irq(zr->pci_dev->irq, zoran_irq,
-			     IRQF_SHARED | IRQF_DISABLED, ZR_DEVNAME(zr), zr);
+			     IRQF_SHARED , ZR_DEVNAME(zr), zr);
 	if (result < 0) {
 		if (result == -EINVAL) {
 			dprintk(1,
Index: linux-2.6/drivers/mfd/da903x.c
===================================================================
--- linux-2.6.orig/drivers/mfd/da903x.c
+++ linux-2.6/drivers/mfd/da903x.c
@@ -517,7 +517,7 @@ static int __devinit da903x_probe(struct
 	chip->ops->read_events(chip, &tmp);
 
 	ret = request_irq(client->irq, da903x_irq_handler,
-			IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+			 IRQF_TRIGGER_FALLING,
 			"da903x", chip);
 	if (ret) {
 		dev_err(&client->dev, "failed to request irq %d\n",
Index: linux-2.6/drivers/mfd/menelaus.c
===================================================================
--- linux-2.6.orig/drivers/mfd/menelaus.c
+++ linux-2.6/drivers/mfd/menelaus.c
@@ -1192,7 +1192,7 @@ static int menelaus_probe(struct i2c_cli
 	menelaus_write_reg(MENELAUS_MCT_CTRL1, 0x73);
 
 	if (client->irq > 0) {
-		err = request_irq(client->irq, menelaus_irq, IRQF_DISABLED,
+		err = request_irq(client->irq, menelaus_irq, 0,
 				  DRIVER_NAME, menelaus);
 		if (err) {
 			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
Index: linux-2.6/drivers/misc/phantom.c
===================================================================
--- linux-2.6.orig/drivers/misc/phantom.c
+++ linux-2.6/drivers/misc/phantom.c
@@ -387,7 +387,7 @@ static int __devinit phantom_probe(struc
 	iowrite32(0, pht->caddr + PHN_IRQCTL);
 	ioread32(pht->caddr + PHN_IRQCTL); /* PCI posting */
 	retval = request_irq(pdev->irq, phantom_isr,
-			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
+			IRQF_SHARED , "phantom", pht);
 	if (retval) {
 		dev_err(&pdev->dev, "can't establish ISR\n");
 		goto err_unmo;
Index: linux-2.6/drivers/mmc/host/omap_hsmmc.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/omap_hsmmc.c
+++ linux-2.6/drivers/mmc/host/omap_hsmmc.c
@@ -1035,7 +1035,7 @@ static int __init omap_mmc_probe(struct 
 			OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
 
 	/* Request IRQ for MMC operations */
-	ret = request_irq(host->irq, mmc_omap_irq, IRQF_DISABLED,
+	ret = request_irq(host->irq, mmc_omap_irq, 0,
 			mmc_hostname(mmc), host);
 	if (ret) {
 		dev_dbg(mmc_dev(host->mmc), "Unable to grab HSMMC IRQ\n");
@@ -1055,7 +1055,7 @@ static int __init omap_mmc_probe(struct 
 		ret = request_irq(mmc_slot(host).card_detect_irq,
 				  omap_mmc_cd_handler,
 				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
-					  | IRQF_DISABLED,
+					  ,
 				  mmc_hostname(mmc), host);
 		if (ret) {
 			dev_dbg(mmc_dev(host->mmc),
Index: linux-2.6/drivers/mmc/host/tmio_mmc.c
===================================================================
--- linux-2.6.orig/drivers/mmc/host/tmio_mmc.c
+++ linux-2.6/drivers/mmc/host/tmio_mmc.c
@@ -614,7 +614,7 @@ static int __devinit tmio_mmc_probe(stru
 
 	disable_mmc_irqs(host->ctl, TMIO_MASK_ALL);
 
-	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED, "tmio-mmc",
+	ret = request_irq(host->irq, tmio_mmc_irq, 0, "tmio-mmc",
 		host);
 	if (ret)
 		goto unmap_cnf;
Index: linux-2.6/drivers/mtd/nand/pxa3xx_nand.c
===================================================================
--- linux-2.6.orig/drivers/mtd/nand/pxa3xx_nand.c
+++ linux-2.6/drivers/mtd/nand/pxa3xx_nand.c
@@ -1136,7 +1136,7 @@ static int pxa3xx_nand_probe(struct plat
 	if (ret)
 		goto fail_free_io;
 
-	ret = request_irq(IRQ_NAND, pxa3xx_nand_irq, IRQF_DISABLED,
+	ret = request_irq(IRQ_NAND, pxa3xx_nand_irq, 0,
 				pdev->name, info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
Index: linux-2.6/drivers/mtd/nand/tmio_nand.c
===================================================================
--- linux-2.6.orig/drivers/mtd/nand/tmio_nand.c
+++ linux-2.6/drivers/mtd/nand/tmio_nand.c
@@ -433,7 +433,7 @@ static int tmio_probe(struct platform_de
 	nand_chip->chip_delay = 15;
 
 	retval = request_irq(irq, &tmio_irq,
-				IRQF_DISABLED, dev_name(&dev->dev), tmio);
+				0, dev_name(&dev->dev), tmio);
 	if (retval) {
 		dev_err(&dev->dev, "request_irq error %d\n", retval);
 		goto err_irq;
Index: linux-2.6/drivers/net/bfin_mac.c
===================================================================
--- linux-2.6.orig/drivers/net/bfin_mac.c
+++ linux-2.6/drivers/net/bfin_mac.c
@@ -1102,7 +1102,7 @@ static int __devinit bfin_mac_probe(stru
 	/* now, enable interrupts */
 	/* register irq handler */
 	rc = request_irq(IRQ_MAC_RX, bfin_mac_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "EMAC_RX", ndev);
+			 IRQF_SHARED, "EMAC_RX", ndev);
 	if (rc) {
 		dev_err(&pdev->dev, "Cannot request Blackfin MAC RX IRQ!\n");
 		rc = -EBUSY;
Index: linux-2.6/drivers/net/ehea/ehea_main.c
===================================================================
--- linux-2.6.orig/drivers/net/ehea/ehea_main.c
+++ linux-2.6/drivers/net/ehea/ehea_main.c
@@ -1224,7 +1224,7 @@ static int ehea_reg_interrupts(struct ne
 
 	ret = ibmebus_request_irq(port->qp_eq->attr.ist1,
 				  ehea_qp_aff_irq_handler,
-				  IRQF_DISABLED, port->int_aff_name, port);
+				  0, port->int_aff_name, port);
 	if (ret) {
 		ehea_error("failed registering irq for qp_aff_irq_handler:"
 			   "ist=%X", port->qp_eq->attr.ist1);
@@ -1242,7 +1242,7 @@ static int ehea_reg_interrupts(struct ne
 			 "%s-queue%d", dev->name, i);
 		ret = ibmebus_request_irq(pr->eq->attr.ist1,
 					  ehea_recv_irq_handler,
-					  IRQF_DISABLED, pr->int_send_name,
+					  0, pr->int_send_name,
 					  pr);
 		if (ret) {
 			ehea_error("failed registering irq for ehea_queue "
@@ -3420,7 +3420,7 @@ static int __devinit ehea_probe_adapter(
 		     (unsigned long)adapter);
 
 	ret = ibmebus_request_irq(adapter->neq->attr.ist1,
-				  ehea_interrupt_neq, IRQF_DISABLED,
+				  ehea_interrupt_neq, 0,
 				  "ehea_neq", adapter);
 	if (ret) {
 		dev_err(&dev->dev, "requesting NEQ IRQ failed\n");
Index: linux-2.6/drivers/net/fec.c
===================================================================
--- linux-2.6.orig/drivers/net/fec.c
+++ linux-2.6/drivers/net/fec.c
@@ -1246,7 +1246,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(idp->irq, idp->handler, IRQF_DISABLED, idp->name, dev) != 0)
+		if (request_irq(idp->irq, idp->handler, 0, idp->name, dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, idp->irq);
 	}
 
@@ -1365,7 +1365,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name, dev) != 0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, 0, idp->name, dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, b+idp->irq);
 	}
 
@@ -1526,7 +1526,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name,dev) != 0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, 0, idp->name,dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n", idp->name, b+idp->irq);
 	}
 
@@ -1643,7 +1643,7 @@ static void __inline__ fec_request_intrs
 
 	/* Setup interrupt handlers. */
 	for (idp = id; idp->name; idp++) {
-		if (request_irq(b+idp->irq, fec_enet_interrupt, IRQF_DISABLED, idp->name,dev) != 0)
+		if (request_irq(b+idp->irq, fec_enet_interrupt, 0, idp->name,dev) != 0)
 			printk("FEC: Could not allocate %s IRQ(%d)!\n",
 				idp->name, b+idp->irq);
 	}
Index: linux-2.6/drivers/net/hamradio/baycom_ser_fdx.c
===================================================================
--- linux-2.6.orig/drivers/net/hamradio/baycom_ser_fdx.c
+++ linux-2.6/drivers/net/hamradio/baycom_ser_fdx.c
@@ -443,7 +443,7 @@ static int ser12_open(struct net_device 
 	outb(0, FCR(dev->base_addr));  /* disable FIFOs */
 	outb(0x0d, MCR(dev->base_addr));
 	outb(0, IER(dev->base_addr));
-	if (request_irq(dev->irq, ser12_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(dev->irq, ser12_interrupt,  IRQF_SHARED,
 			"baycom_ser_fdx", dev)) {
 		release_region(dev->base_addr, SER12_EXTENT);
 		return -EBUSY;
Index: linux-2.6/drivers/net/hamradio/baycom_ser_hdx.c
===================================================================
--- linux-2.6.orig/drivers/net/hamradio/baycom_ser_hdx.c
+++ linux-2.6/drivers/net/hamradio/baycom_ser_hdx.c
@@ -488,7 +488,7 @@ static int ser12_open(struct net_device 
 	outb(0, FCR(dev->base_addr));  /* disable FIFOs */
 	outb(0x0d, MCR(dev->base_addr));
 	outb(0, IER(dev->base_addr));
-	if (request_irq(dev->irq, ser12_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(dev->irq, ser12_interrupt,  IRQF_SHARED,
 			"baycom_ser12", dev)) {
 		release_region(dev->base_addr, SER12_EXTENT);       
 		return -EBUSY;
Index: linux-2.6/drivers/net/hamradio/scc.c
===================================================================
--- linux-2.6.orig/drivers/net/hamradio/scc.c
+++ linux-2.6/drivers/net/hamradio/scc.c
@@ -1733,7 +1733,7 @@ static int scc_net_ioctl(struct net_devi
 			if (!Ivec[hwcfg.irq].used && hwcfg.irq)
 			{
 				if (request_irq(hwcfg.irq, scc_isr,
-						IRQF_DISABLED, "AX.25 SCC",
+						0, "AX.25 SCC",
 						(void *)(long) hwcfg.irq))
 					printk(KERN_WARNING "z8530drv: warning, cannot get IRQ %d\n", hwcfg.irq);
 				else
Index: linux-2.6/drivers/net/hamradio/yam.c
===================================================================
--- linux-2.6.orig/drivers/net/hamradio/yam.c
+++ linux-2.6/drivers/net/hamradio/yam.c
@@ -863,7 +863,7 @@ static int yam_open(struct net_device *d
 		goto out_release_base;
 	}
 	outb(0, IER(dev->base_addr));
-	if (request_irq(dev->irq, yam_interrupt, IRQF_DISABLED | IRQF_SHARED, dev->name, dev)) {
+	if (request_irq(dev->irq, yam_interrupt,  IRQF_SHARED, dev->name, dev)) {
 		printk(KERN_ERR "%s: irq %d busy\n", dev->name, dev->irq);
 		ret = -EBUSY;
 		goto out_release_base;
Index: linux-2.6/drivers/net/hp100.c
===================================================================
--- linux-2.6.orig/drivers/net/hp100.c
+++ linux-2.6/drivers/net/hp100.c
@@ -1095,7 +1095,7 @@ static int hp100_open(struct net_device 
 	/* New: if bus is PCI or EISA, interrupts might be shared interrupts */
 	if (request_irq(dev->irq, hp100_interrupt,
 			lp->bus == HP100_BUS_PCI || lp->bus ==
-			HP100_BUS_EISA ? IRQF_SHARED : IRQF_DISABLED,
+			HP100_BUS_EISA ? IRQF_SHARED : 0,
 			"hp100", dev)) {
 		printk("hp100: %s: unable to get IRQ %d\n", dev->name, dev->irq);
 		return -EAGAIN;
Index: linux-2.6/drivers/net/irda/donauboe.c
===================================================================
--- linux-2.6.orig/drivers/net/irda/donauboe.c
+++ linux-2.6/drivers/net/irda/donauboe.c
@@ -1354,7 +1354,7 @@ toshoboe_net_open (struct net_device *de
     return 0;
 
   rc = request_irq (self->io.irq, toshoboe_interrupt,
-                    IRQF_SHARED | IRQF_DISABLED, dev->name, self);
+                    IRQF_SHARED , dev->name, self);
   if (rc)
   	return rc;
 
@@ -1554,7 +1554,7 @@ toshoboe_open (struct pci_dev *pci_dev, 
   self->io.fir_base = self->base;
   self->io.fir_ext = OBOE_IO_EXTENT;
   self->io.irq = pci_dev->irq;
-  self->io.irqflags = IRQF_SHARED | IRQF_DISABLED;
+  self->io.irqflags = IRQF_SHARED ;
 
   self->speed = self->io.speed = 9600;
   self->async = 0;
Index: linux-2.6/drivers/net/jazzsonic.c
===================================================================
--- linux-2.6.orig/drivers/net/jazzsonic.c
+++ linux-2.6/drivers/net/jazzsonic.c
@@ -81,7 +81,7 @@ static unsigned short known_revisions[] 
 
 static int jazzsonic_open(struct net_device* dev)
 {
-	if (request_irq(dev->irq, &sonic_interrupt, IRQF_DISABLED, "sonic", dev)) {
+	if (request_irq(dev->irq, &sonic_interrupt, 0, "sonic", dev)) {
 		printk(KERN_ERR "%s: unable to get IRQ %d.\n", dev->name, dev->irq);
 		return -EAGAIN;
 	}
Index: linux-2.6/drivers/net/korina.c
===================================================================
--- linux-2.6.orig/drivers/net/korina.c
+++ linux-2.6/drivers/net/korina.c
@@ -1003,14 +1003,14 @@ static int korina_open(struct net_device
 	 * that handles the Done Finished
 	 * Ovr and Und Events */
 	ret = request_irq(lp->rx_irq, &korina_rx_dma_interrupt,
-			IRQF_DISABLED, "Korina ethernet Rx", dev);
+			0, "Korina ethernet Rx", dev);
 	if (ret < 0) {
 		printk(KERN_ERR DRV_NAME "%s: unable to get Rx DMA IRQ %d\n",
 		    dev->name, lp->rx_irq);
 		goto err_release;
 	}
 	ret = request_irq(lp->tx_irq, &korina_tx_dma_interrupt,
-			IRQF_DISABLED, "Korina ethernet Tx", dev);
+			0, "Korina ethernet Tx", dev);
 	if (ret < 0) {
 		printk(KERN_ERR DRV_NAME "%s: unable to get Tx DMA IRQ %d\n",
 		    dev->name, lp->tx_irq);
@@ -1019,7 +1019,7 @@ static int korina_open(struct net_device
 
 	/* Install handler for overrun error. */
 	ret = request_irq(lp->ovr_irq, &korina_ovr_interrupt,
-			IRQF_DISABLED, "Ethernet Overflow", dev);
+			0, "Ethernet Overflow", dev);
 	if (ret < 0) {
 		printk(KERN_ERR DRV_NAME"%s: unable to get OVR IRQ %d\n",
 		    dev->name, lp->ovr_irq);
@@ -1028,7 +1028,7 @@ static int korina_open(struct net_device
 
 	/* Install handler for underflow error. */
 	ret = request_irq(lp->und_irq, &korina_und_interrupt,
-			IRQF_DISABLED, "Ethernet Underflow", dev);
+			0, "Ethernet Underflow", dev);
 	if (ret < 0) {
 		printk(KERN_ERR DRV_NAME "%s: unable to get UND IRQ %d\n",
 		    dev->name, lp->und_irq);
Index: linux-2.6/drivers/net/pasemi_mac.c
===================================================================
--- linux-2.6.orig/drivers/net/pasemi_mac.c
+++ linux-2.6/drivers/net/pasemi_mac.c
@@ -1236,7 +1236,7 @@ static int pasemi_mac_open(struct net_de
 	snprintf(mac->tx_irq_name, sizeof(mac->tx_irq_name), "%s tx",
 		 dev->name);
 
-	ret = request_irq(mac->tx->chan.irq, &pasemi_mac_tx_intr, IRQF_DISABLED,
+	ret = request_irq(mac->tx->chan.irq, &pasemi_mac_tx_intr, 0,
 			  mac->tx_irq_name, mac->tx);
 	if (ret) {
 		dev_err(&mac->pdev->dev, "request_irq of irq %d failed: %d\n",
@@ -1247,7 +1247,7 @@ static int pasemi_mac_open(struct net_de
 	snprintf(mac->rx_irq_name, sizeof(mac->rx_irq_name), "%s rx",
 		 dev->name);
 
-	ret = request_irq(mac->rx->chan.irq, &pasemi_mac_rx_intr, IRQF_DISABLED,
+	ret = request_irq(mac->rx->chan.irq, &pasemi_mac_rx_intr, 0,
 			  mac->rx_irq_name, mac->rx);
 	if (ret) {
 		dev_err(&mac->pdev->dev, "request_irq of irq %d failed: %d\n",
Index: linux-2.6/drivers/net/ps3_gelic_net.c
===================================================================
--- linux-2.6.orig/drivers/net/ps3_gelic_net.c
+++ linux-2.6/drivers/net/ps3_gelic_net.c
@@ -1675,7 +1675,7 @@ static int ps3_gelic_driver_probe(struct
 		goto fail_alloc_irq;
 	}
 	result = request_irq(card->irq, gelic_card_interrupt,
-			     IRQF_DISABLED, netdev->name, card);
+			     0, netdev->name, card);
 
 	if (result) {
 		dev_info(ctodev(card), "%s:request_irq failed (%d)\n",
Index: linux-2.6/drivers/net/smsc911x.c
===================================================================
--- linux-2.6.orig/drivers/net/smsc911x.c
+++ linux-2.6/drivers/net/smsc911x.c
@@ -1968,7 +1968,7 @@ static int __devinit smsc911x_drv_probe(
 	smsc911x_reg_write(pdata, INT_EN, 0);
 	smsc911x_reg_write(pdata, INT_STS, 0xFFFFFFFF);
 
-	retval = request_irq(dev->irq, smsc911x_irqhandler, IRQF_DISABLED,
+	retval = request_irq(dev->irq, smsc911x_irqhandler, 0,
 			     dev->name, dev);
 	if (retval) {
 		SMSC_WARNING(PROBE,
Index: linux-2.6/drivers/net/smsc9420.c
===================================================================
--- linux-2.6.orig/drivers/net/smsc9420.c
+++ linux-2.6/drivers/net/smsc9420.c
@@ -1344,7 +1344,7 @@ static int smsc9420_open(struct net_devi
 	smsc9420_reg_write(pd, INT_STAT, 0xFFFFFFFF);
 	smsc9420_pci_flush_write(pd);
 
-	if (request_irq(dev->irq, smsc9420_isr, IRQF_SHARED | IRQF_DISABLED,
+	if (request_irq(dev->irq, smsc9420_isr, IRQF_SHARED ,
 			DRV_NAME, pd)) {
 		smsc_warn(IFUP, "Unable to use IRQ = %d", dev->irq);
 		result = -ENODEV;
Index: linux-2.6/drivers/net/sun3lance.c
===================================================================
--- linux-2.6.orig/drivers/net/sun3lance.c
+++ linux-2.6/drivers/net/sun3lance.c
@@ -349,7 +349,7 @@ static int __init lance_probe( struct ne
 
 	REGA(CSR0) = CSR0_STOP;
 
-	if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
+	if (request_irq(LANCE_IRQ, lance_interrupt, 0, "SUN3 Lance", dev) < 0) {
 #ifdef CONFIG_SUN3
 		iounmap((void __iomem *)ioaddr);
 #endif
Index: linux-2.6/drivers/net/tulip/de4x5.c
===================================================================
--- linux-2.6.orig/drivers/net/tulip/de4x5.c
+++ linux-2.6/drivers/net/tulip/de4x5.c
@@ -1319,7 +1319,7 @@ de4x5_open(struct net_device *dev)
     if (request_irq(dev->irq, de4x5_interrupt, IRQF_SHARED,
 		                                     lp->adapter_name, dev)) {
 	printk("de4x5_open(): Requested IRQ%d is busy - attemping FAST/SHARE...", dev->irq);
-	if (request_irq(dev->irq, de4x5_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(dev->irq, de4x5_interrupt,  IRQF_SHARED,
 			                             lp->adapter_name, dev)) {
 	    printk("\n              Cannot get IRQ- reconfigure your hardware.\n");
 	    disable_ast(dev);
Index: linux-2.6/drivers/net/wan/hostess_sv11.c
===================================================================
--- linux-2.6.orig/drivers/net/wan/hostess_sv11.c
+++ linux-2.6/drivers/net/wan/hostess_sv11.c
@@ -209,7 +209,7 @@ static struct z8530_dev *sv11_init(int i
 	/* We want a fast IRQ for this device. Actually we'd like an even faster
 	   IRQ ;) - This is one driver RtLinux is made for */
 
-	if (request_irq(irq, &z8530_interrupt, IRQF_DISABLED,
+	if (request_irq(irq, &z8530_interrupt, 0,
 			"Hostess SV11", sv) < 0) {
 		printk(KERN_WARNING "hostess: IRQ %d already in use.\n", irq);
 		goto err_irq;
Index: linux-2.6/drivers/net/wan/sealevel.c
===================================================================
--- linux-2.6.orig/drivers/net/wan/sealevel.c
+++ linux-2.6/drivers/net/wan/sealevel.c
@@ -259,7 +259,7 @@ static __init struct slvl_board *slvl_in
 	/* We want a fast IRQ for this device. Actually we'd like an even faster
 	   IRQ ;) - This is one driver RtLinux is made for */
 
-	if (request_irq(irq, &z8530_interrupt, IRQF_DISABLED,
+	if (request_irq(irq, &z8530_interrupt, 0,
 			"SeaLevel", dev) < 0) {
 		printk(KERN_WARNING "sealevel: IRQ %d already in use.\n", irq);
 		goto err_request_irq;
Index: linux-2.6/drivers/net/xtsonic.c
===================================================================
--- linux-2.6.orig/drivers/net/xtsonic.c
+++ linux-2.6/drivers/net/xtsonic.c
@@ -92,7 +92,7 @@ static unsigned short known_revisions[] 
 
 static int xtsonic_open(struct net_device *dev)
 {
-	if (request_irq(dev->irq,&sonic_interrupt,IRQF_DISABLED,"sonic",dev)) {
+	if (request_irq(dev->irq,&sonic_interrupt, 0,"sonic",dev)) {
 		printk(KERN_ERR "%s: unable to get IRQ %d.\n",
 		       dev->name, dev->irq);
 		return -EAGAIN;
Index: linux-2.6/drivers/parisc/superio.c
===================================================================
--- linux-2.6.orig/drivers/parisc/superio.c
+++ linux-2.6/drivers/parisc/superio.c
@@ -274,7 +274,7 @@ superio_init(struct pci_dev *pcidev)
 	else
 		printk(KERN_ERR PFX "USB regulator not initialized!\n");
 
-	if (request_irq(pdev->irq, superio_interrupt, IRQF_DISABLED,
+	if (request_irq(pdev->irq, superio_interrupt, 0,
 			SUPERIO, (void *)sio)) {
 
 		printk(KERN_ERR PFX "could not get irq\n");
Index: linux-2.6/drivers/pcmcia/soc_common.c
===================================================================
--- linux-2.6.orig/drivers/pcmcia/soc_common.c
+++ linux-2.6/drivers/pcmcia/soc_common.c
@@ -524,7 +524,7 @@ int soc_pcmcia_request_irqs(struct soc_p
 		if (irqs[i].sock != skt->nr)
 			continue;
 		res = request_irq(irqs[i].irq, soc_common_pcmcia_interrupt,
-				  IRQF_DISABLED, irqs[i].str, skt);
+				  0, irqs[i].str, skt);
 		if (res)
 			break;
 		set_irq_type(irqs[i].irq, IRQ_TYPE_NONE);
Index: linux-2.6/drivers/pnp/resource.c
===================================================================
--- linux-2.6.orig/drivers/pnp/resource.c
+++ linux-2.6/drivers/pnp/resource.c
@@ -380,7 +380,7 @@ int pnp_check_irq(struct pnp_dev *dev, s
 	 * device is active because it itself may be in use */
 	if (!dev->active) {
 		if (request_irq(*irq, pnp_test_handler,
-				IRQF_DISABLED | IRQF_PROBE_SHARED, "pnp", NULL))
+				 IRQF_PROBE_SHARED, "pnp", NULL))
 			return 0;
 		free_irq(*irq, NULL);
 	}
Index: linux-2.6/drivers/ps3/ps3-vuart.c
===================================================================
--- linux-2.6.orig/drivers/ps3/ps3-vuart.c
+++ linux-2.6/drivers/ps3/ps3-vuart.c
@@ -951,7 +951,7 @@ static int ps3_vuart_bus_interrupt_get(v
 	}
 
 	result = request_irq(vuart_bus_priv.virq, ps3_vuart_irq_handler,
-		IRQF_DISABLED, "vuart", &vuart_bus_priv);
+		0, "vuart", &vuart_bus_priv);
 
 	if (result) {
 		pr_debug("%s:%d: request_irq failed (%d)\n",
Index: linux-2.6/drivers/ps3/ps3stor_lib.c
===================================================================
--- linux-2.6.orig/drivers/ps3/ps3stor_lib.c
+++ linux-2.6/drivers/ps3/ps3stor_lib.c
@@ -107,7 +107,7 @@ int ps3stor_setup(struct ps3_storage_dev
 		goto fail_close_device;
 	}
 
-	error = request_irq(dev->irq, handler, IRQF_DISABLED,
+	error = request_irq(dev->irq, handler, 0,
 			    dev->sbd.core.driver->name, dev);
 	if (error) {
 		dev_err(&dev->sbd.core, "%s:%u: request_irq failed %d\n",
Index: linux-2.6/drivers/rtc/rtc-at91rm9200.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-at91rm9200.c
+++ linux-2.6/drivers/rtc/rtc-at91rm9200.c
@@ -289,7 +289,7 @@ static int __init at91_rtc_probe(struct 
 					AT91_RTC_CALEV);
 
 	ret = request_irq(AT91_ID_SYS, at91_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				 IRQF_SHARED,
 				"at91_rtc", pdev);
 	if (ret) {
 		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
Index: linux-2.6/drivers/rtc/rtc-at91sam9.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-at91sam9.c
+++ linux-2.6/drivers/rtc/rtc-at91sam9.c
@@ -350,7 +350,7 @@ static int __init at91_rtc_probe(struct 
 
 	/* register irq handler after we know what name we'll use */
 	ret = request_irq(AT91_ID_SYS, at91_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				 IRQF_SHARED,
 				rtc->rtcdev->dev.bus_id, rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", AT91_ID_SYS);
Index: linux-2.6/drivers/rtc/rtc-cmos.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-cmos.c
+++ linux-2.6/drivers/rtc/rtc-cmos.c
@@ -780,7 +780,7 @@ cmos_do_probe(struct device *dev, struct
 			rtc_cmos_int_handler = cmos_interrupt;
 
 		retval = request_irq(rtc_irq, rtc_cmos_int_handler,
-				IRQF_DISABLED, dev_name(&cmos_rtc.rtc->dev),
+				0, dev_name(&cmos_rtc.rtc->dev),
 				cmos_rtc.rtc);
 		if (retval < 0) {
 			dev_dbg(dev, "IRQ %d is already in use\n", rtc_irq);
Index: linux-2.6/drivers/rtc/rtc-ds1511.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-ds1511.c
+++ linux-2.6/drivers/rtc/rtc-ds1511.c
@@ -547,7 +547,7 @@ ds1511_rtc_probe(struct platform_device 
 	if (pdata->irq > 0) {
 		rtc_read(RTC_CMD1);
 		if (request_irq(pdata->irq, ds1511_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, pdev->name, pdev) < 0) {
+			 IRQF_SHARED, pdev->name, pdev) < 0) {
 
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
Index: linux-2.6/drivers/rtc/rtc-ds1553.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-ds1553.c
+++ linux-2.6/drivers/rtc/rtc-ds1553.c
@@ -329,7 +329,7 @@ static int __devinit ds1553_rtc_probe(st
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				 IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
Index: linux-2.6/drivers/rtc/rtc-omap.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-omap.c
+++ linux-2.6/drivers/rtc/rtc-omap.c
@@ -376,13 +376,13 @@ static int __init omap_rtc_probe(struct 
 		rtc_write(OMAP_RTC_STATUS_ALARM, OMAP_RTC_STATUS_REG);
 
 	/* handle periodic and alarm irqs */
-	if (request_irq(omap_rtc_timer, rtc_irq, IRQF_DISABLED,
+	if (request_irq(omap_rtc_timer, rtc_irq, 0,
 			rtc->dev.bus_id, rtc)) {
 		pr_debug("%s: RTC timer interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_timer);
 		goto fail0;
 	}
-	if (request_irq(omap_rtc_alarm, rtc_irq, IRQF_DISABLED,
+	if (request_irq(omap_rtc_alarm, rtc_irq, 0,
 			rtc->dev.bus_id, rtc)) {
 		pr_debug("%s: RTC alarm interrupt IRQ%d already claimed\n",
 			pdev->name, omap_rtc_alarm);
Index: linux-2.6/drivers/rtc/rtc-pl030.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-pl030.c
+++ linux-2.6/drivers/rtc/rtc-pl030.c
@@ -128,7 +128,7 @@ static int pl030_probe(struct amba_devic
 
 	amba_set_drvdata(dev, rtc);
 
-	ret = request_irq(dev->irq[0], pl030_interrupt, IRQF_DISABLED,
+	ret = request_irq(dev->irq[0], pl030_interrupt, 0,
 			  "rtc-pl030", rtc);
 	if (ret)
 		goto err_irq;
Index: linux-2.6/drivers/rtc/rtc-pl031.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-pl031.c
+++ linux-2.6/drivers/rtc/rtc-pl031.c
@@ -151,7 +151,7 @@ static int pl031_probe(struct amba_devic
 
 	amba_set_drvdata(adev, ldata);
 
-	if (request_irq(adev->irq[0], pl031_interrupt, IRQF_DISABLED,
+	if (request_irq(adev->irq[0], pl031_interrupt, 0,
 			"rtc-pl031", ldata->rtc)) {
 		ret = -EIO;
 		goto out_no_irq;
Index: linux-2.6/drivers/rtc/rtc-pxa.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-pxa.c
+++ linux-2.6/drivers/rtc/rtc-pxa.c
@@ -174,14 +174,14 @@ static int pxa_rtc_open(struct device *d
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
 	int ret;
 
-	ret = request_irq(pxa_rtc->irq_1Hz, pxa_rtc_irq, IRQF_DISABLED,
+	ret = request_irq(pxa_rtc->irq_1Hz, pxa_rtc_irq, 0,
 			  "rtc 1Hz", dev);
 	if (ret < 0) {
 		dev_err(dev, "can't get irq %i, err %d\n", pxa_rtc->irq_1Hz,
 			ret);
 		goto err_irq_1Hz;
 	}
-	ret = request_irq(pxa_rtc->irq_Alrm, pxa_rtc_irq, IRQF_DISABLED,
+	ret = request_irq(pxa_rtc->irq_Alrm, pxa_rtc_irq, 0,
 			  "rtc Alrm", dev);
 	if (ret < 0) {
 		dev_err(dev, "can't get irq %i, err %d\n", pxa_rtc->irq_Alrm,
Index: linux-2.6/drivers/rtc/rtc-s3c.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-s3c.c
+++ linux-2.6/drivers/rtc/rtc-s3c.c
@@ -296,7 +296,7 @@ static int s3c_rtc_open(struct device *d
 	int ret;
 
 	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
-			  IRQF_DISABLED,  "s3c2410-rtc alarm", rtc_dev);
+			  0,  "s3c2410-rtc alarm", rtc_dev);
 
 	if (ret) {
 		dev_err(dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
@@ -304,7 +304,7 @@ static int s3c_rtc_open(struct device *d
 	}
 
 	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
-			  IRQF_DISABLED,  "s3c2410-rtc tick", rtc_dev);
+			  0,  "s3c2410-rtc tick", rtc_dev);
 
 	if (ret) {
 		dev_err(dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
Index: linux-2.6/drivers/rtc/rtc-sa1100.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-sa1100.c
+++ linux-2.6/drivers/rtc/rtc-sa1100.c
@@ -190,19 +190,19 @@ static int sa1100_rtc_open(struct device
 {
 	int ret;
 
-	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, IRQF_DISABLED,
+	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, 0,
 				"rtc 1Hz", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTC1Hz);
 		goto fail_ui;
 	}
-	ret = request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, IRQF_DISABLED,
+	ret = request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, 0,
 				"rtc Alrm", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTCAlrm);
 		goto fail_ai;
 	}
-	ret = request_irq(IRQ_OST1, timer1_interrupt, IRQF_DISABLED,
+	ret = request_irq(IRQ_OST1, timer1_interrupt, 0,
 				"rtc timer", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_OST1);
Index: linux-2.6/drivers/rtc/rtc-sh.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-sh.c
+++ linux-2.6/drivers/rtc/rtc-sh.c
@@ -652,7 +652,7 @@ static int __devinit sh_rtc_probe(struct
 	platform_set_drvdata(pdev, rtc);
 
 	/* register periodic/carry/alarm irqs */
-	ret = request_irq(rtc->periodic_irq, sh_rtc_periodic, IRQF_DISABLED,
+	ret = request_irq(rtc->periodic_irq, sh_rtc_periodic, 0,
 			  "sh-rtc period", rtc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev,
@@ -661,7 +661,7 @@ static int __devinit sh_rtc_probe(struct
 		goto err_unmap;
 	}
 
-	ret = request_irq(rtc->carry_irq, sh_rtc_interrupt, IRQF_DISABLED,
+	ret = request_irq(rtc->carry_irq, sh_rtc_interrupt, 0,
 			  "sh-rtc carry", rtc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev,
@@ -671,7 +671,7 @@ static int __devinit sh_rtc_probe(struct
 		goto err_unmap;
 	}
 
-	ret = request_irq(rtc->alarm_irq, sh_rtc_alarm, IRQF_DISABLED,
+	ret = request_irq(rtc->alarm_irq, sh_rtc_alarm, 0,
 			  "sh-rtc alarm", rtc);
 	if (unlikely(ret)) {
 		dev_err(&pdev->dev,
Index: linux-2.6/drivers/rtc/rtc-stk17ta8.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-stk17ta8.c
+++ linux-2.6/drivers/rtc/rtc-stk17ta8.c
@@ -331,7 +331,7 @@ static int __init stk17ta8_rtc_probe(str
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, stk17ta8_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				 IRQF_SHARED,
 				pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
Index: linux-2.6/drivers/rtc/rtc-tx4939.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-tx4939.c
+++ linux-2.6/drivers/rtc/rtc-tx4939.c
@@ -261,7 +261,7 @@ static int __init tx4939_rtc_probe(struc
 
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED,
+			      IRQF_SHARED,
 			     pdev->name, &pdev->dev) < 0) {
 		return -EBUSY;
 	}
Index: linux-2.6/drivers/rtc/rtc-vr41xx.c
===================================================================
--- linux-2.6.orig/drivers/rtc/rtc-vr41xx.c
+++ linux-2.6/drivers/rtc/rtc-vr41xx.c
@@ -368,7 +368,7 @@ static int __devinit rtc_probe(struct pl
 		goto err_device_unregister;
 	}
 
-	retval = request_irq(aie_irq, elapsedtime_interrupt, IRQF_DISABLED,
+	retval = request_irq(aie_irq, elapsedtime_interrupt, 0,
 	                     "elapsed_time", pdev);
 	if (retval < 0)
 		goto err_device_unregister;
@@ -377,7 +377,7 @@ static int __devinit rtc_probe(struct pl
 	if (pie_irq <= 0)
 		goto err_free_irq;
 
-	retval = request_irq(pie_irq, rtclong1_interrupt, IRQF_DISABLED,
+	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
 		             "rtclong1", pdev);
 	if (retval < 0)
 		goto err_free_irq;
Index: linux-2.6/drivers/scsi/NCR5380.c
===================================================================
--- linux-2.6.orig/drivers/scsi/NCR5380.c
+++ linux-2.6/drivers/scsi/NCR5380.c
@@ -584,7 +584,7 @@ static int __init __maybe_unused NCR5380
 	NCR5380_setup(instance);
 
 	for (trying_irqs = i = 0, mask = 1; i < 16; ++i, mask <<= 1)
-		if ((mask & possible) && (request_irq(i, &probe_intr, IRQF_DISABLED, "NCR-probe", NULL) == 0))
+		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
 			trying_irqs |= mask;
 
 	timeout = jiffies + (250 * HZ / 1000);
Index: linux-2.6/drivers/scsi/aacraid/rx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/rx.c
+++ linux-2.6/drivers/scsi/aacraid/rx.c
@@ -626,7 +626,7 @@ int _aac_rx_init(struct aac_dev *dev)
 	aac_adapter_comm(dev, dev->comm_interface);
 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+			IRQF_SHARED, "aacraid", dev) < 0) {
 		if (dev->msi)
 			pci_disable_msi(dev->pdev);
 		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
Index: linux-2.6/drivers/scsi/aacraid/sa.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aacraid/sa.c
+++ linux-2.6/drivers/scsi/aacraid/sa.c
@@ -386,7 +386,7 @@ int aac_sa_init(struct aac_dev *dev)
 	if(aac_init_adapter(dev) == NULL)
 		goto error_irq;
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED,
+			IRQF_SHARED,
 			"aacraid", (void *)dev ) < 0) {
 		printk(KERN_WARNING "%s%d: Interrupt unavailable.\n",
 			name, instance);
Index: linux-2.6/drivers/scsi/aha152x.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aha152x.c
+++ linux-2.6/drivers/scsi/aha152x.c
@@ -848,7 +848,7 @@ struct Scsi_Host *aha152x_probe_one(stru
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, 0);
 
-	if( request_irq(shpnt->irq, swintr, IRQF_DISABLED|IRQF_SHARED, "aha152x", shpnt) ) {
+	if( request_irq(shpnt->irq, swintr, IRQF_SHARED, "aha152x", shpnt) ) {
 		printk(KERN_ERR "aha152x%d: irq %d busy.\n", shpnt->host_no, shpnt->irq);
 		goto out_host_put;
 	}
@@ -882,7 +882,7 @@ struct Scsi_Host *aha152x_probe_one(stru
 	SETPORT(SSTAT0, 0x7f);
 	SETPORT(SSTAT1, 0xef);
 
-	if ( request_irq(shpnt->irq, intr, IRQF_DISABLED|IRQF_SHARED, "aha152x", shpnt) ) {
+	if ( request_irq(shpnt->irq, intr, IRQF_SHARED, "aha152x", shpnt) ) {
 		printk(KERN_ERR "aha152x%d: failed to reassign irq %d.\n", shpnt->host_no, shpnt->irq);
 		goto out_host_put;
 	}
Index: linux-2.6/drivers/scsi/aic7xxx_old.c
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx_old.c
+++ linux-2.6/drivers/scsi/aic7xxx_old.c
@@ -8312,7 +8312,7 @@ aic7xxx_register(struct scsi_host_templa
               "aic7xxx", p));
     if (result < 0)
     {
-      result = (request_irq(p->irq, do_aic7xxx_isr, IRQF_DISABLED | IRQF_SHARED,
+      result = (request_irq(p->irq, do_aic7xxx_isr,  IRQF_SHARED,
               "aic7xxx", p));
     }
   }
Index: linux-2.6/drivers/scsi/arm/acornscsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/arm/acornscsi.c
+++ linux-2.6/drivers/scsi/arm/acornscsi.c
@@ -2995,7 +2995,7 @@ acornscsi_probe(struct expansion_card *e
 	ec->irqaddr	= ashost->fast + INT_REG;
 	ec->irqmask	= 0x0a;
 
-	ret = request_irq(host->irq, acornscsi_intr, IRQF_DISABLED, "acornscsi", ashost);
+	ret = request_irq(host->irq, acornscsi_intr, 0, "acornscsi", ashost);
 	if (ret) {
 		printk(KERN_CRIT "scsi%d: IRQ%d not free: %d\n",
 			host->host_no, ashost->scsi.irq, ret);
Index: linux-2.6/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux-2.6.orig/drivers/scsi/arm/cumana_1.c
+++ linux-2.6/drivers/scsi/arm/cumana_1.c
@@ -264,7 +264,7 @@ cumanascsi1_probe(struct expansion_card 
 		goto out_unmap;
 	}
 
-	ret = request_irq(host->irq, cumanascsi_intr, IRQF_DISABLED,
+	ret = request_irq(host->irq, cumanascsi_intr, 0,
 			  "CumanaSCSI-1", host);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
Index: linux-2.6/drivers/scsi/arm/cumana_2.c
===================================================================
--- linux-2.6.orig/drivers/scsi/arm/cumana_2.c
+++ linux-2.6/drivers/scsi/arm/cumana_2.c
@@ -455,7 +455,7 @@ cumanascsi2_probe(struct expansion_card 
 		goto out_free;
 
 	ret = request_irq(ec->irq, cumanascsi_2_intr,
-			  IRQF_DISABLED, "cumanascsi2", info);
+			  0, "cumanascsi2", info);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
 		       host->host_no, ec->irq, ret);
Index: linux-2.6/drivers/scsi/arm/powertec.c
===================================================================
--- linux-2.6.orig/drivers/scsi/arm/powertec.c
+++ linux-2.6/drivers/scsi/arm/powertec.c
@@ -368,7 +368,7 @@ powertecscsi_probe(struct expansion_card
 		goto out_free;
 
 	ret = request_irq(ec->irq, powertecscsi_intr,
-			  IRQF_DISABLED, "powertec", info);
+			  0, "powertec", info);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
 		       host->host_no, ec->irq, ret);
Index: linux-2.6/drivers/scsi/dtc.c
===================================================================
--- linux-2.6.orig/drivers/scsi/dtc.c
+++ linux-2.6/drivers/scsi/dtc.c
@@ -247,7 +247,7 @@ found:
 		/* With interrupts enabled, it will sometimes hang when doing heavy
 		 * reads. So better not enable them until I finger it out. */
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, dtc_intr, IRQF_DISABLED,
+			if (request_irq(instance->irq, dtc_intr, 0,
 					"dtc", instance)) {
 				printk(KERN_ERR "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
Index: linux-2.6/drivers/scsi/eata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata.c
+++ linux-2.6/drivers/scsi/eata.c
@@ -1221,7 +1221,7 @@ static int port_detect(unsigned long por
 
 	/* Board detected, allocate its IRQ */
 	if (request_irq(irq, do_interrupt_handler,
-			IRQF_DISABLED | ((subversion == ESA) ? IRQF_SHARED : 0),
+			 ((subversion == ESA) ? IRQF_SHARED : 0),
 			driver_name, (void *)&sha[j])) {
 		printk("%s: unable to allocate IRQ %u, detaching.\n", name,
 		       irq);
Index: linux-2.6/drivers/scsi/eata_pio.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata_pio.c
+++ linux-2.6/drivers/scsi/eata_pio.c
@@ -725,7 +725,7 @@ static int register_pio_HBA(long base, s
 		return 0;
 
 	if (!reg_IRQ[gc->IRQ]) {	/* Interrupt already registered ? */
-		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, IRQF_DISABLED, "EATA-PIO", sh)) {
+		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, 0, "EATA-PIO", sh)) {
 			reg_IRQ[gc->IRQ]++;
 			if (!gc->IRQ_TR)
 				reg_IRQL[gc->IRQ] = 1;	/* IRQ is edge triggered */
@@ -959,7 +959,7 @@ static int eata_pio_detect(struct scsi_h
 
 	for (i = 0; i <= MAXIRQ; i++)
 		if (reg_IRQ[i])
-			request_irq(i, do_eata_pio_int_handler, IRQF_DISABLED, "EATA-PIO", NULL);
+			request_irq(i, do_eata_pio_int_handler, 0, "EATA-PIO", NULL);
 
 	HBA_ptr = first_HBA;
 
Index: linux-2.6/drivers/scsi/g_NCR5380.c
===================================================================
--- linux-2.6.orig/drivers/scsi/g_NCR5380.c
+++ linux-2.6/drivers/scsi/g_NCR5380.c
@@ -461,7 +461,7 @@ int __init generic_NCR5380_detect(struct
 
 		if (instance->irq != SCSI_IRQ_NONE)
 			if (request_irq(instance->irq, generic_NCR5380_intr,
-					IRQF_DISABLED, "NCR5380", instance)) {
+					0, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c
+++ linux-2.6/drivers/scsi/gdth.c
@@ -4693,7 +4693,7 @@ static int __init gdth_isa_probe_one(ulo
 	printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
 		isa_bios, ha->irq, ha->drq);
 
-	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	error = request_irq(ha->irq, gdth_interrupt, 0, "gdth", ha);
 	if (error) {
 		printk("GDT-ISA: Unable to allocate IRQ\n");
 		goto out_host_put;
@@ -4825,7 +4825,7 @@ static int __init gdth_eisa_probe_one(us
 	printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
 		eisa_slot >> 12, ha->irq);
 
-	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	error = request_irq(ha->irq, gdth_interrupt, 0, "gdth", ha);
 	if (error) {
 		printk("GDT-EISA: Unable to allocate IRQ\n");
 		goto out_host_put;
@@ -4962,7 +4962,7 @@ static int __devinit gdth_pci_probe_one(
 		ha->irq);
 
 	error = request_irq(ha->irq, gdth_interrupt,
-				IRQF_DISABLED|IRQF_SHARED, "gdth", ha);
+				IRQF_SHARED, "gdth", ha);
 	if (error) {
 		printk("GDT-PCI: Unable to allocate IRQ\n");
 		goto out_host_put;
Index: linux-2.6/drivers/scsi/ibmvscsi/ibmvstgt.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ linux-2.6/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -588,7 +588,7 @@ static int crq_queue_create(struct crq_q
 	}
 
 	err = request_irq(vport->dma_dev->irq, &ibmvstgt_interrupt,
-			  IRQF_DISABLED, "ibmvstgt", target);
+			  0, "ibmvstgt", target);
 	if (err)
 		goto req_irq_failed;
 
Index: linux-2.6/drivers/scsi/in2000.c
===================================================================
--- linux-2.6.orig/drivers/scsi/in2000.c
+++ linux-2.6/drivers/scsi/in2000.c
@@ -2015,7 +2015,7 @@ static int __init in2000_detect(struct s
 		write1_io(0, IO_FIFO_READ);	/* start fifo out in read mode */
 		write1_io(0, IO_INTR_MASK);	/* allow all ints */
 		x = int_tab[(switches & (SW_INT0 | SW_INT1)) >> SW_INT_SHIFT];
-		if (request_irq(x, in2000_intr, IRQF_DISABLED, "in2000", instance)) {
+		if (request_irq(x, in2000_intr, 0, "in2000", instance)) {
 			printk("in2000_detect: Unable to allocate IRQ.\n");
 			detect_count--;
 			continue;
Index: linux-2.6/drivers/scsi/initio.c
===================================================================
--- linux-2.6.orig/drivers/scsi/initio.c
+++ linux-2.6/drivers/scsi/initio.c
@@ -2930,7 +2930,7 @@ static int initio_probe_one(struct pci_d
 	shost->base = host->addr;
 	shost->sg_tablesize = TOTAL_SG_ENTRY;
 
-	error = request_irq(pdev->irq, i91u_intr, IRQF_DISABLED|IRQF_SHARED, "i91u", shost);
+	error = request_irq(pdev->irq, i91u_intr, IRQF_SHARED, "i91u", shost);
 	if (error < 0) {
 		printk(KERN_WARNING "initio: Unable to request IRQ %d\n", pdev->irq);
 		goto out_free_scbs;
Index: linux-2.6/drivers/scsi/pas16.c
===================================================================
--- linux-2.6.orig/drivers/scsi/pas16.c
+++ linux-2.6/drivers/scsi/pas16.c
@@ -453,7 +453,7 @@ int __init pas16_detect(struct scsi_host
 	    instance->irq = NCR5380_probe_irq(instance, PAS16_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED,
+	    if (request_irq(instance->irq, pas16_intr, 0,
 			    "pas16", instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
Index: linux-2.6/drivers/scsi/qla1280.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla1280.c
+++ linux-2.6/drivers/scsi/qla1280.c
@@ -192,7 +192,7 @@
         - Don't walk the entire list in qla1280_putq_t() just to directly
 	  grab the pointer to the last element afterwards
     Rev  3.23.5 Beta August 9, 2001, Jes Sorensen
-	- Don't use IRQF_DISABLED, it's use is deprecated for this kinda driver
+	- Don't use 0, it's use is deprecated for this kinda driver
     Rev  3.23.4 Beta August 8, 2001, Jes Sorensen
 	- Set dev->max_sectors to 1024
     Rev  3.23.3 Beta August 6, 2001, Jes Sorensen
Index: linux-2.6/drivers/scsi/qla2xxx/qla_isr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_isr.c
+++ linux-2.6/drivers/scsi/qla2xxx/qla_isr.c
@@ -2029,7 +2029,7 @@ skip_msix:
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-	    IRQF_DISABLED|IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
+	    IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
Index: linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla4xxx/ql4_os.c
+++ linux-2.6/drivers/scsi/qla4xxx/ql4_os.c
@@ -1288,7 +1288,7 @@ static int __devinit qla4xxx_probe_adapt
 	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc);
 
 	ret = request_irq(pdev->irq, qla4xxx_intr_handler,
-			  IRQF_DISABLED | IRQF_SHARED, "qla4xxx", ha);
+			   IRQF_SHARED, "qla4xxx", ha);
 	if (ret) {
 		dev_warn(&ha->pdev->dev, "Failed to reserve interrupt %d"
 			" already in use.\n", pdev->irq);
Index: linux-2.6/drivers/scsi/t128.c
===================================================================
--- linux-2.6.orig/drivers/scsi/t128.c
+++ linux-2.6/drivers/scsi/t128.c
@@ -259,7 +259,7 @@ found:
 	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128",
+	    if (request_irq(instance->irq, t128_intr, 0, "t128",
 			    instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
Index: linux-2.6/drivers/scsi/u14-34f.c
===================================================================
--- linux-2.6.orig/drivers/scsi/u14-34f.c
+++ linux-2.6/drivers/scsi/u14-34f.c
@@ -873,7 +873,7 @@ static int port_detect \
 
    /* Board detected, allocate its IRQ */
    if (request_irq(irq, do_interrupt_handler,
-             IRQF_DISABLED | ((subversion == ESA) ? IRQF_SHARED : 0),
+              ((subversion == ESA) ? IRQF_SHARED : 0),
              driver_name, (void *) &sha[j])) {
       printk("%s: unable to allocate IRQ %u, detaching.\n", name, irq);
       goto freelock;
Index: linux-2.6/drivers/scsi/wd7000.c
===================================================================
--- linux-2.6.orig/drivers/scsi/wd7000.c
+++ linux-2.6/drivers/scsi/wd7000.c
@@ -1252,7 +1252,7 @@ static int wd7000_init(Adapter * host)
 		return 0;
 
 
-	if (request_irq(host->irq, wd7000_intr, IRQF_DISABLED, "wd7000", host)) {
+	if (request_irq(host->irq, wd7000_intr, 0, "wd7000", host)) {
 		printk("wd7000_init: can't get IRQ %d.\n", host->irq);
 		return (0);
 	}
Index: linux-2.6/drivers/serial/68328serial.c
===================================================================
--- linux-2.6.orig/drivers/serial/68328serial.c
+++ linux-2.6/drivers/serial/68328serial.c
@@ -1385,7 +1385,7 @@ rs68328_init(void)
 
 	    if (request_irq(uart_irqs[i],
 			    rs_interrupt,
-			    IRQF_DISABLED,
+			    0,
 			    "M68328_UART", info))
                 panic("Unable to attach 68328 serial interrupt\n");
 	}
Index: linux-2.6/drivers/serial/bfin_5xx.c
===================================================================
--- linux-2.6.orig/drivers/serial/bfin_5xx.c
+++ linux-2.6/drivers/serial/bfin_5xx.c
@@ -609,14 +609,14 @@ static int bfin_serial_startup(struct ua
 		kgdboc_break_enabled = 0;
 	else {
 # endif
-	if (request_irq(uart->port.irq, bfin_serial_rx_int, IRQF_DISABLED,
+	if (request_irq(uart->port.irq, bfin_serial_rx_int, 0,
 	     "BFIN_UART_RX", uart)) {
 		printk(KERN_NOTICE "Unable to attach BlackFin UART RX interrupt\n");
 		return -EBUSY;
 	}
 
 	if (request_irq
-	    (uart->port.irq+1, bfin_serial_tx_int, IRQF_DISABLED,
+	    (uart->port.irq+1, bfin_serial_tx_int, 0,
 	     "BFIN_UART_TX", uart)) {
 		printk(KERN_NOTICE "Unable to attach BlackFin UART TX interrupt\n");
 		free_irq(uart->port.irq, uart);
Index: linux-2.6/drivers/serial/crisv10.c
===================================================================
--- linux-2.6.orig/drivers/serial/crisv10.c
+++ linux-2.6/drivers/serial/crisv10.c
@@ -256,7 +256,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_out_enabled = 1,
 	  .dma_out_nbr = SER0_TX_DMA_NBR,
 	  .dma_out_irq_nbr = SER0_DMA_TX_IRQ_NBR,
-	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_flags = 0,
 	  .dma_out_irq_description = "serial 0 dma tr",
 #else
 	  .dma_out_enabled = 0,
@@ -269,7 +269,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_in_enabled = 1,
 	  .dma_in_nbr = SER0_RX_DMA_NBR,
 	  .dma_in_irq_nbr = SER0_DMA_RX_IRQ_NBR,
-	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_flags = 0,
 	  .dma_in_irq_description = "serial 0 dma rec",
 #else
 	  .dma_in_enabled = 0,
@@ -311,7 +311,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_out_enabled = 1,
 	  .dma_out_nbr = SER1_TX_DMA_NBR,
 	  .dma_out_irq_nbr = SER1_DMA_TX_IRQ_NBR,
-	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_flags = 0,
 	  .dma_out_irq_description = "serial 1 dma tr",
 #else
 	  .dma_out_enabled = 0,
@@ -324,7 +324,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_in_enabled = 1,
 	  .dma_in_nbr = SER1_RX_DMA_NBR,
 	  .dma_in_irq_nbr = SER1_DMA_RX_IRQ_NBR,
-	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_flags = 0,
 	  .dma_in_irq_description = "serial 1 dma rec",
 #else
 	  .dma_in_enabled = 0,
@@ -367,7 +367,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_out_enabled = 1,
 	  .dma_out_nbr = SER2_TX_DMA_NBR,
 	  .dma_out_irq_nbr = SER2_DMA_TX_IRQ_NBR,
-	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_flags = 0,
 	  .dma_out_irq_description = "serial 2 dma tr",
 #else
 	  .dma_out_enabled = 0,
@@ -380,7 +380,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_in_enabled = 1,
 	  .dma_in_nbr = SER2_RX_DMA_NBR,
 	  .dma_in_irq_nbr = SER2_DMA_RX_IRQ_NBR,
-	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_flags = 0,
 	  .dma_in_irq_description = "serial 2 dma rec",
 #else
 	  .dma_in_enabled = 0,
@@ -421,7 +421,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_out_enabled = 1,
 	  .dma_out_nbr = SER3_TX_DMA_NBR,
 	  .dma_out_irq_nbr = SER3_DMA_TX_IRQ_NBR,
-	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_flags = 0,
 	  .dma_out_irq_description = "serial 3 dma tr",
 #else
 	  .dma_out_enabled = 0,
@@ -434,7 +434,7 @@ static struct e100_serial rs_table[] = {
 	  .dma_in_enabled = 1,
 	  .dma_in_nbr = SER3_RX_DMA_NBR,
 	  .dma_in_irq_nbr = SER3_DMA_RX_IRQ_NBR,
-	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_flags = 0,
 	  .dma_in_irq_description = "serial 3 dma rec",
 #else
 	  .dma_in_enabled = 0,
@@ -4521,7 +4521,7 @@ rs_init(void)
 	/* hook the irq's for DMA channel 6 and 7, serial output and input, and some more... */
 
 	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt,
-			IRQF_SHARED | IRQF_DISABLED, "serial ", driver))
+			IRQF_SHARED , "serial ", driver))
 		panic("%s: Failed to request irq8", __func__);
 
 #endif
Index: linux-2.6/drivers/serial/icom.c
===================================================================
--- linux-2.6.orig/drivers/serial/icom.c
+++ linux-2.6/drivers/serial/icom.c
@@ -1561,7 +1561,7 @@ static int __devinit icom_probe(struct p
 
 	 /* save off irq and request irq line */
 	 if ( (retval = request_irq(dev->irq, icom_interrupt,
-				   IRQF_DISABLED | IRQF_SHARED, ICOM_DRIVER_NAME,
+				    IRQF_SHARED, ICOM_DRIVER_NAME,
 				   (void *) icom_adapter))) {
 		  goto probe_exit2;
 	 }
Index: linux-2.6/drivers/serial/jsm/jsm_driver.c
===================================================================
--- linux-2.6.orig/drivers/serial/jsm/jsm_driver.c
+++ linux-2.6/drivers/serial/jsm/jsm_driver.c
@@ -125,7 +125,7 @@ static int jsm_probe_one(struct pci_dev 
 	}
 
 	rc = request_irq(brd->irq, brd->bd_ops->intr,
-			IRQF_DISABLED|IRQF_SHARED, "JSM", brd);
+			IRQF_SHARED, "JSM", brd);
 	if (rc) {
 		printk(KERN_WARNING "Failed to hook IRQ %d\n",brd->irq);
 		goto out_iounmap;
Index: linux-2.6/drivers/serial/mcf.c
===================================================================
--- linux-2.6.orig/drivers/serial/mcf.c
+++ linux-2.6/drivers/serial/mcf.c
@@ -383,7 +383,7 @@ static void mcf_config_port(struct uart_
 	/* Clear mask, so no surprise interrupts. */
 	writeb(0, port->membase + MCFUART_UIMR);
 
-	if (request_irq(port->irq, mcf_interrupt, IRQF_DISABLED, "UART", port))
+	if (request_irq(port->irq, mcf_interrupt, 0, "UART", port))
 		printk(KERN_ERR "MCF: unable to attach ColdFire UART %d "
 			"interrupt vector=%d\n", port->line, port->irq);
 }
Index: linux-2.6/drivers/serial/mpc52xx_uart.c
===================================================================
--- linux-2.6.orig/drivers/serial/mpc52xx_uart.c
+++ linux-2.6/drivers/serial/mpc52xx_uart.c
@@ -522,7 +522,7 @@ mpc52xx_uart_startup(struct uart_port *p
 
 	/* Request IRQ */
 	ret = request_irq(port->irq, mpc52xx_uart_int,
-		IRQF_DISABLED | IRQF_SAMPLE_RANDOM | IRQF_SHARED,
+		 IRQF_SAMPLE_RANDOM | IRQF_SHARED,
 		"mpc52xx_psc_uart", port);
 	if (ret)
 		return ret;
Index: linux-2.6/drivers/serial/serial_ks8695.c
===================================================================
--- linux-2.6.orig/drivers/serial/serial_ks8695.c
+++ linux-2.6/drivers/serial/serial_ks8695.c
@@ -334,19 +334,19 @@ static int ks8695uart_startup(struct uar
 	/*
 	 * Allocate the IRQ
 	 */
-	retval = request_irq(KS8695_IRQ_UART_TX, ks8695uart_tx_chars, IRQF_DISABLED, "UART TX", port);
+	retval = request_irq(KS8695_IRQ_UART_TX, ks8695uart_tx_chars, 0, "UART TX", port);
 	if (retval)
 		goto err_tx;
 
-	retval = request_irq(KS8695_IRQ_UART_RX, ks8695uart_rx_chars, IRQF_DISABLED, "UART RX", port);
+	retval = request_irq(KS8695_IRQ_UART_RX, ks8695uart_rx_chars, 0, "UART RX", port);
 	if (retval)
 		goto err_rx;
 
-	retval = request_irq(KS8695_IRQ_UART_LINE_STATUS, ks8695uart_rx_chars, IRQF_DISABLED, "UART LineStatus", port);
+	retval = request_irq(KS8695_IRQ_UART_LINE_STATUS, ks8695uart_rx_chars, 0, "UART LineStatus", port);
 	if (retval)
 		goto err_ls;
 
-	retval = request_irq(KS8695_IRQ_UART_MODEM_STATUS, ks8695uart_modem_status, IRQF_DISABLED, "UART ModemStatus", port);
+	retval = request_irq(KS8695_IRQ_UART_MODEM_STATUS, ks8695uart_modem_status, 0, "UART ModemStatus", port);
 	if (retval)
 		goto err_ms;
 
Index: linux-2.6/drivers/serial/sh-sci.c
===================================================================
--- linux-2.6.orig/drivers/serial/sh-sci.c
+++ linux-2.6/drivers/serial/sh-sci.c
@@ -754,7 +754,7 @@ static int sci_request_irq(struct sci_po
 			return -ENODEV;
 
 		if (request_irq(port->irqs[0], sci_mpxed_interrupt,
-				IRQF_DISABLED, "sci", port)) {
+				0, "sci", port)) {
 			dev_err(port->port.dev, "Can't allocate IRQ\n");
 			return -ENODEV;
 		}
@@ -764,7 +764,7 @@ static int sci_request_irq(struct sci_po
 				continue;
 
 			if (request_irq(port->irqs[i], handlers[i],
-					IRQF_DISABLED, desc[i], port)) {
+					0, desc[i], port)) {
 				dev_err(port->port.dev, "Can't allocate IRQ\n");
 				return -ENODEV;
 			}
Index: linux-2.6/drivers/serial/sn_console.c
===================================================================
--- linux-2.6.orig/drivers/serial/sn_console.c
+++ linux-2.6/drivers/serial/sn_console.c
@@ -737,7 +737,7 @@ static void __init sn_sal_switch_to_inte
 		DPRINTF("sn_console: switching to interrupt driven console\n");
 
 		if (request_irq(SGI_UART_VECTOR, sn_sal_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				 IRQF_SHARED,
 				"SAL console driver", port) >= 0) {
 			spin_lock_irqsave(&port->sc_port.lock, flags);
 			port->sc_port.irq = SGI_UART_VECTOR;
Index: linux-2.6/drivers/serial/uartlite.c
===================================================================
--- linux-2.6.orig/drivers/serial/uartlite.c
+++ linux-2.6/drivers/serial/uartlite.c
@@ -221,7 +221,7 @@ static int ulite_startup(struct uart_por
 	int ret;
 
 	ret = request_irq(port->irq, ulite_isr,
-			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "uartlite", port);
+			   IRQF_SAMPLE_RANDOM, "uartlite", port);
 	if (ret)
 		return ret;
 
Index: linux-2.6/drivers/spi/spi_imx.c
===================================================================
--- linux-2.6.orig/drivers/spi/spi_imx.c
+++ linux-2.6/drivers/spi/spi_imx.c
@@ -1525,7 +1525,7 @@ static int __init spi_imx_probe(struct p
 		status = -ENODEV;
 		goto err_no_irqres;
 	}
-	status = request_irq(irq, spi_int, IRQF_DISABLED, dev->bus_id, drv_data);
+	status = request_irq(irq, spi_int, 0, dev->bus_id, drv_data);
 	if (status < 0) {
 		dev_err(&pdev->dev, "probe - cannot get IRQ (%d)\n", status);
 		goto err_no_irqres;
Index: linux-2.6/drivers/staging/me4000/me4000.c
===================================================================
--- linux-2.6.orig/drivers/staging/me4000/me4000.c
+++ linux-2.6/drivers/staging/me4000/me4000.c
@@ -836,7 +836,7 @@ static int alloc_ao_contexts(struct me40
 			/* Request the interrupt line */
 			err =
 			    request_irq(ao_context->irq, me4000_ao_isr,
-					IRQF_DISABLED | IRQF_SHARED,
+					 IRQF_SHARED,
 					ME4000_NAME, ao_context);
 			if (err) {
 				printk(KERN_ERR
@@ -1550,7 +1550,7 @@ static int me4000_open(struct inode *ino
 		/* Request the interrupt line */
 		err =
 		    request_irq(ext_int_context->irq, me4000_ext_int_isr,
-				IRQF_DISABLED | IRQF_SHARED, ME4000_NAME,
+				 IRQF_SHARED, ME4000_NAME,
 				ext_int_context);
 		if (err) {
 			printk(KERN_ERR
@@ -3012,7 +3012,7 @@ static int me4000_ai_prepare(struct me40
 		/* Request the interrupt line */
 		err =
 		    request_irq(ai_context->irq, me4000_ai_isr,
-				IRQF_DISABLED | IRQF_SHARED, ME4000_NAME,
+				 IRQF_SHARED, ME4000_NAME,
 				ai_context);
 		if (err) {
 			printk(KERN_ERR
Index: linux-2.6/drivers/staging/meilhaus/me0600_ext_irq.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me0600_ext_irq.c
+++ linux-2.6/drivers/staging/meilhaus/me0600_ext_irq.c
@@ -438,11 +438,7 @@ me0600_ext_irq_subdevice_t *me0600_ext_i
 	subdevice->irq = irq;
 
 	err = request_irq(subdevice->irq, me0600_isr,
-#ifdef IRQF_DISABLED
-			  IRQF_DISABLED | IRQF_SHARED,
-#else
-			  SA_INTERRUPT | SA_SHIRQ,
-#endif
+			   IRQF_SHARED,
 			  ME0600_NAME, (void *)subdevice);
 
 	if (err) {
Index: linux-2.6/drivers/staging/meilhaus/me1400_ext_irq.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me1400_ext_irq.c
+++ linux-2.6/drivers/staging/meilhaus/me1400_ext_irq.c
@@ -463,11 +463,7 @@ me1400_ext_irq_subdevice_t *me1400_ext_i
 	subdevice->irq = irq;
 
 	err = request_irq(irq, me1400_ext_irq_isr,
-#ifdef IRQF_DISABLED
-			  IRQF_DISABLED | IRQF_SHARED,
-#else
-			  SA_INTERRUPT | SA_SHIRQ,
-#endif
+			   IRQF_SHARED,
 			  ME1400_NAME, (void *)subdevice);
 
 	if (err) {
Index: linux-2.6/drivers/staging/meilhaus/me4600_ai.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me4600_ai.c
+++ linux-2.6/drivers/staging/meilhaus/me4600_ai.c
@@ -307,11 +307,7 @@ me4600_ai_subdevice_t *me4600_ai_constru
 	// Register interrupt service routine.
 	subdevice->irq = irq;
 	if (request_irq(subdevice->irq, me4600_ai_isr,
-#ifdef IRQF_DISABLED
-			IRQF_DISABLED | IRQF_SHARED,
-#else
-			SA_INTERRUPT | SA_SHIRQ,
-#endif
+			 IRQF_SHARED,
 			ME4600_NAME, subdevice)) {
 		PERROR("Cannot register interrupt service routine.\n");
 		me_subdevice_deinit((me_subdevice_t *) subdevice);
Index: linux-2.6/drivers/staging/meilhaus/me4600_ao.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me4600_ao.c
+++ linux-2.6/drivers/staging/meilhaus/me4600_ao.c
@@ -2581,11 +2581,7 @@ me4600_ao_subdevice_t *me4600_ao_constru
 	if (subdevice->fifo) {
 		subdevice->irq = irq;
 		if (request_irq(subdevice->irq, me4600_ao_isr,
-#ifdef IRQF_DISABLED
-				IRQF_DISABLED | IRQF_SHARED,
-#else
-				SA_INTERRUPT | SA_SHIRQ,
-#endif
+				 IRQF_SHARED,
 				ME4600_NAME, subdevice)) {
 			PERROR("Cannot get interrupt line.\n");
 			PDEBUG("free circ_buf = %p size=%d",
Index: linux-2.6/drivers/staging/meilhaus/me4600_ext_irq.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me4600_ext_irq.c
+++ linux-2.6/drivers/staging/meilhaus/me4600_ext_irq.c
@@ -425,11 +425,7 @@ me4600_ext_irq_subdevice_t *me4600_ext_i
 	subdevice->irq = irq;
 
 	if (request_irq(subdevice->irq, me4600_ext_irq_isr,
-#ifdef IRQF_DISABLED
-			IRQF_DISABLED | IRQF_SHARED,
-#else
-			SA_INTERRUPT | SA_SHIRQ,
-#endif
+			 IRQF_SHARED,
 			ME4600_NAME, subdevice)) {
 		PERROR("Cannot register interrupt.\n");
 		kfree(subdevice);
Index: linux-2.6/drivers/staging/meilhaus/me6000_ao.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me6000_ao.c
+++ linux-2.6/drivers/staging/meilhaus/me6000_ao.c
@@ -2639,11 +2639,7 @@ me6000_ao_subdevice_t *me6000_ao_constru
 	if (subdevice->fifo & ME6000_AO_HAS_FIFO) {
 		subdevice->irq = irq;
 		if (request_irq(subdevice->irq, me6000_ao_isr,
-#ifdef IRQF_DISABLED
-				IRQF_DISABLED | IRQF_SHARED,
-#else
-				SA_INTERRUPT | SA_SHIRQ,
-#endif
+				 IRQF_SHARED,
 				ME6000_NAME, subdevice)) {
 			PERROR("Cannot get interrupt line.\n");
 			PDEBUG("free circ_buf = %p size=%d",
Index: linux-2.6/drivers/staging/meilhaus/me8100_di.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me8100_di.c
+++ linux-2.6/drivers/staging/meilhaus/me8100_di.c
@@ -637,11 +637,7 @@ me8100_di_subdevice_t *me8100_di_constru
 	/* Register interrupt service routine. */
 	subdevice->irq = irq;
 	err = request_irq(subdevice->irq, me8100_isr,
-#ifdef IRQF_DISABLED
-			  IRQF_DISABLED | IRQF_SHARED,
-#else
-			  SA_INTERRUPT | SA_SHIRQ,
-#endif
+			   IRQF_SHARED,
 			  ME8100_NAME, (void *)subdevice);
 
 	if (err) {
Index: linux-2.6/drivers/staging/meilhaus/me8200_di.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me8200_di.c
+++ linux-2.6/drivers/staging/meilhaus/me8200_di.c
@@ -817,19 +817,11 @@ me8200_di_subdevice_t *me8200_di_constru
 	subdevice->irq = irq;
 	if (subdevice->version > 0) {	// NEW
 		err = request_irq(subdevice->irq, me8200_isr_EX,
-#ifdef IRQF_DISABLED
-				  IRQF_DISABLED | IRQF_SHARED,
-#else
-				  SA_INTERRUPT | SA_SHIRQ,
-#endif
+				   IRQF_SHARED,
 				  ME8200_NAME, (void *)subdevice);
 	} else {		//OLD
 		err = request_irq(subdevice->irq, me8200_isr,
-#ifdef IRQF_DISABLED
-				  IRQF_DISABLED | IRQF_SHARED,
-#else
-				  SA_INTERRUPT | SA_SHIRQ,
-#endif
+				   IRQF_SHARED,
 				  ME8200_NAME, (void *)subdevice);
 	}
 
Index: linux-2.6/drivers/staging/meilhaus/me8200_do.c
===================================================================
--- linux-2.6.orig/drivers/staging/meilhaus/me8200_do.c
+++ linux-2.6/drivers/staging/meilhaus/me8200_do.c
@@ -560,11 +560,7 @@ me8200_do_subdevice_t *me8200_do_constru
 
 	/* Request the interrupt line */
 	err = request_irq(irq, me8200_do_isr,
-#ifdef IRQF_DISABLED
-			  IRQF_DISABLED | IRQF_SHARED,
-#else
-			  SA_INTERRUPT | SA_SHIRQ,
-#endif
+			   IRQF_SHARED,
 			  ME8200_NAME, (void *)subdevice);
 
 	if (err) {
Index: linux-2.6/drivers/uio/uio_cif.c
===================================================================
--- linux-2.6.orig/drivers/uio/uio_cif.c
+++ linux-2.6/drivers/uio/uio_cif.c
@@ -78,7 +78,7 @@ static int __devinit hilscher_pci_probe(
 	}
 	info->version = "0.0.1";
 	info->irq = dev->irq;
-	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->irq_flags =  IRQF_SHARED;
 	info->handler = hilscher_handler;
 
 	if (uio_register_device(&dev->dev, info))
Index: linux-2.6/drivers/uio/uio_pdrv_genirq.c
===================================================================
--- linux-2.6.orig/drivers/uio/uio_pdrv_genirq.c
+++ linux-2.6/drivers/uio/uio_pdrv_genirq.c
@@ -133,7 +133,6 @@ static int uio_pdrv_genirq_probe(struct 
 	 * Interrupt sharing is not supported.
 	 */
 
-	uioinfo->irq_flags |= IRQF_DISABLED;
 	uioinfo->handler = uio_pdrv_genirq_handler;
 	uioinfo->irqcontrol = uio_pdrv_genirq_irqcontrol;
 	uioinfo->priv = priv;
Index: linux-2.6/drivers/uio/uio_sercos3.c
===================================================================
--- linux-2.6.orig/drivers/uio/uio_sercos3.c
+++ linux-2.6/drivers/uio/uio_sercos3.c
@@ -153,7 +153,7 @@ static int __devinit sercos3_pci_probe(s
 	info->name = "Sercos_III_PCI";
 	info->version = "0.0.1";
 	info->irq = dev->irq;
-	info->irq_flags = IRQF_DISABLED | IRQF_SHARED;
+	info->irq_flags =  IRQF_SHARED;
 	info->handler = sercos3_handler;
 	info->irqcontrol = sercos3_irqcontrol;
 
Index: linux-2.6/drivers/usb/core/hcd-pci.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd-pci.c
+++ linux-2.6/drivers/usb/core/hcd-pci.c
@@ -129,7 +129,7 @@ int usb_hcd_pci_probe(struct pci_dev *de
 
 	pci_set_master(dev);
 
-	retval = usb_add_hcd(hcd, dev->irq, IRQF_DISABLED | IRQF_SHARED);
+	retval = usb_add_hcd(hcd, dev->irq,  IRQF_SHARED);
 	if (retval != 0)
 		goto err4;
 	return retval;
Index: linux-2.6/drivers/usb/core/hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd.c
+++ linux-2.6/drivers/usb/core/hcd.c
@@ -1904,13 +1904,6 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	/* enable irqs just before we start the controller */
 	if (hcd->driver->irq) {
 
-		/* IRQF_DISABLED doesn't work as advertised when used together
-		 * with IRQF_SHARED. As usb_hcd_irq() will always disable
-		 * interrupts we can remove it here.
-		 */
-		if (irqflags & IRQF_SHARED)
-			irqflags &= ~IRQF_DISABLED;
-
 		snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
 				hcd->driver->description, hcd->self.busnum);
 		if ((retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
Index: linux-2.6/drivers/usb/gadget/at91_udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/at91_udc.c
+++ linux-2.6/drivers/usb/gadget/at91_udc.c
@@ -1732,7 +1732,7 @@ static int __init at91udc_probe(struct p
 	/* request UDC and maybe VBUS irqs */
 	udc->udp_irq = platform_get_irq(pdev, 0);
 	retval = request_irq(udc->udp_irq, at91_udc_irq,
-			IRQF_DISABLED, driver_name, udc);
+			0, driver_name, udc);
 	if (retval < 0) {
 		DBG("request irq %d failed\n", udc->udp_irq);
 		goto fail1;
@@ -1751,7 +1751,7 @@ static int __init at91udc_probe(struct p
 		 */
 		udc->vbus = gpio_get_value(udc->board.vbus_pin);
 		if (request_irq(udc->board.vbus_pin, at91_vbus_irq,
-				IRQF_DISABLED, driver_name, udc)) {
+				0, driver_name, udc)) {
 			DBG("request vbus irq %d failed\n",
 					udc->board.vbus_pin);
 			free_irq(udc->udp_irq, udc);
Index: linux-2.6/drivers/usb/gadget/imx_udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/imx_udc.c
+++ linux-2.6/drivers/usb/gadget/imx_udc.c
@@ -1410,7 +1410,7 @@ static int __init imx_udc_probe(struct p
 
 	for (i = 0; i < IMX_USB_NB_EP + 1; i++) {
 		ret = request_irq(imx_usb->usbd_int[i], intr_handler(i),
-				     IRQF_DISABLED, driver_name, imx_usb);
+				     0, driver_name, imx_usb);
 		if (ret) {
 			dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 				imx_usb->usbd_int[i], ret);
Index: linux-2.6/drivers/usb/gadget/lh7a40x_udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/lh7a40x_udc.c
+++ linux-2.6/drivers/usb/gadget/lh7a40x_udc.c
@@ -2081,7 +2081,7 @@ static int lh7a40x_udc_probe(struct plat
 
 	/* irq setup after old hardware state is cleaned up */
 	retval =
-	    request_irq(IRQ_USBINTR, lh7a40x_udc_irq, IRQF_DISABLED, driver_name,
+	    request_irq(IRQ_USBINTR, lh7a40x_udc_irq, 0, driver_name,
 			dev);
 	if (retval != 0) {
 		DEBUG(KERN_ERR "%s: can't get irq %i, err %d\n", driver_name,
Index: linux-2.6/drivers/usb/gadget/m66592-udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/m66592-udc.c
+++ linux-2.6/drivers/usb/gadget/m66592-udc.c
@@ -1605,7 +1605,7 @@ static int __init m66592_probe(struct pl
 
 	m66592->bi_bufnum = M66592_BASE_BUFNUM;
 
-	ret = request_irq(irq, m66592_irq, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(irq, m66592_irq,  IRQF_SHARED,
 			udc_name, m66592);
 	if (ret < 0) {
 		pr_err("request_irq error (%d)\n", ret);
Index: linux-2.6/drivers/usb/gadget/omap_udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/omap_udc.c
+++ linux-2.6/drivers/usb/gadget/omap_udc.c
@@ -2963,7 +2963,7 @@ known:
 	}
 #ifdef	USE_ISO
 	status = request_irq(pdev->resource[3].start, omap_udc_iso_irq,
-			IRQF_DISABLED, "omap_udc iso", udc);
+			0, "omap_udc iso", udc);
 	if (status != 0) {
 		ERR("can't get irq %d, err %d\n",
 			(int) pdev->resource[3].start, status);
Index: linux-2.6/drivers/usb/gadget/pxa25x_udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/pxa25x_udc.c
+++ linux-2.6/drivers/usb/gadget/pxa25x_udc.c
@@ -2202,7 +2202,7 @@ static int __init pxa25x_udc_probe(struc
 
 	/* irq setup after old hardware state is cleaned up */
 	retval = request_irq(irq, pxa25x_udc_irq,
-			IRQF_DISABLED, driver_name, dev);
+			0, driver_name, dev);
 	if (retval != 0) {
 		pr_err("%s: can't get irq %d, err %d\n",
 			driver_name, irq, retval);
@@ -2214,7 +2214,7 @@ static int __init pxa25x_udc_probe(struc
 	if (machine_is_lubbock()) {
 		retval = request_irq(LUBBOCK_USB_DISC_IRQ,
 				lubbock_vbus_irq,
-				IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
+				 IRQF_SAMPLE_RANDOM,
 				driver_name, dev);
 		if (retval != 0) {
 			pr_err("%s: can't get irq %i, err %d\n",
@@ -2224,7 +2224,7 @@ lubbock_fail0:
 		}
 		retval = request_irq(LUBBOCK_USB_IRQ,
 				lubbock_vbus_irq,
-				IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
+				 IRQF_SAMPLE_RANDOM,
 				driver_name, dev);
 		if (retval != 0) {
 			pr_err("%s: can't get irq %i, err %d\n",
@@ -2236,7 +2236,7 @@ lubbock_fail0:
 #endif
 	if (vbus_irq) {
 		retval = request_irq(vbus_irq, udc_vbus_irq,
-				IRQF_DISABLED | IRQF_SAMPLE_RANDOM |
+				 IRQF_SAMPLE_RANDOM |
 				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 				driver_name, dev);
 		if (retval != 0) {
Index: linux-2.6/drivers/usb/gadget/s3c2410_udc.c
===================================================================
--- linux-2.6.orig/drivers/usb/gadget/s3c2410_udc.c
+++ linux-2.6/drivers/usb/gadget/s3c2410_udc.c
@@ -1857,7 +1857,7 @@ static int s3c2410_udc_probe(struct plat
 
 	/* irq setup after old hardware state is cleaned up */
 	retval = request_irq(IRQ_USBD, s3c2410_udc_irq,
-			     IRQF_DISABLED, gadget_name, udc);
+			     0, gadget_name, udc);
 
 	if (retval != 0) {
 		dev_err(dev, "cannot get irq %i, err %d\n", IRQ_USBD, retval);
@@ -1881,7 +1881,7 @@ static int s3c2410_udc_probe(struct plat
 		}
 
 		retval = request_irq(irq, s3c2410_udc_vbus_irq,
-				     IRQF_DISABLED | IRQF_TRIGGER_RISING
+				      IRQF_TRIGGER_RISING
 				     | IRQF_TRIGGER_FALLING | IRQF_SHARED,
 				     gadget_name, udc);
 
Index: linux-2.6/drivers/usb/host/ehci-au1xxx.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci-au1xxx.c
+++ linux-2.6/drivers/usb/host/ehci-au1xxx.c
@@ -166,7 +166,7 @@ static int ehci_hcd_au1xxx_drv_probe(str
 	ehci->hcs_params = readl(&ehci->caps->hcs_params);
 
 	ret = usb_add_hcd(hcd, pdev->resource[1].start,
-			  IRQF_DISABLED | IRQF_SHARED);
+			   IRQF_SHARED);
 	if (ret == 0) {
 		platform_set_drvdata(pdev, hcd);
 		return ret;
Index: linux-2.6/drivers/usb/host/ehci-fsl.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci-fsl.c
+++ linux-2.6/drivers/usb/host/ehci-fsl.c
@@ -120,7 +120,7 @@ int usb_hcd_fsl_probe(const struct hc_dr
 	temp = in_le32(hcd->regs + 0x1a8);
 	out_le32(hcd->regs + 0x1a8, temp | 0x3);
 
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
+	retval = usb_add_hcd(hcd, irq,  IRQF_SHARED);
 	if (retval != 0)
 		goto err4;
 	return retval;
Index: linux-2.6/drivers/usb/host/ehci-orion.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci-orion.c
+++ linux-2.6/drivers/usb/host/ehci-orion.c
@@ -273,7 +273,7 @@ static int __init ehci_orion_drv_probe(s
 		printk(KERN_WARNING "Orion ehci -USB phy version isn't supported.\n");
 	}
 
-	err = usb_add_hcd(hcd, irq, IRQF_SHARED | IRQF_DISABLED);
+	err = usb_add_hcd(hcd, irq, IRQF_SHARED );
 	if (err)
 		goto err4;
 
Index: linux-2.6/drivers/usb/host/ehci-ps3.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ehci-ps3.c
+++ linux-2.6/drivers/usb/host/ehci-ps3.c
@@ -164,7 +164,7 @@ static int ps3_ehci_probe(struct ps3_sys
 
 	ps3_system_bus_set_driver_data(dev, hcd);
 
-	result = usb_add_hcd(hcd, virq, IRQF_DISABLED);
+	result = usb_add_hcd(hcd, virq, 0);
 
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: usb_add_hcd failed (%d)\n",
Index: linux-2.6/drivers/usb/host/fhci-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/fhci-hcd.c
+++ linux-2.6/drivers/usb/host/fhci-hcd.c
@@ -685,7 +685,7 @@ static int __devinit of_fhci_probe(struc
 	}
 
 	ret = request_irq(fhci->timer->irq, fhci_frame_limit_timer_irq,
-			  IRQF_DISABLED, "qe timer (usb)", hcd);
+			  0, "qe timer (usb)", hcd);
 	if (ret) {
 		dev_err(dev, "failed to request timer irq");
 		goto err_timer_irq;
@@ -744,7 +744,7 @@ static int __devinit of_fhci_probe(struc
 	out_be16(&fhci->regs->usb_event, 0xffff);
 	out_be16(&fhci->regs->usb_mask, 0);
 
-	ret = usb_add_hcd(hcd, usb_irq, IRQF_DISABLED);
+	ret = usb_add_hcd(hcd, usb_irq, 0);
 	if (ret < 0)
 		goto err_add_hcd;
 
Index: linux-2.6/drivers/usb/host/isp116x-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/isp116x-hcd.c
+++ linux-2.6/drivers/usb/host/isp116x-hcd.c
@@ -1639,7 +1639,7 @@ static int __devinit isp116x_probe(struc
 		goto err6;
 	}
 
-	ret = usb_add_hcd(hcd, irq, irqflags | IRQF_DISABLED);
+	ret = usb_add_hcd(hcd, irq, irqflags );
 	if (ret)
 		goto err6;
 
Index: linux-2.6/drivers/usb/host/isp1760-if.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/isp1760-if.c
+++ linux-2.6/drivers/usb/host/isp1760-if.c
@@ -78,7 +78,7 @@ static int of_isp1760_probe(struct of_de
 		devflags |= ISP1760_FLAG_DREQ_POL_HIGH;
 
 	hcd = isp1760_register(memory.start, res_len, virq,
-		IRQF_SHARED | IRQF_DISABLED, &dev->dev, dev_name(&dev->dev),
+		IRQF_SHARED , &dev->dev, dev_name(&dev->dev),
 		devflags);
 	if (IS_ERR(hcd)) {
 		ret = PTR_ERR(hcd);
@@ -236,7 +236,7 @@ static int __devinit isp1761_pci_probe(s
 
 	dev->dev.dma_mask = NULL;
 	hcd = isp1760_register(pci_mem_phy0, memlength, dev->irq,
-		IRQF_SHARED | IRQF_DISABLED, &dev->dev, dev_name(&dev->dev),
+		IRQF_SHARED , &dev->dev, dev_name(&dev->dev),
 		devflags);
 	if (IS_ERR(hcd)) {
 		ret_status = -ENODEV;
Index: linux-2.6/drivers/usb/host/ohci-at91.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-at91.c
+++ linux-2.6/drivers/usb/host/ohci-at91.c
@@ -148,7 +148,7 @@ static int usb_hcd_at91_probe(const stru
 	at91_start_hc(pdev);
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, pdev->resource[1].start, 0);
 	if (retval == 0)
 		return retval;
 
Index: linux-2.6/drivers/usb/host/ohci-au1xxx.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-au1xxx.c
+++ linux-2.6/drivers/usb/host/ohci-au1xxx.c
@@ -218,7 +218,7 @@ static int ohci_hcd_au1xxx_drv_probe(str
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
 	ret = usb_add_hcd(hcd, pdev->resource[1].start,
-			  IRQF_DISABLED | IRQF_SHARED);
+			   IRQF_SHARED);
 	if (ret == 0) {
 		platform_set_drvdata(pdev, hcd);
 		return ret;
Index: linux-2.6/drivers/usb/host/ohci-ep93xx.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-ep93xx.c
+++ linux-2.6/drivers/usb/host/ohci-ep93xx.c
@@ -77,7 +77,7 @@ static int usb_hcd_ep93xx_probe(const st
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, pdev->resource[1].start, 0);
 	if (retval == 0)
 		return retval;
 
Index: linux-2.6/drivers/usb/host/ohci-lh7a404.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-lh7a404.c
+++ linux-2.6/drivers/usb/host/ohci-lh7a404.c
@@ -100,7 +100,7 @@ int usb_hcd_lh7a404_probe (const struct 
 	lh7a404_start_hc(dev);
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, dev->resource[1].start, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, dev->resource[1].start, 0);
 	if (retval == 0)
 		return retval;
 
Index: linux-2.6/drivers/usb/host/ohci-omap.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-omap.c
+++ linux-2.6/drivers/usb/host/ohci-omap.c
@@ -362,7 +362,7 @@ static int usb_hcd_omap_probe (const str
 		retval = -ENXIO;
 		goto err3;
 	}
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, irq, 0);
 	if (retval)
 		goto err3;
 
Index: linux-2.6/drivers/usb/host/ohci-pnx4008.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-pnx4008.c
+++ linux-2.6/drivers/usb/host/ohci-pnx4008.c
@@ -398,7 +398,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	ohci_hcd_init(ohci);
 
 	dev_info(&pdev->dev, "at 0x%p, irq %d\n", hcd->regs, hcd->irq);
-	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	ret = usb_add_hcd(hcd, irq, 0);
 	if (ret == 0)
 		return ret;
 
Index: linux-2.6/drivers/usb/host/ohci-pnx8550.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-pnx8550.c
+++ linux-2.6/drivers/usb/host/ohci-pnx8550.c
@@ -107,7 +107,7 @@ int usb_hcd_pnx8550_probe (const struct 
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, dev->resource[1].start, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, dev->resource[1].start, 0);
 	if (retval == 0)
 		return retval;
 
Index: linux-2.6/drivers/usb/host/ohci-ppc-of.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-ppc-of.c
+++ linux-2.6/drivers/usb/host/ohci-ppc-of.c
@@ -144,7 +144,7 @@ ohci_hcd_ppc_of_probe(struct of_device *
 
 	ohci_hcd_init(ohci);
 
-	rv = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	rv = usb_add_hcd(hcd, irq, 0);
 	if (rv == 0)
 		return 0;
 
Index: linux-2.6/drivers/usb/host/ohci-ppc-soc.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-ppc-soc.c
+++ linux-2.6/drivers/usb/host/ohci-ppc-soc.c
@@ -80,7 +80,7 @@ static int usb_hcd_ppc_soc_probe(const s
 #endif
 	ohci_hcd_init(ohci);
 
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, irq, 0);
 	if (retval == 0)
 		return retval;
 
Index: linux-2.6/drivers/usb/host/ohci-ps3.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-ps3.c
+++ linux-2.6/drivers/usb/host/ohci-ps3.c
@@ -164,7 +164,7 @@ static int ps3_ohci_probe(struct ps3_sys
 
 	ps3_system_bus_set_driver_data(dev, hcd);
 
-	result = usb_add_hcd(hcd, virq, IRQF_DISABLED);
+	result = usb_add_hcd(hcd, virq, 0);
 
 	if (result) {
 		dev_dbg(&dev->core, "%s:%d: usb_add_hcd failed (%d)\n",
Index: linux-2.6/drivers/usb/host/ohci-pxa27x.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-pxa27x.c
+++ linux-2.6/drivers/usb/host/ohci-pxa27x.c
@@ -346,7 +346,7 @@ int usb_hcd_pxa27x_probe (const struct h
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, irq, 0);
 	if (retval == 0)
 		return retval;
 
Index: linux-2.6/drivers/usb/host/ohci-s3c2410.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-s3c2410.c
+++ linux-2.6/drivers/usb/host/ohci-s3c2410.c
@@ -388,7 +388,7 @@ static int usb_hcd_s3c2410_probe (const 
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, dev->resource[1].start, IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, dev->resource[1].start, 0);
 	if (retval != 0)
 		goto err_ioremap;
 
Index: linux-2.6/drivers/usb/host/ohci-sa1111.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-sa1111.c
+++ linux-2.6/drivers/usb/host/ohci-sa1111.c
@@ -143,7 +143,7 @@ int usb_hcd_sa1111_probe (const struct h
 	sa1111_start_hc(dev);
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, dev->irq[1], IRQF_DISABLED);
+	retval = usb_add_hcd(hcd, dev->irq[1], 0);
 	if (retval == 0)
 		return retval;
 
Index: linux-2.6/drivers/usb/host/ohci-sh.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-sh.c
+++ linux-2.6/drivers/usb/host/ohci-sh.c
@@ -110,7 +110,7 @@ static int ohci_hcd_sh_probe(struct plat
 	hcd->regs = (void __iomem *)res->start;
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_len(res);
-	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	ret = usb_add_hcd(hcd, irq, 0);
 	if (ret != 0) {
 		err("Failed to add hcd");
 		usb_put_hcd(hcd);
Index: linux-2.6/drivers/usb/host/ohci-sm501.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-sm501.c
+++ linux-2.6/drivers/usb/host/ohci-sm501.c
@@ -166,7 +166,7 @@ static int ohci_hcd_sm501_drv_probe(stru
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | IRQF_SHARED);
+	retval = usb_add_hcd(hcd, irq,  IRQF_SHARED);
 	if (retval)
 		goto err4;
 
Index: linux-2.6/drivers/usb/host/ohci-ssb.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-ssb.c
+++ linux-2.6/drivers/usb/host/ohci-ssb.c
@@ -124,7 +124,7 @@ static int ssb_ohci_attach(struct ssb_de
 	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs)
 		goto err_put_hcd;
-	err = usb_add_hcd(hcd, dev->irq, IRQF_DISABLED | IRQF_SHARED);
+	err = usb_add_hcd(hcd, dev->irq,  IRQF_SHARED);
 	if (err)
 		goto err_iounmap;
 
Index: linux-2.6/drivers/usb/host/ohci-tmio.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/ohci-tmio.c
+++ linux-2.6/drivers/usb/host/ohci-tmio.c
@@ -244,7 +244,7 @@ static int __devinit ohci_hcd_tmio_drv_p
 	ohci = hcd_to_ohci(hcd);
 	ohci_hcd_init(ohci);
 
-	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED);
+	ret = usb_add_hcd(hcd, irq, 0);
 	if (ret)
 		goto err_add_hcd;
 
Index: linux-2.6/drivers/usb/host/r8a66597-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/r8a66597-hcd.c
+++ linux-2.6/drivers/usb/host/r8a66597-hcd.c
@@ -2383,7 +2383,7 @@ static int __init r8a66597_probe(struct 
 			dev_err(&pdev->dev, "Unknown irq_sense value.\n");
 	}
 
-	ret = usb_add_hcd(hcd, irq, IRQF_DISABLED | irq_trigger);
+	ret = usb_add_hcd(hcd, irq,  irq_trigger);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to add hcd\n");
 		goto clean_up3;
Index: linux-2.6/drivers/usb/host/sl811-hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/sl811-hcd.c
+++ linux-2.6/drivers/usb/host/sl811-hcd.c
@@ -1725,7 +1725,7 @@ sl811h_probe(struct platform_device *dev
 	 * Use resource IRQ flags if set by platform device setup.
 	 */
 	irqflags |= IRQF_SHARED;
-	retval = usb_add_hcd(hcd, irq, IRQF_DISABLED | irqflags);
+	retval = usb_add_hcd(hcd, irq,  irqflags);
 	if (retval != 0)
 		goto err6;
 
Index: linux-2.6/drivers/usb/musb/musbhsdma.c
===================================================================
--- linux-2.6.orig/drivers/usb/musb/musbhsdma.c
+++ linux-2.6/drivers/usb/musb/musbhsdma.c
@@ -367,7 +367,7 @@ dma_controller_create(struct musb *musb,
 	controller->controller.channel_program = dma_channel_program;
 	controller->controller.channel_abort = dma_channel_abort;
 
-	if (request_irq(irq, dma_controller_irq, IRQF_DISABLED,
+	if (request_irq(irq, dma_controller_irq, 0,
 			dev_name(musb->controller), &controller->controller)) {
 		dev_err(dev, "request_irq %d failed!\n", irq);
 		dma_controller_destroy(&controller->controller);
Index: linux-2.6/drivers/usb/otg/isp1301_omap.c
===================================================================
--- linux-2.6.orig/drivers/usb/otg/isp1301_omap.c
+++ linux-2.6/drivers/usb/otg/isp1301_omap.c
@@ -936,7 +936,7 @@ static int otg_bind(struct isp1301 *isp)
 
 	if (otg_dev)
 		status = request_irq(otg_dev->resource[1].start, omap_otg_irq,
-				IRQF_DISABLED, DRIVER_NAME, isp);
+				0, DRIVER_NAME, isp);
 	else
 		status = -ENODEV;
 
Index: linux-2.6/drivers/video/au1200fb.c
===================================================================
--- linux-2.6.orig/drivers/video/au1200fb.c
+++ linux-2.6/drivers/video/au1200fb.c
@@ -1693,7 +1693,7 @@ static int au1200fb_drv_probe(struct dev
 
 	/* Now hook interrupt too */
 	if ((ret = request_irq(AU1200_LCD_INT, au1200fb_handle_irq,
-		 	  IRQF_DISABLED | IRQF_SHARED, "lcd", (void *)dev)) < 0) {
+		 	   IRQF_SHARED, "lcd", (void *)dev)) < 0) {
 		print_err("fail to request interrupt line %d (err: %d)",
 			  AU1200_LCD_INT, ret);
 		goto failed;
Index: linux-2.6/drivers/video/bf54x-lq043fb.c
===================================================================
--- linux-2.6.orig/drivers/video/bf54x-lq043fb.c
+++ linux-2.6/drivers/video/bf54x-lq043fb.c
@@ -665,7 +665,7 @@ static int __init bfin_bf54x_probe(struc
 		goto out7;
 	}
 
-	if (request_irq(info->irq, bfin_bf54x_irq_error, IRQF_DISABLED,
+	if (request_irq(info->irq, bfin_bf54x_irq_error, 0,
 			"PPI ERROR", info) < 0) {
 		printk(KERN_ERR DRIVER_NAME
 		       ": unable to request PPI ERROR IRQ\n");
Index: linux-2.6/drivers/video/bfin-t350mcqb-fb.c
===================================================================
--- linux-2.6.orig/drivers/video/bfin-t350mcqb-fb.c
+++ linux-2.6/drivers/video/bfin-t350mcqb-fb.c
@@ -557,7 +557,7 @@ static int __devinit bfin_t350mcqb_probe
 		goto out7;
 	}
 
-	ret = request_irq(info->irq, bfin_t350mcqb_irq_error, IRQF_DISABLED,
+	ret = request_irq(info->irq, bfin_t350mcqb_irq_error, 0,
 			"PPI ERROR", info);
 	if (ret < 0) {
 		printk(KERN_ERR DRIVER_NAME
Index: linux-2.6/drivers/video/mb862xx/mb862xxfb.c
===================================================================
--- linux-2.6.orig/drivers/video/mb862xx/mb862xxfb.c
+++ linux-2.6/drivers/video/mb862xx/mb862xxfb.c
@@ -626,7 +626,7 @@ static int __devinit of_platform_mb862xx
 	if (mb862xx_gdc_init(par))
 		goto io_unmap;
 
-	if (request_irq(par->irq, mb862xx_intr, IRQF_DISABLED,
+	if (request_irq(par->irq, mb862xx_intr, 0,
 			DRV_NAME, (void *)par)) {
 		dev_err(dev, "Cannot request irq\n");
 		goto io_unmap;
@@ -938,7 +938,7 @@ static int __devinit mb862xx_pci_probe(s
 	if (mb862xx_pci_gdc_init(par))
 		goto io_unmap;
 
-	if (request_irq(par->irq, mb862xx_intr, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(par->irq, mb862xx_intr,  IRQF_SHARED,
 			DRV_NAME, (void *)par)) {
 		dev_err(dev, "Cannot request irq\n");
 		goto io_unmap;
Index: linux-2.6/drivers/video/ps3fb.c
===================================================================
--- linux-2.6.orig/drivers/video/ps3fb.c
+++ linux-2.6/drivers/video/ps3fb.c
@@ -982,7 +982,7 @@ static int ps3fb_vsync_settings(struct g
 		return error;
 	}
 
-	error = request_irq(ps3fb.irq_no, ps3fb_vsync_interrupt, IRQF_DISABLED,
+	error = request_irq(ps3fb.irq_no, ps3fb_vsync_interrupt, 0,
 			    DEVICE_NAME, dev);
 	if (error) {
 		dev_err(dev, "%s: request_irq failed %d\n", __func__, error);
Index: linux-2.6/drivers/video/pxafb.c
===================================================================
--- linux-2.6.orig/drivers/video/pxafb.c
+++ linux-2.6/drivers/video/pxafb.c
@@ -2111,7 +2111,7 @@ static int __devinit pxafb_probe(struct 
 		goto failed_free_mem;
 	}
 
-	ret = request_irq(irq, pxafb_handle_irq, IRQF_DISABLED, "LCD", fbi);
+	ret = request_irq(irq, pxafb_handle_irq, 0, "LCD", fbi);
 	if (ret) {
 		dev_err(&dev->dev, "request_irq failed: %d\n", ret);
 		ret = -EBUSY;
Index: linux-2.6/drivers/video/s3c2410fb.c
===================================================================
--- linux-2.6.orig/drivers/video/s3c2410fb.c
+++ linux-2.6/drivers/video/s3c2410fb.c
@@ -856,7 +856,7 @@ static int __init s3c24xxfb_probe(struct
 	for (i = 0; i < 256; i++)
 		info->palette_buffer[i] = PALETTE_BUFF_CLEAR;
 
-	ret = request_irq(irq, s3c2410fb_irq, IRQF_DISABLED, pdev->name, info);
+	ret = request_irq(irq, s3c2410fb_irq, 0, pdev->name, info);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot get irq %d - err %d\n", irq, ret);
 		ret = -EBUSY;
Index: linux-2.6/drivers/video/sa1100fb.c
===================================================================
--- linux-2.6.orig/drivers/video/sa1100fb.c
+++ linux-2.6/drivers/video/sa1100fb.c
@@ -1473,7 +1473,7 @@ static int __init sa1100fb_probe(struct 
 	if (ret)
 		goto failed;
 
-	ret = request_irq(irq, sa1100fb_handle_irq, IRQF_DISABLED,
+	ret = request_irq(irq, sa1100fb_handle_irq, 0,
 			  "LCD", fbi);
 	if (ret) {
 		printk(KERN_ERR "sa1100fb: request_irq failed: %d\n", ret);
Index: linux-2.6/drivers/video/sh_mobile_lcdcfb.c
===================================================================
--- linux-2.6.orig/drivers/video/sh_mobile_lcdcfb.c
+++ linux-2.6/drivers/video/sh_mobile_lcdcfb.c
@@ -688,7 +688,7 @@ static int __init sh_mobile_lcdc_probe(s
 		goto err0;
 	}
 
-	error = request_irq(i, sh_mobile_lcdc_irq, IRQF_DISABLED,
+	error = request_irq(i, sh_mobile_lcdc_irq, 0,
 			    pdev->dev.bus_id, priv);
 	if (error) {
 		dev_err(&pdev->dev, "unable to request irq\n");
Index: linux-2.6/drivers/video/tmiofb.c
===================================================================
--- linux-2.6.orig/drivers/video/tmiofb.c
+++ linux-2.6/drivers/video/tmiofb.c
@@ -750,7 +750,7 @@ static int __devinit tmiofb_probe(struct
 		goto err_ioremap_vram;
 	}
 
-	retval = request_irq(irq, &tmiofb_irq, IRQF_DISABLED,
+	retval = request_irq(irq, &tmiofb_irq, 0,
 					dev->dev.bus_id, info);
 
 	if (retval)
Index: linux-2.6/drivers/w1/masters/ds1wm.c
===================================================================
--- linux-2.6.orig/drivers/w1/masters/ds1wm.c
+++ linux-2.6/drivers/w1/masters/ds1wm.c
@@ -371,7 +371,7 @@ static int ds1wm_probe(struct platform_d
 	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
 		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
 
-	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
+	ret = request_irq(ds1wm_data->irq, ds1wm_isr, 0,
 			  "ds1wm", ds1wm_data);
 	if (ret)
 		goto err1;
Index: linux-2.6/drivers/w1/masters/omap_hdq.c
===================================================================
--- linux-2.6.orig/drivers/w1/masters/omap_hdq.c
+++ linux-2.6/drivers/w1/masters/omap_hdq.c
@@ -633,7 +633,7 @@ static int __init omap_hdq_probe(struct 
 		goto err_irq;
 	}
 
-	ret = request_irq(irq, hdq_isr, IRQF_DISABLED, "omap_hdq", hdq_data);
+	ret = request_irq(irq, hdq_isr, 0, "omap_hdq", hdq_data);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "could not request irq\n");
 		goto err_irq;
Index: linux-2.6/drivers/watchdog/eurotechwdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/eurotechwdt.c
+++ linux-2.6/drivers/watchdog/eurotechwdt.c
@@ -428,7 +428,7 @@ static int __init eurwdt_init(void)
 {
 	int ret;
 
-	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
+	ret = request_irq(irq, eurwdt_interrupt, 0, "eurwdt", NULL);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
Index: linux-2.6/drivers/watchdog/mpcore_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/mpcore_wdt.c
+++ linux-2.6/drivers/watchdog/mpcore_wdt.c
@@ -363,7 +363,7 @@ static int __devinit mpcore_wdt_probe(st
 		goto err_misc;
 	}
 
-	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED,
+	ret = request_irq(wdt->irq, mpcore_wdt_fire, 0,
 							"mpcore_wdt", wdt);
 	if (ret) {
 		dev_printk(KERN_ERR, _dev,
Index: linux-2.6/drivers/watchdog/rm9k_wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/rm9k_wdt.c
+++ linux-2.6/drivers/watchdog/rm9k_wdt.c
@@ -194,7 +194,7 @@ static int wdt_gpi_open(struct inode *in
 		locked = 0;
 	}
 
-	res = request_irq(wd_irq, wdt_gpi_irqhdl, IRQF_SHARED | IRQF_DISABLED,
+	res = request_irq(wd_irq, wdt_gpi_irqhdl, IRQF_SHARED ,
 			  wdt_gpi_name, &miscdev);
 	if (unlikely(res))
 		return res;
Index: linux-2.6/drivers/watchdog/sb_wdog.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/sb_wdog.c
+++ linux-2.6/drivers/watchdog/sb_wdog.c
@@ -299,7 +299,7 @@ static int __init sbwdog_init(void)
 	 * get the resources
 	 */
 
-	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt,  IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
@@ -343,7 +343,7 @@ void platform_wd_setup(void)
 {
 	int ret;
 
-	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt,  IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
 		printk(KERN_CRIT
Index: linux-2.6/drivers/watchdog/wdt.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wdt.c
+++ linux-2.6/drivers/watchdog/wdt.c
@@ -612,7 +612,7 @@ static int __init wdt_init(void)
 		goto out;
 	}
 
-	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED, "wdt501p", NULL);
+	ret = request_irq(irq, wdt_interrupt, 0, "wdt501p", NULL);
 	if (ret) {
 		printk(KERN_ERR "wdt: IRQ %d is not free.\n", irq);
 		goto outreg;
Index: linux-2.6/drivers/watchdog/wdt_pci.c
===================================================================
--- linux-2.6.orig/drivers/watchdog/wdt_pci.c
+++ linux-2.6/drivers/watchdog/wdt_pci.c
@@ -652,7 +652,7 @@ static int __devinit wdtpci_init_one(str
 		goto out_pci;
 	}
 
-	if (request_irq(irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(irq, wdtpci_interrupt,  IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
 		printk(KERN_ERR PFX "IRQ %d is not free\n", irq);
 		goto out_reg;
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -39,7 +39,6 @@
  * These flags used only by the kernel as part of the
  * irq handling routines.
  *
- * IRQF_DISABLED - keep irqs disabled when calling the action handler
  * IRQF_SAMPLE_RANDOM - irq is used to feed the random generator
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
@@ -50,7 +49,6 @@
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
  */
-#define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
Index: linux-2.6/include/net/irda/irda_device.h
===================================================================
--- linux-2.6.orig/include/net/irda/irda_device.h
+++ linux-2.6/include/net/irda/irda_device.h
@@ -162,7 +162,7 @@ typedef struct {
         int irq, irq2;        /* Interrupts used */
         int dma, dma2;        /* DMA channel(s) used */
         int fifo_size;        /* FIFO size */
-        int irqflags;         /* interrupt flags (ie, IRQF_SHARED|IRQF_DISABLED) */
+        int irqflags;         /* interrupt flags (ie, IRQF_SHARED) */
 	int direction;        /* Link direction, used by some FIR drivers */
 	int enabled;          /* Powered on? */
 	int suspended;        /* Suspended by APM */
Index: linux-2.6/include/sound/initval.h
===================================================================
--- linux-2.6.orig/include/sound/initval.h
+++ linux-2.6/include/sound/initval.h
@@ -62,7 +62,7 @@ static int snd_legacy_find_free_irq(int 
 {
 	while (*irq_table != -1) {
 		if (!request_irq(*irq_table, snd_legacy_empty_irq_handler,
-				 IRQF_DISABLED | IRQF_PROBE_SHARED, "ALSA Test IRQ",
+				  IRQF_PROBE_SHARED, "ALSA Test IRQ",
 				 (void *) irq_table)) {
 			free_irq(*irq_table, (void *) irq_table);
 			return *irq_table;
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -354,9 +354,6 @@ irqreturn_t handle_IRQ_event(unsigned in
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	if (!(action->flags & IRQF_DISABLED))
-		local_irq_enable_in_hardirq();
-
 	do {
 		trace_irq_handler_entry(irq, action);
 		ret = action->handler(irq, action->dev_id);
@@ -369,7 +366,6 @@ irqreturn_t handle_IRQ_event(unsigned in
 
 	if (status & IRQF_SAMPLE_RANDOM)
 		add_interrupt_randomness(irq);
-	local_irq_disable();
 
 	return retval;
 }
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -665,7 +665,6 @@ EXPORT_SYMBOL(free_irq);
  *	Flags:
  *
  *	IRQF_SHARED		Interrupt is shared
- *	IRQF_DISABLED	Disable local interrupts while processing
  *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
  *	IRQF_TRIGGER_*		Specify active edge(s) or level
  *
@@ -678,25 +677,6 @@ int request_irq(unsigned int irq, irq_ha
 	int retval;
 
 	/*
-	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
-	 * the _first_ irqaction (sigh).  That can cause oopsing, but
-	 * the behavior is classified as "will not fix" so we need to
-	 * start nudging drivers away from using that idiom.
-	 */
-	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED)) ==
-					(IRQF_SHARED|IRQF_DISABLED)) {
-		pr_warning(
-		  "IRQ %d/%s: IRQF_DISABLED is not guaranteed on shared IRQs\n",
-			irq, devname);
-	}
-
-#ifdef CONFIG_LOCKDEP
-	/*
-	 * Lockdep wants atomic interrupt handlers:
-	 */
-	irqflags |= IRQF_DISABLED;
-#endif
-	/*
 	 * Sanity-check: shared interrupts must pass in a real dev-ID,
 	 * otherwise we'll have trouble later trying to figure out
 	 * which interrupt is which (messes up the interrupt freeing
Index: linux-2.6/sound/arm/aaci.c
===================================================================
--- linux-2.6.orig/sound/arm/aaci.c
+++ linux-2.6/sound/arm/aaci.c
@@ -448,7 +448,7 @@ static int __aaci_pcm_open(struct aaci *
 	if (ret)
 		goto out;
 
-	ret = request_irq(aaci->dev->irq[0], aaci_irq, IRQF_SHARED|IRQF_DISABLED,
+	ret = request_irq(aaci->dev->irq[0], aaci_irq, IRQF_SHARED,
 			  DRIVER_NAME, aaci);
 	if (ret)
 		goto out;
Index: linux-2.6/sound/arm/pxa2xx-ac97-lib.c
===================================================================
--- linux-2.6.orig/sound/arm/pxa2xx-ac97-lib.c
+++ linux-2.6/sound/arm/pxa2xx-ac97-lib.c
@@ -350,7 +350,7 @@ int __devinit pxa2xx_ac97_hw_probe(struc
 	if (ret)
 		goto err_clk2;
 
-	ret = request_irq(IRQ_AC97, pxa2xx_ac97_irq, IRQF_DISABLED, "AC97", NULL);
+	ret = request_irq(IRQ_AC97, pxa2xx_ac97_irq, 0, "AC97", NULL);
 	if (ret < 0)
 		goto err_irq;
 
Index: linux-2.6/sound/drivers/ml403-ac97cr.c
===================================================================
--- linux-2.6.orig/sound/drivers/ml403-ac97cr.c
+++ linux-2.6/sound/drivers/ml403-ac97cr.c
@@ -1152,7 +1152,7 @@ snd_ml403_ac97cr_create(struct snd_card 
 		   "0x%x done\n", (unsigned int)ml403_ac97cr->port);
 	/* get irq */
 	irq = platform_get_irq(pfdev, 0);
-	if (request_irq(irq, snd_ml403_ac97cr_irq, IRQF_DISABLED,
+	if (request_irq(irq, snd_ml403_ac97cr_irq, 0,
 			dev_name(&pfdev->dev), (void *)ml403_ac97cr)) {
 		snd_printk(KERN_ERR SND_ML403_AC97CR_DRIVER ": "
 			   "unable to grab IRQ %d\n",
@@ -1165,7 +1165,7 @@ snd_ml403_ac97cr_create(struct snd_card 
 		   "request (playback) irq %d done\n",
 		   ml403_ac97cr->irq);
 	irq = platform_get_irq(pfdev, 1);
-	if (request_irq(irq, snd_ml403_ac97cr_irq, IRQF_DISABLED,
+	if (request_irq(irq, snd_ml403_ac97cr_irq, 0,
 			dev_name(&pfdev->dev), (void *)ml403_ac97cr)) {
 		snd_printk(KERN_ERR SND_ML403_AC97CR_DRIVER ": "
 			   "unable to grab IRQ %d\n",
Index: linux-2.6/sound/drivers/mpu401/mpu401.c
===================================================================
--- linux-2.6.orig/sound/drivers/mpu401/mpu401.c
+++ linux-2.6/sound/drivers/mpu401/mpu401.c
@@ -86,8 +86,7 @@ static int snd_mpu401_create(int dev, st
 	}
 
 	err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401, port[dev], 0,
-				  irq[dev], irq[dev] >= 0 ? IRQF_DISABLED : 0,
-				  NULL);
+				  irq[dev], 0, NULL);
 	if (err < 0) {
 		printk(KERN_ERR "MPU401 not detected at 0x%lx\n", port[dev]);
 		goto _err;
Index: linux-2.6/sound/drivers/mtpav.c
===================================================================
--- linux-2.6.orig/sound/drivers/mtpav.c
+++ linux-2.6/sound/drivers/mtpav.c
@@ -589,7 +589,7 @@ static int __devinit snd_mtpav_get_ISA(s
 		return -EBUSY;
 	}
 	mcard->port = port;
-	if (request_irq(irq, snd_mtpav_irqh, IRQF_DISABLED, "MOTU MTPAV", mcard)) {
+	if (request_irq(irq, snd_mtpav_irqh, 0, "MOTU MTPAV", mcard)) {
 		snd_printk("MTVAP IRQ %d busy\n", irq);
 		return -EBUSY;
 	}
Index: linux-2.6/sound/drivers/serial-u16550.c
===================================================================
--- linux-2.6.orig/sound/drivers/serial-u16550.c
+++ linux-2.6/sound/drivers/serial-u16550.c
@@ -814,7 +814,7 @@ static int __devinit snd_uart16550_creat
 
 	if (irq >= 0 && irq != SNDRV_AUTO_IRQ) {
 		if (request_irq(irq, snd_uart16550_interrupt,
-				IRQF_DISABLED, "Serial MIDI", uart)) {
+				0, "Serial MIDI", uart)) {
 			snd_printk("irq %d busy. Using Polling.\n", irq);
 		} else {
 			uart->irq = irq;
Index: linux-2.6/sound/isa/ad1816a/ad1816a.c
===================================================================
--- linux-2.6.orig/sound/isa/ad1816a/ad1816a.c
+++ linux-2.6/sound/isa/ad1816a/ad1816a.c
@@ -196,7 +196,7 @@ static int __devinit snd_card_ad1816a_pr
 
 	if (mpu_port[dev] > 0) {
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-					mpu_port[dev], 0, mpu_irq[dev], IRQF_DISABLED,
+					mpu_port[dev], 0, mpu_irq[dev], 0,
 					NULL) < 0)
 			printk(KERN_ERR PFX "no MPU-401 device at 0x%lx.\n", mpu_port[dev]);
 	}
Index: linux-2.6/sound/isa/ad1816a/ad1816a_lib.c
===================================================================
--- linux-2.6.orig/sound/isa/ad1816a/ad1816a_lib.c
+++ linux-2.6/sound/isa/ad1816a/ad1816a_lib.c
@@ -598,7 +598,7 @@ int __devinit snd_ad1816a_create(struct 
 		snd_ad1816a_free(chip);
 		return -EBUSY;
 	}
-	if (request_irq(irq, snd_ad1816a_interrupt, IRQF_DISABLED, "AD1816A", (void *) chip)) {
+	if (request_irq(irq, snd_ad1816a_interrupt, 0, "AD1816A", (void *) chip)) {
 		snd_printk(KERN_ERR "ad1816a: can't grab IRQ %d\n", irq);
 		snd_ad1816a_free(chip);
 		return -EBUSY;
Index: linux-2.6/sound/isa/als100.c
===================================================================
--- linux-2.6.orig/sound/isa/als100.c
+++ linux-2.6/sound/isa/als100.c
@@ -204,7 +204,7 @@ static int __devinit snd_card_als100_pro
 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_ALS100,
 					mpu_port[dev], 0, 
-					mpu_irq[dev], IRQF_DISABLED,
+					mpu_irq[dev], 0,
 					NULL) < 0)
 			snd_printk(KERN_ERR PFX "no MPU-401 device at 0x%lx\n", mpu_port[dev]);
 	}
Index: linux-2.6/sound/isa/azt2320.c
===================================================================
--- linux-2.6.orig/sound/isa/azt2320.c
+++ linux-2.6/sound/isa/azt2320.c
@@ -233,7 +233,7 @@ static int __devinit snd_card_azt2320_pr
 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_AZT2320,
 				mpu_port[dev], 0,
-				mpu_irq[dev], IRQF_DISABLED,
+				mpu_irq[dev], 0,
 				NULL) < 0)
 			snd_printk(KERN_ERR PFX "no MPU-401 device at 0x%lx\n", mpu_port[dev]);
 	}
Index: linux-2.6/sound/isa/cs423x/cs4231.c
===================================================================
--- linux-2.6.orig/sound/isa/cs423x/cs4231.c
+++ linux-2.6/sound/isa/cs423x/cs4231.c
@@ -131,8 +131,7 @@ static int __devinit snd_cs4231_probe(st
 			mpu_irq[n] = -1;
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_CS4232,
 					mpu_port[n], 0, mpu_irq[n],
-					mpu_irq[n] >= 0 ? IRQF_DISABLED : 0,
-					NULL) < 0)
+					0, NULL) < 0)
 			dev_warn(dev, "MPU401 not detected\n");
 	}
 
Index: linux-2.6/sound/isa/cs423x/cs4236.c
===================================================================
--- linux-2.6.orig/sound/isa/cs423x/cs4236.c
+++ linux-2.6/sound/isa/cs423x/cs4236.c
@@ -474,7 +474,7 @@ static int __devinit snd_cs423x_probe(st
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_CS4232,
 					mpu_port[dev], 0,
 					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0, NULL) < 0)
+					0, NULL) < 0)
 			printk(KERN_WARNING IDENT ": MPU401 not detected\n");
 	}
 
Index: linux-2.6/sound/isa/dt019x.c
===================================================================
--- linux-2.6.orig/sound/isa/dt019x.c
+++ linux-2.6/sound/isa/dt019x.c
@@ -196,8 +196,7 @@ static int __devinit snd_card_dt019x_pro
 					MPU401_HW_MPU401,
 					mpu_port[dev], 0,
 					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0,
-					NULL) < 0)
+					0, NULL) < 0)
 			snd_printk(KERN_ERR PFX "no MPU-401 device at 0x%lx ?\n", mpu_port[dev]);
 	}
 
Index: linux-2.6/sound/isa/es1688/es1688.c
===================================================================
--- linux-2.6.orig/sound/isa/es1688/es1688.c
+++ linux-2.6/sound/isa/es1688/es1688.c
@@ -156,7 +156,7 @@ static int __devinit snd_es1688_probe(st
 			chip->mpu_port > 0) {
 		error = snd_mpu401_uart_new(card, 0, MPU401_HW_ES1688,
 				chip->mpu_port, 0,
-				mpu_irq[n], IRQF_DISABLED, NULL);
+				mpu_irq[n], 0, NULL);
 		if (error < 0)
 			goto out;
 	}
Index: linux-2.6/sound/isa/es1688/es1688_lib.c
===================================================================
--- linux-2.6.orig/sound/isa/es1688/es1688_lib.c
+++ linux-2.6/sound/isa/es1688/es1688_lib.c
@@ -658,7 +658,7 @@ int snd_es1688_create(struct snd_card *c
 		snd_es1688_free(chip);
 		return -EBUSY;
 	}
-	if (request_irq(irq, snd_es1688_interrupt, IRQF_DISABLED, "ES1688", (void *) chip)) {
+	if (request_irq(irq, snd_es1688_interrupt, 0, "ES1688", (void *) chip)) {
 		snd_printk(KERN_ERR "es1688: can't grab IRQ %d\n", irq);
 		snd_es1688_free(chip);
 		return -EBUSY;
Index: linux-2.6/sound/isa/es18xx.c
===================================================================
--- linux-2.6.orig/sound/isa/es18xx.c
+++ linux-2.6/sound/isa/es18xx.c
@@ -1824,7 +1824,7 @@ static int __devinit snd_es18xx_new_devi
 		return -EBUSY;
 	}
 
-	if (request_irq(irq, snd_es18xx_interrupt, IRQF_DISABLED, "ES18xx", (void *) chip)) {
+	if (request_irq(irq, snd_es18xx_interrupt, 0, "ES18xx", (void *) chip)) {
 		snd_es18xx_free(chip);
 		snd_printk(KERN_ERR PFX "unable to grap IRQ %d\n", irq);
 		return -EBUSY;
Index: linux-2.6/sound/isa/gus/gus_main.c
===================================================================
--- linux-2.6.orig/sound/isa/gus/gus_main.c
+++ linux-2.6/sound/isa/gus/gus_main.c
@@ -180,7 +180,7 @@ int snd_gus_create(struct snd_card *card
 		snd_gus_free(gus);
 		return -EBUSY;
 	}
-	if (irq >= 0 && request_irq(irq, snd_gus_interrupt, IRQF_DISABLED, "GUS GF1", (void *) gus)) {
+	if (irq >= 0 && request_irq(irq, snd_gus_interrupt, 0, "GUS GF1", (void *) gus)) {
 		snd_printk(KERN_ERR "gus: can't grab irq %d\n", irq);
 		snd_gus_free(gus);
 		return -EBUSY;
Index: linux-2.6/sound/isa/gus/gusextreme.c
===================================================================
--- linux-2.6.orig/sound/isa/gus/gusextreme.c
+++ linux-2.6/sound/isa/gus/gusextreme.c
@@ -316,7 +316,7 @@ static int __devinit snd_gusextreme_prob
 	if (es1688->mpu_port >= 0x300) {
 		error = snd_mpu401_uart_new(card, 0, MPU401_HW_ES1688,
 				es1688->mpu_port, 0,
-				mpu_irq[n], IRQF_DISABLED, NULL);
+				mpu_irq[n], 0, NULL);
 		if (error < 0)
 			goto out;
 	}
Index: linux-2.6/sound/isa/gus/gusmax.c
===================================================================
--- linux-2.6.orig/sound/isa/gus/gusmax.c
+++ linux-2.6/sound/isa/gus/gusmax.c
@@ -291,7 +291,7 @@ static int __devinit snd_gusmax_probe(st
 		goto _err;
 	}
 
-	if (request_irq(xirq, snd_gusmax_interrupt, IRQF_DISABLED, "GUS MAX", (void *)maxcard)) {
+	if (request_irq(xirq, snd_gusmax_interrupt, 0, "GUS MAX", (void *)maxcard)) {
 		snd_printk(KERN_ERR PFX "unable to grab IRQ %d\n", xirq);
 		err = -EBUSY;
 		goto _err;
Index: linux-2.6/sound/isa/gus/interwave.c
===================================================================
--- linux-2.6.orig/sound/isa/gus/interwave.c
+++ linux-2.6/sound/isa/gus/interwave.c
@@ -681,7 +681,7 @@ static int __devinit snd_interwave_probe
 	if ((err = snd_gus_initialize(gus)) < 0)
 		return err;
 
-	if (request_irq(xirq, snd_interwave_interrupt, IRQF_DISABLED,
+	if (request_irq(xirq, snd_interwave_interrupt, 0,
 			"InterWave", iwcard)) {
 		snd_printk(KERN_ERR PFX "unable to grab IRQ %d\n", xirq);
 		return -EBUSY;
Index: linux-2.6/sound/isa/opl3sa2.c
===================================================================
--- linux-2.6.orig/sound/isa/opl3sa2.c
+++ linux-2.6/sound/isa/opl3sa2.c
@@ -654,7 +654,7 @@ static int __devinit snd_opl3sa2_probe(s
 	err = snd_opl3sa2_detect(card);
 	if (err < 0)
 		return err;
-	err = request_irq(xirq, snd_opl3sa2_interrupt, IRQF_DISABLED,
+	err = request_irq(xirq, snd_opl3sa2_interrupt, 0,
 			  "OPL3-SA2", card);
 	if (err) {
 		snd_printk(KERN_ERR PFX "can't grab IRQ %d\n", xirq);
Index: linux-2.6/sound/isa/opti9xx/miro.c
===================================================================
--- linux-2.6.orig/sound/isa/opti9xx/miro.c
+++ linux-2.6/sound/isa/opti9xx/miro.c
@@ -1383,7 +1383,7 @@ static int __devinit snd_miro_probe(stru
 		rmidi = NULL;
 	else
 		if ((error = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-				miro->mpu_port, 0, miro->mpu_irq, IRQF_DISABLED,
+				miro->mpu_port, 0, miro->mpu_irq, 0,
 				&rmidi)))
 			snd_printk(KERN_WARNING "no MPU-401 device at 0x%lx?\n", miro->mpu_port);
 
Index: linux-2.6/sound/isa/opti9xx/opti92x-ad1848.c
===================================================================
--- linux-2.6.orig/sound/isa/opti9xx/opti92x-ad1848.c
+++ linux-2.6/sound/isa/opti9xx/opti92x-ad1848.c
@@ -760,7 +760,7 @@ static int __devinit snd_opti9xx_probe(s
 #endif
 #ifdef OPTi93X
 	error = request_irq(chip->irq, snd_opti93x_interrupt,
-			    IRQF_DISABLED, DEV_NAME" - WSS", codec);
+			    0, DEV_NAME" - WSS", codec);
 	if (error < 0) {
 		snd_printk(KERN_ERR "opti9xx: can't grab IRQ %d\n", chip->irq);
 		return error;
@@ -782,7 +782,7 @@ static int __devinit snd_opti9xx_probe(s
 		rmidi = NULL;
 	else
 		if ((error = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-				chip->mpu_port, 0, chip->mpu_irq, IRQF_DISABLED,
+				chip->mpu_port, 0, chip->mpu_irq, 0,
 				&rmidi)))
 			snd_printk(KERN_WARNING "no MPU-401 device at 0x%lx?\n",
 				   chip->mpu_port);
Index: linux-2.6/sound/isa/sb/sb_common.c
===================================================================
--- linux-2.6.orig/sound/isa/sb/sb_common.c
+++ linux-2.6/sound/isa/sb/sb_common.c
@@ -237,7 +237,7 @@ int snd_sbdsp_create(struct snd_card *ca
 	if (request_irq(irq, irq_handler,
 			(hardware == SB_HW_ALS4000 ||
 			 hardware == SB_HW_CS5530) ?
-			IRQF_SHARED : IRQF_DISABLED,
+			IRQF_SHARED : 0,
 			"SoundBlaster", (void *) chip)) {
 		snd_printk(KERN_ERR "sb: can't grab irq %d\n", irq);
 		snd_sbdsp_free(chip);
Index: linux-2.6/sound/isa/sc6000.c
===================================================================
--- linux-2.6.orig/sound/isa/sc6000.c
+++ linux-2.6/sound/isa/sc6000.c
@@ -591,7 +591,7 @@ static int __devinit snd_sc6000_probe(st
 		if (snd_mpu401_uart_new(card, 0,
 					MPU401_HW_MPU401,
 					mpu_port[dev], 0,
-					mpu_irq[dev], IRQF_DISABLED,
+					mpu_irq[dev], 0,
 					NULL) < 0)
 			snd_printk(KERN_ERR "no MPU-401 device at 0x%lx ?\n",
 					mpu_port[dev]);
Index: linux-2.6/sound/isa/sgalaxy.c
===================================================================
--- linux-2.6.orig/sound/isa/sgalaxy.c
+++ linux-2.6/sound/isa/sgalaxy.c
@@ -145,7 +145,7 @@ static int __devinit snd_sgalaxy_setup_w
         if (tmp < 0)
                 return -EINVAL;
 
-	if (request_irq(irq, snd_sgalaxy_dummy_interrupt, IRQF_DISABLED, "sgalaxy", NULL)) {
+	if (request_irq(irq, snd_sgalaxy_dummy_interrupt, 0, "sgalaxy", NULL)) {
 		snd_printk(KERN_ERR "sgalaxy: can't grab irq %d\n", irq);
 		return -EIO;
 	}
Index: linux-2.6/sound/isa/sscape.c
===================================================================
--- linux-2.6.orig/sound/isa/sscape.c
+++ linux-2.6/sound/isa/sscape.c
@@ -937,7 +937,7 @@ static int __devinit create_mpu401(struc
 	if ((err = snd_mpu401_uart_new(card, devnum,
 	                               MPU401_HW_MPU401,
 	                               port, MPU401_INFO_INTEGRATED,
-	                               irq, IRQF_DISABLED,
+	                               irq, 0,
 	                               &rawmidi)) == 0) {
 		struct snd_mpu401 *mpu = (struct snd_mpu401 *) rawmidi->private_data;
 		mpu->open_input = mpu401_open;
Index: linux-2.6/sound/isa/wavefront/wavefront.c
===================================================================
--- linux-2.6.orig/sound/isa/wavefront/wavefront.c
+++ linux-2.6/sound/isa/wavefront/wavefront.c
@@ -417,7 +417,7 @@ snd_wavefront_probe (struct snd_card *ca
 		return -EBUSY;
 	}
 	if (request_irq(ics2115_irq[dev], snd_wavefront_ics2115_interrupt,
-			IRQF_DISABLED, "ICS2115", acard)) {
+			0, "ICS2115", acard)) {
 		snd_printk(KERN_ERR "unable to use ICS2115 IRQ %d\n", ics2115_irq[dev]);
 		return -EBUSY;
 	}
@@ -448,7 +448,7 @@ snd_wavefront_probe (struct snd_card *ca
 	if (cs4232_mpu_port[dev] > 0 && cs4232_mpu_port[dev] != SNDRV_AUTO_PORT) {
 		err = snd_mpu401_uart_new(card, midi_dev, MPU401_HW_CS4232,
 					  cs4232_mpu_port[dev], 0,
-					  cs4232_mpu_irq[dev], IRQF_DISABLED,
+					  cs4232_mpu_irq[dev], 0,
 					  NULL);
 		if (err < 0) {
 			snd_printk (KERN_ERR "can't allocate CS4232 MPU-401 device\n");
Index: linux-2.6/sound/isa/wss/wss_lib.c
===================================================================
--- linux-2.6.orig/sound/isa/wss/wss_lib.c
+++ linux-2.6/sound/isa/wss/wss_lib.c
@@ -1779,7 +1779,7 @@ int snd_wss_create(struct snd_card *card
 	}
 	chip->cport = cport;
 	if (!(hwshare & WSS_HWSHARE_IRQ))
-		if (request_irq(irq, snd_wss_interrupt, IRQF_DISABLED,
+		if (request_irq(irq, snd_wss_interrupt, 0,
 				"WSS", (void *) chip)) {
 			snd_printk(KERN_ERR "wss: can't grab IRQ %d\n", irq);
 			snd_wss_free(chip);
Index: linux-2.6/sound/mips/au1x00.c
===================================================================
--- linux-2.6.orig/sound/mips/au1x00.c
+++ linux-2.6/sound/mips/au1x00.c
@@ -465,13 +465,13 @@ snd_au1000_pcm_new(struct snd_au1000 *au
 
 	flags = claim_dma_lock();
 	if ((au1000->stream[PLAYBACK]->dma = request_au1000_dma(DMA_ID_AC97C_TX,
-			"AC97 TX", au1000_dma_interrupt, IRQF_DISABLED,
+			"AC97 TX", au1000_dma_interrupt, 0,
 			au1000->stream[PLAYBACK])) < 0) {
 		release_dma_lock(flags);
 		return -EBUSY;
 	}
 	if ((au1000->stream[CAPTURE]->dma = request_au1000_dma(DMA_ID_AC97C_RX,
-			"AC97 RX", au1000_dma_interrupt, IRQF_DISABLED,
+			"AC97 RX", au1000_dma_interrupt, 0,
 			au1000->stream[CAPTURE])) < 0){
 		release_dma_lock(flags);
 		return -EBUSY;
Index: linux-2.6/sound/oss/sh_dac_audio.c
===================================================================
--- linux-2.6.orig/sound/oss/sh_dac_audio.c
+++ linux-2.6/sound/oss/sh_dac_audio.c
@@ -305,7 +305,7 @@ static int __init dac_audio_init(void)
 	dac_audio_set_rate();
 
 	retval =
-	    request_irq(TIMER1_IRQ, timer1_interrupt, IRQF_DISABLED, MODNAME, 0);
+	    request_irq(TIMER1_IRQ, timer1_interrupt, 0, MODNAME, 0);
 	if (retval < 0) {
 		printk(KERN_ERR "sh_dac_audio: IRQ %d request failed\n",
 		       TIMER1_IRQ);
Index: linux-2.6/sound/pci/sis7019.c
===================================================================
--- linux-2.6.orig/sound/pci/sis7019.c
+++ linux-2.6/sound/pci/sis7019.c
@@ -1231,7 +1231,7 @@ static int sis_resume(struct pci_dev *pc
 		goto error;
 	}
 
-	if (request_irq(pci->irq, sis_interrupt, IRQF_DISABLED|IRQF_SHARED,
+	if (request_irq(pci->irq, sis_interrupt, IRQF_SHARED,
 				card->shortname, sis)) {
 		printk(KERN_ERR "sis7019: unable to regain IRQ %d\n", pci->irq);
 		goto error;
@@ -1337,7 +1337,7 @@ static int __devinit sis_chip_create(str
 	if (rc)
 		goto error_out_cleanup;
 
-	if (request_irq(pci->irq, sis_interrupt, IRQF_DISABLED|IRQF_SHARED,
+	if (request_irq(pci->irq, sis_interrupt, IRQF_SHARED,
 				card->shortname, sis)) {
 		printk(KERN_ERR "unable to allocate irq %d\n", sis->irq);
 		goto error_out_cleanup;
Index: linux-2.6/sound/ppc/snd_ps3.c
===================================================================
--- linux-2.6.orig/sound/ppc/snd_ps3.c
+++ linux-2.6/sound/ppc/snd_ps3.c
@@ -879,7 +879,7 @@ static int snd_ps3_allocate_irq(void)
 		return ret;
 	}
 
-	ret = request_irq(the_card.irq_no, snd_ps3_interrupt, IRQF_DISABLED,
+	ret = request_irq(the_card.irq_no, snd_ps3_interrupt, 0,
 			  SND_PS3_DRIVER_NAME, &the_card);
 	if (ret) {
 		pr_info("%s: request_irq failed (%d)\n", __func__, ret);
Index: linux-2.6/sound/soc/s3c24xx/s3c2443-ac97.c
===================================================================
--- linux-2.6.orig/sound/soc/s3c24xx/s3c2443-ac97.c
+++ linux-2.6/sound/soc/s3c24xx/s3c2443-ac97.c
@@ -251,7 +251,7 @@ static int s3c2443_ac97_probe(struct pla
 	writel(ac_glbctrl, s3c24xx_ac97.regs + S3C_AC97_GLBCTRL);
 
 	ret = request_irq(IRQ_S3C244x_AC97, s3c2443_ac97_irq,
-		IRQF_DISABLED, "AC97", NULL);
+		0, "AC97", NULL);
 	if (ret < 0) {
 		printk(KERN_ERR "s3c24xx-ac97: interrupt request failed.\n");
 		clk_disable(s3c24xx_ac97.ac97_clk);
Index: linux-2.6/sound/sparc/amd7930.c
===================================================================
--- linux-2.6.orig/sound/sparc/amd7930.c
+++ linux-2.6/sound/sparc/amd7930.c
@@ -961,7 +961,7 @@ static int __devinit snd_amd7930_create(
 	amd7930_idle(amd);
 
 	if (request_irq(irq, snd_amd7930_interrupt,
-			IRQF_DISABLED | IRQF_SHARED, "amd7930", amd)) {
+			 IRQF_SHARED, "amd7930", amd)) {
 		snd_printk("amd7930-%d: Unable to grab IRQ %d\n",
 			   dev, irq);
 		snd_amd7930_free(amd);


