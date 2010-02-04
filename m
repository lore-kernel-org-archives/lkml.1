Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab0BDIZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:25:34 -0500
Received: from smtp.nokia.com ([192.100.122.233]:47263 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab0BDIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:25:05 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: pavel@ucw.cz, daniel@caiaq.de, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH 0/6] lis3lv02d: Power management, click and threshold interrupts
Date: Thu,  4 Feb 2010 10:24:02 +0200
Message-Id: <1265271848-26559-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 04 Feb 2010 08:24:16.0573 (UTC) FILETIME=[70CC26D0:01CAA573]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lis3 accelerometer chip family changes for power management,
click and threshold event handling.

Patch set adds interrupt handlers for click/tap events and threshold
based events. Actual configuration which events are enabled
is done via platform data. All the features cannot be used in parallel.
Interrupts are implemented only for 8 bit device, since I'm not familiar
with other devices and I don't have suitable testing environment.

Changes:

  lis3: Add missing constants for 8bit device
This is quite clear. Some click feature related register definitions
were missing.

  lis3: Separate configuration function for 8 bit device
Move platformdata based configurations for 8 bit device to
separate function to keep common part little bit more readable.

  lis3: Introduce platform data for second ff / wu unit
8 bit device has two freefall / wakeup detection blocks. Add possibility
to configure also the second unit. Change hipass filter configuration
to platform data. Change is compatible with existing platform data.

  lis3: Power control for the chip
This kind of feature has been in the driver earlier. It was removed
because saving was so small in laptop environment. However, in smaller
devices, even a small saving need to be implemented. When driver detects
that no-one is really interested about the acceleration, chip is powered down.
Input device, freefall device and sysfs are controlling this. By default,
chip is powered on to keep functionality similar to current implementation.

  lis3: Add skeletons for interrupt handlers
Interrupt handlers are added in two patches to keep changes cleaner.
This first patch adds two dummy threaded interrupt handlers for 8 bit device. 

  lis3: Interrupt handlers for 8bit wakeup and click events
This patch adds content to dummy handlers. Depending on the chip configuration,
either click or ff/wu handling is called. For click event, BTN input event is
sent separately for each axes. For threshold event, coordinates are updated
immediatelly to input device. This allows input device to be used either in
polled mode and / or interrupt driven mode. Polling can stopped from userspace
by via input device sysfs.

Patch set applies to 2.6.33-RC6 tree.
Tested with 2.6.32 environment for omap3

Samu Onkalo (6):
  lis3: Add missing constants for 8bit device
  lis3: Separate configuration function for 8 bit device
  lis3: Introduce platform data for second ff / wu unit
  lis3: Power control for the chip
  lis3: Add skeletons for interrupt handlers
  lis3: Interrupt handlers for 8bit wakeup and click events

 drivers/hwmon/lis3lv02d.c     |  308 +++++++++++++++++++++++++++++++++--------
 drivers/hwmon/lis3lv02d.h     |   12 ++
 drivers/hwmon/lis3lv02d_i2c.c |    8 +-
 drivers/hwmon/lis3lv02d_spi.c |   12 +-
 include/linux/lis3lv02d.h     |   12 ++
 5 files changed, 287 insertions(+), 65 deletions(-)

