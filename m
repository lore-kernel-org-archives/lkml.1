Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZIQGcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZIQGcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 02:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZIQGcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 02:32:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56804 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZIQGcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 02:32:10 -0400
Message-ID: <4AB1D887.90300@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 14:34:47 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: rostedt@goodmis.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 2/3] ftrace: add tracepoint for xtime
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com>	 <4A89213C.5090109@cn.fujitsu.com>	 <20090818215620.A63C.A69D9226@jp.fujitsu.com>	 <alpine.DEB.2.00.0908181454090.727@gandalf.stny.rr.com>	 <4A939CDF.2000407@cn.fujitsu.com> <4A939D4A.1020706@cn.fujitsu.com>	 <1f1b08da0909161256m376b1292ia4b2f3b2b4e82c34@mail.gmail.com>	 <1f1b08da0909161258g3e57a579iac2238c2f0916b07@mail.gmail.com>	 <1253133136.20020.245.camel@gandalf.stny.rr.com> <1253134155.3335.13.camel@work-vm>
In-Reply-To: <1253134155.3335.13.camel@work-vm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Wed, 2009-09-16 at 16:32 -0400, Steven Rostedt wrote:
>> On Wed, 2009-09-16 at 12:58 -0700, john stultz wrote:
>>> On Wed, Sep 16, 2009 at 12:56 PM, john stultz <johnstul@us.ibm.com> wrote:
>>>> On Tue, Aug 25, 2009 at 1:14 AM, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
>>>>> From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>>>>  /* Structure holding internal timekeeping values. */
>>>>>  struct timekeeper {
>>>>>        /* Current clocksource used for timekeeping. */
>>>>> @@ -338,6 +341,8 @@ int do_settimeofday(struct timespec *tv)
>>>>>
>>>>>        update_vsyscall(&xtime, timekeeper.clock);
>>>>>
>>>>> +       trace_gtod_update_xtime(&xtime, &wall_to_monotonic);
>>>>> +
>>>> So the only thing to watch out on here is that xtime doesn't hold the
>>>> current time, but the accumulated time. There is some unaccumulated
>>>> time still kept in the clocksource structure.
>>>>
>>>> You probably want (assuming you only need tick granularity time) to
>>>> use current_kernel_time().
>>>>
>>>> As an aside, is there a reason you have to have update callbacks and
>>>> duplicate the time storage instead of using the existing interfaces?
>>>> (ie: Is this due to locking or something else?)
>>> Doh. Sorry, you're actually tracing the timekeeping code. Not using
>>> this to assist tracing. Got this confused.
>>>
>>> So yea, I think this should be ok, plus or minus determining if you
>>> really want xtime or xtime_cache.
>> Well this may be a real concern. It's not about tracing timekeeping
>> (although it adds that functionality). His second patch (I didn't Cc you
>> on that one) hooks to these tracepoints to update time accordingly.
>>
>> What is being done is a way to have a "wall time" value being added to
>> the ring buffer. But this needs to be very carefully done, because the
>> all tracers use this, including the function tracer in NMI code. So the
>> clock source can not take locks or do anything fancy.
>>
>> What the idea is, is to have a semi clock that is read with some kind of
>> fast increment, and then at clock ticks, this clock is synced up.
> 
> Hmm.. Yea, if that's the case, then I'm not a big fan of this approach.
> 
> It sounds like what's really needed is a lock-free variant of
> current_kernel_time() or something close to the CLOCK_MONOTONIC_COARSE
> functionality currently queued.

Yes.

And it will be better if I can get current walltime fast and
with high resolution.

I see your patch of __current_kernel_time() in Aug 19,
and I think it can be used to get walltime in ftrace.
But IMHO, use tracepoint to do it maybe better for its high resolution.

Thanks
Zhaolei

> Doing it without locks might have some downsides, and I guess that's the
> point of the callback method (updates happen at prescribed times and
> likely under locks that the trace code understands so it avoids races
> and deadlocks).
> 
> -john
> 


