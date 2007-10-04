Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbXJDBoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbXJDBoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 21:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXJDBoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 21:44:12 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:2020 "EHLO myri.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbXJDBoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 21:44:10 -0400
Message-ID: <47044565.5070606@myri.com>
Date: Wed, 03 Oct 2007 21:44:05 -0400
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MSI problem since 2.6.21 for devices not providing a mask in
 their MSI capability
References: <470405BB.2000208@myri.com> <m14ph7amxq.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14ph7amxq.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2007 5:49 PM, Eric W. Biederman wrote:
> Loic Prylli <loic@myri.com> writes:
>
>   
>> Hi,
>>
>> We observe a problem with MSI since kernel 2.6.21 where interrupts would
>> randomly stop working. We have tracked it down to the new
>> msi_set_mask_bit definition in 2.6.21. In the MSI case with a device not
>> providing a "native" MSI mask, it was a no-op before, and now it
>> disables MSI in the MSI-ctl register which according to the PCI spec is
>> interpreted as reverting the device to legacy interrupts. If such a
>> device try to generate a new interrupt during the "masked" window, the
>> device will try a legacy interrupt which is generally
>> ignored/never-acked and cause interrupts to no longer work for the
>> device/driver combination (even after the enable bit is restored).
>>     
>
> We should also be leaving the INTx irqs disabled.  So no irq
> should be generated.
>   



Even if the INTx line is not raised, you cannot rely on the device to
retain memory of a interrupt triggered while MSI are disabled, and
expect it to fire it under MSI form later when MSI are reenabled.  The
PCI spec does not provide any implicit or explicit guarantee about the
MSI enable flag that would allow it to be used for temporary masking
without running the risk of loosing such interrupts. Moreover, even if
you eventually call the interrupt handler to recover a lost-interrupt,
having switched the device to INTx mode (whether or not the INTx line
was forced down or not with the corresponding pci-command bit) without
informing the driver can (and will in our case) break interrupt
handshaking because MSI and INTx interrupts are not acked in the same
way (INTx requires an extra step that we don't do for MSI and that the
device will still expect unless going through driver init again).


> If you have a mask bit implemented you are required to be
> able to refire it after the msi is enabled. 



Indeed the masking case is well-defined by the spec (including the
operation of the pending bits). And my subject was definitely restricted
to devices without that masking capability.



>  I don't recall
> the requirements for when both intx and msi irqs are both
> disabled.  Intuitively I would expect no irq message to
> be generated, and at most the card would need to be polled
> manually to recognize a device event happened.
>
> Certainly firing an irq and having it get completely lost is
> unfortunate, and a major pain if you are trying to use the
> card.
>
> As for the previous no-op behavior that was a bug.
>   




OK no-op was a bug, but using the enable-bit for temporary masking
purposes still feels like a bug. I am afraid the only safe solution
might be to prohibit any operation that absolutely requires masking if
real masking is not available. Maybe the set_affinity method should
simply be disabled for device not supported masking (unless there is an
option of doing it without masking for instance by guaranteeing only one
word of the MSI capability is changed).



>   
>> Is there anything apart from irq migration that strongly requires
>> masking? Is is possible to do the irq migration without masking?
>>     
>
> enable_irq/disable_irq.  Although we can get away with a software
> emulation there and those are only needed if the driver calls them.
>   



I don't think there is a problem here, no sane driver would depend on
receiving edge interrupts triggered while irqs were explicitly disabled.



> The PCI spec requires disabling/masking the msi when reprogramming it.
> So as a general rule we can not do better. 



Do you have a reference for that requirement. The spec only vaguely
associates MSI programming with "configuration", but I haven't found any
explicit indication that it should not work.



>  Further because we are
> writing to multiple pci config registers the only way we can safely
> reprogram the message is with the msi disabled/masked on the card in
> some fashion.
>   


That's indeed a show-stopper.


> I suspect what needs to happen is a spec search to verify that the
> current linux behavior is at least reasonable within the spec.
>   



I don't see how you can disable MSI through the control bit (which is
equivalent to switching the device to INTx whether or not the INTx
disable bit is set in PCI_COMMAND) in the middle of operations, not tell
the driver, and not risk loosing interrupts (unless you rely on much
more than the spec).


> I don't want to break anyones hardware, but at the same time I want us
> to be careful and in spec for the default case.
>
>   


The interrupt while doing set_affinity masking would certainly cause a
problem for the device we use (MSI-enable switch between INTx and MSI
mode, and both interrupts are not acked the same way assuming they would
even be delivered to the driver), but I got some new data: upon further
examination, the lost interrupts we have seen seems in fact caused at a
different time:
- the problem is the  mask_ack_irq() done in handle_edge_irq() when a
new interrupt arrives before the IRQ_PROGRESS bit is cleared at the end
of the function.

Again here, switching MSI-off during hot operation breaks the interrupt
accounting and handshaking between our driver and device. At least this
case might be easier to handle, it seems safe to not mask there (when
some proven masking is not available).


Loic



