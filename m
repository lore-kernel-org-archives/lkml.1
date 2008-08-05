Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbYHENFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbYHENFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbYHENE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:04:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:60794 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257AbYHENE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:04:56 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
In-Reply-To: <20080805113111.GA6827@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	 <1217910588.24157.151.camel@pasglop>
	 <20080805113111.GA6827@pingi.kke.suse.de>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 23:04:26 +1000
Message-Id: <1217941466.24157.190.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks for this hint, I didn't know that the repetive versions are
> for byte streams and not for eg. transfer of multiple u32.
> So it makes things lot easier the code should look like:
> 
> 	int l = len >> 2;
> 
> 	if (l) {
> 		ioread32_rep(hc->pci_membase + A_FIFO_DATA0, data, l);
> 		data += l << 2;
> 	}
> 	if (len & 2) {
> 		ioread16_rep(hc->pci_membase + A_FIFO_DATA0, data, 1);
> 		data += 2;
> 	}
> 	if (len & 1)
> 		writeb(*data, hc->pci_membase + A_FIFO_DATA0);

Don't mix the io* variants with the PCI variants. Use iowrite8 for the
last one and make sure you do a proper pci_iomap.

One cool thing with the new iomap stuff is that it also works for both
PIO and MMIO, so you no longer need to differenciate writeX from outX
as long as you use the right mapping stuff initially.

Ben.


