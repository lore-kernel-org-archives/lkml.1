Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYK0KJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYK0KJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYK0KJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:09:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:19557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbYK0KJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=urkEKuTRh186NJH+Xw+T6Mmatec2PV7fEN3jgzxk7Q1WlCjq/t7h76hQOhpgfhUwDe
         trc2Anqj17JRkE3tXXdhrd7tMShJZW9J5DE0YAYRNGmznUYo2bTEiDHtd8qp3M3tOP8m
         nDMR6UlWNOYEmffVlqYLD7pSiMl/RFKaa38Yc=
Message-ID: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
Date: Thu, 27 Nov 2008 11:09:37 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <20081127100602.GF6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
	 <20081126140054.GX6703@one.firstfloor.org>
	 <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>
	 <20081127100602.GF6703@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, Thomas,

On Thu, Nov 27, 2008 at 11:06 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Nov 26, 2008 at 11:54:30PM +0100, Thomas Gleixner wrote:
>> On Wed, 26 Nov 2008, Andi Kleen wrote:
>> > On Wed, Nov 26, 2008 at 02:35:18PM +0100, Thomas Gleixner wrote:
>> > > > +        */
>> > > > +       pfm_arch_resend_irq(ctx);
>> > >
>> > > Do we really need this whole NMI business ?
>> >
>> > Without it you cannot profile interrupts off regions well.
>>
>> Fair enough, but I doubt that this is a real solution.
>>
>> There is not even an attempt to avoid the obvious wrmrsl races, while
>> there are several comments which explain how expensive wrmrsl is. In
>> the NMI handler we enable the NMI right away. This might cause
>> multiple NMIs for nothing when the NMIs hit between the manipulations
>> of the counters. Not likely but can happen depending on the counter
>> settings.
>>
>> Sending an self-IPI from NMI simply sucks: For every NMI we get an
>> extra local interrupt and we have an extra of 2 * NR_ACTIVE_COUNTERS
>> accesses to MSRs.
>
> In newer Intel the counters can be reset/rearmed by accessing
> only a few global control msrs. But it's probably still a problem
> on other PMUs.
>
> On the other hand it also has PEBS which allows at least some
> profiling of irq-off regions without using NMIs.
>>
>> Designing that code to use lockless buffers instead is not really
>> rocket science.
>
> Lockless buffers are nasty, but it works in oprofile at least.
>
> Taking out NMis in the first version at least seems like a reasonable
> solution. After all you can still use standard oprofile where they work
> just fine.
>
The only reason why I have to deal with NMI is not so much to allow
for profiling irq-off regions but because I have to share the PMU with
the NMI watchdog. Otherwise I'd have to fail  or disable the NMI watchdog
on the fly.
