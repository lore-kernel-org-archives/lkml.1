Return-Path: <linux-kernel-owner+w=401wt.eu-S935072AbYBAEsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935072AbYBAEsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765289AbYBAEm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:28 -0500
Received: from mga10.intel.com ([192.55.52.92]:46275 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757722AbYBAEl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516607"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 24/37] ACPI: clear GPE earily in resume to avoid warning
Date: Thu, 31 Jan 2008 23:36:55 -0500
Message-Id: <4e29bddd1bc13fe78da1d1a11dcb335f7fe36f6e.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

Wakeup GPE hasn't a handler. If system is waked up by such GPE like a
USB hotplug, I saw a lot of error reporting the GPE hasn't handler.
acpi_leave_sleep_state will clear the GPE but it's too late, we should
do it before interrupt is re-enabled.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sleep/main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index cbfa058..96d23b3 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -146,6 +146,13 @@ static int acpi_pm_enter(suspend_state_t pm_state)
 	if (ACPI_SUCCESS(status) && (acpi_state == ACPI_STATE_S3))
 		acpi_clear_event(ACPI_EVENT_POWER_BUTTON);
 
+	/*
+	 * Disable and clear GPE status before interrupt is enabled. Some GPEs
+	 * (like wakeup GPE) haven't handler, this can avoid such GPE misfire.
+	 * acpi_leave_sleep_state will reenable specific GPEs later
+	 */
+	acpi_hw_disable_all_gpes();
+
 	local_irq_restore(flags);
 	printk(KERN_DEBUG "Back to C!\n");
 
-- 
1.5.4.rc5.16.gc0279

