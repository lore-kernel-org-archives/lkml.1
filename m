Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbYKWWgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbYKWWgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbYKWWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:36:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39384 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYKWWgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:36:01 -0500
Date: Sun, 23 Nov 2008 23:35:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce ENTRY(KPROBE)_X86  assembly helpers
	to catch unbalanced declaration
Message-ID: <20081123223553.GA3066@elte.hu>
References: <20081123175125.GA32472@uranus.ravnborg.org> <20081123175846.GF12710@localhost> <20081123181248.GA338@uranus.ravnborg.org> <20081123182103.GH12710@localhost> <20081123185417.GA21106@elte.hu> <20081123185726.GL12710@localhost> <20081123190025.GD21106@elte.hu> <20081123192243.GP12710@localhost> <20081123193133.GA2794@elte.hu> <20081123194828.GQ12710@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123194828.GQ12710@localhost>
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
> Yeah, I meant these cases. I don't think we really need 
> irq_entries_start (didn't find any mention of them in tree). In case 
> of system_call_after_swapgs I'm not that sure, but since xen use it 
> as a plain jmp (at least now) it could be converted to a plain 
> label. [...]

system_call_after_swapgs is a slowpath and should be converted to a 
simple:

 .globl system_call_after_swapgs
 system_call_after_swapgs:

symbol definition - with no particular jump target alignment tweaks.

(the above sequence should be generalized as an __ENTRY() macro - i.e. 
raw global symbol definition without any alignment tweaks)

	Ingo
