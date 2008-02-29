Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYB2Cie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYB2Cie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYB2CiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:38:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:50200 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbYB2CiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:38:09 -0500
Subject: Weirdness in pci_read_bases()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 13:37:47 +1100
Message-Id: <1204252667.15052.402.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

There is something dodgy going on in pci_read_bases().

In addition to the fact (or related to it) that we tend to treat
res->start == 0 as meaning "unassigned" (which at this stage is mostly
incorrect, but let's say I can cope), however, there is some bit of code
that I think is just plain wrong:

		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
		pci_read_config_dword(dev, reg, &l);
		pci_write_config_dword(dev, reg, ~0);
		pci_read_config_dword(dev, reg, &sz);
		pci_write_config_dword(dev, reg, l);
		if (!sz || sz == 0xffffffff)
			continue;
		if (l == 0xffffffff)
			l = 0;

So here, we read the BAR value, which at this stage could either be some
assigned address or some ff's from a freshly unassigned BAR. _however_
that test against 0xffffffff looks totally bogus to me.

If we read that value, we write 0 in l. Which means that if we read some
unassigned resource that had the address space bits set to IO, we
overwrite this with a bit encoding that means Memory, and further along,
start sizing & treating this as a memory resource.

In fact, a BAR value should always contain a 0 bit. A Memory BAR must
contain a 0 at the bottom, and an IO BAR should contain a 0 in bit 1.
And we do check that case fine when reading back sz.

Thus a l value of 0xffffffff should not happen in practice, and if it
does, we should -at-least- try to get the address space bits from sz
(since in this case sz looks allright), not from l, no ? Or maybe just
skip the whole resource ?

Do we have practical cases where we see that 0xffffffff value ?

This isn't a problem I'm encountering in practice. I just noticed that
while trying to audit what it would take to fix the code to stop using
res->start = 0 as a way to mark unassigned resources (unrelated), so it
doesn't -need- to be fixed per-se, but I'm curious where that came from
in the first place.

Cheers,
Ben.


