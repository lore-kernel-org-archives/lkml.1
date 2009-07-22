Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZGVV5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZGVV5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZGVV5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:57:11 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:38569 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbZGVV5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:57:10 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
	 <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
	 <1248269443.27058.1449.camel@twins>
	 <200907220957.16499.david-b@pacbell.net>
	 <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain>
Date: Wed, 22 Jul 2009 14:57:09 -0700
Message-ID: <d6200be20907221457r4e2f6d29g57146586fd13776a@mail.gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <david-b@pacbell.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Daniel Ribeiro <drwyrm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 2:04 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
> On Wed, 22 Jul 2009, David Brownell wrote:
>> On Wednesday 22 July 2009, Peter Zijlstra wrote:
>> > Wouldn't it be better if we could express the nesting property from
>> > within genirq, so that we can do things like:
>> >
>> >   register_chip_nested(parent_chip, parent_irq, slave_chip);
>> >
>> > And let genirq set-up the needed magic to make the nesting work.
>>
>> I've been requesting such IRQ chaining support for some time
>> now ... if the ears are now listening, that kind of direction
>> should be pursued.
>
> Well, I was all ear back then, but the disconnect between "embedded
> only needs X be happy" and my repsonsibility to keep that all working
> for everyone was way larger. :)
>
>> > Also, how important is it that subhandler1..n run in their own thread?
>>
>> Completely unimportant in a practical sense.  Undesirable, even;
>> wasteful to allocate all those stack pages and keep them idle
>> most of the time.
>>
>> There might be an argument that the design isn't technicaly done
>> until that model *can* be supported.  On the flip side, last time
>> this came up there was no "customer demand" for that ... it was
>> all "supplier push".
>>
>>
>> > That is, can't we let them run from the thread that is otherwise waiting
>> > for the completino anyway?
>>
>> That would be far preferable, yes.
>
> Ok, so let me summarize what we came up with so far.
>
> 1) handle_level_oneshot_irq is the correct answer to the problem of
> those "I'm behind a slow bus" interrupt controllers.
>
> 2) Some mechanism to request ONESHOT from the driver level is
> required. Preferrably via a flag on request_threaded_irq
>
> 3) a function which allows to express the nested thread irq nature of
> the interrupt controller and its subdevices.
>
> 4) a generic serializing mechanism which is implemented via irq_chip
> functions to solve the chip->mask/unmask issue for the demultiplexed
> interrupts. Something like the bus_lock/bus_sync_unlock patch I posted
> earlier.
>
> 5) a common function which allows to call the thread handler of the
> subdevice interrupts in the context of the main thread which takes
> care of serialization against disable/enable/request/free irq et al.
>
> Any more ?

It would also be useful to mask an edge triggered interrupt until the
thread handler has finished. The touchscreen on the G1 is connected to
an edge triggered interrupt, and the touchscreen may toggle the
interrupt line while reading its registers.

-- 
Arve Hjønnevåg
