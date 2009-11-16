Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZKPCox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZKPCox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 21:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZKPCox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 21:44:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37461 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZKPCow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 21:44:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B00BC81.8060706@jp.fujitsu.com>
Date: Mon, 16 Nov 2009 11:44:17 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, spencer@bluehost.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       oleg@redhat.com, sgruszka@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix granularity of task_u/stime()
References: <4AFB9029.9000208@jp.fujitsu.com> <tip-761b1d26df542fd5eb348837351e4d2f3bc7bffe@git.kernel.org> <20091113230910.GA11280@elte.hu>
In-Reply-To: <20091113230910.GA11280@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> Commit-ID:  761b1d26df542fd5eb348837351e4d2f3bc7bffe
>> Gitweb:     http://git.kernel.org/tip/761b1d26df542fd5eb348837351e4d2f3bc7bffe
>> Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>> AuthorDate: Thu, 12 Nov 2009 13:33:45 +0900
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Thu, 12 Nov 2009 15:23:47 +0100
>>
>> sched: Fix granularity of task_u/stime()
>>
>> Originally task_s/utime() were designed to return clock_t but
>> later changed to return cputime_t by following commit:
> 
> i think this one causes this new warning in -tip:
> 
>  include/trace/events/timer.h:279: warning: format '%lu' 
>  expects type 'long unsigned int', but argument 4 has type 'cputime_t'

No.  I believe the warning was already there.
Following patch, based on tip:sched/core, will remove the warning.


Thanks,
H.Seto

===

Subject: [PATCH] trace: cputime_t is not always unsigned long

Type of cputime_t can be u64, unsigned long long or so on,
e.g. if kernel is configured with VIRT_CPU_ACCOUNTING=y.
So it can cause following warning:

 include/trace/events/timer.h:279: warning: format '%lu'
 expects type 'long unsigned int', but argument 4 has type 'cputime_t'

For printk(), it is better to use cputime_to_cputime64() and %llu,
since cputime64_t is always u64.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/trace/events/timer.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 1844c48..8f4ec13 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -302,8 +302,8 @@ TRACE_EVENT(itimer_state,
 		__entry->interval_usec	= value->it_interval.tv_usec;
 	),
 
-	TP_printk("which %d, expires %lu, it_value %lu.%lu, it_interval %lu.%lu",
-		  __entry->which, __entry->expires,
+	TP_printk("which %d, expires %llu, it_value %lu.%lu, it_interval %lu.%lu",
+		  __entry->which, cputime_to_cputime64(__entry->expires),
 		  __entry->value_sec, __entry->value_usec,
 		  __entry->interval_sec, __entry->interval_usec)
 );
@@ -332,8 +332,8 @@ TRACE_EVENT(itimer_expire,
 		__entry->pid	= pid_nr(pid);
 	),
 
-	    TP_printk("which %d, pid %d, now %lu", __entry->which,
-		      (int) __entry->pid, __entry->now)
+	    TP_printk("which %d, pid %d, now %llu", __entry->which,
+		      (int) __entry->pid, cputime_to_cputime64(__entry->now))
 );
 
 #endif /*  _TRACE_TIMER_H */
-- 
1.6.5.2


