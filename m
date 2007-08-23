Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXHWCIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXHWCIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXHWCIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:08:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51447 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXHWCIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:08:09 -0400
Date: Thu, 23 Aug 2007 07:51:00 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] s390 appldata_base: Remove module_exit function and modular
 stuff
In-Reply-To: <alpine.LFD.0.999.0708230706570.2049@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0708230746450.2049@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708230706570.2049@enigma.security.iitk.ac.in
 >
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Aug 2007, Satyam Sharma wrote:
> 
> BTW the __exit module_exit function appldata_exit() of this driver
> fails to unregister_hotcpu_notifier() the notifier_block that was
> registered by appldata_init() during module startup. This will lead
> to oops if hotplug notification comes after module has been unloaded.
> Let's fix this by unregistering the notifier appropriately (before
> appldata_offline_cpu()'ing the CPUs).

Heh, no wonder we never saw this oops before. This code can never be
built as a module! :-) But why does it define and implement an __exit
marked module_exit(appldata_exit) function in that case ?!

[ On top of previous patch: ]


[PATCH] s390 appldata_base: Remove module_exit function and modular stuff

arch/s390/Kconfig tells us that CONFIG_APPLDATA_BASE is bool and hence
can never be built modular. Given this, defining appldata_exit() function
is pointless (and wasteful, actually). Remove all that.

Previous patch annotated appldata_offline_cpu() as __cpuexit, but now
with the __exit function appldata_exit() gone, the only callsite that
references it is __cpuinit, so this function can also be __cpuinit,
thereby saving space when HOTPLUG_CPU=n.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/s390/appldata/appldata_base.c |   48 +-----------------------------------
 1 files changed, 1 insertions(+), 47 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index a355d81..e74a5fb 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -547,7 +547,7 @@ static void __cpuinit appldata_online_cpu(int cpu)
 	spin_unlock(&appldata_timer_lock);
 }
 
-static void __cpuexit appldata_offline_cpu(int cpu)
+static void __cpuinit appldata_offline_cpu(int cpu)
 {
 	del_virt_timer(&per_cpu(appldata_timer, cpu));
 	if (atomic_dec_and_test(&appldata_expire_count)) {
@@ -607,61 +607,15 @@ static int __init appldata_init(void)
 	register_hotcpu_notifier(&appldata_nb);
 
 	appldata_sysctl_header = register_sysctl_table(appldata_dir_table);
-#ifdef MODULE
-	appldata_dir_table[0].de->owner = THIS_MODULE;
-	appldata_table[0].de->owner = THIS_MODULE;
-	appldata_table[1].de->owner = THIS_MODULE;
-#endif
 
 	P_DEBUG("Base interface initialized.\n");
 	return 0;
 }
 
-/*
- * appldata_exit()
- *
- * stop timer, unregister /proc entries
- */
-static void __exit appldata_exit(void)
-{
-	struct list_head *lh;
-	struct appldata_ops *ops;
-	int rc, i;
-
-	P_DEBUG("Unloading module ...\n");
-	/*
-	 * ops list should be empty, but just in case something went wrong...
-	 */
-	spin_lock(&appldata_ops_lock);
-	list_for_each(lh, &appldata_ops_list) {
-		ops = list_entry(lh, struct appldata_ops, list);
-		rc = appldata_diag(ops->record_nr, APPLDATA_STOP_REC,
-				(unsigned long) ops->data, ops->size,
-				ops->mod_lvl);
-		if (rc != 0) {
-			P_ERROR("STOP DIAG 0xDC for %s failed, "
-				"return code: %d\n", ops->name, rc);
-		}
-	}
-	spin_unlock(&appldata_ops_lock);
-
-	unregister_hotcpu_notifier(&appldata_nb);
-
-	for_each_online_cpu(i)
-		appldata_offline_cpu(i);
-
-	appldata_timer_active = 0;
-
-	unregister_sysctl_table(appldata_sysctl_header);
-
-	destroy_workqueue(appldata_wq);
-	P_DEBUG("... module unloaded!\n");
-}
 /**************************** init / exit <END> ******************************/
 
 
 module_init(appldata_init);
-module_exit(appldata_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Gerald Schaefer");
 MODULE_DESCRIPTION("Linux-VM Monitor Stream, base infrastructure");
