Return-Path: <linux-kernel-owner+w=401wt.eu-S933962AbYBHTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962AbYBHTiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbYBHTiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:38:07 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37603 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238AbYBHTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:38:06 -0500
Message-ID: <47ACAF9C.6030003@s5r6.in-berlin.de>
Date: Fri, 08 Feb 2008 20:38:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Bernhard Kaindl <bk@suse.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, John Stoffel <john@stoffel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: remote DMA via FireWire (was Re: [git pull] x86 arch updates for
 v2.6.25)
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <18344.41128.159384.144803@stoffel.org> <47A8A278.4020908@zytor.com> <alpine.LNX.1.00.0802081900360.321@jbgna.fhfr.qr>
In-Reply-To: <alpine.LNX.1.00.0802081900360.321@jbgna.fhfr.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Kaindl wrote:
> Regarding security:
> 
> On the software side: The new fw-ohci driver seems to allow physical DMA only
> to devices which pretend to be FireWire disks (it is the specified way to
> transfer the data)
...

To be precise, firewire-sbp2 tells firewire-ohci to open up the physical
response unit (which implements the remote DMA feature) for the target
node from when it tries the SBP-2 login until when it completes the
SBP-2 logout or the target is plugged out.  Let's call it filtered
physical DMA.

A mode which doesn't require the physical response unit could be
implemented in firewire-sbp2, but this would come with a considerable
overhead regarding code, runtime CPU usage due to huge interrupt
handling load, and additional runtime memory footprint.

The older sbp2 driver relies on unfiltered physical DMA, hence is less
secure.  There can be a mode selected at compile time to run without
physical DMA, but that's buggy and implemented in a way which is not
portable.

The only reason why we don't have an SBP-2 initiator which works without
remote DMA is that nobody is bothered enough to either debug that mode
in the old driver or implement it in the new driver.  Besides, we could
rather trivially add filtered physical DMA to the old
sbp2/ieee1394/ohci1394 stack but nobody took the time to do this yet either.

> With FireWire enabled by the BIOS, a hacker could (in theory) load his
> own operating system into the system RAM and boot it
...

x86 BIOSes don't initialize OHCI-1394 controllers up to the point that
its physical response unit were working remote nodes were granted access
to it.

Apple's OpenFirmware implements SBP-2 initiator but I don't know if it
uses the physical response unit.  But this point is moot --- you can
boot from SBP-2 targets.
-- 
Stefan Richter
-=====-==--- --=- -=---
http://arcgraph.de/sr/
