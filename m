Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYKTPkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYKTPkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbYKTPkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:40:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40796 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbYKTPkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:40:23 -0500
Date: Thu, 20 Nov 2008 16:39:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86: clean up after: move entry_64.S register saving
	out of the macros
Message-ID: <20081120153954.GA22511@elte.hu>
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com> <20081120134011.GA3627@mailshack.com> <20081120150412.GC13550@elte.hu> <20081120152601.GA3953@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120152601.GA3953@mailshack.com>
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


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> On Thu, Nov 20, 2008 at 04:04:12PM +0100, Ingo Molnar wrote:
> > 
> > * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > 
> > > This add-on patch to x86: move entry_64.S register saving out of the 
> > > macros visually cleans up the appearance of the code by introducing 
> > > some basic helper macro's. It also adds some cfi annotations which 
> > > were missing.
> > > 
> > > Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> > > ---
> > >  arch/x86/kernel/entry_64.S |  220 ++++++++++++++++++++++----------------------
> > >  1 files changed, 112 insertions(+), 108 deletions(-)
> > > 
> > > Hello Ingo,
> > > 
> > > This patch improves the CFI-situation in entry_64.S, but restricted 
> > > mostly to the areas touched by "x86: move entry_64.S register saving 
> > > out of the macros". I'm sure there will be some small errors 
> > > somewhere, but it compiles and runs fine.
> > 
> > very nice cleanup! This is exactly what should be done. Applied to 
> > tip/x86/irq.
> > 
> > Note, i did a small rename:
> > 
> >     cfi_pushq  =>  pushq_cfi
> >     cfi_popq   =>  popq_cfi
> >     cfi_store  =>  movq_cfi
> > 
> > as the goal is to have the actual source code read mostly as regular 
> > assembly code. The fact that the macro is equivalent to a 
> > default-annotated pushq/popq/movq instruction is much more important 
> > than the fact that it also does CFI annotations.
> > 
> > Also, while cfi_store is correct as well, the usual x86 assembly term 
> > (and instruction used here) is movq.
> 
> Now I have a little problem with my next patch... I wanted to 
> introduce cfi_load. Guess what assembly instruction that maps to ;).

heh ;-)

the restore direction could be named movq_cfi_restore, and have the same 
order of arguments as the regular movq that it replaces. I.e.:

        movq 8(%rsp),%r11
        CFI_RESTORE r11

would map to:

	movq_cfi_restore 8, r11

or so.

cfi_store has really a bad name: it's confusing whether it's the CFI 
info we are storing/registering (which we are), or a 'store' instruction 
(which this is too).

If then we should name it movq_cfi_store or movq_cfi_register - but 
that's too long.

movq_cfi for the frame construction direction and movq_cfi_restore for 
the frame deconstruction phase sounds like a good naming compromise, hm?

	Ingo
