Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXBFEzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXBFEzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 23:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXBFEzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 23:55:36 -0500
Received: from colo.lackof.org ([198.49.126.79]:53104 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbXBFEzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 23:55:36 -0500
Date: Mon, 5 Feb 2007 21:55:28 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com, Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Message-ID: <20070206045528.GA4228@colo.lackof.org>
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 05:09:01AM +0400, Manu Abraham wrote:
> Hi,
> 
> I get this error on booting up 2.6.20 (Similar error on 2.6.17.7 also,
> the message is slightly different in 2.6.17.7)
> 
> PCI Cannot allocate resource region 2 of device 0000:02:0a.0
> PCI Error while updating region 000:02:0a.0/5 (f3e00004 != 0200)
> PCI Error while updating region 000:02:0a.0/5 (high 00000000 != 4e351)

...
> The last 2 devices are Rev 1 chips, whereas the one which is acting a
> bit strange is a newer version from the same vendor.

> Any ideas as to why it could not allocate the region ?

Looks like the HW is broken.


This bridge:

> 00:1e.0 0604: 8086:244e (rev c2)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
> 	I/O behind bridge: 0000d000-0000dfff
> 	Memory behind bridge: f3e00000-f7efffff
> 	Prefetchable memory behind bridge: e9b00000-e9bfffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR+
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

will only route 0xf3e... to 0xf7efff... 
The attempt to assign f3e00004 is just trying to put a valid value in the BAR.
So I think linux is _trying_ to DTRT.

> 02:0a.0 4e35: 1800:4e35 (rev 08) (prog-if 18)
> 	Subsystem: 002c:c200
> 	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
> 	Latency: 0, Cache Line Size 0c
> 	BIST is running

BIST is required to complete in 2 seconds. Either with success or failure.
I expect BIOS to have complained before launching grub/lilo.
You might look for that on the next reboot and if possible use a
serial console to log all output or look for BIOS warnings or
logged "events".

But all bets are off regarding programming the device as
long as BIST is running. The only PCI requirement is the device
not interfere with "operation of other devices on the bus".


> 	Region 0: Memory at f7ee0000 (32-bit, non-prefetchable) [disabled] [size=4K]
> 	Region 2: Memory at e9b00000 (32-bit, prefetchable) [disabled] [size=4K]
> 	Region 3: Memory at <unassigned> (32-bit, prefetchable) [disabled]
> 	Region 4: Memory at <ignored> (32-bit, non-prefetchable) [disabled]
> 	Region 5: Memory at <invalid-64bit-slot> (64-bit, non-prefetchable) [disabled]

This is obviously garbage. 64-bit registers can only be represented with
two consecutive "BAR" and region 5 is the last one.
There is no way this can be a 64-bit BAR.
Generally, 64-bit BARs start on an "even" numbered BAR (but I've forgotten
again if that's just convention or a requirement)

hth,
grant
