Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab0BNA2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:28:18 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58203 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab0BNA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:28:12 -0500
From: Matt Helsley <matthltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [RFC][PATCH 1/4] anon_inode fcntl() checks: report failure for fcntl(F_SETFL) on signalfd
Date: Sat, 13 Feb 2010 16:27:44 -0800
Message-Id: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anon_inode interfaces often do not support flags that can be set
by fcntl(). Right now using fcntl() to set these flags falsely
reports success for things like O_ASYNC (yet SIGIO is not delivered).

Report failure when userspace attempts to set unsupported flags
on signalfd files with fcntl().

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 fs/signalfd.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 1dabe4e..3016f3b 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -199,7 +199,19 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	return total ? total: ret;
 }
 
+static int signalfd_check_flags(int flags)
+{
+	/* Check the SFD_* constants for consistency.  */
+	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
+
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK))
+		return -EINVAL;
+	return 0;
+}
+
 static const struct file_operations signalfd_fops = {
+	.check_flags    = signalfd_check_flags,
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,
 	.read		= signalfd_read,
@@ -211,13 +223,8 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	sigset_t sigmask;
 	struct signalfd_ctx *ctx;
 
-	/* Check the SFD_* constants for consistency.  */
-	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
-	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
-
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK))
+	if (signalfd_check_flags(flags))
 		return -EINVAL;
-
 	if (sizemask != sizeof(sigset_t) ||
 	    copy_from_user(&sigmask, user_mask, sizeof(sigmask)))
 		return -EINVAL;
-- 
1.6.3.3

