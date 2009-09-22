Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZIVTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZIVTjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZIVTj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:39:26 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39120 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZIVTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s0Py13IPlINa6q2A/GSx4QWf0xLCcixsmS3GqwidYYPTM0NAuOSxdBkZi19/EeA6wd
         4VubKZKxxct64nNCD2sYnQlah0fi30cg+M7iunUJ3b++DamTa2bCiyuIw9c97zkJDAkK
         kBoZbrFuCYZEwIkccoBGkq00oZ2TMQW2YkL2M=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 20/24] ftrace: Fix trace_remove_event_call() to lock trace_event_mutex
Date: Tue, 22 Sep 2009 21:38:18 +0200
Message-Id: <1253648302-5771-21-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Lock not only event_mutex but also trace_event_mutex in
trace_remove_event_call() to protect __unregister_ftrace_event().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_events.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 83cc2c0..f85b0f1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1054,6 +1054,9 @@ static void remove_subsystem_dir(const char *name)
 	}
 }
 
+/*
+ * Must be called under locking both of event_mutex and trace_event_mutex.
+ */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
 	ftrace_event_enable_disable(call, 0);
@@ -1070,7 +1073,9 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
 	mutex_lock(&event_mutex);
+	down_write(&trace_event_mutex);
 	__trace_remove_event_call(call);
+	up_write(&trace_event_mutex);
 	mutex_unlock(&event_mutex);
 }
 
-- 
1.6.2.3

