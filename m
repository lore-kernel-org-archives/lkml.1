Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYJGE63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYJGE63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 00:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYJGE6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 00:58:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYJGE6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 00:58:20 -0400
Date: Tue, 7 Oct 2008 06:57:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86: SB450: skip IRQ0 override if it is not routed to
	INT2 of IOAPIC
Message-ID: <20081007045757.GB6355@elte.hu>
References: <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006221122.GC22097@alberich.amd.com> <20081007034132.GA3025@elte.hu> <20081007035126.GA2929@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007035126.GA2929@amd.corenet.prv>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Tue, Oct 07, 2008 at 05:41:32AM +0200, Ingo Molnar wrote:
> > 
> > * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > 
> > > So, let's work around BIOS bugs in Linux then ...
> > > 
> > > Following patch is almost untested -- especially I didn't get my hands 
> > > on one of the HP Laptops with broken DSDT.
> > [...]
> > > On some HP nx6... laptops (e.g. nx6325) BIOS reports an IRQ0 override 
> > > but the SB450 chipset is configured such that timer interrupts goe to 
> > > INT0 of IOAPIC.
> > > 
> > > Check IRQ0 routing and if it is routed to INT0 of IOAPIC skip the 
> > > timer override.
> > > 
> > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > >
> > > ---
> > >  arch/x86/kernel/early-quirks.c |   48 ++++++++++++++++++++++++++++++++++++++++
> > >  1 files changed, 48 insertions(+), 0 deletions(-)
> > 
> > very nice, thanks Andreas! Applied to tip/x86/quirks. This PCI ID based 
> > quirk should be more complete than DMI matches.
> > 
> 
> You may add 'Tested by: Dmitry Torokhov <dtor@mail.ru> on nx6115'
> It works fine here with Andreas patch applied and with Rafael's patch
> dropped.
>
> Thanks Andreas!

ok, added your Tested-by to the changelog, thanks.

I also applied the patch below to deprioritize the DMI quirks for this 
problem (without actually removing them, yet). Could you please check 
whether latest tip/master:

  http://people.redhat.com/mingo/tip.git/README

boots fine out of box and that the WARN() does not trigger?

	Ingo

--------------->
>From 8d89adf44cf750e49691ba5b744b2ad77a05e997 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 7 Oct 2008 06:47:52 +0200
Subject: [PATCH] x86: SB450: deprioritize DMI quirks

This PCI ID based quick should be a full solution for the IRQ0 override
related slowdown problem on SB450 based systems:

  33fb0e4: x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC

Emit a warning in those cases where the DMI quirk triggers but
the PCI ID based quirk didnt.

If this warning does not trigger then we can phase out the DMI quirks.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/boot.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c102af8..096102d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1421,8 +1421,16 @@ static int __init force_acpi_ht(const struct dmi_system_id *d)
  */
 static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 {
-	pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n", d->ident);
-	acpi_skip_timer_override = 1;
+	/*
+	 * The ati_ixp4x0_rev() early PCI quirk should have set
+	 * the acpi_skip_timer_override flag already:
+	 */
+	if (!acpi_skip_timer_override) {
+		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
+		pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n",
+			d->ident);
+		acpi_skip_timer_override = 1;
+	}
 	return 0;
 }
 

