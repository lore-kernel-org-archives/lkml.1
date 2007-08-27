Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXH0L4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXH0L4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXH0L4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:56:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:34576 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXH0L4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:56:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:message-id;
        b=trpt7xC/2Bg/iOA3WAfcLLptbPLSWogdIP8a11j1JzNwTGMzf+FP3QFcD4Dy3Se1xJhfV3WvXmHHM3z2uEpP7OsTR00u/Arb+YvcsTGJw+kVwiG/nOkt3nbgqU33PY0hjCMiWd+NukhPMGh8l9QBCbQFsbXcU9xVhfytNW10bN4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: How to find out how many other processes share VM with $PID?
Date: Mon, 27 Aug 2007 12:56:31 +0100
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_vvr0Giq8peyAku0"
Message-Id: <200708271256.31874.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_vvr0Giq8peyAku0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I was a bit frustrated by bad quality of memory usage info
from top and ps, and decided to write my own utility.

One problem I don't know how to solve is how to avoid counting
twice (or more) memory used by processes which share VM
(by use of CLONE_VM flage to sys_clone).

I know how to detect and correctly account for threads
(processes created with CLONE_THREAD), but how to detect non-threads
with shared VM?

If this question is not clear enough, maybe notes below and attached
program for reading /proc/PID/* memory stats will help
to understand it better.


=========================
Shared VM detection

In Linux, processes can have shared VM. Typically, they are threads,
but it's not a certainty.

In Linux, "threads" are processes which were created with CLONE_THREAD
flag to clone(). They share PID, common parent and most of signal handling.
Parent is only signaled when last thread exits, not every one.
Each thread, though, has it's own thread ID (TID).

Threads do not show up as /proc/PID, except for the "thread group leader"
(that is, the process which did the first cloning with CLONE_THREAD).
They are accessible thru /proc/PID/task/TID.

Now, peculiarities you may need to know.

Threads actually *are* accessible as /proc/TID too, they just aren't
visible in ls (readdir/getdents syscall don't return you the info)!
(Peculiar, but not very useful for mem accounting.)

Threads are always spawned with CLONE_VM too. Yon cannot do CLONE_THREAD
without CLONE_VM. This is enforced by Linux kernel.
It means that they share the same VM. No COWing. And therefore you
don't need to go to /proc/PID/task/TID/* and scan info there to figure out
how much memory they use, and how. /proc/PID/* is enough.

Inverse is not true! You can clone a process with CLONE_VM, but
without CLONE_THREAD, and it will get new PID, and its own,
visible /proc/PID entry. It creates a problem: there is no way you can
figure out that /proc/PID1 and /proc/PID2 correspond to two
processes which share VM, and if you will sum memory usage
over the whole of /proc/*, you will count their usage twice.

It can be nice to know how many such CLONE_VM'ed processes
share VM with given /proc/PID. We can do accurate accounting
of memory by dividing all memory numbers of this process
by this number.

But this info seems to be unavailable. /proc/PID/status
has "Threads: N" line but it shows the number of threads,
i.e. the number we are NOT interested in, because we can
automatically account for them by not scanning
/proc/PID/task/TID (ans thus counting all threads' mem
usage only once, in thread group leader).
"Threads: N" does not include processes created with
CLONE_VM, but without CLONE_THREAD.
(NB: CLONE_SIGHAND also seems to be not affecting it).
===========================

--
vda

--Boundary-00=_vvr0Giq8peyAku0
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="memlist.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="memlist.c"

/* vi: set sw=4 ts=4: */
/*
 * Utility routines.
 *
 * Copyright 1998 by Albert Cahalan; all rights reserved.
 * Copyright (C) 2002 by Vladimir Oleynik <dzo@simtreas.ru>
 * SELinux support: (c) 2007 by Yuichi Nakamura <ynakam@hitachisoft.jp>
 *
 * Licensed under GPLv2 or later, see file LICENSE in this tarball for details.
 */

#include <errno.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <fcntl.h>

#define PROCPS_BUFSIZE (4*1024)

