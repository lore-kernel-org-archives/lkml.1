Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYJPOpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYJPOpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYJPOpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:45:07 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:6638 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752536AbYJPOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:45:06 -0400
Date: Thu, 16 Oct 2008 18:45:03 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: fix oops on reading sysfs exported GPIOs
Message-ID: <20081016144503.GA17455@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can get the following oops when a GPIO controller doesn't provide
.direction_input and .get callbacks:

root@b1:~# cat /sys/class/gpio/gpio255/value
Unable to handle kernel paging request for instruction fetch
Faulting instruction address: 0x00000000
Oops: Kernel access of bad area, sig: 11 [#1]
[...]
NIP [00000000] 0x0
LR [c0182fb0] gpio_get_value_cansleep+0x40/0x50
Call Trace:
[c7b79e80] [c0183f28] gpio_value_show+0x5c/0x94
[c7b79ea0] [c01a584c] dev_attr_show+0x30/0x7c
[c7b79eb0] [c00d6b48] fill_read_buffer+0x68/0xe0
[c7b79ed0] [c00d6c54] sysfs_read_file+0x94/0xbc
[c7b79ef0] [c008f24c] vfs_read+0xb4/0x16c
[c7b79f10] [c008f580] sys_read+0x4c/0x90
[c7b79f40] [c0013a14] ret_from_syscall+0x0/0x38

GPIO users should always issue the gpio_direction_input() call and
check its return value prior to trying gpio_get_value().

For sysfs users there are few ways to solve the problem:

1. Call gpio_direction_input() in the gpio_value_show(). This isn't
   good because some GPIO controllers provide capability to read-back
   output pins. Using the FLAG_IS_OUT isn't good for the same reason.

2. Call gpio_direction_input() at the export time, if succeeded, set
   FLAG_CAN_INPUT. Then check that flag in the gpio_value_show().
   Viable.

3. Just check for .get != NULL in the gpio_value_show(). Most
   straightforward. This is implemented in the patch.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8d29405..4e4a498 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -236,6 +236,8 @@ static ssize_t gpio_value_show(struct device *dev,
 
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
+	else if (!desc->chip->get)
+		status = -EINVAL;
 	else
 		status = sprintf(buf, "%d\n", gpio_get_value_cansleep(gpio));
 
-- 
1.5.6.3
