Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbYBOU4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbYBOU4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761763AbYBOUzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:55:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:55865 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761293AbYBOUzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:55:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/7] kgdb-light-v10: fix kgdboc dynamic module configuration
Date: Fri, 15 Feb 2008 14:55:52 -0600
Message-Id: <1203108958-1818-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
References: <1203108958-1818-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 Feb 2008 20:55:33.0281 (UTC) FILETIME=[1B2FF110:01C87015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the run time configuration of kgdboc such that it does not default
to 9600 baud if you use the "echo" command to configure the sysfs
module paramater.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/serial/kgdboc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 3418307..9cf0332 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -106,7 +106,9 @@ static void kgdboc_put_char(u8 chr)
 
 static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
 {
-	if (strlen(kmessage) >= MAX_CONFIG_LEN) {
+	int len = strlen(kmessage);
+
+	if (len >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdboc: config string too long\n");
 		return -ENOSPC;
 	}
@@ -125,6 +127,9 @@ static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
 	}
 
 	strcpy(config, kmessage);
+	/* Chop out \n char as a result of echo */
+	if (config[len - 1] == '\n')
+		config[len - 1] = '\0';
 
 	if (configured == 1)
 		cleanup_kgdboc();
-- 
1.5.4

