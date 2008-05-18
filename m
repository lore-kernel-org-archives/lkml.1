Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYERWPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYERWPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 18:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYERWPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 18:15:12 -0400
Received: from vena.lwn.net ([206.168.112.25]:43283 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYERWPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 18:15:09 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH, RFC] Char dev BKL pushdown v2
From: corbet@lwn.net (Jonathan Corbet)
Date: Sun, 18 May 2008 16:15:08 -0600
Message-ID: <19845.1211148908@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, since the previous announcement, I've revisited all of the open()
functions which didn't get lock_kernel() calls the first time around.
Alan pointed out that even a completely empty open() might, in fact,
need to acquire the BKL, so now they all do.  Hopefully, this completes
this work (at this level - there's plenty of down-pushing to do within
subsystems).

There's a new tree with this stuff:

	git://git.lwn.net/linux-2.6.git bkl-removal

Stephen, might it be about time to pull this into linux-next and see
what explodes?

If others have BKL-removal patches which look like 2.6.27 material, I'll
happily collect them in this tree.  

Thanks,

jon

P.S.  Here's what's in it now:

 arch/cris/arch-v10/drivers/eeprom.c          |    4 +-
 arch/cris/arch-v10/drivers/gpio.c            |    3 ++
 arch/cris/arch-v10/drivers/i2c.c             |    2 +
 arch/cris/arch-v10/drivers/sync_serial.c     |   34 ++++++++++++++----------
 arch/cris/arch-v32/drivers/cryptocop.c       |    3 +-
 arch/cris/arch-v32/drivers/i2c.c             |    2 +
 arch/cris/arch-v32/drivers/mach-a3/gpio.c    |    4 ++
 arch/cris/arch-v32/drivers/mach-fs/gpio.c    |    5 ++-
 arch/cris/arch-v32/drivers/sync_serial.c     |   33 ++++++++++++++---------
 arch/mips/kernel/rtlx.c                      |    7 ++++
 arch/mips/kernel/vpe.c                       |   12 ++++++--
 arch/mips/sibyte/common/sb_tbprof.c          |   25 ++++++++++++-----
 arch/sh/boards/landisk/gio.c                 |   10 ++++---
 arch/x86/kernel/cpuid.c                      |   25 ++++++++++++-----
 arch/x86/kernel/msr.c                        |   16 ++++++++---
 block/bsg.c                                  |    7 ++++
 drivers/block/aoe/aoechr.c                   |    7 ++++
 drivers/block/paride/pg.c                    |   22 +++++++++++----
 drivers/block/paride/pt.c                    |    8 ++++-
 drivers/char/cs5535_gpio.c                   |    2 +
 drivers/char/drm/drm_fops.c                  |    9 ++++--
 drivers/char/dsp56k.c                        |   14 +++++++--
 drivers/char/dtlk.c                          |    3 ++
 drivers/char/ip2/ip2main.c                   |   34 +-----------------------
 drivers/char/ipmi/ipmi_devintf.c             |    8 ++++-
 drivers/char/lp.c                            |   38 ++++++++++++++++++---------
 drivers/char/mbcs.c                          |    5 +++
 drivers/char/mem.c                           |   10 +++++--
 drivers/char/misc.c                          |    3 ++
 drivers/char/pc8736x_gpio.c                  |    2 +
 drivers/char/pcmcia/cm4000_cs.c              |   26 +++++++++++++-----
 drivers/char/pcmcia/cm4040_cs.c              |   23 ++++++++++++----
 drivers/char/ppdev.c                         |    2 +
 drivers/char/raw.c                           |    3 ++
 drivers/char/scx200_gpio.c                   |    2 +
 drivers/char/snsc.c                          |    5 ++-
 drivers/char/tb0219.c                        |    2 +
 drivers/char/tlclk.c                         |   19 ++++++++-----
 drivers/char/tty_io.c                        |   27 +++++++++++++++++--
 drivers/char/vc_screen.c                     |    9 ++++--
 drivers/char/viotape.c                       |    3 ++
 drivers/char/vr41xx_giu.c                    |    2 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c   |    6 +++-
 drivers/firewire/fw-cdev.c                   |   16 ++++++++---
 drivers/hid/hidraw.c                         |    3 ++
 drivers/i2c/i2c-dev.c                        |   22 +++++++++++----
 drivers/ide/ide-tape.c                       |    7 ++++
 drivers/ieee1394/dv1394.c                    |    6 +++-
 drivers/ieee1394/raw1394.c                   |    3 ++
 drivers/ieee1394/video1394.c                 |   18 +++++++++---
 drivers/infiniband/core/ucm.c                |    2 +
 drivers/infiniband/core/user_mad.c           |    7 ++++
 drivers/infiniband/core/uverbs_main.c        |    9 ++++--
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +
 drivers/input/input.c                        |   16 ++++++++---
 drivers/isdn/capi/capi.c                     |   17 +++++++-----
 drivers/isdn/hardware/eicon/divamnt.c        |   16 +++++++----
 drivers/isdn/hardware/eicon/divasi.c         |    2 +
 drivers/isdn/hardware/eicon/divasmain.c      |    2 +
 drivers/isdn/i4l/isdn_common.c               |    3 +-
 drivers/macintosh/adb.c                      |   18 +++++++++---
 drivers/media/dvb/dvb-core/dvbdev.c          |    4 ++
 drivers/media/video/videodev.c               |    4 ++
 drivers/misc/phantom.c                       |    9 ++++--
 drivers/mtd/mtdchar.c                        |   22 +++++++++++----
 drivers/mtd/ubi/cdev.c                       |    7 ++++
 drivers/net/ppp_generic.c                    |    2 +
 drivers/net/wan/cosa.c                       |   22 +++++++++++----
 drivers/pcmcia/pcmcia_ioctl.c                |   25 ++++++++++++-----
 drivers/rtc/rtc-dev.c                        |   12 ++++++--
 drivers/s390/char/fs3270.c                   |   23 +++++++++++-----
 drivers/s390/char/tape_char.c                |   12 ++++++--
 drivers/s390/char/vmlogrdr.c                 |    8 ++++-
 drivers/s390/char/vmur.c                     |   12 ++++++--
 drivers/sbus/char/bpp.c                      |    3 ++
 drivers/sbus/char/vfc_dev.c                  |    5 +++
 drivers/scsi/3w-9xxx.c                       |    3 ++
 drivers/scsi/3w-xxxx.c                       |    3 ++
 drivers/scsi/aacraid/linit.c                 |    3 ++
 drivers/scsi/ch.c                            |    4 ++
 drivers/scsi/dpt_i2o.c                       |    5 +++
 drivers/scsi/gdth.c                          |    3 ++
 drivers/scsi/megaraid.c                      |    5 ++-
 drivers/scsi/megaraid/megaraid_sas.c         |    2 +
 drivers/scsi/osst.c                          |   15 +++++++++-
 drivers/scsi/sg.c                            |   16 +++++++++--
 drivers/scsi/st.c                            |   11 ++++++-
 drivers/spi/spidev.c                         |    3 ++
 drivers/telephony/phonedev.c                 |    3 ++
 drivers/uio/uio.c                            |   17 ++++++++----
 drivers/usb/core/devio.c                     |    2 +
 drivers/usb/core/file.c                      |    3 ++
 drivers/usb/gadget/printer.c                 |    3 +-
 drivers/usb/mon/mon_bin.c                    |    6 ++++
 drivers/video/fbmem.c                        |   15 +++++++---
 fs/char_dev.c                                |    7 ++--
 include/linux/smp_lock.h                     |   13 +++++++++
 sound/core/sound.c                           |   15 +++++++++-
 sound/sound_core.c                           |    5 +++
 99 files changed, 739 insertions(+), 248 deletions(-)


