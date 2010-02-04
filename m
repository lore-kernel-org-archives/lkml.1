Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab0BDXSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:18:36 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:46606 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758475Ab0BDXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:18:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kSYwpPZLNKfw/bx7YJSDwgjiSJdyzLRh57SSETf3it+/grv2VEA10af16SpMmO9310
         8XeZlpovOgsbmDaV+v/PR3j/nlaNRUkdpRIruGoY12exb1IKFRE/gnQUB5gLgDq8BYaK
         oj72RtE0MEWf3rmrhBP7a6wtWMqVuH+zTV7kg=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: Philip Langdale <philipl@overt.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH] MMC: fix hang if card was removed during suspend and unsafe resume was enabled
Date: Fri,  5 Feb 2010 01:18:15 +0200
Message-Id: <1265325495-4220-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265219241.12549.8.camel@maxim-laptop>
References: <1265219241.12549.8.camel@maxim-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently removal of the card leads to del_disk called indirectly by mmc core.
This function expects userspace to be running, which isn't when .resume is called

Fix that by removing the code that did that in mmc_resume_host. It is possible
because card detection logic will kick it later and remove the card.

Also make mtd workqueue freezeable, so it won't attempt to add/remove the card
while userspace is frozen.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mmc/core/core.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 30acd52..879d48d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1257,7 +1257,6 @@ int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 	if (host->caps & MMC_CAP_DISABLE)
 		cancel_delayed_work(&host->disable);
 	cancel_delayed_work(&host->detect);
-	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
@@ -1300,15 +1299,11 @@ int mmc_resume_host(struct mmc_host *host)
 		mmc_select_voltage(host, host->ocr);
 		BUG_ON(!host->bus_ops->resume);
 		err = host->bus_ops->resume(host);
+
 		if (err) {
 			printk(KERN_WARNING "%s: error %d during resume "
 					    "(card was removed?)\n",
 					    mmc_hostname(host), err);
-			if (host->bus_ops->remove)
-				host->bus_ops->remove(host);
-			mmc_claim_host(host);
-			mmc_detach_bus(host);
-			mmc_release_host(host);
 			/* no need to bother upper layers */
 			err = 0;
 		}
@@ -1332,7 +1327,7 @@ static int __init mmc_init(void)
 {
 	int ret;
 
-	workqueue = create_singlethread_workqueue("kmmcd");
+	workqueue = create_freezeable_workqueue("kmmcd");
 	if (!workqueue)
 		return -ENOMEM;
 
-- 
1.6.3.3

