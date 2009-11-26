Return-Path: <linux-kernel-owner+w=401wt.eu-S1758642AbZKZHDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbZKZHDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZKZHDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:03:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59277 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZKZHDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:03:45 -0500
Message-ID: <4B0E283B.3010508@cn.fujitsu.com>
Date: Thu, 26 Nov 2009 15:03:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] tracing: Convert module refcnt events to DEFINE_EVENT
References: <4B0E2807.4060102@cn.fujitsu.com>
In-Reply-To: <4B0E2807.4060102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TRACE_EVENT_TEMPLATE to remove duplicate code:

   text    data     bss     dec     hex filename
  29854    1980     128   31962    7cda kernel/module.o.old
  28750    1980     128   30858    788a kernel/module.o

Two events are converted:

  module_refcnt: module_get, module_put

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/module.h |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 84160fb..32c28db 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -51,7 +51,7 @@ TRACE_EVENT(module_free,
 	TP_printk("%s", __get_str(name))
 );
 
-TRACE_EVENT(module_get,
+TRACE_EVENT_TEMPLATE(module_refcnt,
 
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
-- 
1.6.3


