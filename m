Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZBIXkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZBIXkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZBIXkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:40:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49250 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZBIXkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:40:32 -0500
Date: Tue, 10 Feb 2009 00:40:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, hpa@zytor.com, jeremy@goop.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 03/11] x86: fix math_emu register frame access
Message-ID: <20090209234005.GA31577@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-4-git-send-email-tj@kernel.org> <73c1f2160902090913n20283872r2cb5ae774560d047@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c1f2160902090913n20283872r2cb5ae774560d047@mail.gmail.com>
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


* Brian Gerst <brgerst@gmail.com> wrote:

> On Mon, Feb 9, 2009 at 8:39 AM, Tejun Heo <tj@kernel.org> wrote:
> > do_device_not_available() is the handler for #NM and it declares that
> > it takes a unsigned long and calls math_emu(), which takes a long
> > argument and surprisingly expects the stack frame starting at the zero
> > argument would match struct math_emu_info, which isn't true regardless
> > of configuration in the current code.
> >
> > This patch makes do_device_not_available() take struct pt_regs like
> > other exception handlers and initialize struct math_emu_info with
> > pointer to it and pass pointer to the math_emu_info to math_emulate()
> > like normal C functions do.  This way, unless gcc makes a copy of
> > struct pt_regs in do_device_not_available(), the register frame is
> > correctly accessed regardless of kernel configuration or compiler
> > used.
> >
> > This doesn't fix all math_emu problems but it at least gets it
> > somewhat working.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> >
> > diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> > index afb46c0..84bdf8f 100644
> > --- a/arch/x86/kernel/traps.c
> > +++ b/arch/x86/kernel/traps.c
> > @@ -900,7 +900,7 @@ asmlinkage void math_state_restore(void)
> >  EXPORT_SYMBOL_GPL(math_state_restore);
> >
> >  #ifndef CONFIG_MATH_EMULATION
> > -asmlinkage void math_emulate(long arg)
> > +void math_emulate(struct math_emu_info *info)
> 
> You forgot to drop the asmlinkage from the prototype in traps.h.

fixed.

	Ingo
