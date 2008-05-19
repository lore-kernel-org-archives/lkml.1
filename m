Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbYESMbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbYESMbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYESMbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbYESMbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:06 -0400
Date: Mon, 19 May 2008 14:30:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] I/O APIC: Timer through 8259A revamp
Message-ID: <20080519123056.GB11318@elte.hu>
References: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> There is some seemingly unnecessary cruft accumulated in the 8254 
> timer setup path for the I/O APIC.  Some attempts have been made to 
> cater for broken BIOSes reporting the ExtINTA I/O APIC pin cascaded 
> from the master 8259A as the native timer interrupt input, which 
> interfere with the setup sequence in a non-obvious way and require a 
> pair of additional kernel command-line parameters.
> 
> I think this is unnecessary.  All the bits are already in place.  With 
> the removal of AEOI bits for non-i82489DX systems the whole setup can 
> be simplified.  Here is a set of changes that reuse the existing code 
> for potentially broken systems.  The observation is broken systems do 
> not have a notion of ExtINTA pins, so only one pin/apic pair will be 
> determined as useful for the timer interrupt.  Therefore it should be 
> safe to select this single pin/apic to test both directly and through 
> the 8259A.
> 
> This change implements this approach by copying timer pin information 
> found to the other pin if one has been found only.  This way both 
> tests are always performed.  The timer input of the 8259A is carefully 
> unmasked if needed only and masked again if found unneeded.  This is 
> because some systems seem sensitive for the master 8259A interrupt 
> being active even if all the APIC inputs this line is wired to are 
> masked.
> 
> The "disable_8254_timer" and "enable_8254_timer" kernel parameters are 
> removed as no longer needed.

applied to latest -tip, thanks.

> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  It works for my system, but it definitely requires much, much more 
> testing.  The patch depends on patch-2.6.26-rc1-20080505-timer_ack-1 
> sent earlier.

agreed, scary patch - but nice cleanups!

> Of course these "if (pin? != -1)" statements are useless (though 
> harmless) now, but I think that change deserves a separate patch not 
> to obfuscate changes to code which is obscure enough already.

please send another patch for that. If you can think of a good way of 
splitting up this patch into smaller units feel free to do that too ... 
Dangerous changes are much better if they happen in small incremental 
steps. (even if the sum of the changes is not any less dangerous - it 
just makes any trouble easier to bisect and fix)

	Ingo
