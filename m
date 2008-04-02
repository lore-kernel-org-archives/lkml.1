Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYDBX7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYDBX7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757079AbYDBX7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:59:03 -0400
Received: from mout3.freenet.de ([195.4.92.93]:34574 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146AbYDBX7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:59:01 -0400
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: gettimeofday() jumping into the future
Date: Thu, 3 Apr 2008 00:57:31 +0100
User-Agent: KMail/1.9.9
Cc: John Stultz <johnstul@us.ibm.com>, Tim Ricketts <tr@earth.li>,
       Michael Smith <msmith@xiph.org>, LKML <linux-kernel@vger.kernel.org>,
       Andy Wingo <wingo@fluendo.com>, Ingo Molnar <mingo@elte.hu>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <1206979407.6175.2.camel@jstultz-laptop> <alpine.LFD.1.10.0804021254420.3219@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804021254420.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804030157.32086.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. April 2008 schrieb Thomas Gleixner:
> 
> Subject: x86: tsc prevent time going backwards
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Tue, 01 Apr 2008 19:45:18 +0200
> 
> We already catch most of the TSC problems by sanity checks, but there
> is a subtle bug which has been in the code for ever. This can cause
> time jumps in the range of hours.
> 
> This was reported in:
>      http://lkml.org/lkml/2007/8/23/96
> and
>      http://lkml.org/lkml/2008/3/31/23
> 
> I was able to reproduce the problem with a gettimeofday loop test on a
> dual core and a quad core machine which both have sychronized
> TSCs. The TSCs seems not to be perfectly in sync though, but the
> kernel is not able to detect the slight delta in the bootup sync
> check. There exists an extremly small window where this delta can be
> observed with a real big time jump. So far I was only able to
> reproduce this with the vsyscall gettimeofday implementation, but in
> theory this might be observable with the syscall based version as
> well.
> 
> CPU 0 updates the clock source variables under xtime/vyscall lock and
> CPU1, where the TSC is slighty behind CPU0, is reading the time right
> after the seqlock was unlocked.
> 
> The clocksource reference data was updated with the TSC from CPU0 and
> the value which is read from TSC on CPU1 is less than the reference
> data. This results in a huge delta value due to the unsigned
> subtraction of the TSC value and the reference value. This algorithm
> can not be changed due to the support of wrapping clock sources like
> pm timer.
> 
> The huge delta is converted to nanoseconds and added to xtime, which
> is then observable by the caller. The next gettimeofday call on CPU1
> will show the correct time again as now the TSC has advanced above the
> reference value.
> 
> To prevent this TSC specific wreckage we need to compare the TSC value
> against the reference value and return the latter when it is larger
> than the actual TSC value.

Last paragraph IMO should be:
	To prevent this TSC specific wreckage we need to substract the
	reference value from the TSC value, interpret the result as
	signed. If the interpreted result is negative, return the reference
	value, else the TSC Value.
Your patch misses the corner case where TSC value is < reference _and_ valid
at TSC wrap around.

The access to the reference value needs a (the xtime ?) lock on 32bit, no?

Thanks,
      Karsten
