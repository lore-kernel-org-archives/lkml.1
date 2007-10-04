Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbXJDKCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbXJDKCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 06:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbXJDKCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 06:02:06 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59595 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbXJDKCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:02:05 -0400
Date: Thu, 4 Oct 2007 19:01:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-sh <linuxsh-dev@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix SH DMAC code to handle PVR2 cascade
Message-ID: <20071004100151.GA17628@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	linux-sh <linuxsh-dev@lists.sourceforge.net>,
	LKML <linux-kernel@vger.kernel.org>
References: <1191359367.17654.24.camel@localhost.localdomain> <20071003061805.GA8851@linux-sh.org> <63320.217.150.108.178.1191426097.squirrel@newgolddream.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63320.217.150.108.178.1191426097.squirrel@newgolddream.dyndns.info>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 04:41:37PM +0100, Adrian McMenamin wrote:
> On Wed, October 3, 2007 7:18 am, Paul Mundt wrote:
> > On Tue, Oct 02, 2007 at 10:09:27PM +0100, Adrian McMenamin wrote:
> >> Fix SH DMAC code to correctly handle PVR2 cascade DMA.
> >>
> >> This updates http://lkml.org/lkml/2007/10/2/276
> >>
> >> (I decided it was better to have the true size of the transfer put in
> >> via the API and refactor this here. And calc_xmit_shift(chan) should
> >> return 5 but only returns 3 so I've not used it here)
> >>
> > It would be helpful to know why calc_xmit_shift() is broken here rather
> > than just coding around it, as this will have implications for the other
> > DMA channels on SH7091/SH7750.
> 
> 
> >From include/asm-sh/cpu-sh4/dma.h
> 
> 53 /*
> 54  * The DMA count is defined as the number of bytes to transfer.
> 55  */
> 56 static unsigned int ts_shift[] __maybe_unused = {
> 57         [XMIT_SZ_64BIT]         = 3,
> 58         [XMIT_SZ_8BIT]          = 0,
> 59         [XMIT_SZ_16BIT]         = 1,
> 60         [XMIT_SZ_32BIT]         = 2,
> 61         [XMIT_SZ_256BIT]        = 5,
> 62 };
> 63 #endif
> 
> ie ts_shift returns the number of bytes per transfer, but is then used as
> a bit shift:
> 
Er, no it doesn't, try again. ts_shift returns the transfer size _shift_.
The comment refers to the DMA count, which is a different matter. Your
32-byte transfer where you want the >> 5 shift == ts_shift[XMIT_SZ_256BIT],
and there's nothing wrong with that. So the issue becomes why you don't
get a ts_shift[] offset of XMIT_SZ_256BIT for that channel, and that's
the bug that has to be fixed.

> 45 /*
> 46  * We determine the correct shift size based off of the CHCR transmit size
> 47  * for the given channel. Since we know that it will take:
> 48  *
> 49  *      info->count >> ts_shift[transmit_size]
> 50  *
> 51  * iterations to complete the transfer.
> 52  */
> 53 static inline unsigned int calc_xmit_shift(struct dma_channel *chan)
> 54 {
> 55         u32 chcr = ctrl_inl(CHCR[chan->chan]);
> 56
> 57         return ts_shift[(chcr & CHCR_TS_MASK)>>CHCR_TS_SHIFT];
> 58 }
> 
So for PVR2 cascade, what does the CHCR value work out to? Both
CHCR_TS_MASK and CHCR_TS_SHIFT haven't changed for SH7750, so this
suggests that either the CHCR value is just wrong or we've had a
long-standing bug with the CHCR.TS mask.

Either way, we are not going to hardcode a ts_shift value when the CHCR
has all of the information encoded in it!
