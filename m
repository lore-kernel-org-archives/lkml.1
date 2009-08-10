Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZHJSCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZHJSCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZHJSCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:02:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:46188 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZHJSCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:02:06 -0400
Date: Mon, 10 Aug 2009 18:01:24 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249915116-5210-1-git-send-email-fweisbec@gmail.com>
References: <1249915116-5210-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/urgent] perf_counter: Zero dead bytes from ftrace raw samples size alignment
Message-ID: <tip-1853db0e02ae4088f102b0d8e59e83dc98f93f03@git.kernel.org>
Git-Commit-ID: 1853db0e02ae4088f102b0d8e59e83dc98f93f03
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 18:01:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1853db0e02ae4088f102b0d8e59e83dc98f93f03
Gitweb:     http://git.kernel.org/tip/1853db0e02ae4088f102b0d8e59e83dc98f93f03
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 10 Aug 2009 16:38:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 16:51:19 +0200

perf_counter: Zero dead bytes from ftrace raw samples size alignment

After aligning the ftrace raw samples, there are dead bytes storing
random data from the stack. We don't want to leak these to userspace,
then zero these out.

Before:

	0x2de88 [0x50]: event: 9
	.
	. ... raw event: size 80 bytes
	.  0000:  09 00 00 00 01 00 50 00 d0 c7 00 81 ff ff ff ff  ......P........
	.  0010:  68 01 00 00 68 01 00 00 2c 00 00 00 00 00 00 00  h...h...,......
	.  0020:  2c 00 00 00 2b 00 01 02 68 01 00 00 68 01 00 00  ,...+...h...h..
	.  0030:  6b 6f 6e 64 65 6d 61 6e 64 2f 30 00 00 00 00 00  kondemand/0....
	.  0040:  68 01 00 00 40 7f 46 81 ff ff ff ff 00 10 1b 7f  h...@.F........
                                                      ^  ^  ^  ^
                                                         Leak

After:

	0x2d318 [0x50]: event: 9
	.
	. ... raw event: size 80 bytes
	.  0000:  09 00 00 00 01 00 50 00 d0 c7 00 81 ff ff ff ff  ......P........
	.  0010:  68 01 00 00 68 01 00 00 68 14 00 00 00 00 00 00  h...h...h......
	.  0020:  2c 00 00 00 2b 00 01 02 68 01 00 00 68 01 00 00  ,...+...h...h..
	.  0030:  6b 6f 6e 64 65 6d 61 6e 64 2f 30 00 00 00 00 00  kondemand/0....
	.  0040:  68 01 00 00 a0 80 46 81 ff ff ff ff 00 00 00 00  h.....F........
                                                      ^  ^  ^  ^
							 Fixed

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1249915116-5210-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>


---
 include/trace/ftrace.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a05524f..f64fbaa 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -648,6 +648,9 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *		char raw_data[__entry_size]; <- allocate our sample in the stack
  *		struct trace_entry *ent;
  *
+ *		zero dead bytes from alignment to avoid stack leak to userspace:
+ *
+ *		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
  *		entry = (struct ftrace_raw_<call> *)raw_data;
  *		ent = &entry->ent;
  *		tracing_generic_entry_update(ent, irq_flags, pc);
@@ -698,6 +701,7 @@ static void ftrace_profile_##call(proto)				\
 		char raw_data[__entry_size];				\
 		struct trace_entry *ent;				\
 									\
+		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;	\
 		entry = (struct ftrace_raw_##call *)raw_data;		\
 		ent = &entry->ent;					\
 		tracing_generic_entry_update(ent, irq_flags, pc);	\
