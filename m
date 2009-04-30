Return-Path: <linux-kernel-owner+w=401wt.eu-S1763583AbZD3PMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763583AbZD3PMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932122AbZD3PLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:11:47 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:60758 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbZD3PLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:11:45 -0400
MIME-Version: 1.0
In-Reply-To: <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
References: <f73f7ab80904171732n41832d0hc62978e57bbcc32e@mail.gmail.com> 
	<625fc13d0904200529l152b8d75g33c3f940de1b2920@mail.gmail.com> 
	<f73f7ab80904201710m57472291yf7ff86760977b8e8@mail.gmail.com> 
	<1240388476.17445.10.camel@pasglop> <f73f7ab80904300804j1f847b70ha0fe3cda07249110@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 30 Apr 2009 09:11:24 -0600
Message-ID: <fa686aa40904300811u41e94972offfd75520636bb02@mail.gmail.com>
Subject: Re: Porting the ibm_newemac driver to use phylib (and other PHY/MAC 
	questions)
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 9:04 AM, Kyle Moffett <kyle@moffetthome.net> wrote:
> On Wed, Apr 22, 2009 at 4:21 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Mon, 2009-04-20 at 20:10 -0400, Kyle Moffett wrote:
>>> > IIRC, Ben had some issues with how phylib and the EMAC would need to
>>> > interact.  Not sure if he has those written down somewhere or not.
>>> > (CC'd).
>>>
>>> Hmm, yeah, I'd be interested to see those.  There's enough similar
>>> between phylib and the EMAC and sungem drivers that I'm considering a
>>> series of somewhat-mechanical patches to make EMAC and sungem use the
>>> "struct phy_device" and "struct mii_bus" from phylib, possibly
>>> abstracting out some helper functions along the way.
>>
>> Yup, emac and sungem predate phylib.
>>
>> I had a quick look at what it would take to port at least emac over, the
>> main issue was that I want to be able to sleep (ie, take a mutex) in my
>> mdio read/write functions, and back then, phylib wouldn't let me do that
>> due to spinlock and timer/softirq usage.
>
> Ok, I've made some progress in the port, but right now I'm trying to
> puzzle out what the "gpcs" bits in the code are.  From the few
> publicly available docs and some mailing list posts, the gpcs address
> appears to be some kind of integrated virtual PHY used when 460GT-ish
> chips are communicating via an SGMII bus.  My current plan of action
> is to separate the "gpcs" out into a separate PHY device controlled by
> the emac code.
>
> I'm also curious about the intent of the "mdio_instance" pointer (IE:
> the "mdio-device" property).  Is that used when all the PHY devices
> are attached to the MDIO bus of only one of the (multiple) emac
> devices?  Or is that for when two emac chipsets are connected to the
> same MDIO bus wire?  (or both?)  What keeps the emac_instance pointed
> to by the "mdio_instance" from going away while the other emac chipset
> is using it?
>
> In either case, I plan to have the device actually holding the MDIO
> bus run the mdiobus_alloc() and mdiobus_register() functions, then the
> other emac instance will simply take a reference to that MDIO bus
> (which would also pin down the emac instance that owns it).

Just a heads up Kyle; there are changes queued in the netdev tree
which add OF helpers for MDIO bus drivers and MAC drivers.  See here:

http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commit;h=8bc487d150b939e69830c39322df4ee486efe381

and here is an example of a driver change:

http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commit;h=1dd2d06c0459a2f1bffc56765e3cc57427818867

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
