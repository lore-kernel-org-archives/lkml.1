Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYJHS5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYJHS5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 14:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYJHS5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 14:57:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:41158 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYJHS5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 14:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cDt/f22DZ7+8d0jB4KUm5w5UnFRnUVeMECn+Jf7zH9z3oh5Sn71OikqNRY5Ju6AMk0
         S6vXGTGfErENk/povdTNr8dy/oLlHXWQb3HEGm4JXL44eI7ZweCdF3NPkKVsaYnDn12z
         fWvOhBTR5pfjOGS0si1nQJhF9nrtbVURI5Rsg=
Message-ID: <3efb10970810081157s5e0f8034n63856d2da42b3ad3@mail.gmail.com>
Date: Wed, 8 Oct 2008 20:57:30 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: Toggling GPIO at 38Khz
Cc: "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
X-Google-Sender-Auth: d720cf5d01f051a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jon,

> So how do I reliably generate 38Khz without destroying latency in the
> system? I also don't want to measure the speed of the code I'm
> executing - same code has to run on 90Mhz ARM and 3Ghz Core2. If a do
> a loop with nanosleep() I need to know how fast my code is to subtract
> it's execution time form the sleep time. The existing LIRC code works
> this way and measures it's timing loop.
> hrtimers look promising, but hrtimers doesn't have a periodic API. Is

Hm, 38 kHz is a period time of 26us, for a simple clock you need at
least a twice this frequency, so you need a interrupt every 13us.
Looking at a 200MHz ARM processor (AT91 for example), the HRtimer
framework causes about 100-150us of work after each interrupt. So,
that will probably not work on a 90MHz processor...
nanosleep has similar effects in the system, so that will not work either.
Looking at a worst case interrupt latency of about 50us (still at
200MHz ARM) you still won't get an accurate 13us interval, and then we
are not talking about the execution time of the code you want at this
frequency...

So, if you want such things use a FIQ on ARM, or handle the whole
burst on a busy-idle base, while polling some accurate timer routine
(like sched_clock() for example if its implementation is accurate
enough, and do it in a non-preemptable section, 1 preemption and you
might be preempted for 50us or more), but then you will also run into
problems because of the lengthy execution time (0.79ms)...
Notice that on X86 this is not doing much better, on preempt-RT, the
worst case latency on X86 is about 30us...

So, this will not be an easy job... You probably know by now why it is
implemented this way currently in LIRC...


Good luck ;-)


Remy


> there a technique for creating periodic timing that doesn't accumulate
> error caused by rescheduling the timers?  If I need to send 30 pulses
> of 38Khz, it is more important that the total time be (1/38000)*30 =
> 0.7894ms than it is for each pulse to be generated at exactly 26.3us
> intervals.
>
> Are there other techniques for generating pulse trains in the 36-56Khz
> range on a simple GPIO pin? Anyone have some sample code?
>
> --
> Jon Smirl
> jonsmirl@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
