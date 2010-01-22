Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262Ab0AVE4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0AVE4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239Ab0AVEzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:55:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1363 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab0AVExA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 17/24] drivers/block/floppy.c: remove [_]COPYIN [_]COPYOUT and ECALL macros
Date: Thu, 21 Jan 2010 20:52:47 -0800
Message-Id: <3a9e4acc52f1a16abb1d5d9ba1713bd995690d4a.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove these obfuscating macros with hidden returns

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 822e4ee..a1eb5fe 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -520,7 +520,6 @@ static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
 #define CALL(x)		if ((x) == -EINTR) return -EINTR
-#define ECALL(x)	if ((ret = (x))) return ret;
 #define _WAIT(x,i)	CALL(ret=wait_til_done((x),i))
 #define WAIT(x)		_WAIT((x),interruptible)
 #define IWAIT(x)	_WAIT((x),1)
@@ -3061,14 +3060,6 @@ static inline int fd_copyin(void __user *param, void *address,
 	return copy_from_user(address, param, size) ? -EFAULT : 0;
 }
 
-#define _COPYOUT(x)	(copy_to_user((void __user *)param, &(x), sizeof(x)) \
-			 ? -EFAULT : 0)
-#define _COPYIN(x)	(copy_from_user(&(x), (void __user *)param, sizeof(x)) \
-			 ? -EFAULT : 0)
-
-#define COPYOUT(x)	ECALL(_COPYOUT(x))
-#define COPYIN(x)	ECALL(_COPYIN(x))
-
 static inline const char *drive_name(int type, int drive)
 {
 	struct floppy_struct *floppy;
@@ -3145,7 +3136,9 @@ static inline int raw_cmd_copyout(int cmd, char __user *param,
 	int ret;
 
 	while (ptr) {
-		COPYOUT(*ptr);
+		ret = copy_to_user((void __user *)param, ptr, sizeof(*ptr));
+		if (ret)
+			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
 		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
 			if (ptr->length >= 0 &&
@@ -3195,7 +3188,9 @@ static inline int raw_cmd_copyin(int cmd, char __user *param,
 		if (!ptr)
 			return -ENOMEM;
 		*rcmd = ptr;
-		COPYIN(*ptr);
+		ret = copy_from_user(ptr, (void __user *)param, sizeof(*ptr));
+		if (ret)
+			return -EFAULT;
 		ptr->next = NULL;
 		ptr->buffer_length = 0;
 		param += sizeof(struct floppy_raw_cmd);
-- 
1.6.6.rc0.57.gad7a

