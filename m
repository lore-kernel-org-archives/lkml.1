Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbYGDEDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbYGDEDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 00:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYGDEDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 00:03:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3828 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYGDEDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 00:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jS+hSTeedOLVco6LABnWep9Lf+7/0cVkYfAbaMP6r8tlbEZDK2ZDaRKkbAG4Fljr2Q
         Qg+jGuk6N13/SR3LAFWTvILz9WNK8/vlOYYfdGuGtRCsJ5Cvrv/Q6mF4NobVNPG7RhEV
         DjsZWVkAbJzPvU3e7nBKOvmVx3osachSIs4FY=
Message-ID: <aec7e5c30807032103p7626dcbdwe06c5fac461372c1@mail.gmail.com>
Date: Fri, 4 Jul 2008 13:03:21 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Cc: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <20080703124505.GB3197@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se>
	 <20080702125400.GC3199@local> <20080703071019.GC12214@digi.com>
	 <20080703124505.GB3197@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2008 at 9:45 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Thu, Jul 03, 2008 at 09:10:19AM +0200, Uwe Kleine-König wrote:
>> Hans J. Koch wrote:
>> > On Wed, Jul 02, 2008 at 07:59:51PM +0900, Magnus Damm wrote:
>> > > From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
>> > >
>> > > This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
>> > > is responsible for acknowledging and re-enabling the interrupt.
>> >
>> > This can easily be done without your patch.
>
> BTW, the above wording "the user space driver is responsible for
> acknowledging and re-enabling the interrupt" is misleading. The kernel
> always has to acknowledge/disable/mask the interrupt. Userspace can only
> reenable it, ideally by writing to a chip register. In some cornercases
> for broken hardware we need the newly introduced write function.

You seem to be mixing up masking/acknowledging the interrupt
controller and masking/acknowledging the actual hardware device. In
User IRQ Mode, the only thing the user space driver is accessing is
the hardware device, with the exception of write() to re-enable
interrupts which results in a enable_irq() that touches the interrupt
controller.

I'm not sure what kind of hardware devices you are talking about, but
I have hardware devices here on my desk that need to be acknowledged
by the device-specific driver to deassert the irq. And acknowledging
from user space works just fine.

>> > > Shared interrupts are not supported by this mode.
>> > >
>> > > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
>> > > Signed-off-by: Magnus Damm <damm@igel.co.jp>
>> > > ---
>> > >
>> > >  Similar code has been posted some time ago as:
>> > >  "[PATCH] uio_pdrv: Unique IRQ Mode"
>> > >  "[PATCH 00/03][RFC] Reusable UIO Platform Driver".
>> >
>> > Yes, and in that thread I gave detailed explanations why I won't accept
>> > that.
>> I think for all of your concers one of the following is true:
>>
>>   - they are not valid any more in this version; or
>
> I question the whole concept as such. The concept of having a generic
> irq handler using disable_irq_nosync() makes no sense at all.
>
> Reasons:
>
> - We do not introduce new possibilities. Everything can be done without
>  that patch.

Isn't it possible to use the same argument against UIO? There is no
point in having it since it is possible to do it all in kernel space
instead. But for various reasons people want to write their drivers in
user space.

And for various reasons I'd like to acknowledge interrupts in user
space. And I do that by disabling the interrupt in kernel space,
notify the user space driver and acknowledge and re-enable the
interrupt from there. The reason behind it is that I want to provide
user space device driver people with consistent interface to the
device without the need for any device specific code in kernel space.

> - We offer users an irq handler that shouldn't be used. It is seldom the
>  best solution to call disable_irq_nosync() to disable an interrupt. In
>  almost all cases you should use the irq mask register of the chip your
>  driver handles. What do you want to write into the docs? Here's an irq
>  handler, but please use it only if you're really desperate?

What is wrong with using disable_irq_nosync() compared to using the
device specific irq mask register? It works just fine, and it provides
a nice abstraction in my mind.

> - The only argument in favor of that concept was that it saves a few
>  lines of irq handler code. Given the fact that all the handler has to
>  do is toggle one bit in a hardware register, this is really not much.
>  And you tempt people to delete 5 lines of good code and replace them
>  with a sub-optimal generic irq handler.

What is suboptimal about it? And since when is a device specific
solution better than a generic one?

> - You introduce the need for an irqcontrol function. This was not the
>  intention of that concept. Normal UIO devices don't need a write
>  function, this is only used for broken hardware. If you have normal
>  hardware, and implement a proper 5 lines irq handler, userspace can simply
>  reenable the irq by writing to a hardware register it has mapped
>  anyway. In your concept, it has to use write() on /dev/uioX, which
>  means you have to go all the way through libc, vfs, and the UIO core
>  to finally call your irqcontrol function, which in turn calls
>  enable_irq. As I said, there is broken hardware around where this is
>  the only way, but most chips allow you to do it properly.

