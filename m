Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbXJDD7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbXJDD7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 23:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXJDD7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 23:59:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52679 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbXJDD7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 23:59:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Loic Prylli <loic@myri.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MSI problem since 2.6.21 for devices not providing a mask in their MSI capability
References: <470405BB.2000208@myri.com>
	<m14ph7amxq.fsf@ebiederm.dsl.xmission.com> <47044565.5070606@myri.com>
Date: Wed, 03 Oct 2007 21:58:29 -0600
In-Reply-To: <47044565.5070606@myri.com> (Loic Prylli's message of "Wed, 03
	Oct 2007 21:44:05 -0400")
Message-ID: <m1myuzy1i2.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli <loic@myri.com> writes:

> Even if the INTx line is not raised, you cannot rely on the device to
> retain memory of a interrupt triggered while MSI are disabled, and
> expect it to fire it under MSI form later when MSI are reenabled. 

Sure.  My expectation is if we happened to hit such a narrow window
the irq would simply be dropped.

>
>> If you have a mask bit implemented you are required to be
>> able to refire it after the msi is enabled. 
>
>
>
> Indeed the masking case is well-defined by the spec (including the
> operation of the pending bits). And my subject was definitely restricted
> to devices without that masking capability.

Right.  And INTx has such a pending bit as well.  I guess I figured
if MSI was enabled transferring it over would be the obvious thing to
do.

> OK no-op was a bug, but using the enable-bit for temporary masking
> purposes still feels like a bug. I am afraid the only safe solution
> might be to prohibit any operation that absolutely requires masking if
> real masking is not available. Maybe the set_affinity method should
> simply be disabled for device not supported masking (unless there is an
> option of doing it without masking for instance by guaranteeing only one
> word of the MSI capability is changed).

It's worth looking at, I think that happens in the common case.

Of course it might even make sense simply to refuse to enable MSI
if there is not a masking capability present.

>> The PCI spec requires disabling/masking the msi when reprogramming it.
>> So as a general rule we can not do better. 
>
>
>
> Do you have a reference for that requirement. The spec only vaguely
> associates MSI programming with "configuration", but I haven't found any
> explicit indication that it should not work.

I would have to look it up again but it said that the result is only
defined in the case when it is disabled/masked, when I looked a couple
of months ago.

>> I suspect what needs to happen is a spec search to verify that the
>> current linux behavior is at least reasonable within the spec.
>>   
>
>
> I don't see how you can disable MSI through the control bit (which is
> equivalent to switching the device to INTx whether or not the INTx
> disable bit is set in PCI_COMMAND) in the middle of operations, not tell
> the driver, and not risk loosing interrupts (unless you rely on much
> more than the spec).

I will relook.  My impression is that bit is defined as MSI enable.
Not mode switch.   Although myrinet has clearly implemented it as
mode switch.

>> I don't want to break anyones hardware, but at the same time I want us
>> to be careful and in spec for the default case.
>>
>>   
>
>
> The interrupt while doing set_affinity masking would certainly cause a
> problem for the device we use (MSI-enable switch between INTx and MSI
> mode, and both interrupts are not acked the same way assuming they would
> even be delivered to the driver), but I got some new data: upon further
> examination, the lost interrupts we have seen seems in fact caused at a
> different time:
> - the problem is the  mask_ack_irq() done in handle_edge_irq() when a
> new interrupt arrives before the IRQ_PROGRESS bit is cleared at the end
> of the function.
>
> Again here, switching MSI-off during hot operation breaks the interrupt
> accounting and handshaking between our driver and device. At least this
> case might be easier to handle, it seems safe to not mask there (when
> some proven masking is not available).

Interesting.  So an irq fires before the driver has finished
processing the last instance of the irq.  This is very close to a
screaming irq and something we may actually want to deal with.

Eric
