Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZIQHIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZIQHIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbZIQHIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:08:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756745AbZIQHIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:08:09 -0400
Message-ID: <4AB1E0F2.6030108@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 15:10:42 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: [PATCH v2 2/2] ftrace: Add timer-source of walltime for
 ftrace
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>	 <4A89213C.5090109@cn.fujitsu.com>	 <20090818215620.A63C.A69D9226@jp.fujitsu.com>	 <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>	 <4A939CDF.2000407@cn.fujitsu.com> <4AB076DE.10604@cn.fujitsu.com>	 <4AB077AF.6080800@cn.fujitsu.com> <20090916055928.GF5121@nowhere>	 <4AB0885C.4010504@cn.fujitsu.com> <1253129843.20020.214.camel@gandalf.stny.rr.com>
In-Reply-To: <1253129843.20020.214.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-09-16 at 14:40 +0800, Zhaolei wrote:
>> Frederic Weisbecker wrote:
>>> On Wed, Sep 16, 2009 at 01:29:19PM +0800, Zhaolei wrote:
>>>> We can add a timer-source for ftrace to support wall-time display.
>>>> It is based on Steven Rostedt <rostedt@goodmis.org>'s suggestion in:
>>>> http://lkml.org/lkml/2009/7/24/103
>>>>
>>>> It need to applys on my patch of:
>>>> [PATCH v4 1/2] Add function to convert between calendar time and broken-down time for universal use
>>>>
>> Hello, Frederic
>>
>> Thanks for your review.
>>
>>>> We can get following output:
>>>>  # cd /mnt/debugfs/tracing/
>>>>  # cat trace_clock
>>>>  [local] global walltime
>>>>  # echo sched_switch > current_tracer
>>>>  # cat trace
>>>>  # tracer: sched_switch
>>>>  #
>>>>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>>>>  #              | |       |          |         |
>>>>              bash-3580  [000]  2916.188093:   3580:120:S   + [000]  3580:120:S bash
>>>>              bash-3580  [000]  2916.188205:   3580:120:S   + [000]  3580:120:S bash
>>>>              bash-3580  [000]  2916.188538:   3580:120:R   + [000]     5:115:S events/0
>>>>              bash-3580  [000]  2916.188599:   3580:120:R ==> [000]     5:115:R events/0
>>>>          events/0-5     [000]  2916.188669:      5:115:S ==> [000]  3580:120:R bash
>>>>  ...
>>>>  # echo walltime > trace_clock
>>>>  # cat trace
>>>>  # tracer: sched_switch
>>>>  #
>>>>  #           TASK-PID    CPU#           TIMESTAMP  FUNCTION
>>>>  #              | |       |                        |         |
>>>
>>>
>>>
>>> The headers seem a bit broken. Is it a copy paste effect or?
>> No, it is a format bug of patch.
>> I'll fix it.
>>
>>>
>>>
>>>>              bash-3580  [000] 2009-08-24 18:03:16.500705:   3580:120:S   + [000]  3580:120:S bash
>>>>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
>>>>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S   + [000]  3580:120:S bash
>>>>              bash-3580  [000] 2009-08-24 18:03:16.500815:   3580:120:S ==> [000]     5:115:R events/0
>>>>          events/0-5     [000] 2009-08-24 18:03:16.500815:      5:115:R   + [000]  3578:120:S sshd
>>>>  ...
>>>
>>> But nice result :)
>>>
>>>
>>>> Changelog:
>>>> v1->v2: Rebase to top of tip tree.
>>>>
>>>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>>>> ---
>>>>  include/linux/trace_clock.h |    1 +
>>>>  kernel/trace/trace.c        |   24 ++++++++++++++++-----
>>>>  kernel/trace/trace.h        |    8 ++++++-
>>>>  kernel/trace/trace_clock.c  |   48 +++++++++++++++++++++++++++++++++++++++++++
>>>>  kernel/trace/trace_output.c |   21 +++++++++++++++---
>>>>  5 files changed, 91 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
>>>> index 7a81303..322707e 100644
>>>> --- a/include/linux/trace_clock.h
>>>> +++ b/include/linux/trace_clock.h
>>>> @@ -15,5 +15,6 @@
>>>>  extern u64 notrace trace_clock_local(void);
>>>>  extern u64 notrace trace_clock(void);
>>>>  extern u64 notrace trace_clock_global(void);
>>>> +extern u64 notrace trace_clock_walltime(void);
>>>>  
>>>>  #endif /* _LINUX_TRACE_CLOCK_H */
>>>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>>>> index fd52a19..160b6a8 100644
>>>> --- a/kernel/trace/trace.c
>>>> +++ b/kernel/trace/trace.c
>>>> @@ -335,9 +335,10 @@ static struct {
>>>>  } trace_clocks[] = {
>>>>  	{ trace_clock_local,	"local" },
>>>>  	{ trace_clock_global,	"global" },
>>>> +	{ trace_clock_walltime,	"walltime" },
>>>>  };
>>>>  
>>>> -int trace_clock_id;
>>>> +enum TRACE_CLOCK_TYPE trace_clock_type = TRACE_CLOCK_LOCAL;
>>>
>>>
>>> Uppercase names are usually reserved for CPP macros.
>> I'll rename it.
> 
> After the fixes that Frederic suggested, and the required timekeeping
> ACKS, I'll queue up your next version for v2.6.33. Looking forward to
> your new patches.

I'll send new patch after we finish xtime tracepoint's discussion.

Thanks
Zhaolei

