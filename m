Return-Path: <linux-kernel-owner+w=401wt.eu-S1761008AbYCDVHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbYCDVHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbYCDVHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:07:12 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:63531 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbYCDVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Gl60NAEbDPsPyvI7bE+hhbMrIJg/ko4EdehlqRxyWFuQA05VKvbCrd1DfMTSfe7Ue3AEr0tRWbe5x05F/Y6782UaEx7bMpwP0HmtV3klz429Oc8RMXshQAprIcHXkzQOE5SsqqAm8DAH2GDUx6RSbV5b9KXIiUUZ+zVq1RMWV7I=
Subject: [JANITOR-PATCH] rtc: switch to unlocked_ioctl
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>, Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 13:06:43 -0800
Message-Id: <1204664803.5698.27.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the lock/unlock_kernel explicit.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/arm/common/rtctime.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
index f53bca4..2062f92 100644
--- a/arch/arm/common/rtctime.c
+++ b/arch/arm/common/rtctime.c
@@ -173,8 +173,7 @@ static unsigned int rtc_poll(struct file *file, poll_table *wait)
 	return data != 0 ? POLLIN | POLLRDNORM : 0;
 }
 
-static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct rtc_ops *ops = file->private_data;
 	struct rtc_time tm;
@@ -182,6 +181,7 @@ static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	void __user *uarg = (void __user *)arg;
 	int ret = -EINVAL;
 
+	lock_kernel();
 	switch (cmd) {
 	case RTC_ALM_READ:
 		ret = rtc_arm_read_alarm(ops, &alrm);
@@ -276,6 +276,7 @@ static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			ret = ops->ioctl(cmd, arg);
 		break;
 	}
+	unlock_kernel();
 	return ret;
 }
 
@@ -333,7 +334,7 @@ static const struct file_operations rtc_fops = {
 	.llseek		= no_llseek,
 	.read		= rtc_read,
 	.poll		= rtc_poll,
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
 	.fasync		= rtc_fasync,
-- 
1.5.4.3.500.g83a2c



