Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0BNA2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:28:54 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:42926 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230Ab0BNA2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:28:16 -0500
From: Matt Helsley <matthltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Helsley <matthltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [RFC][PATCH 2/4] anon_inode fcntl() checks: report failure for fcntl(F_SETFL) on timerfd
Date: Sat, 13 Feb 2010 16:27:45 -0800
Message-Id: <83f4033d9d33d5f775401f58acdfa39657fd3e39.1266107200.git.matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
 <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
In-Reply-To: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
References: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report failure when userspace attempts to set unsupported flags
on timerfd files with fcntl().

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 fs/timerfd.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/timerfd.c b/fs/timerfd.c
index 1bfc95a..198a564 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -156,7 +156,19 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
 	return res;
 }
 
+static int timerfd_check_flags(int flags)
+{
+	/* Check the TFD_* constants for consistency.  */
+	BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
+
+	if (flags & ~(TFD_CLOEXEC | TFD_NONBLOCK))
+		return -EINVAL;
+	return 0;
+}
+
 static const struct file_operations timerfd_fops = {
+	.check_flags    = timerfd_check_flags,
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
@@ -182,10 +194,6 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
 	int ufd;
 	struct timerfd_ctx *ctx;
 
-	/* Check the TFD_* constants for consistency.  */
-	BUILD_BUG_ON(TFD_CLOEXEC != O_CLOEXEC);
-	BUILD_BUG_ON(TFD_NONBLOCK != O_NONBLOCK);
-
 	if ((flags & ~TFD_CREATE_FLAGS) ||
 	    (clockid != CLOCK_MONOTONIC &&
 	     clockid != CLOCK_REALTIME))
-- 
1.6.3.3

