Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbZK0FvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbZK0FvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZK0FvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:51:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:57965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbZK0FvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:51:02 -0500
Date: Fri, 27 Nov 2009 05:50:15 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <4B0CEBCB.7080309@cn.fujitsu.com>
References: <4B0CEBCB.7080309@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_kprobes: Don't output zero offset
Message-ID: <tip-52a11f354970e7301e1d1a029b87535be45abec9@git.kernel.org>
Git-Commit-ID: 52a11f354970e7301e1d1a029b87535be45abec9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52a11f354970e7301e1d1a029b87535be45abec9
Gitweb:     http://git.kernel.org/tip/52a11f354970e7301e1d1a029b87535be45abec9
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Wed, 25 Nov 2009 16:33:15 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 27 Nov 2009 06:43:05 +0100

trace_kprobes: Don't output zero offset

"symbol_name+0" is not so friendly.
It makes the output longer.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0CEBCB.7080309@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_kprobe.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 96e1944..72d0c65 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -243,7 +243,11 @@ static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
 		ret = snprintf(buf, n, "@0x%p", ff->data);
 	else if (ff->func == fetch_symbol) {
 		struct symbol_cache *sc = ff->data;
-		ret = snprintf(buf, n, "@%s%+ld", sc->symbol, sc->offset);
+		if (sc->offset)
+			ret = snprintf(buf, n, "@%s%+ld", sc->symbol,
+					sc->offset);
+		else
+			ret = snprintf(buf, n, "@%s", sc->symbol);
 	} else if (ff->func == fetch_retvalue)
 		ret = snprintf(buf, n, "$retval");
 	else if (ff->func == fetch_stack_address)
@@ -762,10 +766,12 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
 	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
 
-	if (tp->symbol)
+	if (!tp->symbol)
+		seq_printf(m, " 0x%p", tp->rp.kp.addr);
+	else if (tp->rp.kp.offset)
 		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);
 	else
-		seq_printf(m, " 0x%p", tp->rp.kp.addr);
+		seq_printf(m, " %s", probe_symbol(tp));
 
 	for (i = 0; i < tp->nr_args; i++) {
 		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i].fetch);
