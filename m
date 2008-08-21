Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbYHUUT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbYHUUT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYHUUTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:19:20 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11525 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbYHUUTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:19:19 -0400
Date: Thu, 21 Aug 2008 14:19:18 -0600
From: Alex Chiang <achiang@hp.com>
To: gregkh@suse.de
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: refcount leak in pci_get_device()?
Message-ID: <20080821201918.GA24411@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, gregkh@suse.de,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

While playing around with my slot symlink stuff, I noticed that
the following sequence is problematic:

	1. clean boot
	2. modprobe acpiphp
	3. echo 0 > /sys/bus/pci/slots/N/power
	4. ???

After step 3, we *should* be seeing pci_release_dev() getting
called, but we never do because the refcount on the device is
still quite high (5 or 6, on my ia64 system).

I'm still trying to track this down, but I did notice, via code
inspection, at least one suspicious area:

#define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)

That eventually calls pci_get_dev_by_id(), which increases the
refcount on the device, but never decrements it.

Looks like that change in behavior happened here:

	PCI: clean up search.c a lot
	95247b57ed844511a212265b45cf9a919753aea1

pci_get_device() used to decrement the refcount, but no longer
does.

Thanks to Matthew Wilcox for helping me get this far...

Like I said, I'm still trying to track down my particular issue,
but I'd like to get your opinion on this.

Thanks!

/ac

