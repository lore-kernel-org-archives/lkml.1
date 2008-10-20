Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYJTTmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYJTTmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYJTTl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:41:58 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:13172 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYJTTl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OmnBT7yc/Wt2R8YRDYPuJMQ1a+p5vnEdrKJyyL6aiNBNRyKjYUUzSVYhPIFcqLbOM3
         nItMMWtCJu78rfxBYGK8pjVHyooLQdqq1jiyRgIgdIYGsexRsZ1BE82PrKpH6xqyl252
         3pn6BRV1gK62IWTNZb/1vo0F8VtZMQwy1cFP4=
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH] MMC: Fix race condition in resume/card detect code
Date: Mon, 20 Oct 2008 22:41:48 +0300
Message-Id: <1224531708-13624-1-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081018191147.00327019@mjolnir.drzeus.cx>
References: <20081018191147.00327019@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device wakes up by card change interrupt and MMC_UNSAFE_RESUME is
enabled then race condition between mmc_rescan() and
mmc_resume()/mmc_sd_resume() appeared.

Resume functions can sleep into mmc_remove_card() and at this time
mmc_rescan() can be called by delayed work handler. Double-free of
kobject or double-remove of host->card can be result of this.

This patch adds an host->suspended flag which indicated that host is in
suspend state. mmc_rescan() checks it and returned when
host->suspended == 1. It's safe because resume code calls
mmc_detect_change() at end of resume process.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
---
 drivers/mmc/core/core.c  |    7 +++++++
 include/linux/mmc/host.h |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 044d84e..427f283 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -657,6 +657,9 @@ void mmc_rescan(struct work_struct *work)
 	u32 ocr;
 	int err;
 
+	if (host->suspended)
+		return;
+
 	mmc_bus_get(host);
 
 	if (host->bus_ops == NULL) {
@@ -780,6 +783,8 @@ int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 
 	mmc_power_off(host);
 
+	host->suspended = 1;
+
 	return 0;
 }
 
@@ -805,6 +810,8 @@ int mmc_resume_host(struct mmc_host *host)
 	 */
 	mmc_detect_change(host, 1);
 
+	host->suspended = 0;
+
 	return 0;
 }
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 9c288c9..a584239 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -139,6 +139,9 @@ struct mmc_host {
 #ifdef CONFIG_MMC_DEBUG
 	unsigned int		removed:1;	/* host is being removed */
 #endif
+#ifdef CONFIG_MMC_UNSAFE_RESUME
+	unsigned int		suspended:1;
+#endif
 
 	struct mmc_card		*card;		/* device attached to this host */
 
-- 
1.5.6.5

