Return-Path: <linux-kernel-owner+w=401wt.eu-S965419AbXC0VPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419AbXC0VPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965427AbXC0VPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:15:11 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56585 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419AbXC0VPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:15:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
References: <08FE5CC30C9A3F41BF819A502CF7BF6EF98178@fmsmsx411.amr.corp.intel.com>
Date: Tue, 27 Mar 2007 15:13:59 -0600
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6EF98178@fmsmsx411.amr.corp.intel.com>
	(Mitch A. Williams's message of "Tue, 27 Mar 2007 10:15:22 -0700")
Message-ID: <m1ps6uwfs8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Williams, Mitch A" <mitch.a.williams@intel.com> writes:

> Eric W. Biederman wrote: 
>>
>>> Because enabling and disabling the MSI interrupt is done through
>>> config space, and config space writes are not posted.  So we won't
>>> see the problem that we do with MSI-X.
>>
>>Normally this is true.  However when we have  memory mapped pci config
>>space the writes could very easily be posted.  Even if there aren't
>>any Intel platforms that do it today other architectures might.
>
>>From what I read in the spec, configuration writes are not ever posted.
> They are a completely separate transaction type from memory writes, and
> only memory writes are posted.  So there's no need to read-flush these.

You may have a point there.  It isn't important at this point, and
it is easy enough to fix at this point.

>>The more I think about this the more I think we should make mask and
>>unmask do the read and set enable/disable to mask/unmask in the msi
>>case.
>>
>>I think being a little more paranoid will result in slightly simpler
>>more maintainable code, and not measurably affect performance.  I
>>don't expect you are migrating irqs in a fast path.
>
> Migrating IRQs happens in the fast path, but infrequently (every 10 
> seconds or so).  

Migrating IRQS gets called from the irq handler.  So I guess in that
sense it qualifies as a fast path operation.   The actual irq migration
itself is time consuming even if the individual operations aren't.  In
large part because ioapics don't appear to obey pci ordering rules so
flushing pending irqs is black magic :(

The comparative low frequency is important.

I guess what I meant is as soon as the test to for IRQ_MOVE_PENDING
is true we need to migrate an irq so we branch off of the fast path,
and irq handling path, where we do what we have to make things
work and the cost is what it takes to be reliable.

> However the mask function is called at EVERY interrupt,
> so this change would be VERY expensive.

If true I think that would be bad.  However I don't see it.
Where in handle_edge_irq do we mask the interrupt?
The only place I see us calling ->mask is from move_native_irq
and that only if IRQ_MOVE_PENDING is true.

All I can see is us routinely calling is ack_APIC_edge.

> If the driver really needs to disable the interrupt, then it can call
> irq_disable().

Agreed.  However the driver should not have any access to the mask method
in any shape or form.  That is an internal irq implementation helper.

>  Otherwise, mask (as-is) should be fine -- it masks
> the interrupt at the APIC, and the device's interrupt moderation
> should take care of keeping it from generating interrupts right away.

Please point at code because you are reading the code quite differently
from myself, and I think I have been over that code enough times to see
how it operates.

Eric
