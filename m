Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZGGICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZGGICS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZGGIB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:01:59 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44914 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZGGIB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YiUVlR/sA5XuogH4QP/dnICM86mTpP57As7PgjZiS3odf3yHtDBp1BP2syQlPhFfHp
         S0p2VkfMi89ALzNzZ0MprhJ/hD3528ghbifxjBonD6GUcg8FwgUguRM+uM2L4h5tD274
         ZWMxSq2gBukr6nbAms318PXSrVf+gpZz9Izqc=
MIME-Version: 1.0
In-Reply-To: <20090707074243.GA6995@n2100.arm.linux.org.uk>
References: <63386a3d0905112337p2d426481o5f9bf9b9489cc57e@mail.gmail.com>
	 <63386a3d0905231446h245bb4a9gec111f68a74a44e4@mail.gmail.com>
	 <1243151839.26820.642.camel@twins>
	 <63386a3d0905250513q6ca56eeepcf7bebe46c447fb4@mail.gmail.com>
	 <1243256510.26820.679.camel@twins>
	 <63386a3d0906010046k3b86d70av3e290fc26c2934f5@mail.gmail.com>
	 <1243933212.23657.5726.camel@twins>
	 <20090707074243.GA6995@n2100.arm.linux.org.uk>
Date: Tue, 7 Jul 2009 10:01:58 +0200
Message-ID: <63386a3d0907070101g51026139rb40635a26a4826a7@mail.gmail.com>
Subject: Re: [PATCH] U300 sched_clock implementation
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding in Paul M since it was his patch that was supposed to fix up a
generic solution...

2009/7/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, Jun 02, 2009 at 11:00:12AM +0200, Peter Zijlstra wrote:
>> On Mon, 2009-06-01 at 09:46 +0200, Linus Walleij wrote:
>> > 2009/5/25 Peter Zijlstra <peterz@infradead.org>:
>> > > On Mon, 2009-05-25 at 14:13 +0200, Linus Walleij wrote:
>> > >> 2009/5/24 Peter Zijlstra <peterz@infradead.org>:
>> > >>
>> > >> > On Sat, 2009-05-23 at 23:46 +0200, Linus Walleij wrote:
>> > >> >
>> > >> >> This overrides the global sched_clock() symbol in the Linux
>> > >> >> scheduler with a local implementation which takes advantage of
>> > >> >> the timesource in U300 giving a scheduling resolution of 1us. The
>> > >> >> solution is the same as found in the OMAP2 core code.
>> > >> >
>> > >> > We assume sched_clock() to return time in ns (e-9) resolution.
>> > >>
>> > >> Yep okay and in this case:
>> > >>
>> > >> >> +       ret = (unsigned long long) u300_get_cycles();
>> > >> >> +       ret = (ret * clocksource_u300_1mhz.mult_orig) >>
>> > >> >> +               clocksource_u300_1mhz.shift;
>> > >> >> +       return ret;
>> > >>
>> > >> (mult_orig >> shift) == 1000
>> > >
>> > > Ah, ok -- missed that little detail ;-)
>> > >
>> > >> So for each cycle in cyclecount register we return 1000 * cycles
>> > >> i.e 1000ns.
>> > >>
>> > >> If it looks nicer we can of course simply:
>> > >> return (unsigned long long) u300_get_cycles * 1000;
>> > >>
>> > >> But the question here is whether this resolution is enough for
>> > >> sched_clock() or if it is irrelevant to override sched_clock()
>> > >> if it cannot schedule with better precision than 1000 ns.
>> > >
>> > > No anything better than jiffies is good, 1us certainly is worth the
>> > > trouble.
>> >
>> > Can I interpret this as Acked-by: Peter Zijlstra <peterz@infradead.org> ?
>>
>> I think its best if we continue with the patch Paul Mundt has been
>> proposing.
>
> [added Tim Bird to CC]
>
> So what do we do?  There's apparantly been zero movement on this for
> over a month, and Tim Bird is reposting his patch adding __notrace
> to ARMs existing sched_clock implementations.
>
> Given that it seems the generic approach has died a death, I suggest we
> merge Linus' U300 patch, and get Tim to redo his patch to take account
> of that, and apply both.
>
> Then, if the generic approach eventually happens, everything can then be
> fixed up.
>
> Alternatively, if there is movement on the generic approach...
>
> Discuss.
>

I would really like to see Pauls work finalized, it looked very promising,
and I think there was actually a rough consensus about his last patch.
But I guess that will be in the 2.6.32 merge window earliest?

Yours,
Linus Walleij
