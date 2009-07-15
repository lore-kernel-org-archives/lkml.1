Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZGOWzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZGOWzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZGOWzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:55:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54357 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbZGOWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:55:20 -0400
Subject: Re: Carefully chosen CYC2NS_SCALE_FACTOR ??
From: john stultz <johnstul@us.ibm.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, george@mvista.com,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247666603.11358.62.camel@nathan.suse.cz>
References: <1247666603.11358.62.camel@nathan.suse.cz>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 15:54:36 -0700
Message-Id: <1247698476.7511.179.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 16:03 +0200, Petr Tesarik wrote:
> Hi,
> 
> I'm having trouble understanding the rationale behind the choice for
> CYC2NS_SCALE_FACTOR in arch/x86/include/asm/timer.h:
> 
> #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
> 
> Why on Earth is this 10?

Oh yikes. Its been awhile since I wrote that. 

Had to dig through my mail archive to find it, but that was written up
in 2003 for 2.5.66 and the cycles_2_ns/set_cyc2ns_scale functions
weren't even used for sched clock back then. I introduced it for the
monotonic_clock() functionality. Here's the original patch:
	http://marc.info/?l=linux-kernel&m=104915471311051&w=2


But point taken: its a terribly unhelpful comment!

> AFAICS this constant is the position of the decimal point in the
> fixed-point cycle-to-nanoseconds computations. It is computed as
> follows:
> 
>                 *scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;

So one minor tweak, I don't think we really *mean* NSEC_PER_MSEC there,
but just 10^6, as its NSEC_PER_SEC/1000 (since the freq is stored in
khz). Don't know when that changed, but it doesn't really make it any
more clear whats going on. The comment above this code is more correct
in explaining how we calculate the scale value (but not so much the
scale_factor :)


> Now, NSEC_PER_MSEC is 10^6, the size of cyc2ns is 32 bits and cpu_khz,
> being an integer, cannot be less than 1. So, if I want maximum accuracy,
> I should choose the maximium CYC2NS_SCALE_FACTOR such that:
> 
> 10^6 * 2^CYC2NS_SCALE_FACTOR < 2^32
>
> Which transforms to:
> 
> CYC2NS_SCALE_FACTOR = floor(log2(2^32/NSEC_PER_MSEC)) = 12
> 
> Did I miss an obvious reason for not using the scale factor of 12?

No. At this point you're probably right.

The hangcheck timer had a very large interval, 180 seconds, so we
probably expected to have to deal with 2x that number in cycles. So
something on the order of 1 trillion cycles @4ghz. The concern was that
(cyc * cyc2ns_scale) had to not overflow 64bits, so cyc2ns_scale had to
be less then about 24 bits. But even with that consideration, 2^12 works
fine, as we divide out the cpu_khz value.

So yea, your analysis looks fine. 

I suspect you could change the code to use 12, but probably reworking
sched_clock to use the TSC clocksource and its orig_mult/shift values
would be a better cleanup. The cyc_2_ns is pretty redundant to the
cyc2ns code used by the timekeeping core.

thanks
-john


