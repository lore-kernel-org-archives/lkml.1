Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZHPMq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZHPMq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 08:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbZHPMq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 08:46:56 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:59348 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbZHPMqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 08:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iBeDdgx2ACCbEdBUQYX2jxrMYZy5wRZBmDmgulT3ZFgaJ+9QwXbViwIfMFmgDpxYxm
         dvH9esWer64KfJTWc1jhQoFtzASyxNAF+OxAPMSxeyz/g8GYDCv6GPQiEm99UNMjzfU2
         8dCEG1/BriUu8WX4iFCm/I8Xl4LR2G3vEstIU=
Date: Sun, 16 Aug 2009 14:46:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf: Enable more compiler warnings
Message-ID: <20090816124641.GA6031@nowhere>
References: <tip-83a0944fa919fb2ebcfc1f8933d86e437b597ca6@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-83a0944fa919fb2ebcfc1f8933d86e437b597ca6@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 08:57:54AM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  83a0944fa919fb2ebcfc1f8933d86e437b597ca6
> Gitweb:     http://git.kernel.org/tip/83a0944fa919fb2ebcfc1f8933d86e437b597ca6
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sat, 15 Aug 2009 12:26:57 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 16 Aug 2009 10:47:47 +0200
> 
> perf: Enable more compiler warnings
> 
> Related to a shadowed variable bug fix Valdis Kletnieks noticed
> that perf does not get built with -Wshadow, which could have
> helped us avoid the bug.
> 
> So enable -Wshadow and also enable the following warnings on
> perf builds, in addition to the already enabled -Wall -Wextra
> -std=gnu99 warnings:
> 
>  -Wcast-align
>  -Wformat=2
>  -Wshadow
>  -Winit-self
>  -Wpacked
>  -Wredundant-decls
>  -Wstack-protector
>  -Wstrict-aliasing=3
>  -Wswitch-default
>  -Wswitch-enum



This one looks like more a pain than something useful.

I have this code in perf trace:

static int event_item_type(enum event_type type)
{
	switch (type) {
	case EVENT_ITEM:
	case EVENT_DQUOTE:
	case EVENT_SQUOTE:
		return 1;
	default:
		return 0;
	}
}

Which results in:

util/trace-event-parse.c: In function ‘event_item_type’:
util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_ERROR’ not handled in switch
util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_NONE’ not handled in switch
util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_SPACE’ not handled in switch
util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_NEWLINE’ not handled in switch
util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_OP’ not handled in switch
util/trace-event-parse.c:377: erreur: enumeration value ‘EVENT_DELIM’ not handled in switch

The default case already handles these and I guess we don't want workarounds like:

static int event_item_type(enum event_type type)
{
        switch (type) {
        case EVENT_ITEM:
        case EVENT_DQUOTE:
        case EVENT_SQUOTE:
                return 1;
	case EVENT_ERROR:
	case EVENT_NONE:
	case EVENT_SPACE:
	case EVENT_NEWLINE:
	case EVENT_OP:
	case EVENT_DELIM:
        default:
                return 0;
        }
}


Right? :-)

This warning might be useful for *very* specific cases, but not here IMO.

But -Wswitch-default is indeed useful.

Frederic.


