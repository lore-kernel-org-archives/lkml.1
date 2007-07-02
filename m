Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbXGBOgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbXGBOgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXGBOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:36:29 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:48841 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXGBOg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:36:27 -0400
From: Chr <chunkeey@web.de>
To: Thorsten Leemhuis <fedora@leemhuis.info>
Subject: Re: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel Santa Rosa PATA controller
Date: Mon, 2 Jul 2007 16:36:24 +0200
User-Agent: KMail/1.9.7
Cc: Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jason Gaston <jason.d.gaston@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <468408F1.3080307@redhat.com> <200707021324.17250.chunkeey@web.de> <4688E519.7040308@leemhuis.info>
In-Reply-To: <4688E519.7040308@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021636.25192.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+YG3/JHmdj1VOdfR18ga/jisScIT4ou8VRxrws
	FTtvZv4UOwSUSk8VgDOKMHrrVkur/SKt9kr0OStqsfsU81lDTB
	N3a+cNPbg=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 2. July 2007, Thorsten Leemhuis wrote:
> > but Alan Cox wrote:
> > http://www.mail-archive.com/linux-ide%40vger.kernel.org/msg07417.html
> >> Its ich_pata_133 - all the newer chips are.
> 
> Intel afaik never supported Ultra ATA 133 officially in any of the
> mainstream desktop or mobile chipsets.

You're probably right! But, what about Intel's ICH5 and ICH7/7-R (i945, i975)?

see ata_piix.c: line 193ff
	{ 0x8086, 0x24DB, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },
[...]
	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_133 },

On the other hand, we can leave it, because of a "off-by-one error" in ata_piix.c, 
do_pata_set_dmamode, line ~770:

(the comment is important!)
/*
 * --> UDMA is handled by a combination of clock switching and
 * selection of dividers <---
 * [...]
 */
u_speed = min(2 - (udma & 1), udma);
if (udma == 5)
	u_clock = 0x1000;	/* 100Mhz */ <-- wrong! it's 133Mhz.
else if (udma > 2)
	u_clock = 1;		/* 66Mhz */
else
	u_clock = 0;		/* 33Mhz */

=>
for udma = 6(133MB/s) , we get u_speed=2 and u_clock=1
for udma = 4(66MB/s), we get the "same" values! (u_speed=2 and u_clock=1)

...
so, atleast for ata_piix, UDMA6 and UDMA4 *is* the same, right?

> 
> >> They work even better if you
> >> set them into AHCI mode in the BIOS and then they should "just work" with
> >> recent kernels as the AHCI driver now matches by class.
> > And "Gaston, Jason D" <jason.d.gaston@intel.com> didn't complain about it.
> > it's a "bit" confusing with all "native" AHCI SATA chipset that have to emulate 
> > PATA for compatibility reasons... 
> 
> Well, just FYI: on my Laptop AHCI is enabled and used for the SATA hard
> disk. But the DVD drive still is a pata one afaics (I'm not in front of
> the machine, so I can't check), connected via the pata controller -- so
> for me there is no emulation involved (at least afaics).
> 
I know. I wanted to say something else... but it doesn't really matter
(not every operating system supports AHCI-only controllers by default...)

Thanks, 
	Chr.

