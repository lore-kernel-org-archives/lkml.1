Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYKWPcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYKWPcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 10:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKWPby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 10:31:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52672 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYKWPbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 10:31:53 -0500
Date: Sun, 23 Nov 2008 16:31:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
Message-ID: <20081123153140.GF3224@elte.hu>
References: <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123091532.GA31515@mailshack.com> <20081123132752.GF1178@elte.hu> <20081123135134.GH24818@localhost> <20081123141237.GI24818@localhost> <20081123150418.GA32078@mailshack.com> <20081123151210.GB27396@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123151210.GB27396@localhost>
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

> [Alexander van Heukelum - Sun, Nov 23, 2008 at 04:04:18PM +0100]
> | On Sun, Nov 23, 2008 at 05:12:37PM +0300, Cyrill Gorcunov wrote:
> | > [Cyrill Gorcunov - Sun, Nov 23, 2008 at 04:51:34PM +0300]
> | > | [Ingo Molnar - Sun, Nov 23, 2008 at 02:27:52PM +0100]
> | > | | 
> | > | | * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> | > | | 
> | > | | > Impact: moves some code out of .kprobes.text
> | > | | > 
> | > | | > KPROBE_ENTRY switches code generation to .kprobes.text, and KPROBE_END
> | > | | > uses .popsection to get back to the previous section (.text, normally).
> | > | | > Also replace ENDPROC by END, for consistency.
> | > | | > 
> | > | | > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> | > | | 
> | > | | applied to tip/x86/irq, thanks Alexander!
> | > | | 
> | > | | > One more small change for today. The xen-related functions 
> | > | | > xen_do_hypervisor_callback and xen_failsafe_callback are put
> | > | | > in the .kprobes.text even in the current kernel: ignore_sysret
> | > | | > is enclosed in KPROBE_ENTRY / ENDPROC, instead of KPROBE_ENTRY /
> | > | | > KPROBE_END, but I guess the situation is harmless.
> | > | | 
> | > | | yeah. It narrows no-kprobes protection for that code, but it should 
> | > | | indeed be fine (and that's the intention as well).
> | > | | 
> | > | | Note that this is a reoccuring bug type, and rather long-lived. Can 
> | > | | you think of any way to get automated nesting protection of both the 
> | > | | .cfi_startproc/endproc macros and kprobes start/end? A poor man's 
> | > | | solution would be to grep the number of start and end methods and 
> | > | | enforce that they are equal.
> | > | | 
> | > | | 	Ingo
> | > | | 
> | > | 
> | > | I think we could play with preprocessor and check if ENTRY/END matches.
> | > | Looking now.
> | > | 
> | > | 		- Cyrill -
> | > 
> | > Here is what I've done
> | > 
> | > 1) Add some macros like:
> | > 
> | > 	.macro __set_entry
> | > 	.set _ENTRY_IN, 1
> | > 	.endm
> | > 
> | > 	.macro __unset_entry
> | > 	.set _ENTRY_IN, 0
> | > 	.endm
> | > 
> | > 	.macro __check_entry
> | > 	.ifeq _ENTRY_IN
> | > 	.error "END should be used"
> | > 	.abort
> | > 	.endif
> | > 	.endm
> | > 
> | > So the code
> | > 
> | > ENTRY(mcount)
> | > 	__unset_entry
> | > 	retq
> | > 	__check_entry
> | > END(mcount)
> | 
> | Looks like a good approach to me. But I assume the ENTRY cppmacro
> | will include magic?
> | 
> | Greetings,
> | 	Alexander
> | 
> 
> yes, but now I'm in doubts since we have this definition in common 
> linkage.h I dont know if such approach would be usable on other 
> platforms.

i'd suggest to introduce another entry macro name for that, for the 
time being. If other architectures want to pick up the method, they 
can generalize and test it.

( but this is assembly magic so i'm doubtful - while the features used 
  are generic GAS features that should work everywhere, binutils 
  variants tend to be rather fragile. So lets go with some other name 
  like X86_ENTRY()/X86_END() or so - or maybe ENTRY_CFI()/END_CFI(). )

	Ingo
