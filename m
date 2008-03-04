Return-Path: <linux-kernel-owner+w=401wt.eu-S933480AbYCDUWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480AbYCDUWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763259AbYCDUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:22:28 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:11727 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYCDUW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rcQXdAVAdH5sSC/zqMyQmvya51UC8bnv21Sof9W2+jnMo5wMnGIkidNxdm3G6d+kXEIQ8g5xvUlgpe4fFZt99x1tsJP/qxQR9/Y74KoiRGV6HGPauhu4VQYfupONfetv0IeouhW29Y3m99KdGClVgX8LiJYXr3cpTzYEOAxuDZo=
Message-ID: <3efb10970803041222j61fd8d28k5cef0994b9bd6f12@mail.gmail.com>
Date: Tue, 4 Mar 2008 21:22:24 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "David Brownell" <david-b@pacbell.net>,
       "Bosko Radivojevic" <bosko.radivojevic@gmail.com>
Subject: Re: High resolution timers on AT91SAM926x
Cc: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <200803031729.19264.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803011457.40857.david-b@pacbell.net>
	 <200803031039.57909.david-b@pacbell.net>
	 <d6c8ef150803031342r567aab86x776dc2a8b73714b6@mail.gmail.com>
	 <200803031729.19264.david-b@pacbell.net>
X-Google-Sender-Auth: a139399f2ed671d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bosko/Dave,

> On Monday 03 March 2008, Bosko Radivojevic wrote:
>
> > I had CONFIG_ATMEL_TCLIB enabled, but not TCB_CLKSRC and
>  > TCB_CLKSRC_BLOCK=0. With all those options, I finally have HRT
>  > functionality. But, strange thing is that jitter of my little example
>  > (get time, sleep 1ms, get time, show the difference) is around 250us.
>  > Maybe this is normal for this architecture?
> I have no idea why that would be.  Maybe you can find out.  :)

These are normal figures for this core, on preempt-rt.
You are talking about jitter on timers. While on preempt-rt the worst
case latency of scheduling a RT-thread is about 300us, 250us is thus
quite normal, and actually quite good... (the kernel-mainline average
latency is better, but worst-case is unbound)
(Note: The 300 us seem to be caused by something in the networking
layer, without network I noticed worst case latencies about 150us, but
NO guarantee here)

But, besides the worst-case schedule latency; the interrupt handler is
shared with the handler of the DBGU. There are patches available to
split the interrupt handler, this will make this behavior somewhat
better, but do not expect miracles here.

I stopped using HRT on these cores and preempt-RT for quite some time
now (several months), because the smaller timer granularity will allow
applications to make timers elapse on sub-millisec intervals, where
each interval generates a interrupt handling cycle of about 50 -
>100us, especially if different applications use periodic timers which
are out of sync.
This will become visible as extreme CPU-load figures on applications
with 1 ms timers.
13-15% CPU load on a application with just 1 single 1 ms timer is
quite normal...

FWIW: For getting the most accurate realtime response for periodic
timers, I used a TC block to generate a periodic interrupt, that only
needs to wake up a RT-thread. This way the OS-timer framework can be
used for non-RT stuff, and/or slow timers. This is much less heavy on
this core, and gives much better/deterministic RT results.
(This is not what I prefer to do, but these cores are just not that
fast as multi-gigahertz X86 PCs ;-)) )


Kind Regards,

Remy

>
>
>
>  > System is (as noted on rt.wik site) very slow with NO_HZ option enabled.
>
>
> It doesn't exactly say *why* or compare to other arm926ejs
>  chips ...
>
>  Could the 64-bit math (ktime stuff) be a factor there?  Your
>  board probably only runs at 95 (or-so) bogomips after all.
>
>  And is that just a NO_HZ issue, or generically an issue when
>  oneshot timer modes are in heavy use?
>
>  - Dave
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>
> the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Please read the FAQ at  http://www.tux.org/lkml/
>
