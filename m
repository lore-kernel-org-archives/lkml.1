Return-Path: <linux-kernel-owner+w=401wt.eu-S933501AbYA2SK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbYA2SK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbYA2SK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:10:26 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54253 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754000AbYA2SKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:10:20 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: [RFC v2 0/5] dmaengine: Slave DMA interface and example users
Date: Tue, 29 Jan 2008 19:10:08 +0100
Message-Id: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds the necessary interfaces to the DMA Engine
framework to use functionality found on most embedded DMA controllers:
DMA from and to I/O registers with hardware handshaking.

In this context, hardware hanshaking means that the peripheral that
owns the I/O registers in question is able to tell the DMA controller
when more data is available for reading, or when there is room for
more data to be written. This usually happens internally on the chip,
but these signals may also be exported outside the chip for things
like IDE DMA, etc.

Since v1 that was posted in november last year, I've rebased it on top
of the four async_tx patches that were posted by Dan Williams in
december, and made a few changes to the "slave" part of the API:

  * Information about the slave device can now be found in struct
    dma_client if the DMA_SLAVE capability is set.
  * The dma_client struct is passed to device_alloc_chan_resources so
    that the DMA engine driver can find this information.
  * Because of this, the device_set_slave hook isn't needed anymore,
    so it has been removed.
  * The slave_set_width and slave_set_direction descriptor hooks have
    been removed for the same reasons the tx_set_src and tx_set_dest
    hooks were removed from the async_tx descriptor.

Which I hope will address the concerns Dan had about my first patch
series. I think this version is cleaner than the first one, and this
is confirmed by the fact that the dw_dmac driver is 60 lines shorter
than it was the first time around. The mmc driver is slightly shorter
too.

I would especially like some feedback on the first two patches in the
series, but if you find any issues with the rest of them, I would
certainly like to hear about those too.

The whole thing has been tested using an SD card with an ext3
filesystem on it: mke2fs, e2fsck and copying stuff around. The
filesystem errors I mentioned the last time around are gone, but I get
some warnings messages from the MMC driver that I need to investigate.
They don't seem to cause any actual harm though.

The patch series must be applied on top of Dan's "towards an async_tx
update for 2.6.25" patches:

http://lkml.org/lkml/2007/12/21/277

or you can simply pull from the master branch of my (temporary)
dmaslave git repository:

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/dmaslave.git master

which contains everything you need to try it out.

Haavard Skinnemoen (5):
      dmaengine: Add dma_client parameter to device_alloc_chan_resources
      dmaengine: Add slave DMA interface
      dmaengine: Make DMA Engine menu visible for AVR32 users
      dmaengine: Driver for the Synopsys DesignWare DMA controller
      Atmel MCI: Driver for Atmel on-chip MMC controllers

 arch/avr32/boards/atngw100/setup.c         |    6 +
 arch/avr32/boards/atstk1000/atstk1002.c    |    3 +
 arch/avr32/mach-at32ap/at32ap700x.c        |   60 +-
 drivers/dma/Kconfig                        |   11 +-
 drivers/dma/Makefile                       |    1 +
 drivers/dma/dmaengine.c                    |   11 +-
 drivers/dma/dw_dmac.c                      | 1120 +++++++++++++++++++++++++++
 drivers/dma/dw_dmac.h                      |  256 ++++++
 drivers/dma/ioat_dma.c                     |    5 +-
 drivers/dma/iop-adma.c                     |    7 +-
 drivers/mmc/host/Kconfig                   |   10 +
 drivers/mmc/host/Makefile                  |    1 +
 drivers/mmc/host/atmel-mci.c               | 1159 ++++++++++++++++++++++++++++
 drivers/mmc/host/atmel-mci.h               |  192 +++++
 include/asm-avr32/arch-at32ap/at32ap700x.h |   16 +
 include/asm-avr32/arch-at32ap/board.h      |   10 +-
 include/linux/dmaengine.h                  |   71 ++-
 17 files changed, 2911 insertions(+), 28 deletions(-)
 create mode 100644 drivers/dma/dw_dmac.c
 create mode 100644 drivers/dma/dw_dmac.h
 create mode 100644 drivers/mmc/host/atmel-mci.c
 create mode 100644 drivers/mmc/host/atmel-mci.h
