Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXFNWoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXFNWoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXFNWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:44:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbXFNWoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:44:22 -0400
Subject: Re: libertas (private) ioctls vs. nl80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200706142203.13779.hs4233@mail.mn-solutions.de>
References: <1181757483.29767.99.camel@johannes.berg>
	 <20070614170901.GA13384@infradead.org>
	 <200706142203.13779.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 18:48:32 -0400
Message-Id: <1181861312.23567.18.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 22:03 +0200, Holger Schurig wrote:
> > Independent of any nl80211 status the private libertas ioctls have to
> > go.  Not only don't we want private ioctls for mesh networking but
> > rather have it as driver-independent interface, but the actual
> > libertas interface is the worst possible choice.
> 
> I have been told that the Libertas mesh functionality is not 802.11s, 

Technically this is correct.  A bit more back-story though.  802.11s is
still in draft form.  It'll be there for a while yet.  Stuff like
authentication and encryption are in heavy flux.  Previously, the mesh
stuff was using the 4th value in the 802.11 frame type.  But it turns
out that a lot of fullmac parts can't handle that because they drop
those frames in silicon.  So the standard is moving towards using WDS
frames without changing the frame type, which is what the Marvell
implementation is _already_ using.  I repeat, the standard is moving
towards the Marvell mesh implementation.  Furthermore, the CozyBit guys
who wrote the Marvell mesh implementation are heavily involved in the
802.11s standards groups anyway.

> Marvell brew their own beer (because it predates 802.11s, I guess). 
> However, for the kernel I'd see more an interface that supports 
> 802.11s --- or is flexible to support both this and the libertas one.

Definitely; 

> I also have two related observations:
> 
> If I'm correctt, the only non-mesh ioctl in ioctl.c is the led_gpio 
> ioctl. Theoretically one can abstract this, many WLAN chips have GPIOs. 

Plus the set_region call that can be replaced by whatever the regulatory
stuff comes up with.

> But mostly there is no documentation available about how those GPIOs 
> are used, where they are soldered to etc. To blindly allow changing 
> arbitrary GPIOs migth even be harmful to the hardware.
> 
> That said: with the USB 8388 dongle that I have, the LED GPIO iwpriv 
> call didn't do anything. Not sure if it works on OLPC ... but I doubt 
> that one can see the LEDs there ...

I think it's all dependent on the firmware; do you know what version of
the CF firmware you have?  The ledgpio function is apparently from an
older version of the firmware but is still in our 8388 5.x branch.
There's apparently a new command for this sort of thing.

> Another thing: I'm working on a CF 8385 based driver. Here I have a 
> firmware that does not (as far as I know this undocumented pile of 
> bytes) have any mesh functionality at all. So I need a way from if_cs.c 
> to disable all those iwpriv ioctls. Haven't thought about this issue 
> yet, other things are more pressing right now. However, I already don't 
> create the mshX interface.

Well, can't the ioctl stuff just return -EOPNOTSUPP or something if mesh
isn't available?

Dan


