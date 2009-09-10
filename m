Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZIJHEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZIJHEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZIJHEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:04:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60455 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbZIJHEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:04:46 -0400
Date: Thu, 10 Sep 2009 09:04:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910070443.GC29009@elte.hu>
References: <20090908091304.GQ18599@kernel.dk> <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop> <20090910065856.GL18599@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20090910065856.GL18599@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Sep 10 2009, Peter Zijlstra wrote:
> > On Wed, 2009-09-09 at 14:20 +0200, Jens Axboe wrote:
> > > 
> > > One thing I also noticed is that when I have logged in, I run xmodmap
> > > manually to load some keymappings (I always tell myself to add this to
> > > the log in scripts, but I suspend/resume this laptop for weeks at the
> > > time and forget before the next boot). With the stock kernel, xmodmap
> > > will halt X updates and take forever to run. With BFS, it returned
> > > instantly. As I would expect.
> > 
> > Can you provide a little more detail (I'm a xmodmap n00b), how 
> > does one run xmodmap and maybe provide your xmodmap config?
> 
> Will do, let me get the notebook and strace time it on both bfs 
> and mainline.

A 'perf stat' comparison would be nice as well - that will show us 
events strace doesnt show, and shows us the basic scheduler behavior 
as well.

A 'full' trace could be done as well via trace-cmd.c (attached), if 
you enable:

  CONFIG_CONTEXT_SWITCH_TRACER=y

and did something like:

  trace-cmd -s xmodmap ... > trace.txt

	Ingo

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="trace-cmd.c"

/*
 * Copyright (C) 2008, Steven Rostedt <srostedt@redhat.com>
 *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License (not later!)
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#define VERSION "0.2"

#define _STR(x) #x
#define STR(x) _STR(x)
#define MAX_PATH 256

#define TRACE_CTRL	"tracing_enabled"
#define TRACE		"latency_trace"
#define AVAILABLE	"available_tracers"
#define CURRENT		"current_tracer"
#define ITER_CTRL	"iter_ctrl"
#define MAX_LATENCY	"tracing_max_latency"
#define THRESH		"tracing_thresh"

static void die(char *fmt, ...)
{
	va_list ap;
	int ret = errno;

	if (errno)
		perror("trace-cmd");
	else
		ret = -1;

	va_start(ap, fmt);
	fprintf(stderr, "  ");
	vfprintf(stderr, fmt, ap);
	va_end(ap);

	fprintf(stderr, "\n");
	exit(ret);
}

static int search_mounts(char *path, int size)
{
	FILE *fp;
	static char debugfs[MAX_PATH+1];
	static int debugfs_size;

	if (!debugfs_size) {
		char type[100];

		if ((fp = fopen("/proc/mounts","r")) == NULL)
			die("Can't open /proc/mounts for read");

		while (fscanf(fp, "%*s %"
			      STR(MAX_PATH)
			      "s %99s %*s %*d %*d\n",
			      debugfs, type) == 2) {
			if (strcmp(type, "debugfs") == 0)
				break;
		}
		fclose(fp);

		if (strcmp(type, "debugfs") != 0)
			die("debugfs not mounted, please mount");
	}

	debugfs_size = strlen(debugfs)+1;

	if (size > debugfs_size)
		size = debugfs_size;

	memcpy(path, debugfs, size);

	return size;
}

/*
 * Finds the path to the debugfs/tracing
 * Allocates the string and stores it.
 */
static int tracing_dir(char *path, int size)
{
	static char debugfs[MAX_PATH];
	static int debugfs_size;
	int ret;

	if (!debugfs_size) {
		ret = search_mounts(debugfs, MAX_PATH);
		if (ret < 0)
			return ret;
		debugfs_size = MAX_PATH - ret;
		strncat(debugfs, "/tracing", debugfs_size);
		debugfs_size = strlen(debugfs)+1;
	}

	if (size > debugfs_size)
		size = debugfs_size;

	memcpy(path, debugfs, size);

	return size;
}

static int tracing_type(char *path, const char *type, int size)
{
	int len = strlen(type) + 1;
	int ret;

	ret = tracing_dir(path, size);
	size -= ret;
	if (len > size)
		die ("debugfs path is too big!");
	strcat(path, "/");
	strcat(path, type);

	return ret + len;
}

static void write_trace(const char *file, const char *val)
{
	char path[MAX_PATH+1];
	int fd;

	tracing_type(path, file, MAX_PATH);

	fd = open(path, O_WRONLY);
	if (fd < 0)
		die("writng %s", path);
	write(fd, val, strlen(val));
	close(fd);
}

static int find_trace_type(const char *type)
{
	FILE *fp;
	char path[MAX_PATH+1];
	char scan[100];
	int ret;

	tracing_type(path, AVAILABLE, MAX_PATH);
	fp = fopen(path, "r");
	if (!fp)
		die("reading %s", path);
	do {
		ret = fscanf(fp, "%99s", scan);
		if (ret > 0 && strcmp(scan, type) == 0)
			break;
	} while (ret > 0);
	fclose(fp);

	return ret > 0;
}

static void set_ftrace(int set)
{
	int fd;
	char *val = set ? "1" : "0";

	fd = open("/proc/sys/kernel/ftrace_enabled", O_WRONLY);
	if (fd < 0)
		die ("Can't %s ftrace", set ? "enable" : "disable");

	write(fd, val, 1);
	close(fd);
}

void run_cmd(int argc, char **argv)
{
	int status;
	int pid;

	if ((pid = fork()) < 0)
		die("failed to fork");
	if (!pid) {
		/* child */
		if (execvp(argv[0], argv))
			exit(-1);
	}
	waitpid(pid, &status, 0);
}

static void usage(char **argv)
{
	char *arg = argv[0];
	char *p = arg+strlen(arg);

	while (p >= arg && *p != '/')
		p--;
	p++;

	printf("\n"
	       "%s version %s\n\n"
	       "usage: %s OPTION [-f] command ...\n"
	       "\n"
	       "  -s  set context switch trace\n"
	       "  -p  set preemption off trace\n"
	       "  -i  set interrupts off trace\n"
	       "  -b  set preempt and interrupts off trace\n"
	       "  -w  set wakeup tracing\n"
	       "  -e  set event tracing\n"
	       "  -f  set function trace\n"
	       "\n"
	       "  Note: only -f may be set with any other trace\n"
	       "\n", p, VERSION, p);
	exit(-1);
}

int main (int argc, char **argv)
{
	const char *type = NULL;
	const char *config;
	int function = 0;
	int type_set = 0;
	int max = 0;
	int c;

	while ((c = getopt(argc, argv, "+hspibfew")) >= 0) {
		switch (c) {
		case 'h':
			usage(argv);
			break;
		case 's':
			type = "sched_switch";
			config = "CONFIG_CONTEXT_SWITCH_TRACER";
			type_set++;
			break;
		case 'p':
			type = "preemptoff";
			config = "CONFIG_CRITICAL_PREEMPT_TIMING";
			max = 1;
			type_set++;
			break;
		case 'i':
			type = "irqsoff";
			config = "CONFIG_CRITICAL_IRQSOFF_TIMING";
			max = 1;
			type_set++;
			break;
		case 'b':
			type = "preemptirqsoff";
			config = "CONFIG_CRITICAL_IRQSOFF_TIMING and"
				" CONFIG_CRITICAL_PREEMPT_TIMING";
			max = 1;
			type_set++;
			break;
		case 'w':
			type = "wakeup";
			config = "CONFIG_WAKEUP_TRACER";
			max = 1;
			type_set++;
			break;
		case 'e':
			type = "events";
			config = "CONFIG_EVENT_TRACER";
			type_set++;
			break;
		case 'f':
			if (!type) {
				type = "ftrace";
				config = "CONFIG_FTRACE";
			}
			function = 1;
			break;
		default:
			/* yeah yeah, I know this is a dup! */
			usage(argv);
			break;
		}
	}

	if (type_set > 1)
		usage(argv);

	if (!(argc - optind))
		usage(argv);

	if (!type)
		usage(argv);

	if (!find_trace_type(type))
		die("Trace type %s not found.\n"
		    " Please configure the kernel with %s set\n",
		    type, config);

	write_trace(TRACE_CTRL, "0");
	if (function)
		set_ftrace(1);
	if (max)
		write_trace(MAX_LATENCY, "0");

	write_trace(CURRENT, type);
	write_trace(TRACE_CTRL, "1");

	run_cmd(argc - optind, &argv[optind]);

	write_trace(TRACE_CTRL, "0");
	if (function)
		set_ftrace(0);

	system("cat /debug/tracing/trace");

	return 0;
}


--3V7upXqbjpZ4EhLz--
