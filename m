Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZEZP3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZEZP3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZEZP3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:29:47 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:35796 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbZEZP3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:29:46 -0400
Date: Tue, 26 May 2009 17:28:02 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace: disable preemption before taking raw spinlocks
Message-ID: <20090526172802.6377e33f@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

s390 code uses smp_processor_id() in __raw_spin_lock() code which
reveals that a (raw) spinlock is taken without preemption disabled.
This can potentially deadlock.

To fix this explicitly disable and enable preemption.

BUG: using smp_processor_id() in preemptible [00000000] code: cat/2278
caller is trace_find_cmdline+0x40/0xfc
CPU: 0 Not tainted 2.6.30-rc7-dirty #39
Process cat (pid: 2278, task: 000000003faedb68, ksp: 000000003b33b988)
000000003b33b988 000000003b33bae0 0000000000000002 0000000000000000 
       000000003b33bb80 000000003b33baf8 000000003b33baf8 00000000000175d6 
       0000000000000001 000000003b33b988 000000003f9b0000 000000000000000b 
       000000000000000c 000000003b33bb40 000000003b33bae0 0000000000000000 
       0000000000000000 00000000000175d6 000000003b33bae0 000000003b33bb28 
Call Trace:
([<00000000000174b2>] show_trace+0x112/0x170)
 [<0000000000017582>] show_stack+0x72/0x100
 [<0000000000441538>] dump_stack+0xc8/0xd8
 [<000000000025c350>] debug_smp_processor_id+0x114/0x130
 [<00000000000bf0e4>] trace_find_cmdline+0x40/0xfc
 [<00000000000c35d4>] trace_print_context+0x58/0xac
 [<00000000000bb676>] print_trace_line+0x416/0x470
 [<00000000000bc8fe>] s_show+0x4e/0x428
 [<000000000013834e>] seq_read+0x36a/0x5d4
 [<0000000000112a78>] vfs_read+0xc8/0x174
 [<0000000000112c58>] SyS_read+0x74/0xc4
 [<000000000002c7ae>] sysc_noemu+0x10/0x16
 [<000002000012436c>] 0x2000012436c
1 lock held by cat/2278:
 #0:  (&p->lock){+.+.+.}, at: [<0000000000138056>] seq_read+0x72/0x5d4

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c
+++ linux-2.6/kernel/trace/trace.c
@@ -800,6 +800,7 @@ void trace_find_cmdline(int pid, char co
 		return;
 	}
 
+	preempt_disable();
 	__raw_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
@@ -808,6 +809,7 @@ void trace_find_cmdline(int pid, char co
 		strcpy(comm, "<...>");
 
 	__raw_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 }
 
 void tracing_record_cmdline(struct task_struct *tsk)
