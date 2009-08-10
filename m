Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZHJOWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZHJOWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZHJOWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:22:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:43660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbZHJOWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:22:16 -0400
Date: Mon, 10 Aug 2009 14:21:33 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090810141129.GA5124@nowhere>
References: <20090810141129.GA5124@nowhere>
Subject: [tip:perfcounters/urgent] perf_counter: Subtract the buffer size field from the event record size
Message-ID: <tip-304703aba31a87903b8c0db8f5e6890cac2d596d@git.kernel.org>
Git-Commit-ID: 304703aba31a87903b8c0db8f5e6890cac2d596d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 14:21:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  304703aba31a87903b8c0db8f5e6890cac2d596d
Gitweb:     http://git.kernel.org/tip/304703aba31a87903b8c0db8f5e6890cac2d596d
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 10 Aug 2009 16:11:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 16:18:50 +0200

perf_counter: Subtract the buffer size field from the event record size

We compute the perf raw sample size by aligning the raw ftrace
event size plus the buffer size field itself. We do that
instead of aligning only the perf raw sample size, so that we
might economize some in some cases.

But this buffer size field is not stored in the perf raw
sample, we must then substract its size from the buffer once we
computed the alignment unless we may get a useless u32 field in
the buffer.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090810141129.GA5124@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/trace/ftrace.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7167b9b..a05524f 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -637,7 +637,12 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *	pc = preempt_count();
  *
  *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
- *	__entry_size = __data_size + sizeof(*entry);
+ *
+ *	// Below we want to get the aligned size by taking into account
+ *	// the u32 field that will later store the buffer size
+ *	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),
+ *			     sizeof(u64));
+ *	__entry_size -= sizeof(u32);
  *
  *	do {
  *		char raw_data[__entry_size]; <- allocate our sample in the stack
@@ -687,6 +692,7 @@ static void ftrace_profile_##call(proto)				\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
 			     sizeof(u64));				\
+	__entry_size -= sizeof(u32);					\
 									\
 	do {								\
 		char raw_data[__entry_size];				\
