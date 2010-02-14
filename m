Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0BNA2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 19:28:22 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:42924 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166Ab0BNA2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 19:28:15 -0500
From: Matt Helsley <matthltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: [RFC][PATCH 3/4] anon_inode fcntl() checks: report failure for fcntl(F_SETFL) on epoll
Date: Sat, 13 Feb 2010 16:27:46 -0800
Message-Id: <1518b6425f7dbee3a666d45cb3be0e3d2487fbec.1266107200.git.matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <83f4033d9d33d5f775401f58acdfa39657fd3e39.1266107200.git.matthltc@us.ibm.com>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
 <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
 <83f4033d9d33d5f775401f58acdfa39657fd3e39.1266107200.git.matthltc@us.ibm.com>
In-Reply-To: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
References: <69d9c93fe958497f69102bea7c32cd048160b978.1266107200.git.matthltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report failure when userspace attempts to set unsupported flags
on epoll files with fcntl().

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 fs/eventpoll.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index bd056a5..ea46b92 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -671,8 +671,19 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 	return pollflags != -1 ? pollflags : 0;
 }
 
+static int ep_eventpoll_check_flags(int flags)
+{
+	/* Check the EPOLL_* constant for consistency.  */
+	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
+
+	if (flags & ~EPOLL_CLOEXEC)
+		return -EINVAL;
+	return 0;
+}
+
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
+	.check_flags    = ep_eventpoll_check_flags,
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll
 };
@@ -1190,11 +1201,9 @@ SYSCALL_DEFINE1(epoll_create1, int, flags)
 	int error;
 	struct eventpoll *ep = NULL;
 
-	/* Check the EPOLL_* constant for consistency.  */
-	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
-
-	if (flags & ~EPOLL_CLOEXEC)
+	if (ep_eventpoll_check_flags(flags))
 		return -EINVAL;
+
 	/*
 	 * Create the internal data structure ("struct eventpoll").
 	 */
-- 
1.6.3.3

