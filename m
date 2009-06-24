Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZFXJqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZFXJqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZFXJqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:46:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbZFXJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:46:15 -0400
Date: Wed, 24 Jun 2009 09:45:35 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, liming.wang@windriver.com, mingo@elte.hu
In-Reply-To: <4A4186DD.6090405@cn.fujitsu.com>
References: <4A4186DD.6090405@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/events: Don't increment @pos in s_start()
Message-ID: <tip-e1c7e2a6e67fe9db19dd15e71614526a31b5fdb1@git.kernel.org>
Git-Commit-ID: e1c7e2a6e67fe9db19dd15e71614526a31b5fdb1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 09:45:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1c7e2a6e67fe9db19dd15e71614526a31b5fdb1
Gitweb:     http://git.kernel.org/tip/e1c7e2a6e67fe9db19dd15e71614526a31b5fdb1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 24 Jun 2009 09:52:29 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 24 Jun 2009 11:02:49 +0200

tracing/events: Don't increment @pos in s_start()

While testing syscall tracepoints posted by Jason, I found 3 entries
were missing when reading available_events. The output size of
available_events is < 4 pages, which means we lost 1 entry per page.

The cause is, it's wrong to increment @pos in s_start().

Actually there's another bug here -- reading avaiable_events/set_events
can race with module unload:

  # cat available_events               |
      s_start()                        |
      s_stop()                         |
                                       | # rmmod foo.ko
      s_start()                        |
        call = list_entry(m->private)  |

@call might be freed and accessing it will lead to crash.

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4A4186DD.6090405@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index aa08be6..53c8fd3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -300,10 +300,18 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
+	struct ftrace_event_call *call = NULL;
+	loff_t l;
+
 	mutex_lock(&event_mutex);
-	if (*pos == 0)
-		m->private = ftrace_events.next;
-	return t_next(m, NULL, pos);
+
+	m->private = ftrace_events.next;
+	for (l = 0; l <= *pos; ) {
+		call = t_next(m, NULL, &l);
+		if (!call)
+			break;
+	}
+	return call;
 }
 
 static void *
@@ -332,10 +340,18 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
 
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
+	struct ftrace_event_call *call = NULL;
+	loff_t l;
+
 	mutex_lock(&event_mutex);
-	if (*pos == 0)
-		m->private = ftrace_events.next;
-	return s_next(m, NULL, pos);
+
+	m->private = ftrace_events.next;
+	for (l = 0; l <= *pos; ) {
+		call = s_next(m, NULL, &l);
+		if (!call)
+			break;
+	}
+	return call;
 }
 
 static int t_show(struct seq_file *m, void *v)
