Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYAIFvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYAIFvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 00:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbYAIFvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 00:51:39 -0500
Received: from mail.suse.de ([195.135.220.2]:41459 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYAIFvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 00:51:38 -0500
Message-ID: <4785B342.2070501@suse.de>
Date: Thu, 10 Jan 2008 11:25:14 +0530
From: Nikanth Karthikesan <knikanth@suse.de>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Change x86 Machine check handler to use unlocked_iocl instead
 of ioctl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Machine check handler registers ioctl handler that is called
with the BKL held. Changing to register unlocked_ioctl instead.
Also mce ioctl handler does not seem to need any lock protection.

To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org

Change the Machine check handler to use unlocked_ioctl instead of
ioctl handler. Also the mce ioctl handler does not need any lock
protection.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c
b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 4b21d29..d3baa62 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -634,8 +634,7 @@ static unsigned int mce_poll(struct file *file,
poll_table *wait)
 	return 0;
 }

-static int mce_ioctl(struct inode *i, struct file *f,unsigned int cmd,
-		     unsigned long arg)
+static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int __user *p = (int __user *)arg;

@@ -664,7 +663,7 @@ static const struct file_operations mce_chrdev_ops = {
 	.release = mce_release,
 	.read = mce_read,
 	.poll = mce_poll,
-	.ioctl = mce_ioctl,
+	.unlocked_ioctl = mce_ioctl,
 };

 static struct miscdevice mce_log_device = {
