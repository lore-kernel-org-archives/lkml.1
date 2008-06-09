Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYFIBMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYFIBMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 21:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYFIBMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 21:12:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:49740 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYFIBML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 21:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=U0yvmjxYcjO4bnirm2pDvAVvWIa4BnuGY9RrA1b5o6XOAEvivXRxn2tF6F1+TXvcK+
         EVmJBBVseNIxDVmDnDUiYiYYFuuojcp3LBkMNBSTkftEQHCCojDNKppdoIGIdh61SVQQ
         pFh3Gi9Hj6WLuUW798e5RXrwbmQ3iZVOtxOIc=
Message-ID: <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com>
Date: Mon, 9 Jun 2008 10:12:09 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, lethal@linux-sh.org, tglx@linutronix.de
In-Reply-To: <20080608205455.GA3191@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
	 <20080604101144.GA3207@local>
	 <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
	 <20080605090916.GA3198@local>
	 <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com>
	 <20080605112744.GB3198@local>
	 <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com>
	 <20080608205455.GA3191@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 5:54 AM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Sun, Jun 08, 2008 at 07:19:25PM +0900, Magnus Damm wrote:
>> >>
>> >> So your main objection against this patch is that you cannot use it
>> >> with shared interrupts?
>> >
>> > I think I've explained my objections detailed enough.
>>
>> It's still unclear to me. Please make a brief summary of your objections.
>
> The objection is that your code offers no advantages. What can we do
> with your patch applied that we cannot do with uio_pdrv alone?

Yes, it is possible to have board or architecture specific hooks, but
does that really make sense if the code is generic and can be reused
by multiple architectures? I say it doesn't make sense at all.

>> > If it's a device within the SoC, you won't use UIO for that. If you did,
>> > your platform would depend on certain userspace software which is simply
>> > crap. And devices outside the SoC are board specific.
>>
>> Why wouldn't we use UIO for device within the Soc?
>
> Can't you read? I've answered that in the lines above your question.

I'm sure there are blocks within the SoC that must be managed by the
kernel, but that's not always the case. Certain things can be managed
by user space just fine. For instance, video acceleration hardware.

>> I've been doing
>> that for quite some time now.
>
> Really? I haven't seen any such driver yet. IMO, support for everything
> inside a SoC should be completely within the kernel, I wouldn't do it
> with UIO. But it's up to the arch maintainer to decide that. Did you ask
> him?

Regarding driver source, I have posted a user space test driver here:

http://article.gmane.org/gmane.linux.ports.sh.devel/3927

As for kernel driver source, you have it earlier in this thread. I'm
planning on pushing my user space VIDIX driver upstream, but I'd like
to get the kernel parts merged first or at least acked. This UIO
specific piece of the puzzle unfortunately seems to take forever.
Which really is a shame, because it's all very simple.

>> >> >> The patch contains no board specific code,
>> >> >> and it is independent of both architecture and cpu model.
>> >> >
>> >> > Every platform device driver depends on board support.
>> >>
>> >> Is that so? I suggest that you have a look at the mfd drivers and think again.
>> >
>> > All I said about board support also applies to platform support files
>> > like at91sam9263_devices.c, I'm simply talking about the file where you
>> > define your struct platform_device.
>>
>> Oh, I see. That's cpu specific code in my mind.
>
> It's completely unimportant if your struct platform_device appears in
> platform-, board-, or cpu-support. Or elsewhere. I won't let myself be
> tricked into a discussion about terms.

No of course, please keep on referring to everything outside of
drivers/ as board code.

>> >> >> > So, NAK to this until somebody convinces me that I completely missed the
>> >> >> > point.
>> >> >>
>> >> >> We can reuse this driver for _many_ different SuperH processor models.
>> >> >> Most of these processor models even have more than one hardware block
>> >> >> that can be exported to user space using this uio_pdrv driver in
>> >> >> "Unique IRQ Mode". There is nothing board specific with this at all,
>> >> >> so yes, I think you are missing the point.
>> >> >
>> >> > First, I won't accept anything that changes the current UIO behaviour.
>> >> > If uio_info->irq is not set, then uio_register_device will fail. That's
>> >> > it. Your patch redefines the meaning of irq-not-set if uio_pdrv is used.
>> >>
>> >> How is this changing the UIO behavior? I'm modifying the uio_pdrv
>> >> driver, which is a driver that you didn't even write yourself.
>> >
>> > uio_pdrv is a generic driver, so I consider it part of the UIO
>> > framework. It adds new possibilities for authors of UIO platform device
>> > drivers (which are the vast majority of all UIO drivers). It is not just
>> > another UIO driver, but part of the system. It'll appear in UIO
>> > documentation, I'll explain it in future UIO presentations, and so on.
>> >
>> > And I consider it my job to make sure that such generic code is clean,
>> > obvious, and consistent.
>>
>> Would you like me to write longer comments? Or some slides?
>
> ;-)
>
>>
>> >> And yet
>> >> you seem to have very strong feelings against this patch.
>> >
>> > I explained why. My reasons are purely technical, please don't take this
>> > as a personal offense.
>>
>> No offense taken. But I can't really see your technical arguments.
>
> Once more (for the last time): The technical argument against your patch
> is that it offers no advantages. It makes other code more complicated,
> less obvious, and less consistent. This might be OK if we had big
> advantages in return, but this isn't the case.

I say:
a) We need this for 5+ different SuperH hardware blocks.
b) This approach can be used by most architectures.
c) The code is architecture independent.

You say "it offers no advantages".

> Furthermore, your approach works only on certain platforms. But that
> doesn't matter anymore, because the above is already enough to NAK your
> patch. We won't add code just because it could be done.
>
>> If something in my code is unclear please ask before NAK.
>
> If I post a patch, it is my job to make it clear what advantages we have
> if we apply it. And no, nothing is unclear with your patch.

I'm glad to hear that you understand it all.

>>
>> > Unfortunately, I'm one of the two UIO maintainers, so I feel obliged to
>> > review your patch and give my opinion. That doesn't mean I'm
>> > the big boss who makes the final decision. I can be critized and
>> > overridden. If Greg loves your patch and merges it, fine. Try it.
>>
>> Maybe I will. =)
>
> Did you notice that in this thread nobody spoke up to support your
> patch?

Maybe no one really cares about arguing about a few lines of code? And
I mean, what is it to argue about - it's not exactly rocket science.

Thanks for your help.

/ magnus
