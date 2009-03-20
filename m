Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbZCTSDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbZCTSDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbZCTSC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:02:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42961 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443AbZCTSC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=uqpwyB1TLMCWtq6Od2aM/PKqO+0omSyYm3x1k6nK0nKgyV9CCv4rl2ee0JVTweFmWT
         IkZ8MVXtexY3UW8waaNVi69l4e7NA3lzNH8RQ1PclD0PUe/02oDvEtDH7P/MHL16sqk8
         Q/uEBfEMn/kNK5cgD9uwrR6Eldtd8dem425MY=
From: Alessio Igor Bogani <abogani@texware.it>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] sony-laptop: Kill the BKL
Date: Fri, 20 Mar 2009 19:02:45 +0100
Message-Id: <1237572165-6494-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/platform/x86/sony-laptop.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 537959d..15f940b 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -46,7 +46,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
@@ -1934,10 +1933,15 @@ static int sonypi_misc_release(struct inode *inode, struct file *file)
 static int sonypi_misc_open(struct inode *inode, struct file *file)
 {
 	/* Flush input queue on first open */
-	lock_kernel();
+	unsigned long flags;
+
+	spin_lock_irqsave(sonypi_compat.fifo->lock, flags);
+
 	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
-		kfifo_reset(sonypi_compat.fifo);
-	unlock_kernel();
+		__kfifo_reset(sonypi_compat.fifo);
+
+	spin_unlock_irqrestore(sonypi_compat.fifo->lock, flags);
+
 	return 0;
 }
 
-- 
1.6.0.4

