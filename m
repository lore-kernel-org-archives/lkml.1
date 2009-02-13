Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZBMOnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZBMOnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761155AbZBMOmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:42:43 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:16668 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758937AbZBMOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:42:41 -0500
Date: Fri, 13 Feb 2009 17:42:38 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 10/11] sdhci: Add quirk for Freescale eSDHC controllers
Message-ID: <20090213144238.GA12304@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru> <20090206180701.GJ11548@oksana.dev.rtsoft.ru> <20090208221209.628ae782@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090208221209.628ae782@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 10:12:09PM +0100, Pierre Ossman wrote:
> On Fri, 6 Feb 2009 21:07:01 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > This patch adds SDHCI_QUIRK_FSL quirk. The quirk is used to instruct
> > the sdhci driver about various FSL eSDHC host incompatibilities:
> > 
> 
> No device quirks please. They should be for specific bugs, not lumping
> things together like this. Otherwise we'll soon have an unmanageable
> mess.

OK.

> > 1) FSL eSDHC controllers can support maximum block size up to 4096
> >    bytes. The MBL (Maximum Block Length) field in the capabilities
> >    register extended by one bit.
> > 
> >    (Should we implement a dedicated quirk for this? I.e.
> >     SDHCI_QUIRK_MAX_BLK_SZ_4096?)
> > 
> 
> Yes please. It would have to mean "always support 4096" though, not
> "turn reserved bit 18 into a block length bit".

OK.

> > 2) sdhci_init() is needed after error conditions.
> > 
> >    (Can we safely do this for all controllers?)
> > 
> 
> Please investigate which part of sdhci_init() is needed. How does it
> break without this?

After reset eSDHC lose signal/interrupt enable states:

Before reset:

sdhci: ============== REGISTER DUMP ==============
sdhci: Sys addr: 0x00000008 | Version:  0x00000000
sdhci: Blk size: 0x00000008 | Blk cnt:  0x00000000
sdhci: Argument: 0x000001aa | Trn mode: 0x00000000
sdhci: Present:  0xff850000 | Host ctl: 0x00000021
sdhci: Power:    0x00000000 | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00001077
sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
sdhci: Int enab: 0x007f0003 | Sig enab: 0x007f0003
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000001
sdhci: Caps:     0x01e30000 | Max curr: 0x00000000
sdhci: ===========================================

after sdhci_reset(host, SDHCI_RESET_CMD):

sdhci: ============== REGISTER DUMP ==============
sdhci: Sys addr: 0x00000008 | Version:  0x00000000
sdhci: Blk size: 0x00000008 | Blk cnt:  0x00000000
sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
sdhci: Present:  0xff850000 | Host ctl: 0x00000021
sdhci: Power:    0x00000000 | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00001077
sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
sdhci: Int enab: 0x017f0003 | Sig enab: 0x00700002
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000001
sdhci: Caps:     0x01e30000 | Max curr: 0x00000000
sdhci: ===========================================

After sdhci_reset(host, SDHCI_RESET_DATA):

sdhci: ============== REGISTER DUMP ==============
sdhci: Sys addr: 0x00000008 | Version:  0x00000000
sdhci: Blk size: 0x00000008 | Blk cnt:  0x00000000
sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
sdhci: Present:  0xff850000 | Host ctl: 0x00000021
sdhci: Power:    0x00000000 | Blk gap:  0x00000000
sdhci: Wake-up:  0x00000000 | Clock:    0x00001077
sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
sdhci: Int enab: 0x117f003f | Sig enab: 0x00000000
sdhci: AC12 err: 0x00000000 | Slot int: 0x00000001
sdhci: Caps:     0x01e30000 | Max curr: 0x00000000
sdhci: ===========================================

> > 3) Small udelay is needed to make eSDHC work in PIO mode. Without
> >    the delay reading causes endless interrupt storm, and writing
> >    corrupts data. The first guess would be that we must wait for
> >    some bit in some register, but I didn't find any reliable bits
> >    that changes before and after the delay. Though, more investigation
> >    on this is in my todo list.
> 
> Please try to investigate more, but if you cannot improve it further
> then a specific quirk can be added.

No luck so far... :-/


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
