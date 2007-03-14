Return-Path: <linux-kernel-owner+w=401wt.eu-S965182AbXCNJEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965182AbXCNJEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965199AbXCNJEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:04:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57596 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965182AbXCNJEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:04:32 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 2/13] const file_operations fallout
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Message-Id: <E1HRPPL-0001qK-OE@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:04:31 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 sound/oss/dmasound/dmasound_core.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index a0ec886..f4056a9 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -1346,22 +1346,34 @@ static const struct file_operations sq_fops =
 	.ioctl		= sq_ioctl,
 	.open		= sq_open,
 	.release	= sq_release,
+};
+
 #ifdef HAS_RECORD
-	.read		= NULL	/* default to no read for compat mode */
-#endif
+static const struct file_operations sq_fops_record =
+{
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= sq_write,
+	.poll		= sq_poll,
+	.ioctl		= sq_ioctl,
+	.open		= sq_open,
+	.release	= sq_release,
+	.read		= sq_read,
 };
+#endif
 
 static int sq_init(void)
 {
+	const struct file_operations *fops = &sq_fops;
 #ifndef MODULE
 	int sq_unit;
 #endif
 
 #ifdef HAS_RECORD
 	if (dmasound.mach.record)
-		sq_fops.read = sq_read ;
+		fops = &sq_fops_record;
 #endif
-	sq_unit = register_sound_dsp(&sq_fops, -1);
+	sq_unit = register_sound_dsp(fops, -1);
 	if (sq_unit < 0) {
 		printk(KERN_ERR "dmasound_core: couldn't register fops\n") ;
 		return sq_unit ;
-- 
1.5.0-rc2.GIT


