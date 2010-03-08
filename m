Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0CHH2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:28:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40598 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab0CHH2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:28:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 8 Mar 2010 16:24:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/2]  memcg: oom notifier and handling oom by user
Message-Id: <20100308162414.faaa9c5f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 2 patches is for memcg's oom handling.

At first, memcg's oom doesn't mean "no more resource" but means "we hit limit."
Then, daemons/user shells out of a memcg can work even if it's under oom.
So, if we have notifier and some more features, we can do something moderate
rather than killing at oom. 

This patch includes
[1/2] oom notifier for memcg (using evetfd framework of cgroups.)
[2/2] oom killer disalibing and hooks for waitq and wake-up.

When memcg's oom-killer is disabled, all tasks which request accountable memory
will sleep in waitq. It will be waken up by user's action as
 - enlarge limit. (memory or memsw)
 - kill some tasks
 - move some tasks (account migration is enabled.)

As an example, some moderate way is
 - send SIGSTOP to all tasks under memcg.
 - send a signal to terminate to a process, or shrink.
 - enlarge limit temporary, send SIGCONT to the task
 - reduce limit after task exits
 or 
 - move a terminating task to root cgroup

etc..etc...Maybe we can take coredump of memory-leaked process in above 
sequence.

Following is a sample script to show all process if oom happens.
Maybe some pop-up for X-window will show something nice.

I did easy test but it seems I have to do more.
Any comments are welcome.
(especially for user-interface and overhead of all checks.)

== memcg_oom_ps.sh
#!/bin/bash -x
# Usage:  ./memcg_oom_ps <path-to-cgroup>

./memcg_oom_waiter $1/memory.oom_control

if [ $? -ne 0 ]; then
        echo "something unexpected happens"
fi

ps -o pid,ppid,uid,vsz,rss,args -p `cat $1/cgroup.procs`
==

/*
 * memcg_oom_waiter: simple waiter for a memcg's OOM.
 *
 * Based on cgroup_event_listener.c
 * by Copyright (C) Kirill A. Shutemov <kirill@shutemov.name>
 */

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <sys/eventfd.h>

#define USAGE_STR "Usage: memcg_oom_waiter <path-to-control-file>\n"

int main(int argc, char **argv)
{
	int efd = -1;
	int cfd = -1;
	int event_control = -1;
	char event_control_path[PATH_MAX];
	char line[LINE_MAX];
	uint64_t result;
	int ret;

	cfd = open(argv[1], O_RDONLY);
	if (cfd == -1) {
		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
				strerror(errno));
		goto out;
	}

	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
			dirname(argv[1]));
	if (ret >= PATH_MAX) {
		fputs("Path to cgroup.event_control is too long\n", stderr);
		goto out;
	}

	event_control = open(event_control_path, O_WRONLY);
	if (event_control == -1) {
		fprintf(stderr, "Cannot open %s: %s\n", event_control_path,
				strerror(errno));
		goto out;
	}

	efd = eventfd(0, 0);
	if (efd == -1) {
		perror("eventfd() failed");
		goto out;
	}

	ret = snprintf(line, LINE_MAX, "%d %d", efd, cfd);
	if (ret >= LINE_MAX) {
		fputs("Arguments string is too long\n", stderr);
		goto out;
	}

	ret = write(event_control, line, strlen(line) + 1);
	if (ret == -1) {
		perror("Cannot write to cgroup.event_control");
		goto out;
	}

	while (1) {
		ret = read(efd, &result, sizeof(result));
		if (ret == -1) {
			if (errno == EINTR)
				continue;
			perror("Cannot read from eventfd");
			break;
		} else
			break;
	}
	assert(ret == sizeof(result));

	ret = access(event_control_path, W_OK);
	if ((ret == -1) && (errno == ENOENT)) {
		puts("The cgroup seems to have removed.");
		ret = 0;
		goto out;
	}

	if (ret == -1)
		perror("cgroup.event_control "
				"is not accessable any more");
out:
	if (efd >= 0)
		close(efd);
	if (event_control >= 0)
		close(event_control);
	if (cfd >= 0)
		close(cfd);

	return (ret != 0);
}


















