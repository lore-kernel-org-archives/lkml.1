Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbXLLSTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbXLLSTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbXLLSTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:19:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbXLLSTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:19:22 -0500
Date: Wed, 12 Dec 2007 13:18:28 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, venkatesh.pallipadi@intel.com
Subject: Re: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Message-ID: <20071212181828.GA27675@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>, venkatesh.pallipadi@intel.com
References: <20071212091144.GA11986@elte.hu> <20071212164013.GA2359@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212164013.GA2359@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 11:40:13AM -0500, Dave Jones wrote:
 
 >  > powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ processors (1 cpu cores) (version 2.20.00)
 >  > powernow-k8: BIOS error - no PSB or ACPI _PSS objects
 >  > ------------[ cut here ]------------
 >  > kernel BUG at drivers/cpufreq/cpufreq.c:1060!
 > 
 > The actual BUG you hit is 
 > 
 >         if (unlikely(lock_policy_rwsem_write(cpu)))
 >                 BUG();
 > 
 > It _looks_ like we're leaking a refcount on that lock, but
 > I don't see where.  It's a shame you can't reproduce this easily,
 > as cpufreq.debug=7 would give us more clues.
 > (And CONFIG_CPUFREQ_DEBUG=y)

So we're missing some unlocks in some error paths.
It's feasible you hit one of those.
This patch should be the fix for that.

	Dave

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5e626b1..79581fa 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -841,19 +841,25 @@ static int cpufreq_add_dev (struct sys_device * sys_dev)
 	drv_attr = cpufreq_driver->attr;
 	while ((drv_attr) && (*drv_attr)) {
 		ret = sysfs_create_file(&policy->kobj, &((*drv_attr)->attr));
-		if (ret)
+		if (ret) {
+			unlock_policy_rwsem_write(cpu);
 			goto err_out_driver_exit;
+		}
 		drv_attr++;
 	}
 	if (cpufreq_driver->get){
 		ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
-		if (ret)
+		if (ret) {
+			unlock_policy_rwsem_write(cpu);
 			goto err_out_driver_exit;
+		}
 	}
 	if (cpufreq_driver->target){
 		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
-		if (ret)
+		if (ret) {
+			unlock_policy_rwsem_write(cpu);
 			goto err_out_driver_exit;
+		}
 	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-- 
http://www.codemonkey.org.uk
