Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZEGQg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZEGQg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbZEGQgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:36:17 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:43303 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZEGQgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=f0Lxh4m3LWKknWRXzdoqAPQ7NA9BYZFydf+OVvBEhECzDQaT0zUIEmj6XbCvufEwp1
         SQ0/W95QbkhpzJ2sQ+2KqULQ/jt6SXZXKb5eSd545oxPUBAFspkOLahoFZEWBgwkbwuG
         X7YDbD7QpQ7ADK8WxktOV3ZaBbKySHpbpyMGg=
MIME-Version: 1.0
In-Reply-To: <1241560625.8665.17.camel@alok-dev1>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> 
	<1241560625.8665.17.camel@alok-dev1>
From: Chris Snook <chris.snook@gmail.com>
Date: Thu, 7 May 2009 12:35:56 -0400
Message-ID: <13a12eea0905070935o5abbeb49n8320d06c15b19b56@mail.gmail.com>
Subject: Re: [PATCH] x86: Reduce the default HZ value
To: akataria@vmware.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 5, 2009 at 5:57 PM, Alok Kataria <akataria@vmware.com> wrote:
>
> On Tue, 2009-05-05 at 14:21 -0700, H. Peter Anvin wrote:
>> Alok Kataria wrote:
>> > Hi,
>> >
>> > Given that there were no major objections that came up regarding
>> > reducing the HZ value in http://lkml.org/lkml/2009/4/27/499.
>> >
>> > Below is the patch which actually reduces it, please consider for tip.
>> >
>>
>> What is the benefit of this?
>
> I did some experiments on linux 2.6.29 guests running on VMware and
> noticed that the number of timer interrupts could have some slowdown on
> the total throughput on the system.
> A simple tight loop experiment showed that with HZ=1000 we took about
> 264sec to complete the loop and that same loop took about 255sec with
> HZ=100.
> You can find more information here http://lkml.org/lkml/2009/4/28/401

This is why certain niches, such as HPC users, often prefer HZ=100
kernels.  For the rest of us, sacrificing a few percent CPU throughput
for significant latency gains is well worth it.

> And with HRT i don't see any downsides in terms of increased latencies
> for device timer's or anything of that sought.
>
>>
>> I can see at least one immediate downside: some timeout values in the
>> kernel are still maintained in units of HZ (like poll, I believe), and
>> so with a lower HZ value we'll have higher roundoff errors.
>
> If that at all is such a big problem shouldn't we think about moving to
> using schedule_hrtimeout for such cases rather than relying on jiffy
> based timeouts.
> The hrtimer explanation over here http://www.tglx.de/hrtimers.html
> also talks about where these HZ (timer wheel) based timeouts be used and
> shouldn't really be dependent on accurate timing.

But your patch doesn't do this.  If you want us to merge a patch that
makes VMware systems faster, we're a lot more likely to take it if it
make everyone else's systems faster, or at least not slower.

> Also the default HZ value was 250 before this commit
>
> commit 5cb04df8d3f03e37a19f2502591a84156be71772
>  x86: defconfig updates
>
> And it was 250 for a very long time before that too. The commit log
> doesn't explain why the value was bumped up either.

250 was considered a compromise between 100 and 1000, but almost
everyone who cared just ended up using one or the other, and most of
them preferred 1000.

Given your use case, what you really need to do is get Red Hat,
Novell, et al. on the phone and ask them to ship kernels with HZ=100,
because the distributions do their own thing anyway.  If you can
figure out a way to do that without harming latency, they'll be
thrilled.

-- Chris
