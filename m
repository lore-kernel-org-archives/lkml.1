Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbZKFUA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbZKFUA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbZKFUA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:00:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbZKFUAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:00:55 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: davej@redhat.com, cpufreq@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Matthew Garrett <mjg@redhat.com>,
       "Arjan van de Ven\"" <arjan@linux.intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Aeolus Yang <Aeolus.Yang@atheros.com>,
       Amod Bodas <Amod.Bodas@atheros.com>,
       David Quan <David.Quan@atheros.com>,
       Kishore Jotwani <Kishore.Jotwani@atheros.com>
Subject: [PATCH] cpu-freq: add troubleshooting section for FSB changes
Date: Fri,  6 Nov 2009 15:01:00 -0500
Message-Id: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cpu frequency scaling you may run into some system
performance issues when the FSB changes speed due to the
throughput constraints this brings on the system.

Document how to rule out whether or not FSB changes
affect general system issues.

Cc: Matthew Garrett <mjg@redhat.com>
Cc: Arjan van de Ven" <arjan@linux.intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Aeolus Yang <Aeolus.Yang@Atheros.com>
Cc: Amod Bodas <Amod.Bodas@Atheros.com>
Cc: David Quan <David.Quan@Atheros.com>
Cc: Kishore Jotwani <Kishore.Jotwani@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Documentation/cpu-freq/user-guide.txt |   45 +++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/Documentation/cpu-freq/user-guide.txt b/Documentation/cpu-freq/user-guide.txt
index 2a5b850..846729d 100644
--- a/Documentation/cpu-freq/user-guide.txt
+++ b/Documentation/cpu-freq/user-guide.txt
@@ -32,6 +32,7 @@ Contents:
 3. How to change the CPU cpufreq policy and/or speed
 3.1 Preferred interface: sysfs
 
+4. Troubleshooting
 
 
 1. Supported Architectures and Processors
@@ -211,3 +212,47 @@ scaling_setspeed.		By "echoing" a new frequency into this
 				you can change the speed of the CPU,
 				but only within the limits of
 				scaling_min_freq and scaling_max_freq.
+
+4. Troubleshooting
+==================
+
+If you are not sure if frequency scaling is the culprit to your
+issues you can try to disable the feature on the BIOS if possible.
+
+Alternatively it helps to understand that on some CPUs (Intel)
+the Front Side Bus (FSB) speed is changed when you happen to change
+the active CPU frequency to the lowest supported frequency, which
+happens to be the frequency used on the highest supported P-n state.
+The P0 state is the highest Performance state with the highest
+CPU frequency and system power. The highest P-n state would be
+the one with the lowest supported frequency and power.
+
+On Intel CPUs the FSB will not be modified with SpeedStep enabled if the
+second to last lowest frequency on the available scaling frequencies
+is used. Testing this would rule out whether or not the FSB changes
+made by SpeedStep would be the main issue.
+
+Modifying the FSB will alter your general system throughput
+on your Northbridge so to prevent general throughput issues
+with devices on it you can modify frequency scaling so that
+it nevers uses the lowest supported frequency.
+
+For example:
+
+cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_frequencies
+1801000 1800000 1200000 800000
+1801000 1800000 1200000 800000
+
+cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq
+800000
+800000
+
+To disable changing the FSB select the second to last CPU freq
+on the available freq for each CPU and set the scaling_min_freq
+for each CPU to that value. For the example output this would be
+echo'ing 1200000 to each scaling_min_freq:
+
+echo 1200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
+echo 1200000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
+
+The first line is for the 1st CPU, the second line for the second line.
-- 
1.6.5.2.143.g8cc62

