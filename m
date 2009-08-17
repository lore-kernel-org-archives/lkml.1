Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZHQJbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZHQJbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932294AbZHQJbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:31:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:56321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258AbZHQJbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:31:38 -0400
Date: Mon, 17 Aug 2009 09:30:56 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <4A891AF6.5050102@cn.fujitsu.com>
References: <4A891AF6.5050102@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/syscalls: Fix to print parameter types
Message-ID: <tip-ba8b3a40ba7e06d00c27508f090803af90e8dbbf@git.kernel.org>
Git-Commit-ID: ba8b3a40ba7e06d00c27508f090803af90e8dbbf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 17 Aug 2009 09:30:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba8b3a40ba7e06d00c27508f090803af90e8dbbf
Gitweb:     http://git.kernel.org/tip/ba8b3a40ba7e06d00c27508f090803af90e8dbbf
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 17 Aug 2009 16:55:18 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 17 Aug 2009 11:25:09 +0200

tracing/syscalls: Fix to print parameter types

When syscall tracing was implemented as a tracer,
"syscall_arg_type" trace option could be set to enable the
display of syscall parameter types.

Now this option is gone since it's no longer a tracer, but the
code is still there but dead.

So we remove dead code and re-enable the printing of paramete
types via the verbose option:

  # echo verbose > trace_options
  # echo syscalls > set_event
  # cat trace
	...
        bash-3331  [000]    95.348937: sys_fcntl64 -> 0x1
        bash-3331  [000]    95.348942: sys_close(unsigned int fd: a)
	...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
LKML-Reference: <4A891AF6.5050102@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_syscalls.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f837ccc..f130dac 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -13,21 +13,6 @@ static int sys_refcount_exit;
 static DECLARE_BITMAP(enabled_enter_syscalls, FTRACE_SYSCALL_MAX);
 static DECLARE_BITMAP(enabled_exit_syscalls, FTRACE_SYSCALL_MAX);
 
-/* Option to display the parameters types */
-enum {
-	TRACE_SYSCALLS_OPT_TYPES = 0x1,
-};
-
-static struct tracer_opt syscalls_opts[] = {
-	{ TRACER_OPT(syscall_arg_type, TRACE_SYSCALLS_OPT_TYPES) },
-	{ }
-};
-
-static struct tracer_flags syscalls_flags = {
-	.val = 0, /* By default: no parameters types */
-	.opts = syscalls_opts
-};
-
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
 {
@@ -55,7 +40,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
 
 	for (i = 0; i < entry->nb_args; i++) {
 		/* parameter types */
-		if (syscalls_flags.val & TRACE_SYSCALLS_OPT_TYPES) {
+		if (trace_flags & TRACE_ITER_VERBOSE) {
 			ret = trace_seq_printf(s, "%s ", entry->types[i]);
 			if (!ret)
 				return TRACE_TYPE_PARTIAL_LINE;
