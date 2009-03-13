Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbZCMJPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbZCMJPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZCMJPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:15:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZCMJPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:15:20 -0400
Message-ID: <49BA23D9.1050900@cn.fujitsu.com>
Date: Fri, 13 Mar 2009 17:14:01 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Steven Rostedt ;" <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: Avoid double-free of dyn_ftrace
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dyn_ftrace is free before ftrace_release(),
ftrace_release() will free it again and make ftrace_free_records wrong.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d33d306..26c45aa 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -356,7 +356,8 @@ void ftrace_release(void *start, unsigned long size)
 
 	mutex_lock(&ftrace_lock);
 	do_for_each_ftrace_rec(pg, rec) {
-		if ((rec->ip >= s) && (rec->ip < e))
+		if ((rec->ip >= s) && (rec->ip < e) &&
+		    !(rec->flags & FTRACE_FL_FREE))
 			ftrace_free_rec(rec);
 	} while_for_each_ftrace_rec();
 	mutex_unlock(&ftrace_lock);
-- 
1.5.5.3


