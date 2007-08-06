Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXHFO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXHFO52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764231AbXHFO5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:57:19 -0400
Received: from mo30.po.2iij.NET ([210.128.50.53]:16233 "EHLO mo30.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbXHFO5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:57:18 -0400
Date: Mon, 6 Aug 2007 23:56:55 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: jeff@garzik.org
Cc: yoichi_yuasa@tripeaks.co.jp, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] fix IDE legacy mode resource
Message-Id: <20070806235655.0a9a09af.yoichi_yuasa@tripeaks.co.jp>
In-Reply-To: <20070729171544.2b352801.yoichi_yuasa@tripeaks.co.jp>
References: <20070728220420.352c316b.yoichi_yuasa@tripeaks.co.jp>
	<46AB8732.6080109@garzik.org>
	<20070729171544.2b352801.yoichi_yuasa@tripeaks.co.jp>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jeff,

Do you have any comments?

On Sun, 29 Jul 2007 17:15:44 +0900
Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp> wrote:

> On Sat, 28 Jul 2007 14:13:06 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
> > Yoichi Yuasa wrote:
> > > Hi,
> > > 
> > > I got the following error on MIPS Cobalt.
> > > MIPS Cobalt has the 0x10000000 offset between resource and bus region. 
> > > 
> > > PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
> > > pata_via 0000:00:09.1: failed to request/iomap BARs for port 0 (errno=-16)
> > > PCI: Unable to reserve I/O region #3:8@f0000170 for device 0000:00:09.1
> > > pata_via 0000:00:09.1: failed to request/iomap BARs for port 1 (errno=-16)
> > > pata_via 0000:00:09.1: no available native port
> > > 
> > > At this point, these resources should be the bus regions.
> > > 
> > > Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> > 
> > I'm not sure I understand what's going on here... could you or someone 
> > provide additional explanation as to why this is a fix?
> 
> The legacy mode IDE resources set the following order. 
> 
> pci_setup_device()
>     Legacy mode ATA controllers have fixed addresses.
>     IDE resources: 0x1F0-0x1F7, 0x3F6, 0x170-0x177, 0x376
>     |
>     V
> pcibios_fixup_bus()
>     MIPS Cobalt PCI bus have the -0x10000000 offset from PCI resources.
>     pcibios_fixup_bus() fix PCI bus regions.
>     0x1F0 - 0x10000000 = 0xF00001F0
>     |
>     V
> ata_pci_init_one()
>     PCI: Unable to reserve I/O region #1:8@f00001f0 for device 0000:00:09.1
> 
> In some architectures, PCI bus have the offset from PCI resource.
> They are adjusted by pcibios_fixup_bus().
> 
> For this reason, pci_setup_device() should set PCI bus regions. 
