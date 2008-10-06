Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYJFPBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYJFPBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYJFPBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:01:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54849 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbYJFPBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:01:17 -0400
Date: Mon, 6 Oct 2008 17:00:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
	(Re: 2.6.27-rc8+ - first impressions)
Message-ID: <20081006150055.GA16930@elte.hu>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 6 Oct 2008, Rafael J. Wysocki wrote:
> > 
> > Unfortunately some of the recent IO-APIC changes made the bug show 
> > up.  To prevent this from happening, blacklist machines that are 
> > known to be affected (nx6115 and 6715b in this particular case).
> 
> Can you point to exactly _which_ recent change made it show up? I'd 
> really like to know. _What_ was it that made us suddenly need this 
> quirk when it wasn't necessary before? I'd like to understand the root 
> cause here.
> 
> And how did you even start looking at that strange ACPI override?

i think it was caused by this stream of IO-APIC changes:

 49a66a0: x86: I/O APIC: Always report how the timer has been set up
 17c4469: x86: I/O APIC: Include <asm/i8259.h> required by some code
 593f4a7: x86: APIC: remove apic_write_around(); use alternatives
 ce8b06b: x86: I/O APIC: remove an IRQ2-mask hack
 af17478: x86: I/O APIC: Never configure IRQ2
 c88ac1d: x86: L-APIC: Always fully configure IRQ0
 1baea6e: x86: L-APIC: Set IRQ0 as edge-triggered

Rafael/Maciej, which of these is causing it? ce8b06b ("x86: I/O APIC: 
remove an IRQ2-mask hack")?

Current theory is that this specific flavor of BIOS on HP / AMD / Turion 
laptops (no other type is known to be affected at the moment) somehow 
detects the IO-APIC masking patterns and uses an SMI quirk to change the 
ACPI thermal trip point to very low settings, and thus confusing cpufreq 
to (correctly) go into a very slow frequency.

Activating the quirk works this around. Should we perhaps default to 
this 'quirk' enabled by default?

	Ingo
