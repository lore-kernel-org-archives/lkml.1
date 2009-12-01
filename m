Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZLAAT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZLAAT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZLAATz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:19:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbZLAATt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:19:49 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/9] trace_kprobes: Fix a memory leak bug and check
	kstrdup return value
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 30 Nov 2009 19:19:20 -0500
Message-ID: <20091201001919.10235.56455.stgit@harusame>
In-Reply-To: <20091201001912.10235.79411.stgit@harusame>
References: <20091201001912.10235.79411.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak case in create_trace_probe(). When an argument is
too long (> MAX_ARGSTR_LEN), it just jumps to error path. In that case
tp->args[i].name is not released.
This also fixes a bug to check kstrdup()'s return value.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
