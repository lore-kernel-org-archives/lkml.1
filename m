Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZE0Xfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZE0Xfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760555AbZE0Xfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:35:33 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:42253 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbZE0Xfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ad7n1gGXqScfiHo+VkVFKHspEG94M1D99kWwMPakuMCb5o4WvfcYyvri9kzQQ9GKlq
         lxcweiJEVPnqTmfQbFSPSqzSiJKSNHRD97tC0LJybLwAh/WtxyH6yL5ZaiGN3L7TP/ez
         WNPjVtjQKSVE7vuHjprkUkBxj8Y5H3B6jAqXQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] trace: disable preemption before taking raw spinlocks
Date: Thu, 28 May 2009 01:35:26 +0200
Message-Id: <1243467327-13194-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243467327-13194-1-git-send-email-fweisbec@gmail.com>
References: <1243467327-13194-1-git-send-email-fweisbec@gmail.com>
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

[ Impact: fix preempt-unsafe raw spinlock ]

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 02d32ba..a3a8a87 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -808,6 +808,7 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
+	preempt_disable();
 	__raw_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
@@ -816,6 +817,7 @@ void trace_find_cmdline(int pid, char comm[])
 		strcpy(comm, "<...>");
 
 	__raw_spin_unlock(&trace_cmdline_lock);
+	preempt_enable();
 }
 
 void tracing_record_cmdline(struct task_struct *tsk)
-- 
1.6.2.3

