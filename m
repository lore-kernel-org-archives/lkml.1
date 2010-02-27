Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328Ab0B0RiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:38:18 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63526 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030261Ab0B0RiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MKLNS1Re2OQ1HPyjXTKHPdWvV5BUo8tSslh6EBXbDy77yzGWA29+cb4r4K2vlLQqH8
         iUoTnRgF2SuL/laQh7CdxM8soQspFp5NJ4a/Euvzt2oEy5juFlAZhNJBhL1fyL/F2s2m
         hAND8D+zgKQG4DPIsiAXYMqJogZ2ovBjc2Km0=
MIME-Version: 1.0
In-Reply-To: <1263918323.4283.707.camel@laptop>
References: <1263825158.4283.590.camel@laptop> <20100118161836.GG10364@nowhere>
	 <1263831973.4283.622.camel@laptop> <20100118165114.GJ10364@nowhere>
	 <1263834806.4283.625.camel@laptop> <20100118172935.GM10364@nowhere>
	 <1263903773.4283.657.camel@laptop> <1263907489.4283.663.camel@laptop>
	 <20100119155508.GE8061@nowhere> <1263918323.4283.707.camel@laptop>
Date: Sat, 27 Feb 2010 18:38:15 +0100
Message-ID: <c62985531002270938k472c1292w5b3beb7a59446398@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/19 Peter Zijlstra <peterz@infradead.org>:
> On Tue, 2010-01-19 at 16:55 +0100, Frederic Weisbecker wrote:
>> > Also, I see you set an ->unthrottle, but then don't implement it, but
>> > comment it as todo, which is strange because that implies its broken. If
>> > there's an ->unthrottle method it will throttle, so if its todo, the
>> > safest thing is to not set it.
>>
>>
>> Yeah, that's because I have a too vague idea on what is the purpose
>> of the unthrottle() callback.
>>
>> I've read the concerned codes that call this, several times, and I still
>> can't figure out what happens there, not sure what is meant by throttle
>> or unthrottle there :-/
>
> OK, so not setting it is relatively safe.
>
> As to what it does, it has to undo everything you do when
> perf_event_overflow() returns true, which happens when ->unthrottle is
> set and we get more than sysctl_perf_event_sample_rate/HZ events in a
> jiffy.
>
> If you look at the x86 implementation, you'll see that we simply disable
> the hardware counter when the overflow call returns true, so the
> unthrottle() callback simply enables it again.


Ok, I understand better now what mean "throttle" and "unthrottle" here.

But looking at what happens when we reach an event storm point, the
pending and subsequent
overflows until the next tick are just cancelled and that's it (as
it's using the software overflow
handler, not the x86 one). So we throttle and it's what we would want
to avoid a hang. If I remove my
unthrottle stub, it won't throttle anymore.

Theorically, the best would be to implement a true unthrottle
callback, which would just clear dr7,
really trivial. But I don't like this as ptrace events must always be
reported. A userspace app
could be polling a watchpointed variable, causing a lot of events, may
be that could trigger
a storm and then perf would throttle. Sure this is not supposed to
happen, given the fact ptrace breakpoints
are signaled to a debugger, which reduces the possible storm windows.
But just imagine a silly user sets sysctl_perf_event_sample_rate to 1,
then we would throttle at
each events, breaking the ptrace determinism rules.

So for now, I guess I need to remove my unthrottle stub, breakpoints
don't want to throttle because
of the ptrace determinism requirements.
