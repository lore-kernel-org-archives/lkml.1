Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYL2A2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYL2A2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYL2A2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:28:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:3154 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYL2A2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:28:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Yo5+kAZdr67zdEWa7AKXa4N85TIybQpAi1KFhqNS9nRjrcm/YzVXTPmi6Y3Rth+N0H
         xTF6SaShngFSrtge05KBssOJx/28h9npCN+x5TwNZyX7ND9lY0CGraeoaa0YrPgzT/LG
         CNbu6EHmvnOKxj9kfEhjMtEScKafHV0wHIRAs=
Message-ID: <45a44e480812281628j214a9efvd19e4647fe30582c@mail.gmail.com>
Date: Mon, 29 Dec 2008 08:28:35 +0800
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Ben Nizette" <bn@niasdigital.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "David Brownell" <david-b@pacbell.net>,
       "Eric Miao" <eric.y.miao@gmail.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <1230501634.16910.57.camel@linux-51e8.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <45a44e480811301710v78875425p75dedd850728cbec@mail.gmail.com>
	 <45a44e480812270655u10bde0d2mc7f429cf47ed7bc6@mail.gmail.com>
	 <200812281346.56703.rgetz@blackfin.uclinux.org>
	 <1230501634.16910.57.camel@linux-51e8.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 6:00 AM, Ben Nizette <bn@niasdigital.com> wrote:
> On Sun, 2008-12-28 at 13:46 -0500, Robin Getz wrote:
>> > gpio_set_batch(DB0, value, 0xFFFF, 16)
>> >
>> > which has the nice performance benefit of skipping all the bit
>> > counting in the most common use case scenario.
>>
>> but has the requirement that the driver know exactly the board level
>> impmentation details (something that doesn't sound generic).
>
> The original use case for these batch operations was in a fastpath -
> setting data lines on a framebuffer.  Sure it's arguably not as generic
> as may be, but it optimises for speed and current usage patterns - I'm
> OK with that.  Other usage patterns which don't have a speed requirement
> can be done using the individual pin operations and a loop.

Hi Ben, Yes, exactly! Thanks!

Hi Robin,  I think the randomly or less ordered gpio case that you
raised should be solved using the existing gpio_set/get single bit
value API. I intended this startpin, mask and length based API is to
help drivers that would currently hit a performance limitation while
keeping it just sufficiently abstract that it can be accelerated on an
implementation specific basis without too much of a headache.

btw, about the term batch, I had looked it up originally and seen:
google define:batch
A collection of products or data which is treated as one entity with
respect to certain operations eg processing and production.
www.shipping.francoudi.com/main/main.asp

so I felt it was a sufficiently meaningful and matching term to use.
Also, I had used the term gpio_set_value_bus in the first patch to try
to be close to the existing gpio_set/get_value API. I switched to
gpio_set_batch because it was pointed out that _bus could be
misleading. All that said, I'm happy to change it to the term around
which consensus forms. :-)

>
>>
>> > While we are here, I was thinking about it, and its better if I give
>> > gpio_request/free/direction_batch a miss for now. Nothing prevents
>> > those features being added at a later point.
>>
>> I don't think that request/free are optional.
>>
>> For example - in most SoC implementations - gpios are implemented as banks of
>> 16 or 32. (a 16 or 32 bit register).
>>
>> Are there facilities to span these registers?
>>  - can you request 64 gpios as a 'bank'?
>>  - can you request gpio_8 -> gpio_40 as a 'bank' on a 32-bit system?

I think as discussed above, these cases would be better solved using
the single bit set/get API.

>>
>> Are non-adjacent/non-contiguous gpios avaliable to be put into
>> a 'bank/batch/bus'? can you use gpio_8 -> 11 &  28 -> 31 as a 8-bit 'bus'?
>>
>> How do you know what is avaliable to be talked to as a bank/bus/batch without
>> the request/free operation?
>
> I think the read/write operations should be able to fail if you give
> them invalid chunks of gpio, sure.  Request/free are not really designed

I think we can do that for read/write but we'd need to break
consistency with the existing api. The existing gpio_set_value and
gpio_get_value don't offer an error return.

> for that operation - they just ensure exclusive access to a gpio if
> that's what the driver wants.  In the batch case the
> request/free/direction operations can once again be performed by single
> pin operations and iteration.

Agreed.

>
>>
>>
>> I have seen various hardware designs (both at the PCB and SoC level) require
>> all of these options, and would like to see common infrastructure which
>> handles this.
>>
>> The issue is that on many SoC implementations - dedicated peripherals can also
>> be GPIOs - so it someone wants to use SPI (for example) GPIO's 3->7 might be
>> removed from the avaliable 'gpio' resources. This is determined by the
>> silicon designer - and even the PCB designer has little to no flexibility on
>> this. It gets worse as multiple SPI or I2C are used on the PCB (which can
>> have lots of small (less than 5) dedicated pins in the middle of the larger
>> gpio resources)....
>
> Yeah the request/free operation doesn't deal with muxing or any other
> platform-specific kinda gumph, that was an original design decision.
> They're really just a usage counter.
>
> An example which comes to mind is the avr32-specific userspace gpio
> interface.  This takes a bitmask, loops over the set bits and fails if
> any of the gpio are previously requested or have been assigned to
> non-gpio peripherals.  I don't really see a need to streamline this.
>
>>
>> I would think that a 'bank' / 'bus' (whatever) would be a collection of
>> random/multiple GPIOs (a struct of gpio_port_t) rather than a start/length
>> (as you described) - or better yet - the request function takes a list (of
>> individual GPIO's - defined in the platform data), and creates the struct
>> itself.

Robin, I agree with you that trying to achieve unstructured multiple
GPIO support is elegant. The start/length approach I've taken here is
definitely not as generic. But by giving up some pure abstraction,
we've gained in implementation simplicity for each platform. Also,
there's nothing in my patch that would in future prevent us from
adding the random capability via an API akin to what you've suggested.

I'd like to get the start/length approach out there and in-play to
find out if other people want to use it and how they end up using it.

Thanks,
jaya
