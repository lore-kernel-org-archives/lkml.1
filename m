Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGVSg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGVSg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 14:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZGVSg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 14:36:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:45025 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751665AbZGVSgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 14:36:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19bxgwG6UNbJiYmtOsSQnNDIYwhMvJXmTf9hSiAlk
	DVRDA+RazOO3Xx
Subject: Re: [patch] perf_counter tools: resurrect perf top annotation in a
 simple interactive form
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1248281171.5738.5.camel@marge.simson.net>
References: <1248090981.18702.14.camel@marge.simson.net>
	 <1248274190.27058.1530.camel@twins>
	 <1248281171.5738.5.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 20:36:03 +0200
Message-Id: <1248287763.8266.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 18:46 +0200, Mike Galbraith wrote:
> On Wed, 2009-07-22 at 16:49 +0200, Peter Zijlstra wrote:
> > On Mon, 2009-07-20 at 13:56 +0200, Mike Galbraith wrote:
> > > Comments/suggestions/clue_bats welcome.
> > > 
> > > perf_counter tools: resurrect perf top annotation in a simple interactive form.
> > > 
> > > This patch allows the user to select any symbol in kernel space for source level
> > > annotation on the fly, switch between event counters and alter display variables.
> > > When symbol details are being displayed, stopping annotation reverts to normal.
> > > 
> > > This doesn't make top _fully_ interactive, you can only select among the events
> > > you started top with, ie it doesn't stop/start event counters etc.
> > > 
> > > known keys:
> > >         [d]     select display delay.
> > >         [e]     select display entries (lines).
> > >         [E]     select annotation event counter.
> > >         [f]     select normal display count filter.
> > >         [F]     select annotation display count filter (percentage).
> > >         [qQ]    quit.
> > >         [s]     select annotation symbol and start annotation.
> > >         [S]     stop annotation, revert to normal display.
> > >         [z]     toggle event count zeroing.
> > 
> > ok, so I tried this, but the screen updates overwrite this input
> > screen before I can read it ;-)
> 
> That's not an input screen, it's a legend shown if you poke an unknown
> key.  Poking a known key prompts for input.

Hm, that is lame though, so updated patch below.  If an unknown key is
poked, display known keys, and wait for the user to poke one that _is_
known.  If you know the keys, you don't have to look at annoying legend,
if you forget, tap space or whatever.

	-Mike


perf_counter tools: resurrect perf top annotation in a simple interactive form.

This patch allows the user to select any symbol in kernel space for source level
annotation on the fly, switch between event counters and alter display variables.
When symbol details are being displayed, stopping annotation reverts to normal.

known keys:
        [d]     select display delay.
        [e]     select display entries (lines).
        [E]     select annotation event counter.
        [f]     select normal display count filter.
        [F]     select annotation display count filter (percentage).
        [qQ]    quit.
        [s]     select annotation symbol and start annotation.
        [S]     stop annotation, revert to normal display.
        [z]     toggle event count zeroing.

Sample:
------------------------------------------------------------------------------
   PerfTop:   16719 irqs/sec  kernel:78.7% [cache-misses/cache-references/instructions/cycles],  (all, 4 CPUs)
------------------------------------------------------------------------------

