Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZJVK06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZJVK06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZJVK05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:26:57 -0400
Received: from smtp.nokia.com ([192.100.122.233]:22634 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337AbZJVK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:26:56 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/4 v2] MFD/OMAP/ASoC: MFD device for twl4030 codec submodule
Date: Thu, 22 Oct 2009 13:26:44 +0300
Message-Id: <1256207208-25010-1-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.1
X-OriginalArrivalTime: 22 Oct 2009 10:26:52.0102 (UTC) FILETIME=[2BA90E60:01CA5302]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes from the first series:
- twl4030-codec MFD driver is using the mfd-core API (and selects MFD_CORE)
- Added Acked-by: Tony Lindgren <tony@atomide.com> to the patch for the OMAP
  board files
- User selectable Kconfig is removed for the TWL4030_CODEC
- soc codec driver patch separated:
 - Change the header file, and use the include/linux/mfd/twl4030-codec.h for
   register definitions
 - The actual change in the soc codec driver
- Module alias corrected in soc codec driver
- The bias is brought up when the driver comes up, rather than in soc probe.
- The soc codec driver is selecting the TWL4030_CODEC driver

The series applies on top of sound-2.6:topic/asoc branch

Commit message from the first series:

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
- add the actual vibra driver ;)
- coexistence related fixes for the audio and vibra driver
- move all audio related configuration from soc machine drivers to the board
  files (if any)

---
Peter Ujfalusi (4):
  MFD: twl4030: add twl4030_codec MFD as a new child to the core
  OMAP: Platform support for twl4030_codec MFD
  ASoC: TWL4030: use the twl4030-codec.h for register descriptions
  ASoC: TWL4030: Driver registration via twl4030_codec MFD

 arch/arm/mach-omap2/board-3430sdp.c      |    9 +
 arch/arm/mach-omap2/board-omap3beagle.c  |    9 +
 arch/arm/mach-omap2/board-omap3evm.c     |    9 +
 arch/arm/mach-omap2/board-omap3pandora.c |    9 +
 arch/arm/mach-omap2/board-overo.c        |    9 +
 arch/arm/mach-omap2/board-zoom2.c        |    9 +
 drivers/mfd/Kconfig                      |    6 +
 drivers/mfd/Makefile                     |    1 +
 drivers/mfd/twl4030-codec.c              |  241 ++++++++++++++++++++++++++
 drivers/mfd/twl4030-core.c               |   14 ++
 include/linux/i2c/twl4030.h              |   18 ++
 include/linux/mfd/twl4030-codec.h        |  271 ++++++++++++++++++++++++++++++
 sound/soc/codecs/Kconfig                 |    1 +
 sound/soc/codecs/twl4030.c               |  203 ++++++++++++++---------
 sound/soc/codecs/twl4030.h               |  242 +--------------------------
 15 files changed, 738 insertions(+), 313 deletions(-)
 create mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 include/linux/mfd/twl4030-codec.h

