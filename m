Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYELLto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYELLto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYELLtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:49:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:57545 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYELLte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=H7AXvxXqYi0fLpkJEaCVeGgfo2pmFmTJFpMtCaWGw/LPTQmglUqU//DmjmE9Qn0WyYRXBqBWycin0e/r37hCzZTBc+bagnWbQvAMgI55YqdzXX2aMajsZyXwT6Y+pZHwrZgi+2us1xs3lSL0tLBNxvCBQM35lj6lIPkUoadPsSM=
Date: Mon, 12 May 2008 13:49:25 +0200
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>
Subject: [RFC/PATCH] printk: detect incomplete lines
Message-ID: <20080512114925.GA29407@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This printk() problem has been bugging me for a long time. Consider the
following code:

diff --git a/init/main.c b/init/main.c
index ddada7a..777e02d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -452,17 +452,38 @@ static void __init setup_command_line(char *command_line)
  * gcc-3.4 accidentally inlines this function, so use noinline.
  */
 
+static void printk_thread(const char *msg, unsigned long wait)
+{
+	int i = 0;
+
+	while(true) {
+		if (i == 0)
+			printk(KERN_INFO "Here we go: ");
+
+		printk("%s%s", msg, i < 7 ? ", " : "\n");
+		if (++i == 8)
+			i = 0;
+		msleep(wait);
+	}
+}
+
+static void printk_thread_1(void) { printk_thread("thread 1", 30); }
+static void printk_thread_2(void) { printk_thread("thread 2", 20); }
+
 static void noinline __init_refok rest_init(void)
 	__releases(kernel_lock)
 {
 	int pid;
 
-	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
+	//kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	unlock_kernel();
 
+	kernel_thread(printk_thread_1, NULL, CLONE_FS | CLONE_SIGHAND);
+	kernel_thread(printk_thread_2, NULL, CLONE_FS | CLONE_SIGHAND);
+
 	/*
 	 * The boot idle thread must execute schedule()
 	 * at least once to get things moving:

This will normally create an output that looks something like this:

Here we go: thread 2, <6>Here we go: thread 1, thread 2, thread 1, thread 2, thread 1, thread 2, thread 2, thread 1, thread 2, thread 1, thread 2, thread 2
thread 1, <6>Here we go: thread 2, thread 1, thread 2, thread 2, thread 1
thread 2, <6>Here we go: thread 1, thread 2, thread 2, thread 1, thread 2, thread 1, thread 2

(Notice the log-level tokens appearing in the middle of some lines.)

With my patch to printk(), the same code now produces this output:

Here we go: thread 1, ...
Here we go: thread 2, thread 2, ...
thread 1, ...
thread 2, ...
thread 1, ...
thread 2, thread 2, ...
thread 1, ...

I first thought of using "current" as the way to distinguish two callers,
but there are two issues with this: 1) I don't think "current" is legal to
access in all contexts, but maybe I am wrong. 2) Executing some kernel
code, say a system call, and an IRQ happening while we are executing inside
that system call will not make "current" change.

Then I thought of using __builtin_return_address(), but in a function, two
different printks will have a different return address.

So we are now using __builtin_frame_address(). This should work everywhere
and should not cause any harmful side effects.

(Yes, this means that "continuation calls across functions" won't work. But
that's broken by design, at least in my opinion.)

The GCC manual says "This function should only be used with a nonzero
argument for debugging purposes", but it is nothing to worry about, as we
are in fact calling it with a zero argument.

The only thing I worry about is whether it will work on all architectures.
Does anybody see anything that can go wrong with this patch?

(The remaining issue is to figure out what the loglevel of the next message
should be, the one that is being continued. It may lead to "leaking" of
certain loglevel messages, but that's a much more fundamental problem and
this patch is at least a step in the right direction.)

Vegard


>From 909874dbedd06271af5185f3eb5f710bb1267433 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 12 May 2008 13:17:19 +0200
Subject: [PATCH] printk: detect incomplete lines

This patch makes printk() remember the previous caller, and if changed,
output a newline to make the next message start in the right place.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/printk.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8fb01c3..6080e66 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -672,6 +672,7 @@ static int printk_recursion_bug;
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
+	static void *prev_caller;
 	static int log_level_unknown = 1;
 	static char printk_buf[1024];
 
@@ -718,6 +719,16 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	printed_len += vscnprintf(printk_buf + printed_len,
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
+	if (prev_caller != __builtin_frame_address(0) && !log_level_unknown) {
+		emit_log_char('.');
+		emit_log_char('.');
+		emit_log_char('.');
+		emit_log_char('\n');
+		log_level_unknown = 1;
+	}
+
+	prev_caller = __builtin_frame_address(0);
+
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
 	 * appropriate log level tags, we insert them here
-- 
1.5.4.1

