Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYGNXXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYGNXXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbYGNXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:23:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbYGNXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:23:40 -0400
Subject: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
	use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 14 Jul 2008 16:23:26 -0700
Message-Id: <1216077806.27455.85.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-2.6.27 branch of:
	git://git.infradead.org/users/dwmw2/firmware-2.6.git for-2.6.27

This does the following (not quite in this order):

 - Provides a method for firmware files to be built into the kernel, so
   that drivers can be updated to use request_firmware() without forcing
   people to use an initrd.

 - In doing that, mark fw->data as 'const', and fix a few drivers to cope.

 - Update a bunch of drivers to use request_firmware(), and move their
   existing firmware, previously hardcoded in all kinds of interesting
   ways, into the firmware/ directory of the kernel tree.

 - Add a FIRMWARE_IN_KERNEL config option which allows the firmware for
   the above (and below) drivers to continue to be built into the kernel.

 - Add a simple method for representing Intel HEX records in binary form,
   since a bunch of drivers need that kind of thing. And a tool to
   convert HEX files into that binary form, for the kernel to load.

 - Drop special cases from a few drivers which could either use
   request_firmware() or build their firmware in; they don't need to
   do that for themselves any more.

 - Implement 'make firmware_install' target, which installs all firmware
   shipped with the kernel.

 - Modify 'make modules_install' to install any firmware required by the
   modules it installs (where that firmware is shipped in the kernel tree).

There are more drivers to be converted to request_firmware() -- notably
drivers/net and drivers/scsi, but it's probably best to ensure that the
infrastructure is all in place and working correctly before we update
those. (Although since modern drivers have been using request_firmware()
for some time, I don't think there's likely to be a problem there; we'll
probably clean up the stragglers in time for 2.6.28.)

David Howells (5):
      Fix a const pointer usage warning in the Digigram VX soundcard driver
      Fix a const assignment in moxa_load_fw()
      Fix a const pointer error in the Conexant cx23418 MPEG encoder driver
      Fix a const pointer usage warning in the Digigram pcxhr soundcard driver
      Fix a const pointer usage warning in the Digigram miXart soundcard driver

Full shortlog and diffstat below, although the really interesting part
is probably between commits fd4f80de..59890f74 -- seen at 
http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=shortlog;h=59890f74

David Woodhouse (52):
      libertas: treat firmware data as const
      bluetooth: treat firmware data as const
      cyclades: treat firmware data as const
      cx25840: treat firmware data as const
      myri10ge: treat firmware data as const
      vx222: treat firmware data as const
      riptide: treat firmware data as const
      pcxhr: treat firmware data as const
      vx: treat firmware data as const
      ueagle-atm: treat firmware data as const
      cxacru: treat firmware data as const
      aic94xx: treat firmware data as const
      zd1201: treat firmware data as const
      rt2x00: treat firmware data as const
      p54: treat firmware data as const
      atmel: treat firmware data as const
      irda-usb: treat firmware data as const
      cxgb3: treat firmware data as const
      bt8xx: treat firmware data as const
      ttusb-dec: treat firmware data as const
      dvb frontends: treat firmware data as const
      cxusb: treat firmware data as const
      gp8psk: treat firmware data as const
      tuners: treat firmware data as const
      maestro3: treat firmware data as const
      ymfpci: treat firmware data as const
      firmware: make fw->data const
      firmware: allow firmware files to be built into kernel image
      firmware: Add CONFIG_EXTRA_FIRMWARE option
      firmware: Add CONFIG_FIRMWARE_IN_KERNEL option.
      firmware: Add firmware installation to modules_install, add firmware_install
      ihex.h: binary representation of ihex records
      ihex: request_ihex_firmware() function to load and validate firmware
      ihex: add ihex2fw tool for converting HEX files into firmware images
      ihex: Add support for long records to ihex2fw.c
      firmware: convert korg1212 driver to use firmware loader exclusively
      firmware: convert maestro3 driver to use firmware loader exclusively
      firmware: convert ymfpci driver to use firmware loader exclusively
      smctr: use request_firmware()
      kaweth: use request_firmware()
      ttusb-budget: use request_firmware()
      keyspan: use request_firmware()
      keyspan_pda: use request_firmware()
      emi26: use request_firmware()
      emi62: use request_firmware()
      ti_usb_3410_5052: use request_firmware()
      whiteheat: use request_firmware()
      firmware: convert Ambassador ATM driver to request_firmware()
      ip2: use request_firmware()
      cpia2: use request_firmware()
      dabusb: use request_firmware()
      Merge git://git.kernel.org/.../torvalds/linux-2.6.git

