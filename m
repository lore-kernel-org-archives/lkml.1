Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYLLHSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYLLHSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYLLHSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:18:40 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:8923 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYLLHSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:18:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MdDpbEOUWaw/PTzuRGeACZIdBjQ00SDTy8wWKjmKkSQqoEDJ+VHezCg+JsnahaZiKG
         8aaBr4OD2ie/q0PDk/Ud5GzjY/knVvxD180mHErNDdy4jmnhAZfYuBT1vujbCdM3Z4Jh
         0ybj7GvFRAXj+KyAg3KJKg72IOp4iy2uJsB+U=
Message-ID: <aec7e5c30812112318t1c4bddd6n1559ea20da9debe1@mail.gmail.com>
Date: Fri, 12 Dec 2008 16:18:38 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] clocksource: add enable() and disable() callbacks
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@redhat.com
In-Reply-To: <20081212063645.GF12451@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211114909.17624.85712.sendpatchset@rx1.opensource.se>
	 <20081212063645.GF12451@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Dec 12, 2008 at 3:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Magnus Damm <magnus.damm@gmail.com> wrote:
>> +static inline int clocksource_enable(struct clocksource *cs)
>> +{
>> +     return cs->enable ? cs->enable(cs) : 0;
>> +}
>
>> +static inline void clocksource_disable(struct clocksource *cs)
>> +{
>> +     if (cs->disable)
>> +             cs->disable(cs);
>> +}
>
> why have the two different styles? The first one should be:
>
>        if (cs->enable)
>                return cs->enable(cs);
>        return 0;

Sure, that's fine too.

>> @@ -193,11 +193,16 @@ static void change_clocksource(void)
>>
>>       clocksource_forward_now();
>>
>> -     new->raw_time = clock->raw_time;
>> +     if (clocksource_enable(new))
>> +             return;
>
> that looks fragile to me: if the enable fails we'll return silently,
> while change_clocksource() assumes that things went fine. At least put a
> WARN_ON_ONCE() in there.

Yeah, John and I discussed this before. What we really want it to move
the failing clocksource out of the list of available clocksources.
That type of change is pretty intrusive though, and I rather see it as
a separate topic.

> also, why does it have to fail? If a clocksource cannot be enabled it
> should not be offered as a clocksource.

Right. I guess most clocksource drivers for embedded platforms will
tie in the clock framework and use clk_enable() and clk_disable().
clk_enable() returns an int.

>> +     clocksource_disable(old);
>
> i do agree with the core purpose here, to allow lowlevel code to
> deactivate unused clocksources.

That's good! I hope we can sort out the details then!

Cheers,

/ magnus
