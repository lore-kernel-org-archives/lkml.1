Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbXHWBZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbXHWBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXHWBZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 21:25:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXHWBZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 21:25:46 -0400
Date: Thu, 23 Aug 2007 07:08:38 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] s390 appldata_base: Misc cpuinit annotations and bugfix
Message-ID: <alpine.LFD.0.999.0708230706570.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


appldata_offline_cpu() is only called from __cpuinit-marked hotplug
notifier callback and from the __exit-marked module_exit function,
therefore candidate for __cpuexit.

BTW the __exit module_exit function appldata_exit() of this driver
fails to unregister_hotcpu_notifier() the notifier_block that was
registered by appldata_init() during module startup. This will lead
to oops if hotplug notification comes after module has been unloaded.
Let's fix this by unregistering the notifier appropriately (before
appldata_offline_cpu()'ing the CPUs).

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/s390/appldata/appldata_base.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 62391fb..a355d81 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -547,8 +547,7 @@ static void __cpuinit appldata_online_cpu(int cpu)
 	spin_unlock(&appldata_timer_lock);
 }
 
-static void
-appldata_offline_cpu(int cpu)
+static void __cpuexit appldata_offline_cpu(int cpu)
 {
 	del_virt_timer(&per_cpu(appldata_timer, cpu));
 	if (atomic_dec_and_test(&appldata_expire_count)) {
@@ -560,9 +559,9 @@ appldata_offline_cpu(int cpu)
 	spin_unlock(&appldata_timer_lock);
 }
 
-static int __cpuinit
-appldata_cpu_notify(struct notifier_block *self,
-		    unsigned long action, void *hcpu)
+static int __cpuinit appldata_cpu_notify(struct notifier_block *self,
+					 unsigned long action,
+					 void *hcpu)
 {
 	switch (action) {
 	case CPU_ONLINE:
@@ -646,6 +645,8 @@ static void __exit appldata_exit(void)
 	}
 	spin_unlock(&appldata_ops_lock);
 
+	unregister_hotcpu_notifier(&appldata_nb);
+
 	for_each_online_cpu(i)
 		appldata_offline_cpu(i);
 
