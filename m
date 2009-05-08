Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZEHOMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZEHOMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZEHOLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:11:52 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:1670 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171AbZEHOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:11:50 -0400
Date: Sat, 9 May 2009 00:11:47 +1000 (EST)
From: Tim Connors <tconnors+linuxkml@astro.swin.edu.au>
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: sata_sil24 EH complete
In-Reply-To: <alpine.DEB.2.00.0905061038340.14678@dirac.rather.puzzling.org>
Message-ID: <alpine.DEB.2.00.0905090005560.24222@dirac.rather.puzzling.org>
References: <alpine.DEB.2.00.0905060004100.15177@dirac.rather.puzzling.org> <4A00DA98.5060201@kernel.org> <alpine.DEB.2.00.0905061038340.14678@dirac.rather.puzzling.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Tim Connors wrote:

> On Wed, 6 May 2009, Tejun Heo wrote:
>
> > Tim Connors wrote:
> > > With 2.6.29, when I hotplug a western digital mybook into a 'Silicon
> > > Image, Inc. SiI 3132 Serial ATA Raid II Controller', the drive is not
> > > found:
> > >
> > >
> > > *** drive failed due to user induced sillyness
> > > ...
> > > [18676.308750] sd 0:0:0:0: [sdb] Stopping disk
> > > [18676.308770] sd 0:0:0:0: [sdb] START_STOP FAILED
> > > [18676.308774] sd 0:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> > > *** drive plugged back in
> > > [18767.821747] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
> > > [18767.821756] ata1: irq_stat 0x00b40090, PHY RDY changed
> > > [18767.821775] ata1: hard resetting link
> > > [18774.633185] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> > > [18774.773591] ata1.00: applying link speed limit horkage to 1.5 Gbps
> > > [18779.655674] ata1: hard resetting link
> > > [18781.861074] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
> > > [18782.178565] ata1.00: configured for UDMA/100
> > > [18782.178579] ata1: EH complete
> > >
> > > And then nothing.  The device is still alive - if I plug it back in
> > > through its usb interface, it comes up normally.  I know from experience
> > > that if I was to reboot the machine, it would have come up quite nicely
> > > from boot:
> >
> > Hmm... "ata1.00: configured for UDMA/100" means libata part of
> > configuration went okay but it looks like SCSI probing didn't kick in
> > for reason.  Is this always reproducible?
>
> 100% of time if it is plugged in after boot.

Hah, I lied.  Not 100% of the time.

With *some* combination perhaps of
> for host in 0 1 2 3 ; do ; echo "- - -" > /sys/class/scsi_host/host$host/scan ; done
and
> scsiadd -s
when the drive is plugged in and when it isn't plugged in (or maybe even
just leaving it alone) and plugging and unplugging it repeadedly,
eventually (maybe 20% of the time?) it comes good:

[278081.974683] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe
frozen
[278081.974689] ata1: irq_stat 0x00a00080, device exchanged
[278081.974703] ata1: limiting SATA link speed to 1.5 Gbps
[278081.974708] ata1: hard resetting link
[278091.984170] ata1: softreset failed (timeout)
[278091.984200] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[278091.984209] ata1: link online but device misclassified, retrying
[278091.984215] ata1: hard resetting link
[278094.196137] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[278094.333982] ata1.00: ATA-6: WD My Book, 01.01A01, max UDMA/133
[278094.333990] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 1)
[278094.506583] ata1.00: configured for UDMA/100
[278094.506601] ata1: EH complete
[278094.506805] scsi 0:0:0:0: Direct-Access     ATA      WD My Book
01.0 PQ: 0 ANSI: 5
[278094.508717] sd 0:0:0:0: [sde] 1953525168 512-byte hardware sectors:
(1.00 TB/931 GiB)
[278094.508752] sd 0:0:0:0: [sde] Write Protect is off
[278094.508759] sd 0:0:0:0: [sde] Mode Sense: 00 3a 00 00
[278094.508815] sd 0:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[278094.508969] sd 0:0:0:0: [sde] 1953525168 512-byte hardware sectors:
(1.00 TB/931 GiB)
[278094.509003] sd 0:0:0:0: [sde] Write Protect is off
[278094.509009] sd 0:0:0:0: [sde] Mode Sense: 00 3a 00 00
[278094.509064] sd 0:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[278094.509076]  sde: sde1
[278094.581084] sd 0:0:0:0: [sde] Attached SCSI disk

Maybe it's a bit worrying, but subsequent to this, it spontaneously
occasionally says:
[279339.156950] ata1: hard resetting link
[279341.280088] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[279341.590803] ata1.00: configured for UDMA/100
[279341.590815] ata1: EH complete
[279341.627787] sd 0:0:0:0: [sde] 1953525168 512-byte hardware sectors:
(1.00 TB/931 GiB)
[279341.698493] sd 0:0:0:0: [sde] Write Protect is off
[279341.698500] sd 0:0:0:0: [sde] Mode Sense: 00 3a 00 00
[279341.698572] sd 0:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA

It's done that twice in the half hour or so (as raid is recovering) that
it's been up so far.

-- 
TimC
It's the _target_ that supposed to go "F00F", not the processor.
              -- Mike Andrews, on Pentiums in missiles
