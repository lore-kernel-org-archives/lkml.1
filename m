Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZIWHoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZIWHoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZIWHoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:44:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:12675 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZIWHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wAmeHVL+5yiywkYbjreZyJWF4KXXrl5Vr1wijuqxE0ybOy5jtWDbfJ2vOdglyhvTs6
         uRXbJJAl1D9h5rSe/i+iy0e+sFm97eBlC4KJ9+q1uEnKZ+hMvB5gNiw6NSxi4K13HJEN
         +mK6QQWCv+lNmF4KGyir34hvrn1qCwac3FU2g=
MIME-Version: 1.0
In-Reply-To: <20090923074028.GA3078@elte.hu>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <20090922212453.GB6062@nowhere> <1253686585.7695.84.camel@twins>
	 <20090923073253.GA18022@elte.hu> <20090923074028.GA3078@elte.hu>
Date: Wed, 23 Sep 2009 11:44:39 +0400
Message-ID: <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com>
Subject: Re: perf sched record hangs machine
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Malley <mail@chrismalley.co.uk>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/09, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> >         .size   default_send_IPI_self, .-default_send_IPI_self
>> >
>> > Which seems to suggest that cmove is in __prepare_ICR, but I'm not
>> > sure how that can cause a page-fault, as that function is rather
>> > pointer-less.
>> >
>> > Did it maybe delay evaluating apic->dest_logical that late, it appear
>> > to be the first usage of that argument?
>> >
>> > Ingo, any ideas?
>>
>> Yeah, the problem is:
>>
>> [    0.042445] Local APIC not detected. Using dummy APIC emulation.
>>
>> we shouldnt be trying to program the lapic in that case - all ops
>> should be a NOP, including send-ipi-self. Cyrill?
>
> Cyrill, the right fix would be to define a:
>
> 	struct apic apic_none;
>
> with dummy functions injected. Set struct apic *apic to _that_, instead
> of apic_default.
>
> This means that if we manage to detect a local APIC, we will set it to
> apic_default (or some other driver) - but the bootup default will be 'no
> APIC'.
>

May it wait till evening (i'll back from office and take a look)?

> This is a lot cleaner and a lot less error-prone than the direct
> frobbing of the function pointers.
>
> 	Ingo
>
