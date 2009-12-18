Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZLRNiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZLRNiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZLRNiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:38:24 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:60958 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZLRNiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:38:23 -0500
Message-ID: <4B2B85C7.80502@linux.vnet.ibm.com>
Date: Fri, 18 Dec 2009 14:38:15 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD is
 set"
References: <4B1D13B5.9020802@linux.vnet.ibm.com> <20091207150906.GC14743@csn.ul.ie> <4B1E93EE.60602@linux.vnet.ibm.com> <4B210754.2020601@linux.vnet.ibm.com> <20091211112009.GC30670@csn.ul.ie> <4B225B9E.2020702@linux.vnet.ibm.com>
In-Reply-To: <4B225B9E.2020702@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------040702020004060807000803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040702020004060807000803
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Christian Ehrhardt wrote:
> Mel Gorman wrote:
> [...]
>>>  
>>
>> One way of finding out if cache hottness was the problem would be to 
>> profile
>> for cache misses and see if there are massive differences with and 
>> without
>> the patch. Is that an option?
>>   
> It is an option to verify things, but as mentioned above I would 
> expect an increase amounts of consumed cycles per kb which I don't see.
> I'll track caches anyway to be sure.
>
> My personal current assumption is that either there is some time lost 
> from the read syscall until the A event blocktrace tracks or I'm wrong 
> with my assumption about user processes and iozone runs "slower".
>
After I was able to verify that the time is lost above the block device 
layer I ran further tests to check out where the additional latency due 
to commit e084b occurs.
With "strace -frT -e trace=open,close,read,write" I could isolate the 
continuous stream of read calls done by the iozone child process.
In those data two things were revealed:
a) The time is lost between read and Block device enter (not e.g. due to 
slow userspace execution or scheduling effects)
     Time spent in userspace until the next read call is almost the 
same, but the average time spent "inside" the read call increases  from 
788µs to 3278µs
b) The time is lost in a few big peaks
    The majority of read calls are ~500-750µs in both cases, but there 
is a slight shift of approximately 8% that occur now as durations 
between 15000 and 60000µs

As mentioned before there is no significant increase of spent cpu cycles 
- therefore I watched out how the read call could end up in sleeps 
(latency but not used cycles).
I found that there is a chance to run into "congestion_wait" in case 
__alloc_pages_direct_reclaim() was able to free some pages with 
try_to_free_pages() but doesn't get a page in the subsequent 
get_page_from_freelist().
To get details about that I patched in some simple counters and 
ktime_get based timings. The results are impressive and point exactly 
towards the congestion_wait theory

The following data is again taken with iozone 1 thread random read in a 
very low memory environment, the counters were zeroed before starting iozone
Bad = the kernel just with commit e084b, good = kernel one commit before 
e084b. The throughput in good case while taking this data was 
approximately ~168% of that of the bad case.

                                         GOOD     BAD
perf_count_congestion_wait                245    1388
perf_count_pages_direct_reclaim         10993    5365
perf_count_failed_pages_direct_reclaim      0    1090
Note - the data also shows that the average time spent in the 
f_op->aio_read call issued by do_sync_read increases by 68.5% which is 
directly inversely proportional to the average loss in throughput.

This lets me conclude that patch e084b causes the system to run into 
congestion_wait after the semi-failed call to __alloc_pages_direct_reclaim.
Unfortunately I don't understand memory management enough to find the 
relation between e084b actually changing the order and position of freed 
pages in the LRU list to __alloc_pages_direct_reclaim not getting pages 
as effectively as before.
Ideas and comments welcome!

Kind regards,
Christian

P.S: attached are the three patches I used to get those new numbers


-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Linux Performance on System z 


--------------040702020004060807000803
Content-Type: text/x-patch;
 name="perf-count-and-time-do-sync-read.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-and-time-do-sync-read.diff"

Index: linux-2.6-git-2.6.31-bisect2/fs/read_write.c
===================================================================
--- linux-2.6-git-2.6.31-bisect2.orig/fs/read_write.c
+++ linux-2.6-git-2.6.31-bisect2/fs/read_write.c
@@ -249,25 +249,37 @@ static void wait_on_retry_sync_kiocb(str
 	__set_current_state(TASK_RUNNING);
 }
 
