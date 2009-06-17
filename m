Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbZFQFLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbZFQFLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 01:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbZFQFKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 01:10:53 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39863 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbZFQFKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 01:10:52 -0400
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
Date: Tue, 16 Jun 2009 22:10:45 -0700
In-Reply-To: <4A37F4AE.5050902@goop.org> (Jeremy Fitzhardinge's message of "Tue\, 16 Jun 2009 12\:38\:22 -0700")
Message-ID: <m1eitjv416.fsf@fess.ebiederm.org>
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

> The only effect of this patch is to parse the I/O APIC parts of the MADT even if
> it skips the local APIC parts; it causes no change in behaviour in normal
> circumstances (unless you actually have a physical machine with ACPI and I/O
> APICs but CPUs with no local APICs, which is guess is possible in principle).

You allow getting to places like apic->setup_apic_routing without going
through prerequisites like generic_bigsmp_probe().

> Can you give an example of how mechanism and policy are mixed?  In what ways
> could it break?  Would you agree to a patch which attempts to decouple policy
> and mechanism to solve these problems?

I would agree with a patch that decouples the parts you need.  Something
that makes it possible to call apci_parse_madt_lapic_entries without
calling the rest of the code sounds reasonable.

Given that ia64 already has a separate path calling into acpi I'm not
certain there is much truly useful code that can be shared.  Getting
the BIOS bug workarounds seems reasonable.

It would be good to see at least a rough draft of where you are going.  So
the whole picture can be clear.

Right now.  I don't think there is anything in anything in
arch/x86/kernel/apic/* arch/x86/kernel/smpboot.c that is usable for xen.

As for mixing mechanism and policy besides the cpu_has_apic tests we
have generic_bigsmp_probe, the calling of apic_setup_apic_routing.
The code that depends on the CONFIG_X86_LOCAL_APIC define.

There are also deep assumptions in the code like default_setup_apic_routing.
That tests the number of local apics and uses that to decide on how to setup
the ioapics.

Eric
