Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZKHV7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZKHV7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 16:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbZKHV7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 16:59:38 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:46056 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZKHV7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 16:59:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=guMfIIMFqQvH5HgsK9tUKkrJuBzGBulMPwO9HzeizUqYg5+cxKM0Z9GUk90QViBGAu
         fb/kLHTJVlDKO8sFfADhIvSqb+xwpDYTno7bGKDHVw/ThePVCru4Ucwnm1KOijFZtc42
         gC1FApONC5AlFWoHXCpJR20b0gy2H5bM2/Jmw=
MIME-Version: 1.0
In-Reply-To: <20091108124035.23d53197@infradead.org>
References: <20090915054259.5282e5ba@infradead.org>
	 <4e5e476b0911040139h1f471627la4262a5fa66abab0@mail.gmail.com>
	 <20091108124035.23d53197@infradead.org>
Date: Sun, 8 Nov 2009 22:59:43 +0100
Message-ID: <4e5e476b0911081359x32d7a6c4x61ee3af92dc0c8a1@mail.gmail.com>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO performance
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       jens.axboe@oracle.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 9:40 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 4 Nov 2009 10:39:13 +0100
> Corrado Zoccolo <czoccolo@gmail.com> wrote:
>
>> Hi Arjan,
>> On Tue, Sep 15, 2009 at 4:42 AM, Arjan van de Ven
>> <arjan@infradead.org> wrote:
>> > From: Arjan van de Ven <arjan@linux.intel.com>
>> > Subject: cpuidle: Fix the menu governor to boost IO performance
>> >
>> > Fix the menu idle governor which balances power savings, energy
>> > efficiency and performance impact.
>>
>> I've tested this patch on an Atom based netbook with SSD, and I see
>> 10% improvement in latencies for reading a single 4k block from disk.
>
> great!
>
>>
>> During this test, while looking at powertop, I found that my CPU was
>> sitting in polling mode for milliseconds (percentage was however
>> negligible).
>> I never recalled seeing a non-zero time spent polling, so I looked at
>> the patch and found:
>> > +       /*
>> > +        * We want to default to C1 (hlt), not to busy polling
>> > +        * unless the timer is happening really really soon.
>> > +        */
>> > +       if (data->expected_us > 5)
>> > +               data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
>> Commenting the if, (the previous behaviour), I no longer see the
>> polling, while I still get the performance improvement.
>>
>> I wonder if that '5' is a bit too much. According to my BIOS ACPI
>> table, the Atom latency for C1 is ~ 1us, so there is very little
>> payback in polling on such processors. Should the check use the ACPI
>> declared C1 latency to decide whether we should poll or go to C1?
>
> the exit latency is +/- 1 us, the entry latency is similar, and then
> you're pretty close to 5 already (esp if you keep in mind that to break
> even on energy you also need to be in the C state for a little bit)...

There are also performance considerations for using C1 (HLT).
Quoting from http://www.intel.com/Assets/PDF/manual/248966.pdf (8-19):
On processors supporting HT Technology, operating systems should use the HLT
instruction if one logical processor is active and the other is not.
HLT will allow an idle
logical processor to transition to a halted state; this allows the
active logical
processor to use all the hardware resources in the physical package.
An operating
system that does not use this technique must still execute
instructions on the idle
logical processor that repeatedly check for work. This “idle loop”
consumes execution
resources that could otherwise be used to make progress on the other
active logical
processor.

>
>>
>> An other consideration is that sometimes, even if we expect to idle
>> for a short time, we end up idling for more (otherwise I would never
>> have seen ms polling, when expecting at most 5us). Should we set up a
>> timer, that would fire when switching to an higher C state would
>> conserve more energy?
>
> this check is supposed to catch the known timer cases; those
> are rather accurate in prediction

Unfortunately, I have seen polling residency times > 1ms, so it must
not be so accurate.
Could be that the timer already expired, when we started polling, or
the wake-up went to an other CPU?
Having a timer for the specific CPU that is going idle would help in
such cases, as well as other cases like the governor chosen to go to
C3, but due to BM restrictions, the driver could only achieve C2.

Corrado

>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
