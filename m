Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab0BDQf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:35:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0BDQf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:35:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bpC70xmp5EQeW0HCtVzYl+owIrtsi020mJhAOSlpqJGCboCwcMhJzpqbQOn08Xlek
	zsszXz62BhM7QxgvsmodA==
MIME-Version: 1.0
In-Reply-To: <bd4cb8901002040832h15bbabfctd216fa07a94a78e6@mail.gmail.com>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
	 <1265295302.24455.2265.camel@laptop>
	 <bd4cb8901002040805k759ae239q80e42f8ac4cc0e0e@mail.gmail.com>
	 <1265300375.22001.102.camel@laptop>
	 <bd4cb8901002040832h15bbabfctd216fa07a94a78e6@mail.gmail.com>
Date: Thu, 4 Feb 2010 17:35:24 +0100
Message-ID: <bd4cb8901002040835n4b58f43fr3d8f0f710794c804@mail.gmail.com>
Subject: Re: [PATCH] perf_events: AMD event scheduling (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> What I'm worried about is:
>>
>> CPU A and B are of the same NorthBridge and all node counters are taken.
>>
>> CPU-A                   CPU-B
>>
>> perf_disable();
>> event->pmu->disable(event)
>>  x86_pmu.put_event_constraint() /* free slot n */
>>
>>                        event->pmu->enable(event);
>>                          x86_schedule_events();
>>                            x86_pmu.get_event_constraint() /* grab slot n */
>>
>> event->pmu->enable(event)
>>  x86_schedule_events()
>>    x86_pmu.get_event_constraint() /* FAIL */
>> perf_enable();
>>
>> That means you cannot disable/enable the same event within a
>> perf_disable/enable section.
>>
> Yes but I would say that is because of the logic behind the enable/disable
> interface. Here you are disabling "for a short period", you know you're going
> to re-enable. Yet you are using an API that is a generic enable/disable.
> You would need to pass some argument to disable() to say "temporary"
> or "stop but don't release the resource".
>
I think if you were to distinguish between "stop the counter", and
"free the counter"
things would work better here.
