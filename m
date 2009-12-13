Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZLMNKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZLMNKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 08:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZLMNIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 08:08:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51043 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753093AbZLMNId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 08:08:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rPB9VHUfry1aCXuCwh7RssPp/Lk1nypQgSlr1ZtiioqP+ALF4MHZ5uhhB4GHGyCddm
         cXvnd3upSp7y5QweO6OcQp4ozpw9SPSt3/e2NkaO7ImKsRT8su98hkdaVID00VzE3l78
         S447SYEA40VICpKPDU1KtsQ0hFvUtyypc70G8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/13] tracing: Use seq file for trace_clock
Date: Sun, 13 Dec 2009 14:08:09 +0100
Message-Id: <1260709694-5166-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
References: <1260709694-5166-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

The buffer for the output is as small as 64 bytes, so it'll
overflow if we add more clock type. Use seq file instead.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC4FB.5030407@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a6c41cc..886268e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3366,21 +3366,18 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
-static ssize_t tracing_clock_read(struct file *filp, char __user *ubuf,
-				  size_t cnt, loff_t *ppos)
+static int tracing_clock_show(struct seq_file *m, void *v)
 {
-	char buf[64];
-	int bufiter = 0;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++)
-		bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter,
+		seq_printf(m,
 			"%s%s%s%s", i ? " " : "",
 			i == trace_clock_id ? "[" : "", trace_clocks[i].name,
 			i == trace_clock_id ? "]" : "");
-	bufiter += snprintf(buf + bufiter, sizeof(buf) - bufiter, "\n");
+	seq_putc(m, '\n');
 
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, bufiter);
+	return 0;
 }
 
 static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
@@ -3422,6 +3419,13 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int tracing_clock_open(struct inode *inode, struct file *file)
+{
+	if (tracing_disabled)
+		return -ENODEV;
+	return single_open(file, tracing_clock_show, NULL);
+}
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -3460,8 +3464,10 @@ static const struct file_operations tracing_mark_fops = {
 };
 
 static const struct file_operations trace_clock_fops = {
-	.open		= tracing_open_generic,
-	.read		= tracing_clock_read,
+	.open		= tracing_clock_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 	.write		= tracing_clock_write,
 };
 
-- 
1.6.2.3

