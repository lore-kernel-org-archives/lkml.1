Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZINHwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZINHwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZINHwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:52:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52881 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZINHwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:52:53 -0400
Message-ID: <4AADF60B.5070407@cn.fujitsu.com>
Date: Mon, 14 Sep 2009 15:51:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing: Fix F_printk()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found some typos in F_printk(), so I wrote compile-time check
for it, and triggered some compile errors and warnings.

I've fixed them on x86_32, but I have no x86_64 in my hand, so there
may still be some compile warnings on 64bits.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_entries.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index c866d34..0c10095 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -78,7 +78,7 @@ FTRACE_ENTRY(funcgraph_entry, ftrace_graph_ent_entry,
 		__field_desc(	int,		graph_ent,	depth		)
 	),
 
-	F_printk("--> %lx (%d)", __entry->graph_ent.func, __entry->depth)
+	F_printk("--> %lx (%d)", __entry->func, __entry->depth)
 );
 
 /* Function return entry */
@@ -97,8 +97,8 @@ FTRACE_ENTRY(funcgraph_exit, ftrace_graph_ret_entry,
 
 	F_printk("<-- %lx (%d) (start: %llx  end: %llx) over: %d",
 		 __entry->func, __entry->depth,
-		 __entry->calltime, __entry->rettim,
-		 __entrty->depth)
+		 __entry->calltime, __entry->rettime,
+		 __entry->depth)
 );
 
 /*
@@ -133,7 +133,7 @@ FTRACE_ENTRY(context_switch, ctx_switch_entry,
 		FTRACE_CTX_FIELDS
 	),
 
-	F_printk(b"%u:%u:%u  ==> %u:%u:%u [%03u]",
+	F_printk("%u:%u:%u  ==> %u:%u:%u [%03u]",
 		 __entry->prev_pid, __entry->prev_prio, __entry->prev_state,
 		 __entry->next_pid, __entry->next_prio, __entry->next_state,
 		 __entry->next_cpu
@@ -257,8 +257,8 @@ FTRACE_ENTRY(mmiotrace_rw, trace_mmiotrace_rw,
 		__field_desc(	unsigned char,	rw,	width	)
 	),
 
-	F_printk("%lx %lx %lx %d %lx %lx",
-		 __entry->phs, __entry->value, __entry->pc,
+	F_printk("%lx %lx %lx %d %x %x",
+		 (unsigned long)__entry->phys, __entry->value, __entry->pc,
 		 __entry->map_id, __entry->opcode, __entry->width)
 );
 
@@ -275,8 +275,8 @@ FTRACE_ENTRY(mmiotrace_map, trace_mmiotrace_map,
 		__field_desc(	unsigned char,	map,	opcode	)
 	),
 
-	F_printk("%lx %lx %lx %d %lx",
-		 __entry->phs, __entry->virt, __entry->len,
+	F_printk("%lx %lx %lx %d %x",
+		 (unsigned long)__entry->phys, __entry->virt, __entry->len,
 		 __entry->map_id, __entry->opcode)
 );
 
@@ -370,7 +370,7 @@ FTRACE_ENTRY(kmem_alloc, kmemtrace_alloc_entry,
 		__field(	int,			node		)
 	),
 
-	F_printk("type:%u call_site:%lx ptr:%p req:%lu alloc:%lu"
+	F_printk("type:%u call_site:%lx ptr:%p req:%zi alloc:%zi"
 		 " flags:%x node:%d",
 		 __entry->type_id, __entry->call_site, __entry->ptr,
 		 __entry->bytes_req, __entry->bytes_alloc,
-- 
1.6.3

