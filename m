Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbZLFKn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbZLFKn1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 05:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933259AbZLFKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 05:43:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58006 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933257AbZLFKnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 05:43:23 -0500
Message-ID: <4B1B8A66.6040302@cn.fujitsu.com>
Date: Sun, 06 Dec 2009 18:41:42 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Unable to use tools/perf sched and timechart correctly
References: <4B18E2AD.3070507@gmail.com>
In-Reply-To: <4B18E2AD.3070507@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Török Edwin wrote:
> Hi,
> 
> I installed 2.6.32 and tried its tools/perf.
> I noticed two problems so far, please tell me if I am doing anything
> wrong here:
> 
> 1. 'perf sched replay' segfaults on any recorded workload
> I tested like this:
> $ sudo ./perf sched record
> ^C[ perf record: Woken up 1 times to write data ]                  
> [ perf record: Captured and wrote 0.295 MB perf.data (~12869 samples) ]
> $ sudo perf sched replay
> run measurement overhead: 1258 nsecs                             
> sleep measurement overhead: 55232 nsecs                          
> the run test took 999778 nsecs                                   
> the sleep test took 1055791 nsecs                                
> nr_run_events:        182                                        
> nr_sleep_events:      209                                        
> nr_wakeup_events:     103                                        
> target-less wakeups:  12
> [...]
> task     25 (         icedove-bin:      8757), nr_events: 3
> task     26 (            events/0:        15), nr_events: 3
> ------------------------------------------------------------
> Segmentation fault

You should enable "CONFIG_SCHED_DEBUG", because we use
"/proc/<pid>/sched" file to get the task's cpu usage.

Ingo, I think we do better show the reason about this error,
just like:

---
 tools/perf/builtin-sched.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 26b782f..f823631 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -427,7 +427,11 @@ static u64 get_cpu_usage_nsec_self(void)
 
 	sprintf(filename, "/proc/%d/sched", getpid());
 	file = fopen(filename, "r");
-	BUG_ON(!file);
+	if (!file)
+	{
+		printf("You should compile your kernel with CONFIG_SCHED_DEBUG option\n");
+		BUG_ON(1);
+	}
 
 	while ((chars = getline(&line, &len, file)) != -1) {
 		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",
-- 
1.6.1.2

Thanks,
Xiao
