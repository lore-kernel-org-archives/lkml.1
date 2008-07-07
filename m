Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbYGGODD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbYGGODD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYGGOCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:02:53 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63953 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750804AbYGGOCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:02:52 -0400
Date: Mon, 7 Jul 2008 15:01:31 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-next@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
 systems
In-Reply-To: <200807071423.48425.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0807071435160.16767@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
 <20080707071706.GA3326@elte.hu> <Pine.LNX.4.55.0807071224491.16767@cliff.in.clinika.pl>
 <200807071423.48425.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Rafael J. Wysocki wrote:

> >  It makes absolutely no sense and should be harmful to call
> > clear_IO_APIC_pin(apic1, pin1) here, because both apic1 and pin1 should be
> > equal to -1 here.  If it has to be called, then I suppose the DMI matching 
> > did not work and the workaround has not been enabled.
> 
> Do you realize that the clear_IO_APIC_pin(apic1, pin1) thing is _only_ called
> _IF_ the DMI matching did work?

 Well, it is the very intent of the DMI quirk to set apic1 and pin1 both
to -1, as a result of IRQ0 being absent from our I/O APIC interrupt
routing table.  Therefore if the quirk did indeed work, a call to
clear_IO_APIC_pin() is useless and likely harmful as its callees don't do
range checking (my understanding of code is it results in random poking at
the local APIC through the FIX_APIC_BASE fixmap).  There should be nothing
to clear too, as interrupt redirection entries for all the I/O APIC inputs
are cleared (the mask is set to 1 and the remaining fields zeroed) when
clear_IO_APIC() is called from enable_IO_APIC() upon initialization and
all the unused ones (not referred to from anywhere in the interrupt
routing table) are never touched afterwards.

  Maciej
