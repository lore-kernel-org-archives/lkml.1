Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbYBHT1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbYBHT1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYBHT1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:27:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:26338 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYBHT13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:27:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XmIWzyT5BuZ5TKYMva8reuahMQYBWMWuIVLRwy9501x991vgQJgE0QHDe3WncsgnOnW6IcM2RY1JN4UnRKnCfrqTRcilSqwRuCbYyPJnSjls3Kly6i98Hc63gT8xCO3X1Egq1DS1Q3AxTCwxBcnLZp4FxrJdFNDxR0XQ+Xiw2mM=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION] kobject handling in cpufreq
Date: Sat, 9 Feb 2008 00:52:40 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: gregkh@suse.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802090052.40939.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi greg,

I encountered a regression in linux-2.6.git which prevented the system from shutting down. I found that it 
was 'waiting_for_completion' on kobj_unregister.The same thing happened when I tried to take CPUs offline.

git-bisect pointed me to this commit :

commit c10997f6575f476ff38442fa18fd4a0d80345f9d
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Thu Dec 20 08:13:05 2007 -0800

    Kobject: convert drivers/* from kobject_unregister() to kobject_put()

In the file drivers/cpufreq/cpufreq.c, you have not replaced one occurrence of kobject_unregister with kobject_put. 
Apparently its because of the kobject_put in the subsequent line.

@@ -1030,8 +1030,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
 
        unlock_policy_rwsem_write(cpu);
 
-       kobject_unregister(&data->kobj);
-
        kobject_put(&data->kobj);
 
        /* we need to make sure that the underlying kobj is actually

Now, this can be fixed by adding another kobject_put. But having two kobject_puts in consequent lines tells us that there 
should be two references to the kobject at that point. So, I believe that it is safe to remove the kobject_get 
corresponding to the existing kobject_put to fix this.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 64926aa..2158786 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1004,17 +1004,6 @@ static int __cpufreq_remove_dev (struct sys_device * sys_dev)
 		unlock_policy_rwsem_write(cpu);
 		return 0;
 	}
-#endif
-
-
-	if (!kobject_get(&data->kobj)) {
-		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
-		cpufreq_debug_enable_ratelimit();
-		unlock_policy_rwsem_write(cpu);
-		return -EFAULT;
-	}
-
-#ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
 	cpufreq_cpu_governor[cpu] = data->governor;
-- 
regards,
balaji rao
