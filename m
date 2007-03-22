Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXCVAdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXCVAdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965553AbXCVAdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:33:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:45855 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbXCVAdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,310,1170662400"; 
   d="scan'208"; a="216851117:sNHT18484655"
Date: Wed, 21 Mar 2007 17:33:15 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1 - problem with cpuidle routine
Message-ID: <20070322003315.GA17996@linux-os.sc.intel.com>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org> <46017E56.7050400@lwfinger.net> <20070321133815.304eb256.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321133815.304eb256.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 01:38:15PM -0700, Andrew Morton wrote:
> On Wed, 21 Mar 2007 13:49:58 -0500
> Larry Finger <larry.finger@lwfinger.net> wrote:
> 
> > When I configure 'CPU Idle PM Support' on my HP dv2125nr notebook with a Turion X64 X2 processor and
> > X86_64 architecture selected, the computer freezes on bootup. I have included a portion the
> > configuration file and part of /var/log/boot.msg for my working system. Please let me know if
> > further info from my system is required. I would be happy to test any patches, etc.
> > 
> > Larry
> > 
> > ==============================================================
> > 
> > The console log ends with the following entries:
> > 
> > ACPI: Processor [CPU0] (supports 8 throttling states)
> > ACPI: Processor [CPU1] (supports 8 throttling states)
> > cpuidle: driver acpi_idle failed to attach to cpu 0
> > cpuidle: driver acpi_idle failed to attach to cpu 0
> > cpuidle: using driver acpi_idle
> > Loading thermal
> > 
> > At this point, the system hangs.
> > 
> > =================================================
> > 
> > The beginning section of my .config is as follows:
> > 
> 
> Thanks.   Cc's added..

Patch below resolves this issue.


Patch for cpuidle boot hang reported by Larry Finger here.
http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/2025.html

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: new/drivers/cpuidle/cpuidle.c
===================================================================
--- new.orig/drivers/cpuidle/cpuidle.c	2007-03-21 14:25:11.000000000 -0800
+++ new/drivers/cpuidle/cpuidle.c	2007-03-21 14:25:33.000000000 -0800
@@ -119,6 +119,7 @@
 
 	dev = &per_cpu(cpuidle_devices, cpu);
 
+	dev->cpu = cpu;
 	mutex_lock(&cpuidle_lock);
 	if (cpu_is_offline(cpu)) {
 		mutex_unlock(&cpuidle_lock);
@@ -129,15 +130,26 @@
 		mutex_unlock(&cpuidle_lock);
 		return 0;
 	}
-	dev->status |= CPUIDLE_STATUS_DETECTED;
-	list_add(&dev->device_list, &cpuidle_detected_devices);
-	cpuidle_add_sysfs(sys_dev);
-	if (cpuidle_curr_driver)
-		cpuidle_attach_driver(dev);
-	if (cpuidle_curr_governor)
-		cpuidle_attach_governor(dev);
+	if (cpuidle_curr_driver) {
+		if (cpuidle_attach_driver(dev))
+			goto err_ret;
+	}
+		
+	if (cpuidle_curr_governor) {
+		if (cpuidle_attach_governor(dev)) {
+			cpuidle_detach_driver(dev);
+			goto err_ret;
+		}
+	}
+
 	if (cpuidle_device_can_idle(dev))
 		cpuidle_install_idle_handler();
+
+	list_add(&dev->device_list, &cpuidle_detected_devices);
+	cpuidle_add_sysfs(sys_dev);
+	dev->status |= CPUIDLE_STATUS_DETECTED;
+
+err_ret:
 	mutex_unlock(&cpuidle_lock);
 
 	return 0;
Index: new/drivers/cpuidle/driver.c
===================================================================
--- new.orig/drivers/cpuidle/driver.c	2007-03-21 14:25:15.000000000 -0800
+++ new/drivers/cpuidle/driver.c	2007-03-21 14:25:53.000000000 -0800
@@ -37,7 +37,7 @@
 	ret = cpuidle_curr_driver->init(dev);
 	if (ret) {
 		module_put(cpuidle_curr_driver->owner);
-		printk(KERN_ERROR "cpuidle: driver %s failed to attach to cpu %d\n",
+		printk(KERN_INFO "cpuidle: driver %s failed to attach to cpu %d\n",
 			cpuidle_curr_driver->name, dev->cpu);
 	} else {
 		if (dev->status & CPUIDLE_STATUS_GOVERNOR_ATTACHED)
