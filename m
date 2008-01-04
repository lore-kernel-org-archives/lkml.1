Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYADIpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYADIpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYADIpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:45:21 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:46212 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYADIpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:45:19 -0500
Date: Fri, 4 Jan 2008 09:45:17 +0100
From: Andreas Mohr <andi@lisas.de>
To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Adrian Bunk <bunk@kernel.org>, Andreas Mohr <andi@lisas.de>,
       Richard Jonsson <richie@coderworld.net>, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
Message-ID: <20080104084517.GA21628@rhlx01.hs-esslingen.de>
References: <477BFC71.7090002@coderworld.net> <20080102214843.GA19224@rhlx01.hs-esslingen.de> <20080102234209.GA10831@does.not.exist> <20080104034357.GA2113@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080104034357.GA2113@atjola.homenet>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 04, 2008 at 04:43:57AM +0100, Björn Steinbrink wrote:
> On 2008.01.03 01:42:09 +0200, Adrian Bunk wrote:
> > [ original bug report: http://lkml.org/lkml/2008/1/2/253 ]
> > 
> > On Wed, Jan 02, 2008 at 10:48:43PM +0100, Andreas Mohr wrote:
> > > The nv_probe() function then nicely obeys this flag by reversing the
> > > address if needed, _however_ there's another function,
> > > nv_copy_mac_to_hw(), which does _NOT_ obey it and simply copies the
> > > _raw_ netdev dev_addr to the card register (NvRegMacAddrA etc.).
> 
> nv_copy_mac_to_hw() is called from nv_probe() _after_ the MAC address
> has been fixed, and from nv_set_mac_address() which is supposed to get a
> correct MAC address anyway. So I don't see any problem there.

/* set permanent address to be correct aswell */
... orig_mac fumbling ...

Why, then, does this driver do such a nice hack as:

        /* special op: write back the misordered MAC address - otherwise
         * the next nv_probe would see a wrong address.
         */
        writel(np->orig_mac[0], base + NvRegMacAddrA);
        writel(np->orig_mac[1], base + NvRegMacAddrB);

I really don't see why this driver needs to do these things in such a
messy way.

One thing is for certain: netdev->dev_addr is always in operating system
order, and order should always be handled properly when copying to/from
hardware.

Such a driver needs exactly *one* central helper method
to reverse an input MAC address in 6 bytes u8 format
(which could arguably be added to include/linux/etherdevice.h even,
since a wee bit too many devices seem to be having trouble
with wrongly ordered MAC addresses).
Then it needs exactly *one* function for I/O register access
to read a MAC address from a device and exactly *one* function
to write it back (both doing raw, unsorted format transfers only,
and possibly as inline function).

And then it needs these card I/O functions wrapped into two functions which
interface with driver- and OS-related MAC variables
(struct variables ALWAYS stored in usual system order, NOT H/W order!!!!!!)
which optionally reverse the address (if needed for a particular card).

And then there will never be any confusion about any MAC address format
anywhere any more, right?

I really don't mean to sound cranky, but this driver did ask for trouble,
and lots of it ;)

Thank you for your reply, and especially thank you for this very fast
patch!

I might even have enough time this weekend to work on this...

Andreas Mohr
