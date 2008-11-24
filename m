Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbYKXJLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbYKXJLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYKXJLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:11:12 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:19075 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYKXJLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:11:11 -0500
Date: Mon, 24 Nov 2008 10:10:31 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers to catch unbalanced declaration
Message-ID: <20081124091031.GA8187@mailshack.com>
References: <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost> <20081123185417.GA21106@elte.hu> <20081123185726.GL12710@localhost> <20081123190025.GD21106@elte.hu> <20081123192243.GP12710@localhost> <20081123193133.GA2794@elte.hu> <20081123194828.GQ12710@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123194828.GQ12710@localhost>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Mon, 24 Nov 2008 10:10:58 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.125; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 10:48:28PM +0300, Cyrill Gorcunov wrote:
> [Ingo Molnar - Sun, Nov 23, 2008 at 08:31:34PM +0100]
> ...
> | > 
> | > Just got an error in implementation -- we have to support nested
> | > ENTRY without problem. Will check. What a surprise :-)
> | 
> | do you mean:
> | 
> |   ENTRY(system_call)
> |   ENTRY(system_call_after_swapgs)
> |   ...
> |   END(system_call)
> | 
> | that's more of a bug - system_call_after_swapgs is not a real entry 
> | point, we just need the label of it. Perhaps something like __ENTRY() 
> | for that case would be enough.
> | 
> | nor is this one real:
> | 
> |   ENTRY(interrupt)
> |   ENTRY(irq_entries_start)
> |   ...
> |   END(irq_entries_start)
> |   END(interrupt)
> | 
> | do we really need .irq_entries_start?
> | 
> | I think in general we should define a flat hierarchy of entries.
> | 
> | 	Ingo
> | 
> 
> Yeah, I meant these cases. I don't think we really need irq_entries_start
> (didn't find any mention of them in tree). In case of system_call_after_swapgs
> I'm not that sure, but since xen use it as a plain jmp (at least now) it
> could be converted to a plain label. Ingo, I'll continue tomorrow evening --
> have some other things to be done :)

The problem is that ENTRY(interrupt) is done in init.rodata, and
ENTRY(irq_entries_start) is done in .text. So inside the .S-file,
they are nested, but in the .o-file they are separate. Instead of
removing ENTRY(irq_entries_start), I think we should just expand to:


	.section .init.rodata,"a"
	.p2align 5
	.global interrupt
interrupt:

and

	size interrupt, .-interrupt

But the only importance I can think of is that this keeps both
the "interrupt" array and irq_entries_start visible in debugging
information.

Alternatively, we could probably do away with the interrupt
array entirely. We _know_ how the irq stubs are structured and
irq_entries_start is in principle enough information to reconstruct
all information in interrupt.

Anyhow, I too think that supporting nested ENTRY/END in .S files is
unnecessary.

Alexander

> 		- Cyrill -
