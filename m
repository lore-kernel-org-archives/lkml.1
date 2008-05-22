Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYEVTXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYEVTXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYEVTXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:23:10 -0400
Received: from www.tglx.de ([62.245.132.106]:59005 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbYEVTXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:23:08 -0400
Date: Thu, 22 May 2008 21:22:52 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Uwe =?utf-8?B?S2xlaW5lLUvDg8K2bmln?= <Uwe.Kleine-Koenig@digi.com>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 0/1] UIO: Add a write() function to enable/disable
	interrupts
Message-ID: <20080522192252.GB3226@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, I've got two examples of hardware where the UIO interrupt
handling has problems:

1) A PCI card with several internal interrupt sources that can activate
the single IRQ line of the card. The card's PCI bridge has an irq
acknowledge register that can be mapped to userspace, but setting a bit
in it would be a read-modify-write operation which is racy from
userspace.

2) An FPGA that has several internal interrupt sources OR'ed to one
interrupt line that is connected to a GPIO of an ARM processor. The chip
only has a single IRQ register where different bits show the status of
the different interrupt sources. To acknowledge an IRQ, I have to clear
the respective bit, which would leave the userspace part of the driver
with a cleared register, unable to determine the source of the
interrupt. My only chance is to disable the GPIO interrupt, but this
leads to the problem that userspace cannot turn it on again.

The patch that I'll send in response to this mail solves these problems by
adding a write() function for /dev/uioX. Userspace can write a 32-bit
int value to /dev/uioX. This value will usually be 0 or 1 to disable or
enable the device's interrupts. The kernel part of the driver can
implement an irqcontrol() hook that is called by the UIO core.

Magnus Damm also ran into this problem when developing a generic UIO
platform handler and came up with a different solution:

http://lkml.org/lkml/2008/5/21/60

However, extending the UIO specs by adding a write function seems to be
a more generic approach. It allows enabling _and_ disabling of
interrupts. For devices that don't need this functionality, nothing
changes. They can simply ignore the new irqcontrol() pointer, and UIO
behaves as it always did. My patch is completely compatible with
existing UIO drivers, no changes to drivers are required.

Thanks to Jan Altenberg for testing this, and to Magnus Damm for telling
me that I'm not the only one who has these problems ;-)

Thanks,
Hans

