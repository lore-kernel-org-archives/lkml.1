Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbZHXQD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbZHXQD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZHXQD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:03:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42660 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZHXQDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=lpHz7HbOI+2iZXXLi417VkUIEMQyjBw7JxSFqSgan7sBNB0YSEpWK3s6bygDEb0FLd
         qt+FtQwhiw5M1WG2kFxPBQvSYSvW2vFZgsjP/QSEcwEZsK/5DKptSuVTuMW4ZkSbVppF
         tl78Nxzvf7I7Mzx8yb1/ub94aVgaXSiK3z0Tw=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	 <1251121618.7538.262.camel@twins>
	 <7c86c4470908240844u7450b13eicf4c4a466e29d701@mail.gmail.com>
Date: Mon, 24 Aug 2009 18:03:26 +0200
Message-ID: <7c86c4470908240903m322e2d5ck7d200046b10141a3@mail.gmail.com>
Subject: Re: perf_counters issue with enable_on_exec
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 5:44 PM, stephane eranian<eranian@googlemail.com> wrote:
> On Mon, Aug 24, 2009 at 3:46 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>> On Thu, 2009-08-20 at 15:49 +0200, stephane eranian wrote:
>>> Hi,
>>>
>>> I am running into an issue trying to use enable_on_exec
>>> in per-thread mode with an event group.
>>>
>>> My understanding is that enable_on_exec allows activation
>>> of an event on first exec. This is useful for tools monitoring
>>> other tasks and which you invoke as: tool my_program. In
>>> other words, the tool forks+execs my_program. This option
>>> allows developers to setup the events after the fork (to get
>>> the pid) but before the exec(). Only execution after the exec
>>> is monitored. This alleviates the need to use the
>>> ptrace(PTRACE_TRACEME) call.
>>>
>>> My understanding is that an event group is scheduled only
>>> if all events in the group are active (disabled=0). Thus, one
>>> trick to activate a group  with a single ioctl(PERF_IOC_ENABLE)
>>> is to enable all events in the group except the leader. This works
>>> well. But once you add enable_on_exec on on the events,
>>> things go wrong. The non-leader events start counting before
>>> the exec. If the non-leader events are created in disabled state,
>>> then they never activate on exec.
>>>
>>> The attached test program demonstrates the problem.
>>> simply invoke with a program that runs for a few seconds.
>>
>> OK, lots of issues here
>>
>>  1) your code is broken ;-)
>
> That's true. I knew about the missing synchro. But I think
> the problem existed nonetheless.
>
>>  2) enable_on_exec on !leader counters is undefined
>
> then fail it.
>
>>  3) there is something fishy non the less
>>
> True.
>
>>
>> 1. you fork() then create a counter group in both the parent and the
>> child without sync, then read the parent group. This obviously doesn't
>> do what is expected. See attached proglet for a better version.
>>
> I have modified the program based on your changes. See new version attached.
>
>> 2. enable_on_exec only works on leaders, Paul, was that intended?
>>
> All events in a group are scheduled together. If one event is not enabled
> in a group, then the group is not dispatched. Setting enable_on_exec
> just on leader makes sense. Then to enable the group on exec, you
> enabled all events but the leader. The enable_on_exec will enable
> the leader on exec and the group will be ready for dispatch. That's
> how it should work in my mind.
>
>
> As you indicated the issue is with the timing information and I think
> it is not related to enable_on_exec. It is more related to the fact
> that to enable a group with a single ioctl() you enable ALL BUT the
> leader. But that means that the time_enabled for the !leader is
> ticking. Thus scaling won't be as expected yet it is correct
> given what happens internally.
>
> I think there needs to be a distinction between 'enabled immediately
> but cannot run because group is not totally enabled' and 'cannot run
> because the group has been multiplexed out yet all could be dispatched
> because all events were dispatched'. In the former, it seems you don't
> want time_enabled to tick, while in the latter you do. In other words,
> time_enabled ticks for each event if the group is 'dispatch-able' (or
> runnable in your terminology) otherwise it does not. time_enabled reflects
> the fact that the group could run but did not have access to the PMU
> resource because of contention with other groups.
>
In other words, I think timing_enabled is measuring the wrong thing.
It should be instead called time_runnable and it should measure the
time during which the event is runnable, i.e, its group is runnable. That
means the event (group) could be dispatched if PMU was "free".
