Return-Path: <linux-kernel-owner+w=401wt.eu-S933858AbZJPBdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbZJPBdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 21:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbZJPBdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 21:33:05 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45467 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478AbZJPBdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 21:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=P/5v6cXVaCxqlKvhjlvVrHtofDuTfC1i8jJ8dSSP9DuXJkXYgbCr/Xw51NKL5n6Evi
         6hvqs67xFsfICmUxdj0HoXs9N+49IO4o6y1/Rqp4nsiKOT+Jzc5Vqk0+UVbhAXjoqpaJ
         fgVLvYiZmZOWTrW/ECq7Mv7LLEb6wQbts2gs8=
MIME-Version: 1.0
In-Reply-To: <c7f37ead-3cf2-4277-a44e-425a7b940d31@default>
References: <4AD6B1F0.6030904@goop.org>
	 <c7f37ead-3cf2-4277-a44e-425a7b940d31@default>
Date: Thu, 15 Oct 2009 18:32:26 -0700
X-Google-Sender-Auth: d19240301a3078e7
Message-ID: <1f1b08da0910151832m59d14ac2i4add6555d6a1208a@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 05/12] xen/pvclock: add monotonicity check
From: john stultz <johnstul@us.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       "arch/x86 maintainers" <x86@kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, chris.mason@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 6:27 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
>> On 10/14/09 20:26, Dan Magenheimer wrote:
>> > As long as we are going through the trouble of making
>> > this monotonic, shouldn't it be monotonically increasing
>> > (rather than just monotonically non-decreasing)?  The
>> > rdtsc instruction and any suitably high-precision
>> > hardware timer will never return the same value
>> > on subsequent uses so this might be a reasonable
>> > precedent to obey.  E.g.
>> >
>> > +   return ret > xen_clocksource.cycle_last ?
>> > +           ret : ++xen_clocksource.cycle_last;

Oof. Modifying .cycle_last will cause timekeeping wreckage.  Please don't.
Also the above would break on SMP.

Ideally we would have moved cycle_last to the timekeeper structure,
since its a timekeeping specific value, not really clocksource
related.

However, there is the situation where we have don't have perfectly
synced TSCs, but TSCs that are very very close. In this case, the only
time we might see skew is if update_wall time were to run on the
slightly faster TSC, and then immediately after the gettimeofday()
code runs and sees the cycle_last value ahead of the rdtsc.

So the cycle_last check is hackish, but it lets folks use the much
faster TSC when we'd have to otherwise throw it out.

If you wanted something like this, a global last_tsc value could be
used and cmpxchged to ensure you always have an increasing TSC value.
However I suspect the performance hit there would be painful.

>> No, cycle_last isn't updated on every read, only on timer ticks.  This
>> test doesn't seem to be intended to make sure that every
>> clocksource_read is globally monotonic, but just to avoid
>> some boundary
>> conditions in the timer interrupt.  I just copied it directly from
>> read_tsc().
>
> I understand but you are now essentially emulating a
> reliable platform timer with a potentially unreliable
> (but still high resolution) per-CPU timer AND probably
> delivering that result to userland.
>
> Read_tsc should only be used if either CONSTANT_TSC
> or TSC_RELIABLE is true, so read_tsc is guaranteed
> to be monotonically-strictly-increasing by hardware
> (and enforced for CONSTANT_TSC by check_tsc_warp
> at boot).

Ideally, yes, only perfect TSCs should be used.

But in reality, its a big performance win for folks who can get away
with just slightly offset TSCs.

thanks
-john
