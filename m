Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbZGPQv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbZGPQv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932577AbZGPQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:51:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34205 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567AbZGPQv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:51:57 -0400
Date: Thu, 16 Jul 2009 18:51:35 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: dont reset set_ftrace_filter/notrace when opened
	with r/w perm
Message-ID: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
with read&write permissions, the previous setup will be removed.

Tested with following program:

[snip]
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
	FILE *f;
	char *mode = "w+";
	char *file = argv[1];

	if (argc == 3)
		mode = argv[2];

	if (NULL == (f = fopen(file, mode))) {
		perror("fopen failed");
		return -1;
	}

	while(!feof(f)) {
#define BUFLEN 100
		char buf[BUFLEN];
		memset(buf, 0, BUFLEN);
		fgets(buf, BUFLEN, f);
		printf(buf);
	}

	fclose(f);
	return 0;
}
[snip]

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>

---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4521c77..11394bc 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1661,10 +1661,6 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 		return -ENOMEM;
 
 	mutex_lock(&ftrace_regex_lock);
-	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND))
-		ftrace_filter_reset(enable);
-
 	if (file->f_mode & FMODE_READ) {
 		iter->pg = ftrace_pages_start;
 		iter->flags = enable ? FTRACE_ITER_FILTER :
@@ -2260,6 +2256,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		return 0;
 
 	mutex_lock(&ftrace_regex_lock);
+	if ((file->f_mode & FMODE_WRITE) &&
+	    !(file->f_flags & O_APPEND))
+		ftrace_filter_reset(enable);
 
 	if (file->f_mode & FMODE_READ) {
 		struct seq_file *m = file->private_data;
