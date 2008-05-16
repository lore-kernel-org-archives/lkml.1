Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYEPPoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYEPPoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbYEPPoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:44:09 -0400
Received: from vena.lwn.net ([206.168.112.25]:35347 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYEPPoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:44:07 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH, RFC] char dev BKL pushdown 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 14 May 2008 14:56:37 PDT."
             <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org> 
Date: Fri, 16 May 2008 09:44:06 -0600
Message-ID: <16082.1210952646@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus said:

> So it literally should be:
>  - remove one lock_kernel/unlock_kernel pair in fs/char_dev.c
>  - add max 83 pairs in the places that register those things

...and so that's what I've done.  My approach was to find every
register_chrdev() and cdev_add() call, look at the associated
file_operations, then go back to the open() function, if any.  Unless it
was almost immediately obvious to me that the function was either (1) so
trivial as to not require locking (quite few of them are "return 0;"), or
(2) clearly doing its own locking, I wrapped the code in the BKL.

Finally, I removed the BKL from chrdev_open().

Allmodconfig and allyesconfig makes work here, and this kernel runs on my
dual-core desktop.  But, clearly, I don't have all of this hardware.
Actually, I wonder if some of it still exists outside of museums.  So
there's probably something stupid in there somewhere.

The result is available at:

	git://git.lwn.net/linux-2.6.git cdev

I'll put a shortlog and diffstat at the end of this message.  For
completeness, there's also a list of files I examined and did *not* change.

Assuming nobody tells me I'm completely off-base, I guess my next step is
to start running individual patches past maintainers.  Some of them,
probably (I hope), will tell me that I've been wasting my time and that
their code doesn't need the BKL.  In such cases, I'll gladly drop the
associated patch.  But there's a fair amount of stuff here which clearly
*does* need it still.  If all seems well, maybe this tree should get into
linux-next at some point too.

Comments?

The changes come out to this:

 arch/cris/arch-v10/drivers/gpio.c         |    3 ++
 arch/cris/arch-v10/drivers/sync_serial.c  |   34 ++++++++++++++++----------
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |    4 +++
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |    5 +++
 arch/cris/arch-v32/drivers/sync_serial.c  |   33 +++++++++++++++-----------
 arch/mips/kernel/rtlx.c                   |    7 ++++-
 arch/mips/kernel/vpe.c                    |   12 +++++++--
 arch/mips/sibyte/common/sb_tbprof.c       |   25 ++++++++++++++-----
 arch/sh/boards/landisk/gio.c              |   10 +++++--
 arch/x86/kernel/cpuid.c                   |   25 +++++++++++++------
 arch/x86/kernel/msr.c                     |   16 +++++++++---
 block/bsg.c                               |    7 ++++-
 drivers/block/aoe/aoechr.c                |    7 ++++-
 drivers/block/paride/pg.c                 |   22 ++++++++++++-----
 drivers/block/paride/pt.c                 |    8 +++++-
 drivers/char/drm/drm_fops.c               |    9 +++++--
 drivers/char/ipmi/ipmi_devintf.c          |    8 ++++--
 drivers/char/lp.c                         |   38 ++++++++++++++++++++----------
 drivers/char/mbcs.c                       |    5 +++
 drivers/char/mem.c                        |   10 ++++++-
 drivers/char/misc.c                       |    3 ++
 drivers/char/pcmcia/cm4000_cs.c           |   26 +++++++++++++++-----
 drivers/char/pcmcia/cm4040_cs.c           |   23 +++++++++++++-----
 drivers/char/snsc.c                       |    5 +++
 drivers/char/tty_io.c                     |   27 +++++++++++++++++++--
 drivers/char/viotape.c                    |    3 ++
 drivers/firewire/fw-cdev.c                |   16 +++++++++---
 drivers/hid/hidraw.c                      |    3 ++
 drivers/i2c/i2c-dev.c                     |   22 ++++++++++++-----
 drivers/ide/ide-tape.c                    |    7 ++++-
 drivers/ieee1394/dv1394.c                 |    6 +++-
 drivers/ieee1394/raw1394.c                |    3 ++
 drivers/ieee1394/video1394.c              |   18 ++++++++++----
 drivers/input/input.c                     |   16 +++++++++---
 drivers/isdn/i4l/isdn_common.c            |    3 +-
 drivers/media/dvb/dvb-core/dvbdev.c       |    4 +++
 drivers/mtd/mtdchar.c                     |   22 ++++++++++++-----
 drivers/mtd/ubi/cdev.c                    |    7 ++++-
 drivers/net/wan/cosa.c                    |   22 ++++++++++++-----
 drivers/pcmcia/pcmcia_ioctl.c             |   25 ++++++++++++++-----
 drivers/rtc/rtc-dev.c                     |   12 +++++++--
 drivers/s390/char/fs3270.c                |   23 ++++++++++++------
 drivers/s390/char/tape_char.c             |   12 +++++++--
 drivers/s390/char/vmlogrdr.c              |    8 +++++-
 drivers/s390/char/vmur.c                  |   12 +++++++--
 drivers/scsi/aacraid/linit.c              |    3 ++
 drivers/scsi/gdth.c                       |    3 ++
 drivers/scsi/osst.c                       |   15 +++++++++++
 drivers/scsi/sg.c                         |   16 ++++++++++--
 drivers/scsi/st.c                         |   11 +++++++-
 drivers/telephony/phonedev.c              |    3 ++
 drivers/uio/uio.c                         |   17 +++++++++----
 drivers/usb/core/file.c                   |    3 ++
 drivers/video/fbmem.c                     |   15 ++++++++---
 fs/char_dev.c                             |    8 ++----
 sound/core/sound.c                        |   15 +++++++++++
 sound/sound_core.c                        |    5 +++
 57 files changed, 554 insertions(+), 176 deletions(-)

