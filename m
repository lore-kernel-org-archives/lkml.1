Return-Path: <linux-kernel-owner+w=401wt.eu-S1763394AbYHERjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763394AbYHERjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761291AbYHERjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:39:24 -0400
Received: from mail.suse.de ([195.135.220.2]:53880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762911AbYHERjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:39:23 -0400
Date: Tue, 5 Aug 2008 19:25:49 +0200
From: Karsten Keil <kkeil@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080805172549.GA6052@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de> <1217910588.24157.151.camel@pasglop> <20080805113111.GA6827@pingi.kke.suse.de> <1217941466.24157.190.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217941466.24157.190.camel@pasglop>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 11:04:26PM +1000, Benjamin Herrenschmidt wrote:
> 
> > Thanks for this hint, I didn't know that the repetive versions are
> > for byte streams and not for eg. transfer of multiple u32.
> > So it makes things lot easier the code should look like:
> > 
> > 	int l = len >> 2;
> > 
> > 	if (l) {
> > 		ioread32_rep(hc->pci_membase + A_FIFO_DATA0, data, l);
> > 		data += l << 2;
> > 	}
> > 	if (len & 2) {
> > 		ioread16_rep(hc->pci_membase + A_FIFO_DATA0, data, 1);
> > 		data += 2;
> > 	}
> > 	if (len & 1)
> > 		writeb(*data, hc->pci_membase + A_FIFO_DATA0);
> 
> Don't mix the io* variants with the PCI variants. Use iowrite8 for the
> last one and make sure you do a proper pci_iomap.

Yes, OK it need some cleanups in other places as well.

> 
> One cool thing with the new iomap stuff is that it also works for both
> PIO and MMIO, so you no longer need to differenciate writeX from outX
> as long as you use the right mapping stuff initially.
> 

Yes this stuff looks really cool, but unfortunately in our case it is not
so easy to remove the different IO functions for MMIO and PIO, since for
MMIO the chip use a flat register model, for PIO it use indirect addressing
via only 2 ports, one for the register offset and one for the data IO.

Maybe we can use the trick from lib/iomap.c to detect which
kind of IO is needed, but unfortunately PIO_OFFSET, PIO_MASK and
PIO_RESERVED are not exported so it would need to copy the defines, which
isn't a really clean solution.

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
