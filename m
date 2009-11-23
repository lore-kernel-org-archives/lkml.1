Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZKWNeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZKWNeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 08:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZKWNeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 08:34:00 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37647 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZKWNd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 08:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=wMfQKqcsLl2QpfjbKU7TVN4UqcZ0d/54KcicbJVQ8phEDH04gePHwjyuIRFHm8RLDo
         lXmVk7uRym/srMjdWiaKFprwei3QnSOTgZvLBP8WAH6LhCMH36zh4QPE/dR9CUs6iZxA
         T022gusidcFeJBcfmORllzNnO3Vbe7FjdX/UU=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1258562785.3918.685.camel@laptop>
References: <1256223091-6002-1-git-send-email-eranian@gmail.com>
	 <1258562785.3918.685.camel@laptop>
Date: Mon, 23 Nov 2009 14:34:04 +0100
Message-ID: <7c86c4470911230534i4119734k1478550567852220@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix validate_event bug
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net, eranian@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay,

On Wed, Nov 18, 2009 at 5:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2009-10-22 at 16:51 +0200, Stephane Eranian wrote:
>>       The validate_event() was failing on valid event
>>       combinations. The function was assuming that if
>>       x86_schedule_event() returned 0, it meant error.
>>       But x86_schedule_event() returns the counter index
>>       and 0 is a perfectly valid value. An error is returned
>>       if the function returns a negative value.
>
> Good point.
>
>>       Furthermore, validate_event() was also failing for
>>       event groups because the event->pmu was not set until
>>       after hw_perf_pmu_init().
>
> (hw_perf_event_init, right?)
>
Yes.

> Won't this give very funny results for mixed pmu groups?
>

What do you mean by 'mixed pmu groups'?

> How about something like:
>
>  if (event->pmu && event->pmu != &pmu)
>        return 0;
>
> That should deal with new events, who do not yet have their pmu set and
> for those we know they're for us, but exclude events for other PMUs.
>
>>       Signed-off-by: Stephane Eranian <eranian@gmail.com>
>> --
>>  arch/x86/kernel/cpu/perf_event.c |    5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
>> index 2e20bca..d321ff7 100644
>> --- a/arch/x86/kernel/cpu/perf_event.c
>> +++ b/arch/x86/kernel/cpu/perf_event.c
>> @@ -2229,10 +2229,7 @@ validate_event(struct cpu_hw_events *cpuc, struct perf_event *event)
>>  {
>>       struct hw_perf_event fake_event = event->hw;
>>
>> -     if (event->pmu != &pmu)
>> -             return 0;
>> -
>> -     return x86_schedule_event(cpuc, &fake_event);
>> +     return x86_schedule_event(cpuc, &fake_event) >= 0;
>>  }
>>
>>  static int validate_group(struct perf_event *event)
>
>
>
