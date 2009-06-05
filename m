Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZFEVjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZFEVjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZFEVi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:38:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:10779 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbZFEVi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:38:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,312,1241420400"; 
   d="scan'208";a="419303279"
Message-ID: <4A29904C.8030102@intel.com>
Date: Fri, 05 Jun 2009 14:38:20 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com, sheng@linux.intel.com, avi@redhat.com
Subject: [RFC v4][PATCH 1/2] intel_txt: KVM shutdown fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix KVM to disable itself under all shutdown conditions.  In additional to being good practice, Intel(R) TXT requires VMX to be disabled on all CPUs in order for TXT to be disabled.

In kvm.git, as f878b14017f.

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
 
