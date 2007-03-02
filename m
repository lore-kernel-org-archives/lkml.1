Return-Path: <linux-kernel-owner+w=401wt.eu-S2992550AbXCBQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992550AbXCBQAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992552AbXCBQAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:00:54 -0500
Received: from mga07.intel.com ([143.182.124.22]:17665 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992550AbXCBQAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:00:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,243,1170662400"; 
   d="scan'208"; a="189362955:sNHT19708430"
Date: Fri, 2 Mar 2007 07:24:28 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, abelay@novell.com, shaohua.li@intel.com,
       len.brown@intel.com
Subject: Re: [-mm patch] cpu_idle: fix build break
Message-ID: <20070302072428.B25965@unix-os.sc.intel.com>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302144007.GC12727@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <20070302144007.GC12727@slug>; from deweerdt@free.fr on Fri, Mar 02, 2007 at 02:40:07PM +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 02:40:07PM +0000, Frederik Deweerdt wrote:
> On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
> > +git-acpi-fix-cpuidle-borkage.patch
> This attached patch might be needed too, the build breaks if
> !CONFIG_HOTPLUG_CPU and CONFIG_CPU_IDLE
>  
>   CC      drivers/cpuidle/cpuidle.o
> drivers/cpuidle/cpuidle.c: In function 'cpuidle_init':
> drivers/cpuidle/cpuidle.c:272: erreur: 'cpuidle_cpu_notifier' undeclared (first use in this function)
> drivers/cpuidle/cpuidle.c:272: erreur: (Each undeclared identifier is reported only once
> drivers/cpuidle/cpuidle.c:272: erreur: for each function it appears in.)
> make[2]: *** [drivers/cpuidle/cpuidle.o] Erreur 1
> make[1]: *** [drivers/cpuidle] Erreur 2
> make: *** [drivers] Erreur 2
>

Thanks for catching this breakage. Patch below should be the proper fix.

Thanks,
Venki

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 
Index: linux-2.6.21-rc-mm/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.21-rc-mm.orig/drivers/cpuidle/cpuidle.c
+++ linux-2.6.21-rc-mm/drivers/cpuidle/cpuidle.c
@@ -189,10 +189,6 @@ static struct sysdev_driver cpuidle_sysd
 	.remove		= cpuidle_remove_device,
 };
 
-#ifdef CONFIG_SMP
-
-#ifdef CONFIG_HOTPLUG_CPU
-
 static int cpuidle_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
@@ -224,7 +220,7 @@ static struct notifier_block __cpuinitda
     .notifier_call = cpuidle_cpu_callback,
 };
 
-#endif /* CONFIG_HOTPLUG_CPU */
+#ifdef CONFIG_SMP
 
 static void smp_callback(void *v)
 {
