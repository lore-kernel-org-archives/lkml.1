Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbZJKCeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbZJKCeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 22:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZJKCeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 22:34:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53814 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbZJKCea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 22:34:30 -0400
Message-ID: <f82dee90d0ab51d5bd33a6c01a9feb17.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <604427e00910091737s52e11ce9p256c95d533dc2837@mail.gmail.com>
References: <20091002135531.3b5abf5c.kamezawa.hiroyu@jp.fujitsu.com>
    <604427e00910091737s52e11ce9p256c95d533dc2837@mail.gmail.com>
Date: Sun, 11 Oct 2009 11:33:50 +0900 (JST)
Subject: Re: [PATCH 0/2] memcg: improving scalability by reducing lock 
 contention at charge/uncharge
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Ying Han" <yinghan@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ying Han wrote:
> Hi KAMEZAWA-san: I tested your patch set based on 2.6.32-rc3 but I don't
> see
> much improvement on the page-faults rate.
> Here is the number I got:
>
> [Before]
>  Performance counter stats for './runpause.sh 10' (5 runs):
>
>   226272.271246  task-clock-msecs         #      3.768 CPUs    ( +-
> 0.193%
> )
>            4424  context-switches         #      0.000 M/sec   ( +-
> 14.418%
> )
>              25  CPU-migrations           #      0.000 M/sec   ( +-
> 23.077%
> )
>        80499059  page-faults              #      0.356 M/sec   ( +-
> 2.586%
> )
>    499246232482  cycles                   #   2206.396 M/sec   ( +-
> 0.055%
> )
>    193036122022  instructions             #      0.387 IPC     ( +-
> 0.281%
> )
>     76548856038  cache-references         #    338.304 M/sec   ( +-
> 0.832%
> )
>       480196860  cache-misses             #      2.122 M/sec   ( +-
> 2.741%
> )
>
>    60.051646892  seconds time elapsed   ( +-   0.010% )
>
> [After]
>  Performance counter stats for './runpause.sh 10' (5 runs):
>
>   226491.338475  task-clock-msecs         #      3.772 CPUs    ( +-
> 0.176%
> )
>            3377  context-switches         #      0.000 M/sec   ( +-
> 14.713%
> )
>              12  CPU-migrations           #      0.000 M/sec   ( +-
> 23.077%
> )
>        81867014  page-faults              #      0.361 M/sec   ( +-
> 3.201%
> )
>    499835798750  cycles                   #   2206.865 M/sec   ( +-
> 0.036%
> )
>    196685031865  instructions             #      0.393 IPC     ( +-
> 0.286%
> )
>     81143829910  cache-references         #    358.265 M/sec   ( +-
> 0.428%
> )
>       119362559  cache-misses             #      0.527 M/sec   ( +-
> 5.291%
> )
>
>    60.048917062  seconds time elapsed   ( +-   0.010% )
>
> I ran it on an 4 core machine with 16G of RAM. And I modified
> the runpause.sh to fork 4 pagefault process instead of 8. I mounted cgroup
> with only memory subsystem and start running the test on the root cgroup.
>
> I believe that we might have different running environment including the
> cgroup configuration.  Any suggestions?
>

This patch series is only for "child" cgroup. Sorry, I had to write it
clearer. No effects to root.

Regards,
-Kame

> --Ying
>
> On Thu, Oct 1, 2009 at 9:55 PM, KAMEZAWA Hiroyuki <
> kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> Hi,
>>
>> This patch is against mmotm + softlimit fix patches.
>> (which are now in -rc git tree.)
>>
>> In the latest -rc series, the kernel avoids accessing res_counter when
>> cgroup is root cgroup. This helps scalabilty when memcg is not used.
>>
>> It's necessary to improve scalabilty even when memcg is used. This patch
>> is for that. Previous Balbir's work shows that the biggest obstacles for
>> better scalabilty is memcg's res_counter. Then, there are 2 ways.
>>
>> (1) make counter scale well.
>> (2) avoid accessing core counter as much as possible.
>>
>> My first direction was (1). But no, there is no counter which is free
>> from false sharing when it needs system-wide fine grain synchronization.
>> And res_counter has several functionality...this makes (1) difficult.
>> spin_lock (in slow path) around counter means tons of invalidation will
>> happen even when we just access counter without modification.
>>
>> This patch series is for (2). This implements charge/uncharge in bached
>> manner.
>> This coalesces access to res_counter at charge/uncharge using nature of
>> access locality.
>>
>> Tested for a month. And I got good reorts from Balbir and Nishimura,
>> thanks.
>> One concern is that this adds some members to the bottom of task_struct.
>> Better idea is welcome.
>>
>> Following is test result of continuous page-fault on my 8cpu
>> box(x86-64).
>>
>> A loop like this runs on all cpus in parallel for 60secs.
>> ==
>>        while (1) {
>>                x = mmap(NULL, MEGA, PROT_READ|PROT_WRITE,
>>                        MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
>>
>>                for (off = 0; off < MEGA; off += PAGE_SIZE)
>>                        x[off]=0;
>>                munmap(x, MEGA);
>>        }
>> ==
>> please see # of page faults. I think this is good improvement.
>>
>>
>> [Before]
>>  Performance counter stats for './runpause.sh' (5 runs):
>>
>>  474539.756944  task-clock-msecs         #      7.890 CPUs    ( +-
>> 0.015%
>> )
>>          10284  context-switches         #      0.000 M/sec   ( +-
>> 0.156%
>> )
>>             12  CPU-migrations           #      0.000 M/sec   ( +-
>> 0.000%
>> )
>>       18425800  page-faults              #      0.039 M/sec   ( +-
>> 0.107%
>> )
>>  1486296285360  cycles                   #   3132.080 M/sec   ( +-
>> 0.029%
>> )
>>   380334406216  instructions             #      0.256 IPC     ( +-
>> 0.058%
>> )
>>     3274206662  cache-references         #      6.900 M/sec   ( +-
>> 0.453%
>> )
>>     1272947699  cache-misses             #      2.682 M/sec   ( +-
>> 0.118%
>> )
>>
>>   60.147907341  seconds time elapsed   ( +-   0.010% )
>>
>> [After]
>>  Performance counter stats for './runpause.sh' (5 runs):
>>
>>  474658.997489  task-clock-msecs         #      7.891 CPUs    ( +-
>> 0.006%
>> )
>>          10250  context-switches         #      0.000 M/sec   ( +-
>> 0.020%
>> )
>>             11  CPU-migrations           #      0.000 M/sec   ( +-
>> 0.000%
>> )
>>       33177858  page-faults              #      0.070 M/sec   ( +-
>> 0.152%
>> )
>>  1485264748476  cycles                   #   3129.120 M/sec   ( +-
>> 0.021%
>> )
>>   409847004519  instructions             #      0.276 IPC     ( +-
>> 0.123%
>> )
>>     3237478723  cache-references         #      6.821 M/sec   ( +-
>> 0.574%
>> )
>>     1182572827  cache-misses             #      2.491 M/sec   ( +-
>> 0.179%
>> )
>>
>>   60.151786309  seconds time elapsed   ( +-   0.014% )
>>
>> Regards,
>> -Kame
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>


