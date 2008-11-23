Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYKWQd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYKWQd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYKWQdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:33:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:3748 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYKWQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:33:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=fSioA06uBvNoAkniHUts8L1+uEqOble9tGYSs7I06AoY2lbvrUwSm91HnzwWzXUPWO
         dnkTKlk7dKdKSz9b6xqOdOVI+qTBniLTOhZhKmA+khuQUW6jRyn+/0ECjteV6OTDGt6o
         UQMjF8XQRVceOF//u4cZfLG507+6YjhcQQmdA=
Message-ID: <492985C8.7070205@gmail.com>
Date: Sun, 23 Nov 2008 17:33:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-return-tracer: don't trace kfree while it
 frees the return stack
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 90d99fb..ffff7ec 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1628,8 +1628,9 @@ void ftrace_retfunc_init_task(struct task_struct *t)
 
 void ftrace_retfunc_exit_task(struct task_struct *t)
 {
-	kfree(t->ret_stack);
+	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
 	t->ret_stack = NULL;
+	kfree(ret_stack);
 }
 #endif
 
-- 
1.5.2.5
