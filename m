Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0CKO4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:56:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:39375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab0CKO4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:56:44 -0500
Message-ID: <4B990496.4020002@kernel.org>
Date: Thu, 11 Mar 2010 23:56:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [RFC] remove implicit slab.h inclusion from percpu.h
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:56:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Lee Schermerhorn was trying to use percpu from slab.h and ran into a
dependency loop.  percpu.h was using slab.h for UP inline
implementation which isn't a big deal in itself but it turns out that
percpu.h ends up being included everywhere via module.h and sched.h.
So, removing that implicit inclusion breaks a lot of files.

The following git tree contains trial conversion on x86_64.
allmodconfig builds fine on it but a lot of other archs are likely to
break although fixing them up shouldn't be too hard.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-remove-implied-slab-inclusion

This can be solved much easier by moving some of the stuff that's
necessary for slab.h from percpu.h into percpu-defs.h which originally
got separated so that it can be used by asm/percpu.h but it's hackish
and for longer term, it would be better to have slab.h explicitly
included where necessary.

So, what do you guys think?  Probably-the-right-thing-to-do >544 file
patch or somewhat-ugly-but-let's-worry-about-it-tommorrow two file
patch?

I omitted the patch itself as it's mind numbingly boring and long.

Thanks.

Patch description and diffstat follows.  Patch content omitted.
===============================================================

>From b0bcd3a0e6a49077a2e7b073831fbae9e8f87b4b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 11 Mar 2010 23:27:38 +0900
Subject: [PATCH] percpu: break implied slab.h inclusing via percpu.h

percpu.h has always been including slab.h to get k[mz]alloc/free() for
UP inline implementation.  percpu.h being used by very low level
headers including module.h and sched.h, this meant that a lot files
unintentionally got slab.h inclusion.

Lee Schermerhorn was trying to make slab.h use percpu.h and got bitten
by this implicit inclusion.  Apparently, the right thing to do is
breaking this ultimately unnecessary implicit inclusion; however,
because it has been there for so long, removing the implicit inclusion
breaks a lot of files.  Another approach would be leaving the implicit
inclusion alone but moving some parts of percpu which slab.h wants to
use into percpu-defs.h which is hacky but far less painful.

This patch drops the implicit slab.h inclusion and updates all the
affected files w/ allmodconfig on x86_64.  This isn't complete and the
same task should be done for each arch but it should cover most of
arch independent code.

REVIEW ONLY.  DO NOT APPLY.  WILL BREAK A LOT OF ARCHS OTHER THAN x86_64.

