Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab0BZOX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:23:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964839Ab0BZOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:23:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf annotate: Handle samples not at objdump output addr boundaries
Date: Fri, 26 Feb 2010 11:23:14 -0300
Message-Id: <1267194194-15670-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Without this patch we get this for need_resched:

[root@mica ~]# perf annotate need_resched

------------------------------------------------
 Percent |      Source code & Disassembly of vmlinux
------------------------------------------------
         :
         :
         :      Disassembly of section .text:
         :
         :      ffffffff810095ed <need_resched>:
         :              return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
         :      }
         :
         :      static inline int need_resched(void)
         :      {
    0.00 :      ffffffff810095ed:       55                      push   %rbp
         :              return unlikely(test_thread_flag(TIF_NEED_RESCHED));
    0.00 :      ffffffff810095ee:       be 03 00 00 00          mov    $0x3,%esi
         :
         :      static inline struct thread_info *current_thread_info(void)
         :      {
         :              struct thread_info *ti;
         :              ti = (void *)(percpu_read_stable(kernel_stack) +
    0.00 :      ffffffff810095f3:       65 48 8b 3c 25 48 b5    mov    %gs:0xb548,%rdi
    0.00 :      ffffffff810095fa:       00 00
         :              return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
         :      }
         :
         :      static inline int need_resched(void)
         :      {
    0.00 :      ffffffff810095fc:       48 89 e5                mov    %rsp,%rbp
         :              return unlikely(test_thread_flag(TIF_NEED_RESCHED));
    0.00 :      ffffffff810095ff:       48 81 ef d8 1f 00 00    sub    $0x1fd8,%rdi
    0.00 :      ffffffff81009606:       e8 9d ff ff ff          callq  ffffffff810095a8 <test_ti_thread_flag>
         :      }
    0.00 :      ffffffff8100960b:       c9                      leaveq
    0.00 :      ffffffff8100960c:       85 c0                   test   %eax,%eax
    0.00 :      ffffffff8100960e:       0f 95 c0                setne  %al
    0.00 :      ffffffff81009611:       0f b6 c0                movzbl %al,%eax
         :      Disassembly of section .vsyscall_0:
         :      Disassembly of section .vsyscall_fn:
         :      Disassembly of section .vsyscall_1:
         :      Disassembly of section .vsyscall_2:
         :      Disassembly of section .init.text:
         :      Disassembly of section .altinstr_replacement:
         :      Disassembly of section .exit.text:
[root@mica ~]#

But from the 'perf report' result we know that there are hits for need_resched
on a 4 way machine mostly doing nothing, so after adding code to show what is
in each hist offset and collapsing IP hits for what happens between objdump
lines we get, for the same perf.data file:

[root@mica ~]# perf annotate -v need_resched

------------------------------------------------
 Percent |      Source code & Disassembly of vmlinux
------------------------------------------------
         :
         :
         :      Disassembly of section .text:
         :
         :      ffffffff810095ed <need_resched>:
         :              return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
         :      }
         :
         :      static inline int need_resched(void)
         :      {
    0.00 :      ffffffff810095ed:       55                      push   %rbp
         :              return unlikely(test_thread_flag(TIF_NEED_RESCHED));
   52.78 :      ffffffff810095ee:       be 03 00 00 00          mov    $0x3,%esi
         :
         :      static inline struct thread_info *current_thread_info(void)
         :      {
         :              struct thread_info *ti;
         :              ti = (void *)(percpu_read_stable(kernel_stack) +
    0.00 :      ffffffff810095f3:       65 48 8b 3c 25 48 b5    mov    %gs:0xb548,%rdi
    0.00 :      ffffffff810095fa:       00 00
         :              return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
         :      }
         :
         :      static inline int need_resched(void)
         :      {
    0.00 :      ffffffff810095fc:       48 89 e5                mov    %rsp,%rbp
         :              return unlikely(test_thread_flag(TIF_NEED_RESCHED));
    9.72 :      ffffffff810095ff:       48 81 ef d8 1f 00 00    sub    $0x1fd8,%rdi
    0.00 :      ffffffff81009606:       e8 9d ff ff ff          callq  ffffffff810095a8 <test_ti_thread_flag>
         :      }
    0.00 :      ffffffff8100960b:       c9                      leaveq
    0.00 :      ffffffff8100960c:       85 c0                   test   %eax,%eax
   37.50 :      ffffffff8100960e:       0f 95 c0                setne  %al
    0.00 :      ffffffff81009611:       0f b6 c0                movzbl %al,%eax
         :      Disassembly of section .vsyscall_0:
         :      Disassembly of section .vsyscall_fn:
         :      Disassembly of section .vsyscall_1:
         :      Disassembly of section .vsyscall_2:
         :      Disassembly of section .init.text:
         :      Disassembly of section .altinstr_replacement:
         :      Disassembly of section .exit.text:
[root@mica ~]#

And now 'perf annotate -v', verbose mode, will show the hits per precise IP,
so that one can make sense of the attribution to each objdumop line:

[root@mica ~]# perf annotate -v need_resched
Looking at the vmlinux_path (5 entries long)
Using /lib/modules/2.6.33-rc8-tip-00784-g3471df5-dirty/build/vmlinux for symbols
annotate_sym: filename=/lib/modules/2.6.33-rc8-tip-00784-g3471df5-dirty/build/vmlinux, sym=need_resched, start=0xffffffff810095ed, end=0xffffffff81009614

------------------------------------------------
 Percent |      Source code & Disassembly of vmlinux
------------------------------------------------
                ffffffff810095f1: 152
                ffffffff81009603: 28
                ffffffff8100960f: 55
                ffffffff81009610: 53
                          h->sum: 288
<SNIP same annotation>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |  135 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 112 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e47dd15..5ec5de9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -145,21 +145,58 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int parse_line(FILE *file, struct hist_entry *he, u64 len)
+struct objdump_line {
+	struct list_head node;
+	s64		 offset;
+	char		 *line;
+};
+
+static struct objdump_line *objdump_line__new(s64 offset, char *line)
+{
+	struct objdump_line *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->offset = offset;
+		self->line = line;
+	}
+
+	return self;
+}
+
+static void objdump_line__free(struct objdump_line *self)
+{
+	free(self->line);
+	free(self);
+}
+
+static void objdump__add_line(struct list_head *head, struct objdump_line *line)
+{
+	list_add_tail(&line->node, head);
+}
+
+static struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
+						      struct objdump_line *pos)
+{
+	list_for_each_entry_continue(pos, head, node)
+		if (pos->offset >= 0)
+			return pos;
+
+	return NULL;
+}
+
+static int parse_line(FILE *file, struct hist_entry *he,
+		      struct list_head *head)
 {
 	struct symbol *sym = he->sym;
+	struct objdump_line *objdump_line;
 	char *line = NULL, *tmp, *tmp2;
-	static const char *prev_line;
-	static const char *prev_color;
-	unsigned int offset;
 	size_t line_len;
-	u64 start;
-	s64 line_ip;
-	int ret;
+	s64 line_ip, offset = -1;
 	char *c;
 
 	if (getline(&line, &line_len, file) < 0)
 		return -1;
+
 	if (!line)
 		return -1;
 
@@ -168,8 +205,6 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 		*c = 0;
 
 	line_ip = -1;
-	offset = 0;
-	ret = -2;
 
 	/*
 	 * Strip leading spaces:
@@ -190,9 +225,30 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 			line_ip = -1;
 	}
 
-	start = map__rip_2objdump(he->map, sym->start);
-
 	if (line_ip != -1) {
+		u64 start = map__rip_2objdump(he->map, sym->start);
+		offset = line_ip - start;
+	}
+
+	objdump_line = objdump_line__new(offset, line);
+	if (objdump_line == NULL) {
+		free(line);
+		return -1;
+	}
+	objdump__add_line(head, objdump_line);
+
+	return 0;
+}
+
+static int objdump_line__print(struct objdump_line *self,
+			       struct list_head *head,
+			       struct hist_entry *he, u64 len)
+{
+	struct symbol *sym = he->sym;
+	static const char *prev_line;
+	static const char *prev_color;
+
+	if (self->offset != -1) {
 		const char *path = NULL;
 		unsigned int hits = 0;
 		double percent = 0.0;
@@ -200,15 +256,22 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 		struct sym_priv *priv = symbol__priv(sym);
 		struct sym_ext *sym_ext = priv->ext;
 		struct sym_hist *h = priv->hist;
+		s64 offset = self->offset;
+		struct objdump_line *next = objdump__get_next_ip_line(head, self);
+
+		while (offset < (s64)len &&
+		       (next == NULL || offset < next->offset)) {
+			if (sym_ext) {
+				if (path == NULL)
+					path = sym_ext[offset].path;
+				percent += sym_ext[offset].percent;
+			} else
+				hits += h->ip[offset];
+
+			++offset;
+		}
 
-		offset = line_ip - start;
-		if (offset < len)
-			hits = h->ip[offset];
-
-		if (offset < len && sym_ext) {
-			path = sym_ext[offset].path;
-			percent = sym_ext[offset].percent;
-		} else if (h->sum)
+		if (sym_ext == NULL && h->sum)
 			percent = 100.0 * hits / h->sum;
 
 		color = get_percent_color(percent);
@@ -229,12 +292,12 @@ static int parse_line(FILE *file, struct hist_entry *he, u64 len)
 
 		color_fprintf(stdout, color, " %7.2f", percent);
 		printf(" :	");
-		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", line);
+		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", self->line);
 	} else {
-		if (!*line)
+		if (!*self->line)
 			printf("         :\n");
 		else
-			printf("         :	%s\n", line);
+			printf("         :	%s\n", self->line);
 	}
 
 	return 0;
@@ -360,6 +423,20 @@ static void print_summary(const char *filename)
 	}
 }
 
+static void hist_entry__print_hits(struct hist_entry *self)
+{
+	struct symbol *sym = self->sym;
+	struct sym_priv *priv = symbol__priv(sym);
+	struct sym_hist *h = priv->hist;
+	u64 len = sym->end - sym->start, offset;
+
+	for (offset = 0; offset < len; ++offset)
+		if (h->ip[offset] != 0)
+			printf("%*Lx: %Lu\n", BITS_PER_LONG / 2,
+			       sym->start + offset, h->ip[offset]);
+	printf("%*s: %Lu\n", BITS_PER_LONG / 2, "h->sum", h->sum);
+}
+
 static void annotate_sym(struct hist_entry *he)
 {
 	struct map *map = he->map;
@@ -369,6 +446,8 @@ static void annotate_sym(struct hist_entry *he)
 	u64 len;
 	char command[PATH_MAX*2];
 	FILE *file;
+	LIST_HEAD(head);
+	struct objdump_line *pos, *n;
 
 	if (!filename)
 		return;
@@ -410,11 +489,21 @@ static void annotate_sym(struct hist_entry *he)
 		return;
 
 	while (!feof(file)) {
-		if (parse_line(file, he, len) < 0)
+		if (parse_line(file, he, &head) < 0)
 			break;
 	}
 
 	pclose(file);
+
+	if (verbose)
+		hist_entry__print_hits(he);
+
+	list_for_each_entry_safe(pos, n, &head, node) {
+		objdump_line__print(pos, &head, he, len);
+		list_del(&pos->node);
+		objdump_line__free(pos);
+	}
+
 	if (print_line)
 		free_source_line(he, len);
 }
-- 
1.5.5.1

