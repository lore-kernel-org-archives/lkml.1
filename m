Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbZCZXBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbZCZXBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbZCZW76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:59:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697AbZCZW74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:59:56 -0400
Message-ID: <49CC08D8.6080501@redhat.com>
Date: Thu, 26 Mar 2009 18:59:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -tip 4/4 V3] tracing: kprobe-tracer plugin supports fetching
 symbol value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add symbol value fetching support. This allows kprobe tracer to fetch the
value of global variables.

To record some values of symbols, just specify @SYMBOL(e.g. @jiffies).
Offset specifying is also available(e.g. @jiffies+4).
---

 Documentation/ftrace.txt    |    1
 kernel/trace/trace_kprobe.c |  120 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 104 insertions(+), 17 deletions(-)


diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
index ddc75af..1ad2e66 100644
--- a/Documentation/ftrace.txt
+++ b/Documentation/ftrace.txt
@@ -1336,6 +1336,7 @@ Synopsis of kprobe_probes:
   rN	: Fetch Nth register (N >= 0)
   sN	: Fetch Nth entry of stack (N >= 0)
   @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
+  @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
   aN	: Fetch function argument. (N >= 1)(*)
   rv	: Fetch return value.(**)
   rp	: Fetch return address.(**)
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 68b2833..c22a5c6 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -142,6 +142,55 @@ static unsigned long fetch_ip(struct pt_regs *regs, void *dummy)
 	return instruction_pointer(regs);
 }

+struct symbol_cache {
+	char *symbol;
+	long offset;
+	unsigned long addr;
+};
+
+static unsigned long update_symbol_cache(struct symbol_cache *sc)
+{
+	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
+	if (sc->addr)
+		sc->addr += sc->offset;
+	return sc->addr;
+}
+
+static void free_symbol_cache(struct symbol_cache *sc)
+{
+	kfree(sc->symbol);
+	kfree(sc);
+}
+
+static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
+{
+	struct symbol_cache *sc;
+	if (!sym || strlen(sym) == 0)
+		return NULL;
+	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
+	if (!sc)
+		return NULL;
+
+	sc->symbol = kstrdup(sym, GFP_KERNEL);
+	if (!sc->symbol) {
+		kfree(sc);
+		return NULL;
+	}
+	sc->offset = offset;
+
+	update_symbol_cache(sc);
+	return sc;
+}
+
+static unsigned long fetch_symbol(struct pt_regs *regs, void *data)
+{
+	struct symbol_cache *sc = data;
+	if (sc->addr)
+		return fetch_memory(regs, (void *)sc->addr);
+	else
+		return 0;
+}
+

 /**
  * kprobe_trace_core
@@ -225,6 +274,11 @@ static struct trace_probe *alloc_trace_probe(const char *symbol)

 static void free_trace_probe(struct trace_probe *tp)
 {
+	int i;
+	for (i = 0; i < tp->nr_args; i++)
+		if (tp->args[i].func == fetch_symbol)
+			free_symbol_cache(tp->args[i].data);
+
 	kfree(tp->symbol);
 	kfree(tp);
 }
@@ -258,6 +312,32 @@ static void unregister_trace_probe(struct trace_probe *tp)
 	list_del(&tp->list);
 }

+/* Split symbol and offset. */
+static int split_symbol_offset(char *symbol, long *offset)
+{
+	char *tmp;
+	int ret;
+
+	if (!offset)
+		return -EINVAL;
+
+	tmp = strchr(symbol, '+');
+	if (!tmp)
+		tmp = strchr(symbol, '-');
+
+	if (tmp) {
+		/* skip sign because strict_strtol doesn't accept '+' */
+		ret = strict_strtol(tmp + 1, 0, offset);
+		if (ret)
+			return ret;
+		if (*tmp == '-')
+			*offset = -(*offset);
+		*tmp = '\0';
+	} else
+		*offset = 0;
+	return 0;
+}
+
 #define PARAM_MAX_ARGS 16
 #define PARAM_MAX_REGS MAX_REG_NUM
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
@@ -273,6 +353,7 @@ static int create_trace_probe(int argc, char **argv)
 	 *  rN	: fetch Nth of register (pt_regs + N) (N:0-)
 	 *  sN	: fetch Nth of stack (N:0-)
 	 *  @ADDR	: fetch memory at ADDR (ADDR should be in kernel)
+	 *  @SYM[+|-offs] : fetch memory at SYM +|- offs (SYM is a data symbol)
 	 */
 	struct trace_probe *tp;
 	struct kprobe *kp;
@@ -305,19 +386,9 @@ static int create_trace_probe(int argc, char **argv)
 		/* a symbol specified */
 		symbol = argv[1];
 		/* TODO: support .init module functions */
-		tmp = strchr(symbol, '+');
-		if (!tmp)
-			tmp = strchr(symbol, '-');
-
-		if (tmp) {
-			/* skip sign because strict_strtol doesn't accept '+' */
-			ret = strict_strtol(tmp + 1, 0, &offset);
-			if (ret)
-				return ret;
-			if (*tmp == '-')
-				offset = -offset;
-			*tmp = '\0';
-		}
+		ret = split_symbol_offset(symbol, &offset);
+		if (ret)
+			return ret;
 		if (offset && is_return)
 			return -EINVAL;
 	}
@@ -383,11 +454,23 @@ static int create_trace_probe(int argc, char **argv)
 				tp->args[i].data = (void *)param;
 			}
 			break;
-		case '@':	/* memory */
-			ret = strict_strtoul(tmp + 1, 0, &param);
-			if (!ret) {
+		case '@':	/* memory or symbol */
+			if (isdigit(tmp[1])) {
+				ret = strict_strtoul(tmp + 1, 0, &param);
+				if (ret)
+					break;
 				tp->args[i].func = fetch_memory;
 				tp->args[i].data = (void *)param;
+			} else {
+				ret = split_symbol_offset(tmp + 1, &offset);
+				if (ret)
+					break;
+				tp->args[i].data = alloc_symbol_cache(tmp + 1,
+								      offset);
+				if (tp->args[i].data)
+					tp->args[i].func = fetch_symbol;
+				else
+					ret = -EINVAL;
 			}
 			break;
 		default:
@@ -466,7 +549,10 @@ static int probes_seq_show(struct seq_file *m, void *v)
 			seq_printf(m, " s%lu", (unsigned long)tp->args[i].data);
 		else if (tp->args[i].func == fetch_memory)
 			seq_printf(m, " @0x%p", tp->args[i].data);
-		else if (tp->args[i].func == fetch_retvalue)
+		else if (tp->args[i].func == fetch_symbol) {
+			struct symbol_cache *sc = tp->args[i].data;
+			seq_printf(m, " @%s%+ld", sc->symbol, sc->offset);
+		} else if (tp->args[i].func == fetch_retvalue)
 			seq_printf(m, " rv");
 		else if (tp->args[i].func == fetch_ip)
 			seq_printf(m, " rp");
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