typedef struct {
        DIR *dir;
	unsigned pid;
/* Fields are set to 0/NULL if failed to determine (or not requested) */
        unsigned long long stat_vsz; /* we round it to kbytes */
        unsigned long long stat_rss; /* we round it to kbytes */
        unsigned long long status_vmsize;
        unsigned long long status_vmlck ;
        unsigned long long status_vmhwm ;
        unsigned long long status_vmrss ;
        unsigned long long status_vmdata;
        unsigned long long status_vmstk ;
        unsigned long long status_vmexe ;
        unsigned long long status_vmlib ;
        unsigned long long status_vmpte ;
        unsigned long long smaps_shared_clean ;
        unsigned long long smaps_shared_dirty ;
        unsigned long long smaps_private_clean;
        unsigned long long smaps_private_dirty;
        unsigned long long smaps_referenced   ;
	char argv0[32];
} procps_status_t;

static int read_to_buf(const char *filename, void *buf)
{
	int fd;
	ssize_t ret = -1;
	fd = open(filename, O_RDONLY);
	if (fd >= 0) {
		ret = read(fd, buf, PROCPS_BUFSIZE-1);
		close(fd);
	}
	((char *)buf)[ret > 0 ? ret : 0] = '\0';
	return ret;
}

procps_status_t *alloc_procps_scan(void)
{
	procps_status_t* sp = malloc(sizeof(*sp));
	memset(sp, 0, sizeof(*sp));
	sp->dir = opendir("/proc");
	return sp;
}

void free_procps_scan(procps_status_t* sp)
{
	closedir(sp->dir);
	free(sp);
}