Showing cache-misses for e1000_clean_rx_irq
  Events  Pcnt (>=3%)
       0  0.0%                  /* adjust length to remove Ethernet CRC */
       0  0.0%                  if (!(adapter->flags2 & FLAG2_CRC_STRIPPING))
       0  0.0%                          length -= 4;
     436  5.0%      f039:       41 f6 84 24 5c 29 00    testb  $0x1,0x295c(%r12)
       0  0.0%      f089:       8b 4d 84                mov    -0x7c(%rbp),%ecx
       0  0.0%      f08c:       48 83 ef 02             sub    $0x2,%rdi
       0  0.0%      f090:       48 83 ee 02             sub    $0x2,%rsi
     811  9.3%      f094:       f3 a4                   rep movsb %ds:(%rsi),%es:(%rdi)
       0  0.0%
       0  0.0%          while (rx_desc->status & E1000_RXD_STAT_DD) {
       0  0.0%      f114:       41 f6 47 0c 01          testb  $0x1,0xc(%r15)
    7226 82.6%      f119:       0f 85 24 fe ff ff       jne    ef43 <e1000_clean_rx_irq+0x84>

Available events:
        0 cache-misses
        1 cache-references
        2 instructions
        3 cycles
Enter details event counter: 2
------------------------------------------------------------------------------
   PerfTop:   15035 irqs/sec  kernel:79.0% [cache-misses/cache-references/instructions/cycles],  (all, 4 CPUs)
------------------------------------------------------------------------------

Showing instructions for e1000_clean_rx_irq
  Events  Pcnt (>=3%)
       0  0.0%                                 int *work_done, int work_to_do)
       0  0.0%  {
     175  0.9%      eebf:       55                      push   %rbp
    1898  9.8%      eec0:       48 89 e5                mov    %rsp,%rbp
       0  0.0%
       0  0.0%          i = rx_ring->next_to_clean;
     140  0.7%      ef0a:       0f b7 41 1a             movzwl 0x1a(%rcx),%eax
     670  3.4%      ef0e:       89 45 ac                mov    %eax,-0x54(%rbp)
       0  0.0%  {
       0  0.0%          memcpy(skb->data + offset, from, len);
      91  0.5%      f07b:       49 8b b6 e8 00 00 00    mov    0xe8(%r14),%rsi
    1153  5.9%      f082:       48 8b b8 e8 00 00 00    mov    0xe8(%rax),%rdi
      42  0.2%      f089:       8b 4d 84                mov    -0x7c(%rbp),%ecx
      14  0.1%      f08c:       48 83 ef 02             sub    $0x2,%rdi
       0  0.0%      f090:       48 83 ee 02             sub    $0x2,%rsi
    1618  8.3%      f094:       f3 a4                   rep movsb %ds:(%rsi),%es:(%rdi)
       0  0.0%
       0  0.0%                  /* return some buffers to hardware, one at a time is too slow */
       0  0.0%                  if (cleaned_count >= E1000_RX_BUFFER_WRITE) {
     867  4.5%      f0e7:       83 7d b0 0f             cmpl   $0xf,-0x50(%rbp)
       0  0.0%
       0  0.0%          while (rx_desc->status & E1000_RXD_STAT_DD) {
      37  0.2%      f114:       41 f6 47 0c 01          testb  $0x1,0xc(%r15)
    4047 20.8%      f119:       0f 85 24 fe ff ff       jne    ef43 <e1000_clean_rx_irq+0x84>


Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/builtin-top.c |  494 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 455 insertions(+), 39 deletions(-)

Index: linux-2.6/tools/perf/builtin-top.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-top.c
+++ linux-2.6/tools/perf/builtin-top.c
@@ -31,6 +31,8 @@
 #include <fcntl.h>
 
 #include <stdio.h>
+#include <termios.h>
+#include <unistd.h>
 
 #include <errno.h>
 #include <time.h>
@@ -54,7 +56,7 @@ static int			system_wide			=  0;
 
 static int			default_interval		= 100000;
 
-static u64			count_filter			=  5;
+static int			count_filter			=  5;
 static int			print_entries			= 15;
 
 static int			target_pid			= -1;
@@ -68,15 +70,27 @@ static int			freq				=  0;
 static int			verbose				=  0;
 static char			*vmlinux			=  NULL;
 
-static char			*sym_filter;
-static unsigned long		filter_start;
-static unsigned long		filter_end;
-
 static int			delay_secs			=  2;
 static int			zero;
 static int			dump_symtab;
 
 /*
+ * Source
+ */
+
+struct source_line {
+	u64			eip;
+	unsigned long		count[MAX_COUNTERS];
+	char			*line;
+	struct source_line	*next;
+};
+
+static char			*sym_filter			=  NULL;
+struct sym_entry		*sym_filter_entry		=  NULL;
+static int			sym_pcnt_filter			=  5;
+static int			sym_counter			=  0;
+
+/*
  * Symbols
  */
 
@@ -90,9 +104,237 @@ struct sym_entry {
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
+	struct source_line	*source;
+	struct source_line	*lines;
+	struct source_line	**lines_tail;
+	pthread_mutex_t		source_lock;
 };
 
-struct sym_entry		*sym_filter_entry;
+/*
+ * Source functions
+ */
+
+static void parse_source(struct sym_entry *syme)
+{
+	struct symbol *sym;
+	struct module *module;
+	struct section *section = NULL;
+	FILE *file;
+	char command[PATH_MAX*2], *path = vmlinux;
+	u64 start, end, len;
+
+	if (!syme)
+		return;
+
+	if (syme->lines) {
+		pthread_mutex_lock(&syme->source_lock);
+		goto out_assign;
+	}
+
+	sym = (struct symbol *)(syme + 1);
+	module = sym->module;
+
+	if (module)
+		path = module->path;
+	if (!path)
+		return;
+
+	start = sym->obj_start;
+	if (!start)
+		start = sym->start;
+
+	if (module) {
+		section = module->sections->find_section(module->sections, ".text");
+		if (section)
+			start -= section->vma;
+	}
+
+	end = start + sym->end - sym->start + 1;
+	len = sym->end - sym->start;
+
+	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", start, end, path);
+
+	file = popen(command, "r");
+	if (!file)
+		return;
+
+	pthread_mutex_lock(&syme->source_lock);
+	syme->lines_tail = &syme->lines;
+	while (!feof(file)) {
+		struct source_line *src;
+		size_t dummy = 0;
+		char *c;
+
+		src = malloc(sizeof(struct source_line));
+		assert(src != NULL);
+		memset(src, 0, sizeof(struct source_line));
+
+		if (getline(&src->line, &dummy, file) < 0)
+			break;
+		if (!src->line)
+			break;
+
+		c = strchr(src->line, '\n');
+		if (c)
+			*c = 0;
+
+		src->next = NULL;
+		*syme->lines_tail = src;
+		syme->lines_tail = &src->next;
+
+		if (strlen(src->line)>8 && src->line[8] == ':') {
+			src->eip = strtoull(src->line, NULL, 16);
+			if (section)
+				src->eip += section->vma;
+		}
+		if (strlen(src->line)>8 && src->line[16] == ':') {
+			src->eip = strtoull(src->line, NULL, 16);
+			if (section)
+				src->eip += section->vma;
+		}
+	}
+	pclose(file);
+out_assign:
+	sym_filter_entry = syme;
+	pthread_mutex_unlock(&syme->source_lock);
+}
+
+static void __zero_source_counters(struct sym_entry *syme)
+{
+	int i;
+	struct source_line *line;
+
+	line = syme->lines;
+	while (line) {
+		for (i = 0; i < nr_counters; i++)
+			line->count[i] = 0;
+		line = line->next;
+	}
+}
+
+static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
+{
+	struct source_line *line;
+
+	if (syme != sym_filter_entry)
+		return;
+
+	if (pthread_mutex_trylock(&syme->source_lock))
+		return;
+
+	if (!syme->source)
+		goto out_unlock;
+
+	for (line = syme->lines; line; line = line->next) {
+		if (line->eip == ip) {
+			line->count[counter]++;
+			break;
+		}
+		if (line->eip > ip)
+			break;
+	}
+out_unlock:
+	pthread_mutex_unlock(&syme->source_lock);
+}
+
+static void lookup_sym_source(struct sym_entry *syme)
+{
+	struct symbol *symbol = (struct symbol *)(syme + 1);
+	struct source_line *line;
+	char pattern[PATH_MAX];
+	char *idx;
+
+	sprintf(pattern, "<%s>:", symbol->name);
+
+	if (symbol->module) {
+		idx = strstr(pattern, "\t");
+		if (idx)
+			*idx = 0;
+	}
+
+	pthread_mutex_lock(&syme->source_lock);
+	for (line = syme->lines; line; line = line->next) {
+		if (strstr(line->line, pattern)) {
+			syme->source = line;
+			break;
+		}
+	}
+	pthread_mutex_unlock(&syme->source_lock);
+}
+
+static void show_lines(struct source_line *queue, int count, int total)
+{
+	int i;
+	struct source_line *line;
+
+	line = queue;
+	for (i = 0; i < count; i++) {
+		float pcnt = 100.0*(float)line->count[sym_counter]/(float)total;
+
+		printf("%8li %4.1f%%\t%s\n", line->count[sym_counter], pcnt, line->line);
+		line = line->next;
+	}
+}
+
+#define TRACE_COUNT     3
+
+static void show_details(struct sym_entry *syme)
+{
+	struct symbol *symbol;
+	struct source_line *line;
+	struct source_line *line_queue = NULL;
+	int displayed = 0;
+	int line_queue_count = 0, total = 0, more = 0;
+
+	if (!syme)
+		return;
+
+	if (!syme->source)
+		lookup_sym_source(syme);
+
+	if (!syme->source)
+		return;
+
+	symbol = (struct symbol *)(syme + 1);
+	printf("Showing %s for %s\n", event_name(sym_counter), symbol->name);
+	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
+
+	pthread_mutex_lock(&syme->source_lock);
+	line = syme->source;
+	while (line) {
+		total += line->count[sym_counter];
+		line = line->next;
+	}
+
+	line = syme->source;
+	while (line) {
+		float pcnt = 0.0;
+
+		if (!line_queue_count)
+			line_queue = line;
+		line_queue_count++;
+
+		if (line->count[sym_counter])
+			pcnt = 100.0 * line->count[sym_counter] / (float)total;
+		if (pcnt >= (float)sym_pcnt_filter) {
+			if (displayed <= print_entries)
+				show_lines(line_queue, line_queue_count, total);
+			else more++;
+			displayed += line_queue_count;
+			line_queue_count = 0;
+			line_queue = NULL;
+		} else if (line_queue_count > TRACE_COUNT) {
+			line_queue = line_queue->next;
+			line_queue_count--;
+		}
+
+		line->count[sym_counter] = zero ? 0 : line->count[sym_counter] * 7 / 8;
+		line = line->next;
+	}
+	pthread_mutex_unlock(&syme->source_lock);
+	if (more)
+		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
+}
 
 struct dso			*kernel_dso;
 
@@ -227,6 +469,11 @@ static void print_sym_table(void)
 
 	printf("------------------------------------------------------------------------------\n\n");
 
+	if (sym_filter_entry) {
+		show_details(sym_filter_entry);
+		return;
+	}
+
 	if (nr_counters == 1)
 		printf("             samples    pcnt");
 	else
@@ -241,7 +488,7 @@ static void print_sym_table(void)
 		struct symbol *sym = (struct symbol *)(syme + 1);
 		double pcnt;
 
-		if (++printed > print_entries || syme->snap_count < count_filter)
+		if (++printed > print_entries || (int)syme->snap_count < count_filter)
 			continue;
 
 		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
@@ -260,19 +507,208 @@ static void print_sym_table(void)
 	}
 }
 
+static void prompt_integer(int *target, const char *msg)
+{
+	char *buf = malloc(0), *p;
+	size_t dummy = 0;
+	int tmp;
+
+	fprintf(stdout, "\n%s: ", msg);
+	if (getline(&buf, &dummy, stdin) < 0)
+		return;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = 0;
+
+	p = buf;
+	while(*p) {
+		if (!isdigit(*p))
+			goto out_free;
+		p++;
+	}
+	tmp = strtoul(buf, NULL, 10);
+	*target = tmp;
+out_free:
+	free(buf);
+}
+
+static void prompt_percent(int *target, const char *msg)
+{
+	int tmp = 0;
+
+	prompt_integer(&tmp, msg);
+	if (tmp >= 0 && tmp <= 100)
+		*target = tmp;
+}
+
+static void prompt_symbol(struct sym_entry **target, const char *msg)
+{
+	char *buf = malloc(0), *p;
+	struct sym_entry *syme = *target, *n, *found = NULL;
+	size_t dummy = 0;
+
+	/* zero counters of active symbol */
+	if (syme) {
+		pthread_mutex_lock(&syme->source_lock);
+		__zero_source_counters(syme);
+		*target = NULL;
+		pthread_mutex_unlock(&syme->source_lock);
+	}
+
+	fprintf(stdout, "\n%s: ", msg);
+	if (getline(&buf, &dummy, stdin) < 0)
+		goto out_free;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = 0;
+
+	pthread_mutex_lock(&active_symbols_lock);
+	syme = list_entry(active_symbols.next, struct sym_entry, node);
+	pthread_mutex_unlock(&active_symbols_lock);
+
+	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
+		struct symbol *sym = (struct symbol *)(syme + 1);
+
+		if (!strcmp(buf, sym->name)) {
+			found = syme;
+			break;
+		}
+	}
+
+	if (!found) {
+		fprintf(stderr, "Sorry, %s is not active.\n", sym_filter);
+		sleep(1);
+		return;
+	} else
+		parse_source(found);
+
+out_free:
+	free(buf);
+}
+
+static void print_known_keys(void)
+{
+	fprintf(stdout, "\nknown keys:\n");
+	fprintf(stdout, "\t[d]     select display delay.\n");
+	fprintf(stdout, "\t[e]     select display entries (lines).\n");
+	fprintf(stdout, "\t[E]     select annotation event counter.\n");
+	fprintf(stdout, "\t[f]     select normal display count filter.\n");
+	fprintf(stdout, "\t[F]     select annotation display count filter (percentage).\n");
+	fprintf(stdout, "\t[qQ]    quit.\n");
+	fprintf(stdout, "\t[s]     select annotation symbol and start annotation.\n");
+	fprintf(stdout, "\t[S]     stop annotation, revert to normal display.\n");
+	fprintf(stdout, "\t[z]     toggle event count zeroing.\n");
+}
+
+static void handle_keypress(int c)
+{
+	int once = 0;
+repeat:
+	switch (c) {
+		case 'd':
+			prompt_integer(&delay_secs, "Enter display delay");
+			break;
+		case 'e':
+			prompt_integer(&print_entries, "Enter display entries (lines)");
+			break;
+		case 'E':
+			if (nr_counters > 1) {
+				int i;
+
+				fprintf(stderr, "\nAvailable events:");
+				for (i = 0; i < nr_counters; i++)
+					fprintf(stderr, "\n\t%d %s", i, event_name(i));
+
+				prompt_integer(&sym_counter, "Enter details event counter");
+
+				if (sym_counter >= nr_counters) {
+					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(0));
+					sym_counter = 0;
+					sleep(1);
+				}
+			} else sym_counter = 0;
+			break;
+		case 'f':
+			prompt_integer(&count_filter, "Enter display event count filter");
+			break;
+		case 'F':
+			prompt_percent(&sym_pcnt_filter, "Enter details display event filter (percent)");
+			break;
+		case 'q':
+		case 'Q':
+			printf("exiting.\n");
+			exit(0);
+		case 's':
+			prompt_symbol(&sym_filter_entry, "Enter details symbol");
+			break;
+		case 'S':
+			if (!sym_filter_entry)
+				break;
+			else {
+				struct sym_entry *syme = sym_filter_entry;
+
+				pthread_mutex_lock(&syme->source_lock);
+				sym_filter_entry = NULL;
+				__zero_source_counters(syme);
+				pthread_mutex_unlock(&syme->source_lock);
+			}
+			break;
+		case 'z':
+			zero = ~zero;
+			break;
+		default: {
+			struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
+			struct termios tc, save;
+
+			if (!once) {
+				print_known_keys();
+				once++;
+			}
+
+			tcgetattr(0, &save);
+			tc = save;
+			tc.c_lflag &= ~(ICANON | ECHO);
+			tc.c_cc[VMIN] = 0;
+			tc.c_cc[VTIME] = 0;
+			tcsetattr(0, TCSANOW, &tc);
+
+			poll(&stdin_poll, 1, -1);
+			c = getc(stdin);
+
+			tcsetattr(0, TCSAFLUSH, &save);
+			goto repeat;
+		}
+	}
+}
+
 static void *display_thread(void *arg __used)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-	int delay_msecs = delay_secs * 1000;
