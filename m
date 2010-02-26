Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935898Ab0BZMO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:14:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:43302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935885Ab0BZMOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:22 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/43] acpi: use queue_work_on() instead of binding workqueue worker to cpu0
Date: Fri, 26 Feb 2010 21:22:46 +0900
Message-Id: <1267187000-18791-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:26 +0000 (UTC)
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

