Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZJBIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZJBIz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 04:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZJBIz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 04:55:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42274 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZJBIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 04:55:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Oct 2009 17:53:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 0/2] memcg: improving scalability by reducing lock
 contention at charge/uncharge
Message-Id: <20091002175310.0991139c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__2_Oct_2009_17_53_10_+0900_CjTryyjzW0PATSRD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Fri__2_Oct_2009_17_53_10_+0900_CjTryyjzW0PATSRD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Oct 2009 13:55:31 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Following is test result of continuous page-fault on my 8cpu box(x86-64).
> 
> A loop like this runs on all cpus in parallel for 60secs. 
> ==
>         while (1) {
>                 x = mmap(NULL, MEGA, PROT_READ|PROT_WRITE,
>                         MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
> 
>                 for (off = 0; off < MEGA; off += PAGE_SIZE)
>                         x[off]=0;
>                 munmap(x, MEGA);
>         }
> ==
> please see # of page faults. I think this is good improvement.
> 
> 
> [Before]
>  Performance counter stats for './runpause.sh' (5 runs):
> 
>   474539.756944  task-clock-msecs         #      7.890 CPUs    ( +-   0.015% )
>           10284  context-switches         #      0.000 M/sec   ( +-   0.156% )
>              12  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
>        18425800  page-faults              #      0.039 M/sec   ( +-   0.107% )
>   1486296285360  cycles                   #   3132.080 M/sec   ( +-   0.029% )
>    380334406216  instructions             #      0.256 IPC     ( +-   0.058% )
>      3274206662  cache-references         #      6.900 M/sec   ( +-   0.453% )
>      1272947699  cache-misses             #      2.682 M/sec   ( +-   0.118% )
> 
>    60.147907341  seconds time elapsed   ( +-   0.010% )
> 
> [After]
>  Performance counter stats for './runpause.sh' (5 runs):
> 
>   474658.997489  task-clock-msecs         #      7.891 CPUs    ( +-   0.006% )
>           10250  context-switches         #      0.000 M/sec   ( +-   0.020% )
>              11  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
>        33177858  page-faults              #      0.070 M/sec   ( +-   0.152% )
>   1485264748476  cycles                   #   3129.120 M/sec   ( +-   0.021% )
>    409847004519  instructions             #      0.276 IPC     ( +-   0.123% )
>      3237478723  cache-references         #      6.821 M/sec   ( +-   0.574% )
>      1182572827  cache-misses             #      2.491 M/sec   ( +-   0.179% )
> 
>    60.151786309  seconds time elapsed   ( +-   0.014% )
> 
BTW, this is a score in root cgroup.


  473811.590852  task-clock-msecs         #      7.878 CPUs    ( +-   0.006% )
          10257  context-switches         #      0.000 M/sec   ( +-   0.049% )
             10  CPU-migrations           #      0.000 M/sec   ( +-   0.000% )
       36418112  page-faults              #      0.077 M/sec   ( +-   0.195% )
  1482880352588  cycles                   #   3129.684 M/sec   ( +-   0.011% )
   410948762898  instructions             #      0.277 IPC     ( +-   0.123% )
     3182986911  cache-references         #      6.718 M/sec   ( +-   0.555% )
     1147144023  cache-misses             #      2.421 M/sec   ( +-   0.137% )


Then,
  36418112 x 100 / 33177858 = 109% slower in children cgroup.

But, Hmm, this test is an extreme case.(60sec continuous page faults on all cpus.)
We may can do something more, but this score itself is not so bad. I think.
Results on more cpus are welcome. Programs I used are attached.

Thanks,
-Kame
 



--Multipart=_Fri__2_Oct_2009_17_53_10_+0900_CjTryyjzW0PATSRD
Content-Type: text/x-csrc;
 name="pagefault.c"
Content-Disposition: attachment;
 filename="pagefault.c"
Content-Transfer-Encoding: 7bit

#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <signal.h>

#define PAGE_SIZE (4096)
#define MEGA	(1024 * 1024)

void sigalarm_handler(int sig)
{
}

int main(int argc, char *argv[])
{
	char *x;
	int off;

	signal(SIGALRM, sigalarm_handler);
	pause();
	while (1) {
		x = mmap(NULL, MEGA, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);

		for (off = 0; off < MEGA; off += PAGE_SIZE)
			x[off]=0;
		munmap(x, MEGA);
	}
}

--Multipart=_Fri__2_Oct_2009_17_53_10_+0900_CjTryyjzW0PATSRD
Content-Type: text/x-sh;
 name="runpause.sh"
Content-Disposition: attachment;
 filename="runpause.sh"
Content-Transfer-Encoding: 7bit

#!/bin/sh

for i in 0 1 2 3 4 5 6 7 ;do
	taskset -c $i ./pagefault &
done

pkill -ALRM  pagefault
sleep 60
pkill -HUP pagefault

--Multipart=_Fri__2_Oct_2009_17_53_10_+0900_CjTryyjzW0PATSRD--

