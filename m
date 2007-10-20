Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbXJTFH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbXJTFH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXJTFHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:07:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:2219 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbXJTFHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type;
        b=nOqzZUh8zSmzxqPYHaVAYOPfAnddMcOpddI25z/Dbw7s3fbbUTC2BlWis3/OHzGIcVKQ8BgTS0kRjJvwFKkZQB2Qyp7m8EJT5lYefKPkmkkPf64stKKEXpZZ8r6EaMVMV/MrKhWPWOwd1nRxPaHNrXO8MbosIExAWX622udrT0U=
Message-ID: <47198CFD.8080304@gmail.com>
Date: Sat, 20 Oct 2007 01:07:09 -0400
From: emist <emistz@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Linux <linux-kernel@vger.kernel.org>
Subject: [PATCH] Bug fix for the s390 dcssblk driver
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------080005080905010200000002"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080005080905010200000002
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

The following patch fixes and issue in the s390 dcssblk driver. The
issue is caused when an unsuccessful attempt is made in order to change
a segment's type through the device attribute file "shared". This causes
the driver to remove the device in question, removing with it the device
attribute which is currently handling the call. The result is a hang on
the driver as it removes memory from under its feet.

Not exactly sure if this explanation makes sense or its entirely
accurate. This is what I believe at this point from encountering and
fixing the error. Anyway here is the patch, hope it helps.



--------------080005080905010200000002
Content-Type: text/plain;
 name="dcssblk_fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dcssblk_fix"

# This patch fixes a memory corruption bug in the s390 dcssblk driver.
# The bug occurs when an attempt to change the type of a segment 
# returns an error. At this point the driver tries to remove the segment in
# question while some of the device's attributes are in use. This causes the
# driver to hang.
# 
# questions/comments @ emistz@gmail.com

diff -urN linux-2.6.23.1/drivers/s390/block/dcssblk.c linuxx/drivers/s390/block/dcssblk.c
--- linux-2.6.23.1/drivers/s390/block/dcssblk.c	2007-10-12 12:43:44.000000000 -0400
+++ linuxx/drivers/s390/block/dcssblk.c	2007-10-20 00:51:19.000000000 -0400
@@ -253,8 +253,12 @@
 					   SEGMENT_EXCLUSIVE);
 		if (rc < 0) {
 			BUG_ON(rc == -EINVAL);
-			if (rc != -EAGAIN)
-				goto removeseg;
+			if (rc != -EAGAIN){
+				PRINT_DEBUG("Could not reload segment %s in the specified format, reloading\n",
+					dev_info->segment_name);
+				rc = segment_modify_shared(dev_info->segment_name, SEGMENT_SHARED);
+				goto out;	
+			}
 		} else {
 			dev_info->is_shared = 0;
 			set_disk_ro(dev_info->gd, 0);

--------------080005080905010200000002--