The associated shortlog is:

Jonathan Corbet (43):
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
      viotape: cdev lock_kernel pushdown
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
      Remove the lock_kernel() call from chrdev_open()
      Add a comment in chrdev_open()

Char device source files which I did *not* change:

	arch/cris/arch-v32/drivers/pcf8563.c (no open function)
	arch/cris/arch-v32/drivers/i2c.c (empty open function)
	arch/cris/arch-v32/drivers/cryptocop.c (almost-empty open function)
	arch/cris/arch-v10/drivers/pcf8563.c  (no open function)
	arch/cris/arch-v10/drivers/i2c.c (empty open function)
	arch/cris/arch-v10/drivers/ds1302.c (no open function)
	arch/cris/arch-v10/drivers/eeprom.c (trivial)
	drivers/net/ppp_generic.c (trivial)
	drivers/ieee1394/ieee1394_core.c (almost-trivial)
	drivers/spi/spidev.c  (locking looks right)
	drivers/char/cs5535_gpio.c (trivial)
	drivers/char/dtlk.c (trivial, broken open)
	drivers/char/ds1302.c (no open)
	drivers/char/pc8736x_gpio.c (trivial)
	drivers/char/stallion.c (no open)
	drivers/char/tb0219.c (trivial open)
	drivers/char/vc_screen.c (trivial open)
	drivers/char/ppdev.c (trivial open)
	drivers/char/ip2/ip2main.c (trivial open - does not do anything!)
	drivers/char/scx200_gpio.c (trivial open)
	drivers/char/xilinx_hwicap/xilinx_hwicap.c (locking looks right)
	drivers/char/istallion.c (no open)
	drivers/char/vr41xx_giu.c (trivial)
	drivers/char/tlclk.c (locking looks right)
	drivers/char/raw.c (obvious locking w/raw_mutex)
	drivers/char/dsp56k.c (single-use locking)
	drivers/infiniband/hw/ipath/ipath_file_ops.c (trivial open)
	drivers/infiniband/core/user_mad.c (appears to have good locking)
	drivers/infiniband/core/uverbs_main.c (ditto)
	drivers/infiniband/core/ucm.c (trivial open)
	drivers/misc/phantom.c (has locking)
	drivers/sbus/char/bpp.c (has locking)
	drivers/sbus/char/vfc_dev.c (has locking)
	drivers/scsi/dpt_i2o.c (has locking)
	drivers/scsi/3w-xxxx.c (trivial open)
	drivers/scsi/3w-9xxx.c (trivial open)
	drivers/scsi/megaraid/megaraid_sas.c (trivial open)
	drivers/scsi/ch.c (has locking)
	drivers/scsi/megaraid.c (trivial open)
	drivers/isdn/capi/capi.c (semi-trivial open)
	drivers/isdn/hardware/eicon/divasi.c (empty open)
	drivers/isdn/hardware/eicon/divamnt.c (single-use open)
	drivers/isdn/hardware/eicon/divasmain.c (empty open)
	drivers/macintosh/adb.c (trivial open)
	drivers/usb/gadget/printer.c (has locking)
	drivers/usb/mon/mon_bin.c (has locking)
	drivers/usb/core/endpoint.c (no opens)
	drivers/usb/core/devio.c (has locking)
	drivers/media/video/videodev.c (has locking)
	fs/coda/psdev.c (already has lock_kernel() calls)

jon
