Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZJRTjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZJRTjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 15:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbZJRTjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 15:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058AbZJRTjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 15:39:47 -0400
Date: Sun, 18 Oct 2009 21:39:22 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RFC] PPC-BRIQ_PANEL: Remove BKL and replace with atomic
 variable.
Message-ID: <alpine.LFD.2.00.0910182137470.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b64c7d0f11eab96cb253b23c7264c999746116c0 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 21:29:21 +0200
Subject: [PATCH] PPC-BRIQ_PANEL: Remove BKL and replace with atomic variable.

There are no locks here except the bkl in briq_panel_open. It's only
purpose is to ensure single access. Remove the bkl and ensure single access
by making vfd_is_open an atomic_variable.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/briq_panel.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/char/briq_panel.c b/drivers/char/briq_panel.c
index d8cff90..5396df4 100644
--- a/drivers/char/briq_panel.c
+++ b/drivers/char/briq_panel.c
@@ -6,7 +6,6 @@
 
 #include <linux/module.h>
 
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
@@ -25,6 +24,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/prom.h>
+#include <asm/atomic.h>
 
 #define		BRIQ_PANEL_MINOR	156
 #define		BRIQ_PANEL_VFD_IOPORT	0x0390
@@ -32,7 +32,7 @@
 #define		BRIQ_PANEL_VER		"1.1 (04/20/2002)"
 #define		BRIQ_PANEL_MSG0		"Loading Linux"
 
-static int		vfd_is_open;
+static atomic_t vfd_is_open = ATOMIC_INIT(0);
 static unsigned char	vfd[40];
 static int		vfd_cursor;
 static unsigned char	ledpb, led;
@@ -68,35 +68,26 @@ static void set_led(char state)
 
 static int briq_panel_open(struct inode *ino, struct file *filep)
 {
-	lock_kernel();
-	/* enforce single access, vfd_is_open is protected by BKL */
-	if (vfd_is_open) {
-		unlock_kernel();
+	/* enforce single access */
+	if (atomic_cmpxchg(vfd_is_open, 0, 1))
 		return -EBUSY;
-	}
-	vfd_is_open = 1;
-
-	unlock_kernel();
 	return 0;
 }
 
 static int briq_panel_release(struct inode *ino, struct file *filep)
 {
-	if (!vfd_is_open)
+	if (!atomic_cmpxchg(vfd_is_open, 1, 0))
 		return -ENODEV;
-
-	vfd_is_open = 0;
-
 	return 0;
 }
 
-static ssize_t briq_panel_read(struct file *file, char __user *buf, size_t count,
-			 loff_t *ppos)
+static ssize_t briq_panel_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
 {
 	unsigned short c;
 	unsigned char cp;
 
-	if (!vfd_is_open)
+	if (!atomic_read(vfd_is_open))
 		return -ENODEV;
 
 	c = (inb(BRIQ_PANEL_LED_IOPORT) & 0x000c) | (ledpb & 0x0003);
-- 
1.6.0.6

