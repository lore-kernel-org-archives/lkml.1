Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbZKFD0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbZKFD0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 22:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZKFD0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 22:26:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46311 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbZKFD0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 22:26:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 12:23:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
Message-Id: <20091106122344.51118116.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	<20091104234923.GA25306@redhat.com>
	<alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1>
	<alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>
	<20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 10:11:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This is the result of 'top -b -n 1' with 2000 processes(most of them just sleep)
> on my 8cpu, SMP box.
> 
> == [Before]
>  Performance counter stats for 'top -b -n 1' (5 runs):
> 
>      406.690304  task-clock-msecs         #      0.442 CPUs    ( +-   3.327% )
>              32  context-switches         #      0.000 M/sec   ( +-   0.000% )
>               0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
>             718  page-faults              #      0.002 M/sec   ( +-   0.000% )
>       987832447  cycles                   #   2428.955 M/sec   ( +-   2.655% )
>       933831356  instructions             #      0.945 IPC     ( +-   2.585% )
>        17383990  cache-references         #     42.745 M/sec   ( +-   1.676% )
>          353620  cache-misses             #      0.870 M/sec   ( +-   0.614% )
> 
>     0.920712639  seconds time elapsed   ( +-   1.609% )
> 
> == [After]
>  Performance counter stats for 'top -b -n 1' (5 runs):
> 
>      675.926348  task-clock-msecs         #      0.568 CPUs    ( +-   0.601% )
>              62  context-switches         #      0.000 M/sec   ( +-   1.587% )
>               0  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
>            1095  page-faults              #      0.002 M/sec   ( +-   0.000% )
>      1896320818  cycles                   #   2805.514 M/sec   ( +-   1.494% )
>      1790600289  instructions             #      0.944 IPC     ( +-   1.333% )
>        35406398  cache-references         #     52.382 M/sec   ( +-   0.876% )
>          722781  cache-misses             #      1.069 M/sec   ( +-   0.192% )
> 
>     1.190605561  seconds time elapsed   ( +-   0.417% )
> 
> Because I know 'ps' related workload is used in various ways, "How this will
> be in large smp" is my concern.
> 
> Maybe usual use of 'ps -elf' will not read RSS value and not affected by this.
> If this counter supports single-thread-mode (most of apps are single threaded),
> impact will not be big.
> 

Measured extreme case benefits with attached program. 
please see # of page faults. Bigger is better.
please let me know my program is buggy.
Excuse:
My .config may not be for extreme performace challenge, and my host only have 8cpus.
(memcg is enabled, hahaha...)

# of page fault is not very stable (affected by task-clock-msecs.)
but maybe we have some improvements.

I'd like to see score of "top" and this in big servers......

BTW, can't we have single-thread-mode for this counter ?
Usual program's read-side will get much benefit.....


==[Before]==
 Performance counter stats for './multi-fault 8' (5 runs):

  474810.516710  task-clock-msecs         #      7.912 CPUs    ( +-   0.006% )
          10713  context-switches         #      0.000 M/sec   ( +-   2.529% )
              8  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
       16669105  page-faults              #      0.035 M/sec   ( +-   0.449% )
  1487101488902  cycles                   #   3131.989 M/sec   ( +-   0.012% )
   307164795479  instructions             #      0.207 IPC     ( +-   0.177% )
     2355518599  cache-references         #      4.961 M/sec   ( +-   0.420% )
      901969818  cache-misses             #      1.900 M/sec   ( +-   0.824% )

   60.008425257  seconds time elapsed   ( +-   0.004% )

==[After]==
 Performance counter stats for './multi-fault 8' (5 runs):

  474212.969563  task-clock-msecs         #      7.902 CPUs    ( +-   0.007% )
          10281  context-switches         #      0.000 M/sec   ( +-   0.156% )
              9  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
       16795696  page-faults              #      0.035 M/sec   ( +-   2.218% )
  1485411063159  cycles                   #   3132.371 M/sec   ( +-   0.014% )
   305810331186  instructions             #      0.206 IPC     ( +-   0.133% )
     2391293765  cache-references         #      5.043 M/sec   ( +-   0.737% )
      890490519  cache-misses             #      1.878 M/sec   ( +-   0.212% )

   60.010631769  seconds time elapsed   ( +-   0.004% )

Thanks,
-Kame

==

/*
 * multi-fault.c :: causes 60secs of parallel page fault in multi-thread.
 * % gcc -O2 -o multi-fault multi-fault.c -lpthread
 * % multi-fault # of cpus.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <pthread.h>
#include <sched.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define NR_THREADS	32
pthread_t threads[NR_THREADS];
/*
 * For avoiding contention in page table lock, FAULT area is
 * sparse. If FAULT_LENGTH is too large for your cpus, decrease it.
 */
#define MMAP_LENGTH	(8 * 1024 * 1024)
#define FAULT_LENGTH	(2 * 1024 * 1024)
void *mmap_area[NR_THREADS];
#define PAGE_SIZE	4096

pthread_barrier_t barrier;
int name[NR_THREADS];

void *worker(void *data)
{
	int cpu = *(int *)data;
	cpu_set_t set;

	CPU_ZERO(&set);
	CPU_SET(cpu, &set);
	sched_setaffinity(0, sizeof(set), &set);
	pthread_barrier_wait(&barrier);

	while (1) {
		char *c;
		char *start = mmap_area[cpu];
		char *end = mmap_area[cpu] + FAULT_LENGTH;

		for (c = start; c < end; c += PAGE_SIZE)
			*c = 0;

		madvise(start, FAULT_LENGTH, MADV_DONTNEED);
	}
	return NULL;
}

int main(int argc, char *argv[])
{
	int i, num, ret;

	if (argc < 2)
		return 0;

	num = atoi(argv[1]);	

	pthread_barrier_init(&barrier, NULL, num + 1);

	for (i = 0; i < num; i++) {
		name[i] = i;
		ret = pthread_create(&threads[i], NULL, worker, &name[i]);
		if (ret < 0) {
			perror("pthread create");
			return 0;
		}
		mmap_area[i] = mmap(NULL, MMAP_LENGTH,
				PROT_WRITE | PROT_READ,
				MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
	}
	pthread_barrier_wait(&barrier);	
	sleep(60);
	return 0;
}





