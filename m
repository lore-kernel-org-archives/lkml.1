Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZJFEy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZJFEy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZJFEy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:54:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:45050 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZJFEy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:54:26 -0400
Subject: Re: Patch "USB: Work around BIOS bugs by quiescing USB controllers
 earlier" causes MCEs
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <npiggin@suse.de>, hpa@zytor.com, greg@kroah.com
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091006044401.GA30316@wotan.suse.de>
References: <20091002073400.GV6327@wotan.suse.de>
	 <19141.54587.207559.849751@pilspetsen.it.uu.se>
	 <19142.21600.475756.10647@pilspetsen.it.uu.se>
	 <20091006044401.GA30316@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 05:53:39 +0100
Message-Id: <1254804819.14541.101.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 06:44 +0200, Nick Piggin wrote:
> > Changing this quirk back to a FIXUP_FINAL allows the platform's PCI
> > init to complete. Later on the generic pci_init() calls the quirk,
> > which now gets the correct I/O base address, and the outw()s in
> > uhci_reset_hc() don't fail.
> 
> Thanks for this, I guess we await David's response.

The problem is that FIXUP_FINAL is too late. If the USB controllers are
still active at the time the IOMMU is initialised, then DMA for their
'legacy keyboard/mouse emulation' will go AWOL -- because the BIOS
authors are too incompetent to tell the OS about it correctly.

And then the whole system goes down, locked up in SMM mode because the
BIOS authors are too incompetent to write code which can _cope_ with the
DMA going AWOL. Or do any testing.

One option is to add a new quirk somewhere in the middle, or to invoke
the USB fixups manually rather than by the quirk mechanism.

Another might be to move the initialisation of the IOMMU to later in the
boot, so it happens just after the final PCI fixups.

But I distinctly remember a conversation, probably with hpa, in which he
(or whoever) said that he wants to kill the USB controllers even
_earlier_ in the boot process, because of other problems. So I was kind
of hoping that whoever it was would pipe up. And then we'd take that
option.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

