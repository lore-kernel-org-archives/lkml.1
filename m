Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745Ab0A0Ure@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0A0Ure (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331Ab0A0Uqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:42 -0500
Received: from mail.perches.com ([173.55.12.10]:1543 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0A0Uqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:35 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 09/13] drivers/block/floppy.c: Convert raw_cmd_copyin from while(1) to label: goto
Date: Wed, 27 Jan 2010 12:46:25 -0800
Message-Id: <6312f530cad23a739224a514fea122ffd73b3380.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces indent
Makes a bit more readable and intelligible
Return value now at bottom of function

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   73 +++++++++++++++++++++++++-----------------------
 1 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5bad295..e089b69 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3126,6 +3126,7 @@ static inline int raw_cmd_copyout(int cmd, void __user *param,
 		}
 		ptr = ptr->next;
 	}
+
 	return 0;
 }
 
@@ -3156,18 +3157,19 @@ static inline int raw_cmd_copyin(int cmd, void __user *param,
 	int i;
 
 	*rcmd = NULL;
-	while (1) {
-		ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
-		if (!ptr)
-			return -ENOMEM;
-		*rcmd = ptr;
-		ret = copy_from_user(ptr, param, sizeof(*ptr));
-		if (ret)
-			return -EFAULT;
-		ptr->next = NULL;
-		ptr->buffer_length = 0;
-		param += sizeof(struct floppy_raw_cmd);
-		if (ptr->cmd_count > 33)
+
+loop:
+	ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
+	if (!ptr)
+		return -ENOMEM;
+	*rcmd = ptr;
+	ret = copy_from_user(ptr, param, sizeof(*ptr));
+	if (ret)
+		return -EFAULT;
+	ptr->next = NULL;
+	ptr->buffer_length = 0;
+	param += sizeof(struct floppy_raw_cmd);
+	if (ptr->cmd_count > 33)
 			/* the command may now also take up the space
 			 * initially intended for the reply & the
 			 * reply count. Needed for long 82078 commands
@@ -3176,34 +3178,35 @@ static inline int raw_cmd_copyin(int cmd, void __user *param,
 			 * 16 bytes for a structure, you'll one day
 			 * discover that you really need 17...
 			 */
+		return -EINVAL;
+
+	for (i = 0; i < 16; i++)
+		ptr->reply[i] = 0;
+	ptr->resultcode = 0;
+	ptr->kernel_data = NULL;
+
+	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
+		if (ptr->length <= 0)
 			return -EINVAL;
+		ptr->kernel_data = (char *)fd_dma_mem_alloc(ptr->length);
+		fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
+		if (!ptr->kernel_data)
+			return -ENOMEM;
+		ptr->buffer_length = ptr->length;
+	}
+	if (ptr->flags & FD_RAW_WRITE) {
+		ret = fd_copyin(ptr->data, ptr->kernel_data, ptr->length);
+		if (ret)
+			return ret;
+	}
 
-		for (i = 0; i < 16; i++)
-			ptr->reply[i] = 0;
-		ptr->resultcode = 0;
-		ptr->kernel_data = NULL;
-
-		if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
-			if (ptr->length <= 0)
-				return -EINVAL;
-			ptr->kernel_data =
-			    (char *)fd_dma_mem_alloc(ptr->length);
-			fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
-			if (!ptr->kernel_data)
-				return -ENOMEM;
-			ptr->buffer_length = ptr->length;
-		}
-		if (ptr->flags & FD_RAW_WRITE) {
-			ret = fd_copyin(ptr->data, ptr->kernel_data,
-					ptr->length);
-			if (ret)
-				return ret;
-		}
+	if (ptr->flags & FD_RAW_MORE) {
 		rcmd = &(ptr->next);
-		if (!(ptr->flags & FD_RAW_MORE))
-			return 0;
 		ptr->rate &= 0x43;
+		goto loop;
 	}
+
+	return 0;
 }
 
 static int raw_cmd_ioctl(int cmd, void __user *param)
-- 
1.6.6.rc0.57.gad7a

