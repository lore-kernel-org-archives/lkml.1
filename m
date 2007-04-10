Return-Path: <linux-kernel-owner+w=401wt.eu-S1030404AbXDJWVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030404AbXDJWVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030412AbXDJWVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:21:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:27421 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030404AbXDJWVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:21:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,392,1170662400"; 
   d="scan'208"; a="71584941:sNHT18956070"
Date: Tue, 10 Apr 2007 15:20:09 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org,
       Adam Belay <abelay@novell.com>
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070410222009.GA26607@linux-os.sc.intel.com>
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com> <200704091940.53439.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704091940.53439.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 07:40:52PM +0200, Rafael J. Wysocki wrote:
> On Monday, 9 April 2007 18:14, Pallipadi, Venkatesh wrote:
> > 
> > >-----Original Message-----
> > >From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> > >Sent: Monday, April 09, 2007 9:08 AM
> > >To: Andrew Morton
> > >Cc: linux-kernel@vger.kernel.org; randy.dunlap@oracle.com; 
> > >lenb@kernel.org; Pallipadi, Venkatesh
> > >Subject: Re: 2.6.21-rc6-mm1
> > >
> > >On Sunday, 8 April 2007 23:35, Andrew Morton wrote:
> > >> 
> > >> 
> > >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2
> > >.6.21-rc6/2.6.21-rc6-mm1/
> > >> 
> > >> 
> > >> - Lots of x86 updates
> > >> 
> > >> - This is a 25MB diff against mainline, which is rather large.
> > >
> > >The cpuidle thing tends to hang my x86-64 machines on boot.
> > >
> > 
> > Hi Rafael,
> > 
> > At what point during boot does it hang?
> 
> When mounting the root filesystem.  It hangs completely, even the magic SysRq
> doesn't work
> 

Rafael: Below patch should fix the hang.
Len: Please include this patch in acpi-test.

Thanks,
Venki

Prevent hang on x86-64, when ACPI processor driver is added as a module on
a system that does not support C-states.

x86-64 expects all idle handlers to enable interrupts before returning from
idle handler. This is due to enter_idle(), exit_idle() races. Make
cpuidle_idle_call() confirm to this when there is no pm_idle_old.

Also, cpuidle look at the return values of attch_driver() and set
current_driver to NULL if attach fails on all CPUs.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc6-mm1/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/cpuidle/cpuidle.c
+++ linux-2.6.21-rc6-mm1/drivers/cpuidle/cpuidle.c
@@ -43,6 +43,8 @@ static void cpuidle_idle_call(void)
 	if (dev->status != CPUIDLE_STATUS_DOIDLE) {
 		if (pm_idle_old)
 			pm_idle_old();
+		else
+			local_irq_enable();
 		return;
 	}
 
Index: linux-2.6.21-rc6-mm1/drivers/cpuidle/driver.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/cpuidle/driver.c
+++ linux-2.6.21-rc6-mm1/drivers/cpuidle/driver.c
@@ -107,11 +107,20 @@ int cpuidle_switch_driver(struct cpuidle
 	cpuidle_curr_driver = drv;
 
 	if (drv) {
+		int ret = 1;
 		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
-			cpuidle_attach_driver(dev);
-		if (cpuidle_curr_governor)
+			if (cpuidle_attach_driver(dev) == 0)
+				ret = 0;
+
+		/* If attach on all devices fail, switch to NULL driver */
+		if (ret)
+			cpuidle_curr_driver = NULL;
+
+		if (cpuidle_curr_driver && cpuidle_curr_governor) {
+			printk(KERN_INFO "cpuidle: using driver %s\n",
+					drv->name);
 			cpuidle_install_idle_handler();
-		printk(KERN_INFO "cpuidle: using driver %s\n", drv->name);
+		}
 	}
 
 	return 0;
