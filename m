Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187Ab0AUKV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0AUKV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174Ab0AUKVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:21:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0AUKVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:21:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hxmRmQkrknwTDcPehkhy8zlgt7hoGYMxayNwL9YrBC/BVjTpbmSoyIoQGKpSuxyUJ
	d2OWWkNMSDSMBNWyyCq9Q==
MIME-Version: 1.0
In-Reply-To: <1264068712.4283.1141.camel@laptop>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere>
	 <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
	 <1264068712.4283.1141.camel@laptop>
Date: Thu, 21 Jan 2010 11:21:19 +0100
Message-ID: <bd4cb8901001210221u5f02f05eq512df5dbb314419b@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v5)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-01-21 at 11:08 +0100, Stephane Eranian wrote:
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
>
> No it wont indeed, but it will work for where we now use
> hw_perf_group_sched_in() without having to replicate lots of code.
>
> For the cases you mention I see no other way than to try and schedule
> each event individually.
>
Are you suggesting a speculative approach where you first try simply
accumulate then schedule and if this fails, then restart the whole
loop but this time adding and scheduling each event individually?
For groups, you'd have to fail the group if one of its events fails.
