Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZHQJBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZHQJBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZHQJBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:01:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbZHQJBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:01:04 -0400
Message-ID: <4A891AF6.5050102@cn.fujitsu.com>
Date: Mon, 17 Aug 2009 16:55:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/syscalls: Fix to print parameter types
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When syscall tracing was implemented as a tracer,  "syscall_arg_type"
trace option could be set to enable the display of syscall parameter
types.

Now this option is gone since it's no longer a tracer, but the code
is still there but dead.

So we remove dead code and re-enable the printing of paramete types
via the verbose option:

  # echo verbose > trace_options
  # echo syscalls > set_event
  # cat trace
	...
        bash-3331  [000]    95.348937: sys_fcntl64 -> 0x1
        bash-3331  [000]    95.348942: sys_close(unsigned int fd: a)
	...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3