Jonathan Corbet (65):
      bsg: cdev lock_kernel() pushdown
      cris: cdev lock_kernel() pushdown
      mips: cdev lock_kernel() pushdown
      sh: cdev lock_kernel() pushdown
      x86: cdev lock_kernel() pushdown
      i2c: cdev lock_kernel() pushdown
      cosa: cdev lock_kernel() pushdown
      pcmcia: cdev lock_kernel() pushdown
      ieee1394: cdev lock_kernel() pushdown
      rtc: cdev lock_kernel() pushdown
      drivers/s390: cdev lock_kernel() pushdown
      AoE: cdev lock_kernel() pushdown
      paride: cdev lock_kernel() pushdown
      mtdchar: cdev lock_kernel() pushdown
      UBI: cdev lock_kernel() pushdown
      firewire: cdev lock_kernel() pushdown
      HID: cdev lock_kernel() pushdown
      Input: cdev lock_kernel() pushdown
      UIO: cdev lock_kernel() pushdown
      cm40x0: cdev lock_kernel() pushdown
      ipmi: cdev lock_kernel() pushdown
      mem: cdev lock_kernel() pushdown
      misc: cdev lock_kernel() pushdown
      viotape: cdev lock_kernel pushdown ()
      mbcs: cdev lock_kernel() pushdown
      lp: cdev lock_kernel() pushdown
      drm: cdev lock_kernel() pushdown
      phonedev: cdev lock_kernel() pushdown
      ide-tape: cdev lock_kernel() pushdown
      sg: cdev lock_kernel() pushdown
      osst: cdev lock_kernel() pushdown.
      aacraid: cdev lock_kernel() pushdown
      st: cdev lock_kernel() pushdown
      gdth: cdev lock_kernel() pushdown
      isdn: cdev lock_kernel() pushdown
      usbcore: cdev lock_kernel() pushdown
      dvb: cdev lock_kernel() pushdown
      fbmem: cdev lock_kernel() pushdown
      sound: cdev lock_kernel() pushdown
      snsc: cdev lock_kernel() pushdown
      tty: cdev lock_kernel() pushdown
      Add "no BKL needed" comments to several drivers
      spidev: BKL pushdown
      vcs: BKL pushdown
      xilinx icap: BKL pushdown
      tlckl: BKL pushdown
      raw: BKL pushdown
      dsp56k: BKL pushdown
      infiniband: more BKL pushdown
      phantom: BKL pushdown
      bpp: bkl pushdown
      videopix: BKL pushdown
      dpt_i20: BKL pushdown
      changer: BKL pushdown
      CAPI: BKL pushdown
      divamnt: BKL pushdown
      adb: BKL pushdown
      printer gadget: BKL pushdown
      USB Monitor: BKL pushdown
      usbdev: BKL pushdown
      videodev: BKL pushdown
      Add cycle_kernel_lock()
      Add a bunch of cycle_kernel_lock() calls
      Add a comment in chrdev_open()
      Remove the lock_kernel() call from chrdev_open()

