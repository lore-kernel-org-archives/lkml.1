Return-Path: <linux-kernel-owner+w=401wt.eu-S1765163AbZAOOJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765163AbZAOOJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZAOOIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:08:52 -0500
Received: from ns.suse.de ([195.135.220.2]:50405 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333AbZAOOIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:08:51 -0500
Message-ID: <496F4370.4010406@suse.de>
Date: Thu, 15 Jan 2009 15:08:48 +0100
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Olaf Dabrunz <od@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jon Masters <jcm@redhat.com>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
 interrupt equivalent
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496C788C.9050305@suse.de> <20090113155717.GM25512@suse.de> <200901141710.33859.bjorn.helgaas@hp.com>
In-Reply-To: <200901141710.33859.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tuesday 13 January 2009 08:57:17 am Olaf Dabrunz wrote:
>> On 13-Jan-09, Stefan Assmann wrote:
>>> Bjorn Helgaas wrote:
>>>> (I added Eric, Maciej, and Jon because they participated in
>>>> previous discussion here: http://lkml.org/lkml/2008/6/2/269)
>>>>
>>>> On Monday 12 January 2009 04:09:25 am Stefan Assmann wrote:
>>>>> Len Brown wrote:
>>>>>> Stefan,
>>>>>> I had to exclude your changes to drivers/acpi/pci_irq.c from
>>>>>> e1d3a90846b40ad3160bf4b648d36c6badad39ac
>>>>>> in order to get some other changes to that file upstream in the
>>>>>> 2.6.29 merge window. ...
>>>>> Let me try to give you a short overview of what's happening there.
>>>>>
>>>>> If an IRQ arrives at line X of a non-primary IO-APIC and that line is
>>>>> masked a new IRQ will be generated on the primary IO-APIC/PIC. This is
>>>>> called a "Boot Interrupt" by Intel. It's purpose is, as the name
>>>>> suggests, to ensure that the IRQ is handled at boot time (when the
>>>>> non-primary) IO-APIC is still disabled.
>>>>>
>>>>> Condition to be met for "Boot Interrupts":
>>>>> - line X on non-primary IO-APIC interrupt line is masked
>>>>> - line X is asserted
>>>> Thanks.  Let me replay this to see whether I understand.  Please
>>>> correct any of my misapprehensions :-)
>>>>
>>>> Since your patch doesn't look at the IOxAPIC RDL register to see
>>>> whether the pin is masked, you must be assuming that Linux is
>>>> *always* using boot interrupts, and never unmasking the non-primary
>>>> IOxAPIC entry.
>>> Yes, for this special case that is correct.
>> Right. The current reroute code assumes that all interrupts use masking.
> 
> I'm not an expert in the "classic x86 ioapic behaviour" or in RT
> interrupt handling.  My main objections are that the patch as proposed
> is a gross hack in the ACPI _PRT lookup path, and that it didn't touch
> the non-ACPI lookup path, which should have the same problem.  Now that

I guess by non-ACPI path you refer to the MP_TABLE. So in case you boot
with "acpi=off" the system falls back to the MP_TABLE information and
this is not covered yet.

> Eric pointed out this is just classic behavior, I also wonder why the
> quirk doesn't list more devices.

The reason why the list of quirks isn't larger is that there's no
documentation available in public for some of the chipsets. For example
for Nvidia and VIA chipsets. Note that there is only a problem if more
than one IO-APIC exists in the system. Additional IO-APICs usually
appear on PCI bridges. We have not encountered any systems yet that are
Nvidia or VIA based with more than one IO-APIC. But your mileage may
vary.

> The effect of the patch sounds sort of similar to using "noapic" --
> you're basically ignoring the IOAPIC and using only the "boot interrupt"
> or legacy PIC interrupt or whatever it is.  Can you contrast it with
> that?

The main difference here is that "noapic" disables any IO-APIC in the
system, whereas the patch leaves them intact. We won't be falling back
to the PIC instead we fall back to the first IO-APIC.

What difference does this make? We won't lose all the enhancements of
the IO-APIC over the PIC. What comes to mind first is that, when using
the PIC all non-MSI interrupts have to be dealt with by CPU0. You have
no IRQ balancing, pinning and such things.

> 
> Bjorn
> 
> 

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail: sassmann@suse.de  | GF: Markus Rex, HRB 16746 (AG Nuernberg)
