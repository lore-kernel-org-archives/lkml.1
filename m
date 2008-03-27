Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYC0Ndu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYC0Ndu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbYC0Nbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:31:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760573AbYC0Nbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:31:33 -0400
Date: Thu, 27 Mar 2008 14:34:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: iommu breaks usb after resume
Message-ID: <20080327133451.GH29105@one.firstfloor.org>
References: <20080320111429.GA14764@elf.ucw.cz> <20080321135418.GB2346@one.firstfloor.org> <20080326102151.GB18965@elf.ucw.cz> <20080326130052.GF2170@one.firstfloor.org> <20080326225407.GA9378@elf.ucw.cz> <20080326230017.GA21017@elte.hu> <20080327084231.GC25876@elf.ucw.cz> <20080327095949.GA5771@elf.ucw.cz> <20080327114923.GA6589@basil.nowhere.org> <20080327132923.GA12801@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327132923.GA12801@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 02:29:23PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > ...this sounds like it needs to be done during resume, too, no?
> > 
> > This is only a workaround for BIOS that don't set up an aperture,
> > but yes if they don't do that it is likely needed on resume too.
> > 
> > You would need to add a resume handler to aperture.c
> 
> Probably this needs to be redone during resume, right?

Yes, but using the standard pci access functions to avoid races which
the early boot code can ignore.

> 
> 	/* Fix up the north bridges */
> 	for (num = 24; num < 32; num++) {
> 		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
> 			continue;
> 
> 		/*
> 		 * Don't enable translation yet. That is done later.
> 		 * Assume this BIOS didn't initialise the GART so
> 		 * just overwrite all previous bits
> 		 */
> 		write_pci_config(0, num, 3, 0x90, aper_order<<1);
> 		write_pci_config(0, num, 3, 0x94, aper_alloc>>25);
> 	}
> 
> ....plus the "enable translation" part... but where is that hiding?

Both pci-gart and the AGP driver have code for this.

-Andi

