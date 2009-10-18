Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZJRUyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZJRUyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 16:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZJRUyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 16:54:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbZJRUyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 16:54:49 -0400
Date: Sun, 18 Oct 2009 22:54:20 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH RFC] raw: Remove the BKL from raw_open
Message-ID: <alpine.LFD.2.00.0910182252330.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made this RFC in case folks with more experience spot something I've 
missed, although this looks pretty safe to me.

>From c1700fbd613ac94d95406eb83ada3d15e511e98c Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 22:45:34 +0200
Subject: [PATCH] raw: Remove the BKL from raw_open

The BKL was pushed into raw_open with
commit c0bed680f0ca603864375ed5f9fed4296a53aa62

Jonathan's comments were " Put explicit lock_kernel() calls into raw_open(), even though the existing locking looks adequate."

I have to agree, the raw_mutex should provide all the protection needed here.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/raw.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 64acd05..d9cfad1 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -19,7 +19,6 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -54,7 +53,6 @@ static int raw_open(struct inode *inode, struct file *filp)
 		return 0;
 	}
 
-	lock_kernel();
 	mutex_lock(&raw_mutex);
 
 	/*
@@ -81,7 +79,6 @@ static int raw_open(struct inode *inode, struct file *filp)
 			bdev->bd_inode->i_mapping;
 	filp->private_data = bdev;
 	mutex_unlock(&raw_mutex);
-	unlock_kernel();
 	return 0;
 
 out2:
@@ -90,7 +87,6 @@ out1:
 	blkdev_put(bdev, filp->f_mode);
 out:
 	mutex_unlock(&raw_mutex);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.0.6

