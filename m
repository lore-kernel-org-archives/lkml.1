Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZLRNDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZLRNDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZLRNDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:03:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:45216 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZLRM5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:57:13 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net,
       andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/27] acpi: use queue_work_on() instead of binding workqueue worker to cpu0
Date: Fri, 18 Dec 2009 21:57:48 +0900
Message-Id: <1261141088-2014-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1261141088-2014-1-git-send-email-tj@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI works need to be executed on cpu0 and acpi/osl.c achieves this by
creating singlethread workqueue and then binding it to cpu0 from a
work which is quite unorthodox.  Make it create regular workqueues and
use queue_work_on() instead.  This is in preparation of concurrency
managed workqueue and the extra workers won't be a problem after it's
implemented.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/acpi/osl.c |   41 ++++++++++++-----------------------------
 1 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 02e8464..93f6647 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -191,36 +191,11 @@ acpi_status __init acpi_os_initialize(void)
 	return AE_OK;
 }
 
-static void bind_to_cpu0(struct work_struct *work)
-{
-	set_cpus_allowed_ptr(current, cpumask_of(0));
-	kfree(work);
-}
-
-static void bind_workqueue(struct workqueue_struct *wq)
-{
-	struct work_struct *work;
-
-	work = kzalloc(sizeof(struct work_struct), GFP_KERNEL);
-	INIT_WORK(work, bind_to_cpu0);
-	queue_work(wq, work);
-}
-
 acpi_status acpi_os_initialize1(void)
 {
-	/*
-	 * On some machines, a software-initiated SMI causes corruption unless
-	 * the SMI runs on CPU 0.  An SMI can be initiated by any AML, but
-	 * typically it's done in GPE-related methods that are run via
-	 * workqueues, so we can avoid the known corruption cases by binding
-	 * the workqueues to CPU 0.
-	 */
-	kacpid_wq = create_singlethread_workqueue("kacpid");
-	bind_workqueue(kacpid_wq);
-	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
-	bind_workqueue(kacpi_notify_wq);
-	kacpi_hotplug_wq = create_singlethread_workqueue("kacpi_hotplug");
-	bind_workqueue(kacpi_hotplug_wq);
+	kacpid_wq = create_workqueue("kacpid");
+	kacpi_notify_wq = create_workqueue("kacpi_notify");
+	kacpi_hotplug_wq = create_workqueue("kacpi_hotplug");
 	BUG_ON(!kacpid_wq);
 	BUG_ON(!kacpi_notify_wq);
 	BUG_ON(!kacpi_hotplug_wq);
@@ -759,7 +734,15 @@ static acpi_status __acpi_os_execute(acpi_execute_type type,
 		(type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
 	dpc->wait = hp ? 1 : 0;
 	INIT_WORK(&dpc->work, acpi_os_execute_deferred);
-	ret = queue_work(queue, &dpc->work);
+
+	/*
+	 * On some machines, a software-initiated SMI causes corruption unless
+	 * the SMI runs on CPU 0.  An SMI can be initiated by any AML, but
+	 * typically it's done in GPE-related methods that are run via
+	 * workqueues, so we can avoid the known corruption cases by always
+	 * queueing on CPU 0.
+	 */
+	ret = queue_work_on(0, queue, &dpc->work);
 
 	if (!ret) {
 		printk(KERN_ERR PREFIX
-- 
1.6.4.2

