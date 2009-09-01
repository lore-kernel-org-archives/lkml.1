Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZIALkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZIALkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZIALkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:40:41 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:44162 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZIALkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:40:40 -0400
Date: Tue, 1 Sep 2009 17:10:36 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v4 PATCH 3/5]: pSeries: Incorporate registering of idle loop for
	pSeries.
Message-ID: <20090901114036.GJ7599@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090901113704.GG7599@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090901113704.GG7599@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-01 17:07:04]:

Platform needs to register its idle function via register_idle_function()
in order to provide a clean way of handling the ppc_md.power_save

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/setup.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux.trees.git/arch/powerpc/platforms/pseries/setup.c
===================================================================
--- linux.trees.git.orig/arch/powerpc/platforms/pseries/setup.c
+++ linux.trees.git/arch/powerpc/platforms/pseries/setup.c
@@ -280,6 +280,8 @@ static struct notifier_block pci_dn_reco
 
 static void __init pSeries_setup_arch(void)
 {
+	struct idle_function_desc pseries_idle_desc;
+
 	/* Discover PIC type and setup ppc_md accordingly */
 	pseries_discover_pic();
 
@@ -305,10 +307,17 @@ static void __init pSeries_setup_arch(vo
 		vpa_init(boot_cpuid);
 		if (get_lppaca()->shared_proc) {
 			printk(KERN_DEBUG "Using shared processor idle loop\n");
-			ppc_md.power_save = pseries_shared_idle_sleep;
+			//snprintf(pseries_idle_desc.name, 16, "shared_loop");
+			pseries_idle_desc.name = "shared_loop";
+			pseries_idle_desc.idle_func = pseries_shared_idle_sleep;
+			register_idle_function(&pseries_idle_desc);
 		} else {
 			printk(KERN_DEBUG "Using dedicated idle loop\n");
-			ppc_md.power_save = pseries_dedicated_idle_sleep;
+			//snprintf(pseries_idle_desc.name, 16, "dedicated_loop");
+			pseries_idle_desc.name = "dedicated_loop";
+			pseries_idle_desc.idle_func =
+						pseries_dedicated_idle_sleep;
+			register_idle_function(&pseries_idle_desc);
 		}
 	} else {
 		printk(KERN_DEBUG "Using default idle loop\n");
