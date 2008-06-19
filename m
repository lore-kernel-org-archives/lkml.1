Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYFSG0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYFSG0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbYFSG0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:26:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:18445 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbYFSG0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NaA2WXy61s0dUGAdp0IJ//MKB22J1hLBlz4xLrK0HZq42j9aoH41NTtrDFyK36QMbt
         a3RHagFFZt1dE9XCTyrqX4HmB8XWAdmXvGB/GDqTh7xoV7TM+TOoa5f/7G59gH/s7tPG
         q+zeWevEg9/lQ10ZefFE18N1LLbCa45epudY8=
Message-ID: <86802c440806182326m8c3ad56j29242895507e074d@mail.gmail.com>
Date: Wed, 18 Jun 2008 23:26:11 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0806190113290.3613@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805041823.57198.yhlu.kernel@gmail.com>
	 <200805191252.36814.yhlu.kernel@gmail.com>
	 <200805251600.26325.yhlu.kernel@gmail.com>
	 <200806011317.38622.yhlu.kernel@gmail.com>
	 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
	 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
	 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
	 <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
	 <alpine.LFD.1.10.0806190113290.3613@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 10:20 PM, Len Brown <lenb@kernel.org> wrote:
>
>
>> >> >> make mptable to be consistent to acpi routing, so we could
>> >> >> 1. kexec kernel with acpi=off
>> >> >> 2. workaround BIOS that acpi routing is working, but mptable is not right.
>> >> >>    so can use kernel/kexec to start other os that doesn't have good acpi support
>> >> >
>> >> > Is this an effort to boot an ACPI-mode kernel,
>> >> > and then kexec a non-ACPI kernel?
>> >>
>> >> Yes,
>> >
>> > Why is this feature needed?
>> > There are a number of ways that the resulting kernel may fail,
>> > all platform specific.
>>
>> other os still doesn't have update acpi irq routing support. but has
>> broken mptable.
>
> I don't see how this can work.
>
> What if the the platform doesn't suport MPS -- the
> 2nd OS will try to run in PIC mode and will see
> only the legacy interrupts?

if the system doesn't support mps, this patch will bail out, because
it can not find mptable

>
> What if it does support MPS but ACPI has configured
> its PCI Interrupt Link Devices to direct interrupts
> to different IRQs that are described by MPS?

it will use irq from mptable that is updated according to acpi

when acpi irq set routing, and it will set some bits in pci config in
southbridge, and the irq routing is consistent between HW and irq
returned by acpi.
when first kernel is shutdown, it doesn't restore the bits about irq
routing in pci config. So if keep updated mptable has correct pin,
then device on second
kernel will work.

>
>> >> > Doing so could confuse the heck out of the platform firmware,
>> >> > which will think that an ACPI-mode kernel is still running.
>
> There is state in the chip-set that the ACPI OS has set
> that makes no sense in an non-ACPI context and can lead
> to bizzare behaviour.  The Links above is just one example.
>
> the ACPI SCI interrupt is configured in ACPI mode only.
> What happens when the non-ACPI OS boots and GPE's
> fire and result in SCI's?  They'll not get serviced
> and will kill that IRQ and anything else on it.

the patch doesn't change entries in mptable that pin < 16 and irq is
not for pci device...

and normal sci/acpi is using 9..., and even mptable even doesn't has that entry.
and there is no pci device share that irq with sci/acpi..., so it will
be put into updated mptable.
so next kernel will mask that.

>
> Can somebody clue me into why this concept
> is something other than totally insane?

for system that have 6 pcie slots and more, with full populated cards.
when boot with mptable, BIOS will use irq < 16 for all pci devices,
and several devices will share same irq.
but when acpi is enabled, irqs are spanned all over.

also when pci card with several pci bridges is plugged in, the mptable
is totally messed up, some slot will work, and some doesn't work.

YH
