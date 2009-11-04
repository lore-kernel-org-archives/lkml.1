Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZKDH6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZKDH6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZKDH6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:58:38 -0500
Received: from smtp.nokia.com ([192.100.105.134]:46766 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZKDH6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:58:36 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/4 v2] ASoC/MFD/OMAP: TWL4030: APLL_CTL handling change
Date: Wed,  4 Nov 2009 09:58:16 +0200
Message-Id: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 04 Nov 2009 07:58:26.0300 (UTC) FILETIME=[96C243C0:01CA5D24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes from the first series:
- Typos fixed and warning/error messages for APLL frequency mismatch
  now consistent
- twl4030-codec MFD driver audio_mclk validity check simplified
- Commit message for the twl4030-codec MFD driver has been changed also
- Patch: "ASoC: TWL4030: Make sure, that the codec is powered on startup" has
  been removed from the series, since it is already taken.

Intro text from the first series:

The following series changes the way how the APLL_CTL register is handled by
the twl4030 codec related drivers.
Moving the configuration of APLL_CTL register from child drivers (specifically
from soc codec driver) to the twl4030-codec MFD driver.
Because the audio_mclk is static, board specific and can not be changed in
runtime, the codec MFD is the right place to configure it early enough, so
child can use the hardware correctly.
Before this patch for example the APLL_INFREQ was configured first, when the
user played or recorded audio via the twl4030.
The digital bypass needs correct APLL_INFREQ to be configured in order to work
properly. If the digital bypass enabled before any audio activity, in some
cases the bypassed audio was not correct.

The series also addresses the issue, that after boot-up, neither of the
loopbacks was working, because the codec was actually off.
Setting the codec->bias_level to _OFF, before setting the codec bias level to
STANDBY fixes this issue.

This series is on top of Takashi's sound-2.6 topic/asoc branch, which has the
twl403-codec MFD and related patches for 2.6.33.

It would be really nice, if this series would make it also to the same branch,
since this fixes some real anomalies brought in by the cleanup of the twl4030
codec related drivers.
These problems were hidden before because of the inconsistent handling of bits
and states in the codec driver in the past.

---
Peter Ujfalusi (4):
  MFD: TWL4030: Add audio_mclk to the codec platform data
  OMAP: Configure audio_mclk for twl4030-codec MFD
  MFD: twl4030-codec: APLL_INFREQ handling in the MFD driver
  ASoC: TWL4030: Do not modify the APLL_CTL register

 arch/arm/mach-omap2/board-3430sdp.c      |    1 +
 arch/arm/mach-omap2/board-omap3beagle.c  |    1 +
 arch/arm/mach-omap2/board-omap3evm.c     |    1 +
 arch/arm/mach-omap2/board-omap3pandora.c |    1 +
 arch/arm/mach-omap2/board-overo.c        |    1 +
 arch/arm/mach-omap2/board-zoom2.c        |    1 +
 drivers/mfd/twl4030-codec.c              |   35 ++++++++++++++
 include/linux/i2c/twl4030.h              |    1 +
 include/linux/mfd/twl4030-codec.h        |    1 +
 sound/soc/codecs/twl4030.c               |   76 ++++++++++++------------------
 10 files changed, 74 insertions(+), 45 deletions(-)

