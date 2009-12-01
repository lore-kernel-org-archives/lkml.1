Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZLAHfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZLAHfC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZLAHfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:35:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:37379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbZLAHdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:33:47 -0500
Date: Tue, 1 Dec 2009 07:31:21 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, dle-develop@lists.sourceforge.net,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, hch@infradead.org, ananth@in.ibm.com,
       srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091201001919.10235.56455.stgit@harusame>
References: <20091201001919.10235.56455.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_kprobes: Fix a memory leak bug and check kstrdup() return value
Message-ID: <tip-ba8665d7dd95eb6093ee06f8f624b6acb1e73206@git.kernel.org>
Git-Commit-ID: ba8665d7dd95eb6093ee06f8f624b6acb1e73206
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba8665d7dd95eb6093ee06f8f624b6acb1e73206
Gitweb:     http://git.kernel.org/tip/ba8665d7dd95eb6093ee06f8f624b6acb1e73206
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 30 Nov 2009 19:19:20 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 08:19:59 +0100

trace_kprobes: Fix a memory leak bug and check kstrdup() return value

Fix a memory leak case in create_trace_probe(). When an argument
is too long (> MAX_ARGSTR_LEN), it just jumps to error path. In
that case tp->args[i].name is not released.
This also fixes a bug to check kstrdup()'s return value.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091201001919.10235.56455.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 72d0c65..aff5f80 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -483,7 +483,8 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
 	return ret;
 }
 
-static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
+/* Recursive argument parser */
+static int __parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 {
 	int ret = 0;
 	unsigned long param;
@@ -543,7 +544,7 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 			if (!id)
 				return -ENOMEM;
 			id->offset = offset;
-			ret = parse_probe_arg(arg, &id->orig, is_return);
+			ret = __parse_probe_arg(arg, &id->orig, is_return);
 			if (ret)
 				kfree(id);
 			else {
@@ -560,6 +561,16 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 	return ret;
 }
 
+/* String length checking wrapper */
+static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
+{
+	if (strlen(arg) > MAX_ARGSTR_LEN) {
+		pr_info("Argument is too long.: %s\n",  arg);
+		return -ENOSPC;
+	}
+	return __parse_probe_arg(arg, ff, is_return);
+}
+
 /* Return 1 if name is reserved or already used by another argument */
 static int conflict_field_name(const char *name,
 			       struct probe_arg *args, int narg)
@@ -698,13 +709,14 @@ static int create_trace_probe(int argc, char **argv)
 		}
 
 		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
-
-		/* Parse fetch argument */
-		if (strlen(arg) > MAX_ARGSTR_LEN) {
-			pr_info("Argument%d(%s) is too long.\n", i, arg);
-			ret = -ENOSPC;
+		if (!tp->args[i].name) {
+			pr_info("Failed to allocate argument%d name '%s'.\n",
+				i, argv[i]);
+			ret = -ENOMEM;
 			goto error;
 		}
+
+		/* Parse fetch argument */
 		ret = parse_probe_arg(arg, &tp->args[i].fetch, is_return);
 		if (ret) {
 			pr_info("Parse error at argument%d. (%d)\n", i, ret);
