Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYHDRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYHDRKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYHDRKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:10:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55591 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754182AbYHDRKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:10:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/6] Fix locking
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 04 Aug 2008 17:53:22 +0100
Message-ID: <20080804165305.15222.45811.stgit@localhost.localdomain>
In-Reply-To: <20080804164941.15222.24613.stgit@localhost.localdomain>
References: <20080804164941.15222.24613.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Use unlocked_ioctl
Remove semaphores

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/ar7_wdt.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)


diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 2eb48c0..ef7b0d6 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -69,7 +69,8 @@ struct ar7_wdt {
 	u32 prescale;
 };
 
-static struct semaphore open_semaphore;
+static unsigned long wdt_is_open;
+static spinlock_t wdt_lock;
 static unsigned expect_close;
 
 /* XXX currently fixed, allows max margin ~68.72 secs */
@@ -154,8 +155,10 @@ static void ar7_wdt_update_margin(int new_margin)
 	u32 change;
 
 	change = new_margin * (ar7_vbus_freq() / prescale_value);
-	if (change < 1) change = 1;
-	if (change > 0xffff) change = 0xffff;
+	if (change < 1)
+		change = 1;
+	if (change > 0xffff)
+		change = 0xffff;
 	ar7_wdt_change(change);
 	margin = change * prescale_value / ar7_vbus_freq();
 	printk(KERN_INFO DRVNAME
@@ -179,7 +182,7 @@ static void ar7_wdt_disable_wdt(void)
 static int ar7_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 	ar7_wdt_enable_wdt();
 	expect_close = 0;
@@ -195,9 +198,7 @@ static int ar7_wdt_release(struct inode *inode, struct file *file)
 		"will not disable the watchdog timer\n");
 	else if (!nowayout)
 		ar7_wdt_disable_wdt();
-
-	up(&open_semaphore);
-
+	clear_bit(0, &wdt_is_open);
 	return 0;
 }
 
@@ -222,7 +223,9 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 	if (len) {
 		size_t i;
 
+		spin_lock(&wdt_lock);
 		ar7_wdt_kick(1);
+		spin_unlock(&wdt_lock);
 
 		expect_close = 0;
 		for (i = 0; i < len; ++i) {
@@ -237,8 +240,8 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 	return len;
 }
 
-static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long ar7_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info ident = {
 		.identity = LONGNAME,
@@ -269,8 +272,10 @@ static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
 		if (new_margin < 1)
 			return -EINVAL;
 
+		spin_lock(&wdt_lock);
 		ar7_wdt_update_margin(new_margin);
 		ar7_wdt_kick(1);
+		spin_unlock(&wdt_lock);
 
 	case WDIOC_GETTIMEOUT:
 		if (put_user(margin, (int *)arg))
@@ -282,7 +287,7 @@ static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
 static const struct file_operations ar7_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ar7_wdt_write,
-	.ioctl		= ar7_wdt_ioctl,
+	.unlocked_ioctl	= ar7_wdt_ioctl,
 	.open		= ar7_wdt_open,
 	.release	= ar7_wdt_release,
 };
@@ -297,6 +302,8 @@ static int __init ar7_wdt_init(void)
 {
 	int rc;
 
+	spin_lock_init(&wdt_lock);
+
 	ar7_wdt_get_regs();
 
 	if (!request_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt),
@@ -312,8 +319,6 @@ static int __init ar7_wdt_init(void)
 	ar7_wdt_prescale(prescale_value);
 	ar7_wdt_update_margin(margin);
 
-	sema_init(&open_semaphore, 1);
-
 	rc = register_reboot_notifier(&ar7_wdt_notifier);
 	if (rc) {
 		printk(KERN_ERR DRVNAME

