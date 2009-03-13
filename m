Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZCMJRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZCMJRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZCMJRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:17:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50860 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZCMJRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:17:45 -0400
Message-ID: <49BA2472.4060206@cn.fujitsu.com>
Date: Fri, 13 Mar 2009 17:16:34 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Steven Rostedt ;" <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: Don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED
 rec
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do __ftrace_replace_code for !FTRACE_FL_CONVERTED rec will always
fail, we should ignore this rec.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/ftrace.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 26c45aa..08f4a62 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -532,11 +532,12 @@ static void ftrace_replace_code(int enable)
 
 	do_for_each_ftrace_rec(pg, rec) {
 		/*
-		 * Skip over free records and records that have
-		 * failed.
+		 * Skip over free records, records that have
+		 * failed and not converted.
 		 */
 		if (rec->flags & FTRACE_FL_FREE ||
-		    rec->flags & FTRACE_FL_FAILED)
+		    rec->flags & FTRACE_FL_FAILED ||
+		    rec->flags & FTRACE_FL_CONVERTED)
 			continue;
 
 		/* ignore updates to this record's mcount site */
@@ -548,7 +549,7 @@ static void ftrace_replace_code(int enable)
 		}
 
 		failed = __ftrace_replace_code(rec, enable);
-		if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
+		if (failed) {
 			rec->flags |= FTRACE_FL_FAILED;
 			if ((system_state == SYSTEM_BOOTING) ||
 			    !core_kernel_text(rec->ip)) {
-- 
1.5.5.3


