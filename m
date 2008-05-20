Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbYETFOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbYETFOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 01:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYETFNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 01:13:50 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:50905 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYETFNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 01:13:49 -0400
Message-ID: <fa686aa40805192213y485c4ba2u750748f8201e0377@mail.gmail.com>
Date: Mon, 19 May 2008 23:13:48 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com, jonsmirl@gmail.com
In-Reply-To: <Pine.LNX.4.64.0805191811510.29559@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	 <Pine.LNX.4.64.0805191446530.27140@axis700.grange>
	 <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
	 <Pine.LNX.4.64.0805191811510.29559@axis700.grange>
X-Google-Sender-Auth: dd73e642f5941c1f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 10:30 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 19 May 2008, Grant Likely wrote:
>> But that is Linux internal
>> details; this discussion is about device tree bindings.
>>
>> Note that I did say that drivers can define additional properties for
>> supporting chip select changes as needed.  I'm just not attempting to
>> encode them into the formal binding.  There is simply just too many
>> different ways to manipulate chip select signals and so I don't feel
>> confident trying to define a *common* binding at this moment in time.
>
> Yes, I understand, that physically there can be many ways SPI chipselects
> can be controlled. But I thought there could be a generic way to cover
> them all by defining a separate entry on your SPI bus. Like
>
> +    SPI example for an MPC5200 SPI bus:
> +               spi@f00 {
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
> +                       reg = <0xf00 0x20>;
> +                       interrupts = <2 13 0 2 14 0>;
> +                       interrupt-parent = <&mpc5200_pic>;
> +                       eth-switch-cs@0 {
> +                               compatible = "oem,cs-type";
> +                       };
> +
> +                       ethernet-switch@0 {
> +                               compatible = "micrel,ks8995m";
> +                               linux,modalias = "ks8995";
> +                               max-speed = <1000000>;
> +                               reg = <0>;
> +                               cs-parent = <&/.../spi@f00/eth-switch-cs@0>;
> +                       };
> ...
> +               };
>
> Then whatever method is used to actually switch the CS, a driver should be
> registered to handle eth-switch-cs@0, providing the required calls.
> Without such a driver ethernet-switch@0 will not probe successfully.
> Wouldn't this cover all possible cases? One could even consider actually
> putting SPI devices on SPI chipselect busses, but that won't look very
> elegant:-)

Hurrmmmm...

I'm not so fond of this approach.  cs-parent doesn't seem to make much
sense to me.  It might be better to have a cs-handler property on the
SPI bus node instead of on the SPI slave nodes, but even then it
leaves a number of questions about what it really means.  In some
cases it would be overkill.  For example, if the SPI node simply had
multiple GPIO lines then an extra cs-parent node wouldn't be needed at
all.  Then there are the complex arrangements.  When setting CS
requires inserting a special 'set cs' SPI message at the right time.
Or worse; when setting CS requires /modifying/ the sent SPI message.
Essentially, the binding would need to describe the ability to
completely intercept and rewrite all SPI messages going through the CS
scheme.

I'm not saying it's not possible to do, but I am saying that I'd like
to have a better feel for all the use cases before it is defined.  I'm
not convinced that adding a cs-parent phandle will do that
appropriately.  That being said, my gut feel is that the solution will
be to support spi-bridge nodes that handle the complex CS
configuration settings; the spi-bridge would be a child of the
spi-master and the parent of the spi devices; and simple CS settings
being handled with regular old GPIO bindings.  (Much like the last
suggestion you make; except that I think that it *does* looks
elegant.)  :-)

example; here's an SPI bus that has 2 GPIOs for two bus CS lines and
an SPI bridge that uses both CSes; one address for accessing the
bridge's CS register and one CS to access the downstream devices.

+    SPI example for an MPC5200 SPI bus:
+               spi@f00 {
+                   #address-cells = <1>;
+                   #size-cells = <0>;
+                   compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
+                   reg = <0xf00 0x20>;
+                   interrupts = <2 13 0 2 14 0>;
+                   interrupt-parent = <&mpc5200_pic>;
+                   gpios = <&gpio1 0 0 &gpio1 1 0>;
+                   spi-bridge@0 {
+                       compatible = "oem,spi-bridge-type";
+                       reg = < 0 1 >;  // note: 2 SPI CS addresses;
first one to access bridge registers
+
+                       ethernet-switch@0 {
+                           compatible = "micrel,ks8995m";
+                           linux,modalias = "ks8995";
+                           max-speed = <1000000>;
+                           reg = <0>;
+                       };
...                     // and more SPI child nodes here...
+                   };
+               };

But even this doesn't reflect the hardware layout well.  What if the
SS lines are on SPI GPIO expanders on the same bus?  Then does it make
sense for them to be layed out as spi bridges?

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
