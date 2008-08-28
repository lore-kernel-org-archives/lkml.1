Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYH1MwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYH1MwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYH1MwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:52:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44158 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYH1MwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:52:11 -0400
Date: Thu, 28 Aug 2008 14:52:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: kkeil@novell.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Misc mISDN timerdev fixes
Message-ID: <20080828125206.GA25855@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten,

For some reason i looked at the mISDN timerdev code and noticed
some minor issues (which I fixed) and a major one (which I only
commented). The major one is a SMP timer race. I think it needs
reference counting on the timer object to fix properly.

-Andi

--

Misc mISDN timerdev fixes

- Remove noop VFS stubs. The VFS does that on a NULL pointer anyways.
- Fix timer handler prototype to be correct
- Comment ugly SMP race I didn't fix.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.27-rc4-misc/drivers/isdn/mISDN/timerdev.c
===================================================================
--- linux-2.6.27-rc4-misc.orig/drivers/isdn/mISDN/timerdev.c
+++ linux-2.6.27-rc4-misc/drivers/isdn/mISDN/timerdev.c
@@ -124,18 +124,6 @@ mISDN_read(struct file *filep, char *buf
 	return ret;
 }
 
-static loff_t
-mISDN_llseek(struct file *filep, loff_t offset, int orig)
-{
-	return -ESPIPE;
-}
-
-static ssize_t
-mISDN_write(struct file *filep, const char *buf, size_t count, loff_t *off)
-{
-	return -EOPNOTSUPP;
-}
-
 static unsigned int
 mISDN_poll(struct file *filep, poll_table *wait)
 {
@@ -157,8 +145,9 @@ mISDN_poll(struct file *filep, poll_tabl
 }
 
 static void
-dev_expire_timer(struct mISDNtimer *timer)
+dev_expire_timer(unsigned long data)
 {
+	struct mISDNtimer *timer = (void *)data;
 	u_long			flags;
 
 	spin_lock_irqsave(&timer->dev->lock, flags);
@@ -191,7 +180,7 @@ misdn_add_timer(struct mISDNtimerdev *de
 		spin_unlock_irqrestore(&dev->lock, flags);
 		timer->dev = dev;
 		timer->tl.data = (long)timer;
-		timer->tl.function = (void *) dev_expire_timer;
+		timer->tl.function = dev_expire_timer;
 		init_timer(&timer->tl);
 		timer->tl.expires = jiffies + ((HZ * (u_long)timeout) / 1000);
 		add_timer(&timer->tl);
@@ -211,6 +200,9 @@ misdn_del_timer(struct mISDNtimerdev *de
 	list_for_each_entry(timer, &dev->pending, list) {
 		if (timer->id == id) {
 			list_del_init(&timer->list);
+			/* RED-PEN AK: race -- timer can be still running on
+			 * other CPU. Needs reference count I think
+ 		 	 */
 			del_timer(&timer->tl);
 			ret = timer->id;
 			kfree(timer);
@@ -268,9 +260,7 @@ mISDN_ioctl(struct inode *inode, struct 
 }
 
 static struct file_operations mISDN_fops = {
-	.llseek		= mISDN_llseek,
 	.read		= mISDN_read,
-	.write		= mISDN_write,
 	.poll		= mISDN_poll,
 	.ioctl		= mISDN_ioctl,
 	.open		= mISDN_open,
