Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYABVs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYABVs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYABVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:48:46 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33855 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYABVsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:48:45 -0500
Date: Wed, 2 Jan 2008 22:48:43 +0100
From: Andreas Mohr <andi@lisas.de>
To: Richard Jonsson <richie@coderworld.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
Message-ID: <20080102214843.GA19224@rhlx01.hs-esslingen.de>
References: <477BFC71.7090002@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477BFC71.7090002@coderworld.net>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 02, 2008 at 10:04:49PM +0100, Richard Jonsson wrote:
> Bugreport regarding forcedeth driver.
>
> When returning from suspend-to-RAM the MAC-address byteorder is reversed. 
> After another suspend-resume cycle the MAC-address is again correct. This 
> brings a great deal of pain since the NIC is assigned a random MAC-address 
> when it is detected as invalid.
>
> I cannot say if this issue appeared recently or if it's been in the kernel 
> for a while, as I've been using wireless until recently.
>
> I read somewhere on lkml that the mac is read from the device, then 
> reversed and finally written back to the device. Can it be that it is read 
> again on resume and reversed, and then again written to the device? This 
> would explain why it's ok every other resume cycle.

Uh, Use The Source, Luke?

But no, I think it's simply driver dainbreadness, not a matter of
complicated writing and reading back in reversed order.

drivers/net/forcedeth.c has a nice DEV_HAS_CORRECT_MACADDR flag which is
being enabled for certain cards (those which need this) and disabled for others.

The nv_probe() function then nicely obeys this flag by reversing the
address if needed, _however_ there's another function, nv_copy_mac_to_hw(),
which does _NOT_ obey it and simply copies the _raw_ netdev dev_addr
to the card register (NvRegMacAddrA etc.).

I don't know, this all looks a bit dirty to me, MAC reading/writing
should have been implemented in a more central way, then those people
wouldn't have confused heaven and hell with MAC address fiddling.

And yeah, this certainly looks like a bug that should be fixed ASAP,
unless my short analysis somehow happened to be wrong.
(I could probably fix it, but then the forcedeth people
most likely know better how they would like to see it implemented)

Thank you for your report!

Now the only thing remaining would be: is there a specific way to
contact forcedeth-related people? I didn't find anything within a short
search.

Andreas Mohr
