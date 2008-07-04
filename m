Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYGDVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYGDVjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYGDVjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:39:10 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:48320 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYGDVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:39:09 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_it821x completely broken
Date: Fri, 4 Jul 2008 23:39:00 +0200
User-Agent: KMail/1.9.9
Cc: alan@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <20080704212204.7c94ca7c@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704212204.7c94ca7c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807042339.02444.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2008 22:22:04 Alan Cox wrote:
> > When I don't have any RAID array created, both drives are detected but it
> > appears to work only in MWDMA2 mode:
>
> The speed is meaningless in hardware RAID mode. Its also btw usually
> faster (except for some cases of RAID1 with high PCI bus utilisation like
> video capture boxes) in non RAID mode ;)
>
> > ata3: PATA max MWDMA2 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
> > ata4: PATA max MWDMA2 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
>
> I'll have a poke at that, see if I can make it lie more meaningfully
>
> > ata4.00: configured for DMA
>
> as it does here.

OK, so it's not a bug, it's a (missing) feature.

>
> > Also I get some errors about HPA when rebooting but haven't captured them
> > yet.
>
> IT821x does not support the HPA in 'raid' mode, only in non RAID mode so
> it would complain about the HPA.

It complains pretty loudly - something like 3 screens (with framebuffer at 
1024x768) of errors like this:

sd 3:0:0:0: [sdc] Synchronizing SCSI cache
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata4.00: status: { DRDY }
ata4.00: failed to read native max address (err_mask=0x1)
ata4.00: HPA support seems broken, skipping HPA handling
ata4.00: revalidation failed (errno=-5)
ata4: failed to recover some devices, retrying in 5 secs

Maybe it should just not do anything with HPA if it's not supported (but I 
don't know libata internals).

>
> > But the more interesting thing is that once I create a RAID1 array (and
> > run background rebuild), the driver does not work anymore:
>
> Ok that is a bug I've not met. What firmware revision is this and does it
> work after the rebuild is done ?

It's BIOS v1.7.1.94, firmware 02093030. Haven't tried waiting for the rebuild 
to complete. It will probably take ages for 400GB drives. I'll try with some 
much smaller drives (something <1GB).

>
> > ata3.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_masl=0x80)
> > ata3: failed to recover some devices, retrying in 5 secs
> > ata3.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_masl=0x80)
> > ata3: failed to recover some devices, retrying in 5 secs
> > ata3.00: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_masl=0x80)
> > ata3: failed to recover some devices, retrying in 5 secs
>
> It seems to have decided to be indefinitely busy from that.
>
> Alan



-- 
Ondrej Zary
