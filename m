Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044Ab0A2XIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0A2XIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803Ab0A2XIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:08:18 -0500
Received: from smtp-out.google.com ([216.239.33.17]:10060 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab0A2XIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:08:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YzONz1gx9le5n5OrzyXG5V7k7V/LKvcsBw6hiXL9+qhAne9Jhf33qPWxx6IZCVFY/
	nlLLFgltemW4uZNU/s5AQ==
MIME-Version: 1.0
In-Reply-To: <1264442381.4283.1944.camel@laptop>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
	 <1264192074.4283.1602.camel@laptop>
	 <7c86c4471001250912l47aa53dfw2c056e3a4733271e@mail.gmail.com>
	 <1264440342.4283.1936.camel@laptop>
	 <7c86c4471001250948t2c1b06ebx2e70f30f45c81aad@mail.gmail.com>
	 <1264442381.4283.1944.camel@laptop>
Date: Sat, 30 Jan 2010 00:08:12 +0100
Message-ID: <bd4cb8901001291508w421898c2u8e8e7de32b030e67@mail.gmail.com>
Subject: Re: [PATCH] perf_events: improve x86 event scheduling (v6 
	incremental)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think there is a problem with this following code:

void hw_perf_enable(void)
                for (i = 0; i < cpuc->n_events; i++) {

                        event = cpuc->event_list[i];
                        hwc = &event->hw;

                        if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
                                continue;

Here you are looking for events which are moving. I think the 2nd
part of the if is not good enough. It is not because hwc->idx is
identical to the assignment, that you can assume the event was
already there. It may have been there in the past, then scheduled
out and replaced at idx by another event. When it comes back,
it gets its spot back, but it needs to be reprogrammed.

That is why in v6 incremental, I have added last_cpu, last_tag
to have a stronger checks and match_prev_assignment().

Somehow it is missing in the series you've committed unless
I am missing something.


On Mon, Jan 25, 2010 at 6:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-01-25 at 18:48 +0100, stephane eranian wrote:
>
>> >> It seems a solution would be to call x86_pmu_disable() before
>> >> assigning an event to a new counter for all events which are
>> >> moving. This is because we cannot assume all events have been
>> >> previously disabled individually. Something like
>> >>
>> >> if (!match_prev_assignment(hwc, cpuc, i)) {
>> >>    if (hwc->idx != -1)
>> >>       x86_pmu.disable(hwc, hwc->idx);
>> >>    x86_assign_hw_event(event, cpuc, cpuc->assign[i]);
>> >>    x86_perf_event_set_period(event, hwc, hwc->idx);
>> >> }
