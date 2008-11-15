Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYKOAqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYKOAqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKOAqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:46:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36450 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYKOAqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:46:08 -0500
Message-Id: <20081115004604.607126569@goodmis.org>
References: <20081115004537.616030629@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 19:45:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: do not process freed records
Content-Disposition: inline; filename=0003-ftrace-do-not-process-freed-records.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: keep from converting freed records

When the tracer is started or stopped, it converts all code pointed
to by the saved records into callers to ftrace or nops. When modules
are unloaded, their records are freed, but they still exist within
the record pages.

This patch changes the code to skip over freed records.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4ef1331..2e712a4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -489,8 +489,12 @@ static void ftrace_replace_code(int enable)
 		for (i = 0; i < pg->index; i++) {
 			rec = &pg->records[i];
 
-			/* don't modify code that has already faulted */
-			if (rec->flags & FTRACE_FL_FAILED)
+			/*
+			 * Skip over free records and records that have
+			 * failed.
+			 */
+			if (rec->flags & FTRACE_FL_FREE ||
+			    rec->flags & FTRACE_FL_FAILED)
 				continue;
 
 			/* ignore updates to this record's mcount site */
-- 
1.5.6.5

-- 
