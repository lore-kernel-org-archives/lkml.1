Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbXGHMBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbXGHMBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXGHLzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:32 -0400
Received: from il.qumranet.com ([82.166.9.18]:38413 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbXGHLyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:47 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 16/20] HOTPLUG: Adapt thermal throttle to CPU_DYING
Date: Sun,  8 Jul 2007 14:54:45 +0300
Message-Id: <11838956891066-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_DYING is notified in atomic context, so no taking mutexes here.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/i386/kernel/cpu/mcheck/therm_throt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c b/arch/i386/kernel/cpu/mcheck/therm_throt.c
index 7ba7c3a..1203dc5 100644
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -134,19 +134,21 @@ static __cpuinit int thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	int err;
 
 	sys_dev = get_cpu_sysdev(cpu);
-	mutex_lock(&therm_cpu_lock);
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		mutex_lock(&therm_cpu_lock);
 		err = thermal_throttle_add_dev(sys_dev);
+		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		mutex_lock(&therm_cpu_lock);
 		thermal_throttle_remove_dev(sys_dev);
+		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
-	mutex_unlock(&therm_cpu_lock);
 	return NOTIFY_OK;
 }
 
-- 
1.5.2.2