+unsigned long perf_count_do_sync_read_calls_aio_read = 0;
+unsigned long perf_tsum_do_sync_read_calls_aio_read = 0;
+unsigned long perf_count_do_sync_read_calls_wait_on_sync_kiocb = 0;
+unsigned long perf_tsum_do_sync_read_calls_wait_on_sync_kiocb = 0;
 ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = buf, .iov_len = len };
 	struct kiocb kiocb;
 	ssize_t ret;
+	ktime_t tv64_pre;
 
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = *ppos;
 	kiocb.ki_left = len;
 
 	for (;;) {
+		perf_count_do_sync_read_calls_aio_read++;
+		tv64_pre = ktime_get();
 		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
+		perf_tsum_do_sync_read_calls_aio_read += ktime_sub(ktime_get(),tv64_pre).tv64;
 		if (ret != -EIOCBRETRY)
 			break;
 		wait_on_retry_sync_kiocb(&kiocb);
 	}
 
-	if (-EIOCBQUEUED == ret)
+	if (-EIOCBQUEUED == ret) {
+		perf_count_do_sync_read_calls_wait_on_sync_kiocb++;
+		tv64_pre = ktime_get();
 		ret = wait_on_sync_kiocb(&kiocb);
+		perf_tsum_do_sync_read_calls_wait_on_sync_kiocb += ktime_sub(ktime_get(),tv64_pre).tv64;
+	}
 	*ppos = kiocb.ki_pos;
 	return ret;
 }
Index: linux-2.6-git-2.6.31-bisect2/kernel/sysctl.c
===================================================================
--- linux-2.6-git-2.6.31-bisect2.orig/kernel/sysctl.c
+++ linux-2.6-git-2.6.31-bisect2/kernel/sysctl.c
@@ -257,6 +257,10 @@ extern unsigned long perf_count_pages_di
 extern unsigned long perf_count_failed_pages_direct_reclaim;
 extern unsigned long perf_count_do_generic_file_read_calls_page_cache_alloc_cold;
 extern unsigned long perf_tsum_do_generic_file_read_calls_page_cache_alloc_cold;
+extern unsigned long perf_count_do_sync_read_calls_aio_read;
+extern unsigned long perf_tsum_do_sync_read_calls_aio_read;
+extern unsigned long perf_count_do_sync_read_calls_wait_on_sync_kiocb;
+extern unsigned long perf_tsum_do_sync_read_calls_wait_on_sync_kiocb;
 static struct ctl_table perf_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -297,6 +301,38 @@ static struct ctl_table perf_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode           = 0666,
 		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_do_sync_read_calls_aio_read",
+		.data           = &perf_count_do_sync_read_calls_aio_read,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_tsum_do_sync_read_calls_aio_read",
+		.data           = &perf_tsum_do_sync_read_calls_aio_read,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_do_sync_read_calls_wait_on_sync_kiocb",
+		.data           = &perf_count_do_sync_read_calls_wait_on_sync_kiocb,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_tsum_do_sync_read_calls_wait_on_sync_kiocb",
+		.data           = &perf_tsum_do_sync_read_calls_wait_on_sync_kiocb,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
 	},
 	{ .ctl_name = 0 }
 };

--------------040702020004060807000803
Content-Type: text/x-patch;
 name="perf-count-congestion-wait.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-congestion-wait.diff"

Index: linux-2.6-git-2.6.31-bisect2/include/linux/sysctl.h
===================================================================
--- linux-2.6-git-2.6.31-bisect2.orig/include/linux/sysctl.h
+++ linux-2.6-git-2.6.31-bisect2/include/linux/sysctl.h
@@ -69,6 +69,7 @@ enum
 	CTL_BUS=8,		/* Busses */
 	CTL_ABI=9,		/* Binary emulation */
 	CTL_CPU=10,		/* CPU stuff (speed scaling, etc) */
+	CTL_PERF=11,		/* Performance counters and timer sums for debugging */
 	CTL_ARLAN=254,		/* arlan wireless driver */
 	CTL_S390DBF=5677,	/* s390 debug */
 	CTL_SUNRPC=7249,	/* sunrpc debug */
