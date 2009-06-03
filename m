Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZFCWg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZFCWg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZFCWgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:36:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:43604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbZFCWgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:36:16 -0400
Date: Wed, 3 Jun 2009 22:35:35 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Clean up event processing
Message-ID: <tip-d80d338d2fb611b65830db7ea56680624776030f@git.kernel.org>
Git-Commit-ID: d80d338d2fb611b65830db7ea56680624776030f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 22:35:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d80d338d2fb611b65830db7ea56680624776030f
Gitweb:     http://git.kernel.org/tip/d80d338d2fb611b65830db7ea56680624776030f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 3 Jun 2009 23:14:49 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 23:14:49 +0200

perf report: Clean up event processing

- Split out event processig into process_events() helper.

- Untangle the cwd parameters - it's constant so can be a static.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  186 ++++++++++++++-------------
 1 files changed, 98 insertions(+), 88 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 33b3b15..333d312 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -147,7 +147,11 @@ static int load_kernel(void)
 	return err;
 }
 
-static int strcommon(const char *pathname, const char *cwd, int cwdlen)
+static char __cwd[PATH_MAX];
+static char *cwd = __cwd;
+static int cwdlen;
+
+static int strcommon(const char *pathname)
 {
 	int n = 0;
 
@@ -165,7 +169,7 @@ struct map {
 	struct dso	 *dso;
 };
 
-static struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
+static struct map *map__new(struct mmap_event *event)
 {
 	struct map *self = malloc(sizeof(*self));
 
@@ -174,7 +178,8 @@ static struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen)
 		char newfilename[PATH_MAX];
 
 		if (cwd) {
-			int n = strcommon(filename, cwd, cwdlen);
+			int n = strcommon(filename);
+
 			if (n == cwdlen) {
 				snprintf(newfilename, sizeof(newfilename),
 					 ".%s", filename + n);
@@ -752,85 +757,11 @@ static void register_idle_thread(void)
 	}
 }
 
+static unsigned long total = 0, total_mmap = 0, total_comm = 0, total_unknown = 0;
 
-static int __cmd_report(void)
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	unsigned long offset = 0;
-	unsigned long head = 0;
-	struct stat stat;
-	char *buf;
-	event_t *event;
-	int ret, rc = EXIT_FAILURE;
-	uint32_t size;
-	unsigned long total = 0, total_mmap = 0, total_comm = 0, total_unknown = 0;
-	char cwd[PATH_MAX], *cwdp = cwd;
-	int cwdlen;
-
-	register_idle_thread();
-
-	input = open(input_name, O_RDONLY);
-	if (input < 0) {
-		perror("failed to open file");
-		exit(-1);
-	}
-
-	ret = fstat(input, &stat);
-	if (ret < 0) {
-		perror("failed to stat file");
-		exit(-1);
-	}
-
-	if (!stat.st_size) {
-		fprintf(stderr, "zero-sized file, nothing to do!\n");
-		exit(0);
-	}
-
-	if (load_kernel() < 0) {
-		perror("failed to load kernel symbols");
-		return EXIT_FAILURE;
-	}
-
-	if (!full_paths) {
-		if (getcwd(cwd, sizeof(cwd)) == NULL) {
-			perror("failed to get the current directory");
-			return EXIT_FAILURE;
-		}
-		cwdlen = strlen(cwd);
-	} else {
-		cwdp = NULL;
-		cwdlen = 0;
-	}
-remap:
-	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
-			   MAP_SHARED, input, offset);
-	if (buf == MAP_FAILED) {
-		perror("failed to mmap file");
-		exit(-1);
-	}
-
-more:
-	event = (event_t *)(buf + head);
-
-	size = event->header.size;
-	if (!size)
-		size = 8;
-
-	if (head + event->header.size >= page_size * mmap_window) {
-		unsigned long shift = page_size * (head / page_size);
-		int ret;
-
-		ret = munmap(buf, page_size * mmap_window);
-		assert(ret == 0);
-
-		offset += shift;
-		head -= shift;
-		goto remap;
-	}
-
-	size = event->header.size;
-	if (!size)
-		goto broken_event;
-
 	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
 		char level;
 		int show = 0;
@@ -851,7 +782,7 @@ more:
 		if (thread == NULL) {
 			fprintf(stderr, "problem processing %d event, skipping it.\n",
 				event->header.type);
-			goto broken_event;
+			return -1;
 		}
 
 		if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
@@ -895,14 +826,14 @@ more:
 			if (hist_entry__add(thread, map, dso, sym, ip, level)) {
 				fprintf(stderr,
 		"problem incrementing symbol count, skipping event\n");
-				goto broken_event;
+				return -1;
 			}
 		}
 		total++;
 	} else switch (event->header.type) {
 	case PERF_EVENT_MMAP: {
 		struct thread *thread = threads__findnew(event->mmap.pid);
-		struct map *map = map__new(&event->mmap, cwdp, cwdlen);
+		struct map *map = map__new(&event->mmap);
 
 		dprintf("%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
 			(void *)(offset + head),
@@ -915,7 +846,7 @@ more:
 		if (thread == NULL || map == NULL) {
 			if (verbose)
 				fprintf(stderr, "problem processing PERF_EVENT_MMAP, skipping event.\n");
-			goto broken_event;
+			return -1;
 		}
 		thread__insert_map(thread, map);
 		total_mmap++;
@@ -932,13 +863,93 @@ more:
 		if (thread == NULL ||
 		    thread__set_comm(thread, event->comm.comm)) {
 			fprintf(stderr, "problem processing PERF_EVENT_COMM, skipping event.\n");
-			goto broken_event;
+			return -1;
 		}
 		total_comm++;
 		break;
 	}
-	default: {
-broken_event:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int __cmd_report(void)
+{
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat stat;
+	char *buf;
+	event_t *event;
+	int ret, rc = EXIT_FAILURE;
+	uint32_t size;
+
+	register_idle_thread();
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	if (load_kernel() < 0) {
+		perror("failed to load kernel symbols");
+		return EXIT_FAILURE;
+	}
+
+	if (!full_paths) {
+		if (getcwd(__cwd, sizeof(__cwd)) == NULL) {
+			perror("failed to get the current directory");
+			return EXIT_FAILURE;
+		}
+		cwdlen = strlen(cwd);
+	} else {
+		cwd = NULL;
+		cwdlen = 0;
+	}
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+		int ret;
+
+		ret = munmap(buf, page_size * mmap_window);
+		assert(ret == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+	if (!size || process_event(event, offset, head) < 0) {
+
 		dprintf("%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
@@ -956,7 +967,6 @@ broken_event:
 
 		size = 8;
 	}
-	}
 
 	head += size;
 
