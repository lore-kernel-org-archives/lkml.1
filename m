Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXJDJOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXJDJOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbXJDJOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:14:31 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:2012 "EHLO myri.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755100AbXJDJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:14:30 -0400
Message-ID: <4704AEF1.3000206@myri.com>
Date: Thu, 04 Oct 2007 05:14:25 -0400
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MSI problem since 2.6.21 for devices not providing a mask in
 their MSI capability
References: <470405BB.2000208@myri.com>	<m14ph7amxq.fsf@ebiederm.dsl.xmission.com> <47044565.5070606@myri.com> <m1myuzy1i2.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1myuzy1i2.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/2007 11:58 PM, Eric W. Biederman wrote:
> Right.  And INTx has such a pending bit as well.  I guess I figured
> if MSI was enabled transferring it over would be the obvious thing to
> do.
>   



The INTx pending and disable bit were only added starting with PCI 2.3,
so in  PCI-2.2 and PCI-X 1.0{,a,b} those bits don't exist at all and
there is still a significant of such devices still in use or on the market.

I agree it would look natural (and that probably happens for a lot of or
most devices) to transfer the interrupt state from INTx to MSI, but I
don't think you can rely on it without doing some assumptions about
device interrupt management that are outside the scope of the spec.



> Of course it might even make sense simply to refuse to enable MSI
> if there is not a masking capability present.
>   



The possibility of masking for MSI was only specified (and then only as
something optional) starting with PCI-3.0, PCI Express 1.0 and 1.0a are
based on the older PCI-2.3 and corresponding devices are very unlikely
to have it. So there might still be majority of devices in the field
with no MSI masking capability in the different PCI categories:
conventional-PCI, PCI-X, PCI-Express.


>
>>>  The PCI spec requires disabling/masking the msi when reprogramming it.
>>>  So as a general rule we can not do better. 
>>>
>>>       
>> Do you have a reference for that requirement. The spec only vaguely
>> associates MSI programming with "configuration", but I haven't found any
>> explicit indication that it should not work.
>>     
> I would have to look it up again but it said that the result is only
> defined in the case when it is disabled/masked, when I looked a couple
> of months ago.
>   
>


I found this quote in PCI-3.0/6.8.3.5:
"For MSI-X, a function is permitted to cache Address and Data values
from unmasked
MSI-X Table entries. However, anytime software unmasks a currently
masked MSI-X
Table entry either by clearing its Mask bit or by clearing the Function
Mask bit, the
function must update any Address or Data values that it cached from that
entry. If
software changes the Address or Data value of an entry while the entry
is unmasked, the
result is undefined."


I haven't seen a caching possibility mentioned for the MSI case, so
apart from the problem with multi-word changes, maybe changing the
Address or Data can be done at anytime for MSI.




>> I don't see how you can disable MSI through the control bit (which is
>> equivalent to switching the device to INTx whether or not the INTx
>> disable bit is set in PCI_COMMAND) in the middle of operations, not tell
>> the driver, and not risk loosing interrupts (unless you rely on much
>> more than the spec).
>>     
>
> I will relook.  My impression is that bit is defined as MSI enable.
> Not mode switch.   Although myrinet has clearly implemented it as
> mode switch.
>   



It is indeed defined as MSI-enable, but that's not a contradiction with 
being equivalent to a "mode switch between INTx and MSI" (ignoring MSI-X
in that context). The spec seems to define the following "modes":

MSI-enable = 1, INTx-disable= x : MSI-mode
MSI-enable = 0, INTx-disable= 0 : INTx-mode with INTx-signal == INTx-pending
MSI-enable = 0, INTx-disable= 1 : INTx-mode "polling/diag" mode using
INTx pending bit

The only specificity of Myrinet is having relatively independant logic
for the two modes, while at the same time requiring any pending INTx to
be acked before starting any kind of new interrupt.


> Interesting.  So an irq fires before the driver has finished
> processing the last instance of the irq.  This is very close to a
> screaming irq and something we may actually want to deal with.
>
>   



In our case it is true that the device can fire a bounded number of MSI
without acks (but not an infinite number, there are a limited number of
interrupt tokens, furthermore interrupt rate is limited with  a
configurable minimum time between interrupts which default to ~10us), I
suspect a race with other interrupts were involved because otherwise
that minimum inter-interrupt delay would prevent entering that code path.

I think even a more casual interrupt-scheme (with an explicit ack
required for each interrupt before generating a new one) can also
exercise that code path, since between the return from the handler and
the clearing of IRQ_PROGRESS, there is an opportunity for the next
interrupt to happen.

To detect a crazy device generating storms of edge interrupts, I guess
note_interrupt() could be called during this "reentrant detection" if
masking was made conditional.


Loic


P.S.: just a little more context: in all Myrinet hardware, enough of the
interrupt functionality is implemented in firmware that we can avoid
loosing interrupts whenever MSI-enable is toggled, and we already
started distributing a firmware-based software update for users running
linux >= 2.6.21 and using MSI. So for Myrinet the problem is more or
less already closed.

The only motivation for starting the thread was that it seemed a
possibility that other non-Myrinet devices could be affected by that "
use MSI-enable as a masking function":
-  the first problem being a possible spurious INTx interrupt (and for
most PCI-X 133Mhz or earlier there might not be a INTx disable bit to
avoid that) during the "MSI-disabled" window.
- it does not seem far-fetched that other devices could also loose an
interrupt during that toggling, at best this seems a grey area of the spec.
-  the race to trigger any of those potential problems is small, they
would be hard to reproduce.

