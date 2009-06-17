Return-Path: <linux-kernel-owner+w=401wt.eu-S933418AbZFQMCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418AbZFQMCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933175AbZFQMCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:02:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58108 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZFQMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:02:33 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>
	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>
	<4A37F4AE.5050902@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Jun 2009 05:02:29 -0700
In-Reply-To: <4A37F4AE.5050902@goop.org> (Jeremy Fitzhardinge's message of "Tue\, 16 Jun 2009 12\:38\:22 -0700")
Message-ID: <m1vdmvxe3u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> I think we're getting off into the weeds a bit here.  I'm looking at other
> options of how to fit Xen interrupt handling into the kernel in a clean way; we
> may end up with a different model from the previous patch postings (not this
> particular one under discussion; the ones from last month).  We can reopen this
> discussion when I post those patches.
>
> However, the kernel will still need information about the I/O APICs from ACPI so
> that it can perform basic interrupt routing for PCI devices (ie, regardless of
> how the interrupt gets delivered, and who programs the APIC hardware, we still
> need the basic information of "what io apic+pin is this PCI device connected
> to?").  This particular patch is my attempt to achieve this.

Trying to understand what is going on I just read through Xen 3.4 and the
accompanying 2.6.18 kernel source.

Xen has a horrible api with respect to io_apics.  They aren't even real
io_apics when Xen is done ``abstracting'' them.

Xen gives us the vector to write.  But we get to assign that
vector arbitrarily to an ioapic and vector.

We are required to use a hypercall when performing the write.
Xen overrides the delivery_mode and destination, and occasionally
the mask bit.

We still have to handle polarity and the trigger mode.  Despite
the fact that Xen has acpi and mp tables parsers of it's own.

I expect it would have been easier and simpler all around if there
was just a map_gsi event channel hypercall.  But Xen has an abi
and an existing set of calls so could aren't worth worrying about
much.

Xen's ioapic affinity management logic looks like it only works
on sunny days if you don't stress it too hard.  Of course the hard
part Xen of driving the hardware Xen doesn't want to share.

It looks like the only thing Xen gains by pushing out the work of
setting the polarity and setting edge/level triggering is our database
of motherboards which get those things wrong.

So I expect the thing to do is factor out acpi_parse_ioapic,
mp_register_ioapic so we can share information on borked BIOS's
between the Xen dom0 port and otherwise push Xen pseudo apic handling
off into it's strange little corner.

Eric
