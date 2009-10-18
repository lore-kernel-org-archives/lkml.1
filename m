Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZJRUMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZJRUMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 16:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbZJRUMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 16:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbZJRUL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 16:11:59 -0400
Date: Sun, 18 Oct 2009 22:11:32 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] hpet: Remove BKL from hpet_open
Message-ID: <alpine.LFD.2.00.0910182210220.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8dea55a14071c1b3445fc8a934f96c47dd35a1e1 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 22:07:01 +0200
Subject: [PATCH] hpet: Remove BKL from hpet_open

hpet_open received the BKL from commit 48b81880519274d2a8b3e9919a47d91d05a1c964
during the BKL pushdown.

It is not needed here because everything is serialized via the hpet_lock

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/hpet.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 70a770a..5e83828 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/major.h>
@@ -251,7 +250,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
 
-	lock_kernel();
 	spin_lock_irq(&hpet_lock);
 
 	for (devp = NULL, hpetp = hpets; hpetp && !devp; hpetp = hpetp->hp_next)
@@ -265,7 +263,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 
 	if (!devp) {
 		spin_unlock_irq(&hpet_lock);
-		unlock_kernel();
 		return -EBUSY;
 	}
 
@@ -273,7 +270,6 @@ static int hpet_open(struct inode *inode, struct file *file)
 	devp->hd_irqdata = 0;
 	devp->hd_flags |= HPET_OPEN;
 	spin_unlock_irq(&hpet_lock);
-	unlock_kernel();
 
 	hpet_timer_set_irq(devp);
 
-- 
1.6.0.6

