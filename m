Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZLOHkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZLOHkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZLOHkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:40:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbZLOHkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:40:02 -0500
Message-ID: <4B273D2E.1010807@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 15:39:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/10] trace_syscalls: fix SYSCALL_DEFINE0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct syscall_metadata variable name in SYSCALL_DEFINE0
is not the same as SYSCALL_DEFINE1/2/3/4/5/6.

SYSCALL_TRACE_ENTER_EVENT() and SYSCALL_TRACE_EXIT_EVENT() expect
struct syscall_metadata's name is __syscall_meta__XXXXXX
as SYSCALL_DEFINE1/2/3/4/5/6 defines.

It causes event_enter_##sname->data points to a wrong place.
(event_enter_##sname->data points to a dummy struct syscall_metadata)

It causes syscalls which are defined by SYSCALL_DEFINE0() can not be traced.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 55e7108..bee1d41 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -196,7 +196,7 @@ struct perf_event_attr;
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
-	  __syscall_meta_##sname = {				\
+	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
 		.enter_event	= &event_enter__##sname,	\








