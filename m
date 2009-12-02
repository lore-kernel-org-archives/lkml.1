Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZLBGIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZLBGIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbZLBGH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:57 -0500
Received: from mail.perches.com ([173.55.12.10]:1228 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZLBGHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:49 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 05/13] drivers/block/floppy.c: remove [_]COPYIN [_]COPYOUT and ECALL macros
Date: Tue,  1 Dec 2009 22:07:45 -0800
Message-Id: <66b999624f7b27581256a33c6bbf76fa0d648fb6.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove these obfuscating macros with hidden returns

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 4a17eae..9582e4e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1040,7 +1040,6 @@ static DECLARE_WAIT_QUEUE_HEAD(command_done);
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
 
 #define CALL(x)		do { if ((x) == -EINTR) return -EINTR; } while (0)
-#define ECALL(x)	do { if ((ret = (x))) return ret; } while (0)
 #define _WAIT(x, i)	CALL(ret = wait_til_done((x), i))
 #define WAIT(x)		_WAIT((x), interruptible)
 #define IWAIT(x)	_WAIT((x), 1)
@@ -3589,14 +3588,6 @@ static inline int fd_copyin(void __user *param, void *address,
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
@@ -3673,7 +3664,9 @@ static inline int raw_cmd_copyout(int cmd, char __user *param,
 	int ret;
 
 	while (ptr) {
-		COPYOUT(*ptr);
+		ret = copy_to_user((void __user *)param, ptr, sizeof(*ptr));
+		if (ret)
+			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
 		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
 			if (ptr->length >= 0 &&
@@ -3722,7 +3715,9 @@ static inline int raw_cmd_copyin(int cmd, char __user *param,
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

