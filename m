Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXLFMdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXLFMdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXLFMdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:33:35 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:38069 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbXLFMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:33:34 -0500
Date: Thu, 6 Dec 2007 12:32:54 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Message-ID: <20071206123254.GA7185@linux-mips.org>
References: <200710122305.l9CN5tFI008240@hera.kernel.org> <1196899818.7033.11.camel@pasglop> <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net> <1196917447.7033.17.camel@pasglop> <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 02:58:13PM +0900, Yoichi Yuasa wrote:

> > What I don't understand is thus why you are calling resource_to_bus on 0x1f0
> > which is -not- a resource value, but is already a BAR value...
> 
> 0x1f0 is resource value on MIPS Cobalt.
> All RAW BAR values contain the offset(0x10000000) on it.

In arch/mips/cobalt/pci.c:

static struct resource cobalt_io_resource = {
        .start  = 0x1000,
        .end    = GT_DEF_PCI0_IO_SIZE - 1,
        .name   = "PCI I/O",
        .flags  = IORESOURCE_IO,
};

static struct pci_controller cobalt_pci_controller = {
	[...]
        .io_resource    = &cobalt_io_resource,
        .io_offset      = 0 - GT_DEF_PCI0_IO_BASE,
};

The .io_offset initialization looks odd; no other platform is trying to
use a negative offset here.  I think there was something odd with the
Galileo GT-64111 which (unlike its later sucessors such as the GT-64120)
passes memory accesses in the range 0x10000000 ... 0x11ffffff to the PCI
bus unmodified.  That is for example a load or store to physical address
0x100003f8 will become an I/O port access to 0x100003f8.

I hope this is just a missconfiguration of the GT-64111, time for manual
reading.

  Ralf
