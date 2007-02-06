Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbXBFFUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbXBFFUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbXBFFUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:20:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:2917 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbXBFFUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UBID7PAXT7Dxf2y3B+YuwRawUAoFESSRCbRIgzAcPo2jzS0BpC6o97r5PfYbi3npjFpVcduYjLr9JV6/KguB13EyzGZHuj8gw3ZV0Wo7yne/tqDakxL39TmFvUp1f/dnk//A67kamGUHB6VwtoLptOlWCZftBFV2CX4hY7gCoEc=
Message-ID: <1a297b360702052120x10f15b4cicaa867573d0210b9@mail.gmail.com>
Date: Tue, 6 Feb 2007 09:20:15 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20070206045528.GA4228@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Grant Grundler <grundler@parisc-linux.org> wrote:
> On Mon, Feb 05, 2007 at 05:09:01AM +0400, Manu Abraham wrote:
> > Hi,
> >
> > I get this error on booting up 2.6.20 (Similar error on 2.6.17.7 also,
> > the message is slightly different in 2.6.17.7)
> >
> > PCI Cannot allocate resource region 2 of device 0000:02:0a.0
> > PCI Error while updating region 000:02:0a.0/5 (f3e00004 != 0200)
> > PCI Error while updating region 000:02:0a.0/5 (high 00000000 != 4e351)
>
> ...
> > The last 2 devices are Rev 1 chips, whereas the one which is acting a
> > bit strange is a newer version from the same vendor.
>
> > Any ideas as to why it could not allocate the region ?
>
> Looks like the HW is broken.


ah, was thinking about this. :-)


> This bridge:
>
> > 00:1e.0 0604: 8086:244e (rev c2)
> >       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> >       Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> >       Latency: 0
> >       Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
> >       I/O behind bridge: 0000d000-0000dfff
> >       Memory behind bridge: f3e00000-f7efffff
> >       Prefetchable memory behind bridge: e9b00000-e9bfffff
> >       Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR+
> >       BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>
> will only route 0xf3e... to 0xf7efff...
> The attempt to assign f3e00004 is just trying to put a valid value in the BAR.
> So I think linux is _trying_ to DTRT.
>
> > 02:0a.0 4e35: 1800:4e35 (rev 08) (prog-if 18)
> >       Subsystem: 002c:c200
> >       Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> >       Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
> >       Latency: 0, Cache Line Size 0c
> >       BIST is running
>
> BIST is required to complete in 2 seconds. Either with success or failure.
> I expect BIOS to have complained before launching grub/lilo.


BIOS didn't say anything at all.


> You might look for that on the next reboot and if possible use a
> serial console to log all output or look for BIOS warnings or
> logged "events".
> But all bets are off regarding programming the device as
> long as BIST is running. The only PCI requirement is the device
> not interfere with "operation of other devices on the bus".
>

BIST is supposed to terminate before, say the OS kernel is loaded ? or
does it mean that it  can keep running still ?

>
> >       Region 0: Memory at f7ee0000 (32-bit, non-prefetchable) [disabled] [size=4K]
> >       Region 2: Memory at e9b00000 (32-bit, prefetchable) [disabled] [size=4K]
> >       Region 3: Memory at <unassigned> (32-bit, prefetchable) [disabled]
> >       Region 4: Memory at <ignored> (32-bit, non-prefetchable) [disabled]
> >       Region 5: Memory at <invalid-64bit-slot> (64-bit, non-prefetchable) [disabled]
>
> This is obviously garbage. 64-bit registers can only be represented with
> two consecutive "BAR" and region 5 is the last one.
> There is no way this can be a 64-bit BAR.
> Generally, 64-bit BARs start on an "even" numbered BAR (but I've forgotten
> again if that's just convention or a requirement)
>

was just wondering how it could be a 64 bit device.

> hth,
> grant
>


Thanks a lot for the valuable info. I had not ruled out the option
that it could be broken.
I will try the device in the other OS also, to confirm this. Will post
the status after that.
But most probably as you said, could be broken.

Thanks,
Manu
