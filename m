Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbYALH1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbYALH1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 02:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761086AbYALH1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 02:27:23 -0500
Received: from colo.lackof.org ([198.49.126.79]:54147 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761031AbYALH1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 02:27:23 -0500
Date: Sat, 12 Jan 2008 00:27:05 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI Failed to allocate mem for PCI ROM
Message-ID: <20080112072705.GB7234@colo.lackof.org>
References: <1B75C5A8-E512-40CB-A6F3-351640701D0D@kernel.crashing.org> <20080111175039.GB7916@kroah.com> <E1025115-6BE2-46B6-8416-A5ADD506E2ED@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1025115-6BE2-46B6-8416-A5ADD506E2ED@kernel.crashing.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 02:27:16PM -0600, Kumar Gala wrote:
>>> I'm getting the following message from the kernel on an embedded ppc32
>>> system:
>>>
>>> PCI: Failed to allocate mem resource #9:100000@e0000000 for 0000:00:00.0
>>>
>>> The HW setup is a PCIe host controller and an e1000 NIC card.
...
> I'm happy to debug, is the fact that the resno == 9 ok or does that seem 
> wrong?

That is fine for the Bridge. See include/linux/pci.h :
#define PCI_ROM_RESOURCE        6
#define PCI_BRIDGE_RESOURCES    7
#define PCI_NUM_RESOURCES       11

IIRC, Bridges may have two 32-bit or one 64-bit BAR, Expansion ROM BAR and
three "range" registers: IO Port, MMIO (Prefetchable and non-prefetchable).
The BRIDGE_RESOURCES (7-10) are what failed to be assigned for some reason.

Looking at setup-bus.c:pci_bridge_check_ranges(), I'm concluding that:
[7] is IO Range.
[8] is MMIO
[9] is Prefetchable MMIO
[10] no clue...maybe used by host PCI bus controllers.

0x100000 is 1MB and would be the minimum MMIO range that can be allocated.
So that looks right too. Probably need to find out what is allocating
0xe0000000 instead.

hth,
grant
