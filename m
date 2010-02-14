Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab0BNA23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:28:29 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:42932 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab0BNA2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:28:18 -0500
From: Matt Helsley <matthltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [RFC][PATCH 4/4] anon_inode fcntl() checks: report failure for fcntl(F_SETFL) on eventfd
Date: Sat, 13 Feb 2010 16:27:47 -0800
Message-Id: <b3f27238de61d1b4f2b7ee31644b65bdca9fdbd0.1266107200.git.matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1518b6425f7dbee3a666d45cb3be0e3d2487fbec.1266107200.git.matthltc@us.ibm.com>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
 <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
 <83f4033d9d33d5f775401f58acdfa39657fd3e39.1266107200.git.matthltc@us.ibm.com>
 <1518b6425f7dbee3a666d45cb3be0e3d2487fbec.1266107200.git.matthltc@us.ibm.com>
In-Reply-To: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
References: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report failure when userspace attempts to set unsupported flags
on eventfd files with fcntl().

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 fs/eventfd.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 7758cc3..8976079 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -287,7 +287,19 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 	return res;
 }
 
+static int eventfd_check_flags(int flags)
+{
+	/* Check the EFD_* constants for consistency.  */
+	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
+	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
+
+	if (flags & ~EFD_SHARED_FCNTL_FLAGS)
+		return -EINVAL;
+	return 0;
+}
+
 static const struct file_operations eventfd_fops = {
+	.check_flags    = eventfd_check_flags,
 	.release	= eventfd_release,
 	.poll		= eventfd_poll,
 	.read		= eventfd_read,
@@ -381,9 +393,6 @@ struct file *eventfd_file_create(unsigned int count, int flags)
 	struct file *file;
 	struct eventfd_ctx *ctx;
 
-	/* Check the EFD_* constants for consistency.  */
-	BUILD_BUG_ON(EFD_CLOEXEC != O_CLOEXEC);
-	BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);
 
 	if (flags & ~EFD_FLAGS_SET)
 		return ERR_PTR(-EINVAL);
-- 
1.6.3.3

