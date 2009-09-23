Return-Path: <linux-kernel-owner+w=401wt.eu-S1751289AbZIWJsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbZIWJsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZIWJst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:48:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:1255 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZIWJst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:48:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y8YvCz8vq2ApNyYPmXYM/2c/iMTevsY6C/a8sggcuyS6Ud9+PdfspZj3YrY79YqK4j
         giRPt6tRLhyH5vQYRF6TaZojeUuDtsj0ngCSIVdbg5k4USqdi+CJpFMb5kWxFkGjLsOA
         Sz6EHQHAfi3xoAfL5NhVGHRVvq95fyql27yio=
MIME-Version: 1.0
In-Reply-To: <20090923092024.GA29323@elte.hu>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <20090922212453.GB6062@nowhere> <1253686585.7695.84.camel@twins>
	 <20090923073253.GA18022@elte.hu> <20090923074028.GA3078@elte.hu>
	 <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com>
	 <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com>
	 <7863dc4c0909230215u2fed3edciec84f93f24d3ae1@mail.gmail.com>
	 <20090923092024.GA29323@elte.hu>
Date: Wed, 23 Sep 2009 13:48:51 +0400
Message-ID: <aa79d98a0909230248j22f05047n34e0ee97382f573f@mail.gmail.com>
Subject: Re: perf sched record hangs machine
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Malley <mail@chrismalley.co.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/09, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Chris Malley <mail@chrismalley.co.uk> wrote:
>
>> 2009/9/23 Cyrill Gorcunov <gorcunov@gmail.com>:
>> >
>> > Btw, meanwhile Chris may try to pass lapic boot-option in attempt to
>> > reenable apic via msr registers. Also (iirc) i feel we may be hiding
>> > errors if complete noop apic would be used since i belive we need to
>> > check out under which condition a particular operation is called and
>> > when apic is disabled it's mean we're switched to UP mode and
>> > inter-cpu interrupts are under suspicion too. Will take a look during
>> > ~6 hours ;)
>> >
>>
>> Hi Cyrill
>>
>> Heh, yes that just occurred to me as well.  With the lapic boot option
>> I can't reproduce the problem, and get a good recording every time.
>> Don't know why the BIOS had disabled it (can't see any specific
>> option).
>
> Would still be important to fix the crash - there are boxes where lapics
> are disabled permanently and cannot be re-enabled. (plus most people
> dont touch their defaults and dont add funky boot options - so crashing
> is not an option)
>

Ingo, Chris, could you try Peter's patch? It seems like what we need.

(Peter, self-ipi shouldn't be separated from others ipi, yes it  may
not issue any cycle on fsb, but iirc it uses the same logic as other
ipi use)

> I have such a test-box:
>
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x8008
> [    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
> [    0.000000] Local APIC disabled by BIOS -- reenabling.
> [    0.000000] Could not enable APIC!
> [    0.000000] APIC: disable apic facility
>
> Btw., perf events can work even without a lapic (albeit without NMI
> driven sampling):
>
> [    0.052051] Performance Events:
> [    0.055138] no APIC, boot with the "lapic" boot parameter to force-enable
> it.
> [    0.056014] no hardware sampling interrupt available.
> [    0.060014] p6 PMU driver.
> [    0.062955] ... version:                0
> [    0.064014] ... bit width:              32
> [    0.068014] ... generic registers:      2
> [    0.072015] ... value mask:             00000000ffffffff
> [    0.076014] ... max period:             000000007fffffff
> [    0.080014] ... fixed-purpose events:   0
> [    0.084014] ... event mask:             0000000000000003
>
> That's what it did on your box too:
>
> [    0.013679] Performance Events:
> [    0.013705] no APIC, boot with the "lapic" boot parameter to force-enable
> it.
> [    0.013783] no hardware sampling interrupt available.
> [    0.013826] p6 PMU driver.
> [    0.013882] ... version:                0
> [    0.013922] ... bit width:              32
> [    0.013962] ... generic registers:      2
> [    0.014002] ... value mask:             00000000ffffffff
> [    0.014045] ... max period:             000000007fffffff
> [    0.014088] ... fixed-purpose events:   0
> [    0.014128] ... event mask:             0000000000000003
>
> Unfortunately i cannot reproduce the crash you've been seeing. (but i'm
> quite sure it's due to self-IPI not working fine with dummy lapic.)
>
> 	Ingo
>
