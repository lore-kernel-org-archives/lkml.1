Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbZLGHmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbZLGHmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbZLGHmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:42:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55833 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758712AbZLGHmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:42:51 -0500
Message-ID: <4B1CB1E7.2000704@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:42:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/13] tracing: Use seq file for trace_clock
References: <4B1CB14A.4080402@cn.fujitsu.com>
In-Reply-To: <4B1CB14A.4080402@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffer for the output is as small as 64 bytes, so it'll
overflow if we add more clock types. Use seq file instead.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e989fc9..75871e5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3327,21 +3327,18 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
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
@@ -3383,6 +3380,13 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
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
@@ -3421,8 +3425,10 @@ static const struct file_operations tracing_mark_fops = {
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
1.6.3

