Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbYGLGF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbYGLGF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 02:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYGLGFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 02:05:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40821 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbYGLGFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 02:05:17 -0400
Date: Sat, 12 Jul 2008 08:05:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic LVTT - use APIC_DIVISOR on 64bit mode
Message-ID: <20080712060504.GB14714@elte.hu>
References: <20080709190237.GA21423@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709190237.GA21423@asus>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> We use APIC_TDR_DIV_16 while setting APIC_TDCR (divisor) it happened 
> this moment is hidden from __setup_APIC_LVTT caller. So we better 
> increment caller 'clocks' value to not change current behaviour and 
> use APIC_DIVISOR (as already done in 32bit version).
> 
> The main benefit - unified procedure code for 32/64bit modes.

> Please review carefully. Any comments are welcome.
> I'm _not_ 100% sure if this patch is safe.

hm, how about the other caller to __setup_APIC_LVTT(), 
lapic_timer_setup():

        case CLOCK_EVT_MODE_ONESHOT:
                __setup_APIC_LVTT(calibration_result,
                                  mode != CLOCK_EVT_MODE_PERIODIC, 1);
                break;

that will affect high-res timers. Wont calibration_result have the same 
value after your patch as well, but only a 16th of it will be used in 
__setup_APIC_LVTT(), causing 16 times shorter timeouts than intended?

I.e. are we fixing a bug, are we changing nothing, or are we introducing 
a bug? :-)

	Ingo
