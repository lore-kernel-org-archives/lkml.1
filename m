Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYFQMur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYFQMur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYFQMuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:50:39 -0400
Received: from [194.117.236.238] ([194.117.236.238]:45767 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbYFQMui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:50:38 -0400
Date: Tue, 17 Jun 2008 15:49:23 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080617154923.36195161@linux360.ro>
In-Reply-To: <20080617153934.59a7c7ee@linux360.ro>
References: <20080613040958.4f52ee29@linux360.ro>
	<1213417601.8237.37.camel@charm-linux>
	<20080614181103.17617db1@linux360.ro>
	<20080616122249.GB18561@Krystal>
	<20080616162212.27a8c119@linux360.ro>
	<20080616164609.GM20851@kernel.dk>
	<84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
	<20080616182843.GS20851@kernel.dk>
	<20080617153934.59a7c7ee@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 15:39:34 +0300
Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> kmemtrace will use the affine versions and set CPU affinity anyway,
> but it would be nice to have a consistent behavior from relay's part.
> 
> 
> 	Cheers,
> 	Eduard

BTW, I wrote this stuff and tested affinity behavior. It seems like
migration always occurs fast enough, even if under pressure. My machine
has two CPUs, so there are a few hardcoded values.

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <sched.h>

unsigned long get_current_cpu(FILE *stat_fp)
{
	char buf[256], *p;
	unsigned long n_delims = 0, ret;
	size_t count;
	
	fseek(stat_fp, 0, SEEK_SET);
	count = fread(buf, 1, 255, stat_fp);
	buf[count] = 0;

	p = buf;
	while (n_delims < 38)
		if (*p++ == ' ')
			n_delims++;
	sscanf(p, "%lu", &ret);

	return ret;
}

int main(void)
{
	FILE *stat_fp;
	char stat_filename[255];
	int err;
	unsigned long old_cpu, new_cpu, cpu;
	pid_t pid;
	cpu_set_t cpuset;

	pid = getpid();
	sprintf(stat_filename, "/proc/%lu/stat", pid);
	stat_fp = fopen(stat_filename, "r");
	if (!stat_fp) {
		printf("Couldn't open %lu", pid);
		return 1;
	}

	old_cpu = get_current_cpu(stat_fp);
	new_cpu = (old_cpu + 1) % 2;

	printf("Started on CPU %lu, PID %lu, setting affinity to CPU %lu...\n",
	       old_cpu, pid, new_cpu);
	
	err = sched_getaffinity(pid, sizeof(cpu_set_t), &cpuset);
	if (err == -1){
		printf("Could not retrieve the affinity!\n");
		return 1;
	}
	printf("Previous affinity: %d %d\n",
	       CPU_ISSET(0, &cpuset), CPU_ISSET(1, &cpuset));
	CPU_ZERO(&cpuset);
	CPU_SET(new_cpu, &cpuset);
	err = sched_setaffinity(pid, sizeof(cpu_set_t), &cpuset);
	if (err == -1) {
		printf("Could not set affinity!\n");
		return 1;
	}
	err = sched_getaffinity(pid, sizeof(cpu_set_t), &cpuset);
	if (err == -1){
		printf("Could not retrieve the affinity!\n");
		return 1;
	}
	printf("Current affinity: %d %d\n",
	       CPU_ISSET(0, &cpuset), CPU_ISSET(1, &cpuset));

	cpu = get_current_cpu(stat_fp);
	if (cpu != new_cpu) {
		printf("Process migration did not occur immediately!\n"
		       "--- we were supposed to be on %lu, but we're on %lu\n",
		       new_cpu, cpu);
		/* return 1; */
	}

	for (;;) {
		cpu = get_current_cpu(stat_fp);
		if (cpu != new_cpu) {
			printf("Oh, we arrived on a different CPU!\n");
			/* return 1; */
		}
	}

	return 0;
}

