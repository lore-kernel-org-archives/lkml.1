Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZFNKUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZFNKUW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZFNKUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:20:12 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:38598 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZFNKUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Pfy+llPblD6MC5FemSUmQUJBmGvgmT7ytqXYDyF6RrOG++QPafiJBGEFY92bHjwQ+q
         PPT11EAcKJ3N+z/nNNm0gnmCOHGV8if8c3BunT1qy7lMljEOTbqmjfmsn3Kk46Vy0z/d
         Hw+XMun3jlPzZSnlle9JNcCbZ8pVR5weZapJI=
MIME-Version: 1.0
In-Reply-To: <1244850967.7231.26.camel@localhost.localdomain>
References: <20090501054546.8193.10688.sendpatchset@rx1.opensource.se>
	 <1244667895.8085.20.camel@localhost.localdomain>
	 <aec7e5c30906102251n36bbe6f9x9b384131f332d4d9@mail.gmail.com>
	 <1244850967.7231.26.camel@localhost.localdomain>
Date: Sun, 14 Jun 2009 19:20:12 +0900
Message-ID: <aec7e5c30906140320r4d24c9efqb2bc2e30d715de02@mail.gmail.com>
Subject: Re: [PATCH] clocksource: setup mult_orig in clocksource_enable()
From: Magnus Damm <magnus.damm@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 8:56 AM, john stultz<johnstul@us.ibm.com> wrote:
> On Thu, 2009-06-11 at 14:51 +0900, Magnus Damm wrote:
>> On Thu, Jun 11, 2009 at 6:04 AM, john stultz<johnstul@us.ibm.com> wrote:
>> > Is there really no way to calculate the mult value prior to
>> > registration? Maybe quickly enabling, getting the freq, and then
>> > disabling?
>>
>> I can't think of any way that would work. The clock frequency can be
>> changed while the clock is disabled. And we can only know the rate
>> after enabling the clock, see these lines from include/linux/clk.h:
>>
>> /**
>>  * clk_get_rate - obtain the current clock rate (in Hz) for a clock source.
>>  *              This is only valid once the clock source has been enabled.
>>  * @clk: clock source
>>  */
>> unsigned long clk_get_rate(struct clk *clk);
>
> Hrmm.. Yuck.
>
> Is this really expected behavior that a clk would change frequencies
> between uses as a clocksource?

Yes, I think so. The clock frequency can change through cpufreq or
clk_set_rate().

> Do you have some examples where this code is actually used?

Everywhere. =) Many embedded platforms use the clock framework for
(runtime power) management of clocks, and clk_get_rate() is the
standard way of getting the frequency of a certain clock. Just grep in
drivers/, or check out the timer code currently used by SuperH in
driver/clocksource/ or drivers/clocksource/tcb_clksrc.c.

>> > So this seems like it will break if a clocksource is switched away from
>> > and then back to (the reason we added mult_orig in the first place).
>> > Since the re-enabled clocksource would then save off its modified mult
>> > value into mult_orig.
>>
>> Oh, I see. Sorry about that. I wonder if adding a "cs->mult =
>> cs->orig_mult;" to clock_disable() would help?
>
> Technically it would. Although we lose the corrective factor that had
> already been applied, but that should readjust fairly quickly.
>
> So yea, at a minimum setting mult back to orig_mult would be needed for
> this patch to work.

Want me to write a patch for it, or do you prefer to handle it yourself?

> However, its just ugly. I don't really like the idea of clocksources
> freq changes under us (even if they're not actively in use). But I may
> have to just deal with the reality. :(

Yeah, I agree that the mult/org_mult save/restore code is far from
pretty. Unfortunately I think we all have to live with that unused
clocks can get their frequencies changed. It's just the way the clock
framework is designed. I'm open to any suggestions how to deal with it
in a cleaner way...

Another option would be that we don't register multiple clocksources -
only one at a time - but I then we would have to invent some layer on
top of clocksources. I prefer registering a bunch of clocksources and
letting the generic clocksource code use the rating to decide which
one to enable. I think that's pretty close to how x86 does things, no?

Any ideas?

Cheers,

/ magnus
