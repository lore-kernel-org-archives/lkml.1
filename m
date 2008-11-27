Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbYK0BwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbYK0BwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYK0BwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:52:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53342 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbYK0BwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:52:07 -0500
Date: Wed, 26 Nov 2008 17:52:05 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Alex Chiang <achiang@hp.com>, Trent Piepho <xyzzy@speakeasy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the
	device
Message-ID: <20081127015205.GG6539@plum>
Reply-To: djwong@us.ibm.com
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net> <20081126225535.GA27936@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126225535.GA27936@ldl.fc.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 03:55:35PM -0700, Alex Chiang wrote:
> > Maybe it's different on powerpc then?  My pseudo-hotplugable device is also
> > the only thing connected to the PCI-E host bus controller.  At boot the
> > controller is empty and so I think some code to enable its BARs gets
> > skipped.  But without the pci_enable_device(), I get this:
> > 
> > 01:00.0 Signal processing controller: Freescale Semiconductor Inc Aurora Nexus Trace Interface
> >         Flags: fast devsel, IRQ 255
> >         Memory at 40000000 (64-bit, prefetchable) [disabled] [size=4K]
                           Are you referring to this? ^^^^^^^^^^

Without seeing the raw dump of the PCI config space, it looks to me like
the memory space enable bit of the PCICMD register is unset.  Probably
the device driver should call pci_enable_device() at init time, though I
suppose you did say earlier that there is no driver.

> There is no way for fakephp to hot-add devices. The only use case
> is to hot-remove devices.

Actually, you can "hot-add" devices that were previously removed.  Just
rescan the removed device's bridge by running this command: echo 1 >
/sys/bus/pci/slots/fakeX/power.  Onlining the bridge (even if it's
already online) causes the PCI code to rescan the bridge for devices,
and that which you've removed comes back.

> Maybe you're talking about something else. Some more context for
> what you're trying to do, please?

Here is my bizarro case.  The MCH has a bit that controls whether or not
the ioat controller pays attention to accesses to PCI configuration
data.  If the bit is set, the ioat device shows up as 0:8.0.  If the bit
is unset, it looks like there's no device there.  So I set this bit and
use the fakephp driver to rescan the root PCI bridge; after doing that,
the ioat controller pops up.  Quite possibly this (ab)use of the fakephp
driver could be used to turn on other things from Linux that would
otherwise be disabled, but your machine might blow up too.

--D
