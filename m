Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZEHEtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZEHEtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbZEHEtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:49:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:10706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbZEHEtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:49:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,315,1239001200"; 
   d="scan'208";a="140549057"
Message-ID: <4A03B9BD.8020205@intel.com>
Date: Thu, 07 May 2009 21:49:01 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com, sheng@linux.intel.com, avi@redhat.com
Subject: [RFC v3][PATCH 1/2] intel_txt: KVM shutdown fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix KVM to disable itself under all shutdown conditions.  In additional to being good practice, Intel(R) TXT requires VMX to be disabled on all CPUs in order for TXT to be disabled.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
---
 kvm_main.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.30-rc4/virt/kvm/kvm_main.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/virt/kvm/kvm_main.c	2009-05-07 13:27:03.000000000 -0700
@@ -2112,15 +2112,15 @@ EXPORT_SYMBOL_GPL(kvm_handle_fault_on_re
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
-	if (val == SYS_RESTART) {
-		/*
-		 * Some (well, at least mine) BIOSes hang on reboot if
-		 * in vmx root mode.
-		 */
-		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		kvm_rebooting = true;
-		on_each_cpu(hardware_disable, NULL, 1);
-	}
+	/*
+	 * Some (well, at least mine) BIOSes hang on reboot if
+	 * in vmx root mode.
+	 *
+	 * And Intel TXT required VMX off for all cpu when system shutdown.
+	 */
+	printk(KERN_INFO "kvm: exiting hardware virtualization\n");
+	kvm_rebooting = true;
+	on_each_cpu(hardware_disable, NULL, 1);
 	return NOTIFY_OK;
 }
 


