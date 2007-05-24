Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbXEXMKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbXEXMKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbXEXMKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:36438 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbXEXMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:18 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 3/7] HOTPLUG: Adapt thermal throttle to CPU_DYING
Date: Thu, 24 May 2007 15:10:11 +0300
Message-Id: <11800086151924-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1180008615579-git-send-email-avi@qumranet.com>
References: <1180008615579-git-send-email-avi@qumranet.com>
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
1.5.0.6

