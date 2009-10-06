Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZJFAbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZJFAbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZJFAbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:31:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44017 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbZJFAbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:31:13 -0400
Subject: Re: [PATCH tracing/kprobes v2 4/5] perf: Add perf probe subcommand
 for kprobe-event setup helper
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20091002214904.30906.11622.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20091002214904.30906.11622.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 05 Oct 2009 20:29:13 -0400
Message-Id: <1254788953.13160.209.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 17:49 -0400, Masami Hiramatsu wrote:
> Add perf probe subcommand for kprobe-event setup helper to perf command.
> This allows user to define kprobe events by C expressions (C line numbers,
> C function names, and C local variables).
> 
> Usage
> -----
>  perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]
> 
>     -k, --vmlinux <file>  vmlinux/module pathname
>     -r, --release <rel>   kernel release
>     -P, --probe <p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]>
>                           probe point definition, where
> 		p:	kprobe probe
> 		r:	kretprobe probe
> 		GRP:	Group name (optional)
> 		NAME:	Event name
> 		FUNC:	Function name
> 		OFFS:	Offset from function entry (in byte)
> 		SRC:	Source code path
> 		LINE:	Line number
> 		ARG:	Probe argument (local variable name or
> 			kprobe-tracer argument format is supported.)
> 
> Changes in v2:
>  - Check synthesized string length.
>  - Rename perf kprobe to perf probe.
>  - Use spaces for separator and update usage comment.
>  - Check error paths in parse_probepoint().
>  - Check optimized-out variables.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> ---
> 
>  tools/perf/Makefile            |   10 +
>  tools/perf/builtin-probe.c     |  356 +++++++++++++++++++++
>  tools/perf/builtin.h           |    1 
>  tools/perf/perf.c              |    3 
>  tools/perf/util/probe-finder.c |  690 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/probe-finder.h |   68 ++++
>  6 files changed, 1128 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/builtin-probe.c
>  create mode 100644 tools/perf/util/probe-finder.c
>  create mode 100644 tools/perf/util/probe-finder.h
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index b5f1953..6dabcf1 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -419,6 +419,16 @@ ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf *
>  	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
>  endif
>  
> +ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
> +	msg := $(warning No libdwarf.h found, disables probe subcommand. Please install libdwarf-dev/libdwarf-devel);

Wow! And I thought my macros were ugly ;-)

