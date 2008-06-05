Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYFEJqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYFEJqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYFEJqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:46:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:53123 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbYFEJqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cP0m0TP5/VeaI68Y8ict0g+lBLtCgM+BReduw4LXZ6xRQxGHNHeTUDTt46X0e39rq+
         avJeCh/TnLDHnv2pQgtRd71oK29Ncc3P4vROVvmzsCxIfXGTaaDxEIxTXZANku8taUU1
         cXnMzY1TvjMB6PFNu9qLFQ7hg+XbAXgfCHA64=
Message-ID: <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com>
Date: Thu, 5 Jun 2008 18:46:35 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Cc: linux-kernel@vger.kernel.org, Uwe.Kleine-Koenig@digi.com, gregkh@suse.de,
       akpm@linux-foundation.org, lethal@linux-sh.org, tglx@linutronix.de
In-Reply-To: <20080605090916.GA3198@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se>
	 <20080604101144.GA3207@local>
	 <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com>
	 <20080605090916.GA3198@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 6:09 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Thu, Jun 05, 2008 at 10:25:27AM +0900, Magnus Damm wrote:
>> On Wed, Jun 4, 2008 at 7:11 PM, Hans J. Koch <hjk@linutronix.de> wrote:
>> > On Wed, Jun 04, 2008 at 03:08:26PM +0900, Magnus Damm wrote:
>> >> From: Magnus Damm <damm@igel.co.jp>
>> >>
>> >> This patch adds a "Unique IRQ Mode" to the uio_pdrv UIO platform driver.
>> >> In this mode the user space driver is responsible for acknowledging and
>> >> re-enabling the interrupt. Shared interrupts are not supported.
>> >
>> > I still don't see any gain in this. This only works for embedded
>> > devices, so a user has to setup hardware specific code in his board
>> > support anyway.
>>
>> Exactly what in my patch makes this platform driver only suitable for
>> embedded devices?
>
> You assume the interrupt is not shared. You can never do that on a
> normal x86 PC, for example. E.g. for a PCI card you don't know which irq
> it'll get and if it is shared or not.

So your main objection against this patch is that you cannot use it
with shared interrupts?

>> > With your code, we would have to add something like this
>> > to the docs:
>> >
>> > IF you define an irq AND ommit the irq handler THEN we silently add a
>> > handler that blindly assumes the irq is not shared...
>>
>> I'm not sure if silently and blindly are the first words that pop into
>> my mind, but sure. Documentation is a good idea. Just let me know
>> which uio_pdrv document you want me to modify.
>
> Stuff that is useful for other driver writers and not only for userspace
> people should be added to Documentation/Docbook/uio_howto.tmpl.
> Unfortunately, I forgot to ask Uwe to do this, so I'll probably have to
> do it myself one day ;-)

Right.

>> > In my opinion, this is confusing, and all it does is saving the need for a
>> > three-lines irq handler in the board support.
>>
>> You propose that I put the callbacks in my board support code instead
>> of modifying the driver.
>
> That's what uio_pdrv does.

Yes.

>> I don't think the board support level is the
>> proper place for this code.
>
> You have to write code there anyway, e.g. code that configures your GPIO
> as input, makes it generate interrupts and so on. And of course, you
> have to setup your platform device as well. If you simply add the irq
> handler, you can use uio_pdrv as-is. And if you _know_ that on your
> platform the irq is not shared, this might really be a one-liner that
> simply calls irq_disable. That's OK in board specific code, but not in a
> generic driver.

Ever heard about system on chip? Not all platform devices need board
specific setup.

>> The patch contains no board specific code,
>> and it is independent of both architecture and cpu model.
>
> Every platform device driver depends on board support.

Is that so? I suggest that you have a look at the mfd drivers and think again.

>> > So, NAK to this until somebody convinces me that I completely missed the
>> > point.
>>
>> We can reuse this driver for _many_ different SuperH processor models.
>> Most of these processor models even have more than one hardware block
>> that can be exported to user space using this uio_pdrv driver in
>> "Unique IRQ Mode". There is nothing board specific with this at all,
>> so yes, I think you are missing the point.
>
> First, I won't accept anything that changes the current UIO behaviour.
> If uio_info->irq is not set, then uio_register_device will fail. That's
> it. Your patch redefines the meaning of irq-not-set if uio_pdrv is used.

How is this changing the UIO behavior? I'm modifying the uio_pdrv
driver, which is a driver that you didn't even write yourself. And yet
you seem to have very strong feelings against this patch.

> Second, if we decide to introduce new UIO capabilities, there must be an
> obvious advantage. E.g., uio_pdrv saves the trouble of writing almost
> identical UIO platform drivers over and over again. A programmer only
> needs to touch the board support file he has to set up anyway which
> makes his board support patches simpler and easier to maintain. Your
> patch adds code that is not obvious, just to save a few lines of board
> support code. It doesn't add new possibilities, everything can be done
> with uio_pdrv alone.

Again, it's not board support code. And it's pretty obvious.

>> Maybe you prefer that I repost my "Reusable UIO Platform Driver"
>> instead of modifying uio_pdrv?
>
> If you have an idea that adds new possibilities, feel free to post it.
> If you come up with something that just adds confusion but no
> advantages, I'll never accept it.

You don't have to accept it. I'll just repost my original driver and
let someone else merge it then.

/ magnus
