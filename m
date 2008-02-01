Return-Path: <linux-kernel-owner+w=401wt.eu-S934842AbYBAEyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842AbYBAEyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765910AbYBAEm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:59 -0500
Received: from mga10.intel.com ([192.55.52.92]:64964 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764342AbYBAEmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:42:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516645"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 36/37] Hibernation: Invoke suspend notifications after console switch
Date: Thu, 31 Jan 2008 23:37:07 -0500
Message-Id: <6c6e1163d2b4833bf448f02aaf26e12053957078.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Following the recent change in the suspend code path, switch consoles before
calling PM notifiers during hibernation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 kernel/power/disk.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 53c22d9..d09da08 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -458,20 +458,13 @@ static void power_down(void)
 	while(1);
 }
 
-static void unprepare_processes(void)
-{
-	thaw_processes();
-	pm_restore_console();
-}
-
 static int prepare_processes(void)
 {
 	int error = 0;
 
-	pm_prepare_console();
 	if (freeze_processes()) {
 		error = -EBUSY;
-		unprepare_processes();
+		thaw_processes();
 	}
 	return error;
 }
@@ -491,6 +484,7 @@ int hibernate(void)
 		goto Unlock;
 	}
 
+	pm_prepare_console();
 	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
 	if (error)
 		goto Exit;
@@ -530,11 +524,12 @@ int hibernate(void)
 		swsusp_free();
 	}
  Thaw:
-	unprepare_processes();
+	thaw_processes();
  Finish:
 	free_basic_memory_bitmaps();
  Exit:
 	pm_notifier_call_chain(PM_POST_HIBERNATION);
+	pm_restore_console();
 	atomic_inc(&snapshot_device_available);
  Unlock:
 	mutex_unlock(&pm_mutex);
@@ -603,6 +598,7 @@ static int software_resume(void)
 		goto Unlock;
 	}
 
+	pm_prepare_console();
 	error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
 	if (error)
 		goto Finish;
@@ -626,11 +622,12 @@ static int software_resume(void)
 
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	swsusp_free();
-	unprepare_processes();
+	thaw_processes();
  Done:
 	free_basic_memory_bitmaps();
  Finish:
 	pm_notifier_call_chain(PM_POST_RESTORE);
+	pm_restore_console();
 	atomic_inc(&snapshot_device_available);
 	/* For success case, the suspend path will release the lock */
  Unlock:
-- 
1.5.4.rc5.16.gc0279

