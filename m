Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZFRM0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZFRM0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZFRM01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:26:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34804 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZFRM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:26:26 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>
	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>
	<4A37F4AE.5050902@goop.org> <m1vdmvxe3u.fsf@fess.ebiederm.org>
	<4A392896.9090408@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 18 Jun 2009 05:26:16 -0700
In-Reply-To: <4A392896.9090408@goop.org> (Jeremy Fitzhardinge's message of "Wed\, 17 Jun 2009 10\:32\:06 -0700")
Message-ID: <m1hbydohhz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, keir.fraser@eu.citrix.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Actually I was discussing this with Keir yesterday.  We're definitely open to
> changing the dom0 API to make things simpler on the Linux side.  (The dom0 ABI
> is more fluid than the domU one, and these changes would be backwards-compatible
> anyway.)
>
> One of the options we discussed was changing the API to get rid of the exposed
> vector, and just replace it with an operation to directly bind a gsi to a pirq
> (internal Xen physical interrupt handle, if you will), so that Xen ends up doing
> all the I/O APIC programming internally, as well as the local APIC.
>
> On the Linux side, I think it means we can just point pcibios_enable/disable_irq
> to our own xen_pci_irq_enable/disable functions to create the binding between a
> PCI device and an irq.

Then let's make this the plan.  Design a supportable dom0 <-> kernel
irq abi.  Essentially binding a gsi to an event channel mapping
function.  Get that into Xen.  Then get that into the mainstream linux
kernel.

Regardless of the upstream linux kernel merge status cleaning up the
irq handling is going to have to happen to move past 2.6.18.  I cleaned the
irq code up and changed it to work in incompatible ways starting in 2.6.19.

I really REALLY don't want to see support for Xen 3.4 domU irq
handling in the mainline linux kernel.  It is an evolutionary dead
end, and I have already ripped that code out of linux once.  Vectors
should be an implementation detail not an exposed part of the ABI.

Eric
