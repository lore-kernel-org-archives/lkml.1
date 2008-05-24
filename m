Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbYEXSk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbYEXSk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbYEXSkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:40:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:30334 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323AbYEXSkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=a1hNpt0jSEsf/QZ6LIMLzqtAQs4rTEzoiCkaL+aJLouceCuj0zFUSqlC/sQAha17osw9sckc0HTfVT1y1OERR/mnYadqv55hRPxwtNpt9WVCrXt2Jv39UPr8gW/uhJqV/WTI76qVgfINFIQ5szWRteTLx+5Myw56cdA+zxwKG0s=
Message-ID: <48386104.6020109@gmail.com>
Date: Sun, 25 May 2008 00:10:04 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: fix updating of ftrace_update_cnt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo/Steven,

Ftrace currently maintains an update count which includes false updates, i.e, updates which failed. If anything, such failures should be tracked by some separate variable, but this patch provides a minimal fix.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---
fix updating of ftrace_update_cnt

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index bfba25c..14e086f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -443,7 +443,7 @@ static void ftrace_shutdown_replenish(void)
 	ftrace_pages->next = (void *)get_zeroed_page(GFP_KERNEL);
 }
 
-static void
+static int
 ftrace_code_disable(struct dyn_ftrace *rec)
 {
 	unsigned long ip;
@@ -459,7 +459,9 @@ ftrace_code_disable(struct dyn_ftrace *rec)
 	if (failed) {
 		rec->flags |= FTRACE_FL_FAILED;
 		ftrace_free_rec(rec);
+		return 0;
 	}
+	return 1;
 }
 
 static int __ftrace_modify_code(void *data)
@@ -607,8 +609,8 @@ static int __ftrace_update_code(void *ignore)
 
 		/* all CPUS are stopped, we are safe to modify code */
 		hlist_for_each_entry(p, t, &head, node) {
-			ftrace_code_disable(p);
-			ftrace_update_cnt++;
+			if (ftrace_code_disable(p))
+				ftrace_update_cnt++;
 		}
 
 	}
