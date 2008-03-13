Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYCMQM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYCMQM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYCMQL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:11:27 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27732 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYCMQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:11:26 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH 01/10] mtd: maps/physmap: fix oops in suspend/resume/shutdown ops
Date: Thu, 13 Mar 2008 15:39:36 +0100
Message-Id: <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0305 (UTC) FILETIME=[154BAF10:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

- - - -
# reboot
...
[   42.351266] Flash device refused suspend due to active operation (state 0)
[   42.358195] Unable to handle kernel NULL pointer dereference at virtual address 00000078
[   42.360060] pgd = c7d9c000
[   42.362769] [00000078] *pgd=a7d8d031, *pte=00000000, *ppte=00000000
[   42.372902] Internal error: Oops: 17 [#1]
[   42.376911] Modules linked in:
[   42.379980] CPU: 0    Not tainted  (2.6.25-rc2-10642-ge8f2594-dirty #73)
[   42.380000] PC is at physmap_flash_shutdown+0x28/0x54
...
[   42.380000] Backtrace:
[   42.380000] [<c0130c1c>] (physmap_flash_shutdown+0x0/0x54) from [<c01207c0>] (platform_drv_shutdown+0x20/0x24)
[   42.380000]  r5:28121969 r4:c0229e08
[   42.380000] [<c01207a0>] (platform_drv_shutdown+0x0/0x24) from [<c011cd40>] (device_shutdown+0x60/0x88)
[   42.380000] [<c011cce0>] (device_shutdown+0x0/0x88) from [<c003e8a4>] (kernel_restart_prepare+0x2c/0x3c)
[   42.380000]  r4:00000000
[   42.380000] [<c003e878>] (kernel_restart_prepare+0x0/0x3c) from [<c003ea00>] (kernel_restart+0x14/0x48)
[   42.380000] [<c003e9ec>] (kernel_restart+0x0/0x48) from [<c003fdc0>] (sys_reboot+0xe8/0x1f8)
[   42.380000]  r4:01234567
[   42.380000] [<c003fcd8>] (sys_reboot+0x0/0x1f8) from [<c001aa00>] (ret_fast_syscall+0x0/0x2c)
[   42.380000]  r7:00000058 r6:00000004 r5:00000001 r4:00000000
[   42.380000] Code: 0a000009 e7953004 e1a00003 e1a0e00f (e593f078)
[   42.650051] ---[ end trace 6d6c26a0fc3141de ]---
Segmentation fault
INIT: no more processes left in this runlevel
- - - -

While looping for mtd[i]s, we should stop at the mtd[i] == NULL.

This patch also removes unnecessary "if (info)" checks:
suspend/resume/shutdown ops are executed only if probe() is succeeded,
so info is guaranteed to be !NULL.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/mtd/maps/physmap.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index f00e04e..bc4649a 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -202,9 +202,8 @@ static int physmap_flash_suspend(struct platform_device *dev, pm_message_t state
 	int ret = 0;
 	int i;
 
-	if (info)
-		for (i = 0; i < MAX_RESOURCES; i++)
-			ret |= info->mtd[i]->suspend(info->mtd[i]);
+	for (i = 0; i < MAX_RESOURCES && info->mtd[i]; i++)
+		ret |= info->mtd[i]->suspend(info->mtd[i]);
 
 	return ret;
 }
@@ -214,9 +213,9 @@ static int physmap_flash_resume(struct platform_device *dev)
 	struct physmap_flash_info *info = platform_get_drvdata(dev);
 	int i;
 
-	if (info)
-		for (i = 0; i < MAX_RESOURCES; i++)
-			info->mtd[i]->resume(info->mtd[i]);
+	for (i = 0; i < MAX_RESOURCES && info->mtd[i]; i++)
+		info->mtd[i]->resume(info->mtd[i]);
+
 	return 0;
 }
 
@@ -225,8 +224,8 @@ static void physmap_flash_shutdown(struct platform_device *dev)
 	struct physmap_flash_info *info = platform_get_drvdata(dev);
 	int i;
 
-	for (i = 0; i < MAX_RESOURCES; i++)
-		if (info && info->mtd[i]->suspend(info->mtd[i]) == 0)
+	for (i = 0; i < MAX_RESOURCES && info->mtd[i]; i++)
+		if (info->mtd[i]->suspend(info->mtd[i]) == 0)
 			info->mtd[i]->resume(info->mtd[i]);
 }
 #else
-- 
1.5.4.3

