Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbZFLHDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbZFLHDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZFLHDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:03:34 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:38137 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZFLHDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qxxCX1HxSTI4MFyxR9tqSIFu7c2uB0P0DLLrgBrzq6cPi9EFZjKa/3iLlnkV7FieQ/
         Y7h3G1kL1iKEAAiopwhArtVHMBiS8q9V95iXisogzul4jyvdVHrbP+Nq3M9MlNhy5keO
         p6p3qsB1bgpDkQOht79nnuYmfBTAWKV6B22Lk=
Message-ID: <4A31FDBE.3030506@gmail.com>
Date: Fri, 12 Jun 2009 00:03:26 -0700
From: Richard Henderson <rth7680@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: ink@jurassic.park.msu.ru, lkml <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
Subject: Re: [PATCH] Convert alpha to use arch_gettimeoffset()
References: <1244758210.7192.5.camel@localhost.localdomain>
In-Reply-To: <1244758210.7192.5.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> I suspect the alpha arch could even be further improved to provide and
> rpcc() based clocksource, but not having the hardware, I don't feel
> comfortable attempting the more complicated conversion (but I'd be glad
> to help if anyone else is interested).

Unfortunately this isn't possible.  The rpcc value is only 32-bits wide,
and so rolls over in approx 3 to 4 seconds.  Thus all the contortions to
try and use the truncated value for sub 1 second adjustments.

> +	delta_cycles = rpcc() - state.last_time;
> +	partial_tick = state.partial_tick;
>  	/*
>  	 * usec = cycles * ticks_per_cycle * 2**48 * 1e6 / (2**48 * ticks)
>  	 *	= cycles * (s_t_p_c) * 1e6 / (2**48 * ticks)
> @@ -448,62 +437,9 @@ do_gettimeofday(struct timeval *tv)
>  	delta_usec = ((delta_usec / ((1UL << (FIX_SHIFT-6-1)) * HZ)) + 1) / 2;
>  #endif
...
> +	return delta_usec * 1000;

If we're going to be computing nsec now, we might as well adjust
the computation here.

   nsec = cycles * ticks_per_cycle * 1e9 / HZ
        = cycles * s_t_p_c * 1e9 / (2**48 * HZ)
        = cycles * s_t_p_c * 1953125 / (2**39 * HZ)

   delta_nsec = delta_cycles*state.scaled_ticks_per_cycle + partial_tick;
   delta_nsec *= 1953125
   delta_nsec /= HZ << (FIX_SHIFT - 9 - 1);
   delta_nsec = (delta_nsec + 1) / 2;

As far as I can tell, the range of the dividend is about 7e17,
which still fits in an unsigned long.


r~