Greg Kroah-Hartman (3):
      dell_rbu: firmware data is const
      x86 microcode: firmware data is const
      isight: treat firmware data as const

Jaswinder Singh (5):
      vicam: use request_firmware()
      edgeport: use request_firmware()
      edgeport-ti: use request_firmware()
      dsp56k: use request_firmware
      firmware: convert sb16_csp driver to use firmware loader exclusively

 Makefile                                           |   15 +-
 arch/x86/kernel/microcode.c                        |    4 +-
 drivers/atm/Makefile                               |    6 +-
 drivers/atm/ambassador.c                           |  140 +-
 drivers/atm/ambassador.h                           |   11 -
 drivers/atm/atmsar11.data                          | 2063 -----
 drivers/atm/atmsar11.regions                       |    6 -
 drivers/atm/atmsar11.start                         |    4 -
 drivers/base/Kconfig                               |   64 +
 drivers/base/firmware_class.c                      |   35 +-
 drivers/bluetooth/bfusb.c                          |    3 +-
 drivers/bluetooth/bt3c_cs.c                        |    3 +-
 drivers/char/cyclades.c                            |   10 +-
 drivers/char/dsp56k.c                              |   84 +-
 drivers/char/ip2/fip_firm.h                        | 2149 -----
 drivers/char/ip2/ip2base.c                         |    5 +-
 drivers/char/ip2/ip2main.c                         |   47 +-
 drivers/char/moxa.c                                |    4 +-
 drivers/firmware/dell_rbu.c                        |    2 +-
 drivers/media/common/tuners/tuner-xc2028.c         |    2 +-
 drivers/media/common/tuners/xc5000.c               |    2 +-
 drivers/media/dvb/dvb-usb/cxusb.c                  |   21 +-
 drivers/media/dvb/dvb-usb/gp8psk.c                 |    3 +-
 drivers/media/dvb/frontends/bcm3510.c              |    5 +-
 drivers/media/dvb/frontends/nxt200x.c              |    3 +-
 drivers/media/dvb/frontends/or51211.c              |    4 +-
 drivers/media/dvb/frontends/sp8870.c               |    2 +-
 drivers/media/dvb/frontends/sp887x.c               |    2 +-
 drivers/media/dvb/frontends/tda10048.c             |    2 +-
 drivers/media/dvb/frontends/tda1004x.c             |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |   16 +-
 .../media/dvb/ttusb-budget/dvb-ttusb-dspbootcode.h | 1644 ----
 drivers/media/dvb/ttusb-dec/ttusb_dec.c            |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c             |    3 +-
 drivers/media/video/cpia2/cpia2_core.c             |   46 +-
 drivers/media/video/cpia2/cpia2patch.h             |  233 -
 drivers/media/video/cx18/cx18-av-firmware.c        |    2 +-
 drivers/media/video/cx25840/cx25840-firmware.c     |   27 +-
 drivers/media/video/dabfirmware.h                  | 1415 ----
 drivers/media/video/dabusb.c                       |   44 +-
 drivers/media/video/usbvideo/vicam.c               |  317 +-
 drivers/net/cxgb3/common.h                         |    5 +-
 drivers/net/cxgb3/t3_hw.c                          |    7 +-
 drivers/net/irda/irda-usb.c                        |   12 +-
 drivers/net/myri10ge/myri10ge.c                    |   11 +-
 drivers/net/tokenring/smctr.c                      |   56 +-
 drivers/net/tokenring/smctr.h                      |    2 -
 drivers/net/tokenring/smctr_firmware.h             |  978 ---
 drivers/net/usb/kaweth.c                           |   43 +-
 drivers/net/usb/kawethfw.h                         |  557 --
 drivers/net/wireless/atmel.c                       |    6 +-
 drivers/net/wireless/libertas/if_cs.c              |    2 +-
 drivers/net/wireless/libertas/if_sdio.c            |    4 +-
 drivers/net/wireless/libertas/if_usb.c             |    4 +-
 drivers/net/wireless/p54/p54usb.c                  |    5 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |    4 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    6 +-
 drivers/net/wireless/zd1201.c                      |    2 +-
 drivers/scsi/aic94xx/aic94xx_sds.c                 |   12 +-
 drivers/scsi/aic94xx/aic94xx_sds.h                 |    4 +-
 drivers/scsi/aic94xx/aic94xx_seq.c                 |    7 +-
 drivers/usb/atm/cxacru.c                           |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |   20 +-
 drivers/usb/misc/emi26.c                           |   96 +-
 drivers/usb/misc/emi26_fw.h                        | 5779 -------------
 drivers/usb/misc/emi62.c                           |  130 +-
 drivers/usb/misc/emi62_fw_m.h                      | 8853 --------------------
 drivers/usb/misc/emi62_fw_s.h                      | 8837 -------------------
 drivers/usb/misc/isight_firmware.c                 |    2 +-
 drivers/usb/serial/Kconfig                         |   24 +-
 drivers/usb/serial/io_edgeport.c                   |  183 +-
 drivers/usb/serial/io_fw_boot.h                    |  556 --
 drivers/usb/serial/io_fw_boot2.h                   |  546 --
 drivers/usb/serial/io_fw_down.h                    | 1229 ---
 drivers/usb/serial/io_fw_down2.h                   | 1133 ---
 drivers/usb/serial/io_fw_down3.h                   |  847 --
 drivers/usb/serial/io_ti.c                         |   73 +-
 drivers/usb/serial/keyspan.c                       |   78 +-
 drivers/usb/serial/keyspan.h                       |   84 -
 drivers/usb/serial/keyspan_mpr_fw.h                |  286 -
 drivers/usb/serial/keyspan_pda.S                   | 1124 ---
 drivers/usb/serial/keyspan_pda.c                   |   51 +-
 drivers/usb/serial/keyspan_pda_fw.h                |   99 -
 drivers/usb/serial/keyspan_usa18x_fw.h             |  447 -
 drivers/usb/serial/keyspan_usa19_fw.h              |  285 -
 drivers/usb/serial/keyspan_usa19qi_fw.h            |  284 -
 drivers/usb/serial/keyspan_usa19qw_fw.h            |  448 -
 drivers/usb/serial/keyspan_usa19w_fw.h             |  446 -
 drivers/usb/serial/keyspan_usa28_fw.h              |  466 -
 drivers/usb/serial/keyspan_usa28x_fw.h             |  447 -
 drivers/usb/serial/keyspan_usa28xa_fw.h            |  449 -
 drivers/usb/serial/keyspan_usa28xb_fw.h            |  448 -
 drivers/usb/serial/keyspan_usa49w_fw.h             |  464 -
 drivers/usb/serial/keyspan_usa49wlc_fw.h           |  476 --
 drivers/usb/serial/ti_fw_3410.h                    |  885 --
 drivers/usb/serial/ti_fw_5052.h                    |  885 --
 drivers/usb/serial/ti_usb_3410_5052.c              |   40 +-
 drivers/usb/serial/whiteheat.c                     |   77 +-
 drivers/usb/serial/whiteheat_fw.h                  | 1669 ----
 drivers/usb/serial/xircom_pgs.S                    | 1192 ---
 drivers/usb/serial/xircom_pgs_fw.h                 |  103 -
 firmware/Makefile                                  |  177 +
 firmware/WHENCE                                    |  341 +
 firmware/atmsar11.HEX                              |  204 +
 firmware/cpia2/stv0672_vp4.bin.ihex                |   73 +
 firmware/dabusb/bitstream.bin.ihex                 |  761 ++
 firmware/dabusb/firmware.HEX                       |  649 ++
 firmware/dsp56k/bootstrap.asm                      |   98 +
 firmware/dsp56k/bootstrap.bin.ihex                 |   26 +
 firmware/edgeport/boot.H16                         |   29 +
 firmware/edgeport/boot2.H16                        |   28 +
 firmware/edgeport/down.H16                         |   29 +
 firmware/edgeport/down2.H16                        |   29 +
 firmware/edgeport/down3.bin.ihex                   |  815 ++
 firmware/emi26/bitstream.HEX                       | 4391 ++++++++++
 firmware/emi26/firmware.HEX                        | 1261 +++
 firmware/emi26/loader.HEX                          |  116 +
 firmware/emi62/bitstream.HEX                       | 4372 ++++++++++
 firmware/emi62/loader.HEX                          |  107 +
 firmware/emi62/midi.HEX                            | 1266 +++
 firmware/emi62/spdif.HEX                           | 1257 +++
 firmware/ess/maestro3_assp_kernel.fw.ihex          |  120 +
 firmware/ess/maestro3_assp_minisrc.fw.ihex         |   51 +
 firmware/ihex2fw.c                                 |  268 +
 firmware/intelliport2.bin.ihex                     | 2147 +++++
 firmware/kaweth/new_code.bin.ihex                  |  206 +
 firmware/kaweth/new_code_fix.bin.ihex              |   40 +
 firmware/kaweth/trigger_code.bin.ihex              |   13 +
 firmware/kaweth/trigger_code_fix.bin.ihex          |    3 +
 firmware/keyspan/mpr.HEX                           |  104 +
 firmware/keyspan/usa18x.HEX                        |  141 +
 firmware/keyspan/usa19.HEX                         |  101 +
 firmware/keyspan/usa19qi.HEX                       |  101 +
 firmware/keyspan/usa19qw.HEX                       |  142 +
 firmware/keyspan/usa19w.HEX                        |  141 +
 firmware/keyspan/usa28.HEX                         |  148 +
 firmware/keyspan/usa28x.HEX                        |  141 +
 firmware/keyspan/usa28xa.HEX                       |  141 +
 firmware/keyspan/usa28xb.HEX                       |  142 +
 firmware/keyspan/usa49w.HEX                        |  145 +
 firmware/keyspan/usa49wlc.HEX                      |  153 +
 firmware/keyspan_pda/keyspan_pda.HEX               |   83 +
 firmware/keyspan_pda/keyspan_pda.S                 | 1124 +++
 firmware/keyspan_pda/xircom_pgs.HEX                |   87 +
 firmware/keyspan_pda/xircom_pgs.S                  | 1192 +++
 firmware/korg/k1212.dsp.ihex                       |  987 +++
 firmware/sb16/alaw_main.csp.ihex                   |   87 +
 firmware/sb16/ima_adpcm_capture.csp.ihex           |  121 +
 firmware/sb16/ima_adpcm_init.csp.ihex              |   70 +
 firmware/sb16/ima_adpcm_playback.csp.ihex          |  122 +
 firmware/sb16/mulaw_main.csp.ihex                  |   84 +
 firmware/ti_3410.fw.ihex                           |  862 ++
 firmware/ti_5052.fw.ihex                           |  862 ++
 firmware/tr_smctr.bin.ihex                         |  477 ++
 firmware/ttusb-budget/dspbootcode.bin.ihex         |  820 ++
 firmware/vicam/firmware.H16                        |    7 +
 firmware/whiteheat.HEX                             | 1097 +++
 firmware/whiteheat_loader.HEX                      |  314 +
 firmware/whiteheat_loader_debug.HEX                |  403 +
 firmware/yamaha/ds1_ctrl.fw.ihex                   |  769 ++
 firmware/yamaha/ds1_dsp.fw.ihex                    |    9 +
 firmware/yamaha/ds1e_ctrl.fw.ihex                  |  769 ++
 include/asm-generic/vmlinux.lds.h                  |    7 +
 include/linux/firmware.h                           |   23 +-
 include/linux/ihex.h                               |   74 +
 scripts/Makefile.fwinst                            |   45 +
 sound/drivers/vx/vx_core.c                         |    4 +-
 sound/isa/Kconfig                                  |    9 -
 sound/isa/sb/sb16_csp.c                            |   22 -
 sound/isa/sb/sb16_csp_codecs.h                     |  949 ---
 sound/pci/Kconfig                                  |   30 -
 sound/pci/korg1212/korg1212-firmware.h             |  987 ---
 sound/pci/korg1212/korg1212.c                      |   18 -
 sound/pci/maestro3.c                               |  186 +-
 sound/pci/mixart/mixart_hwdep.c                    |    2 +-
 sound/pci/pcxhr/pcxhr_core.c                       |    4 +-
 sound/pci/pcxhr/pcxhr_hwdep.c                      |    2 +-
 sound/pci/riptide/riptide.c                        |   10 +-
 sound/pci/vx222/vx222_ops.c                        |    2 +-
 sound/pci/ymfpci/ymfpci_image.h                    | 1565 ----
 sound/pci/ymfpci/ymfpci_main.c                     |   74 +-
 183 files changed, 31965 insertions(+), 52599 deletions(-)


-- 
dwmw2 @linux.intel.com