>  -Wno-system-headers
>  -Wundef
>  -Wvolatile-register-var
>  -Wwrite-strings
>  -Wbad-function-cast
>  -Wmissing-declarations
>  -Wmissing-prototypes
>  -Wnested-externs
>  -Wold-style-definition
>  -Wstrict-prototypes
>  -Wdeclaration-after-statement
> 
> And change/fix the perf code to build cleanly under GCC 4.3.2.
> 
> The list of warnings enablement is rather arbitrary: it's based
> on my (quick) reading of the GCC manpages and trying them on
> perf.
> 
> I categorized the warnings based on individually enabling them
> and looking whether they trigger something in the perf build.
> If i liked those warnings (i.e. if they trigger for something
> that arguably could be improved) i enabled the warning.
> 
> If the warnings seemed to come from language laywers spamming
> the build with tons of nuisance warnings i generally kept them
> off. Most of the sign conversion related warnings were in
> this category. (A second patch enabling some of the sign
> warnings might be welcome - sign bugs can be nasty.)
> 
> I also kept warnings that seem to make sense from their manpage
> description and which produced no actual warnings on our code
> base. These warnings might still be turned off if they end up
> being a nuisance.
> 
> I also left out a few warnings that are not supported in older
> compilers.
> 
> [ Note that these changes might break the build on older
>   compilers i did not test, or on non-x86 architectures that
>   produce different warnings, so more testing would be welcome. ]
> 
> Reported-by: Valdis.Kletnieks@vt.edu
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  tools/perf/Makefile             |    7 ++-
>  tools/perf/builtin-annotate.c   |   32 ++++++------
>  tools/perf/builtin-help.c       |    1 +
>  tools/perf/builtin-report.c     |   38 ++++++++-------
>  tools/perf/builtin-top.c        |   23 ++++++---
>  tools/perf/util/abspath.c       |    3 +-
>  tools/perf/util/cache.h         |    1 -
>  tools/perf/util/callchain.c     |    2 +
>  tools/perf/util/color.c         |    6 +-
>  tools/perf/util/color.h         |    2 +-
>  tools/perf/util/config.c        |   22 +++++---
>  tools/perf/util/exec_cmd.c      |    1 -
>  tools/perf/util/module.c        |    4 +-
>  tools/perf/util/parse-events.c  |   26 +++++-----
>  tools/perf/util/parse-events.h  |    4 +-
>  tools/perf/util/parse-options.c |   22 ++++++++
>  tools/perf/util/path.c          |   25 ++++++----
>  tools/perf/util/run-command.c   |    6 +-
>  tools/perf/util/symbol.c        |  104 +++++++++++++++++++-------------------
>  tools/perf/util/symbol.h        |    4 +-
>  tools/perf/util/values.c        |    7 +--
>  tools/perf/util/values.h        |    2 +-
>  22 files changed, 194 insertions(+), 148 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 0056405..8608c06 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -166,7 +166,12 @@ endif
>  
>  # CFLAGS and LDFLAGS are for the users to override from the command line.
>  
> -CFLAGS = $(M64) -ggdb3 -Wall -Wextra -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement -Werror -O6
> +#
> +# Include saner warnings here, which can catch bugs:
> +#
> +EXTRA_WARNINGS = -Wcast-align -Wformat=2 -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
> +
> +CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 $(EXTRA_WARNINGS)
>  LDFLAGS = -lpthread -lrt -lelf -lm
>  ALL_CFLAGS = $(CFLAGS)
>  ALL_LDFLAGS = $(LDFLAGS)
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 3bedaa5..32ff983 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -81,7 +81,7 @@ struct hist_entry {
>  struct sort_entry {
>  	struct list_head list;
>  
> -	char *header;
> +	const char *header;
>  
>  	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
>  	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
> @@ -225,7 +225,7 @@ static struct sort_entry sort_sym = {
>  static int sort__need_collapse = 0;
>  
>  struct sort_dimension {
> -	char			*name;
> +	const char		*name;
>  	struct sort_entry	*entry;
>  	int			taken;
>  };
> @@ -723,7 +723,7 @@ parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
>  		const char *path = NULL;
>  		unsigned int hits = 0;
>  		double percent = 0.0;
> -		char *color;
> +		const char *color;
>  		struct sym_ext *sym_ext = sym->priv;
>  
>  		offset = line_ip - start;
> @@ -805,7 +805,7 @@ static void free_source_line(struct symbol *sym, int len)
>  
>  /* Get the filename:line for the colored entries */
>  static void
> -get_source_line(struct symbol *sym, u64 start, int len, char *filename)
> +get_source_line(struct symbol *sym, u64 start, int len, const char *filename)
>  {
>  	int i;
>  	char cmd[PATH_MAX * 2];
> @@ -851,7 +851,7 @@ get_source_line(struct symbol *sym, u64 start, int len, char *filename)
>  	}
>  }
>  
> -static void print_summary(char *filename)
> +static void print_summary(const char *filename)
>  {
>  	struct sym_ext *sym_ext;
>  	struct rb_node *node;
> @@ -867,7 +867,7 @@ static void print_summary(char *filename)
>  	node = rb_first(&root_sym_ext);
>  	while (node) {
>  		double percent;
> -		char *color;
> +		const char *color;
>  		char *path;
>  
>  		sym_ext = rb_entry(node, struct sym_ext, node);
> @@ -882,7 +882,7 @@ static void print_summary(char *filename)
>  
>  static void annotate_sym(struct dso *dso, struct symbol *sym)
>  {
> -	char *filename = dso->name, *d_filename;
> +	const char *filename = dso->name, *d_filename;
>  	u64 start, end, len;
>  	char command[PATH_MAX*2];
>  	FILE *file;
> @@ -892,7 +892,7 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
>  	if (sym->module)
>  		filename = sym->module->path;
>  	else if (dso == kernel_dso)
> -		filename = vmlinux;
> +		filename = vmlinux_name;
>  
>  	start = sym->obj_start;
>  	if (!start)
> @@ -964,7 +964,7 @@ static int __cmd_annotate(void)
>  	int ret, rc = EXIT_FAILURE;
>  	unsigned long offset = 0;
>  	unsigned long head = 0;
> -	struct stat stat;
> +	struct stat input_stat;
>  	event_t *event;
>  	uint32_t size;
>  	char *buf;
> @@ -977,13 +977,13 @@ static int __cmd_annotate(void)
>  		exit(-1);
>  	}
>  
> -	ret = fstat(input, &stat);
> +	ret = fstat(input, &input_stat);
>  	if (ret < 0) {
>  		perror("failed to stat file");
>  		exit(-1);
>  	}
>  
> -	if (!stat.st_size) {
> +	if (!input_stat.st_size) {
>  		fprintf(stderr, "zero-sized file, nothing to do!\n");
>  		exit(0);
>  	}
> @@ -1010,10 +1010,10 @@ more:
>  
>  	if (head + event->header.size >= page_size * mmap_window) {
>  		unsigned long shift = page_size * (head / page_size);
> -		int ret;
> +		int munmap_ret;
>  
> -		ret = munmap(buf, page_size * mmap_window);
> -		assert(ret == 0);
> +		munmap_ret = munmap(buf, page_size * mmap_window);
> +		assert(munmap_ret == 0);
>  
>  		offset += shift;
>  		head -= shift;
> @@ -1049,7 +1049,7 @@ more:
>  
>  	head += size;
>  
> -	if (offset + head < (unsigned long)stat.st_size)
> +	if (offset + head < (unsigned long)input_stat.st_size)
>  		goto more;
>  
>  	rc = EXIT_SUCCESS;
> @@ -1092,7 +1092,7 @@ static const struct option options[] = {
>  		    "be more verbose (show symbol address, etc)"),
>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>  		    "dump raw trace in ASCII"),
> -	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
> +	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
>  	OPT_BOOLEAN('m', "modules", &modules,
>  		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
>  	OPT_BOOLEAN('l', "print-line", &print_line,
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 2599d86..4fb8734 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -456,6 +456,7 @@ int cmd_help(int argc, const char **argv, const char *prefix __used)
>  		break;
>  	case HELP_FORMAT_WEB:
>  		show_html_page(argv[0]);
> +	default:
>  		break;
>  	}
>  
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 298f26b..3b9d24d 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -97,6 +97,7 @@ static int repsep_fprintf(FILE *fp, const char *fmt, ...)
>  		n = vasprintf(&bf, fmt, ap);
>  		if (n > 0) {
>  			char *sep = bf;
> +
>  			while (1) {
>  				sep = strchr(sep, *field_sep);
>  				if (sep == NULL)
> @@ -144,7 +145,7 @@ struct hist_entry {
>  struct sort_entry {
>  	struct list_head list;
>  
> -	char *header;
> +	const char *header;
>  
>  	int64_t (*cmp)(struct hist_entry *, struct hist_entry *);
>  	int64_t (*collapse)(struct hist_entry *, struct hist_entry *);
> @@ -328,7 +329,7 @@ static int sort__need_collapse = 0;
>  static int sort__has_parent = 0;
>  
>  struct sort_dimension {
> -	char			*name;
> +	const char		*name;
>  	struct sort_entry	*entry;
>  	int			taken;
>  };
> @@ -343,7 +344,7 @@ static struct sort_dimension sort_dimensions[] = {
>  
>  static LIST_HEAD(hist_entry__sort_list);
>  
> -static int sort_dimension__add(char *tok)
> +static int sort_dimension__add(const char *tok)
>  {
>  	unsigned int i;
>  
> @@ -602,6 +603,7 @@ hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
>  		case CHAIN_GRAPH_REL:
>  			ret += callchain__fprintf_graph(fp, chain,
>  							total_samples, 1, 1);
> +		case CHAIN_NONE:
>  		default:
>  			break;
>  		}
> @@ -1290,7 +1292,7 @@ process_lost_event(event_t *event, unsigned long offset, unsigned long head)
>  static void trace_event(event_t *event)
>  {
>  	unsigned char *raw_event = (void *)event;
> -	char *color = PERF_COLOR_BLUE;
> +	const char *color = PERF_COLOR_BLUE;
>  	int i, j;
>  
>  	if (!dump_trace)
> @@ -1348,7 +1350,7 @@ process_read_event(event_t *event, unsigned long offset, unsigned long head)
>  	struct perf_counter_attr *attr = perf_header__find_attr(event->read.id);
>  
>  	if (show_threads) {
> -		char *name = attr ? __event_name(attr->type, attr->config)
> +		const char *name = attr ? __event_name(attr->type, attr->config)
>  				   : "unknown";
>  		perf_read_values_add_value(&show_threads_values,
>  					   event->read.pid, event->read.tid,
> @@ -1411,19 +1413,19 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
>  
>  static u64 perf_header__sample_type(void)
>  {
> -	u64 sample_type = 0;
> +	u64 type = 0;
>  	int i;
>  
>  	for (i = 0; i < header->attrs; i++) {
>  		struct perf_header_attr *attr = header->attr[i];
>  
> -		if (!sample_type)
> -			sample_type = attr->attr.sample_type;
> -		else if (sample_type != attr->attr.sample_type)
> +		if (!type)
> +			type = attr->attr.sample_type;
> +		else if (type != attr->attr.sample_type)
>  			die("non matching sample_type");
>  	}
>  
> -	return sample_type;
> +	return type;
>  }
>  
>  static int __cmd_report(void)
> @@ -1431,7 +1433,7 @@ static int __cmd_report(void)
>  	int ret, rc = EXIT_FAILURE;
>  	unsigned long offset = 0;
>  	unsigned long head, shift;
> -	struct stat stat;
> +	struct stat input_stat;
>  	event_t *event;
>  	uint32_t size;
>  	char *buf;
> @@ -1450,13 +1452,13 @@ static int __cmd_report(void)
>  		exit(-1);
>  	}
>  
> -	ret = fstat(input, &stat);
> +	ret = fstat(input, &input_stat);
>  	if (ret < 0) {
>  		perror("failed to stat file");
>  		exit(-1);
>  	}
>  
> -	if (!stat.st_size) {
> +	if (!input_stat.st_size) {
>  		fprintf(stderr, "zero-sized file, nothing to do!\n");
>  		exit(0);
>  	}
> @@ -1524,12 +1526,12 @@ more:
>  		size = 8;
>  
>  	if (head + event->header.size >= page_size * mmap_window) {
> -		int ret;
> +		int munmap_ret;
>  
>  		shift = page_size * (head / page_size);
>  
> -		ret = munmap(buf, page_size * mmap_window);
> -		assert(ret == 0);
> +		munmap_ret = munmap(buf, page_size * mmap_window);
> +		assert(munmap_ret == 0);
>  
>  		offset += shift;
>  		head -= shift;
> @@ -1568,7 +1570,7 @@ more:
>  	if (offset + head >= header->data_offset + header->data_size)
>  		goto done;
>  
> -	if (offset + head < (unsigned long)stat.st_size)
> +	if (offset + head < (unsigned long)input_stat.st_size)
>  		goto more;
>  
>  done:
> @@ -1666,7 +1668,7 @@ static const struct option options[] = {
>  		    "be more verbose (show symbol address, etc)"),
>  	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
>  		    "dump raw trace in ASCII"),
> -	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
> +	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
>  	OPT_BOOLEAN('m', "modules", &modules,
>  		    "load module symbols - WARNING: use only with -k and LIVE kernel"),
>  	OPT_BOOLEAN('n', "show-nr-samples", &show_nr_samples,
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 9a6dbbf..06f763e 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -120,7 +120,8 @@ static void parse_source(struct sym_entry *syme)
>  	struct module *module;
>  	struct section *section = NULL;
>  	FILE *file;
> -	char command[PATH_MAX*2], *path = vmlinux;
> +	char command[PATH_MAX*2];
> +	const char *path = vmlinux_name;
>  	u64 start, end, len;
>  
>  	if (!syme)
> @@ -487,10 +488,12 @@ static void print_sym_table(void)
>  	);
>  
>  	for (nd = rb_first(&tmp); nd; nd = rb_next(nd)) {
> -		struct sym_entry *syme = rb_entry(nd, struct sym_entry, rb_node);
> -		struct symbol *sym = (struct symbol *)(syme + 1);
> +		struct symbol *sym;
>  		double pcnt;
>  
> +		syme = rb_entry(nd, struct sym_entry, rb_node);
> +		sym = (struct symbol *)(syme + 1);
> +
>  		if (++printed > print_entries || (int)syme->snap_count < count_filter)
>  			continue;
>  
> @@ -609,7 +612,7 @@ static void print_mapped_keys(void)
>  
>  	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
>  
> -	if (vmlinux) {
> +	if (vmlinux_name) {
>  		fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
>  		fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
>  		fprintf(stdout, "\t[S]     stop annotation.\n");
> @@ -638,7 +641,9 @@ static int key_mapped(int c)
>  		case 'F':
>  		case 's':
>  		case 'S':
> -			return vmlinux ? 1 : 0;
> +			return vmlinux_name ? 1 : 0;
> +		default:
> +			break;
>  	}
>  
>  	return 0;
> @@ -724,6 +729,8 @@ static void handle_keypress(int c)
>  		case 'z':
>  			zero = ~zero;
>  			break;
> +		default:
> +			break;
>  	}
>  }
>  
> @@ -812,13 +819,13 @@ static int parse_symbols(void)
>  {
>  	struct rb_node *node;
>  	struct symbol  *sym;
> -	int modules = vmlinux ? 1 : 0;
> +	int use_modules = vmlinux_name ? 1 : 0;
>  
>  	kernel_dso = dso__new("[kernel]", sizeof(struct sym_entry));
>  	if (kernel_dso == NULL)
>  		return -1;
>  
> -	if (dso__load_kernel(kernel_dso, vmlinux, symbol_filter, verbose, modules) <= 0)
> +	if (dso__load_kernel(kernel_dso, vmlinux_name, symbol_filter, verbose, use_modules) <= 0)
>  		goto out_delete_dso;
>  
>  	node = rb_first(&kernel_dso->syms);
> @@ -1114,7 +1121,7 @@ static const struct option options[] = {
>  			    "system-wide collection from all CPUs"),
>  	OPT_INTEGER('C', "CPU", &profile_cpu,
>  		    "CPU to profile on"),
> -	OPT_STRING('k', "vmlinux", &vmlinux, "file", "vmlinux pathname"),
> +	OPT_STRING('k', "vmlinux", &vmlinux_name, "file", "vmlinux pathname"),
>  	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
>  		    "number of mmap data pages"),
>  	OPT_INTEGER('r', "realtime", &realtime_prio,
> diff --git a/tools/perf/util/abspath.c b/tools/perf/util/abspath.c
> index 61d33b8..a791dd4 100644
> --- a/tools/perf/util/abspath.c
> +++ b/tools/perf/util/abspath.c
> @@ -50,7 +50,8 @@ const char *make_absolute_path(const char *path)
>  			die ("Could not get current working directory");
>  
>  		if (last_elem) {
> -			int len = strlen(buf);
> +			len = strlen(buf);
> +
>  			if (len + strlen(last_elem) + 2 > PATH_MAX)
>  				die ("Too long path name: '%s/%s'",
>  						buf, last_elem);
> diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
> index 4b50c41..6f8ea9d 100644
> --- a/tools/perf/util/cache.h
> +++ b/tools/perf/util/cache.h
> @@ -52,7 +52,6 @@ extern const char *perf_mailmap_file;
>  extern void maybe_flush_or_die(FILE *, const char *);
>  extern int copy_fd(int ifd, int ofd);
>  extern int copy_file(const char *dst, const char *src, int mode);
> -extern ssize_t read_in_full(int fd, void *buf, size_t count);
>  extern ssize_t write_in_full(int fd, const void *buf, size_t count);
>  extern void write_or_die(int fd, const void *buf, size_t count);
>  extern int write_or_whine(int fd, const void *buf, size_t count, const char *msg);
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 0114734..3b8380f 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -50,6 +50,7 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
>  			else
>  				p = &(*p)->rb_right;
>  			break;
> +		case CHAIN_NONE:
>  		default:
>  			break;
>  		}
> @@ -143,6 +144,7 @@ int register_callchain_param(struct callchain_param *param)
>  	case CHAIN_FLAT:
>  		param->sort = sort_chain_flat;
>  		break;
> +	case CHAIN_NONE:
>  	default:
>  		return -1;
>  	}
> diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
> index 90a044d..e47fdeb 100644
> --- a/tools/perf/util/color.c
> +++ b/tools/perf/util/color.c
> @@ -242,9 +242,9 @@ int color_fwrite_lines(FILE *fp, const char *color,
>  	return 0;
>  }
>  
> -char *get_percent_color(double percent)
> +const char *get_percent_color(double percent)
>  {
> -	char *color = PERF_COLOR_NORMAL;
> +	const char *color = PERF_COLOR_NORMAL;
>  
>  	/*
>  	 * We color high-overhead entries in red, mid-overhead
> @@ -263,7 +263,7 @@ char *get_percent_color(double percent)
>  int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
>  {
>  	int r;
> -	char *color;
> +	const char *color;
>  
>  	color = get_percent_color(percent);
>  	r = color_fprintf(fp, color, fmt, percent);
> diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
> index 706cec5..43d0d1b 100644
> --- a/tools/perf/util/color.h
> +++ b/tools/perf/util/color.h
> @@ -36,6 +36,6 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
>  int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
>  int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
>  int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
> -char *get_percent_color(double percent);
> +const char *get_percent_color(double percent);
>  
>  #endif /* COLOR_H */
> diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
> index 780df54..8784649 100644
> --- a/tools/perf/util/config.c
> +++ b/tools/perf/util/config.c
> @@ -160,17 +160,18 @@ static int get_extended_base_var(char *name, int baselen, int c)
>  	name[baselen++] = '.';
>  
>  	for (;;) {
> -		int c = get_next_char();
> -		if (c == '\n')
> +		int ch = get_next_char();
> +
> +		if (ch == '\n')
>  			return -1;
> -		if (c == '"')
> +		if (ch == '"')
>  			break;
> -		if (c == '\\') {
> -			c = get_next_char();
> -			if (c == '\n')
> +		if (ch == '\\') {
> +			ch = get_next_char();
> +			if (ch == '\n')
>  				return -1;
>  		}
> -		name[baselen++] = c;
> +		name[baselen++] = ch;
>  		if (baselen > MAXNAME / 2)
>  			return -1;
>  	}
> @@ -530,6 +531,8 @@ static int store_aux(const char* key, const char* value, void *cb __used)
>  					store.offset[store.seen] = ftell(config_file);
>  			}
>  		}
> +	default:
> +		break;
>  	}
>  	return 0;
>  }
> @@ -619,6 +622,7 @@ contline:
>  		switch (contents[offset]) {
>  			case '=': equal_offset = offset; break;
>  			case ']': bracket_offset = offset; break;
> +			default: break;
>  		}
>  	if (offset > 0 && contents[offset-1] == '\\') {
>  		offset_ = offset;
> @@ -742,9 +746,9 @@ int perf_config_set_multivar(const char* key, const char* value,
>  			goto write_err_out;
>  	} else {
>  		struct stat st;
> -		char* contents;
> +		char *contents;
>  		ssize_t contents_sz, copy_begin, copy_end;
> -		int i, new_line = 0;
> +		int new_line = 0;
>  
>  		if (value_regex == NULL)
>  			store.value_regex = NULL;
> diff --git a/tools/perf/util/exec_cmd.c b/tools/perf/util/exec_cmd.c
> index 34a3528..2745605 100644
> --- a/tools/perf/util/exec_cmd.c
> +++ b/tools/perf/util/exec_cmd.c
> @@ -6,7 +6,6 @@
>  
>  #define MAX_ARGS	32
>  
> -extern char **environ;
>  static const char *argv_exec_path;
>  static const char *argv0_path;
>  
> diff --git a/tools/perf/util/module.c b/tools/perf/util/module.c
> index ddabe92..3d567fe 100644
> --- a/tools/perf/util/module.c
> +++ b/tools/perf/util/module.c
> @@ -436,9 +436,9 @@ static int mod_dso__load_module_paths(struct mod_dso *self)
>  		goto out_failure;
>  
>  	while (!feof(file)) {
> -		char *path, *name, *tmp;
> +		char *name, *tmp;
>  		struct module *module;
> -		int line_len, len;
> +		int line_len;
>  
>  		line_len = getline(&line, &n, file);
>  		if (line_len < 0)
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 0441784..1cda97b 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -14,10 +14,10 @@ int					nr_counters;
>  struct perf_counter_attr		attrs[MAX_COUNTERS];
>  
>  struct event_symbol {
> -	u8	type;
> -	u64	config;
> -	char	*symbol;
> -	char	*alias;
> +	u8		type;
> +	u64		config;
> +	const char	*symbol;
> +	const char	*alias;
>  };
>  
>  char debugfs_path[MAXPATHLEN];
> @@ -51,7 +51,7 @@ static struct event_symbol event_symbols[] = {
>  #define PERF_COUNTER_TYPE(config)	__PERF_COUNTER_FIELD(config, TYPE)
>  #define PERF_COUNTER_ID(config)		__PERF_COUNTER_FIELD(config, EVENT)
>  
> -static char *hw_event_names[] = {
> +static const char *hw_event_names[] = {
>  	"cycles",
>  	"instructions",
>  	"cache-references",
> @@ -61,7 +61,7 @@ static char *hw_event_names[] = {
>  	"bus-cycles",
>  };
>  
> -static char *sw_event_names[] = {
> +static const char *sw_event_names[] = {
>  	"cpu-clock-msecs",
>  	"task-clock-msecs",
>  	"page-faults",
> @@ -73,7 +73,7 @@ static char *sw_event_names[] = {
>  
>  #define MAX_ALIASES 8
>  
> -static char *hw_cache[][MAX_ALIASES] = {
> +static const char *hw_cache[][MAX_ALIASES] = {
>   { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
>   { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
>   { "LLC",	"L2"							},
> @@ -82,13 +82,13 @@ static char *hw_cache[][MAX_ALIASES] = {
>   { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
>  };
>  
> -static char *hw_cache_op[][MAX_ALIASES] = {
> +static const char *hw_cache_op[][MAX_ALIASES] = {
>   { "load",	"loads",	"read",					},
>   { "store",	"stores",	"write",				},
>   { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
>  };
>  
> -static char *hw_cache_result[][MAX_ALIASES] = {
> +static const char *hw_cache_result[][MAX_ALIASES] = {
>   { "refs",	"Reference",	"ops",		"access",		},
>   { "misses",	"miss",							},
>  };
> @@ -158,7 +158,7 @@ int valid_debugfs_mount(const char *debugfs)
>  	return 0;
>  }
>  
> -static char *tracepoint_id_to_name(u64 config)
> +static const char *tracepoint_id_to_name(u64 config)
>  {
>  	static char tracepoint_name[2 * MAX_EVENT_LENGTH];
>  	DIR *sys_dir, *evt_dir;
> @@ -235,7 +235,7 @@ static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
>  	return name;
>  }
>  
> -char *event_name(int counter)
> +const char *event_name(int counter)
>  {
>  	u64 config = attrs[counter].config;
>  	int type = attrs[counter].type;
> @@ -243,7 +243,7 @@ char *event_name(int counter)
>  	return __event_name(type, config);
>  }
>  
> -char *__event_name(int type, u64 config)
> +const char *__event_name(int type, u64 config)
>  {
>  	static char buf[32];
>  
> @@ -294,7 +294,7 @@ char *__event_name(int type, u64 config)
>  	return "unknown";
>  }
>  
> -static int parse_aliases(const char **str, char *names[][MAX_ALIASES], int size)
> +static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int size)
>  {
>  	int i, j;
>  	int n, longest = -1;
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index 192a962..9b1aeea 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -9,8 +9,8 @@ extern int			nr_counters;
>  
>  extern struct perf_counter_attr attrs[MAX_COUNTERS];
>  
> -extern char *event_name(int ctr);
> -extern char *__event_name(int type, u64 config);
> +extern const char *event_name(int ctr);
> +extern const char *__event_name(int type, u64 config);
>  
>  extern int parse_events(const struct option *opt, const char *str, int unset);
>  
> diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
> index 1bf6719..6d8af48 100644
> --- a/tools/perf/util/parse-options.c
> +++ b/tools/perf/util/parse-options.c
> @@ -53,6 +53,12 @@ static int get_value(struct parse_opt_ctx_t *p,
>  		case OPTION_SET_INT:
>  		case OPTION_SET_PTR:
>  			return opterror(opt, "takes no value", flags);
> +		case OPTION_END:
> +		case OPTION_ARGUMENT:
> +		case OPTION_GROUP:
> +		case OPTION_STRING:
> +		case OPTION_INTEGER:
> +		case OPTION_LONG:
>  		default:
>  			break;
>  		}
> @@ -130,6 +136,9 @@ static int get_value(struct parse_opt_ctx_t *p,
>  			return opterror(opt, "expects a numerical value", flags);
>  		return 0;
>  
> +	case OPTION_END:
> +	case OPTION_ARGUMENT:
> +	case OPTION_GROUP:
>  	default:
>  		die("should not happen, someone must be hit on the forehead");
>  	}
> @@ -296,6 +305,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>  				return parse_options_usage(usagestr, options);
>  			case -2:
>  				goto unknown;
> +			default:
> +				break;
>  			}
>  			if (ctx->opt)
>  				check_typos(arg + 1, options);
> @@ -314,6 +325,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>  					ctx->argv[0] = strdup(ctx->opt - 1);
>  					*(char *)ctx->argv[0] = '-';
>  					goto unknown;
> +				default:
> +					break;
>  				}
>  			}
>  			continue;
> @@ -336,6 +349,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>  			return parse_options_usage(usagestr, options);
>  		case -2:
>  			goto unknown;
> +		default:
> +			break;
>  		}
>  		continue;
>  unknown:
> @@ -456,6 +471,13 @@ int usage_with_options_internal(const char * const *usagestr,
>  			}
>  			break;
>  		default: /* OPTION_{BIT,BOOLEAN,SET_INT,SET_PTR} */
> +		case OPTION_END:
> +		case OPTION_GROUP:
> +		case OPTION_BIT:
> +		case OPTION_BOOLEAN:
> +		case OPTION_SET_INT:
> +		case OPTION_SET_PTR:
> +		case OPTION_LONG:
>  			break;
>  		}
>  
> diff --git a/tools/perf/util/path.c b/tools/perf/util/path.c
> index a501a40..fd1f2fa 100644
> --- a/tools/perf/util/path.c
> +++ b/tools/perf/util/path.c
> @@ -17,7 +17,7 @@ static char bad_path[] = "/bad-path/";
>   * Two hacks:
>   */
>  
> -static char *get_perf_dir(void)
> +static const char *get_perf_dir(void)
>  {
>  	return ".";
>  }
> @@ -38,8 +38,9 @@ size_t strlcpy(char *dest, const char *src, size_t size)
>  static char *get_pathname(void)
>  {
>  	static char pathname_array[4][PATH_MAX];
> -	static int index;
> -	return pathname_array[3 & ++index];
> +	static int idx;
> +
> +	return pathname_array[3 & ++idx];
>  }
>  
>  static char *cleanup_path(char *path)
> @@ -161,20 +162,24 @@ int perf_mkstemp(char *path, size_t len, const char *template)
>  }
>  
>  
> -const char *make_relative_path(const char *abs, const char *base)
> +const char *make_relative_path(const char *abs_path, const char *base)
>  {
>  	static char buf[PATH_MAX + 1];
>  	int baselen;
> +
>  	if (!base)
> -		return abs;
> +		return abs_path;
> +
>  	baselen = strlen(base);
> -	if (prefixcmp(abs, base))
> -		return abs;
> -	if (abs[baselen] == '/')
> +	if (prefixcmp(abs_path, base))
> +		return abs_path;
> +	if (abs_path[baselen] == '/')
>  		baselen++;
>  	else if (base[baselen - 1] != '/')
> -		return abs;
> -	strcpy(buf, abs + baselen);
> +		return abs_path;
> +
> +	strcpy(buf, abs_path + baselen);
> +
>  	return buf;
>  }
>  
> diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
> index a393534..2b615ac 100644
> --- a/tools/perf/util/run-command.c
> +++ b/tools/perf/util/run-command.c
> @@ -262,7 +262,7 @@ int run_hook(const char *index_file, const char *name, ...)
>  {
>  	struct child_process hook;
>  	const char **argv = NULL, *env[2];
> -	char index[PATH_MAX];
> +	char idx[PATH_MAX];
>  	va_list args;
>  	int ret;
>  	size_t i = 0, alloc = 0;
> @@ -284,8 +284,8 @@ int run_hook(const char *index_file, const char *name, ...)
>  	hook.no_stdin = 1;
>  	hook.stdout_to_stderr = 1;
>  	if (index_file) {
> -		snprintf(index, sizeof(index), "PERF_INDEX_FILE=%s", index_file);
> -		env[0] = index;
> +		snprintf(idx, sizeof(idx), "PERF_INDEX_FILE=%s", index_file);
> +		env[0] = idx;
>  		env[1] = NULL;
>  		hook.env = env;
>  	}
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 0b98623..3159d47 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -21,7 +21,7 @@ enum dso_origin {
>  
>  static struct symbol *symbol__new(u64 start, u64 len,
>  				  const char *name, unsigned int priv_size,
> -				  u64 obj_start, int verbose)
> +				  u64 obj_start, int v)
>  {
>  	size_t namelen = strlen(name) + 1;
>  	struct symbol *self = calloc(1, priv_size + sizeof(*self) + namelen);
> @@ -29,7 +29,7 @@ static struct symbol *symbol__new(u64 start, u64 len,
>  	if (!self)
>  		return NULL;
>  
> -	if (verbose >= 2)
> +	if (v >= 2)
>  		printf("new symbol: %016Lx [%08lx]: %s, hist: %p, obj_start: %p\n",
>  			(u64)start, (unsigned long)len, name, self->hist, (void *)(unsigned long)obj_start);
>  
> @@ -156,7 +156,7 @@ size_t dso__fprintf(struct dso *self, FILE *fp)
>  	return ret;
>  }
>  
> -static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verbose)
> +static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int v)
>  {
>  	struct rb_node *nd, *prevnd;
>  	char *line = NULL;
> @@ -198,7 +198,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
>  		 * Well fix up the end later, when we have all sorted.
>  		 */
>  		sym = symbol__new(start, 0xdead, line + len + 2,
> -				  self->sym_priv_size, 0, verbose);
> +				  self->sym_priv_size, 0, v);
>  
>  		if (sym == NULL)
>  			goto out_delete_line;
> @@ -239,7 +239,7 @@ out_failure:
>  	return -1;
>  }
>  
> -static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int verbose)
> +static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int v)
>  {
>  	char *line = NULL;
>  	size_t n;
> @@ -277,7 +277,7 @@ static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int verb
>  			continue;
>  
>  		sym = symbol__new(start, size, line + len,
> -				  self->sym_priv_size, start, verbose);
> +				  self->sym_priv_size, start, v);
>  
>  		if (sym == NULL)
>  			goto out_delete_line;
> @@ -305,13 +305,13 @@ out_failure:
>   * elf_symtab__for_each_symbol - iterate thru all the symbols
>   *
>   * @self: struct elf_symtab instance to iterate
> - * @index: uint32_t index
> + * @idx: uint32_t idx
>   * @sym: GElf_Sym iterator
>   */
> -#define elf_symtab__for_each_symbol(syms, nr_syms, index, sym) \
> -	for (index = 0, gelf_getsym(syms, index, &sym);\
> -	     index < nr_syms; \
> -	     index++, gelf_getsym(syms, index, &sym))
> +#define elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) \
> +	for (idx = 0, gelf_getsym(syms, idx, &sym);\
> +	     idx < nr_syms; \
> +	     idx++, gelf_getsym(syms, idx, &sym))
>  
>  static inline uint8_t elf_sym__type(const GElf_Sym *sym)
>  {
> @@ -354,7 +354,7 @@ static inline const char *elf_sym__name(const GElf_Sym *sym,
>  
>  static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  				    GElf_Shdr *shp, const char *name,
> -				    size_t *index)
> +				    size_t *idx)
>  {
>  	Elf_Scn *sec = NULL;
>  	size_t cnt = 1;
> @@ -365,8 +365,8 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  		gelf_getshdr(sec, shp);
>  		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
>  		if (!strcmp(name, str)) {
> -			if (index)
> -				*index = cnt;
> +			if (idx)
> +				*idx = cnt;
>  			break;
>  		}
>  		++cnt;
> @@ -392,7 +392,7 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>   * And always look at the original dso, not at debuginfo packages, that
>   * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
>   */
> -static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
> +static int dso__synthesize_plt_symbols(struct  dso *self, int v)
>  {
>  	uint32_t nr_rel_entries, idx;
>  	GElf_Sym sym;
> @@ -442,7 +442,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
>  		goto out_elf_end;
>  
>  	/*
> -	 * Fetch the relocation section to find the indexes to the GOT
> +	 * Fetch the relocation section to find the idxes to the GOT
>  	 * and the symbols in the .dynsym they refer to.
>  	 */
>  	reldata = elf_getdata(scn_plt_rel, NULL);
> @@ -476,7 +476,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
>  				 "%s@plt", elf_sym__name(&sym, symstrs));
>  
>  			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
> -					sympltname, self->sym_priv_size, 0, verbose);
> +					sympltname, self->sym_priv_size, 0, v);
>  			if (!f)
>  				goto out_elf_end;
>  
> @@ -494,7 +494,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int verbose)
>  				 "%s@plt", elf_sym__name(&sym, symstrs));
>  
>  			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
> -					sympltname, self->sym_priv_size, 0, verbose);
> +					sympltname, self->sym_priv_size, 0, v);
>  			if (!f)
>  				goto out_elf_end;
>  
> @@ -518,12 +518,12 @@ out:
>  }
>  
>  static int dso__load_sym(struct dso *self, int fd, const char *name,
> -			 symbol_filter_t filter, int verbose, struct module *mod)
> +			 symbol_filter_t filter, int v, struct module *mod)
>  {
>  	Elf_Data *symstrs, *secstrs;
>  	uint32_t nr_syms;
>  	int err = -1;
> -	uint32_t index;
> +	uint32_t idx;
>  	GElf_Ehdr ehdr;
>  	GElf_Shdr shdr;
>  	Elf_Data *syms;
> @@ -534,14 +534,14 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  
>  	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
>  	if (elf == NULL) {
> -		if (verbose)
> +		if (v)
>  			fprintf(stderr, "%s: cannot read %s ELF file.\n",
>  				__func__, name);
>  		goto out_close;
>  	}
>  
>  	if (gelf_getehdr(elf, &ehdr) == NULL) {
> -		if (verbose)
> +		if (v)
>  			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
>  		goto out_elf_end;
>  	}
> @@ -583,9 +583,9 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  						     NULL) != NULL);
>  	} else self->adjust_symbols = 0;
>  
> -	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
> +	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
>  		struct symbol *f;
> -		const char *name;
> +		const char *elf_name;
>  		char *demangled;
>  		u64 obj_start;
>  		struct section *section = NULL;
> @@ -608,7 +608,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  		obj_start = sym.st_value;
>  
>  		if (self->adjust_symbols) {
> -			if (verbose >= 2)
> +			if (v >= 2)
>  				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
>  					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
>  
> @@ -630,13 +630,13 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
>  		 * DWARF DW_compile_unit has this, but we don't always have access
>  		 * to it...
>  		 */
> -		name = elf_sym__name(&sym, symstrs);
> -		demangled = bfd_demangle(NULL, name, DMGL_PARAMS | DMGL_ANSI);
> +		elf_name = elf_sym__name(&sym, symstrs);
> +		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
>  		if (demangled != NULL)
> -			name = demangled;
> +			elf_name = demangled;
>  
> -		f = symbol__new(sym.st_value, sym.st_size, name,
> -				self->sym_priv_size, obj_start, verbose);
> +		f = symbol__new(sym.st_value, sym.st_size, elf_name,
> +				self->sym_priv_size, obj_start, v);
>  		free(demangled);
>  		if (!f)
>  			goto out_elf_end;
> @@ -659,7 +659,7 @@ out_close:
>  
>  #define BUILD_ID_SIZE 128
>  
> -static char *dso__read_build_id(struct dso *self, int verbose)
> +static char *dso__read_build_id(struct dso *self, int v)
>  {
>  	int i;
>  	GElf_Ehdr ehdr;
> @@ -676,14 +676,14 @@ static char *dso__read_build_id(struct dso *self, int verbose)
>  
>  	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
>  	if (elf == NULL) {
> -		if (verbose)
> +		if (v)
>  			fprintf(stderr, "%s: cannot read %s ELF file.\n",
>  				__func__, self->name);
>  		goto out_close;
>  	}
>  
>  	if (gelf_getehdr(elf, &ehdr) == NULL) {
> -		if (verbose)
> +		if (v)
>  			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
>  		goto out_elf_end;
>  	}
> @@ -706,7 +706,7 @@ static char *dso__read_build_id(struct dso *self, int verbose)
>  		++raw;
>  		bid += 2;
>  	}
> -	if (verbose >= 2)
> +	if (v >= 2)
>  		printf("%s(%s): %s\n", __func__, self->name, build_id);
>  out_elf_end:
>  	elf_end(elf);
> @@ -732,7 +732,7 @@ char dso__symtab_origin(const struct dso *self)
>  	return origin[self->origin];
>  }
>  
> -int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
> +int dso__load(struct dso *self, symbol_filter_t filter, int v)
>  {
>  	int size = PATH_MAX;
>  	char *name = malloc(size), *build_id = NULL;
> @@ -745,7 +745,7 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
>  	self->adjust_symbols = 0;
>  
>  	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
> -		ret = dso__load_perf_map(self, filter, verbose);
> +		ret = dso__load_perf_map(self, filter, v);
>  		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
>  					 DSO__ORIG_NOT_FOUND;
>  		return ret;
> @@ -764,7 +764,7 @@ more:
>  			snprintf(name, size, "/usr/lib/debug%s", self->name);
>  			break;
>  		case DSO__ORIG_BUILDID:
> -			build_id = dso__read_build_id(self, verbose);
> +			build_id = dso__read_build_id(self, v);
>  			if (build_id != NULL) {
>  				snprintf(name, size,
>  					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
> @@ -785,7 +785,7 @@ more:
>  		fd = open(name, O_RDONLY);
>  	} while (fd < 0);
>  
> -	ret = dso__load_sym(self, fd, name, filter, verbose, NULL);
> +	ret = dso__load_sym(self, fd, name, filter, v, NULL);
>  	close(fd);
>  
>  	/*
> @@ -795,7 +795,7 @@ more:
>  		goto more;
>  
>  	if (ret > 0) {
> -		int nr_plt = dso__synthesize_plt_symbols(self, verbose);
> +		int nr_plt = dso__synthesize_plt_symbols(self, v);
>  		if (nr_plt > 0)
>  			ret += nr_plt;
>  	}
> @@ -807,7 +807,7 @@ out:
>  }
>  
>  static int dso__load_module(struct dso *self, struct mod_dso *mods, const char *name,
> -			     symbol_filter_t filter, int verbose)
> +			     symbol_filter_t filter, int v)
>  {
>  	struct module *mod = mod_dso__find_module(mods, name);
>  	int err = 0, fd;
> @@ -820,13 +820,13 @@ static int dso__load_module(struct dso *self, struct mod_dso *mods, const char *
>  	if (fd < 0)
>  		return err;
>  
> -	err = dso__load_sym(self, fd, name, filter, verbose, mod);
> +	err = dso__load_sym(self, fd, name, filter, v, mod);
>  	close(fd);
>  
>  	return err;
>  }
>  
> -int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose)
> +int dso__load_modules(struct dso *self, symbol_filter_t filter, int v)
>  {
>  	struct mod_dso *mods = mod_dso__new_dso("modules");
>  	struct module *pos;
> @@ -844,7 +844,7 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose)
>  	next = rb_first(&mods->mods);
>  	while (next) {
>  		pos = rb_entry(next, struct module, rb_node);
> -		err = dso__load_module(self, mods, pos->name, filter, verbose);
> +		err = dso__load_module(self, mods, pos->name, filter, v);
>  
>  		if (err < 0)
>  			break;
> @@ -887,14 +887,14 @@ static inline void dso__fill_symbol_holes(struct dso *self)
>  }
>  
>  static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
> -			     symbol_filter_t filter, int verbose)
> +			     symbol_filter_t filter, int v)
>  {
>  	int err, fd = open(vmlinux, O_RDONLY);
>  
>  	if (fd < 0)
>  		return -1;
>  
> -	err = dso__load_sym(self, fd, vmlinux, filter, verbose, NULL);
> +	err = dso__load_sym(self, fd, vmlinux, filter, v, NULL);
>  
>  	if (err > 0)
>  		dso__fill_symbol_holes(self);
> @@ -905,18 +905,18 @@ static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
>  }
>  
>  int dso__load_kernel(struct dso *self, const char *vmlinux,
> -		     symbol_filter_t filter, int verbose, int modules)
> +		     symbol_filter_t filter, int v, int use_modules)
>  {
>  	int err = -1;
>  
>  	if (vmlinux) {
> -		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
> -		if (err > 0 && modules)
> -			err = dso__load_modules(self, filter, verbose);
> +		err = dso__load_vmlinux(self, vmlinux, filter, v);
> +		if (err > 0 && use_modules)
> +			err = dso__load_modules(self, filter, v);
>  	}
>  
>  	if (err <= 0)
> -		err = dso__load_kallsyms(self, filter, verbose);
> +		err = dso__load_kallsyms(self, filter, v);
>  
>  	if (err > 0)
>  		self->origin = DSO__ORIG_KERNEL;
> @@ -929,7 +929,7 @@ struct dso	*kernel_dso;
>  struct dso	*vdso;
>  struct dso	*hypervisor_dso;
>  
> -char		*vmlinux = "vmlinux";
> +const char	*vmlinux_name = "vmlinux";
>  int		modules;
>  
>  static void dsos__add(struct dso *dso)
> @@ -997,7 +997,7 @@ int load_kernel(void)
>  	if (!kernel_dso)
>  		return -1;
>  
> -	err = dso__load_kernel(kernel_dso, vmlinux, NULL, verbose, modules);
> +	err = dso__load_kernel(kernel_dso, vmlinux_name, NULL, verbose, modules);
>  	if (err <= 0) {
>  		dso__delete(kernel_dso);
>  		kernel_dso = NULL;
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 48b8e57..6e84907 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -55,7 +55,7 @@ struct dso {
>  	char		 name[0];
>  };
>  
> -const char *sym_hist_filter;
> +extern const char *sym_hist_filter;
>  
>  typedef int (*symbol_filter_t)(struct dso *self, struct symbol *sym);
>  
> @@ -87,6 +87,6 @@ extern struct list_head dsos;
>  extern struct dso *kernel_dso;
>  extern struct dso *vdso;
>  extern struct dso *hypervisor_dso;
> -extern char *vmlinux;
> +extern const char *vmlinux_name;
>  extern int   modules;
>  #endif /* _PERF_SYMBOL_ */
> diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
> index 614cfaf..1c15e39 100644
> --- a/tools/perf/util/values.c
> +++ b/tools/perf/util/values.c
> @@ -96,7 +96,7 @@ static void perf_read_values__enlarge_counters(struct perf_read_values *values)
>  }
>  
>  static int perf_read_values__findnew_counter(struct perf_read_values *values,
> -					     u64 rawid, char *name)
> +					     u64 rawid, const char *name)
>  {
>  	int i;
>  
> @@ -116,7 +116,7 @@ static int perf_read_values__findnew_counter(struct perf_read_values *values,
>  
>  void perf_read_values_add_value(struct perf_read_values *values,
>  				u32 pid, u32 tid,
> -				u64 rawid, char *name, u64 value)
> +				u64 rawid, const char *name, u64 value)
>  {
>  	int tindex, cindex;
>  
> @@ -221,8 +221,7 @@ static void perf_read_values__display_raw(FILE *fp,
>  				countwidth, values->value[i][j]);
>  }
>  
> -void perf_read_values_display(FILE *fp, struct perf_read_values *values,
> -			      int raw)
> +void perf_read_values_display(FILE *fp, struct perf_read_values *values, int raw)
>  {
>  	if (raw)
>  		perf_read_values__display_raw(fp, values);
> diff --git a/tools/perf/util/values.h b/tools/perf/util/values.h
> index f8960fd..cadf8cf 100644
> --- a/tools/perf/util/values.h
> +++ b/tools/perf/util/values.h
> @@ -19,7 +19,7 @@ void perf_read_values_destroy(struct perf_read_values *values);
>  
>  void perf_read_values_add_value(struct perf_read_values *values,
>  				u32 pid, u32 tid,
> -				u64 rawid, char *name, u64 value);
> +				u64 rawid, const char *name, u64 value);
>  
>  void perf_read_values_display(FILE *fp, struct perf_read_values *values,
>  			      int raw);

