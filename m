Return-Path: <linux-kernel-owner+w=401wt.eu-S1751524Ab0ARM5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab0ARM5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033Ab0ARM5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:57:35 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45032 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0ARM5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:57:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=vzBy/4l3RbJbCKrzeCoJaH8fA3+GblGkD84WrSELJ8zPRrDPRI1QQKifqD1isGmidq
         HjSKL7jG38bSENR2ZYBcQLz/wxF2frVCfOVQD5v1ZjK9k13bJ3KZ7WfeR987VclFfglk
         VbfJL5eb/aVct4kPvUOmVtB+2dP6FmpPaku+c=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20100118120747.GG5256@nowhere>
References: <4b4c761b.0338560a.1eaa.ffff824d@mx.google.com>
	 <1263312616.4244.153.camel@laptop>
	 <bd4cb8901001130154p732672b6x56e758c1ab33a8e8@mail.gmail.com>
	 <1263400193.4244.238.camel@laptop>
	 <bd4cb8901001130852y1de007cbqe66d77605c1ec372@mail.gmail.com>
	 <bd4cb8901001130922s7ad85af6w6c631d90de177ef9@mail.gmail.com>
	 <20100117141233.GF5035@nowhere> <1263813189.4283.245.camel@laptop>
	 <1263815616.4283.332.camel@laptop> <20100118120747.GG5256@nowhere>
Date: Mon, 18 Jan 2010 13:57:33 +0100
Message-ID: <7c86c4471001180457ue8738a5r25d717c939c6588c@mail.gmail.com>
Subject: Re: [perfmon2] [PATCH] perf: fix the is_software_event() definition
From: stephane eranian <eranian@googlemail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, perfmon2-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       paulus@samba.org, mingo@elte.hu, davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 1:07 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, Jan 18, 2010 at 12:53:36PM +0100, Peter Zijlstra wrote:
>> On Mon, 2010-01-18 at 12:13 +0100, Peter Zijlstra wrote:
>> > On Sun, 2010-01-17 at 15:12 +0100, Frederic Weisbecker wrote:
>> >
>> > > You need to also call pmu->disable() if it is a software event,
>> > > because a breakpoint needs to be unregistered in hardware level
>> > > too.
>> >
>> > breakpoint isn't a software pmu. But yeah, enable and disable need to
>> > match.
>>
>> That is, it shouldn't be a software pmu, because we assume software
>> events can always be scheduled, whereas that's definitely not so for the
>> breakpoint one.
>>
>> Which seems to suggest the following
>>
>> ---
>> Subject: perf: fix the is_software_event() definition
>>
>> When adding the breakpoint pmu Frederic forgot to exclude it from being
>> a software event. While we're at it, make it an inclusive expression.
>>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>
>
> Agreed.
>
> But then Stephane will need to update his patch and use
> something else than is_software_event() to guess if an event
> needs its pmu->enable/disable to be called.
>
> A kind of helper that can tell: I am not handled by
> hw_perf_group_sched_in()
>
Then, we should use something that checks if the event
is handled by the X86 PMU layer:

int is_x86_hw_event(struct perf_event *event)
{
   return event->pmu == x86_pmu;
}