You are the one who posted the irqcontrol code because it solved some
issues you are having with broken hardware. I'm happy to use your code
in a generic way. Actually, my first version of this patch avoided the
extra write() call overhead by re-enabling things automatically, but
since your irqcontrol patch is cleaner I'd rather use that and live
with the small performance penalty.

Performance in this case is really a non-issue. If we experience
performance problems in the future because of high interrupt overhead
then UIO is most likely no longer suitable for us. Right now it's a
perfect match.

>>   - I cannot understand it.
>>
>> I'll try to list them all below.  Please tell us if the list isn't
>> complete or if my comments doesn't convince you.  You might have to
>> repeat yourself, but for me it's hard to sort your arguments because
>> Magnus' suggestion changed over time.
>
> OK, the version Magnus sent last is different, so some of my arguments
> are superfluous now.
>
> Please, to make things simpler, let's only talk about the concept as
> such and not go into implementation details. I deliberately do not review
> that code (although I believe it has more bugs than the one Alan found),
> because as long as the concept doesn't make sense, I don't care how it
> is implemented.

I'd say it makes sense to Paul, Uwe and me.

>> And please, I try to work out the pros and cons in a constructive way
>> and hope there is nothing in it you will take personal.  It's really
>> that I consider the patch valuable and don't understand your concerns.
>
> You both keep telling me how valuable that patch is but never answered my
> question what the advantage would be. I cannot see it yet.

Avoid having device specific interrupts handlers in kernel space?

>>
>> In the first thread[1] your unique and open concerns (to the best of my
>> knowledge and belief) with my comments are:
>>
>>       - "This only works for embedded devices [...]"
>>
>>         OK, this doesn't work with shared IRQs which rules out x86.
>>         I don't claim to know all the 23[2] other architectures but
>>         IMHO if something is good for 3 archs and doesn't hurt the
>>         other 21, you should do it.
>>
>>       - "This would save somebody the trouble to add the above 5 lines
>>         to the 30 lines of board/platform support code he has to write
>>         anyway. That's the only gain, and that is not enough."
>>
>>         IMHO it's worth it.  Because if you add the five lines to a
>>         central place you save 5 lines per platform using the driver.
>
> OK, that is one argument in favor. I always admitted that, but said that
> this is not enough to compensate for the disadvantages mentioned above.

I still fail to see your technical arguments.

>>         Moreover this might prevent some bugs.  (And obviously this
>>         function has the potential to have a buggy implementation as
>>         the comment by Alan Cox shows.)
>
> For me, this shows two things:
>
> - I never ever had to use disable_irq_nosync() in any UIO driver yet,
>  otherwise I would have noticed.

Is that so? Given the stunning UIO patch throughput it wouldn't
surprise me if people end up using local patches instead of even
trying to merge things upstream. Which means you wouldn't see the
code.

> - Magnus turned in a patch that he never tested.

Is that so?

I've tested the patch using two different processors on three
different boards. I have written a user space uio driver that
interfaces to mplayer using vidix, providing hardware accelerated
color space conversion and stretching. So don't call my patch untested
please.

I plan on submitting the vidix driver upstream soon after the uio
interface gets stabilized, ie this patch gets merged.

>>
>>       - "And if you _know_ that on your platform the irq is not
>>         shared, this might really be a one-liner that simply calls
>>         irq_disable. That's OK in board specific code, but not in a
>>         generic driver."
>>
>>         Please note that the patch only introduces a helper that the
>>         platform code *can* use.  You still have the freedom not to
>>         use it without any overhead.
>
> It's not a good idea to add nonsense code and tell the users to ignore
> it whenever they can...

This nonsense code, exactly which code are you talking about? Could it
be one of your significant kernel contributions? =)

>>
>>       - "I won't accept anything that changes the current UIO
>>         behaviour."
>>
>>         Not valid anymore.  There is no change in behaviour.
>
> Well, at least the whole stuff would have to be explained in the docs.

Sure, documentation is always good.

> You add an element to struct uio_info, together with a new #define. And
> a whole class of drivers using that stuff would have a write() function
> without needing it.

Another way to see it is that a whole class of drivers would need
kernel space interrupt handling code without really needing it.

>>
>> In the second thread[3] I cannot find any open concerns that are not
>> already listed above.
>>
>> > >  Changes since Uwe's last version:
>> > >   - flags should be unsigned long
>> > >   - simplify uio_userirq_handler()
>> >
>> > That's nearly nothing. All you do is sending the same stuff three weeks
>> > later in the hope somebody will merge it this time. NAK.
>> I think nobody really is surprised that you're not happy with the new
>> post.  But note that Magnus just did what you told him. ("I'm [not] the
>> big boss who makes the final decision. I can be critized and overridden.
>> If Greg loves your patch and merges it, fine. Try it.")
>>
>> In the hope not to have kicked off a flame,
>
> Oh, no, stay cool ;-)

Good, let's stay cool.

/ magnus