NOT_SIGNED_OFF_YET
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
---
 arch/x86/ia32/sys_ia32.c                          |    1 +
 arch/x86/kernel/alternative.c                     |    1 +
 arch/x86/kernel/apic/nmi.c                        |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c                  |    1 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c              |    1 +
 arch/x86/kernel/cpu/perf_event.c                  |    1 +
 arch/x86/kernel/hpet.c                            |    1 +
 arch/x86/kernel/i387.c                            |    1 +
 arch/x86/kernel/kdebugfs.c                        |    1 +
 arch/x86/kernel/uv_irq.c                          |    1 +
 arch/x86/kernel/uv_time.c                         |    1 +
 arch/x86/mm/kmmio.c                               |    1 +
 arch/x86/mm/mmio-mod.c                            |    1 +
 arch/x86/mm/pat.c                                 |    1 +
 arch/x86/vdso/vma.c                               |    1 +
 arch/x86/xen/debugfs.c                            |    1 +
 arch/x86/xen/smp.c                                |    1 +
 block/blk-cgroup.c                                |    1 +
 block/blk-integrity.c                             |    1 +
 block/blk-ioc.c                                   |    1 +
 block/blk-sysfs.c                                 |    1 +
 block/blk-tag.c                                   |    1 +
 block/bsg.c                                       |    1 +
 block/cfq-iosched.c                               |    1 +
 block/compat_ioctl.c                              |    1 +
 block/noop-iosched.c                              |    1 +
 drivers/auxdisplay/cfag12864b.c                   |    1 +
 drivers/base/bus.c                                |    1 +
 drivers/base/devres.c                             |    1 +
 drivers/base/driver.c                             |    1 +
 drivers/base/firmware_class.c                     |    1 +
 drivers/base/memory.c                             |    1 +
 drivers/base/module.c                             |    1 +
 drivers/block/brd.c                               |    1 +
 drivers/block/osdblk.c                            |    1 +
 drivers/block/ub.c                                |    1 +
 drivers/block/virtio_blk.c                        |    1 +
 drivers/block/xen-blkfront.c                      |    1 +
 drivers/char/hvc_console.c                        |    1 +
 drivers/char/pty.c                                |    1 +
 drivers/char/tpm/tpm.c                            |    1 +
 drivers/char/tpm/tpm_nsc.c                        |    1 +
 drivers/char/tpm/tpm_tis.c                        |    1 +
 drivers/char/tty_audit.c                          |    1 +
 drivers/char/virtio_console.c                     |    1 +
 drivers/cpufreq/cpufreq_stats.c                   |    1 +
 drivers/cpuidle/sysfs.c                           |    1 +
 drivers/dma/dmaengine.c                           |    1 +
 drivers/dma/dmatest.c                             |    1 +
 drivers/firmware/dell_rbu.c                       |    1 +
 drivers/firmware/dmi-id.c                         |    1 +
 drivers/firmware/memmap.c                         |    1 +
 drivers/gpio/adp5588-gpio.c                       |    1 +
 drivers/gpio/gpiolib.c                            |    1 +
 drivers/gpio/max7300.c                            |    1 +
 drivers/gpio/max730x.c                            |    1 +
 drivers/gpio/pca953x.c                            |    1 +
 drivers/gpio/timbgpio.c                           |    1 +
 drivers/gpio/wm8994-gpio.c                        |    1 +
 drivers/gpu/drm/ttm/ttm_agp_backend.c             |    1 +
 drivers/gpu/drm/ttm/ttm_bo_util.c                 |    1 +
 drivers/gpu/drm/ttm/ttm_memory.c                  |    1 +
 drivers/gpu/drm/ttm/ttm_tt.c                      |    1 +
 drivers/hwmon/ad7414.c                            |    1 +
 drivers/hwmon/ad7418.c                            |    1 +
 drivers/hwmon/adt7411.c                           |    1 +
 drivers/hwmon/adt7462.c                           |    1 +
 drivers/hwmon/adt7470.c                           |    1 +
 drivers/hwmon/atxp1.c                             |    1 +
 drivers/hwmon/f75375s.c                           |    1 +
 drivers/hwmon/mc13783-adc.c                       |    1 +
 drivers/hwmon/sht15.c                             |    1 +
 drivers/i2c/busses/i2c-gpio.c                     |    1 +
 drivers/i2c/busses/i2c-ocores.c                   |    1 +
 drivers/i2c/busses/i2c-simtec.c                   |    1 +
 drivers/i2c/busses/i2c-tiny-usb.c                 |    1 +
 drivers/i2c/busses/i2c-xiic.c                     |    1 +
 drivers/i2c/i2c-boardinfo.c                       |    1 +
 drivers/i2c/i2c-smbus.c                           |    1 +
 drivers/infiniband/core/cm.c                      |    1 +
 drivers/infiniband/core/mad.c                     |    1 +
 drivers/infiniband/core/mad_priv.h                |    1 +
 drivers/infiniband/core/multicast.c               |    1 +
 drivers/infiniband/core/ucm.c                     |    1 +
 drivers/infiniband/core/user_mad.c                |    1 +
 drivers/infiniband/core/uverbs_cmd.c              |    1 +
 drivers/infiniband/core/uverbs_main.c             |    1 +
 drivers/input/ff-core.c                           |    1 +
 drivers/input/ff-memless.c                        |    1 +
 drivers/input/input-polldev.c                     |    1 +
 drivers/input/keyboard/adp5588-keys.c             |    1 +
 drivers/input/keyboard/lm8323.c                   |    1 +
 drivers/input/keyboard/matrix_keypad.c            |    1 +
 drivers/input/keyboard/max7359_keypad.c           |    1 +
 drivers/input/keyboard/opencores-kbd.c            |    1 +
 drivers/input/misc/ati_remote2.c                  |    1 +
 drivers/input/misc/pcap_keys.c                    |    1 +
 drivers/input/misc/pcf50633-input.c               |    1 +
 drivers/input/misc/rotary_encoder.c               |    1 +
 drivers/input/misc/winbond-cir.c                  |    1 +
 drivers/input/mouse/alps.c                        |    1 +
 drivers/input/mouse/elantech.c                    |    1 +
 drivers/input/mouse/lifebook.c                    |    1 +
 drivers/input/mouse/sentelic.c                    |    1 +
 drivers/input/mouse/synaptics.c                   |    1 +
 drivers/input/mouse/synaptics_i2c.c               |    1 +
 drivers/input/serio/altera_ps2.c                  |    1 +
 drivers/input/serio/ct82c710.c                    |    1 +
 drivers/input/serio/i8042.c                       |    1 +
 drivers/input/sparse-keymap.c                     |    1 +
 drivers/input/touchscreen/eeti_ts.c               |    1 +
 drivers/input/touchscreen/mc13783_ts.c            |    1 +
 drivers/input/touchscreen/mcs5000_ts.c            |    1 +
 drivers/input/touchscreen/pcap_ts.c               |    1 +
 drivers/input/xen-kbdfront.c                      |    1 +
 drivers/isdn/capi/capifs.c                        |    1 +
 drivers/isdn/capi/capiutil.c                      |    1 +
 drivers/isdn/hardware/mISDN/hfcpci.c              |    1 +
 drivers/leds/led-triggers.c                       |    1 +
 drivers/leds/leds-bd2802.c                        |    1 +
 drivers/leds/leds-gpio.c                          |    1 +
 drivers/leds/leds-lp3944.c                        |    1 +
 drivers/leds/leds-lt3593.c                        |    1 +
 drivers/leds/leds-pca9532.c                       |    2 +
 drivers/leds/leds-pca955x.c                       |    1 +
 drivers/leds/leds-regulator.c                     |    1 +
 drivers/leds/ledtrig-backlight.c                  |    1 +
 drivers/leds/ledtrig-gpio.c                       |    1 +
 drivers/leds/ledtrig-heartbeat.c                  |    1 +
 drivers/leds/ledtrig-timer.c                      |    1 +
 drivers/md/dm-log-userspace-base.c                |    1 +
 drivers/md/dm.h                                   |    1 +
 drivers/md/md.h                                   |    1 +
 drivers/media/IR/ir-keytable.c                    |    1 +
 drivers/media/IR/ir-sysfs.c                       |    1 +
 drivers/media/common/tuners/mc44s803.c            |    1 +
 drivers/media/common/tuners/mt2060.c              |    1 +
 drivers/media/common/tuners/mt20xx.c              |    1 +
 drivers/media/common/tuners/mt2131.c              |    1 +
 drivers/media/common/tuners/mt2266.c              |    1 +
 drivers/media/common/tuners/qt1010.c              |    2 +
 drivers/media/common/tuners/tda827x.c             |    1 +
 drivers/media/common/tuners/tda8290.c             |    1 +
 drivers/media/common/tuners/tea5761.c             |    1 +
 drivers/media/common/tuners/tea5767.c             |    1 +
 drivers/media/common/tuners/tuner-i2c.h           |    1 +
 drivers/media/common/tuners/tuner-simple.c        |    1 +
 drivers/media/common/tuners/tuner-xc2028.c        |    1 +
 drivers/media/dvb/frontends/atbm8830.c            |    1 +
 drivers/media/dvb/frontends/dib0070.c             |    1 +
 drivers/media/dvb/frontends/dib0090.c             |    1 +
 drivers/media/dvb/frontends/dib3000mc.c           |    1 +
 drivers/media/dvb/frontends/dib7000m.c            |    1 +
 drivers/media/dvb/frontends/dib7000p.c            |    1 +
 drivers/media/dvb/frontends/dib8000.c             |    1 +
 drivers/media/dvb/frontends/drx397xD.c            |    1 +
 drivers/media/dvb/frontends/dvb-pll.c             |    1 +
 drivers/media/dvb/frontends/ec100.c               |    1 +
 drivers/media/dvb/frontends/itd1000.c             |    1 +
 drivers/media/dvb/frontends/lgdt3304.c            |    1 +
 drivers/media/dvb/frontends/lgdt3305.c            |    1 +
 drivers/media/dvb/frontends/lgs8gxx.c             |    1 +
 drivers/media/dvb/frontends/mb86a16.c             |    1 +
 drivers/media/dvb/frontends/s921_module.c         |    1 +
 drivers/media/dvb/frontends/stb0899_drv.c         |    1 +
 drivers/media/dvb/frontends/stb6000.c             |    1 +
 drivers/media/dvb/frontends/stb6100.c             |    1 +
 drivers/media/dvb/frontends/stv090x.c             |    1 +
 drivers/media/dvb/frontends/stv6110.c             |    1 +
 drivers/media/dvb/frontends/stv6110x.c            |    1 +
 drivers/media/dvb/frontends/tda665x.c             |    1 +
 drivers/media/dvb/frontends/tda8261.c             |    1 +
 drivers/media/dvb/frontends/tda826x.c             |    1 +
 drivers/media/dvb/frontends/tua6100.c             |    1 +
 drivers/media/dvb/frontends/zl10036.c             |    1 +
 drivers/media/dvb/siano/smscoreapi.c              |    1 +
 drivers/media/dvb/siano/smsdvb.c                  |    1 +
 drivers/media/dvb/siano/smssdio.c                 |    1 +
 drivers/media/dvb/siano/smsusb.c                  |    1 +
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c          |    2 +
 drivers/media/radio/radio-si4713.c                |    1 +
 drivers/media/radio/radio-tea5764.c               |    1 +
 drivers/media/radio/radio-timb.c                  |    1 +
 drivers/media/radio/saa7706h.c                    |    1 +
 drivers/media/radio/si4713-i2c.c                  |    1 +
 drivers/media/radio/tef6862.c                     |    1 +
 drivers/media/video/adv7170.c                     |    1 +
 drivers/media/video/adv7175.c                     |    1 +
 drivers/media/video/bt819.c                       |    1 +
 drivers/media/video/bt856.c                       |    1 +
 drivers/media/video/bt866.c                       |    1 +
 drivers/media/video/cs5345.c                      |    1 +
 drivers/media/video/cs53l32a.c                    |    1 +
 drivers/media/video/gspca/gspca.h                 |    1 +
 drivers/media/video/ks0127.c                      |    1 +
 drivers/media/video/m52790.c                      |    1 +
 drivers/media/video/mt9v011.c                     |    1 +
 drivers/media/video/ov7670.c                      |    1 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c        |    1 +
 drivers/media/video/pwc/pwc-ctrl.c                |    1 +
 drivers/media/video/pwc/pwc-dec1.c                |    2 +-
 drivers/media/video/pwc/pwc-dec23.c               |    1 +
 drivers/media/video/s2255drv.c                    |    1 +
 drivers/media/video/saa5246a.c                    |    1 +
 drivers/media/video/saa5249.c                     |    1 +
 drivers/media/video/saa717x.c                     |    1 +
 drivers/media/video/saa7185.c                     |    1 +
 drivers/media/video/soc_camera.c                  |    1 +
 drivers/media/video/tda9840.c                     |    1 +
 drivers/media/video/tea6415c.c                    |    1 +
 drivers/media/video/tea6420.c                     |    1 +
 drivers/media/video/tlg2300/pd-video.c            |    1 +
 drivers/media/video/tvp5150.c                     |    1 +
 drivers/media/video/upd64031a.c                   |    1 +
 drivers/media/video/upd64083.c                    |    1 +
 drivers/media/video/usbvideo/quickcam_messenger.c |    1 +
 drivers/media/video/uvc/uvc_ctrl.c                |    1 +
 drivers/media/video/uvc/uvc_driver.c              |    1 +
 drivers/media/video/uvc/uvc_status.c              |    1 +
 drivers/media/video/uvc/uvc_v4l2.c                |    1 +
 drivers/media/video/uvc/uvc_video.c               |    1 +
 drivers/media/video/v4l2-ioctl.c                  |    1 +
 drivers/media/video/vp27smpx.c                    |    1 +
 drivers/media/video/vpx3220.c                     |    1 +
 drivers/media/video/wm8739.c                      |    1 +
 drivers/media/video/wm8775.c                      |    1 +
 drivers/memstick/core/memstick.c                  |    1 +
 drivers/memstick/core/mspro_block.c               |    1 +
 drivers/mfd/htc-pasic3.c                          |    1 +
 drivers/mfd/pcf50633-adc.c                        |    1 +
 drivers/mfd/pcf50633-core.c                       |    1 +
 drivers/mfd/ucb1400_core.c                        |    1 +
 drivers/mfd/wm8400-core.c                         |    1 +
 drivers/mfd/wm8994-core.c                         |    1 +
 drivers/misc/c2port/core.c                        |    1 +
 drivers/misc/enclosure.c                          |    1 +
 drivers/misc/ics932s401.c                         |    1 +
 drivers/misc/iwmc3200top/debugfs.c                |    1 +
 drivers/misc/iwmc3200top/fw-download.c            |    1 +
 drivers/misc/iwmc3200top/log.c                    |    1 +
 drivers/misc/iwmc3200top/main.c                   |    1 +
 drivers/misc/lkdtm.c                              |    1 +
 drivers/misc/sgi-xp/xpc_main.c                    |    1 +
 drivers/misc/sgi-xp/xpc_partition.c               |    1 +
 drivers/misc/sgi-xp/xpc_uv.c                      |    1 +
 drivers/mmc/card/block.c                          |    1 +
 drivers/mmc/card/mmc_test.c                       |    1 +
 drivers/mmc/card/queue.c                          |    1 +
 drivers/mmc/card/sdio_uart.c                      |    1 +
 drivers/mmc/core/bus.c                            |    1 +
 drivers/mmc/core/debugfs.c                        |    1 +
 drivers/mmc/core/host.c                           |    1 +
 drivers/mmc/core/mmc.c                            |    1 +
 drivers/mmc/core/mmc_ops.c                        |    1 +
 drivers/mmc/core/sd.c                             |    1 +
 drivers/mmc/core/sdio_bus.c                       |    1 +
 drivers/mmc/core/sdio_cis.c                       |    1 +
 drivers/mmc/host/sdhci.c                          |    1 +
 drivers/mmc/host/wbsd.c                           |    1 +
 drivers/mtd/devices/block2mtd.c                   |    1 +
 drivers/mtd/lpddr/lpddr_cmds.c                    |    1 +
 drivers/mtd/maps/gpio-addr-flash.c                |    1 +
 drivers/mtd/nand/diskonchip.c                     |    1 +
 drivers/mtd/onenand/onenand_base.c                |    1 +
 drivers/mtd/onenand/onenand_sim.c                 |    1 +
 drivers/mtd/tests/mtd_oobtest.c                   |    1 +
 drivers/mtd/tests/mtd_pagetest.c                  |    1 +
 drivers/mtd/tests/mtd_readtest.c                  |    1 +
 drivers/mtd/tests/mtd_speedtest.c                 |    1 +
 drivers/mtd/tests/mtd_stresstest.c                |    1 +
 drivers/mtd/tests/mtd_subpagetest.c               |    1 +
 drivers/mtd/tests/mtd_torturetest.c               |    1 +
 drivers/mtd/ubi/gluebi.c                          |    1 +
 drivers/mtd/ubi/ubi.h                             |    1 +
 drivers/net/phy/fixed.c                           |    1 +
 drivers/power/bq27x00_battery.c                   |    1 +
 drivers/power/ds2760_battery.c                    |    1 +
 drivers/power/ds2782_battery.c                    |    1 +
 drivers/power/max17040_battery.c                  |    1 +
 drivers/power/pcf50633-charger.c                  |    1 +
 drivers/power/power_supply_leds.c                 |    1 +
 drivers/power/power_supply_sysfs.c                |    1 +
 drivers/pps/kapi.c                                |    1 +
 drivers/regulator/core.c                          |    1 +
 drivers/regulator/fixed.c                         |    1 +
 drivers/regulator/lp3971.c                        |    1 +
 drivers/regulator/max1586.c                       |    1 +
 drivers/regulator/max8649.c                       |    1 +
 drivers/regulator/max8660.c                       |    1 +
 drivers/regulator/mc13783-regulator.c             |    1 +
 drivers/regulator/tps65023-regulator.c            |    1 +
 drivers/regulator/tps6507x-regulator.c            |    1 +
 drivers/regulator/userspace-consumer.c            |    1 +
 drivers/regulator/virtual.c                       |    1 +
 drivers/regulator/wm8994-regulator.c              |    1 +
 drivers/rtc/class.c                               |    1 +
 drivers/rtc/rtc-bq4802.c                          |    1 +
 drivers/rtc/rtc-ds1286.c                          |    1 +
 drivers/rtc/rtc-ds1374.c                          |    1 +
 drivers/rtc/rtc-fm3130.c                          |    1 +
 drivers/rtc/rtc-m48t35.c                          |    1 +
 drivers/rtc/rtc-m48t59.c                          |    1 +
 drivers/rtc/rtc-mc13783.c                         |    1 +
 drivers/rtc/rtc-msm6242.c                         |    1 +
 drivers/rtc/rtc-pcap.c                            |    1 +
 drivers/rtc/rtc-pcf50633.c                        |    1 +
 drivers/rtc/rtc-pcf8563.c                         |    1 +
 drivers/rtc/rtc-rp5c01.c                          |    1 +
 drivers/rtc/rtc-rs5c372.c                         |    1 +
 drivers/rtc/rtc-rx8025.c                          |    1 +
 drivers/rtc/rtc-v3020.c                           |    1 +
 drivers/scsi/ch.c                                 |    1 +
 drivers/scsi/device_handler/scsi_dh.c             |    1 +
 drivers/scsi/device_handler/scsi_dh_alua.c        |    1 +
 drivers/scsi/device_handler/scsi_dh_emc.c         |    1 +
 drivers/scsi/device_handler/scsi_dh_hp_sw.c       |    1 +
 drivers/scsi/device_handler/scsi_dh_rdac.c        |    1 +
 drivers/scsi/hosts.c                              |    1 +
 drivers/scsi/libsrp.c                             |    1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c                  |    1 +
 drivers/scsi/osd/osd_initiator.c                  |    1 +
 drivers/scsi/osd/osd_uld.c                        |    1 +
 drivers/scsi/scsi_scan.c                          |    1 +
 drivers/scsi/scsi_sysfs.c                         |    1 +
 drivers/scsi/scsi_tgt_lib.c                       |    1 +
 drivers/scsi/scsi_transport_spi.c                 |    1 +
 drivers/scsi/scsicam.c                            |    1 +
 drivers/scsi/sd.c                                 |    1 +
 drivers/scsi/ses.c                                |    1 +
 drivers/scsi/sr.c                                 |    1 +
 drivers/scsi/sr_ioctl.c                           |    1 +
 drivers/scsi/sr_vendor.c                          |    1 +
 drivers/scsi/st.c                                 |    1 +
 drivers/serial/8250.c                             |    1 +
 drivers/thermal/thermal_sys.c                     |    1 +
 drivers/uio/uio.c                                 |    1 +
 drivers/uio/uio_pdrv.c                            |    1 +
 drivers/uio/uio_pdrv_genirq.c                     |    1 +
 drivers/usb/c67x00/c67x00-drv.c                   |    1 +
 drivers/usb/c67x00/c67x00-sched.c                 |    1 +
 drivers/usb/class/usbtmc.c                        |    1 +
 drivers/usb/core/driver.c                         |    1 +
 drivers/usb/core/endpoint.c                       |    1 +
 drivers/usb/core/file.c                           |    1 +
 drivers/usb/gadget/audio.c                        |    1 +
 drivers/usb/host/isp116x-hcd.c                    |    1 +
 drivers/usb/host/r8a66597-hcd.c                   |    1 +
 drivers/usb/host/xhci-hcd.c                       |    1 +
 drivers/usb/host/xhci-ring.c                      |    1 +
 drivers/usb/misc/appledisplay.c                   |    1 +
 drivers/usb/misc/cypress_cy7c63.c                 |    1 +
 drivers/usb/misc/cytherm.c                        |    1 +
 drivers/usb/misc/isight_firmware.c                |    1 +
 drivers/usb/misc/trancevibrator.c                 |    1 +
 drivers/usb/otg/nop-usb-xceiv.c                   |    1 +
 drivers/usb/serial/aircable.c                     |    1 +
 drivers/usb/serial/ark3116.c                      |    1 +
 drivers/usb/serial/bus.c                          |    1 +
 drivers/usb/serial/ch341.c                        |    1 +
 drivers/usb/serial/opticon.c                      |    1 +
 drivers/usb/serial/option.c                       |    1 +
 drivers/usb/serial/sierra.c                       |    1 +
 drivers/usb/serial/symbolserial.c                 |    1 +
 drivers/usb/storage/usb.h                         |    1 +
 drivers/usb/wusbcore/cbaf.c                       |    1 +
 drivers/usb/wusbcore/wusbhc.h                     |    1 +
 drivers/uwb/allocator.c                           |    1 +
 drivers/uwb/beacon.c                              |    1 +
 drivers/uwb/drp-ie.c                              |    1 +
 drivers/uwb/drp.c                                 |    1 +
 drivers/uwb/est.c                                 |    1 +
 drivers/uwb/i1480/dfu/mac.c                       |    1 +
 drivers/uwb/i1480/dfu/usb.c                       |    1 +
 drivers/uwb/uwb-internal.h                        |    1 +
 drivers/video/backlight/backlight.c               |    1 +
 drivers/video/backlight/lcd.c                     |    1 +
 drivers/video/backlight/platform_lcd.c            |    1 +
 drivers/video/console/bitblit.c                   |    1 +
 drivers/video/console/fbcon_ccw.c                 |    1 +
 drivers/video/console/fbcon_cw.c                  |    1 +
 drivers/video/console/fbcon_rotate.c              |    1 +
 drivers/video/console/fbcon_ud.c                  |    1 +
 drivers/video/display/display-sysfs.c             |    1 +
 drivers/video/fb_ddc.c                            |    1 +
 drivers/video/fbcvt.c                             |    1 +
 drivers/video/fbsysfs.c                           |    1 +
 drivers/video/modedb.c                            |    1 +
 drivers/video/output.c                            |    1 +
 drivers/video/s1d13xxxfb.c                        |    1 +
 drivers/video/xen-fbfront.c                       |    1 +
 drivers/virtio/virtio_balloon.c                   |    1 +
 drivers/virtio/virtio_ring.c                      |    1 +
 drivers/w1/masters/ds2490.c                       |    1 +
 drivers/w1/masters/w1-gpio.c                      |    1 +
 drivers/w1/slaves/w1_ds2433.c                     |    1 +
 drivers/watchdog/max63xx_wdt.c                    |    1 +
 drivers/xen/events.c                              |    1 +
 drivers/xen/grant-table.c                         |    1 +
 drivers/xen/manage.c                              |    1 +
 drivers/xen/sys-hypervisor.c                      |    1 +
 drivers/xen/xenbus/xenbus_client.c                |    1 +
 drivers/xen/xenfs/xenbus.c                        |    1 +
 fs/9p/cache.c                                     |    1 +
 fs/9p/fid.c                                       |    1 +
 fs/9p/v9fs.c                                      |    1 +
 fs/9p/vfs_dentry.c                                |    1 +
 fs/9p/vfs_dir.c                                   |    1 +
 fs/9p/vfs_inode.c                                 |    1 +
 fs/9p/vfs_super.c                                 |    1 +
 fs/adfs/super.c                                   |    1 +
 fs/affs/affs.h                                    |    1 +
 fs/affs/bitmap.c                                  |    1 +
 fs/affs/super.c                                   |    1 +
 fs/bio-integrity.c                                |    1 +
 fs/btrfs/async-thread.c                           |    1 +
 fs/btrfs/ctree.h                                  |    1 +
 fs/btrfs/super.c                                  |    1 +
 fs/ecryptfs/dentry.c                              |    1 +
 fs/ecryptfs/kthread.c                             |    1 +
 fs/ecryptfs/messaging.c                           |    1 +
 fs/ecryptfs/miscdev.c                             |    1 +
 fs/eventfd.c                                      |    1 +
 fs/exofs/inode.c                                  |    1 +
 fs/exofs/ios.c                                    |    1 +
 fs/exofs/super.c                                  |    1 +
 fs/ext2/balloc.c                                  |    1 +
 fs/fat/cache.c                                    |    1 +
 fs/fat/fat.h                                      |    1 +
 fs/fs-writeback.c                                 |    1 +
 fs/fscache/object-list.c                          |    1 +
 fs/fscache/operation.c                            |    1 +
 fs/fscache/page.c                                 |    1 +
 fs/fuse/cuse.c                                    |    1 +
 fs/gfs2/lock_dlm.c                                |    1 +
 fs/hfsplus/options.c                              |    1 +
 fs/libfs.c                                        |    1 +
 fs/logfs/logfs.h                                  |    1 +
 fs/nilfs2/the_nilfs.h                             |    1 +
 fs/ntfs/ntfs.h                                    |    1 +
 fs/ocfs2/stack_o2cb.c                             |    1 +
 fs/ocfs2/stack_user.c                             |    1 +
 fs/omfs/inode.c                                   |    1 +
 fs/ramfs/inode.c                                  |    1 +
 fs/signalfd.c                                     |    1 +
 fs/squashfs/zlib_wrapper.c                        |    1 +
 fs/sync.c                                         |    1 +
 fs/sysfs/inode.c                                  |    1 +
 fs/sysfs/mount.c                                  |    1 +
 fs/timerfd.c                                      |    1 +
 fs/ubifs/ubifs.h                                  |    1 +
 fs/udf/unicode.c                                  |    1 +
 include/linux/fsnotify.h                          |    1 +
 include/linux/gameport.h                          |    1 +
 include/linux/jbd.h                               |    1 +
 include/linux/jbd2.h                              |    1 +
 include/linux/kvm_host.h                          |    1 +
 include/linux/percpu.h                            |   22 ++--------------
 include/linux/security.h                          |    1 +
 include/linux/spi/spi.h                           |    1 +
 include/linux/taskstats_kern.h                    |    1 +
 include/linux/usb/gadget.h                        |    2 +
 kernel/async.c                                    |    1 +
 kernel/cgroup_freezer.c                           |    1 +
 kernel/irq/numa_migrate.c                         |    1 +
 kernel/padata.c                                   |    1 +
 kernel/perf_event.c                               |    1 +
 kernel/pid_namespace.c                            |    1 +
 kernel/power/hibernate_nvs.c                      |    1 +
 kernel/power/snapshot.c                           |    1 +
 kernel/power/swap.c                               |    1 +
 kernel/sched_cpupri.c                             |    1 +
 kernel/time/timecompare.c                         |    1 +
 kernel/timer.c                                    |    1 +
 kernel/trace/trace.h                              |    1 +
 lib/cpumask.c                                     |    1 +
 lib/debugobjects.c                                |    1 +
 lib/genalloc.c                                    |    1 +
 lib/kasprintf.c                                   |    1 +
 lib/kref.c                                        |    1 +
 lib/scatterlist.c                                 |    1 +
 mm/Makefile                                       |    3 +-
 mm/bootmem.c                                      |    1 +
 mm/mmu_notifier.c                                 |    1 +
 mm/percpu.c                                       |   28 ++++++++++++++++++++-
 mm/sparse-vmemmap.c                               |    1 +
 mm/sparse.c                                       |    1 +
 net/9p/client.c                                   |    1 +
 net/9p/protocol.c                                 |    1 +
 net/9p/util.c                                     |    1 +
 net/rfkill/core.c                                 |    1 +
 net/sunrpc/xdr.c                                  |    1 +
 samples/kobject/kset-example.c                    |    1 +
 security/device_cgroup.c                          |    1 +
 security/tomoyo/common.h                          |    1 +
 sound/core/hrtimer.c                              |    1 +
 sound/core/jack.c                                 |    1 +
 sound/core/misc.c                                 |    1 +
 sound/core/pcm_memory.c                           |    1 +
 sound/core/seq/seq_system.c                       |    1 +
 sound/drivers/opl3/opl3_synth.c                   |    1 +
 sound/drivers/serial-u16550.c                     |    1 +
 sound/i2c/other/tea575x-tuner.c                   |    1 +
 sound/pci/atiixp.c                                |    1 +
 sound/pci/atiixp_modem.c                          |    1 +
 sound/pci/hda/hda_eld.c                           |    1 +
 sound/pci/ice1712/ak4xxx.c                        |    1 +
 sound/soc/codecs/ad73311.c                        |    1 +
 sound/soc/codecs/ads117x.c                        |    1 +
 sound/soc/codecs/ak4535.c                         |    1 +
 sound/soc/codecs/ak4642.c                         |    1 +
 sound/soc/codecs/ak4671.c                         |    1 +
 sound/soc/codecs/cs4270.c                         |    1 +
 sound/soc/codecs/da7210.c                         |    1 +
 sound/soc/codecs/pcm3008.c                        |    1 +
 sound/soc/codecs/ssm2602.c                        |    1 +
 sound/soc/codecs/tlv320aic23.c                    |    1 +
 sound/soc/codecs/tlv320aic3x.c                    |    1 +
 sound/soc/codecs/tlv320dac33.c                    |    1 +
 sound/soc/codecs/tpa6130a2.c                      |    1 +
 sound/soc/codecs/uda134x.c                        |    1 +
 sound/soc/codecs/wm2000.c                         |    1 +
 sound/soc/codecs/wm8400.c                         |    1 +
 sound/soc/codecs/wm8523.c                         |    1 +
 sound/soc/codecs/wm8580.c                         |    1 +
 sound/soc/codecs/wm8727.c                         |    1 +
 sound/soc/codecs/wm8900.c                         |    1 +
 sound/soc/codecs/wm8903.c                         |    1 +
 sound/soc/codecs/wm8904.c                         |    1 +
 sound/soc/codecs/wm8955.c                         |    1 +
 sound/soc/codecs/wm8960.c                         |    1 +
 sound/soc/codecs/wm8961.c                         |    1 +
 sound/soc/codecs/wm8971.c                         |    1 +
 sound/soc/codecs/wm8974.c                         |    1 +
 sound/soc/codecs/wm8978.c                         |    1 +
 sound/soc/codecs/wm8990.c                         |    1 +
 sound/soc/codecs/wm8994.c                         |    1 +
 sound/soc/codecs/wm9081.c                         |    1 +
 sound/soc/soc-core.c                              |    1 +
 sound/soc/soc-dapm.c                              |    1 +
 sound/usb/caiaq/audio.c                           |    1 +
 sound/usb/usx2y/us122l.c                          |    1 +
 sound/usb/usx2y/usX2Yhwdep.c                      |    1 +
 sound/usb/usx2y/usbusx2y.c                        |    1 +
 sound/usb/usx2y/usbusx2yaudio.c                   |    1 +
 544 files changed, 576 insertions(+), 23 deletions(-)

=====================
PATCH CONTENT OMITTED
=====================
