Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZD3WV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZD3WV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZD3WVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:21:19 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:58297 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZD3WVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <1241126291.29501.41.camel@pasglop>
References: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com>
	 <625fc13d0904200529l152b8d75g33c3f940de1b2920@mail.gmail.com>
	 <f73f7ab80904201710m57472291yf7ff86760977b8e8@mail.gmail.com>
	 <1240388476.17445.10.camel@pasglop>
	 <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
	 <1241126291.29501.41.camel@pasglop>
Date: Thu, 30 Apr 2009 18:21:18 -0400
Message-ID: <f73f7ab80904301521x16effa0ar2d4756daceada122@mail.gmail.com>
Subject: Re: Porting the ibm_newemac driver to use phylib (and other PHY/MAC 
	questions)
From: Kyle Moffett <kyle@moffetthome.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 5:18 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Well... GPCS is indeed some kind of internal PHY if you like but it's
> not MDIO controlled and I don't really see a need to move it to the
> phylib as it's so specific to the NIC itself. But if you think it cleans
> the code up significantly... There are also some subtle differences in
> how the NIC is programmed when using GPCS vs. xMII

Ok, thanks, that's helpful information.  Mainly I was trying to puzzle
out why the driver sometimes resets the GPCS and other times resets
the real PHY.  It seems to be rather inconsistent when it resets
different devices.  For instance, one of the Marvell PHY's init()
helper resets the PHY, which was getting in the way of me ensuring
that the init() helpers are called after every PHY reset (because I
need to reinitialize the state that just got erased by the reset).

The challenge is working out which of the implicit ordering is
required for correct operation and which is simply an artifact of the
current implementation.


>> I'm also curious about the intent of the "mdio_instance" pointer (IE:
>> the "mdio-device" property).  Is that used when all the PHY devices
>> are attached to the MDIO bus of only one of the (multiple) emac
>> devices?
>
> It's common especially on older SoCs using EMAC to have only one of
> the EMAC instance with an MDIO bus for configuring the PHYs. This is one
> of the reasons why I have the mutex in the low level MDIO access
> routines since 2 EMACs can try to talk to the same MDIO, and this is the
> problem I had with phylib back then which was doing everything in atomic
> contexts.

Ok, good, the current mdiobus code seems to make handling this a good
deal easier.


>> What keeps the emac_instance pointed
>> to by the "mdio_instance" from going away while the other emac chipset
>> is using it?
>
> Nothing other than those are all in a SoC and so generally don't do
> hotplug, but I suppose that with things like kvm which could potentially
> hotplug devices between partitions, one would have to get a bit more
> careful.

Yeah, I was experimenting with fiddling with the bind/unbind files in
sysfs and determined that the device-removal code is completely
broken.  As far as I can tell, any attempts to unregister one of the
emac devices cause an OOPS, even if it isn't used by another emac for
MDIO.  I may just start by nuking the broken device-removal code
entirely, and re-implement it properly once the rework is done.

Thanks for the info!

Cheers,
Kyle Moffett
