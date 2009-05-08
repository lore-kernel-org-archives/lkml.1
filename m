Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZEHCbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZEHCbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 22:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbZEHCbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:31:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757248AbZEHCbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:31:18 -0400
Message-ID: <4A0399A5.2080603@cn.fujitsu.com>
Date: Fri, 08 May 2009 10:32:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/events: simplify system_enable_read()
References: <4A03998E.3020503@cn.fujitsu.com>
In-Reply-To: <4A03998E.3020503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A smarter way to figure out the output of an enable file.

[ Impact: clean up ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
 
-- 
1.5.4.rc3