+	struct termios tc, save;
+	int delay_msecs, c;
 
-	printf("PerfTop refresh period: %d seconds\n", delay_secs);
+	tcgetattr(0, &save);
+	tc = save;
+	tc.c_lflag &= ~(ICANON | ECHO);
+	tc.c_cc[VMIN] = 0;
+	tc.c_cc[VTIME] = 0;
+repeat:
+	delay_msecs = delay_secs * 1000;
+	tcsetattr(0, TCSANOW, &tc);
+	/* trash return*/
+	getc(stdin);
 
 	do {
 		print_sym_table();
 	} while (!poll(&stdin_poll, 1, delay_msecs) == 1);
 
-	printf("key pressed - exiting.\n");
-	exit(0);
+	c = getc(stdin);
+	tcsetattr(0, TCSAFLUSH, &save);
+
+	handle_keypress(c);
+	goto repeat;
 
 	return NULL;
 }
@@ -291,7 +727,6 @@ static const char *skip_symbols[] = {
 
 static int symbol_filter(struct dso *self, struct symbol *sym)
 {
-	static int filter_match;
 	struct sym_entry *syme;
 	const char *name = sym->name;
 	int i;
@@ -313,6 +748,10 @@ static int symbol_filter(struct dso *sel
 		return 1;
 
 	syme = dso__sym_priv(self, sym);
+	pthread_mutex_init(&syme->source_lock, NULL);
+	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter))
+		sym_filter_entry = syme;
+
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
 			syme->skip = 1;
@@ -320,29 +759,6 @@ static int symbol_filter(struct dso *sel
 		}
 	}
 