Index: linux-2.6-git-2.6.31-bisect2/kernel/sysctl.c
===================================================================
--- linux-2.6-git-2.6.31-bisect2.orig/kernel/sysctl.c
+++ linux-2.6-git-2.6.31-bisect2/kernel/sysctl.c
@@ -177,6 +177,7 @@ static struct ctl_table_root sysctl_tabl
 	.default_set.list = LIST_HEAD_INIT(root_table_header.ctl_entry),
 };
 
+static struct ctl_table perf_table[];
 static struct ctl_table kern_table[];
 static struct ctl_table vm_table[];
 static struct ctl_table fs_table[];
@@ -230,6 +231,13 @@ static struct ctl_table root_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
+	{
+		.ctl_name	= CTL_PERF,
+		.procname	= "perf",
+		.mode		= 0555,
+		.child		= perf_table,
+	},
+
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
@@ -244,6 +252,19 @@ static int min_wakeup_granularity_ns;
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
+extern unsigned long perf_count_congestion_wait;
+static struct ctl_table perf_table[] = {
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_congestion_wait",
+		.data           = &perf_count_congestion_wait,
+		.mode           = 0666,
+		.maxlen		= sizeof(unsigned long),
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{ .ctl_name = 0 }
+};
+
 static struct ctl_table kern_table[] = {
 #ifdef CONFIG_SCHED_DEBUG
 	{
Index: linux-2.6-git-2.6.31-bisect2/mm/backing-dev.c
===================================================================
--- linux-2.6-git-2.6.31-bisect2.orig/mm/backing-dev.c
+++ linux-2.6-git-2.6.31-bisect2/mm/backing-dev.c
@@ -305,6 +305,7 @@ void set_bdi_congested(struct backing_de
 }
 EXPORT_SYMBOL(set_bdi_congested);
 
+unsigned long perf_count_congestion_wait = 0;
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
  * @sync: SYNC or ASYNC IO
@@ -320,6 +321,7 @@ long congestion_wait(int sync, long time
 	DEFINE_WAIT(wait);
 	wait_queue_head_t *wqh = &congestion_wqh[sync];
 
+	perf_count_congestion_wait++;
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = io_schedule_timeout(timeout);
 	finish_wait(wqh, &wait);

--------------040702020004060807000803
Content-Type: text/x-patch;
 name="perf-count-failed-direct-recalims.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf-count-failed-direct-recalims.diff"

Index: linux-2.6-git-2.6.31-bisect2/kernel/sysctl.c
===================================================================
--- linux-2.6-git-2.6.31-bisect2.orig/kernel/sysctl.c
+++ linux-2.6-git-2.6.31-bisect2/kernel/sysctl.c
@@ -253,6 +253,8 @@ static int max_wakeup_granularity_ns = N
 #endif
 
 extern unsigned long perf_count_congestion_wait;
+extern unsigned long perf_count_pages_direct_reclaim;
+extern unsigned long perf_count_failed_pages_direct_reclaim;
 static struct ctl_table perf_table[] = {
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -262,6 +264,22 @@ static struct ctl_table perf_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.proc_handler   = &proc_doulongvec_minmax,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_pages_direct_reclaim",
+		.data           = &perf_count_pages_direct_reclaim,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname       = "perf_count_failed_pages_direct_reclaim",
+		.data           = &perf_count_failed_pages_direct_reclaim,
+		.maxlen		= sizeof(unsigned long),
+		.mode           = 0666,
+		.proc_handler   = &proc_doulongvec_minmax,
+	},
 	{ .ctl_name = 0 }
 };
 
Index: linux-2.6-git-2.6.31-bisect2/mm/page_alloc.c
===================================================================
--- linux-2.6-git-2.6.31-bisect2.orig/mm/page_alloc.c
+++ linux-2.6-git-2.6.31-bisect2/mm/page_alloc.c
@@ -1605,6 +1605,9 @@ out:
 	return page;
 }
 
+unsigned long perf_count_pages_direct_reclaim = 0;
+unsigned long perf_count_failed_pages_direct_reclaim = 0;
+
 /* The really slow allocator path where we enter direct reclaim */
 static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
@@ -1645,6 +1648,11 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 					zonelist, high_zoneidx,
 					alloc_flags, preferred_zone,
 					migratetype);
+
+	perf_count_pages_direct_reclaim++;
+	if (!page)
+		perf_count_failed_pages_direct_reclaim++;
+
 	return page;
 }
 

--------------040702020004060807000803--
