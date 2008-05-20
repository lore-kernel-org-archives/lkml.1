Return-Path: <linux-kernel-owner+w=401wt.eu-S935304AbYETPsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935304AbYETPsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbYETPsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:48:35 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:25202 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592AbYETPsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:48:32 -0400
Message-ID: <fa686aa40805200848n2afcaf62pa45e076cb38c5f65@mail.gmail.com>
Date: Tue, 20 May 2008 09:48:29 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com, jonsmirl@gmail.com
In-Reply-To: <Pine.LNX.4.64.0805201650280.5283@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	 <Pine.LNX.4.64.0805191446530.27140@axis700.grange>
	 <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
	 <Pine.LNX.4.64.0805191811510.29559@axis700.grange>
	 <fa686aa40805192213y485c4ba2u750748f8201e0377@mail.gmail.com>
	 <Pine.LNX.4.64.0805201650280.5283@axis700.grange>
X-Google-Sender-Auth: 9aa28a6d5ae5bd2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 9:26 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 19 May 2008, Grant Likely wrote:
>
>> I'm not so fond of this approach.  cs-parent doesn't seem to make much
>> sense to me.  It might be better to have a cs-handler property on the
>> SPI bus node instead of on the SPI slave nodes, but even then it
>> leaves a number of questions about what it really means.  In some
>> cases it would be overkill.  For example, if the SPI node simply had
>> multiple GPIO lines then an extra cs-parent node wouldn't be needed at
>> all.
>
> Right, it is optional.
>
>> Then there are the complex arrangements.  When setting CS
>> requires inserting a special 'set cs' SPI message at the right time.
>> Or worse; when setting CS requires /modifying/ the sent SPI message.
>
> Hm, are there actually such SPI _controllers_ that use SPI data to toggle
> chipselects? I.e., you would have to send your SPI client data (for the
> RTC or whatever) plus some extra bytes or with some modifications, and
> this extra information would then be intercepted by the SPI _controller_
> itself and only client data would be sent out?

Yes!  There really are!!!  One case I've been told of is an SPI bridge
that uses the first byte of the transfer to obtain the chip select.

> Isn't what you're
> describing really a case of an SPI bridge, as you also call it below? In
> which case, I think, it might make sense to cleanly differentiate these
> two cases:
>
> 1. SPI chipselect. Either controlled by an external (typically a GPIO)
> signal or by the controller itself, in the latter case the controller has
> to be configured with the required address
>
> 2. SPI bridge. I don't know such configurations, so, I can only guess: the
> SPI controller has a single SPI client, which acts like a bridge. It
> receives data from the primary host, and in this data the target client
> data and its address are encoded.

Yes, this is probably appropriate.

> Now, I can also imagine case 2 where the bridge is actually a part of the
> host controller... Even though this doesn't make any sense to me.

Hmmm, yeah, I suppose it is possible; but if it is internal to the bus
controller then it can also be handled internally by the bus
controller driver and probably won't need to be reflected in the
device tree layout.

>> Essentially, the binding would need to describe the ability to
>> completely intercept and rewrite all SPI messages going through the CS
>> scheme.

It also needs to describe layouts which require SPI transfers in a
particular order.  For example, if you're doing 2 SPI messages (M1 and
M2) to 2 different SPI devices (S1 and S2), and the CS lines are on a
GPIO expander which is a third SPI device (S3).  In which case 5 or 6
SPI messages need to be transmitted:

ctrl msg -> S3    // To set the CS to S1
M1 -> S1
ctrl msg -> S3    // To clear the CS to S1
ctrl msg -> S3    // To set the CS to S2
M2 -> S2
ctrl msg -> S3    // To clear the CS to S2

An important subtlety to note here is that the GPIO device (S3) cannot
simply enqueue the control message to the SPI device when it is time
to send M1 or M2.  Normal enqueuing would add the messages to the end
of the queue; too late to actually activate the relevant CS line.
Granted, the is mostly a driver issue; not a device tree issue; but it
has some impact on the layout.  It could be handled with the
spi_bridge construct, but S1 and S2 aren't really children of S3.  On
the other hand; the spi_bridge is really more of a board level
construct.  The spi_bridge could be considered the board wireup and
S1, S2 and S3 are all children of the spi_bridge.  The spi_bridge
would have to be knowledgeable enough to handle control messages to S3
in a special order.

>> I'm not saying it's not possible to do, but I am saying that I'd like
>> to have a better feel for all the use cases before it is defined.  I'm
>> not convinced that adding a cs-parent phandle will do that
>> appropriately.  That being said, my gut feel is that the solution will
>> be to support spi-bridge nodes that handle the complex CS
>> configuration settings; the spi-bridge would be a child of the
>> spi-master and the parent of the spi devices; and simple CS settings
>> being handled with regular old GPIO bindings.  (Much like the last
>> suggestion you make; except that I think that it *does* looks
>> elegant.)  :-)
>
> Ok, elegance apart:-) You can use the SPI-bridge construct to also
> describe simple SPI-chipselect configurations. But is it really a good
> idea? Wouldn't it be better to handle these two cases separately? Using
> "bridge" to describe CS's seems also confusing - imagine someone
> implementing a new DTS, having to describe a bridge not having one doesn't
> seem very intuitive:-)

... and it must be said that I got rather lazy in my example below.  I
really covered both layouts (simple GPIO and an SPI bridge in the same
example without documenting it sufficiently.  I'll hash out my
thoughts some more and post a series of better examples this
afternoon.

>
>> example; here's an SPI bus that has 2 GPIOs for two bus CS lines and
>> an SPI bridge that uses both CSes; one address for accessing the
>> bridge's CS register and one CS to access the downstream devices.
>>
>> +    SPI example for an MPC5200 SPI bus:
>> +               spi@f00 {
>> +                   #address-cells = <1>;
>> +                   #size-cells = <0>;
>> +                   compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
>> +                   reg = <0xf00 0x20>;
>> +                   interrupts = <2 13 0 2 14 0>;
>> +                   interrupt-parent = <&mpc5200_pic>;
>> +                   gpios = <&gpio1 0 0 &gpio1 1 0>;
>> +                   spi-bridge@0 {
>> +                       compatible = "oem,spi-bridge-type";
>> +                       reg = < 0 1 >;  // note: 2 SPI CS addresses; first one to access bridge registers
>> +
>> +                       ethernet-switch@0 {
>> +                           compatible = "micrel,ks8995m";
>> +                           linux,modalias = "ks8995";
>> +                           max-speed = <1000000>;
>> +                           reg = <0>;
>> +                       };
>> ...                     // and more SPI child nodes here...
>> +                   };
>> +               };
>>
>> But even this doesn't reflect the hardware layout well.  What if the
>> SS lines are on SPI GPIO expanders on the same bus?  Then does it make
>> sense for them to be layed out as spi bridges?
>
> Well, in this case - yes, because addressing clients "behind" the expander
> and the expander itself is done differently.
>
> On the whole, I think, it begins to look good - I think, it is better to
> implement an imperfect but complete and consistent scheme and modify or
> extend it in the future, than a perfect, but incomplete, and have to use
> auxiliary means (platform bindings) to fill in the gaps.

I'm not too opposed to using non-standard properties to describe stuff
in the short term; but I agree that avoiding hacky platform data stuff
is not desired.

Thanks for all the feedback.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
