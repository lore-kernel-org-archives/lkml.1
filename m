Return-Path: <linux-kernel-owner+w=401wt.eu-S1751404AbXC1FzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbXC1FzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 01:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXC1FzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 01:55:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55747 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXC1FzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 01:55:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 10/21] MSI: Add an arch_msi_supported()
References: <20070322105340.C6E43DDF66@ozlabs.org>
Date: Tue, 27 Mar 2007 23:54:43 -0600
In-Reply-To: <20070322105340.C6E43DDF66@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:39 +1100")
Message-ID: <m1fy7psyjg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> Add an arch_msi_supported(), which gives archs a chance to check the input
> to pci_enable_msi/x. For MSI-X this routine might need the entry array, so
> pass it in. For plain MSI, NULL is passed, the arch routine needs to cope
> with that. Propagate the error value returned from the arch routine out to
> the caller.

Ugh.  I'm not very comfortable with passing struct msix_entry into
the architectures right now.

There are a couple of reasons.
- It's irq field is to small (so we need to change it at some point)
- No a single driver that calls pci_enable_msix uses the scatter gather
  feature (so the entry member is redundant).

So this struct msix_entry needs to change and we need to change the drivers
along with it.  Having to change a couple of architectures as well sounds
painful.  So we might as well fix that at the same time as we are
adding the RTAS support so architectures don't have to deal with this
nasty unused concept.

I'm thinking the same thing to do is to completely remove struct msix_entry
and just let drivers walk the linked list you introduce a few patches
later down.  All they need is to get their irq numbers anyway.

I was tempted to drop nvec as well since our irq numbers are virtual,
we could always delay the failure into request_irq.  But there are
a few embedded architectures like the arm where the number irqs
numbers may stay limited for a long time and if the driver will never
use all of the irqs we get to save some resources and some work.  So
that makes sense.

So can we please at least move this patch down to the end with the
rest of the RTAS arch support?

Moving it towards the end will allow it to be reviewed in the context
where it will be used and it will give us a chance to simplify
pci_enable_msix before we get there.

Eric
