Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbXLDWP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbXLDWP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXLDWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:15:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34195 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbXLDWPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:15:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4755D186.20204@s5r6.in-berlin.de>
Date: Tue, 04 Dec 2007 23:15:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Bernhard Kaindl <bkaindl@ffii.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Andi Kleen <ak@suse.de>,
       Bernhard Kaindl <bk@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire * __fast__ firedump!
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org>
In-Reply-To: <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Kaindl wrote:
> The biggest block size that worked here was 2048 bytes, which was
> enough to get nearly 10MB/s of data transfer rate from the remote
> memory to disk.

The maximum payload size of block requests depends on three things:
1. speed of the connection between the two nodes (debugged machine and
debugging machine), 2. link layer controllers of the two nodes, 3.
software on the debugging machine.

1.) S100: 512 bytes, S200: 1024 bytes, S400: 2048 bytes, S800 and more:
4096 bytes.

2.) Controllers on CardBus cards are limited to 1024 bytes payload of
asynchronous packets, for reasons I don't know.  The other available
controllers only have the above mentioned speed-dependent limit.

3.) The ohci1394 driver has an implementation limitation which requires
that all packets including headers don't exceed PAGE_SIZE.  This does
not affect the packets which go through the physical response unit
(which they do on the debugged machine) but it affects the debugging
machine.

A quick note to this text from
http://www.suse.de/~bk/firewire/ohci1394_dma_early.diff :
> +	  As all changes to the FireWire bus such as enabling and disabling
> +	  devices cause a bus reset and thereby disable remote DMA for all
> +	  devices, be sure to have FireWire enabled on the debug host (and
> +	  the cable plugged) before booting the debug target for debugging.

Bus resets are also caused by bus managing software, which Linux' old
and new FireWire stacks and the stacks of all other FireWire capable
desktop OSs are to varying degrees.  I wonder if the following could
happen:  The two PCs are directly connected, only the PHY of the
debugging PC is active, then the PHY of the debugged PC is activated,
becomes root node, debugging PC examines the bus, then resets the bus to
force its own PHY to become root node in order to get a working
isochronous resource manager.  This bus reset would switch remote DMA on
the debugged PC off.
-- 
Stefan Richter
-=====-=-=== ==-- --=--
http://arcgraph.de/sr/
