Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZJLGxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZJLGxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZJLGx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:53:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:53667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZJLGx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:53:28 -0400
Date: Mon, 12 Oct 2009 06:52:14 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, randy.dunlap@oracle.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, randy.dunlap@oracle.com,
       mingo@elte.hu
In-Reply-To: <20091005131729.78444bfb.randy.dunlap@oracle.com>
References: <20091005131729.78444bfb.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix const char type propagation
Message-ID: <tip-cbef79a82a64ec13e745ce2b0274154ae1e47243@git.kernel.org>
Git-Commit-ID: cbef79a82a64ec13e745ce2b0274154ae1e47243
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 06:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbef79a82a64ec13e745ce2b0274154ae1e47243
Gitweb:     http://git.kernel.org/tip/cbef79a82a64ec13e745ce2b0274154ae1e47243
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Mon, 5 Oct 2009 13:17:29 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 08:35:00 +0200

perf tools: Fix const char type propagation

The following perf build warnings/errors in function
argument types:

  builtin-sched.c:1894: warning: passing argument 1 of 'sort_dimension__add' discards qualifiers from pointer target type
  util/trace-event-parse.c:685: warning: passing argument 2 of 'read_expected' discards qualifiers from pointer target type
  util/trace-event-parse.c:741: warning: passing argument 4 of 'test_type_token' discards qualifiers from pointer target type
  util/trace-event-parse.c:706: warning: passing argument 2 of 'read_expected_item' discards qualifiers from pointer target type

... trigger because older GCC is not able to prove that
sort_dimension__add() does not change the string.

Some goes for test_type_token().

Fix this by improving type consistency.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20091005131729.78444bfb.randy.dunlap@oracle.com>
[ Also remove ugly type cast now unnecessary. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-sched.c          |    4 ++--
 tools/perf/util/trace-event-parse.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

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
