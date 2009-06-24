Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZFXBvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZFXBvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZFXBvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:51:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61042 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZFXBvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:51:32 -0400
Message-ID: <4A4186DD.6090405@cn.fujitsu.com>
Date: Wed, 24 Jun 2009 09:52:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Liming Wang <liming.wang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] tracing/events: don't increment @pos in s_start()
References: <4A4186C6.9090706@cn.fujitsu.com>
In-Reply-To: <4A4186C6.9090706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

[ Impact fix missing entries when reading available_events/set_events ]

Reviewed-by: Liming Wang <liming.wang@windriver.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.5.4.rc3
