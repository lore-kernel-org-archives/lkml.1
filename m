Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbXGVPqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbXGVPqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbXGVPoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:44:34 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:8114 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbXGVPod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=PSQbl9IFpXZcS0Wwe1yzv49FSiPAfHQvgAsPlJqK94ntQC9hzSpU8f2Ps/IG7l4WvSWDrGpKx6UVZJ8OpLW6+qwdLcDVWQEhdVzFEHCpaHfbSRnbOp7SV1ktQefGDCDYFxjU6glTdhxTs3BJDZx7HSOXHmdRZc8LGw0/5QtA2qs=
Message-Id: <20070722153359.528292289@gmail.com>
References: <20070722153312.083951746@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 00:33:17 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitriy Zavin <dmitriyz@google.com>, Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 5/9] thermal_throttle: fix cpu hotplug error handling
Content-Disposition: inline; filename=therm_throt-hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do thermal_throttle_add_dev() in CPU_UP_PREPARE instead of CPU_ONLINE.

Cc: Dmitriy Zavin <dmitriyz@google.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/i386/kernel/cpu/mcheck/therm_throt.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: 2.6-git/arch/i386/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- 2.6-git.orig/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ 2.6-git/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -131,17 +131,19 @@ static __cpuinit int thermal_throttle_cp
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct sys_device *sys_dev;
-	int err;
+	int err = 0;
 
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
 		err = thermal_throttle_add_dev(sys_dev);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		mutex_lock(&therm_cpu_lock);
@@ -149,7 +151,7 @@ static __cpuinit int thermal_throttle_cp
 		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
-	return NOTIFY_OK;
+	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
 
 static struct notifier_block thermal_throttle_cpu_notifier =

-- 
