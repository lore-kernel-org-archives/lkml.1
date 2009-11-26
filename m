Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbZKZIn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbZKZIn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbZKZIn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:43:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:58676 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbZKZInZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:43:25 -0500
Date: Thu, 26 Nov 2009 08:42:35 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0E283B.3010508@cn.fujitsu.com>
References: <4B0E283B.3010508@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert module refcnt events to DEFINE_EVENT
Message-ID: <tip-925684d6d589e40e41007edf47c69e729d911263@git.kernel.org>
Git-Commit-ID: 925684d6d589e40e41007edf47c69e729d911263
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  925684d6d589e40e41007edf47c69e729d911263
Gitweb:     http://git.kernel.org/tip/925684d6d589e40e41007edf47c69e729d911263
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 26 Nov 2009 15:03:23 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 09:14:02 +0100

tracing: Convert module refcnt events to DEFINE_EVENT

Use DECLARE_EVENT_CLASS to remove duplicate code:

   text    data     bss     dec     hex filename
  29854    1980     128   31962    7cda kernel/module.o.old
  28750    1980     128   30858    788a kernel/module.o

Two events are converted:

  module_refcnt: module_get, module_put

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0E283B.3010508@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/module.h |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 84160fb..4b0f48b 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -51,7 +51,7 @@ TRACE_EVENT(module_free,
 	TP_printk("%s", __get_str(name))
 );
 
-TRACE_EVENT(module_get,
+DECLARE_EVENT_CLASS(module_refcnt,
 
 	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
 
@@ -73,26 +73,18 @@ TRACE_EVENT(module_get,
 		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
 );
 
-TRACE_EVENT(module_put,
+DEFINE_EVENT(module_refcnt, module_get,
 
 	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
 
-	TP_ARGS(mod, ip, refcnt),
+	TP_ARGS(mod, ip, refcnt)
+);
 
-	TP_STRUCT__entry(
-		__field(	unsigned long,	ip		)
-		__field(	int,		refcnt		)
-		__string(	name,		mod->name	)
-	),
+DEFINE_EVENT(module_refcnt, module_put,
 
-	TP_fast_assign(
-		__entry->ip	= ip;
-		__entry->refcnt	= refcnt;
-		__assign_str(name, mod->name);
-	),
+	TP_PROTO(struct module *mod, unsigned long ip, int refcnt),
 
-	TP_printk("%s call_site=%pf refcnt=%d",
-		  __get_str(name), (void *)__entry->ip, __entry->refcnt)
+	TP_ARGS(mod, ip, refcnt)
 );
 
 TRACE_EVENT(module_request,
