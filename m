Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887Ab0A0I2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0A0I2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752Ab0A0I22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:28:28 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:38468 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0A0I2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qa/AzsZVOEl2FBrXxhrC4WXtS474LqOeJRPhcQzIu0N1vLjLORnDErx79MupKGLRyR
         51SSdDemkOzrgic+AVEC4cAnL7Xlhh3LsGcpLqH6UizwzKunaqi+PYQwULwWWGpd3T9s
         J/vhnqbYcCUucw8pcnrvTsZfA9bYO/iV5p7zY=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 09/12] perf tools: save syscall map
Date: Wed, 27 Jan 2010 02:28:00 -0600
Message-Id: <1264580883-15324-10-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read the exported syscall metadata and save it in the trace file for
post-processing tools.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-info.c  |   25 ++++++++++++++
 tools/perf/util/trace-event-parse.c |   63 +++++++++++++++++++++++++++++++++++
 tools/perf/util/trace-event-read.c  |   18 ++++++++++
 tools/perf/util/trace-event.h       |   10 +++++
 4 files changed, 116 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 5ea8973..6a6e5cc 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -461,6 +461,30 @@ out:
 	put_tracing_file(path);
 }
 
+static void read_syscall_map(void)
+{
+	unsigned int size, check_size;
+	char *path;
+	struct stat st;
+	int ret;
+
+	path = get_tracing_file("syscall_map");
+	ret = stat(path, &st);
+	if (ret < 0) {
+		/* not found */
+		size = 0;
+		write_or_die(&size, 4);
+		goto out;
+	}
+	size = get_size(path);
+	write_or_die(&size, 4);
+	check_size = copy_file(path);
+	if (size != check_size)
+		die("error in size of file '%s'", path);
+out:
+	put_tracing_file(path);
+}
+
 static struct tracepoint_path *
 get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
 {
@@ -523,6 +547,7 @@ int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 	read_event_files(tps);
 	read_proc_kallsyms();
 	read_ftrace_printk();
+	read_syscall_map();
 
 	return 0;
 }
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c1299ff..31bb6f2 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -336,6 +336,69 @@ void print_printk(void)
 	}
 }
 
+static struct syscall_metadata *syscalls;
+static int syscall_count;
+
+void parse_syscall_map(char *file, int size __unused)
+{
+	struct syscall_list {
+		struct syscall_list	*next;
+		char			*name;
+		int			nr;
+	} *list = NULL, *item;
+	char *line;
+	char *next = NULL;
+	int i;
+
+	line = strtok_r(file, "\n", &next);
+	while (line) {
+		item = malloc_or_die(sizeof(*item));
+		sscanf(line, "%d:%as", &item->nr,
+		       (float *)(void *)&item->name); /* workaround gcc warning */
+		item->next = list;
+		list = item;
+		line = strtok_r(NULL, "\n", &next);
+		syscall_count++;
+	}
+
+	syscalls = malloc_or_die(sizeof(*syscalls) * syscall_count);
+
+	i = 0;
+	while (list) {
+		syscalls[i].nr = list->nr;
+		syscalls[i].name = list->name;
+		i++;
+		item = list;
+		list = list->next;
+		free(item);
+	}
+}
+
+int nr_syscalls(void)
+{
+	return syscall_count;
+}
+
+const struct syscall_metadata *syscall_at_idx(int idx)
+{
+	if (idx >= syscall_count)
+		return NULL;
+
+	return &syscalls[idx];
+}
+
+const struct syscall_metadata *find_syscall(int syscall_nr)
+{
+	int i;
+
+	for (i = 0; i < syscall_count; i++) {
+		if (syscalls[i].nr == syscall_nr)
+			return &syscalls[i];
+	}
+
+	return NULL;
+}
+
 static struct event *alloc_event(void)
 {
 	struct event *event;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 1744422..70fcaec 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -171,6 +171,23 @@ static void read_ftrace_printk(void)
 	free(buf);
 }
 
+static void read_syscall_map(void)
+{
+	unsigned int size;
+	char *buf;
+
+	size = read4();
+	if (!size)
+		return;
+
+	buf = malloc_or_die(size);
+	read_or_die(buf, size);
+
+	parse_syscall_map(buf, size);
+
+	free(buf);
+}
+
 static void read_header_files(void)
 {
 	unsigned long long size;
@@ -498,6 +515,7 @@ void trace_report(int fd)
 	read_event_files();
 	read_proc_kallsyms();
 	read_ftrace_printk();
+	read_syscall_map();
 
 	if (show_funcs) {
 		print_funcs();
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index c3269b9..5313ad8 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -178,6 +178,16 @@ int parse_event_file(char *buf, unsigned long size, char *sys);
 void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 		  char *comm);
 
+struct syscall_metadata {
+	char *name;
+	int nr;
+};
+
+void parse_syscall_map(char *file, int size);
+int nr_syscalls(void);
+const struct syscall_metadata *syscall_at_idx(int idx);
+const struct syscall_metadata *find_syscall(int syscall_nr);
+
 extern int file_bigendian;
 extern int host_bigendian;
 
-- 
1.6.4.GIT

