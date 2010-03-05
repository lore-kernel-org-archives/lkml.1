Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0CEV54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:57:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:33648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab0CEV5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:57:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=Xq3o0UJo0KemK1tdxXbcPYC7+HOjh2I9sT0/HvG7CRAlKZnLU/J5IYtQ8eYcLmn5o
	L86GErCRZ1LfriWXp0b5w==
MIME-Version: 1.0
In-Reply-To: <1267825433.4997.14.camel@laptop>
References: <20100305153926.639506880@chello.nl>
	 <20100305154128.890278662@chello.nl>
	 <bd4cb8901003051058k5c3d88bewa787f88f03d2da80@mail.gmail.com>
	 <1267816553.4942.6.camel@laptop> <1267823134.4997.5.camel@laptop>
	 <bd4cb8901003051322l1722fcaaqacf0c913853d384f@mail.gmail.com>
	 <1267824933.4997.9.camel@laptop>
	 <bd4cb8901003051338p1c12ceacv994bad73e81093a2@mail.gmail.com>
	 <1267825433.4997.14.camel@laptop>
Date: Fri, 5 Mar 2010 13:57:49 -0800
Message-ID: <bd4cb8901003051357o357ac7adt7cb56b5deb4089dd@mail.gmail.com>
Subject: Re: [PATCH 3/5] perf, x86: Disable PEBS on clowertown chips
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 1:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-03-05 at 13:38 -0800, Stephane Eranian wrote:
>> On Fri, Mar 5, 2010 at 1:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, 2010-03-05 at 13:22 -0800, Stephane Eranian wrote:
>> >> > The two serious ones, AJ106 and AJ68 are no fix and are listed as such
>> >> > in all errata I can find, including the 7[23]00 series.
>> >> >
>> >> Not E74xx. I think it would be fine to drop LBR with PEBS as the work-around
>> >> to AJ106.
>> >>
>> >> > I checked the 65nm Core2Duo, Xeon 5200 and Xeon 7[23]00 spec updates.
>> >> > Going by that it seems the full model 15 family is broken and I'll leave
>> >> > the patch as is.
>> >>
>> >> But the E74xx are okay and you are excluding them. Worst case you should
>> >> provide an override.
>> >
>> > >From what I can tell E74xx is model 29, which would be just fine with
>> > this patch, this patch only marks model 15 as broken.
>> >
>> True, my bad.
>> So it would be a matter to provide some ways of disabling LBR with PEBS
>> on model 15.
>
> And some way of dealing with the flaky PEBS PMI, which requires we
> program the pebs_event_reset thing otherwise there won't be a next PEBS
> record to re-trigger the PMI.
>
> If it would have stated it always did the threshold comparison first and
> then the index increment, so that we'd always trigger on the second
> record we could simply program half the period and always take two and
> ignore the first, but it says _MAY_, so its a race and there's no
> reliable solution.
>
> It might all be possible but I don't see it being worth the effort.
>
There are lots of model15 out there, like the Q6xxx series.

When I read AJ68, my understanding is that it's not that you do not
get the interrupt. It will be delayed by one event. The buffer will become
full. You won't overrun the buffer, you will get the interrupt at the next
event. On interrupt, you have to reset the PEBS position pointer anyway.
There is already a disconnect between the sampling period and the actual
instruction sampled. That's not making the situation that much worse, unless
I am missing something.
