Return-Path: <linux-kernel-owner+w=401wt.eu-S932763AbXHNR6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbXHNR6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 13:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764519AbXHNR6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 13:58:23 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:5486 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbXHNR6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 13:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ncUcKBC/OMkzaZpXJXe42wWYwatB/TQ47wT0rHs7g2D8lSwKwb6MBPGeVGaeLxGylm4Sll9qiXFTzX4MGaa4vzBZmEmr3X3T7n9ddb572Iy0vS4hIOIylwKeKBAWYNVRt2Yuhal7Il7i+JkFK/ZjWjzYniJfRWADAotezk+86xA=
Message-ID: <5767b9100708141058q24e3562s8f414963eeca64f3@mail.gmail.com>
Date: Wed, 15 Aug 2007 01:58:21 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       a.zummo@towertech.it
Subject: [PATCH] rtc-dev.c: remove to_rtc_device macro
Cc: rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
  According to rtc_dev_open() in file rtc-dev.c (see below), all the
to_rtc_device macro in rtc file_operations functions should be
removed, namely:
  "struct rtc_device *rtc = to_rtc_device(file->private_data);"
should be modified to: "struct rtc_device *rtc = file->private_data;"

  to_rtc_device is not a correct usage here, what's more, pls consider
when dev were not the first member of struct rtc_device :)

static int rtc_dev_open(struct inode *inode, struct file *file)
{
    int err;
    //...<snip>

    file->private_data = rtc;

    //...<snip>
}

Signed-off-by: conke.hu@gmail.com

------------------------------
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 005fff3..9552577 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -142,7 +142,7 @@ static int set_uie(struct rtc_device *rtc)
 static ssize_t
 rtc_dev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;

 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long data;
@@ -196,7 +196,7 @@ rtc_dev_read(struct file *file, char __user *buf,
size_t count, loff_t *ppos)

 static unsigned int rtc_dev_poll(struct file *file, poll_table *wait)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;
 	unsigned long data;

 	poll_wait(file, &rtc->irq_queue, wait);
@@ -405,7 +405,7 @@ static int rtc_dev_ioctl(struct inode *inode,
struct file *file,

 static int rtc_dev_release(struct inode *inode, struct file *file)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;

 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	clear_uie(rtc);
@@ -419,7 +419,7 @@ static int rtc_dev_release(struct inode *inode,
struct file *file)

 static int rtc_dev_fasync(int fd, struct file *file, int on)
 {
-	struct rtc_device *rtc = to_rtc_device(file->private_data);
+	struct rtc_device *rtc = file->private_data;
 	return fasync_helper(fd, file, on, &rtc->async_queue);
 }