> +else
> +	EXTLIBS += -lelf -ldwarf
> +	LIB_H += util/probe-finder.h
> +	LIB_OBJS += util/probe-finder.o
> +	BUILTIN_OBJS += builtin-probe.o
> +	BASIC_CFLAGS += -DSUPPORT_DWARF
> +endif
> +
>  ifdef NO_DEMANGLE
>  	BASIC_CFLAGS += -DNO_DEMANGLE
>  else
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> new file mode 100644
> index 0000000..47c5fb8
> --- /dev/null
> +++ b/tools/perf/builtin-probe.c
> @@ -0,0 +1,356 @@
> +/*
> + * builtin-probe.c
> + *
> + * Builtin probe command: Set up probe events by C expression
> + *
> + * Written by Masami Hiramatsu <mhiramat@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + */
> +
> +#include <sys/utsname.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include "perf.h"
> +#include "builtin.h"
> +#include "util/util.h"
> +#include "util/parse-options.h"
> +#include "util/parse-events.h"	/* For debugfs_path */
> +#include "util/probe-finder.h"
> +
> +/* Default vmlinux search paths */
> +#define NR_SEARCH_PATH 3
> +const char *default_search_path[NR_SEARCH_PATH] = {
> +"/lib/modules/%s/build/vmlinux",		/* Custom build kernel */
> +"/usr/lib/debug/lib/modules/%s/vmlinux",	/* Red Hat debuginfo */
> +"/boot/vmlinux-debug-%s",			/* Ubuntu */
> +};
> +
> +#define MAX_PATH_LEN 256
> +#define MAX_PROBES 128
> +
> +/* Session management structure */
> +static struct {
> +	char *vmlinux;
> +	char *release;
> +	int nr_probe;
> +	struct probe_point probes[MAX_PROBES];
> +	char *events[MAX_PROBES];
> +} session;
> +
> +static void semantic_error(const char *msg)
> +{
> +	fprintf(stderr, "Semantic error: %s\n", msg);
> +	exit(1);
> +}
> +
> +static void perror_exit(const char *msg)
> +{
> +	perror(msg);
> +	exit(1);
> +}
> +
> +#define MAX_PROBE_ARGS 128
> +
> +static int parse_probepoint(const struct option *opt __used,
> +			    const char *str, int unset __used)
> +{
> +	char *argv[MAX_PROBE_ARGS + 2];	/* Event + probe + args */
> +	int argc, i;
> +	char *arg, *ptr;
> +	struct probe_point *pp = &session.probes[session.nr_probe];
> +	char **event = &session.events[session.nr_probe];
> +	int retp = 0;
> +
> +	if (!str)	/* The end of probe points */
> +		return 0;
> +
> +	debug("Probe-define(%d): %s\n", session.nr_probe, str);
> +	if (++session.nr_probe == MAX_PROBES)
> +		semantic_error("Too many probes");
> +
> +	/* Separate arguments, similar to argv_split */
> +	argc = 0;
> +	do {
> +		/* Skip separators */
> +		while (isspace(*str))
> +			str++;
> +
> +		/* Add an argument */
> +		if (*str != '\0') {
> +			const char *s = str;
> +
> +			/* Skip the argument */
> +			while (!isspace(*str) && *str != '\0')
> +				str++;
> +
> +			/* Duplicate the argument */
> +			argv[argc] = strndup(s, str - s);
> +			if (argv[argc] == NULL)
> +				perror_exit("strndup");
> +			if (++argc == MAX_PROBE_ARGS)
> +				semantic_error("Too many arguments");
> +			debug("argv[%d]=%s\n", argc, argv[argc - 1]);
> +		}
> +	} while (*str != '\0');
> +	if (argc < 2)
> +		semantic_error("Need event-name and probe-point at least.");
> +
> +	/* Parse the event name */
> +	if (argv[0][0] == 'r')
> +		retp = 1;
> +	else if (argv[0][0] != 'p')
> +		semantic_error("You must specify 'p'(kprobe) or"
> +				" 'r'(kretprobe) first.");
> +	/* TODO: check event name */
> +	*event = argv[0];
> +
> +	/* Parse probe point */
> +	arg = argv[1];
> +	if (arg[0] == '@') {
> +		/* Source Line */
> +		arg++;
> +		ptr = strchr(arg, ':');
> +		if (!ptr || !isdigit(ptr[1]))
> +			semantic_error("Line number is required.");
> +		*ptr++ = '\0';
> +		if (strlen(arg) == 0)
> +			semantic_error("No file name.");
> +		pp->file = strdup(arg);
> +		pp->line = atoi(ptr);
> +		if (!pp->file || !pp->line)
> +			semantic_error("Failed to parse line.");
> +		debug("file:%s line:%d\n", pp->file, pp->line);
> +	} else {
> +		/* Function name */
> +		ptr = strchr(arg, '+');
> +		if (ptr) {
> +			if (!isdigit(ptr[1]))
> +				semantic_error("Offset is required.");
> +			*ptr++ = '\0';
> +			pp->offset = atoi(ptr);
> +		} else
> +			ptr = arg;
> +		ptr = strchr(ptr, '@');
> +		if (ptr) {
> +			*ptr++ = '\0';
> +			pp->file = strdup(ptr);
> +		}
> +		pp->function = strdup(arg);
> +		debug("symbol:%s file:%s offset:%d\n",
> +		      pp->function, pp->file, pp->offset);
> +	}
> +	free(argv[1]);
> +
> +	/* Copy arguments */
> +	pp->nr_args = argc - 2;
> +	if (pp->nr_args > 0) {
> +		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);

Hmm, you don't check for failed malloc here?

> +		memcpy(pp->args, &argv[2], sizeof(char *) * pp->nr_args);
> +	}
> +
> +	/* Ensure return probe has no C argument */
> +	if (retp)
> +		for (i = 0; i < pp->nr_args; i++)
> +			if (is_c_varname(pp->args[i]))
> +				semantic_error("You can't specify local"
> +						" variable for kretprobe");
> +	debug("%d arguments\n", pp->nr_args);
> +	return 0;
> +}
> +
> +static int open_default_vmlinux(void)
> +{
> +	struct utsname uts;
> +	char fname[MAX_PATH_LEN];
> +	int fd, ret, i;
> +
> +	if (!session.release) {
> +		ret = uname(&uts);
> +		if (ret) {
> +			debug("uname() failed.\n");
> +			return -errno;
> +		}
> +		session.release = uts.release;
> +	}
> +	for (i = 0; i < NR_SEARCH_PATH; i++) {
> +		ret = snprintf(fname, MAX_PATH_LEN,
> +			       default_search_path[i], session.release);
> +		if (ret >= MAX_PATH_LEN || ret < 0) {
> +			debug("Filename(%d,%s) is too long.\n", i, uts.release);
> +			errno = E2BIG;
> +			return -E2BIG;
> +		}
> +		debug("try to open %s\n", fname);
> +		fd = open(fname, O_RDONLY);
> +		if (fd >= 0)
> +			break;
> +	}
> +	return fd;
> +}
> +
> +static const char * const probe_usage[] = {
> +	"perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]",
> +	NULL
> +};
> +
> +static const struct option options[] = {
> +	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
> +		"vmlinux/module pathname"),
> +	OPT_STRING('r', "release", &session.release, "rel", "kernel release"),
> +	OPT_CALLBACK('P', "probe", NULL,
> +		"p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]",
> +		"probe point definition, where\n"
> +		"\t\tp:\tkprobe probe\n"
> +		"\t\tr:\tkretprobe probe\n"
> +		"\t\tGRP:\tGroup name (optional)\n"
> +		"\t\tNAME:\tEvent name\n"
> +		"\t\tFUNC:\tFunction name\n"
> +		"\t\tOFFS:\tOffset from function entry (in byte)\n"
> +		"\t\tSRC:\tSource code path\n"
> +		"\t\tLINE:\tLine number\n"
> +		"\t\tARG:\tProbe argument (local variable name or\n"
> +		"\t\t\tkprobe-tracer argument format is supported.)\n",
> +		parse_probepoint),
> +	OPT_END()
> +};
> +
> +static int write_new_event(int fd, const char *buf)
> +{
> +	int ret;
> +
> +	printf("Adding new event: %s\n", buf);
> +	ret = write(fd, buf, strlen(buf));
> +	if (ret <= 0)
> +		perror("Error: Failed to create event");
> +
> +	return ret;
> +}
> +
> +#define MAX_CMDLEN 256
> +
> +static int synthesize_probepoint(struct probe_point *pp)
> +{
> +	char *buf;
> +	int i, len, ret;
> +	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));

