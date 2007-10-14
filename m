Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbXJNFeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbXJNFeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXJNFd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:33:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbXJNFd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:33:56 -0400
Date: Sun, 14 Oct 2007 00:33:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] MMC/SD: Fix regression in 2.6.23-git3 due to change in calling add_uevent_var
Message-ID: <4711aa42.y6JoJfYdYdcIu66P%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 7eff2e7a8b65c25920207324e56611150eb1cd9a, the calling sequence
for add_uevent_var was changed. This patch propagates this change to
MMC/SD card support.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Linus, Andrew,

The wring patch was sent the first time.

Sorry,

Larry


 drivers/mmc/core/sdio_bus.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/mmc/core/sdio_bus.c
===================================================================
--- linux-2.6.orig/drivers/mmc/core/sdio_bus.c
+++ linux-2.6/drivers/mmc/core/sdio_bus.c
@@ -96,30 +96,21 @@ static int sdio_bus_match(struct device 
 }
 
 static int
-sdio_bus_uevent(struct device *dev, char **envp, int num_envp, char *buf,
-		int buf_size)
+sdio_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	int i = 0, length = 0;
 
-	if (add_uevent_var(envp, num_envp, &i,
-			buf, buf_size, &length,
-			"SDIO_CLASS=%02X", func->class))
+	if (add_uevent_var(env, "SDIO_CLASS=%02X", func->class))
 		return -ENOMEM;
 
-	if (add_uevent_var(envp, num_envp, &i,
-			buf, buf_size, &length,
-			"SDIO_ID=%04X:%04X", func->vendor, func->device))
+	if (add_uevent_var(env, "SDIO_ID=%04X:%04X", func->vendor,
+			func->device))
 		return -ENOMEM;
 
-	if (add_uevent_var(envp, num_envp, &i,
-			buf, buf_size, &length,
-			"MODALIAS=sdio:c%02Xv%04Xd%04X",
+	if (add_uevent_var(env, "MODALIAS=sdio:c%02Xv%04Xd%04X",
 			func->class, func->vendor, func->device))
 		return -ENOMEM;
 
-	envp[i] = NULL;
-
 	return 0;
 }
 
