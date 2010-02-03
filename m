Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0BCDXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:23:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33576 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0BCDXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:23:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 3 Feb 2010 12:20:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH mmotm] memcg: use generic percpu instead of private
 implementation
Message-Id: <20100203122021.619d250f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100203121624.bab7be2c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100203121624.bab7be2c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a test program I used.

 1. fork() processes on each cpus.
 2. do page fault repeatedly on each process.
 3. after 60secs, kill all childredn and exit.

(3 is necessary for getting stable data, this is improvement from previous one.)

Bye.
-Kame
==

#define _GNU_SOURCE
#include <stdio.h>
#include <sched.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <stdlib.h>

/*
 * For avoiding contention in page table lock, FAULT area is
 * sparse. If FAULT_LENGTH is too large for your cpus, decrease it.
 */
#define FAULT_LENGTH	(2 * 1024 * 1024)
#define PAGE_SIZE	4096
#define MAXNUM		(128)

void alarm_handler(int sig)
{
}

void *worker(int cpu, int ppid)
{
	void *start, *end;
	char *c;
	cpu_set_t set;
	int i;

	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	sched_setaffinity(0, sizeof(set), &set);

	start = mmap(NULL, FAULT_LENGTH, PROT_READ|PROT_WRITE,
			MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	if (start == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	end = start + FAULT_LENGTH;

	pause();
	//fprintf(stderr, "run%d", cpu);
	while (1) {
		for (c = (char*)start; (void *)c < end; c += PAGE_SIZE)
			*c = 0;
		madvise(start, FAULT_LENGTH, MADV_DONTNEED);
	}
	return NULL;
}

int main(int argc, char *argv[])
{
	int num, i, ret, pid, status;
	int pids[MAXNUM];

	if (argc < 2)
		return 0;

	setpgid(0, 0);
	signal(SIGALRM, alarm_handler);
	num = atoi(argv[1]);	
	pid = getpid();

	for (i = 0; i < num; ++i) {
		ret = fork();
		if (!ret) {
			worker(i, pid);
			exit(0);
		}
		pids[i] = ret;
	}
	sleep(1);
	kill(-pid, SIGALRM);
	sleep(60);
	for (i = 0; i < num; i++)
		kill(pids[i], SIGKILL);
	for (i = 0; i < num; i++)
		waitpid(pids[i], &status, 0);
	return 0;
}

