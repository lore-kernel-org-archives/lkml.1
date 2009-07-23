Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbZGWFAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbZGWFAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZGWFAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:00:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:38961 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZGWFAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UFFd9yfd9UIg3TxSi61eILf10VjLZzIHLNzSgLmNUkskur/LlHeb+taURn72N4k0WX
         KN6DEWt/diMC3+6EXPTr99ssP0BHbQGfZtHW6rIwt6bHQ49WhcwF1M+v7p713QHcVhQm
         FsxyCUUeyHQDaFVpUCV127NsARIqDqf/2CGe0=
From: unsik Kim <donari75@gmail.com>
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, unsik Kim <donari75@gmail.com>
Subject: [PATCH 2/2] mg_disk: fix reading invalid status when use polling driver
Date: Thu, 23 Jul 2009 13:57:46 +0900
Message-Id: <1248325066-4071-2-git-send-email-donari75@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1248325066-4071-1-git-send-email-donari75@gmail.com>
References: <1248325066-4071-1-git-send-email-donari75@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using polling driver, little delay is required to access
status register. Without this, host might read invalid status.

Signed-off-by: unsik Kim <donari75@gmail.com>
---
 drivers/block/mg_disk.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 26371d5..6d7fbaa 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -218,6 +218,16 @@ static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
 	host->error = MG_ERR_NONE;
 	expire = jiffies + msecs_to_jiffies(msec);
 
+	/* These 2 times dummy status read prevents reading invalid
+	 * status. A very little time (3 times of mflash operating clk)
+	 * is required for busy bit is set. Use dummy read instead of
+	 * busy wait, because mflash's PLL is machine dependent.
+	 */
+	if (prv_data->use_polling) {
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+	}
+
 	status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
 
 	do {
-- 
1.6.0.6

