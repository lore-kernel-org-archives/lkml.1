Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbYKWO4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbYKWO4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 09:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbYKWO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 09:56:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235AbYKWO4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 09:56:08 -0500
Date: Sun, 23 Nov 2008 15:55:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
Message-ID: <20081123145554.GA3224@elte.hu>
References: <20081120153954.GA22511@elte.hu> <20081121154155.GA12999@mailshack.com> <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123091532.GA31515@mailshack.com> <20081123132752.GF1178@elte.hu> <20081123135134.GH24818@localhost> <20081123141237.GI24818@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123141237.GI24818@localhost>
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

> [Cyrill Gorcunov - Sun, Nov 23, 2008 at 04:51:34PM +0300]
> | [Ingo Molnar - Sun, Nov 23, 2008 at 02:27:52PM +0100]
> | | 
> | | * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> | | 
> | | > Impact: moves some code out of .kprobes.text
> | | > 
> | | > KPROBE_ENTRY switches code generation to .kprobes.text, and KPROBE_END
> | | > uses .popsection to get back to the previous section (.text, normally).
> | | > Also replace ENDPROC by END, for consistency.
> | | > 
> | | > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> | | 
> | | applied to tip/x86/irq, thanks Alexander!
> | | 
> | | > One more small change for today. The xen-related functions 
> | | > xen_do_hypervisor_callback and xen_failsafe_callback are put
> | | > in the .kprobes.text even in the current kernel: ignore_sysret
> | | > is enclosed in KPROBE_ENTRY / ENDPROC, instead of KPROBE_ENTRY /
> | | > KPROBE_END, but I guess the situation is harmless.
> | | 
> | | yeah. It narrows no-kprobes protection for that code, but it should 
> | | indeed be fine (and that's the intention as well).
> | | 
> | | Note that this is a reoccuring bug type, and rather long-lived. Can 
> | | you think of any way to get automated nesting protection of both the 
> | | .cfi_startproc/endproc macros and kprobes start/end? A poor man's 
> | | solution would be to grep the number of start and end methods and 
> | | enforce that they are equal.
> | | 
> | | 	Ingo
> | | 
> | 
> | I think we could play with preprocessor and check if ENTRY/END matches.
> | Looking now.
> | 
> | 		- Cyrill -
> 
> Here is what I've done
> 
> 1) Add some macros like:
> 
> 	.macro __set_entry
> 	.set _ENTRY_IN, 1
> 	.endm
> 
> 	.macro __unset_entry
> 	.set _ENTRY_IN, 0
> 	.endm
> 
> 	.macro __check_entry
> 	.ifeq _ENTRY_IN
> 	.error "END should be used"
> 	.abort
> 	.endif
> 	.endm
> 
> So the code
> 
> ENTRY(mcount)
> 	__unset_entry
> 	retq
> 	__check_entry
> END(mcount)
> 
> will fail like
> 
> cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/entry_64.o
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   AS      arch/x86/kernel/entry_64.o
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:84: Error: END should be used
> arch/x86/kernel/entry_64.S:84: Fatal error: .abort detected.  Abandoning ship.
> make[1]: *** [arch/x86/kernel/entry_64.o] Error 1
> make: *** [arch/x86/kernel/entry_64.o] Error 2
> cyrill@lenovo linux-2.6.git $ 
> 
> So if such an approach is acceptable (in general) -- I could take a 
> more deeper look. So every ENTRY would check if other ENTRY/KPROBE 
> is active and report that.

looks good!

Can we somehow detect a missing .cfi_endproc? That's another pattern 
i've seen.

	Ingo
