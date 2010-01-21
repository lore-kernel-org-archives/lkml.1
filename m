Return-Path: <linux-kernel-owner+w=401wt.eu-S1752358Ab0AULoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab0AULoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 06:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153Ab0AULoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 06:44:10 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32590 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0AULoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 06:44:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=JQ1/JsH7mS5EWjz80RYolb9mN2JNnjcCqMnzsLz3HgOl4ImM/ywzyyOeAOnOGpMox
	l3lTpa12lupVDh8c+3GbQ==
MIME-Version: 1.0
In-Reply-To: <20100121104513.GA5017@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere>
	 <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
	 <20100121104513.GA5017@nowhere>
Date: Thu, 21 Jan 2010 12:44:03 +0100
Message-ID: <bd4cb8901001210344n1aea2f78l62848f55ea462e84@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Stephane Eranian <eranian@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:45 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Thu, Jan 21, 2010 at 11:08:12AM +0100, Stephane Eranian wrote:
>> >> > Do you mean this:
>> >> >
>> >> > hw_perf_group_sched_in_begin(&x86_pmu);
>> >> >
>> >> > for_each_event(event, group) {
>> >> >         event->enable();        //do the collection here
>> >> > }
>> >> >
>> >> >
>> >> > if (hw_perf_group_sched_in_end(&x86_pmu)) {
>> >> >         rollback...
>> >> > }
>> >> >
>> >> > That requires to know in advance if we have hardware pmu
>> >> > in the list though (can be a flag in the group).
>> >>
>>
>> I don't think this model can work without scheduling for each event.
>>
>> Imagine the situation where you have more events than you have
>> counters. At each tick you:
>>    - disable all events
>>    - rotate the list
>>    - collect events from the list
>>    - schedule events
>>    - activate
>>
>> Collection is the accumulation of events until you have as many as you
>> have counters
>> given you defer scheduling until the end (see loop above).
>>
>> But that does not mean you can schedule what you have accumulated. And then what
>> do you do, i.e., rollback to what?
>
>
>
> If the scheduling validation fails, then you just need to rollback
> the whole group.
>
> That's sensibly what you did in your patch, right? Except the loop
> is now handled by the core code.
>
>
Ok, I think I missed where you were actually placing that loop.
So you want to do this in group_sched_in(), right?

>
> I don't understand why that can't be done with the above model.
> In your patch we iterate through the whole group, collect events,
> and schedule them.
>
> With the above, the collection is just done on enable(), and the scheduling
> is done with the new pmu callbacks.
>
> The thing is sensibly the same, where is the obstacle?
>
There is none. You've just hoisted the some of the code from
hw_perf_group_sched_in().
