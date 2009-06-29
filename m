Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZF2QA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZF2QA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZF2QAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:00:51 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:48790 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbZF2QAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:00:50 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/5] watchdog: w83697ug, fix lock imbalance
Date: Mon, 29 Jun 2009 18:00:39 +0200
Message-Id: <1246291239-3331-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to unlock io_lock when w83697ug_select_wd_register fails in
wdt_ctrl.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/watchdog/w83697ug_wdt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index 883b5f7..a6c12de 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -149,8 +149,10 @@ static void wdt_ctrl(int timeout)
 {
 	spin_lock(&io_lock);
 
-	if (w83697ug_select_wd_register() < 0)
+	if (w83697ug_select_wd_register() < 0) {
+		spin_unlock(&io_lock);
 		return;
+	}
 
 	outb_p(0xF4, WDT_EFER);    /* Select CRF4 */
 	outb_p(timeout, WDT_EFDR); /* Write Timeout counter to CRF4 */
-- 
1.6.3.2

