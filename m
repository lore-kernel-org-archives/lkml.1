Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbZCQIeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbZCQIeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbZCQIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:34:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:53181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZCQIeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:34:10 -0400
Date: Tue, 17 Mar 2009 08:33:27 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237270859.8033.141.camel@charm-linux>
References: <1237270859.8033.141.camel@charm-linux>
Subject: [tip:tracing/ftrace] tracing: fix leak in event_format_read()
Message-ID: <tip-c269fc8c537d761f36cb98e637ae934d9331a9d5@git.kernel.org>
Git-Commit-ID: c269fc8c537d761f36cb98e637ae934d9331a9d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 08:33:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c269fc8c537d761f36cb98e637ae934d9331a9d5
Gitweb:     http://git.kernel.org/tip/c269fc8c537d761f36cb98e637ae934d9331a9d5
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 17 Mar 2009 01:20:59 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Mar 2009 08:38:23 +0100

tracing: fix leak in event_format_read()

Impact: fix memory leak

If event_format_read() exits early due to nonzero ppos, the
previous kmalloc doesn't get freed - might as well do the
check before the kmalloc and avoid the problem.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237270859.8033.141.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 238ea95..c88227b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -378,15 +378,15 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	char *buf;
 	int r;
 
+	if (*ppos)
+		return 0;
+
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
 		return -ENOMEM;
 
 	trace_seq_init(s);
 
-	if (*ppos)
-		return 0;
-
 	/* If any of the first writes fail, so will the show_format. */
 
 	trace_seq_printf(s, "name: %s\n", call->name);
