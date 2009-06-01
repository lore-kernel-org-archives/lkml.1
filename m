Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZFAUu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZFAUu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZFAUuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:50:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58749 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbZFAUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:50:50 -0400
Date: Mon, 1 Jun 2009 17:50:19 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/2] perf_counter tools: Use hex2u64 in more places
Message-ID: <20090601205019.GA7805@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has also a nice side effect, tools built on newer systems such as
fedora 10 again work on systems with older versions of glibc:

My workstation:

[acme@doppio ~]$ rpm -q glibc.x86_64
glibc-2.9-3.x86_64

Test machine:

[acme@emilia ~]$ rpm -q glibc.x86_64
glibc-2.5-24

Before:

[acme@emilia ~]$ perf
perf: /lib64/libc.so.6: version `GLIBC_2.7' not found (required by perf)
[acme@emilia ~]$ nm `which perf` | grep GLIBC_2\.7
                 U __isoc99_sscanf@@GLIBC_2.7
[acme@emilia ~]$

After:
[acme@emilia ~]$ perf
usage: perf [--version] [--help] COMMAND [ARGS]

The most commonly used perf commands are:
   record   Run a command and record its profile into perf.data
   report   Read perf.data (created by perf record) and display the
profile
   stat     Run a command and gather performance counter statistics
   top      Run a command and profile it

See 'perf help COMMAND' for more information on a specific command.
[acme@emilia ~]$ nm `which perf` | grep GLIBC_2\.7
[acme@emilia ~]$

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/Makefile            |    2 +
 Documentation/perf_counter/builtin-record.c    |   56 +++++++++++++----------
 Documentation/perf_counter/builtin-report.c    |    1 +
 Documentation/perf_counter/util/parse-events.c |   27 +++++++-----
 Documentation/perf_counter/util/symbol.c       |   38 +---------------
 5 files changed, 54 insertions(+), 70 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 416ab11..3b8275f 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -296,6 +296,7 @@ LIB_H += util/quote.h
 LIB_H += util/util.h
 LIB_H += util/help.h
 LIB_H += util/strbuf.h
+LIB_H += util/string.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
@@ -315,6 +316,7 @@ LIB_OBJS += util/rbtree.o
 LIB_OBJS += util/run-command.o
 LIB_OBJS += util/quote.o
 LIB_OBJS += util/strbuf.o
+LIB_OBJS += util/string.o
 LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
 LIB_OBJS += util/sigchain.o
diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index 23d1224..5aee047 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -5,6 +5,7 @@
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
+#include "util/string.h"
 
 #include <sched.h>
 
@@ -165,12 +166,10 @@ static pid_t pid_synthesize_comm_event(pid_t pid)
 {
 	struct comm_event comm_ev;
 	char filename[PATH_MAX];
-	pid_t spid, ppid;
 	char bf[BUFSIZ];
-	int fd, nr, ret;
-	char comm[18];
+	int fd, ret;
 	size_t size;
-	char state;
+	char *field, *sep;
 
 	snprintf(filename, sizeof(filename), "/proc/%d/stat", pid);
 
@@ -185,20 +184,22 @@ static pid_t pid_synthesize_comm_event(pid_t pid)
 	}
 	close(fd);
 
+	/* 9027 (cat) R 6747 9027 6747 34816 9027 ... */
 	memset(&comm_ev, 0, sizeof(comm_ev));
-        nr = sscanf(bf, "%d %s %c %d %d ",
-			&spid, comm, &state, &ppid, &comm_ev.pid);
-	if (nr != 5) {
-		fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
-			filename);
-		exit(EXIT_FAILURE);
-	}
+	field = strchr(bf, '(');
+	if (field == NULL)
+		goto out_failure;
+	sep = strchr(++field, ')');
+	if (sep == NULL)
+		goto out_failure;
+	size = sep - field;
+	memcpy(comm_ev.comm, field, size++);
+	field = strchr(sep + 4, ' ');
+	if (field == NULL)
+		goto out_failure;
+	comm_ev.pid = atoi(++field);
 	comm_ev.header.type = PERF_EVENT_COMM;
 	comm_ev.tid = pid;
-	size = strlen(comm);
-	comm[--size] = '\0'; /* Remove the ')' at the end */
-	--size; /* Remove the '(' at the begin */
-	memcpy(comm_ev.comm, comm + 1, size);
 	size = ALIGN(size, sizeof(uint64_t));
 	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
 
@@ -208,6 +209,11 @@ static pid_t pid_synthesize_comm_event(pid_t pid)
 		exit(-1);
 	}
 	return comm_ev.pid;
+out_failure:
+	fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
+		filename);
+	exit(EXIT_FAILURE);
+	return -1;
 }
 
 static void pid_synthesize_mmap_events(pid_t pid, pid_t pgid)
@@ -223,23 +229,25 @@ static void pid_synthesize_mmap_events(pid_t pid, pid_t pgid)
 		exit(EXIT_FAILURE);
 	}
 	while (1) {
-		char bf[BUFSIZ];
-		unsigned char vm_read, vm_write, vm_exec, vm_mayshare;
+		char bf[BUFSIZ], *pbf = bf;
 		struct mmap_event mmap_ev = {
 			.header.type = PERF_EVENT_MMAP,
 		};
-		unsigned long ino;
-		int major, minor;
+		int n;
 		size_t size;
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		sscanf(bf, "%llx-%llx %c%c%c%c %llx %x:%x %lu",
-			&mmap_ev.start, &mmap_ev.len,
-                        &vm_read, &vm_write, &vm_exec, &vm_mayshare,
-                        &mmap_ev.pgoff, &major, &minor, &ino);
-		if (vm_exec == 'x') {
+		n = hex2u64(pbf, &mmap_ev.start);
+		if (n < 0)
+			continue;
+		pbf += n + 1;
+		n = hex2u64(pbf, &mmap_ev.len);
+		if (n < 0)
+			continue;
+		pbf += n + 3;
+		if (*pbf == 'x') { /* vm_exec */
 			char *execname = strrchr(bf, ' ');
 
 			if (execname == NULL || execname[1] != '/')
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 4705679..7973092 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -5,6 +5,7 @@
 #include "util/cache.h"
 #include "util/rbtree.h"
 #include "util/symbol.h"
+#include "util/string.h"
 
 #include "perf.h"
 
diff --git a/Documentation/perf_counter/util/parse-events.c b/Documentation/perf_counter/util/parse-events.c
index 88c903e..2fdfd1d 100644
--- a/Documentation/perf_counter/util/parse-events.c
+++ b/Documentation/perf_counter/util/parse-events.c
@@ -4,6 +4,7 @@
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
+#include "string.h"
 
 int nr_counters;
 
@@ -105,22 +106,26 @@ static __u64 match_event_symbols(const char *str)
 	__u64 config, id;
 	int type;
 	unsigned int i;
-	char mask_str[4];
+	const char *sep, *pstr;
 
-	if (sscanf(str, "r%llx", &config) == 1)
+	if (str[0] == 'r' && hex2u64(str + 1, &config) > 0)
 		return config | PERF_COUNTER_RAW_MASK;
 
-	switch (sscanf(str, "%d:%llu:%2s", &type, &id, mask_str)) {
-		case 3:
-			if (strchr(mask_str, 'k'))
+	pstr = str;
+	sep = strchr(pstr, ':');
+	if (sep) {
+		type = atoi(pstr);
+		pstr = sep + 1;
+		id = atoi(pstr);
+		sep = strchr(pstr, ':');
+		if (sep) {
+			pstr = sep + 1;
+			if (strchr(pstr, 'k'))
 				event_mask[nr_counters] |= EVENT_MASK_USER;
-			if (strchr(mask_str, 'u'))
+			if (strchr(pstr, 'u'))
 				event_mask[nr_counters] |= EVENT_MASK_KERNEL;
-		case 2:
-			return EID(type, id);
-
-		default:
-			break;
+		}
+		return EID(type, id);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index 4728121..31e8fae 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -1,5 +1,6 @@
 #include "util.h"
 #include "../perf.h"
+#include "string.h"
 #include "symbol.h"
 
 #include <libelf.h>
@@ -122,39 +123,6 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
 	return ret;
 }
 
-static int hex(char ch)
-{
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
-/*
- * While we find nice hex chars, build a long_val.
- * Return number of chars processed.
- */
-static int hex2long(char *ptr, unsigned long *long_val)
-{
-	const char *p = ptr;
-	*long_val = 0;
-
-	while (*p) {
-		const int hex_val = hex(*p);
-
-		if (hex_val < 0)
-			break;
-
-		*long_val = (*long_val << 4) | hex_val;
-		p++;
-	}
-
-	return p - ptr;
-}
-
 static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter)
 {
 	struct rb_node *nd, *prevnd;
@@ -166,7 +134,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter)
 		goto out_failure;
 
 	while (!feof(file)) {
-		unsigned long start;
+		__u64 start;
 		struct symbol *sym;
 		int line_len, len;
 		char symbol_type;
@@ -180,7 +148,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter)
 
 		line[--line_len] = '\0'; /* \n */
 
-		len = hex2long(line, &start);
+		len = hex2u64(line, &start);
 
 		len++;
 		if (len + 2 >= line_len)
-- 
1.6.0.6

