Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbYETP1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbYETP1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933311AbYETP0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:26:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:57212 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933136AbYETP0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:26:43 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18F4ElnmrgFqOTvIUh4jCoMgrPP0kTJjohpDvXqGv
	ZXKumTBIHuzQeG
Date: Tue, 20 May 2008 17:26:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com, jonsmirl@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
In-Reply-To: <fa686aa40805192213y485c4ba2u750748f8201e0377@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805201650280.5283@axis700.grange>
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> 
 <20080516193613.28030.13950.stgit@trillian.secretlab.ca> 
 <Pine.LNX.4.64.0805191446530.27140@axis700.grange> 
 <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com> 
 <Pine.LNX.4.64.0805191811510.29559@axis700.grange>
 <fa686aa40805192213y485c4ba2u750748f8201e0377@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Grant Likely wrote:

> I'm not so fond of this approach.  cs-parent doesn't seem to make much
> sense to me.  It might be better to have a cs-handler property on the
> SPI bus node instead of on the SPI slave nodes, but even then it
> leaves a number of questions about what it really means.  In some
> cases it would be overkill.  For example, if the SPI node simply had
> multiple GPIO lines then an extra cs-parent node wouldn't be needed at
> all.

Right, it is optional.

> Then there are the complex arrangements.  When setting CS
> requires inserting a special 'set cs' SPI message at the right time.
> Or worse; when setting CS requires /modifying/ the sent SPI message.

Hm, are there actually such SPI _controllers_ that use SPI data to toggle 
chipselects? I.e., you would have to send your SPI client data (for the 
RTC or whatever) plus some extra bytes or with some modifications, and 
this extra information would then be intercepted by the SPI _controller_ 
itself and only client data would be sent out? Isn't what you're 
describing really a case of an SPI bridge, as you also call it below? In 
which case, I think, it might make sense to cleanly differentiate these 
two cases:

1. SPI chipselect. Either controlled by an external (typically a GPIO) 
signal or by the controller itself, in the latter case the controller has 
to be configured with the required address

2. SPI bridge. I don't know such configurations, so, I can only guess: the 
SPI controller has a single SPI client, which acts like a bridge. It 
receives data from the primary host, and in this data the target client 
data and its address are encoded.

Now, I can also imagine case 2 where the bridge is actually a part of the 
host controller... Even though this doesn't make any sense to me.

> Essentially, the binding would need to describe the ability to
> completely intercept and rewrite all SPI messages going through the CS
> scheme.
> 
> I'm not saying it's not possible to do, but I am saying that I'd like
> to have a better feel for all the use cases before it is defined.  I'm
> not convinced that adding a cs-parent phandle will do that
> appropriately.  That being said, my gut feel is that the solution will
> be to support spi-bridge nodes that handle the complex CS
> configuration settings; the spi-bridge would be a child of the
> spi-master and the parent of the spi devices; and simple CS settings
> being handled with regular old GPIO bindings.  (Much like the last
> suggestion you make; except that I think that it *does* looks
> elegant.)  :-)

Ok, elegance apart:-) You can use the SPI-bridge construct to also 
describe simple SPI-chipselect configurations. But is it really a good 
idea? Wouldn't it be better to handle these two cases separately? Using 
"bridge" to describe CS's seems also confusing - imagine someone 
implementing a new DTS, having to describe a bridge not having one doesn't 
seem very intuitive:-)

> example; here's an SPI bus that has 2 GPIOs for two bus CS lines and
> an SPI bridge that uses both CSes; one address for accessing the
> bridge's CS register and one CS to access the downstream devices.
> 
> +    SPI example for an MPC5200 SPI bus:
> +               spi@f00 {
> +                   #address-cells = <1>;
> +                   #size-cells = <0>;
> +                   compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
> +                   reg = <0xf00 0x20>;
> +                   interrupts = <2 13 0 2 14 0>;
> +                   interrupt-parent = <&mpc5200_pic>;
> +                   gpios = <&gpio1 0 0 &gpio1 1 0>;
> +                   spi-bridge@0 {
> +                       compatible = "oem,spi-bridge-type";
> +                       reg = < 0 1 >;  // note: 2 SPI CS addresses; first one to access bridge registers
> +
> +                       ethernet-switch@0 {
> +                           compatible = "micrel,ks8995m";
> +                           linux,modalias = "ks8995";
> +                           max-speed = <1000000>;
> +                           reg = <0>;
> +                       };
> ...                     // and more SPI child nodes here...
> +                   };
> +               };
> 
> But even this doesn't reflect the hardware layout well.  What if the
> SS lines are on SPI GPIO expanders on the same bus?  Then does it make
> sense for them to be layed out as spi bridges?

Well, in this case - yes, because addressing clients "behind" the expander 
and the expander itself is done differently.

On the whole, I think, it begins to look good - I think, it is better to 
implement an imperfect but complete and consistent scheme and modify or 
extend it in the future, than a perfect, but incomplete, and have to use 
auxiliary means (platform bindings) to fill in the gaps.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
