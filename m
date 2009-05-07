Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbZEGU3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbZEGU3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbZEGU3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:29:44 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:60653 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZEGU3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TjuMBOFoJNZt3E88ePBdqaIrC5mszGjU6aMIhhYj/CKVhiNBIlDdwjji4iOa/HHwwR
         Hp/47+30HnMX28wG+sItMT5lKOsBJB2EGBg6eQ3B8Je38Iw+9pkh4P0nSurRoWUdCmKl
         u/+Vz5xDbz0JW8153crtlHxoyqUpvS/MKrLNQ=
MIME-Version: 1.0
In-Reply-To: <1241715373.32495.21.camel@alok-dev1>
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> 
	<1241560625.8665.17.camel@alok-dev1> <13a12eea0905070935o5abbeb49n8320d06c15b19b56@mail.gmail.com> 
	<1241715373.32495.21.camel@alok-dev1>
From: Chris Snook <chris.snook@gmail.com>
Date: Thu, 7 May 2009 16:29:23 -0400
Message-ID: <13a12eea0905071329s79fb262tf89ed901a77726ae@mail.gmail.com>
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

On Thu, May 7, 2009 at 12:56 PM, Alok Kataria <akataria@vmware.com> wrote:
>
> On Thu, 2009-05-07 at 09:35 -0700, Chris Snook wrote:
>> On Tue, May 5, 2009 at 5:57 PM, Alok Kataria <akataria@vmware.com> wrote:
>> >
>> > On Tue, 2009-05-05 at 14:21 -0700, H. Peter Anvin wrote:
>> >> Alok Kataria wrote:
>> >> > Hi,
>> >> >
>> >> > Given that there were no major objections that came up regarding
>> >> > reducing the HZ value in http://lkml.org/lkml/2009/4/27/499.
>> >> >
>> >> > Below is the patch which actually reduces it, please consider for tip.
>> >> >
>> >>
>> >> What is the benefit of this?
>> >
>> > I did some experiments on linux 2.6.29 guests running on VMware and
>> > noticed that the number of timer interrupts could have some slowdown on
>> > the total throughput on the system.
>> > A simple tight loop experiment showed that with HZ=1000 we took about
>> > 264sec to complete the loop and that same loop took about 255sec with
>> > HZ=100.
>> > You can find more information here http://lkml.org/lkml/2009/4/28/401
>>
>> This is why certain niches, such as HPC users, often prefer HZ=100
>> kernels.  For the rest of us, sacrificing a few percent CPU throughput
>> for significant latency gains is well worth it.
>>
>> > And with HRT i don't see any downsides in terms of increased latencies
>> > for device timer's or anything of that sought.
>> >
>> >>
>> >> I can see at least one immediate downside: some timeout values in the
>> >> kernel are still maintained in units of HZ (like poll, I believe), and
>> >> so with a lower HZ value we'll have higher roundoff errors.
>> >
>> > If that at all is such a big problem shouldn't we think about moving to
>> > using schedule_hrtimeout for such cases rather than relying on jiffy
>> > based timeouts.
>> > The hrtimer explanation over here http://www.tglx.de/hrtimers.html
>> > also talks about where these HZ (timer wheel) based timeouts be used and
>> > shouldn't really be dependent on accurate timing.
>>
>> But your patch doesn't do this.
>
> The reason it doesn't do it is because poll and select already use
> hrtimer. So IMO no important subsystem relies on jiffies for wakeups.
> Thus the latency problem is not actually present in the kernel.

TCP/IP still uses jiffies.  There's been talk of changing that, but it
hasn't been done yet, and it's definitely a latency-critical
subsystem.

>>  If you want us to merge a patch that
>> makes VMware systems faster, we're a lot more likely to take it if it
>> make everyone else's systems faster, or at least not slower.
>
> I doubt it would make any system slower, running these simple
> experiments is not hard at all and one could run these on native system
> too to check.

If this patch improves performance for both simple loops and
transaction processing by changing a non-idiotic tuning parameter, it
would be a first.  Can you at least run some sort of database
benchmark to back this up?

>>
>> > Also the default HZ value was 250 before this commit
>> >
>> > commit 5cb04df8d3f03e37a19f2502591a84156be71772
>> >  x86: defconfig updates
>> >
>> > And it was 250 for a very long time before that too. The commit log
>> > doesn't explain why the value was bumped up either.
>>
>> 250 was considered a compromise between 100 and 1000, but almost
>> everyone who cared just ended up using one or the other, and most of
>> them preferred 1000.
>>
>> Given your use case, what you really need to do is get Red Hat,
>> Novell, et al. on the phone and ask them to ship kernels with HZ=100,
>> because the distributions do their own thing anyway.
>
> Yeah but I don't think there is any better platform other than LKML to
> figure out if at all this is a problem anymore. Once we are assured that
> a low HZ is no more a problem I don't see why would the various distros
> not consider reducing it.
>
>>   If you can
>> figure out a way to do that without harming latency, they'll be
>> thrilled.
>
> Why do you think it would harm latency ?
> The sched_tick too is driven by hrtimers, if there is any specific
> subsystem which you think still relies on jiffy we could think about
> using hrtimer's for them too, right ?
> I did a quick scan and the only things that rely on jiffy are the device
> timeout's where latency is not a issue.
> So please let me know in what cases do you think it could affect system
> latency.

If you can get TCP/IP converted, or convince me that this won't hurt
transaction processing, I'm sold.

-- Chris
