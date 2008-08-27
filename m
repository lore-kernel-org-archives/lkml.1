Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbYH0RtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbYH0RtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYH0Rs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:48:57 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:59363 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750811AbYH0Rs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:48:57 -0400
Date: Wed, 27 Aug 2008 13:48:45 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Al Viro <aviro@redhat.com>
Subject: [PATCH] message queues: increase range limits
Message-ID: <20080827174845.GA27509@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the range of various posix message queue limits.

Posix gives the message queue user the ability to 'trade
off' the maximum size of messages with the number of
possible messages that can be 'in flight'.  Linux currently
makes this trade off more restrictive than it needs to be.

In particular, the maximum message size today can be
made no smaller than 8192.  This greatly restricts those
applications that would like to have the ability to post
large numbers of very small messages.

So this task lowers the limit that the maximum message
size can be set to, from 8192 to 128.  It also lowers the
limit that the maximum #number of messages in flight can
be set to, from 10 to 1.

With these changes the message queue user can make better
trade offs between #messages and message size, in order to
get everything to fit within the setrlimit(RLIMIT_MSGQUEUE)
limit for that particular user.

This patch also applies the values in

	/proc/sys/fs/mqueue/msg_max
	/proc/sys/fs/mqueue/msgsize_max

as the defaults for the max #messages allowed and the max
message size allowed, respectively, for those applications
that do not supply these.  Previously, the defaults were
hardwired to 10 and 8192, respectively.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/ipc/mqueue.c
===================================================================
--- 2.6.27-rc4-git4.orig/ipc/mqueue.c	2008-08-26 17:44:35.000000000 -0400
+++ 2.6.27-rc4-git4/ipc/mqueue.c	2008-08-27 13:36:12.000000000 -0400
@@ -52,6 +52,14 @@
 #define HARD_MSGMAX 	(131072/sizeof(void*))
 #define DFLT_MSGSIZEMAX 8192	/* max message size */
 
+/*
+ * Define the ranges various user-specified maximum values can
+ * be set to.
+ */
+#define MIN_MSGMAX	1		/* min value for msg_max */
+#define MAX_MSGMAX	HARD_MSGMAX	/* max value for msg_max */
+#define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
+#define MAX_MSGSIZEMAX	8192*128	/* max value for msgsize_max */
 
 struct ext_wait_queue {		/* queue of sleeping tasks */
 	struct task_struct *task;
@@ -134,8 +142,8 @@
 			info->qsize = 0;
 			info->user = NULL;	/* set when all is ok */
 			memset(&info->attr, 0, sizeof(info->attr));
-			info->attr.mq_maxmsg = DFLT_MSGMAX;
-			info->attr.mq_msgsize = DFLT_MSGSIZEMAX;
+			info->attr.mq_maxmsg = msg_max;
+			info->attr.mq_msgsize = msgsize_max;
 			if (attr) {
 				info->attr.mq_maxmsg = attr->mq_maxmsg;
 				info->attr.mq_msgsize = attr->mq_msgsize;
@@ -1191,11 +1199,11 @@
 	.kill_sb = kill_litter_super,
 };
 
-static int msg_max_limit_min = DFLT_MSGMAX;
-static int msg_max_limit_max = HARD_MSGMAX;
+static int msg_max_limit_min = MIN_MSGMAX;
+static int msg_max_limit_max = MAX_MSGMAX;
 
-static int msg_maxsize_limit_min = DFLT_MSGSIZEMAX;
-static int msg_maxsize_limit_max = INT_MAX;
+static int msg_maxsize_limit_min = MIN_MSGSIZEMAX;
+static int msg_maxsize_limit_max = MAX_MSGSIZEMAX;
 
 static ctl_table mq_sysctls[] = {
 	{
