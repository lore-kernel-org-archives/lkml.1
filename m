Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbYBAExh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbYBAExh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765551AbYBAEmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:55 -0500
Received: from mga10.intel.com ([192.55.52.92]:38807 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754474AbYBAEmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:42:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516642"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 35/37] Suspend: Invoke suspend notifications after console switch
Date: Thu, 31 Jan 2008 23:37:06 -0500
Message-Id: <a7c630e98acfad228bd2b3bba59e163ad86ed6ee.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

In order to fix APM emulation it is necessary to enable apm-emulation
notifications for suspends triggered in various ways via the suspend
notifiers.  However, this will cause the systems using APM emulation
to lock up between X being needed to switch away from the VT and X
already waiting for resume in the APM ioctl.

This patch moves the console switch (if enabled) before the suspend
notification (and after the resume notification) to avoid this issue.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 kernel/power/main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index e47214c..6a6d5eb 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -175,12 +175,12 @@ static int suspend_prepare(void)
 	if (!suspend_ops || !suspend_ops->enter)
 		return -EPERM;
 
+	pm_prepare_console();
+
 	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
 	if (error)
 		goto Finish;
 
-	pm_prepare_console();
-
 	if (suspend_freeze_processes()) {
 		error = -EAGAIN;
 		goto Thaw;
@@ -200,9 +200,9 @@ static int suspend_prepare(void)
 
  Thaw:
 	suspend_thaw_processes();
-	pm_restore_console();
  Finish:
 	pm_notifier_call_chain(PM_POST_SUSPEND);
+	pm_restore_console();
 	return error;
 }
 
@@ -309,8 +309,8 @@ int suspend_devices_and_enter(suspend_state_t state)
 static void suspend_finish(void)
 {
 	suspend_thaw_processes();
-	pm_restore_console();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
+	pm_restore_console();
 }
 
 
-- 
1.5.4.rc5.16.gc0279

