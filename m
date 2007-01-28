Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbXA1Tm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbXA1Tm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbXA1Tm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:42:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42322 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772AbXA1TmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:42:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>,
       Kyle McMartin <kyle@parisc-linux.org>, <linuxppc-dev@ozlabs.org>,
       Brice Goglin <brice@myri.com>, <shaohua.li@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/6] MSI portability cleanups
References: <1169714047.65693.647693675533.qpush@cradle>
Date: Sun, 28 Jan 2007 12:40:53 -0700
In-Reply-To: <1169714047.65693.647693675533.qpush@cradle> (Michael Ellerman's
	message of "Thu, 25 Jan 2007 19:34:07 +1100")
Message-ID: <m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is against gregkh-pci but except for the context around
msi_lookup_irq being completely different it applies cleanly to 2.6.20-rc6
as well.

When I first looked at this problem I thought no big deal it will one
or two simple patches and that is it.

When I looked more closely I discovered that to be certain of not introducing
bugs I would have to kill msi_lock, which made the problem a little more
difficult.

The result of this patchset is that architecture hooks become:

int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc);
void arch_teardown_msi_irq(unsigned int irq);

and are responsible for allocating and freeing the irq as well
as setting it up.

This touches the architecture code for i386, x86_64, and ia64 to
accomplish this.

Since I couldn't test ia64 I reviewed the code closely, and compile
tested it.

The other big change is that I added a field to irq_desc to point
at the msi_desc.  This removes the conflicts with the existing pointer
fields and makes the irq -> msi_desc mapping useable outside of msi.c

The only architecture problem that isn't solvable in this context is
the problem of supporting the crazy hypervisor on the ppc RTAS, which
asks us to drive the hardware but does not give us access to the
hardware registers.

Eric
