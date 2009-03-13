Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZCMJeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZCMJeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 05:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758480AbZCMJe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 05:34:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:47663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758449AbZCMJe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 05:34:28 -0400
Date: Fri, 13 Mar 2009 09:33:38 GMT
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49BA2472.4060206@cn.fujitsu.com>
References: <49BA2472.4060206@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] ftrace: don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED rec
Message-ID: <tip-fa9d13cf135efbd454453a53b6299976bea245a9@git.kernel.org>
Git-Commit-ID: fa9d13cf135efbd454453a53b6299976bea245a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 09:33:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa9d13cf135efbd454453a53b6299976bea245a9
Gitweb:     http://git.kernel.org/tip/fa9d13cf135efbd454453a53b6299976bea245a9
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Fri, 13 Mar 2009 17:16:34 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 10:25:06 +0100

ftrace: don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED rec

Do __ftrace_replace_code for !FTRACE_FL_CONVERTED rec will always
fail, we should ignore this rec.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: "Steven Rostedt ;" <rostedt@goodmis.org>
LKML-Reference: <49BA2472.4060206@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
