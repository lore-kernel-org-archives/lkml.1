Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYHGQ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYHGQ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYHGQ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:58:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHGQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:58:41 -0400
Subject: [GIT PULL]: firmware patches for building firmware into kernel
From: Jaswinder Singh <jaswinder@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 22:26:59 +0530
Message-Id: <1218128219.14483.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Please pull these firmware patches.

Fixed following Issues and more features can be added :-

1. defined FIRMWARE_NAME so it will easy handling

2. No need to check release_firmware for NON NULL:

	if (fw)
		release_firmware(fw);

Now we can simply call:

	release_firmware(fw);

3. Can do multiple request_firmware but it will use old copy and
return old fw for same FW_NAME and increment count.
And release_firmware will only release_firmware when count 
becomes 1 otherwise decrement count.

	request_firmware(&fw, FW_NAME, &dev);
		request_firmware(&fw, FW_NAME, &dev);
			request_firmware(&fw, FW_NAME, &dev);
				request_firmware(&fw, FW_NAME, &dev);

				release_firmware(fw);
			release_firmware(fw);
		release_firmware(fw);
	release_firmware(fw);

4. Introducing release_firmware_all and release firmware at one short:

	request_firmware(&fw, FW_NAME, &dev);
		request_firmware(&fw, FW_NAME, &dev);
			request_firmware(&fw, FW_NAME, &dev);
				request_firmware(&fw, FW_NAME, &dev);

	release_firmware_all(fw);

5. No need to check release_firmware_all for NON NULL:

	if (fw)
		release_firmware_all(fw);

Now we can simply call:

	release_firmware_all(fw);

6. Defined firmware handle in structure for handling where ever required.

The following changes since commit 5b664cb235e97afbf34db9c4d77f08ebd725335e:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../mfasheh/ocfs2

are available in the git repository at:

  git://git.infradead.org/users/jaswinder/firm-jsr-2.6.git master

