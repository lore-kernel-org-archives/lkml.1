Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZDDSDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZDDSDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZDDSDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:03:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:20850 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbZDDSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BVo23CX8WToIl0rreunngfPRrjMKVx9V9yj6oz7FTHHFMLWv20EvIaVzB6Z7YqpCkB
         RN8ay2/u2uyA/shKEitg6k3LFcEwO3QJ3bKAMY1PqCn6/+/c/lOyfxvnI/7GQiDYwR1l
         8GCLVhgyIvU2uP1izxZAl8b6wN7twByo35s6c=
MIME-Version: 1.0
Date: Sat, 4 Apr 2009 11:03:04 -0700
Message-ID: <a95a62fe0904041103w7fb5a647h5b8469060ed70abc@mail.gmail.com>
Subject: [PATCH] [MTD] sysfs support should not depend on CONFIG_PROC_FS
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the driver model init code out of the "#ifdef CONFIG_PROC_FS"
block.

Tested with both values of CONFIG_PROC_FS .  Tested with CONFIG_MTD=m .

Issue was reported here: http://lkml.org/lkml/2009/4/4/107

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
---
 drivers/mtd/mtdcore.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 89c1e5d..fdd6ae8 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -585,6 +585,8 @@ done:
         return ((count < begin+len-off) ? count : begin+len-off);
 }

+#endif /* CONFIG_PROC_FS */
+
 /*====================================================================*/
 /* Init code */

@@ -596,24 +598,25 @@ static int __init init_mtd(void)
 		pr_err("Error creating mtd class.\n");
 		return PTR_ERR(mtd_class);
 	}
+#ifdef CONFIG_PROC_FS
 	if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
 		proc_mtd->read_proc = mtd_read_proc;
+#endif /* CONFIG_PROC_FS */
 	return 0;
 }

 static void __exit cleanup_mtd(void)
 {
+#ifdef CONFIG_PROC_FS
         if (proc_mtd)
 		remove_proc_entry( "mtd", NULL);
+#endif /* CONFIG_PROC_FS */
 	class_destroy(mtd_class);
 }

 module_init(init_mtd);
 module_exit(cleanup_mtd);

-#endif /* CONFIG_PROC_FS */
-
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("Core MTD registration and access routines");
-- 
1.5.6.3