-	if (filter_match == 1) {
-		filter_end = sym->start;
-		filter_match = -1;
-		if (filter_end - filter_start > 10000) {
-			fprintf(stderr,
-				"hm, too large filter symbol <%s> - skipping.\n",
-				sym_filter);
-			fprintf(stderr, "symbol filter start: %016lx\n",
-				filter_start);
-			fprintf(stderr, "                end: %016lx\n",
-				filter_end);
-			filter_end = filter_start = 0;
-			sym_filter = NULL;
-			sleep(1);
-		}
-	}
-
-	if (filter_match == 0 && sym_filter && !strcmp(name, sym_filter)) {
-		filter_match = 1;
-		filter_start = sym->start;
-	}
-
-
 	return 0;
 }
 
@@ -378,8 +794,6 @@ out_delete_dso:
 	return -1;
 }
 
-#define TRACE_COUNT     3
-
 /*
  * Binary search in the histogram table and record the hit:
  */
@@ -392,6 +806,7 @@ static void record_ip(u64 ip, int counte
 
 		if (!syme->skip) {
 			syme->count[counter]++;
+			record_precise_ip(syme, counter, ip);
 			pthread_mutex_lock(&active_symbols_lock);
 			if (list_empty(&syme->node) || !syme->node.next)
 				__list_insert_active_sym(syme);
@@ -685,8 +1100,8 @@ static const struct option options[] = {
 		    "only display functions with more events than this"),
 	OPT_BOOLEAN('g', "group", &group,
 			    "put the counters into a counter group"),
-	OPT_STRING('s', "sym-filter", &sym_filter, "pattern",
-		    "only display symbols matchig this pattern"),
+	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
+		    "symbol to annotate - requires -k option"),
 	OPT_BOOLEAN('z', "zero", &zero,
 		    "zero history across updates"),
 	OPT_INTEGER('F', "freq", &freq,
@@ -729,6 +1144,7 @@ int cmd_top(int argc, const char **argv,
 		delay_secs = 1;
 
 	parse_symbols();
+	parse_source(sym_filter_entry);
 
 	/*
 	 * Fill in the ones not specifically initialized via -c:


