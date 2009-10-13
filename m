Return-Path: <linux-kernel-owner+w=401wt.eu-S934029AbZJMS0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934029AbZJMS0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbZJMS0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:26:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933561AbZJMS0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:26:00 -0400
Date: Tue, 13 Oct 2009 20:25:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20091013182515.GA14001@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ashwin Chaugule (1):
      perf tools: Remove static debugfs path from parse-events

Ingo Molnar (1):
      perf tools: Fix the NO_64BIT build on pure 64-bit systems

Randy Dunlap (1):
      perf tools: Fix const char type propagation

Vincent Legoll (1):
      perf events: Update MAINTAINERS entry file patterns


 MAINTAINERS                         |    7 +++++++
 tools/perf/Makefile                 |   21 ++++++++++++++-------
 tools/perf/builtin-sched.c          |    4 ++--
 tools/perf/util/parse-events.c      |    5 ++++-
 tools/perf/util/trace-event-parse.c |    8 ++++----
 5 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 69e31aa..cf69091 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4071,6 +4071,13 @@ M:	Peter Zijlstra <a.p.zijlstra@chello.nl>
 M:	Paul Mackerras <paulus@samba.org>
 M:	Ingo Molnar <mingo@elte.hu>
 S:	Supported
+F:	kernel/perf_event.c
+F:	include/linux/perf_event.h
+F:	arch/*/*/kernel/perf_event.c
+F:	arch/*/include/asm/perf_event.h
+F:	arch/*/lib/perf_event.c
+F:	arch/*/kernel/perf_callchain.c
+F:	tools/perf/
 
 PERSONALITY HANDLING
 M:	Christoph Hellwig <hch@infradead.org>
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5881943..742a32e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,11 +157,18 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
-# If we're on a 64-bit kernel, use -m64
-ifndef NO_64BIT
-	ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-	  M64 := -m64
-	endif
+#
+# Add -m32 for cross-builds:
+#
+ifdef NO_64BIT
+  MBITS := -m32
+else
+  #
+  # If we're on a 64-bit kernel, use -m64:
+  #
+  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+    MBITS := -m64
+  endif
 endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
@@ -194,7 +201,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
@@ -416,7 +423,7 @@ ifeq ($(uname_S),Darwin)
 endif
 
 ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
-	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
+	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index ea9c15c..ce2d5be 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1287,7 +1287,7 @@ static struct sort_dimension *available_sorts[] = {
 
 static LIST_HEAD(sort_list);
 
-static int sort_dimension__add(char *tok, struct list_head *list)
+static int sort_dimension__add(const char *tok, struct list_head *list)
 {
 	int i;
 
@@ -1917,7 +1917,7 @@ static void setup_sorting(void)
 
 	free(str);
 
-	sort_dimension__add((char *)"pid", &cmp_pid);
+	sort_dimension__add("pid", &cmp_pid);
 }
 
 static const char *record_args[] = {
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 87c424d..8cfb48c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -691,7 +691,10 @@ static void store_event_type(const char *orgname)
 	FILE *file;
 	int id;
 
-	sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);
+	sprintf(filename, "%s/", debugfs_path);
+	strncat(filename, orgname, strlen(orgname));
+	strcat(filename, "/id");
+
 	c = strchr(filename, ':');
 	if (c)
 		*c = '/';
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 55b41b9..55c9659 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -618,7 +618,7 @@ static int test_type(enum event_type type, enum event_type expect)
 }
 
 static int test_type_token(enum event_type type, char *token,
-		    enum event_type expect, char *expect_tok)
+		    enum event_type expect, const char *expect_tok)
 {
 	if (type != expect) {
 		die("Error: expected type %d but read %d",
@@ -650,7 +650,7 @@ static int read_expect_type(enum event_type expect, char **tok)
 	return __read_expect_type(expect, tok, 1);
 }
 
-static int __read_expected(enum event_type expect, char *str, int newline_ok)
+static int __read_expected(enum event_type expect, const char *str, int newline_ok)
 {
 	enum event_type type;
 	char *token;
@@ -668,12 +668,12 @@ static int __read_expected(enum event_type expect, char *str, int newline_ok)
 	return 0;
 }
 
-static int read_expected(enum event_type expect, char *str)
+static int read_expected(enum event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 1);
 }
 
-static int read_expected_item(enum event_type expect, char *str)
+static int read_expected_item(enum event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 0);
 }
