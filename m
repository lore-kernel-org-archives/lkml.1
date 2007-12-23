Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbXLWLDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbXLWLDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 06:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbXLWLDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 06:03:24 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:37333 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXLWLDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 06:03:23 -0500
Date: Sun, 23 Dec 2007 14:03:37 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: Loic Prylli <loic@myri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
Message-ID: <20071223110337.GA25441@jurassic.park.msu.ru>
References: <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476DF5BE.5030004@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 12:44:30AM -0500, Jeff Garzik wrote:
> Failures are more predictable and more consistent with an all-or-none 
> scenario.  The all-or-none solutions are the least complex on the software 
> side, and far more widely tested than any mixed config access scheme.

Nope. The vast majority of mmconfig problems that happen at boot time
actually have nothing to do with "broken" or "working" mmconfig.
Typically these are
- mmconf area overlapped during BAR sizing;
- BIOS (or kernel) placed some MMIO in the middle of mmconfig area,
  which looks like some random device "doesn't like mmconfig".

This is a result of all-or-none approach, as mmconfig is fundamentally
unsafe until after PCI init is done.

The mixed access that Loic proposes allows to avoid these boot problems
just for free. Systems that have both non-mmconf PCI(X) and mmconf PCI-E
domains could be handled almost for free as well.
And probably most important thing is that the x86 pci_conf implementation
would be so much simpler and cleaner that I honestly don't understand
why are we still discussing it ;-)

At the same time, making drivers to request extended config space
still makes sense. I think of pci_request_ext_conf(dev, drv_name) which
doesn't set any per-device flag, but
- returns success or failure depending on mmconf availability;
- can be logged by kernel to make it easier to debug if something
  goes wrong.

Ivan.
