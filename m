Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYCMQMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYCMQMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYCMQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:11:26 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27732 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYCMQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:11:25 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 00/10] avr32: Power Management support
Date: Thu, 13 Mar 2008 15:39:35 +0100
Message-Id: <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0258 (UTC) FILETIME=[15448320:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for "standby" and "mem" power modes on
the AT32AP700x CPUs.

I've also included a couple of fixes that should go in through other
trees in order to ease testing:
  #1 fixes an oops on suspend and shutdown. Picked from the linux-mtd
     list.
  #2 is a quick-n-dirty hack for a build problem when CONFIG_PM=y
  #7 is a quick-n-dirty suspend/resume implementation for macb which
     prevents it from waking up the system all the time.

This patch series is meant to apply to the avr32-arch branch of the
avr32 tree. It won't apply to 2.6.24, and even if you fix the
conflicts it won't work because of Kconfig changes. I've made the
necessary fixes and pushed it out to

git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git atmel-2.6.24

and the result seems to work fine.

I haven't measured the time it takes to resume the system, but it
feels instantaneous, at least on the ATNGW100. The delay is more
noticeable on ATSTK1000 since it needs to power up the LCD panel
(the ltv350qv panel takes about 100 ms to power up).

Anton Vorontsov (1):
      mtd: maps/physmap: fix oops in suspend/resume/shutdown ops

Haavard Skinnemoen (9):
      atmel_serial: Fix build on avr32 with CONFIG_PM enabled
      avr32: Move setup_platform() into chip-specific file
      avr32: Rename at32ap.c -> pdc.c
      avr32: Enable SDRAMC clock at startup
      avr32: Add simple SRAM allocator
      macb: Basic suspend/resume support
      avr32: Define TIF_FREEZE
      avr32: Add system device for the internal interrupt controller (intc)
      avr32: Power Management support ("standby" and "mem" modes)

 arch/avr32/Kconfig                         |    6 +
 arch/avr32/mach-at32ap/Makefile            |    7 +-
 arch/avr32/mach-at32ap/at32ap700x.c        |   53 +++++-
 arch/avr32/mach-at32ap/intc.c              |   80 +++++++++-
 arch/avr32/mach-at32ap/{at32ap.c => pdc.c} |    8 -
 arch/avr32/mach-at32ap/pm-at32ap700x.S     |  108 ++++++++++++
 arch/avr32/mach-at32ap/pm.c                |  245 ++++++++++++++++++++++++++++
 arch/avr32/mach-at32ap/sdramc.h            |   76 +++++++++
 drivers/mtd/maps/physmap.c                 |   15 +-
 drivers/net/macb.c                         |   37 ++++
 drivers/serial/atmel_serial.c              |   11 +-
 include/asm-avr32/arch-at32ap/init.h       |    4 -
 include/asm-avr32/arch-at32ap/pm.h         |    3 +
 include/asm-avr32/arch-at32ap/sram.h       |   30 ++++
 include/asm-avr32/thread_info.h            |    1 +
 15 files changed, 649 insertions(+), 35 deletions(-)
 rename arch/avr32/mach-at32ap/{at32ap.c => pdc.c} (90%)
 create mode 100644 arch/avr32/mach-at32ap/pm.c
 create mode 100644 arch/avr32/mach-at32ap/sdramc.h
 create mode 100644 include/asm-avr32/arch-at32ap/sram.h
