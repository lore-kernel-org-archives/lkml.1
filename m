Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbZIDTe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbZIDTe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbZIDTeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:34:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36637 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbZIDTeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:34:18 -0400
From: Sanjeev Premi <premi@ti.com>
To: linux-kernel@vger.kernel.org
Cc: Sanjeev Premi <premi@ti.com>
Subject: [PATCHv3 0/1] PM : cpuidle - incorrect statistics
Date: Sat,  5 Sep 2009 01:04:12 +0530
Message-Id: <1252092852-18320-1-git-send-email-premi@ti.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 'enable_off_mode' is 0, the target power state for MPU
and Core is locally changed to PWRDM_POWER_RET but, the
statistics are updated for idle state originally selected
by the governor.

To debug the issue and validate the fix, added variables -
mpu_state_modified and core_state_modified. Both are
incremented in omap3_enter_idle() as below:

	if (!enable_off_mode) {
		if (mpu_state < PWRDM_POWER_RET) {
			mpu_state_modified++;
			mpu_state = PWRDM_POWER_RET;
		}
		if (core_state < PWRDM_POWER_RET) {
			core_state_modified++;
			core_state = PWRDM_POWER_RET;
		}
	}

Also added a sysfs entry to track these modifications.

Before the change:

...BOOT...
[root@OMAP3EVM /]#
[root@OMAP3EVM /]# cat /sys/power/enable_off_mode
0
[root@OMAP3EVM /]# cat /sys/power/enable_off_mode
0
[root@OMAP3EVM /]# cat /sys/power/track_modifs
[mpu_state_modified, core_state_modified] = [0 , 0]
[root@OMAP3EVM /]#
[root@OMAP3EVM /]#
[root@OMAP3EVM /]# echo 1 > /sys/power/sleep_while_idle
[root@OMAP3EVM /]#
...WAIT 5 SECS...
[root@OMAP3EVM /]# cat /sys/power/track_modifs
[mpu_state_modified, core_state_modified] = [5 , 3]
[root@OMAP3EVM /]# cat /sys/devices/system/cpu/cpu0/cpuidle/state6/usage
3
...WAIT FEW MORE SECS...
[root@OMAP3EVM /]# cat /sys/power/track_modifs
[mpu_state_modified, core_state_modified] = [27 , 25]
[root@OMAP3EVM /]# cat /sys/devices/system/cpu/cpu0/cpuidle/state6/usage
25
[root@OMAP3EVM /]# cat /sys/power/enable_off_mode
0

After the fix:

...BOOT...
[root@OMAP3EVM /]#
[root@OMAP3EVM /]# cat /sys/power/enable_off_mode
0
[root@OMAP3EVM /]# cat /sys/power/enable_off_mode
0
[root@OMAP3EVM /]# cat /sys/power/track_modifs
[mpu_state_modified, core_state_modified] = [0 , 0]
[root@OMAP3EVM /]#
[root@OMAP3EVM /]#
[root@OMAP3EVM /]# echo 1 > /sys/power/sleep_while_idle
[root@OMAP3EVM /]#
...WAIT 5 SECS...
[root@OMAP3EVM /]# cat /sys/power/track_modifs
[mpu_state_modified, core_state_modified] = [0 , 0]
[root@OMAP3EVM /]# cat /sys/devices/system/cpu/cpu0/cpuidle/state6/usage
0
[root@OMAP3EVM /]# echo 1 > /sys/power/sleep_while_idle
[root@OMAP3EVM /]#
...WAIT APPROX 10 SECS...
[root@OMAP3EVM /]# cat /sys/power/track_modifs
[mpu_state_modified, core_state_modified] = [0 , 0]
[root@OMAP3EVM /]# cat /sys/devices/system/cpu/cpu0/cpuidle/state6/usage
2
...WAIT APPROX 30 SECS...
[root@OMAP3EVM /]# cat /sys/power/track_modifs
[mpu_state_modified, core_state_modified] = [0 , 0]
[root@OMAP3EVM /]# cat /sys/devices/system/cpu/cpu0/cpuidle/state6/usage
17
[root@OMAP3EVM /]#

This topic was discussed earlier; but the final fix did not find its
way back.

  [1] http://marc.info/?l=linux-omap&m=123681603821299&w=2

Sanjeev Premi (1):
  PM : cpuidle - update statistics for correct state

 arch/arm/mach-omap2/cpuidle34xx.c |   34 +++++++++++++++++++++++++++-------
 arch/arm/mach-omap2/pm.h          |    2 ++
 arch/arm/mach-omap2/pm34xx.c      |    2 ++
 3 files changed, 31 insertions(+), 7 deletions(-)

