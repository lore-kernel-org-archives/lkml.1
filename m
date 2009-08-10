Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbZHJOil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbZHJOil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZHJOil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:38:41 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:53104 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZHJOik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BJ2q7/9cGX2lIPE9Wd8e5MWxrezXCNTrC6Sv86bPlKPGdAs4y+xZXhhNimIEXkwrTQ
         eaQdlLbOHmYzKfnD8ocCVLPyAbpd106QFhvlgbiH5lpIRJArObdsiWd9TFgau+4EeCTK
         tBdpC+Wp7hZPCXhDsvwFwqlisa3YZM7HN1unY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 7/3] perfcounter: Zeroe dead bytes from ftrace raw samples size alignment
Date: Mon, 10 Aug 2009 16:38:36 +0200
Message-Id: <1249915116-5210-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249888437.17467.42.camel@twins>
References: <1249888437.17467.42.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After aligning the ftrace raw samples, there are dead bytes storing
random data from the stack. We don't want to leak these to userspace,
then zeroe these out.

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
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 include/trace/ftrace.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index f98ff56..f2646e0 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -650,6 +650,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *		char raw_data[__entry_size]; <- allocate our sample in the stack
  *		struct trace_entry *ent;
  *
+ *		// zeroe dead bytes from alignment to avoid stack leak to userspace
+ *		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
  *		entry = (struct ftrace_raw_<call> *)raw_data;
  *		ent = &entry->ent;
  *		tracing_generic_entry_update(ent, irq_flags, pc);
@@ -700,6 +702,7 @@ static void ftrace_profile_##call(proto)				\
 		char raw_data[__entry_size];				\
 		struct trace_entry *ent;				\
 									\
+		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;	\
 		entry = (struct ftrace_raw_##call *)raw_data;		\
 		ent = &entry->ent;					\
 		tracing_generic_entry_update(ent, irq_flags, pc);	\
-- 
1.6.2.3

