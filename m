Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZKJAaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZKJAaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZKJAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:30:18 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:54784
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828AbZKJAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:30:17 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: device@lanana.org, akpm@linux-foundation.org, rubini@gnudd.com,
       gregkh@suse.de, hpa@zytor.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/3] misc: clear allocation bit in minor bitmap when device register fails
Date: Mon,  9 Nov 2009 22:30:15 -0200
Message-Id: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there's a failure creating the device (because there's already one
with the same name, for example), the current implementation does not
clear the bit for the allocated minor and that number is lost for future
allocations.

Second, the test currently in misc_deregister is broken, since it does
not test for the 0 minor.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/char/misc.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 07fa612..95d1282 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -219,6 +219,9 @@ int misc_register(struct miscdevice * misc)
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
+		int i = misc->minor;
+		if (i < DYNAMIC_MINORS && i >= 0)
+			misc_minors[i>>3] &= ~(1 << (i & 7));
 		err = PTR_ERR(misc->this_device);
 		goto out;
 	}
@@ -253,9 +256,8 @@ int misc_deregister(struct miscdevice *misc)
 	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
 	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
-	if (i < DYNAMIC_MINORS && i>0) {
-		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
-	}
+	if (i < DYNAMIC_MINORS && i >= 0)
+		misc_minors[i>>3] &= ~(1 << (i & 7));
 	mutex_unlock(&misc_mtx);
 	return 0;
 }
-- 
1.6.3.3

