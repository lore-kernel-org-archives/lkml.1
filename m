Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZJWX2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZJWX2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZJWX2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:28:21 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:50362
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbZJWX2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:28:21 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: device@lanana.org, rubini@vision.unipv.it, gregkh@suse.de,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] misc: use a proper range for minor number dynamic allocation
Date: Fri, 23 Oct 2009 21:28:17 -0200
Message-Id: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current dynamic allocation of minor number for misc devices has some
drawbacks.

First of all, the range for dynamic numbers include some statically
allocated numbers. It goes from 63 to 0, and we have numbers in the
range from 1 to 15 already allocated. Although, it gives priority to the
higher and not allocated numbers, we may end up in a situation where we
must reject registering a driver which got a static number because a
driver got its number with dynamic allocation. Considering fs/dlm/user.c
allocates as many misc devices as lockspaces are created, and that we
have more than 50 users around, it's not unreasonable to reach that
situation.

The proposed solution uses the not yet reserved range from 64 to 127. If
more devices are needed, we may push 64 to 16. Moreover, if we don't
need to give priority to the higher numbers anymore, we can start using
the bitmap/bitops functions.

Finally, if there's a failure creating the device (because there's
already one with the same name, for example), the current implementation
does not clear the bit for the allocated minor and that number is lost
for future allocations.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/char/misc.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index afc8e26..6bc4f44 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -60,8 +60,9 @@ static DEFINE_MUTEX(misc_mtx);
 /*
  * Assigned numbers, used for dynamic minors
  */
+#define DYNAMIC_MINOR_BASE 64
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
-static unsigned char misc_minors[DYNAMIC_MINORS / 8];
+static DECLARE_BITMAP(misc_minors, DYNAMIC_MINORS);
 
 #ifdef CONFIG_PROC_FS
 static void *misc_seq_start(struct seq_file *seq, loff_t *pos)
@@ -199,24 +200,23 @@ int misc_register(struct miscdevice * misc)
 	}
 
 	if (misc->minor == MISC_DYNAMIC_MINOR) {
-		int i = DYNAMIC_MINORS;
-		while (--i >= 0)
-			if ( (misc_minors[i>>3] & (1 << (i&7))) == 0)
-				break;
-		if (i<0) {
+		int i = find_first_zero_bit(misc_minors, DYNAMIC_MINORS);
+		if (i >= DYNAMIC_MINORS) {
 			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
-		misc->minor = i;
+		misc->minor = DYNAMIC_MINOR_BASE + i;
+		set_bit(i, misc_minors);
 	}
 
-	if (misc->minor < DYNAMIC_MINORS)
-		misc_minors[misc->minor >> 3] |= 1 << (misc->minor & 7);
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
+		int i = misc->minor - DYNAMIC_MINOR_BASE;
+		if (i >= 0 && i < DYNAMIC_MINORS)
+			clear_bit(i, misc_minors);
 		err = PTR_ERR(misc->this_device);
 		goto out;
 	}
@@ -243,7 +243,7 @@ int misc_register(struct miscdevice * misc)
 
 int misc_deregister(struct miscdevice *misc)
 {
-	int i = misc->minor;
+	int i = misc->minor - DYNAMIC_MINOR_BASE;
 
 	if (list_empty(&misc->list))
 		return -EINVAL;
@@ -251,9 +251,8 @@ int misc_deregister(struct miscdevice *misc)
 	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
 	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
-	if (i < DYNAMIC_MINORS && i>0) {
-		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
-	}
+	if (i >= 0 && i < DYNAMIC_MINORS)
+		clear_bit(i, misc_minors);
 	mutex_unlock(&misc_mtx);
 	return 0;
 }
-- 
1.6.3.3

