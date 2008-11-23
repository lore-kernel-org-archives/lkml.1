Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYKWQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYKWQkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYKWQk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:40:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51428 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYKWQk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:40:27 -0500
Date: Sun, 23 Nov 2008 17:40:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: don't trace kfree
	while it frees the return stack
Message-ID: <20081123164013.GC6206@elte.hu>
References: <492985C8.7070205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492985C8.7070205@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: fix a crash
> 
> While I killed the cat process, I got sometimes the following (but 
> rare) crash:
> 
> [   65.689027] Pid: 2969, comm: cat Not tainted (2.6.28-rc6-tip #83) AMILO Li 2727
> [   65.689027] EIP: 0060:[<00000000>] EFLAGS: 00010082 CPU: 1
> [   65.689027] EIP is at 0x0
> [   65.689027] EAX: 00000000 EBX: f66cd780 ECX: c019a64a EDX: f66cd780
> [   65.689027] ESI: 00000286 EDI: f66cd780 EBP: f630be2c ESP: f630be24
> [   65.689027]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   65.689027] Process cat (pid: 2969, ti=f630a000 task=f66cd780 task.ti=f630a000)
> [   65.689027] Stack:
> [   65.689027]  00000012 f630bd54 f630be7c c012c853 00000000 c0133cc9 f66cda54 f630be5c
> [   65.689027]  f630be68 f66cda54 f66cd88c f66cd878 f7070000 00000001 f630be90 c0135dbc
> [   65.689027]  f614a614 f630be68 f630be68 f65ba200 00000002 f630bf10 f630be90 c012cad6
> [   65.689027] Call Trace:
> [   65.689027]  [<c012c853>] ? do_exit+0x603/0x850
> [   65.689027]  [<c0133cc9>] ? next_signal+0x9/0x40
> [   65.689027]  [<c0135dbc>] ? dequeue_signal+0x8c/0x180
> [   65.689027]  [<c012cad6>] ? do_group_exit+0x36/0x90
> [   65.689027]  [<c013709c>] ? get_signal_to_deliver+0x20c/0x390
> [   65.689027]  [<c0102b69>] ? do_notify_resume+0x99/0x8b0
> [   65.689027]  [<c02e6d1a>] ? tty_ldisc_deref+0x5a/0x80
> [   65.689027]  [<c014db9b>] ? trace_hardirqs_on+0xb/0x10
> [   65.689027]  [<c02e6d1a>] ? tty_ldisc_deref+0x5a/0x80
> [   65.689027]  [<c02e39b0>] ? n_tty_write+0x0/0x340
> [   65.689027]  [<c02e1812>] ? redirected_tty_write+0x82/0x90
> [   65.689027]  [<c019ee99>] ? vfs_write+0x99/0xd0
> [   65.689027]  [<c02e1790>] ? redirected_tty_write+0x0/0x90
> [   65.689027]  [<c019f342>] ? sys_write+0x42/0x70
> [   65.689027]  [<c01035ca>] ? work_notifysig+0x13/0x19
> [   65.689027] Code:  Bad EIP value.
> [   65.689027] EIP: [<00000000>] 0x0 SS:ESP 0068:f630be24
> 
> This is because on do_exit(), kfree is called to free the return addresses stack
> but kfree is traced and stored its return address in this stack.
> This patch fixes it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 90d99fb..ffff7ec 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1628,8 +1628,9 @@ void ftrace_retfunc_init_task(struct task_struct *t)
>  
>  void ftrace_retfunc_exit_task(struct task_struct *t)
>  {
> -	kfree(t->ret_stack);
> +	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
>  	t->ret_stack = NULL;
> +	kfree(ret_stack);

heh, nice one :)

note that we also need to keep gcc from reordering things here (no 
matter how unlikely in this particular case).

(also, small detail: we prefer a newline after variable definitions.)

Full commit attached below.

	Ingo

-------------->
>From eae849ca034c7f1015f0a6f17421ebc737f0a069 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sun, 23 Nov 2008 17:33:12 +0100
Subject: [PATCH] tracing/function-return-tracer: don't trace kfree while it frees the return stack

Impact: fix a crash

While I killed the cat process, I got sometimes the following (but rare)
crash:

[   65.689027] Pid: 2969, comm: cat Not tainted (2.6.28-rc6-tip #83) AMILO Li 2727
[   65.689027] EIP: 0060:[<00000000>] EFLAGS: 00010082 CPU: 1
[   65.689027] EIP is at 0x0
[   65.689027] EAX: 00000000 EBX: f66cd780 ECX: c019a64a EDX: f66cd780
[   65.689027] ESI: 00000286 EDI: f66cd780 EBP: f630be2c ESP: f630be24
[   65.689027]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   65.689027] Process cat (pid: 2969, ti=f630a000 task=f66cd780 task.ti=f630a000)
[   65.689027] Stack:
[   65.689027]  00000012 f630bd54 f630be7c c012c853 00000000 c0133cc9 f66cda54 f630be5c
[   65.689027]  f630be68 f66cda54 f66cd88c f66cd878 f7070000 00000001 f630be90 c0135dbc
[   65.689027]  f614a614 f630be68 f630be68 f65ba200 00000002 f630bf10 f630be90 c012cad6
[   65.689027] Call Trace:
[   65.689027]  [<c012c853>] ? do_exit+0x603/0x850
[   65.689027]  [<c0133cc9>] ? next_signal+0x9/0x40
[   65.689027]  [<c0135dbc>] ? dequeue_signal+0x8c/0x180
[   65.689027]  [<c012cad6>] ? do_group_exit+0x36/0x90
[   65.689027]  [<c013709c>] ? get_signal_to_deliver+0x20c/0x390
[   65.689027]  [<c0102b69>] ? do_notify_resume+0x99/0x8b0
[   65.689027]  [<c02e6d1a>] ? tty_ldisc_deref+0x5a/0x80
[   65.689027]  [<c014db9b>] ? trace_hardirqs_on+0xb/0x10
[   65.689027]  [<c02e6d1a>] ? tty_ldisc_deref+0x5a/0x80
[   65.689027]  [<c02e39b0>] ? n_tty_write+0x0/0x340
[   65.689027]  [<c02e1812>] ? redirected_tty_write+0x82/0x90
[   65.689027]  [<c019ee99>] ? vfs_write+0x99/0xd0
[   65.689027]  [<c02e1790>] ? redirected_tty_write+0x0/0x90
[   65.689027]  [<c019f342>] ? sys_write+0x42/0x70
[   65.689027]  [<c01035ca>] ? work_notifysig+0x13/0x19
[   65.689027] Code:  Bad EIP value.
[   65.689027] EIP: [<00000000>] 0x0 SS:ESP 0068:f630be24

This is because on do_exit(), kfree is called to free the return addresses stack
but kfree is traced and stored its return address in this stack.
This patch fixes it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ftrace.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 90d99fb..53042f1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1628,8 +1628,13 @@ void ftrace_retfunc_init_task(struct task_struct *t)
 
 void ftrace_retfunc_exit_task(struct task_struct *t)
 {
-	kfree(t->ret_stack);
+	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
+
 	t->ret_stack = NULL;
+	/* NULL must become visible to IRQs before we free it: */
+	barrier();
+
+	kfree(ret_stack);
 }
 #endif
 
