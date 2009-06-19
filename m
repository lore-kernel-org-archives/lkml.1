Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZFST6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZFST6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZFST6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:58:14 -0400
Received: from claw.goop.org ([74.207.240.146]:50756 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbZFST6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:58:13 -0400
Message-ID: <4A3BEDD6.6070303@goop.org>
Date: Fri, 19 Jun 2009 12:58:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org>	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>	<4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>	<4A3AC0C4.6060508@goop.org> <m17hz9djwn.fsf@fess.ebiederm.org>
In-Reply-To: <m17hz9djwn.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/09 19:42, Eric W. Biederman wrote:
> Interesting.  Then we need to know what Xen has chosen to do.
> This whole logic of having linux and Xen happen to choose the
> same interrupt handling mode by coincidence that is in use
> right now seems fragile.
>
> Xen runs a timer so I can't see Xen actually leaving the decision
> up to linux.  It certainly doesn't leave the physical versus logical
> mode decision up to linux.
>   

Yes.  And if the chipset does actually rely on programming/configuration
from the DSDT, I guess there could be a problem in principle (I don't
know of any problems in practice).

> Assuming Xen not having the AML interpreter is the right decision.
> I recall from some of the hibernation discussions that ACPI is not an easy
> thing to start/stop on a machine unless it is handled just so.
>
> Which if dom0 is to be redundant/restartable seems to make the
> argument for AML living in Xen.
>   
> Xen has everything except the AML interpreter.
>   

I assume that putting AML into Xen has been considered, but I don't
anything about those deliberations.  Keir? Jun?

>> DomU doesn't know or care about ACPI at all.  There's no reason for it
>> to get any kind of ACPI event.
>>     
>
> Yet at least occasionally Xen fakes up ACPI tables for a guest.
>   

No, it never fakes up an ACPI table.  Privileged domains can see the
real BIOS ACPI tables, but unprivileged PV DomUs can't see anything.

(HVM - fully virtualized - domains get completely faked ACPI, along with
everything else, courtesy of qemu.)

> DomU has to do something to get the mapping, which is what I thought you
> were referring to.
>
> I can believe a Xen dom0 that is the same as domU except with lots
> more hardware.

There isn't really a sharp divide between the two.  At core a dom0 (or
"control domain" as we're beginnging to call it) functions just like a
plain paravirtualized domU domain with some extra privileges.  Among
those privileges is the ability to directly map device memory, perform
pio and bind physical interrupts to event channels.

At the moment a whole pile of disparate things are lumped together into
the initial domain (hence "dom0" - the first domain), which tends to
conflate them in people's minds.  But we're moving towards a model of
disaggregating those functions into separate special-purpose domains,
with a more fine-grained notion of "privileged".

For example, there have been prototypes of "driver domains" floating
around for a while now, where a domain has specific responsibility for a
device or set of devices, and is only allowed to access those particular
hardware resources (this is a lot more convincing with VT-d enabled).

Simiarly, xenstore/xenbus - the system-wide configuration state - can be
in its own domain, as it is one of the few things whose loss can't be
recovered from.

>   I have trouble understanding and Xen dom0 that has to
> all kinds of special one off hardware manipulation because Xen is too
> lazy too. 

Well the reason is the obvious one - Linux has a pile of drivers, and
attempting to duplicate them, or even port them into a completely
different environment - is a huge amount of pointless work.

>  Xen is already 300,000 lines of code so it's not like it is
> fully comprehensible/maintainable by a single person anyway.

Well, more like 200,000 for all the common code and arch/x86 (ia64 adds
another 30k lines or so).  By contrast, in Linux just kernel/ and
arch/x86/ is about 360,000 lines, and that doesn't include any drivers; 
drivers/ contains a further 5.8 million lines of code (~2 million in
scsi, net and block).

I don't see why it needs to be maintainable by a single person, though
there are probably only ~10 people who'd be classed as core developers. 
But while Xen and core Linux are about the same order of magnitude,
there's no way trying to import Linux drivers into Xen is even remotely
sustainable.

    J
