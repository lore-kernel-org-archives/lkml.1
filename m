Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZJRVzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZJRVzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 17:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZJRVzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 17:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZJRVzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 17:55:14 -0400
Date: Sun, 18 Oct 2009 23:54:53 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b5fefbe4ab8783a0299953b0869cf2af24160875 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 23:49:49 +0200
Subject: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open

The BKL is in this function because of the BKL pushdown
(see commit f8f2c79d594463427f7114cedb1555110d547d89)

It is not needed here because the mutex_lock sonypi_device.lock
provides the necessary locking.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/sonypi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 8c262aa..f64600b 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -50,7 +50,6 @@
 #include <linux/err.h>
 #include <linux/kfifo.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -902,14 +901,13 @@ static int sonypi_misc_release(struct inode *inode, struct file *file)
 
 static int sonypi_misc_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
 	mutex_lock(&sonypi_device.lock);
 	/* Flush input queue on first open */
 	if (!sonypi_device.open_count)
 		kfifo_reset(sonypi_device.fifo);
 	sonypi_device.open_count++;
 	mutex_unlock(&sonypi_device.lock);
-	unlock_kernel();
+
 	return 0;
 }
 
-- 
1.6.0.6

