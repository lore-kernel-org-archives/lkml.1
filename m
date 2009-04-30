Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbZD3VSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbZD3VSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 17:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbZD3VSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 17:18:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:39071 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbZD3VS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 17:18:29 -0400
Subject: Re: Porting the ibm_newemac driver to use phylib (and other
 PHY/MAC questions)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, netdev <netdev@vger.kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
References: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com>
	 <625fc13d0904200529l152b8d75g33c3f940de1b2920@mail.gmail.com>
	 <f73f7ab80904201710m57472291yf7ff86760977b8e8@mail.gmail.com>
	 <1240388476.17445.10.camel@pasglop>
	 <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 01 May 2009 07:18:11 +1000
Message-Id: <1241126291.29501.41.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, I've made some progress in the port, but right now I'm trying to
> puzzle out what the "gpcs" bits in the code are.  From the few
> publicly available docs and some mailing list posts, the gpcs address
> appears to be some kind of integrated virtual PHY used when 460GT-ish
> chips are communicating via an SGMII bus.  My current plan of action
> is to separate the "gpcs" out into a separate PHY device controlled by
> the emac code.

Well... GPCS is indeed some kind of internal PHY if you like but it's
not MDIO controlled and I don't really see a need to move it to the
phylib as it's so specific to the NIC itself. But if you think it cleans
the code up significantly... There are also some subtle differences in
how the NIC is programmed when using GPCS vs. xMII

> I'm also curious about the intent of the "mdio_instance" pointer (IE:
> the "mdio-device" property).  Is that used when all the PHY devices
> are attached to the MDIO bus of only one of the (multiple) emac
> devices? 

It's common especially on older SoCs using EMAC to have only one of
the EMAC instance with an MDIO bus for configuring the PHYs. This is one
of the reasons why I have the mutex in the low level MDIO access
routines since 2 EMACs can try to talk to the same MDIO, and this is the
problem I had with phylib back then which was doing everything in atomic
contexts.

> What keeps the emac_instance pointed
> to by the "mdio_instance" from going away while the other emac chipset
> is using it?

Nothing other than those are all in a SoC and so generally don't do
hotplug, but I suppose that with things like kvm which could potentially
hotplug devices between partitions, one would have to get a bit more
careful.
 
> In either case, I plan to have the device actually holding the MDIO
> bus run the mdiobus_alloc() and mdiobus_register() functions, then the
> other emac instance will simply take a reference to that MDIO bus
> (which would also pin down the emac instance that owns it).

Sounds good at first.

Cheers,
Ben.


