Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbXLMDAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbXLMDAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 22:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXLMDA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 22:00:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:53023 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXLMDA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 22:00:27 -0500
Subject: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 14:00:04 +1100
Message-Id: <1197514804.15741.60.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While reworking the powerpc PCI resource management, to make it more
x86-like and use more of the generic code in setup-bus.c and
setup-res.c, I noticed something a bit fishy in the way we deal with
resources that we failed to assign.

That's especially problematic for us as we have to deal with all sort of
more or less crappy firmwares, so we need our PCI code to be as robust
as possible vs. whatever might have been there before the kernel kicks
in.

Now, let's say that we have a device for which a BAR contain a value out
of whack or conflicting with something else. We "see" that in
pcibios_allocate_resources() and set res->start to 0 (and offset
res->end accordingly).

At this stage, we thus have a resource that is marked as unassigned.
However, we haven't actually modified the BAR content. So the device is
still potentially decoding the conflicting addresses (which may have
been allocated to some other device).

Now, normally, pci_assign_unassigned_resources() will take care of that
and assign some new address to this device. However, that may fail
(bridge window too small for example). Which mean we leave a device with
a dangling BAR. In fact, a driver may even successfully call
pci_enable_device_bars() on it, provided that the device has several
resources and that the one that is/are requested by the driver (via the
bitmask argument) are not the one(s) that failed to allocate.

So not only we can have a dangling BAR, but nothing prevent us to
actually go turn IO or MEM decoding on in case it wasn't already the
case on that device.

Ben.