Jaswinder Singh (18):
      firmware: avoiding multiple replication for same firmware file
      firmware: convert e100 driver to request_firmware()
      firmware: convert acenic driver to request_firmware()
      firmware: convert tg3 driver to request_firmware()
      firmware: convert av7110 driver to request_firmware()
      Remove fdump tool for av7110 firmware
      qla1280: use request_firmware
      advansys: use request_firmware
      qlogicpti: use request_firmware
      starfire: use request_firmware()
      cassini: use request_firmware
      myri_sbus: use request_firmware
      tehuti: use request_firmware
      typhoon: use request_firmware
      smc91c92_cs: use request_firmware
      yam: use request_firmware
      3C359: use request_firmware
      radeon_cp: use request_firmware

 drivers/base/firmware_class.c             |  156 +-
 drivers/gpu/drm/radeon/radeon_cp.c        |  151 +-
 drivers/gpu/drm/radeon/radeon_drv.h       |    6 +
 drivers/gpu/drm/radeon/radeon_microcode.h | 1844 -----
 drivers/media/dvb/ttpci/Kconfig           |   24 +-
 drivers/media/dvb/ttpci/Makefile          |    9 -
 drivers/media/dvb/ttpci/av7110.c          |   16 -
 drivers/media/dvb/ttpci/av7110_hw.c       |   35 +-
 drivers/media/dvb/ttpci/av7110_hw.h       |    3 +-
 drivers/media/dvb/ttpci/fdump.c           |   44 -
 drivers/net/acenic.c                      |  122 +-
 drivers/net/acenic.h                      |    4 +
 drivers/net/acenic_firmware.h             | 9456 -------------------------
 drivers/net/cassini.c                     |   44 +-
 drivers/net/cassini.h                     | 1520 +----
 drivers/net/e100.c                        |  291 +-
 drivers/net/hamradio/yam.c                |   88 +-
 drivers/net/hamradio/yam1200.h            |  343 -
 drivers/net/hamradio/yam9600.h            |  343 -
 drivers/net/myri_code.h                   | 5006 --------------
 drivers/net/myri_sbus.c                   |   45 +-
 drivers/net/pcmcia/ositech.h              |  358 -
 drivers/net/pcmcia/smc91c92_cs.c          |   46 +-
 drivers/net/starfire.c                    |   68 +-
 drivers/net/starfire_firmware.h           |  346 -
 drivers/net/starfire_firmware.pl          |   31 -
 drivers/net/tehuti.c                      |   43 +-
 drivers/net/tehuti.h                      |    1 +
 drivers/net/tehuti_fw.h                   |10712 -----------------------------
 drivers/net/tg3.c                         |  792 +--
 drivers/net/tg3.h                         |    4 +
 drivers/net/tokenring/3c359.c             |   53 +-
 drivers/net/tokenring/3c359.h             |    3 +
 drivers/net/tokenring/3c359_microcode.h   | 1581 -----
 drivers/net/typhoon-firmware.h            | 3778 ----------
 drivers/net/typhoon.c                     |   32 +-
 drivers/scsi/advansys.c                   | 1737 +-----
 drivers/scsi/ql1040_fw.h                  | 2130 ------
 drivers/scsi/ql12160_fw.h                 | 1811 -----
 drivers/scsi/ql1280_fw.h                  | 2048 ------
 drivers/scsi/qla1280.c                    |  121 +-
 drivers/scsi/qla1280.h                    |    6 +
 drivers/scsi/qlogicpti.c                  |   65 +-
 drivers/scsi/qlogicpti_asm.c              | 1160 ----
 firmware/3com/3C359.bin.ihex              | 1573 +++++
 firmware/3com/typhoon.bin.ihex            | 2819 ++++++++
 firmware/Makefile                         |   30 +
 firmware/WHENCE                           |  273 +
 firmware/acenic/tg1.bin.ihex              | 4573 ++++++++++++
 firmware/acenic/tg2.bin.ihex              | 4844 +++++++++++++
 firmware/adaptec/starfire_rx.bin.ihex     |   53 +
 firmware/adaptec/starfire_tx.bin.ihex     |   53 +
 firmware/advansys/3550.bin.ihex           |  317 +
 firmware/advansys/38C0800.bin.ihex        |  336 +
 firmware/advansys/38C1600.bin.ihex        |  398 ++
 firmware/advansys/mcode.bin.ihex          |  147 +
 firmware/av7110/Boot.S                    |  109 +
 firmware/av7110/bootcode.bin.ihex         |   15 +
 firmware/e100/d101m_ucode.bin.ihex        |   38 +
 firmware/e100/d101s_ucode.bin.ihex        |   38 +
 firmware/e100/d102e_ucode.bin.ihex        |   38 +
 firmware/myricom/lanai.bin.ihex           | 4771 +++++++++++++
 firmware/ositech/Xilinx7OD.bin.ihex       |  177 +
 firmware/qlogic/1040.bin.ihex             | 2111 ++++++
 firmware/qlogic/12160.bin.ihex            | 1771 +++++
 firmware/qlogic/1280.bin.ihex             | 2008 ++++++
 firmware/qlogic/isp1000.bin.ihex          | 1158 ++++
 firmware/radeon/R100_cp.bin.ihex          |  130 +
 firmware/radeon/R200_cp.bin.ihex          |  130 +
 firmware/radeon/R300_cp.bin.ihex          |  130 +
 firmware/radeon/R420_cp.bin.ihex          |  130 +
 firmware/radeon/R520_cp.bin.ihex          |  130 +
 firmware/radeon/RS600_cp.bin.ihex         |  130 +
 firmware/radeon/RS690_cp.bin.ihex         |  130 +
 firmware/sun/cassini.bin.ihex             |  143 +
 firmware/tehuti/bdx.bin.ihex              | 2678 +++++++
 firmware/tigon/tg3.bin.ihex               |  175 +
 firmware/tigon/tg3_tso.bin.ihex           |  446 ++
 firmware/tigon/tg3_tso5.bin.ihex          |  252 +
 firmware/yam/1200.bin.ihex                |  342 +
 firmware/yam/9600.bin.ihex                |  342 +
 include/linux/firmware.h                  |    5 +
 82 files changed, 34045 insertions(+), 45374 deletions(-)
 delete mode 100644 drivers/gpu/drm/radeon/radeon_microcode.h
 delete mode 100644 drivers/media/dvb/ttpci/fdump.c
 delete mode 100644 drivers/net/acenic_firmware.h
 delete mode 100644 drivers/net/hamradio/yam1200.h
 delete mode 100644 drivers/net/hamradio/yam9600.h
 delete mode 100644 drivers/net/myri_code.h
 delete mode 100644 drivers/net/pcmcia/ositech.h
 delete mode 100644 drivers/net/starfire_firmware.h
 delete mode 100644 drivers/net/starfire_firmware.pl
 delete mode 100644 drivers/net/tehuti_fw.h
 delete mode 100644 drivers/net/tokenring/3c359_microcode.h
 delete mode 100644 drivers/net/typhoon-firmware.h
 delete mode 100644 drivers/scsi/ql1040_fw.h
 delete mode 100644 drivers/scsi/ql12160_fw.h
 delete mode 100644 drivers/scsi/ql1280_fw.h
 delete mode 100644 drivers/scsi/qlogicpti_asm.c
 create mode 100644 firmware/3com/3C359.bin.ihex
 create mode 100644 firmware/3com/typhoon.bin.ihex
 create mode 100644 firmware/acenic/tg1.bin.ihex
 create mode 100644 firmware/acenic/tg2.bin.ihex
 create mode 100644 firmware/adaptec/starfire_rx.bin.ihex
 create mode 100644 firmware/adaptec/starfire_tx.bin.ihex
 create mode 100644 firmware/advansys/3550.bin.ihex
 create mode 100644 firmware/advansys/38C0800.bin.ihex
 create mode 100644 firmware/advansys/38C1600.bin.ihex
 create mode 100644 firmware/advansys/mcode.bin.ihex
 create mode 100644 firmware/av7110/Boot.S
 create mode 100644 firmware/av7110/bootcode.bin.ihex
 create mode 100644 firmware/e100/d101m_ucode.bin.ihex
 create mode 100644 firmware/e100/d101s_ucode.bin.ihex
 create mode 100644 firmware/e100/d102e_ucode.bin.ihex
 create mode 100644 firmware/myricom/lanai.bin.ihex
 create mode 100644 firmware/ositech/Xilinx7OD.bin.ihex
 create mode 100644 firmware/qlogic/1040.bin.ihex
 create mode 100644 firmware/qlogic/12160.bin.ihex
 create mode 100644 firmware/qlogic/1280.bin.ihex
 create mode 100644 firmware/qlogic/isp1000.bin.ihex
 create mode 100644 firmware/radeon/R100_cp.bin.ihex
 create mode 100644 firmware/radeon/R200_cp.bin.ihex
 create mode 100644 firmware/radeon/R300_cp.bin.ihex
 create mode 100644 firmware/radeon/R420_cp.bin.ihex
 create mode 100644 firmware/radeon/R520_cp.bin.ihex
 create mode 100644 firmware/radeon/RS600_cp.bin.ihex
 create mode 100644 firmware/radeon/RS690_cp.bin.ihex
 create mode 100644 firmware/sun/cassini.bin.ihex
 create mode 100644 firmware/tehuti/bdx.bin.ihex
 create mode 100644 firmware/tigon/tg3.bin.ihex
 create mode 100644 firmware/tigon/tg3_tso.bin.ihex
 create mode 100644 firmware/tigon/tg3_tso5.bin.ihex
 create mode 100644 firmware/yam/1200.bin.ihex
 create mode 100644 firmware/yam/9600.bin.ihex

Thank you,

Jaswinder Singh.

