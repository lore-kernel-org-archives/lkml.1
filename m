Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZLKDE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZLKDE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZLKDEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:04:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:40271 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZLKDEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:04:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="221376690"
Date: Fri, 11 Dec 2009 11:04:58 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: [PATCH 2/2]ACPI: assign different lockdep key for acpi works
Message-ID: <20091211030458.GB7772@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Differentiate works for three different workqueue in ACPI. This fixes
a fase alarm from lockdep, as acpi hotplug workqueue waits other
workqueues.

http://bugzilla.kernel.org/show_bug.cgi?id=14553

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/acpi/osl.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux/drivers/acpi/osl.c
===================================================================
--- linux.orig/drivers/acpi/osl.c	2009-12-10 10:40:15.000000000 +0800
+++ linux/drivers/acpi/osl.c	2009-12-10 10:43:25.000000000 +0800
@@ -729,6 +729,8 @@ static acpi_status __acpi_os_execute(acp
 	struct acpi_os_dpc *dpc;
 	struct workqueue_struct *queue;
 	int ret;
+	static struct lock_class_key hp_key, notify_key, acpid_key;
+
 	ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
 			  "Scheduling function [%p(%p)] for deferred execution.\n",
 			  function, context));
@@ -758,7 +760,15 @@ static acpi_status __acpi_os_execute(acp
 	queue = hp ? kacpi_hotplug_wq :
 		(type == OSL_NOTIFY_HANDLER ? kacpi_notify_wq : kacpid_wq);
 	dpc->wait = hp ? 1 : 0;
-	INIT_WORK(&dpc->work, acpi_os_execute_deferred);
+	if (queue == kacpi_hotplug_wq)
+		INIT_WORK_KEY(&dpc->work, acpi_os_execute_deferred,
+				hp_key, "acpi_hp_work");
+	else if (queue == kacpi_notify_wq)
+		INIT_WORK_KEY(&dpc->work, acpi_os_execute_deferred,
+				notify_key, "acpi_notify_work");
+	else
+		INIT_WORK_KEY(&dpc->work, acpi_os_execute_deferred,
+				acpid_key, "acpi_acpid_work");
 	ret = queue_work(queue, &dpc->work);
 
 	if (!ret) {
