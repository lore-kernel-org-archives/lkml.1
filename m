Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZKYIdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZKYIdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZKYIdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:33:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49939 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbZKYIdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:33:37 -0500
Message-ID: <4B0CEBCB.7080309@cn.fujitsu.com>
Date: Wed, 25 Nov 2009 16:33:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] trace_kprobes: don't output zero offset
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"symbol_name+0" is not so friendly.
It makes the output longer.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9e42f2a..e82bea3 100644
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
@@ -760,10 +764,12 @@ static int probes_seq_show(struct seq_file *m, void *v)
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


