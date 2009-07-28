Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbZG1Kig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbZG1Kig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZG1Kif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:38:35 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31728 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZG1Kid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:38:33 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:38:34 +0300
Message-Id: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 0/32] mmc and omap_hsmmc patches
X-OriginalArrivalTime: 28 Jul 2009 10:38:06.0768 (UTC) FILETIME=[7E446B00:01CA0F6F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is version 2 of our 32 patches for mmc and omap_hsmmc.

They include Matt Fleming's change for card caps, and 2 other fixes:
	- use a spin lock rather than enable / diable irq
	- make disable delay specified in milliseconds not jiffies because the
	value is an int, and jiffies are unsigned long (also millisecs are
	better anyway)

They split into 2 groups: the first 8 affect mmc core only
and the remaining ones affect omap_hsmmc only.

Adrian Hunter (19):
      mmc: add 'enable' and 'disable' methods to mmc host
      mmc: allow host claim / release nesting
      mmc: add MMC_CAP_NONREMOVABLE host capability
      mmc: add ability to save power by powering off cards
      mmc: check status after MMC SWITCH command
      omap_hsmmc: make use of new enable/disable interface
      omap_hsmmc: keep track of power mode
      omap_hsmmc: ensure workqueues are empty before suspend
      omap_hsmmc: make use of new MMC_CAP_NONREMOVABLE host capability
      ARM: OMAP: mmc-twl4030: add regulator sleep / wake function
      omap_hsmmc: put MMC regulator to sleep
      omap_hsmmc: clear interrupt status after init sequence
      omap_hsmmc: cater for weird CMD6 behaviour
      omap_hsmmc: prevent races with irq handler
      omap_hsmmc: pass host capabilities for SD only and MMC only
      omap_hsmmc: protect the card when the cover is open
      omap_hsmmc: ensure all clock enables and disables are paired
      omap_hsmmc: set a large data timeout for commands with busy signal
      ARM: OMAP: RX51: set MMC capabilities and power-saving flag

Denis Karpov (8):
      mmc: power off once at removal
      omap_hsmmc: add debugfs entry (host registers)
      ARM: OMAP: mmc-twl4030: add context loss counter support
      omap_hsmmc: context save/restore support
      omap_hsmmc: set open drain bit correctly
      omap_hsmmc: support for deeper power saving states
      omap_hsmmc: cleanup macro usage
      omap_hsmmc: code refactoring

Jarkko Lavinen (4):
      mmc: add mmc card sleep and awake support
      omap_hsmmc: fix scatter-gather list sanity checking
      omap_hsmmc: add mmc card sleep and awake support
      omap_hsmmc: fix NULL pointer dereference

Matt Fleming (1):
      mmc: add host capabilities for SD only and MMC only

 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +
 arch/arm/mach-omap2/mmc-twl4030.c            |   77 ++
 arch/arm/mach-omap2/mmc-twl4030.h            |    2 +
 arch/arm/plat-omap/include/mach/mmc.h        |   11 +
 drivers/mmc/core/core.c                      |  291 +++++++-
 drivers/mmc/core/core.h                      |    4 +
 drivers/mmc/core/host.c                      |    1 +
 drivers/mmc/core/host.h                      |    2 +
 drivers/mmc/core/mmc.c                       |  130 +++-
 drivers/mmc/core/mmc_ops.c                   |   59 ++
 drivers/mmc/core/mmc_ops.h                   |    1 +
 drivers/mmc/core/sd.c                        |   52 ++-
 drivers/mmc/host/at91_mci.c                  |    2 +-
 drivers/mmc/host/atmel-mci.c                 |    1 +
 drivers/mmc/host/au1xmmc.c                   |    3 +-
 drivers/mmc/host/cb710-mmc.c                 |    3 +-
 drivers/mmc/host/imxmmc.c                    |    3 +-
 drivers/mmc/host/mmc_spi.c                   |    2 +-
 drivers/mmc/host/mmci.c                      |    2 +
 drivers/mmc/host/mvsdio.c                    |    3 +-
 drivers/mmc/host/mxcmmc.c                    |    3 +-
 drivers/mmc/host/omap.c                      |    2 +-
 drivers/mmc/host/omap_hsmmc.c                | 1038 +++++++++++++++++++++-----
 drivers/mmc/host/pxamci.c                    |    2 +-
 drivers/mmc/host/s3cmci.c                    |    3 +-
 drivers/mmc/host/sdhci.c                     |    2 +-
 drivers/mmc/host/sdricoh_cs.c                |    3 +-
 drivers/mmc/host/tifm_sd.c                   |    3 +-
 drivers/mmc/host/tmio_mmc.c                  |    3 +-
 drivers/mmc/host/via-sdmmc.c                 |    3 +-
 drivers/mmc/host/wbsd.c                      |    3 +-
 include/linux/mmc/card.h                     |    2 +
 include/linux/mmc/core.h                     |    1 +
 include/linux/mmc/host.h                     |   61 ++
 include/linux/mmc/mmc.h                      |    3 +
 35 files changed, 1554 insertions(+), 232 deletions(-)


Regards
Adrian
