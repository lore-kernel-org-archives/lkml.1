Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbYHELbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbYHELbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYHELbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:31:17 -0400
Received: from ns2.suse.de ([195.135.220.15]:34107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbYHELbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:31:14 -0400
Date: Tue, 5 Aug 2008 13:31:11 +0200
From: Karsten Keil <kkeil@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
Message-ID: <20080805113111.GA6827@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de> <1217910588.24157.151.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217910588.24157.151.camel@pasglop>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 02:29:48PM +1000, Benjamin Herrenschmidt wrote:
> On Sat, 2008-08-02 at 16:35 +0200, Karsten Keil wrote:
> > The driver was not so bad at big endian at all, only the optimised fifo
> > read/write functions need a fix, with this fix the driver works on
> > a pegasus PPC machine.
> 
> This is however very broken... IE, you should instead use iomap
> and thus get ioreadXX_rep() and writeXX_rep() (XX = 16 or 32) that
> will do the right thing for you. IE, they will do the right amount
> of memory barriers and will avoid the unnecessary double-swapping
> you are doing there.
> 

Thanks for this hint, I didn't know that the repetive versions are
for byte streams and not for eg. transfer of multiple u32.
So it makes things lot easier the code should look like:

	int l = len >> 2;

	if (l) {
		ioread32_rep(hc->pci_membase + A_FIFO_DATA0, data, l);
		data += l << 2;
	}
	if (len & 2) {
		ioread16_rep(hc->pci_membase + A_FIFO_DATA0, data, 1);
		data += 2;
	}
	if (len & 1)
		writeb(*data, hc->pci_membase + A_FIFO_DATA0);

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
