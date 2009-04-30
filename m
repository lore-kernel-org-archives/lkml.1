Return-Path: <linux-kernel-owner+w=401wt.eu-S1762428AbZD3Adc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762428AbZD3Adc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761508AbZD3A16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:58 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:4720 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761448AbZD3A15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i/+c9lSR16OwQiFTROnBkUtI0gCSRa/ohMT1mXrUMc4ZZyltn2+vi4gsBUva4UhL+e
         DmQezhcu3Uv9BdS2gP+aBGr/tQoOo0zxICeeG+6JSdRG/6KCvTRPWe85JDWn+tHgXCu7
         6UCPK+zf2UnvBUNSKqvDJtzd7D9QzN6nqsR28=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 16/19] tracing/workqueue: add open/release file handlers
Date: Thu, 30 Apr 2009 02:27:17 +0200
Message-Id: <1241051240-4280-17-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A stat tracer might want to free one of its entries in an atomic
context, this is the case for the workqueue tracer.

The problem is that the stat tracing framework can store a pointer
to a freed entry and pass it to the stat_next() and stat_show()
handlers.

Since this is the only tracer which suffers such issue for now, it's
better to implement the protection on the workqueue tracer layer
using a reader refcount.

These open/release callbacks are then added to help implementing
such facility.

[ Impact: prepare workqueue tracer to protect its entries freeing ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/trace/trace_stat.c |    8 ++++++++
 kernel/trace/trace_stat.h |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index fdde3a4..04f3285 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -210,8 +210,13 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 	ret = seq_open(file, &trace_stat_seq_ops);
 	if (!ret) {
 		struct seq_file *m = file->private_data;
+
 		m->private = session;
+		if (session->ts->file_open)
+			session->ts->file_open();
 		ret = stat_seq_init(session);
+		if (ret && session->ts->file_release)
+			session->ts->file_release();
 	}
 
 	return ret;
@@ -228,6 +233,9 @@ static int tracing_stat_release(struct inode *i, struct file *f)
 	reset_stat_session(session);
 	mutex_unlock(&session->stat_mutex);
 
+	if (session->ts->file_release)
+		session->ts->file_release();
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
index f3546a2..915bf2e 100644
--- a/kernel/trace/trace_stat.h
+++ b/kernel/trace/trace_stat.h
@@ -20,6 +20,9 @@ struct tracer_stat {
 	int			(*stat_show)(struct seq_file *s, void *p);
 	/* Print the headers of your stat entries */
 	int			(*stat_headers)(struct seq_file *s);
+	/* Hooks on file operations */
+	void			(*file_open)(void);
+	void			(*file_release)(void);
 };
 
 /*
-- 
1.6.2.3

