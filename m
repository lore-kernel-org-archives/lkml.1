Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZJSMmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZJSMmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZJSMmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:42:42 -0400
Received: from smtp.nokia.com ([192.100.105.134]:54137 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbZJSMmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:42:39 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: sameo@linux.intel.com, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/4] twl4030 codec as MFD device
Date: Mon, 19 Oct 2009 15:42:16 +0300
Message-Id: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.1
X-OriginalArrivalTime: 19 Oct 2009 12:42:21.0229 (UTC) FILETIME=[99C225D0:01CA50B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following series adds new MFD device on top of the twl4030 MFD device for
the codec part of the chip, and also converts the soc audio driver to use the
correct probing (device model).

Reason for the twl4030_codec MFD: the vibra control is actually in the codec
part of the twl4030. If both the vibra and the audio functionality is needed
from the twl4030 at the same time, than they need to control the codec power
and APLL at the same time without breaking the other driver.
Also these two has to be able to work without the need for the other driver.

The proposed solution:
Register twl4030_codec as a child for the twl4030 mfd.
twl4030_codec is also and mfd and at the moment it has two child:
twl4030_codec_audio: for audio codec
twl4030_codec_vibra: for vibra driver

The twl4030_codec mfd registers the devices for audio and vibra (if the
platform data is not NULL for them), and has - at the moment - functions to
enable/disable resources, each of these resources has ref-counts, so the
twl4030_codec knows, when the resource is need to be turned on or off.

The interface is quite simple:
int twl4030_codec_enable_resource(enum twl4030_codec_res id);
int twl4030_codec_disable_resource(enum twl4030_codec_res id);

These functions are returning the content of the given register after the
modification (or negative value, if error -  the error handling need to be
revisited in a near future), so that the caller can update it's local cache if
it need to do (the audio driver needs it).

There are two resource defined:
TWL4030_CODEC_RES_POWER: Controlling the power of the codec
TWL4030_CODEC_RES_APLL: For APLL

The vibra driver is not part of this series.

I have also included a patch, which changes the board files for those, which
in my knowledge uses the twl4030 codec as audio device. I might missed some
boards...

To-Do list:
- revisit the error handling in twl4030-codec driver
- add the actual vibra driver ;)
- coexistence related fixes for the audio and vibra driver
- move all audio related configuration from soc machine drivers to the board
  files (if any)

---
Peter Ujfalusi (4):
  MFD: twl4030: add twl4030_codec MFD as a new child to the core
  OMAP: Platform support for twl4030_codec MFD
  ASoC: TWL4030: Only update the needed bits in *set_dai_sysclk
  ASoC: TWL4030: Driver registration via twl4030_codec MFD

 arch/arm/mach-omap2/board-3430sdp.c      |    9 +
 arch/arm/mach-omap2/board-omap3beagle.c  |    9 +
 arch/arm/mach-omap2/board-omap3evm.c     |    9 +
 arch/arm/mach-omap2/board-omap3pandora.c |    9 +
 arch/arm/mach-omap2/board-overo.c        |    9 +
 arch/arm/mach-omap2/board-zoom2.c        |    9 +
 drivers/mfd/Kconfig                      |   13 ++
 drivers/mfd/Makefile                     |    1 +
 drivers/mfd/twl4030-codec.c              |  245 ++++++++++++++++++++++++++++
 drivers/mfd/twl4030-core.c               |   14 ++
 include/linux/i2c/twl4030.h              |   18 ++
 include/linux/mfd/twl4030-codec.h        |  261 ++++++++++++++++++++++++++++++
 sound/soc/codecs/Kconfig                 |    2 +-
 sound/soc/codecs/twl4030.c               |  225 ++++++++++++++++----------
 sound/soc/codecs/twl4030.h               |  242 +---------------------------
 15 files changed, 751 insertions(+), 324 deletions(-)
 create mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 include/linux/mfd/twl4030-codec.h

