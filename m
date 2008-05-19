Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYESQaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYESQaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYESQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:30:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:38478 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759205AbYESQaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:30:19 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/96tNZjHz9NlVJJ9+e0BYJ/VIzHQUe7cgoyCVvFd
	wW4wsKSIkbu8kN
Date: Mon, 19 May 2008 18:30:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com, jonsmirl@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
In-Reply-To: <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805191811510.29559@axis700.grange>
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> 
 <20080516193613.28030.13950.stgit@trillian.secretlab.ca> 
 <Pine.LNX.4.64.0805191446530.27140@axis700.grange>
 <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Grant Likely wrote:

> On Mon, May 19, 2008 at 7:17 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Fri, 16 May 2008, Grant Likely wrote:
> >
> >> +    However, the binding does not attempt to define the specific method for
> >> +    assigning chip select numbers.  Since SPI chip select configuration is
> >> +    flexible and non-standardized, it is left out of this binding with the
> >> +    assumption that board specific platform code will be used to manage
> >> +    chip selects.  Individual drivers can define additional properties to
> >> +    support describing the chip select layout.
> >
> > Yes, this looks like a problem to me. This means, SPI devices will need
> > two bindings - OF and platform?... Maybe define an spi_chipselect
> > OF-binding?
> 
> Actually, spi devices have *neither*.  :-)  They bind to the SPI bus.
> Not the platform bus or of_platform bus.

Right, sorry, your SPI bus driver scans the bus device bindings and 
registers devices on it using spi_of_register_devices().

> But that is Linux internal
> details; this discussion is about device tree bindings.
> 
> Note that I did say that drivers can define additional properties for
> supporting chip select changes as needed.  I'm just not attempting to
> encode them into the formal binding.  There is simply just too many
> different ways to manipulate chip select signals and so I don't feel
> confident trying to define a *common* binding at this moment in time.

Yes, I understand, that physically there can be many ways SPI chipselects 
can be controlled. But I thought there could be a generic way to cover 
them all by defining a separate entry on your SPI bus. Like

+    SPI example for an MPC5200 SPI bus:
+		spi@f00 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl,mpc5200b-spi","fsl,mpc5200-spi";
+			reg = <0xf00 0x20>;
+			interrupts = <2 13 0 2 14 0>;
+			interrupt-parent = <&mpc5200_pic>;
+			eth-switch-cs@0 {
+				compatible = "oem,cs-type";
+			};
+
+			ethernet-switch@0 {
+				compatible = "micrel,ks8995m";
+				linux,modalias = "ks8995";
+				max-speed = <1000000>;
+				reg = <0>;
+				cs-parent = <&/.../spi@f00/eth-switch-cs@0>;
+			};
...
+		};

Then whatever method is used to actually switch the CS, a driver should be 
registered to handle eth-switch-cs@0, providing the required calls. 
Without such a driver ethernet-switch@0 will not probe successfully. 
Wouldn't this cover all possible cases? One could even consider actually 
putting SPI devices on SPI chipselect busses, but that won't look very 
elegant:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
