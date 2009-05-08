Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbZEHS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbZEHS2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759753AbZEHS2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:28:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:53398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759438AbZEHS2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:28:21 -0400
Date: Fri, 8 May 2009 18:27:42 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A0399A5.2080603@cn.fujitsu.com>
References: <4A0399A5.2080603@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: simplify system_enable_read()
Message-ID: <tip-c142b15dc56ee6d55cb97a062e3c8e9c61e384c0@git.kernel.org>
Git-Commit-ID: c142b15dc56ee6d55cb97a062e3c8e9c61e384c0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 18:27:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c142b15dc56ee6d55cb97a062e3c8e9c61e384c0
Gitweb:     http://git.kernel.org/tip/c142b15dc56ee6d55cb97a062e3c8e9c61e384c0
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 8 May 2009 10:32:05 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 May 2009 14:00:36 +0200

tracing/events: simplify system_enable_read()

A smarter way to figure out the output of an enable file.

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A0399A5.2080603@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |   40 ++++++----------------------------------
 1 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 45f1099..df394bc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -414,10 +414,11 @@ static ssize_t
 system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
+	const char set_to_char[4] = { '?', '0', '1', 'X' };
 	const char *system = filp->private_data;
 	struct ftrace_event_call *call;
 	char buf[2];
-	int set = -1;
+	int set = 0;
 	int ret;
 
 	mutex_lock(&event_mutex);
@@ -433,47 +434,18 @@ system_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		 * or if all events or cleared, or if we have
 		 * a mixture.
 		 */
-		if (call->enabled) {
-			switch (set) {
-			case -1:
-				set = 1;
-				break;
-			case 0:
-				set = 2;
-				break;
-			}
-		} else {
-			switch (set) {
-			case -1:
-				set = 0;
-				break;
-			case 1:
-				set = 2;
-				break;
-			}
-		}
+		set |= (1 << !!call->enabled);
+
 		/*
 		 * If we have a mixture, no need to look further.
 		 */
-		if (set == 2)
+		if (set == 3)
 			break;
 	}
 	mutex_unlock(&event_mutex);
 
+	buf[0] = set_to_char[set];
 	buf[1] = '\n';
-	switch (set) {
-	case 0:
-		buf[0] = '0';
-		break;
-	case 1:
-		buf[0] = '1';
-		break;
-	case 2:
-		buf[0] = 'X';
-		break;
-	default:
-		buf[0] = '?';
-	}
 
 	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, 2);
 
