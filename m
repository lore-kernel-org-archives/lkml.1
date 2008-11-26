Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYKZVh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYKZVh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKZVhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:37:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:18497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYKZVhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:37:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=SRwdurXBLZGsOnSIR1qTjHwBrYg2EpBLiDQ9xAbdkgxKSVKArrj6gmFaG3I8O9INPP
         fkm0EYaGxE1ZC5sCVpINnh6S0h9CvjTWICIasIn3Et6f1YEqhipng6BGFjvGun3BqECG
         d+u3zKR7RRNQfzBJJh2Aumhuxa+DeiiGsfbKc=
Message-ID: <7c86c4470811261337ic1ea828me5e3ba0de469f4b6@mail.gmail.com>
Date: Wed, 26 Nov 2008 22:37:07 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811262156390.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
	 <20081126140054.GX6703@one.firstfloor.org>
	 <alpine.LFD.2.00.0811262156390.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Wed, Nov 26, 2008 at 10:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 26 Nov 2008, Andi Kleen wrote:
>
>> On Wed, Nov 26, 2008 at 02:35:18PM +0100, Thomas Gleixner wrote:
>> > > +  *        does not work with other types of PMU registers.Thus, no
>> > > +  *        address is ever exposed by counters
>> > > +  *
>> > > +  *      - there is never a dependency between one pmd register and
>> > > +  *        another
>> > > +  */
>> > > + for (i = 0; num; i++) {
>> > > +         if (likely(pfm_arch_bv_test_bit(i, set->used_pmds))) {
>> > > +                 pfm_write_pmd(ctx, i, set->pmds[i]);
>> > > +                 num--;
>> > > +         }
>> > > + }
>> >
>> >   This loop construct looks scary. It relies on set->nused_pmds >=
>> >   bits set in set->used_pmds. I had to look more than once to
>> >   understand that. It's used all over the code in variations.
>>
>> FWIW this loop style tripped me up during review too.
>
> It's even worse than I thought when looking at it a second time:
>
> All the loops iterate over an array which means in the worst case we
> do full array_size iterations. In each iteration we check whether the
> corresponding bit in the bitmask is set or not.
>
> What a nonsense. We have a bitmask already. Why not iterate over the
> bitmask and be done ?
>

Bitmask can be sparsed. Num represents the number of bits we have to find.
The idea is that we don't need to scan the entire bitmask, we stop as soon as
we have found all the bits we care about (i.e., all the bits that are set).

Example:
         num = 3
     bitmask=0000000010001001
                                    ^ we will iterate until we are
done with that bit.
