Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957Ab0AUKIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0AUKIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828Ab0AUKIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:08:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab0AUKIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:08:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=iiQNj/feTc11NgZ6spJV5xp5EmBEGUea+yBk20EiPAvAFmQ5o4srkgLwLtDv4jCpf
	cuF3mVS/1EwupmKK8f0yA==
MIME-Version: 1.0
In-Reply-To: <20100118144556.GE10364@nowhere>
References: <4b5430c6.0f975e0a.1bf9.ffff85fe@mx.google.com>
	 <20100118134324.GB10364@nowhere> <1263822898.4283.558.camel@laptop>
	 <20100118142004.GD10364@nowhere> <1263825158.4283.590.camel@laptop>
	 <20100118144556.GE10364@nowhere>
Date: Thu, 21 Jan 2010 11:08:12 +0100
Message-ID: <bd4cb8901001210208h758a546cw19fc81300164ec55@mail.gmail.com>
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

>> > Do you mean this:
>> >
>> > hw_perf_group_sched_in_begin(&x86_pmu);
>> >
>> > for_each_event(event, group) {
>> >         event->enable();        //do the collection here
>> > }
>> >
>> >
>> > if (hw_perf_group_sched_in_end(&x86_pmu)) {
>> >         rollback...
>> > }
>> >
>> > That requires to know in advance if we have hardware pmu
>> > in the list though (can be a flag in the group).
>>

I don't think this model can work without scheduling for each event.

Imagine the situation where you have more events than you have
counters. At each tick you:
   - disable all events
   - rotate the list
   - collect events from the list
   - schedule events
   - activate

Collection is the accumulation of events until you have as many as you
have counters
given you defer scheduling until the end (see loop above).

But that does not mean you can schedule what you have accumulated. And then what
do you do, i.e., rollback to what?

With incremental, you can skip a group that is conflicting with the
groups already
accumulated. What hw_perf_group_sched_in() gives you is simply a way to do
incremental on a whole event group at once.

Given the perf_event model, I believe you have no other way but to do
incremental
scheduling of events. That is the only way you guarantee you maximize the use of
the PMU. Regardless of that, the scheduling model has a bias towards smaller
and less constrained event groups.
