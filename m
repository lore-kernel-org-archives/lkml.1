Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYG0Gkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYG0Gkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbYG0GjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:39:19 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:29943 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbYG0GjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:39:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=KsYOq+haeCuEsz6Np1rUjMcAQQWGyV1VpHVpMRsbDLTczc37YytGNa3ZgJarPuzcH9
         i3W/ASaOFsr+G1+EisBVnrGpoa7rOK2q3gJrl6zqto6SfeFJOAEoYPO77ftIPVtY5yrn
         hjmpLFQ0CNTVC5WAv9hMdv+C+F2OS88/v42UU=
From: Bryan Wu <cooloney@kernel.org>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 6/8] Blackfin RTC Driver: wait for the write complete interrupt complete before sleeping
Date: Sun, 27 Jul 2008 14:38:25 +0800
Message-Id: <1217140707-21263-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
References: <1217140707-21263-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Since we use the write complete interrupt, wait for it
to complete before sleeping so we don't wake right back up due to it

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/rtc/rtc-bfin.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index d53772f..e6b0470 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -435,9 +435,10 @@ static int __devexit bfin_rtc_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev)) {
 		enable_irq_wake(IRQ_RTC);
-	else
+		bfin_rtc_sync_pending(&pdev->dev);
+	} else
 		bfin_rtc_int_clear(-1);
 
 	return 0;
-- 
1.5.6

