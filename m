Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbZE0HWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbZE0HWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbZE0HRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:50219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477AbZE0HRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:39 -0400
Date: Wed, 27 May 2009 07:16:27 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, rostedt@goodmis.org,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, rostedt@goodmis.org, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090526222155.GJ4424@ghostprotocols.net>
References: <20090526222155.GJ4424@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf report: Only load text symbols from kallsyms, fix
Message-ID: <tip-af83632f98aefd1ae4d8ca3c7c285ccf6a7d3956@git.kernel.org>
Git-Commit-ID: af83632f98aefd1ae4d8ca3c7c285ccf6a7d3956
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 07:16:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af83632f98aefd1ae4d8ca3c7c285ccf6a7d3956
Gitweb:     http://git.kernel.org/tip/af83632f98aefd1ae4d8ca3c7c285ccf6a7d3956
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 May 2009 08:38:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 09:10:37 +0200

perf report: Only load text symbols from kallsyms, fix

- allow 'W' symbols too
 - Convert initializations to C99 style
 - whitespace cleanups

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090526222155.GJ4424@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   30 ++++++++++++++++----------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index a55f15d..ed3da9d 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -384,21 +384,26 @@ int hex2long(char *ptr, unsigned long *long_val)
 
 static int load_kallsyms(void)
 {
+	struct rb_node *nd, *prevnd;
+	char *line = NULL;
+	FILE *file;
+	size_t n;
+
 	kernel_dso = dso__new("[kernel]");
 	if (kernel_dso == NULL)
 		return -1;
 
-	FILE *file = fopen("/proc/kallsyms", "r");
-
+	file = fopen("/proc/kallsyms", "r");
 	if (file == NULL)
 		goto out_delete_dso;
 
-	char *line = NULL;
-	size_t n;
-
 	while (!feof(file)) {
 		unsigned long start;
-		int line_len = getline(&line, &n, file);
+		struct symbol *sym;
+		int line_len, len;
+		char symbol_type;
+
+		line_len = getline(&line, &n, file);
 		if (line_len < 0)
 			break;
 
@@ -407,22 +412,22 @@ static int load_kallsyms(void)
 
 		line[--line_len] = '\0'; /* \n */
 
-		int len = hex2long(line, &start);
-		
+		len = hex2long(line, &start);
+
 		len++;
 		if (len + 2 >= line_len)
 			continue;
 
-		char symbol_type = line[len];
+		symbol_type = toupper(line[len]);
 		/*
 		 * We're interested only in code ('T'ext)
 		 */
-		if (toupper(symbol_type) != 'T')
+		if (symbol_type != 'T' && symbol_type != 'W')
 			continue;
 		/*
 		 * Well fix up the end later, when we have all sorted.
 		 */
-		struct symbol *sym = symbol__new(start, 0xdead, line + len + 2);
+		sym = symbol__new(start, 0xdead, line + len + 2);
 
 		if (sym == NULL)
 			goto out_delete_dso;
@@ -434,7 +439,7 @@ static int load_kallsyms(void)
 	 * Now that we have all sorted out, just set the ->end of all
 	 * symbols
 	 */
-	struct rb_node *nd, *prevnd = rb_first(&kernel_dso->syms);
+	prevnd = rb_first(&kernel_dso->syms);
 
 	if (prevnd == NULL)
 		goto out_delete_line;
@@ -450,6 +455,7 @@ static int load_kallsyms(void)
 	dsos__add(kernel_dso);
 	free(line);
 	fclose(file);
+
 	return 0;
 
 out_delete_line:
