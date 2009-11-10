Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbZKJAaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbZKJAaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZKJAaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:30:19 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:54792
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837AbZKJAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:30:17 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: device@lanana.org, akpm@linux-foundation.org, rubini@gnudd.com,
       gregkh@suse.de, hpa@zytor.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 2/3] misc: use bitmap/bitops functions for dynamic minor number allocation
Date: Mon,  9 Nov 2009 22:30:16 -0200
Message-Id: <1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_BITMAP, find_first_zero_bit, set_bit and clear_bit instead
of rewriting code to do it with the minor number dynamic allocation
bitmap.

We need to invert the bit position to keep the code behaviour of using
the last minor numbers first, since we don't have a find_last_zero_bit.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/char/misc.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 95d1282..59fff30 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -61,7 +61,7 @@ static DEFINE_MUTEX(misc_mtx);
  * Assigned numbers, used for dynamic minors
  */
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
-static unsigned char misc_minors[DYNAMIC_MINORS / 8];
+static DECLARE_BITMAP(misc_minors, DYNAMIC_MINORS);
 
 extern int pmu_device_init(void);
 
@@ -201,27 +201,23 @@ int misc_register(struct miscdevice * misc)
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
+		misc->minor = DYNAMIC_MINORS - i - 1;
+		set_bit(i, misc_minors);
 	}
 
-	if (misc->minor < DYNAMIC_MINORS)
-		misc_minors[misc->minor >> 3] |= 1 << (misc->minor & 7);
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
-		int i = misc->minor;
+		int i = DYNAMIC_MINORS - misc->minor - 1;
 		if (i < DYNAMIC_MINORS && i >= 0)
-			misc_minors[i>>3] &= ~(1 << (i & 7));
+			clear_bit(i, misc_minors);
 		err = PTR_ERR(misc->this_device);
 		goto out;
 	}
@@ -248,7 +244,7 @@ int misc_register(struct miscdevice * misc)
 
 int misc_deregister(struct miscdevice *misc)
 {
-	int i = misc->minor;
+	int i = DYNAMIC_MINORS - misc->minor - 1;
 
 	if (list_empty(&misc->list))
 		return -EINVAL;
@@ -257,7 +253,7 @@ int misc_deregister(struct miscdevice *misc)
 	list_del(&misc->list);
 	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	if (i < DYNAMIC_MINORS && i >= 0)
-		misc_minors[i>>3] &= ~(1 << (i & 7));
+		clear_bit(i, misc_minors);
 	mutex_unlock(&misc_mtx);
 	return 0;
 }
-- 
1.6.3.3

