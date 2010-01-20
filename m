Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328Ab0ATUWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0ATUWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870Ab0ATUWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:22:34 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1895 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab0ATUWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:22:33 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902
 check_sync
From: "Michael Chan" <mchan@broadcom.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
cc: "Jarek Poplawski" <jarkao2@gmail.com>,
       "David Miller" <davem@davemloft.net>,
       "Michael Breuer" <mbreuer@majjas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "flyboy@gmail.com" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Don Fry" <pcnet32@verizon.net>,
       "Francois Romieu" <romieu@fr.zoreil.com>,
       "Matthew Carlson" <mcarlson@broadcom.com>
In-Reply-To: <20100120100316.2b5b1b05@nehalam>
References: <20100120094103.GA6225@ff.dom.local>
 <20100120100316.2b5b1b05@nehalam>
Date: Wed, 20 Jan 2010 12:11:52 -0800
Message-ID: <1264018312.9030.76.camel@nseg_linux_HP1.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6749BA703J882888890-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2010-01-20 at 10:03 -0800, Stephen Hemminger wrote:
> On Wed, 20 Jan 2010 09:41:03 +0000
> Jarek Poplawski <jarkao2@gmail.com> wrote:
> > > Seems like an underlying bug in the DMA api. Maybe it just can't
> > > handle operations on partial mapping.
> > > 
> > > Other drivers with same problem:
> > >   bnx2, cassini, pcnet32, r8169, rrunner, skge, sungem, tg3, 
> > 
> > It seems using the same length (even without pci_unmap_len()) is
> > crucial here, but I hope maintainers (added to CC) will take care.
> > 

I'm still unsure how to do dma_sync properly in bnx2.  In the current
code, we always dma_sync_for_cpu a small portion of the SKB because the
rx descriptor is at the beginning of the SKB.  We get the packet length,
for example, from the rx descriptor.

If it's a big packet, we'll simply unmap the entire SKB buffer (with the
beginning portion already dma_sync'ed).  If the packet is smaller than
what we dma_sync'ed, we'll just copy the data to a new SKB.  We'll then
dma_sync_for_device the portion of the original buffer and recycle the
whole buffer back to the device for new packets.

So, is it correct to just change the dma_sync length to the full length
of the buffer?  It doesn't sound right to me.

Thanks.


