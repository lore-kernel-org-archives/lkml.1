Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZKJAap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZKJAap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZKJAao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:30:44 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:54798
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847AbZKJAaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:30:19 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: device@lanana.org, akpm@linux-foundation.org, rubini@gnudd.com,
       gregkh@suse.de, hpa@zytor.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 3/3] misc: use a proper range for minor number dynamic allocation
Date: Mon,  9 Nov 2009 22:30:17 -0200
Message-Id: <1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
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
more devices are needed, we may push 64 to 16.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/char/misc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 59fff30..5681d3c 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -60,6 +60,7 @@ static DEFINE_MUTEX(misc_mtx);
 /*
  * Assigned numbers, used for dynamic minors
  */
+#define DYNAMIC_MINOR_BASE 64
 #define DYNAMIC_MINORS 64 /* like dynamic majors */
 static DECLARE_BITMAP(misc_minors, DYNAMIC_MINORS);
 
@@ -206,7 +207,7 @@ int misc_register(struct miscdevice * misc)
 			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
-		misc->minor = DYNAMIC_MINORS - i - 1;
+		misc->minor = DYNAMIC_MINOR_BASE + i;
 		set_bit(i, misc_minors);
 	}
 
@@ -215,7 +216,7 @@ int misc_register(struct miscdevice * misc)
 	misc->this_device = device_create(misc_class, misc->parent, dev,
 					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
-		int i = DYNAMIC_MINORS - misc->minor - 1;
+		int i = misc->minor - DYNAMIC_MINOR_BASE;
 		if (i < DYNAMIC_MINORS && i >= 0)
 			clear_bit(i, misc_minors);
 		err = PTR_ERR(misc->this_device);
@@ -244,7 +245,7 @@ int misc_register(struct miscdevice * misc)
 
 int misc_deregister(struct miscdevice *misc)
 {
-	int i = DYNAMIC_MINORS - misc->minor - 1;
+	int i = misc->minor - DYNAMIC_MINOR_BASE;
 
 	if (list_empty(&misc->list))
 		return -EINVAL;
-- 
1.6.3.3

