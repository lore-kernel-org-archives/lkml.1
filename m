Return-Path: <linux-kernel-owner+w=401wt.eu-S933844AbZDATBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933844AbZDATBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933777AbZDATA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:00:29 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:51171 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbZDATAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:00:25 -0400
Message-ID: <49D3B9CC.8050304@mnementh.co.uk>
Date: Wed, 01 Apr 2009 20:00:28 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>	 <20090316193010.56644165@mjolnir.ossman.eu>	 <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>	 <49C84060.6010903@mnementh.co.uk>	 <aec7e5c30903250156v1eb38bd7qafe1c4236d9daef@mail.gmail.com>	 <aec7e5c30903301951g792a25a2s3abef57ba59fe8ee@mail.gmail.com>	 <49D262F5.6020700@mnementh.co.uk> <aec7e5c30903311920p6b1409b6q8a8a6cbee29b44bf@mail.gmail.com>
In-Reply-To: <aec7e5c30903311920p6b1409b6q8a8a6cbee29b44bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:

> The SoC is directly connected to the SD connector. I've verified this
> by looking at board schematics. There is no power control hardware on
> the boards that I've seen so far,

Which SoC? (I think you said before, but I forgot).

> but I'm currently working with
> hardware designers to make sure they will add such capabilities to
> future boards. The power will then be controlled by board specific
> code, most likely using GPIO pins. The hardware block that the
> tmio_mmc driver is handling does not have any power control
> functionality.

Great stuff.

> As for the clock API, adding such a feature to the tmio_mmc driver is
> not very complicated, especially for the SoC case where we already
> have control over all system clocks.

The problem (as I pointed out, and you noted below) is that we cant only 
consider the SoC case because there ARE other current users of the 
device in-tree and they use MFD. They arent going away.

> Some architectures may have clock framework support, some may not. I
> guess wrapping the clock functions in #ifdefs is one (ugly) way to
> support both cases. And if we consider MFD it certainly becomes more
> complicated.

I dont mind tmio-mmc requiring the clk api. its only used on embedded 
platforms and these usually have clk support.

> So the current tmio_mmc driver does not use the clock API. With my
> patches the clock API us still unused. I agree that working on adding
> clock API support is needed, but I don't see how this is related to
> single iomem window support.

  Because that second iomem window is _purely_ in control of clock and 
power management.

Rather than design a bunch of special callbacks for clock control which 
will later be got rid of I think it is better that we create the proper 
infrastructure in the first place. Its on my to-do but IIRC Dmitry has 
done some work on it already and you're more than welcome to finish that 
work off.

> Regardless of clock API, I still need a way to use the driver with a
> single iomem window. Please propose how to use single iomem window
> harware with tmio_mmc.

If you dont want to extend the clk api to cover it, you can use a patch 
in your local tree?

> So exactly what is the "proper" solution for single iomem window support?

Extand the clk API to be arch agnostic.

> And why does single iomem window support have to block on clock API support?

Because with clk API support it is not necessary.

> But... How do I use tmio_mmc with hardware that only has a single
> iomem window?

if you get the clk API support generalised, I personally promise I will 
rip out the second IO window myself and move it to the TMIO/ASIC3 MFD 
core (where it belongs). Then we both get what we want.

> I need that regardless of clock API, and that's what the
> code in this patch series is all about.

Not regardless. single IO window in the tmio-mmc driver is  _dependant_ 
on clk API support, IMO.

-Ian
