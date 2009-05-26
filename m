Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZEZMPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZEZMPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbZEZMOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:14:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:51307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbZEZMOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:14:39 -0400
Date: Tue, 26 May 2009 12:14:00 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf record: Convert to Git option parsing
Message-ID: <tip-53cb8bc2a3d976efd1a800c3de4640a7220afbb3@git.kernel.org>
Git-Commit-ID: 53cb8bc2a3d976efd1a800c3de4640a7220afbb3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 12:14:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53cb8bc2a3d976efd1a800c3de4640a7220afbb3
Gitweb:     http://git.kernel.org/tip/53cb8bc2a3d976efd1a800c3de4640a7220afbb3
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 26 May 2009 09:17:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 13:05:27 +0200

perf record: Convert to Git option parsing

Remove getopt usage and use Git's much more advanced and more compact
command option library.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |  126 ++++++++-------------------
 1 files changed, 38 insertions(+), 88 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 21386a8..9e59d60 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -1,52 +1,29 @@
-#define _GNU_SOURCE
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/time.h>
-#include <unistd.h>
-#include <stdint.h>
-#include <stdbool.h>
-#include <stdlib.h>
-#include <string.h>
-#include <limits.h>
+#include "util/util.h"
+
+#include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
-#include <libelf.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <errno.h>
-#include <ctype.h>
-#include <time.h>
-#include <getopt.h>
-#include <assert.h>
-#include <search.h>
-
-#include <sys/ioctl.h>
-#include <sys/poll.h>
-#include <sys/prctl.h>
-#include <sys/wait.h>
-#include <sys/mman.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-
-#include <linux/unistd.h>
-#include <linux/types.h>
-
-#include "../../include/linux/perf_counter.h"
+
 #include "util/list.h"
 #include "util/rbtree.h"
 
+#include "perf.h"
+
+#include "util/parse-options.h"
+#include "util/parse-events.h"
+
 #define SHOW_KERNEL	1
 #define SHOW_USER	2
 #define SHOW_HV		4
 
-static char 		const *input_name = "output.perf";
+static char		const *input_name = "output.perf";
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
 
-static const char *perf_event_names[] = {
+const char *perf_event_names[] = {
 	[PERF_EVENT_MMAP]   = " PERF_EVENT_MMAP",
 	[PERF_EVENT_MUNMAP] = " PERF_EVENT_MUNMAP",
 	[PERF_EVENT_COMM]   = " PERF_EVENT_COMM",
@@ -86,7 +63,7 @@ struct section {
 	char		 name[0];
 };
 
-static struct section *section__new(uint64_t start, uint64_t size,
+struct section *section__new(uint64_t start, uint64_t size,
 				    uint64_t offset, char *name)
 {
 	struct section *self = malloc(sizeof(*self) + strlen(name) + 1);
@@ -241,7 +218,7 @@ static inline uint8_t elf_sym__type(const GElf_Sym *sym)
 	return GELF_ST_TYPE(sym->st_info);
 }
 
-static inline bool elf_sym__is_function(const GElf_Sym *sym)
+static inline int elf_sym__is_function(const GElf_Sym *sym)
 {
 	return elf_sym__type(sym) == STT_FUNC &&
 	       sym->st_name != 0 &&
@@ -393,7 +370,7 @@ out_delete_dso:
 	return NULL;
 }
 
-static void dsos__fprintf(FILE *fp)
+void dsos__fprintf(FILE *fp)
 {
 	struct dso *pos;
 
@@ -503,7 +480,7 @@ static struct symhist *symhist__new(struct symbol *sym, uint64_t ip,
 	return self;
 }
 
-static void symhist__delete(struct symhist *self)
+void symhist__delete(struct symhist *self)
 {
 	free(self);
 }
@@ -587,7 +564,7 @@ static int thread__set_comm(struct thread *self, const char *comm)
 	return self->comm ? 0 : -ENOMEM;
 }
 
-static size_t thread__maps_fprintf(struct thread *self, FILE *fp)
+size_t thread__maps_fprintf(struct thread *self, FILE *fp)
 {
 	struct map *pos;
 	size_t ret = 0;
@@ -668,49 +645,7 @@ static void threads__fprintf(FILE *fp)
 	}
 }
 
-static void display_help(void)
-{
-	printf(
-	"Usage: perf-report [<options>]\n"
-	" -i file   --input=<file>      # input file\n"
-	);
-
-	exit(0);
-}
-
-static void process_options(int argc, char *argv[])
-{
-	int error = 0;
-
-	for (;;) {
-		int option_index = 0;
-		/** Options for getopt */
-		static struct option long_options[] = {
-			{"input",	required_argument,	NULL, 'i'},
-			{"no-user",	no_argument,		NULL, 'u'},
-			{"no-kernel",	no_argument,		NULL, 'k'},
-			{"no-hv",	no_argument,		NULL, 'h'},
-			{NULL,		0,			NULL,  0 }
-		};
-		int c = getopt_long(argc, argv, "+:i:kuh",
-				    long_options, &option_index);
-		if (c == -1)
-			break;
-
-		switch (c) {
-		case 'i': input_name			= strdup(optarg); break;
-		case 'k': show_mask &= ~SHOW_KERNEL; break;
-		case 'u': show_mask &= ~SHOW_USER; break;
-		case 'h': show_mask &= ~SHOW_HV; break;
-		default: error = 1; break;
-		}
-	}
-
-	if (error)
-		display_help();
-}
-
-int cmd_report(int argc, char **argv)
+static int __cmd_report(void)
 {
 	unsigned long offset = 0;
 	unsigned long head = 0;
@@ -720,12 +655,6 @@ int cmd_report(int argc, char **argv)
 	int ret, rc = EXIT_FAILURE;
 	unsigned long total = 0;
 
-	elf_version(EV_CURRENT);
-
-	page_size = getpagesize();
-
-	process_options(argc, argv);
-
 	input = open(input_name, O_RDONLY);
 	if (input < 0) {
 		perror("failed to open file");
@@ -867,3 +796,24 @@ done:
 	return rc;
 }
 
+static const char * const report_usage[] = {
+	"perf report [<options>] <command>",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_END()
+};
+
+int cmd_report(int argc, const char **argv, const char *prefix)
+{
+	elf_version(EV_CURRENT);
+
+	page_size = getpagesize();
+
+	parse_options(argc, argv, options, report_usage, 0);
+
+	return __cmd_report();
+}
