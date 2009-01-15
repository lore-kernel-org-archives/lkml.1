Return-Path: <linux-kernel-owner+w=401wt.eu-S1762904AbZAOKQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762904AbZAOKQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:16:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbZAOKQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:16:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:54698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbZAOKQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:16:37 -0500
Message-ID: <496F0D02.1090402@suse.de>
Date: Thu, 15 Jan 2009 11:16:34 +0100
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jon Masters <jcm@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
 interrupt equivalent
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>	<496B24E5.1070804@suse.de> <200901121151.53195.bjorn.helgaas@hp.com>	<m1d4esxfk2.fsf@frodo.ebiederm.org>	<1231806563.4094.25.camel@perihelion.bos.jonmasters.org>	<20090113014723.GA11366@elte.hu> <m1prirx3xn.fsf@frodo.ebiederm.org>	<1231820798.4094.34.camel@perihelion.bos.jonmasters.org>	<20090114114006.GF8625@elte.hu>	<1231960709.23174.0.camel@londonpacket.bos.redhat.com> <m11vv5wlug.fsf@frodo.ebiederm.org>
In-Reply-To: <m11vv5wlug.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jon Masters <jcm@redhat.com> writes:
> 
>> On Wed, 2009-01-14 at 12:40 +0100, Ingo Molnar wrote:
>>
>>> it's not just -rt, but it is also needed for the concept of threaded IRQ 
>>> handlers - which was discussed at the Kernel Summit to be desired for 
>>> mainline.
>> Right. I'm poking at Thomas' patches and hope to post something soon on
>> that front - I'm acutely aware that this will be impacted aswell but
>> because it's vaguely RT related had banded it under that banner.
> 
> Stepping back a moment.  The only way I can see this working reliably
> is if we disable the boot interrupt.  Anything that leaves the boot interrupt
> enabled means that when we disable the primary interrupt the boot interrupt
> will scream, and thus we must disable it as well.

Disabling Boot Interrupts is our goal, if they don't appear everything
is fine. Now if you take a closer look at United States Patent 6466998
you can read that there has to be a way to disable Boot Interrupts on
APIC aware OSes.

Let me back this up with a quote from that patent:
"Therefore, 8259 PIC may be incorporated into a system board along with
the APIC system to ensure proper operation of an operating system (OS)
regardless whether such an operating system (OS) may or may not support
an APIC system. However, external logic devices are required to route
particular interrupts from a non-legacy peripheral bus to the 8259 PIC.
General purpose I/O pins are then needed to enable/disable this
functionality once an operating system (OS) which understands the APIC
system is loaded."

We already managed to successfully disable Boot Interrupt generation on
several chipsets. See the following posts:

http://lkml.org/lkml/2008/7/8/213
http://lkml.org/lkml/2008/7/8/215
http://lkml.org/lkml/2008/6/2/270

What makes things complicated is that we have to deal with buggy
hardware which can't disable the generation of Boot Interrupts, that's
why we introduced the reroute to legacy interrupt patch.

> Which leads to my problem with the entire development process of this feature.
> 
>  People want the feature.
>  People don't want to pay attention to the limits of the hardware.
>  Which leads to countless broken patches proposed.

Sorry if you feel that way, really trying to pay attention to
hardware limitations here. I bet you have a lot more experience in this
field than I have, so please let me know what technical reasons you
see for this being a dead end.

> Which leads me to conclude.
> - IRQ handling in the RT kernel is hopelessly broken.
> - IRQ threads are a bad idea.
> 
> Because it is all leading to stupid patches and stupid development.
> 
> None of this works reliably on level triggered ioapic irqs.

We're trying really hard to make it work reliably, but this is a
complicated matter and it sure needs a lot of research.

> 
> Eric

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail: sassmann@suse.de  | GF: Markus Rex, HRB 16746 (AG Nuernberg)