Again no check for failed calloc?

> +	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
> +	if (ret <= 0 || ret >= MAX_CMDLEN)
> +		goto error;
> +	len = ret;
> +
> +	for (i = 0; i < pp->nr_args; i++) {
> +		ret = snprintf(&buf[len], MAX_CMDLEN - len, " %s",
> +			       pp->args[i]);
> +		if (ret <= 0 || ret >= MAX_CMDLEN - len)
> +			goto error;
> +		len += ret;
> +	}
> +	pp->found = 1;
> +	return pp->found;
> +error:
> +	free(pp->probes[0]);
> +	if (ret > 0)
> +		ret = -E2BIG;
> +	return ret;
> +}
> +
> +int cmd_probe(int argc, const char **argv, const char *prefix __used)
> +{
> +	int i, j, fd, ret, need_dwarf = 0;
> +	struct probe_point *pp;
> +	char buf[MAX_CMDLEN];
> +
> +	argc = parse_options(argc, argv, options, probe_usage,
> +		PARSE_OPT_STOP_AT_NON_OPTION);
> +	if (argc || session.nr_probe == 0)
> +		usage_with_options(probe_usage, options);
> +
> +	/* Synthesize return probes */
> +	for (j = 0; j < session.nr_probe; j++) {
> +		if (session.events[j][0] != 'r') {
> +			need_dwarf = 1;
> +			continue;
> +		}
> +		ret = synthesize_probepoint(&session.probes[j]);
> +		if (ret == -E2BIG)
> +			semantic_error("probe point is too long.");
> +		else if (ret < 0) {
> +			perror("snprintf");
> +			return -1;
> +		}
> +	}
> +
> +	if (!need_dwarf)
> +		goto setup_probes;
> +
> +	if (session.vmlinux)
> +		fd = open(session.vmlinux, O_RDONLY);
> +	else
> +		fd = open_default_vmlinux();
> +	if (fd < 0) {
> +		perror("vmlinux/module file open");
> +		return -1;
> +	}
> +
> +	/* Searching probe points */
> +	for (j = 0; j < session.nr_probe; j++) {
> +		pp = &session.probes[j];
> +		if (pp->found)
> +			continue;
> +
> +		lseek(fd, SEEK_SET, 0);
> +		ret = find_probepoint(fd, pp);
> +		if (ret <= 0) {
> +			fprintf(stderr, "Error: No probe point found.\n");
> +			return -1;
> +		}
> +		debug("probe event %s found\n", session.events[j]);
> +	}
> +	close(fd);
> +
> +setup_probes:
> +	/* Settng up probe points */
> +	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
> +	fd = open(buf, O_WRONLY, O_APPEND);
> +	if (fd < 0) {
> +		perror("kprobe_events open");
> +		return -1;
> +	}
> +	for (j = 0; j < session.nr_probe; j++) {
> +		pp = &session.probes[j];
> +		if (pp->found == 1) {
> +			snprintf(buf, MAX_CMDLEN, "%s %s\n",
> +				session.events[j], pp->probes[0]);
> +			write_new_event(fd, buf);
> +		} else
> +			for (i = 0; i < pp->found; i++) {
> +				snprintf(buf, MAX_CMDLEN, "%s%d %s\n",
> +					session.events[j], i, pp->probes[i]);
> +				write_new_event(fd, buf);
> +			}
> +	}
> +	close(fd);
> +	return 0;
> +}
> +
> diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
> index e11d8d2..ad5f0f4 100644
> --- a/tools/perf/builtin.h
> +++ b/tools/perf/builtin.h

The rest looks fine (for what I can tell, it is all dwarf magic to
me ;-)

-- Steve


