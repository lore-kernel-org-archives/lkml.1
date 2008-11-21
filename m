Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYKUBGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYKUBGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbYKUBF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:05:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38041 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYKUBFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:05:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
References: <patchbomb.1226603398@abulafia.goop.org>
	<d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
	<20081120093506.GB6885@elte.hu> <492597B9.8070506@goop.org>
	<m1y6ze87w6.fsf@frodo.ebiederm.org> <4925D762.6040406@goop.org>
Date: Thu, 20 Nov 2008 16:58:38 -0800
In-Reply-To: <4925D762.6040406@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 20 Nov 2008 13:32:18 -0800")
Message-ID: <m1prkpj3nl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1808]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:


> The changes are spread over a number of patches, but the meat of it is in "xen:
> route hardware irqs via Xen".  It turns out fairly simply, but perhaps its
> because I've made a number of simplifying assumptions: interrupts are always
> IOAPIC based, only using ACPI for routing, no MSI support yet.
>
> But it seems to me that the only time you really care that the irq isn't a gsi
> is when programming a vector into the ioapics - you need to do a irq ->
> ioapic/pin mapping anyway, so adding a irq -> gsi -> ioapic/pin map isn't all
> that complex.

It is hideous.  Been there and ripped out hundreds of lines of useless and problem
causing code to get here.  It is especially bad when you do not identity map the first
16 gsi to linux irqs (the legacy isa irqs).

It is very useful to keep the linux irq number and the gsi irq number the same.
It facilitates debugging and keeps the code simple.

> And conversely, when probing devices you need to map gsi->irq to
> see whether the interrupt is shared, though you could do that on a pure gsi
> level anyway.

What I care about is important is that the GSI number == the linux irq number.

> And of course the current code isn't purely irq == gsi anyway, since msis are
> allocated irqs as well, and there's no underlying gsi.

Yep.  And but the numbers we you should be beyond the range of the gsi's so there
is no conflict.  Think of it an extension of how we identitly make the low 16 linux
irqs.

>  In a sense you can think
> of the other Xen interrupt sources as being a bit like MSI, at least in as much
> as they're not sourced from a GSI (but they go further and are not sourced from
> an IOAPIC at all).

MSI isn't sourced from an IOAPIC either.

The difference is that the xen sources are not delivered using vectors.  The cpu
vector numbers we do hide and treat as an implementation detail.  And I am totally
happy not going through the vector allocation path.

My gut feel says that you just want to use a different set of irq operations when
doing Xen native and working with hardware interrupts.    I haven't seen the code so
I don't know how you interact there.  Except in dom0 this is not a consideration so
I don't how it is handled.

Eric