procps_status_t *procps_scan(procps_status_t* sp)
{
	struct dirent *entry;
	char buf[PROCPS_BUFSIZE];
	char filename[sizeof("/proc//cmdline") + sizeof(int)*3];
	char *filename_tail;
	long tasknice;
	unsigned pid;
	int n;
	struct stat sb;

	if (!sp)
		sp = alloc_procps_scan();

	for (;;) {
		FILE *file;
		char *cp;
		unsigned long long vsz, rss;
		unsigned long long tmp_ull;

		entry = readdir(sp->dir);
		if (entry == NULL) {
			free_procps_scan(sp);
			return NULL;
		}
		pid = strtoul(entry->d_name, &cp, 10);
		if (cp[0])
			continue;

		/* After this point we have to break, not continue
		 * ("continue" would mean that current /proc/NNN
		 * is not a valid process info) */

		memset(&sp->pid, 0, sizeof(*sp) - offsetof(procps_status_t, pid));
		sp->pid = pid;
		filename_tail = filename + sprintf(filename, "/proc/%d", pid);

		strcpy(filename_tail, "/stat");
		n = read_to_buf(filename, buf);
		if (n < 0)
			break;
		cp = strrchr(buf, ')'); /* split into "PID (cmd" and "<rest>" */
		*cp = '\0';
		strncpy(sp->argv0, strchr(buf, '(') + 1, sizeof(sp->argv0) - 1);
		sp->argv0[sizeof(sp->argv0) - 1] = '\0';
		sscanf(cp+2,
			"%*s %*s "             /* state, ppid */
			"%*s %*s %*s %*s "     /* pgid, sid, tty, tpgid */
			"%*s %*s %*s %*s %*s " /* flags, min_flt, cmin_flt, maj_flt, cmaj_flt */
			"%*s %*s "             /* utime, stime */
			"%*s %*s %*s "         /* cutime, cstime, priority */
			"%*s "                 /* nice */
			"%*s %*s %*s "         /* timeout, it_real_value, start_time */
			"%llu "                /* vsize */
			"%llu "                /* rss */
		/*	"%lu %lu %lu %lu %lu %lu " rss_rlim, start_code, end_code, start_stack, kstk_esp, kstk_eip */
		/*	"%u %u %u %u "         signal, blocked, sigignore, sigcatch */
		/*	"%lu %lu %lu"          wchan, nswap, cnswap */
			,
			&vsz,
			&rss);
		sp->stat_vsz = vsz >> 10; /* vsize is in bytes and we want kb */
		sp->stat_rss = rss * (getpagesize() >> 10); /* or sysconf(_SC_PAGESIZE) */

		strcpy(filename_tail, "/status");
		n = read_to_buf(filename, buf);
		if (n < 0)
			break;
#define SCAN(str, name) \
	do { \
		cp = strstr(buf, str); \
		if (cp) sscanf(cp, str ": %llu ", &sp->status_##name); \
	} while (0)
		SCAN("VmSize", vmsize);
		SCAN("VmLck" , vmlck );
		SCAN("VmHWM" , vmhwm );
		SCAN("VmRSS" , vmrss );
		SCAN("VmData", vmdata);
		SCAN("VmStk" , vmstk );
		SCAN("VmExe" , vmexe );
		SCAN("VmLib" , vmlib );
		SCAN("VmPTE" , vmpte );
#undef SCAN

		strcpy(filename_tail, "/smaps");
		file = fopen(filename, "r");
		if (!file)
			break;
		while (fgets(buf, sizeof(buf), file)) {
#define SCAN(str, name) \
	if (strncmp(buf, str, sizeof(str)-1) == 0) { \
		sscanf(buf, str ": %llu ", &tmp_ull); \
		sp->smaps_##name += tmp_ull; \
		continue; \
	}
			SCAN("Shared_Clean" , shared_clean );
			SCAN("Shared_Dirty" , shared_dirty );
			SCAN("Private_Clean", private_clean);
			SCAN("Private_Dirty", private_dirty);
			SCAN("Referenced"   , referenced   );
#undef SCAN
		}
		fclose(file);

		strcpy(filename_tail, "/cmdline");
		n = read_to_buf(filename, buf);
		if (n <= 0)
			break;
		cp = strrchr(buf, '/');
		if (!cp)
			cp = buf - 1;
		strncpy(sp->argv0, cp + 1, sizeof(sp->argv0) - 1);
		sp->argv0[sizeof(sp->argv0) - 1] = '\0';

		break;
	}
	return sp;
}

int main()
{
	int stat_vsz_eq_status_vmsize = 1;
	int stat_rss_eq_status_vmrss = 1;
	int stat_rss_eq_smaps_total = 1;
	int status_vmhwm_eq_status_vmrss = 1;
	procps_status_t *sp = NULL;

	printf(        "      stat          status                                                  smaps\n");
	printf(        "PID.. vsz... rss... vmsize vmlck. vmhwm. vmdata vmstk. vmexe. vmlib. vmpte. total. (shr). dirty. (shr).\n");
	while ((sp = procps_scan(sp)) != NULL) {
		if (getpid() == sp->pid)
			continue;
		unsigned long long smaps_total = sp->smaps_shared_clean + sp->smaps_shared_dirty + sp->smaps_private_clean + sp->smaps_private_dirty;
		printf("%5u %6llu %6llu %6llu %6llu %6llu %6llu %6llu %6llu %6llu %6llu %6llu %6llu %6llu %6llu",
			sp->pid                ,
			sp->stat_vsz           ,
			sp->stat_rss           ,
			sp->status_vmsize      ,
			sp->status_vmlck       ,
			sp->status_vmhwm       ,
			//sp->status_vmrss       ,
			sp->status_vmdata      ,
			sp->status_vmstk       ,
			sp->status_vmexe       ,
			sp->status_vmlib       ,
			sp->status_vmpte       ,
			smaps_total, //sp->smaps_shared_clean + sp->smaps_shared_dirty + sp->smaps_private_clean + sp->smaps_private_dirty,
			sp->smaps_shared_clean + sp->smaps_shared_dirty,
			sp->smaps_shared_dirty + sp->smaps_private_dirty,
			sp->smaps_shared_dirty
			//sp->smaps_referenced
		);
		if (sp->stat_vsz != sp->status_vmsize) stat_vsz_eq_status_vmsize = 0, printf(" !1");
		if (sp->stat_rss != sp->status_vmrss) stat_rss_eq_status_vmrss = 0, printf(" !2");
		if (sp->status_vmhwm != sp->status_vmrss) status_vmhwm_eq_status_vmrss = 0, printf(" !3");
		if (sp->stat_rss != smaps_total) stat_rss_eq_smaps_total = 0, printf(" !4");
		printf(" %s\n", sp->argv0);
	}
	printf("stat_vsz == status_vmsize:    %d\n", stat_vsz_eq_status_vmsize   );
	printf("stat_rss == status_vmrss:     %d\n", stat_rss_eq_status_vmrss    );
	printf("status_vmhwm == status_vmrss: %d\n", status_vmhwm_eq_status_vmrss);
	printf("stat_rss == smaps_total:      %d\n", stat_rss_eq_smaps_total     );      
	return 0;
}

--Boundary-00=_vvr0Giq8peyAku0--
