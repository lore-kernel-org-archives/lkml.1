Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZKBMfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZKBMfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZKBMfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:35:30 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41330 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZKBMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:35:25 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/5] ASoC/MFD/OMAP: TWL4030: APLL_CTL handling change
Date: Mon,  2 Nov 2009 14:34:50 +0200
Message-Id: <1257165295-9352-1-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 02 Nov 2009 12:34:55.0593 (UTC) FILETIME=[E1EBFD90:01CA5BB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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

Thank you,

---
Peter Ujfalusi (5):
  MFD: TWL4030: Add audio_mclk to the codec platform data
  OMAP: Configure audio_mclk for twl4030-codec MFD
  MFD: twl4030-codec: APLL_INFREQ handling in the MFD driver
  ASoC: TWL4030: Make sure, that the codec is powered on startup
  ASoC: TWL4030: Do not modify the APLL_CTL register

 arch/arm/mach-omap2/board-3430sdp.c      |    1 +
 arch/arm/mach-omap2/board-omap3beagle.c  |    1 +
 arch/arm/mach-omap2/board-omap3evm.c     |    1 +
 arch/arm/mach-omap2/board-omap3pandora.c |    1 +
 arch/arm/mach-omap2/board-overo.c        |    1 +
 arch/arm/mach-omap2/board-zoom2.c        |    1 +
 drivers/mfd/twl4030-codec.c              |   40 +++++++++++++++++
 include/linux/i2c/twl4030.h              |    1 +
 include/linux/mfd/twl4030-codec.h        |    1 +
 sound/soc/codecs/twl4030.c               |   70 +++++++++++------------------
 10 files changed, 75 insertions(+), 43 deletions(-)

