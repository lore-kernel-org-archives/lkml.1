Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZBIORr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZBIORr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZBIOPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:15:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbZBIOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:15:42 -0500
Date: Mon, 9 Feb 2009 15:15:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, hpa@zytor.com, jeremy@goop.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
Message-ID: <20090209141525.GA24897@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <73c1f2160902090609qeabc926nc5579f87c1ca5207@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c1f2160902090609qeabc926nc5579f87c1ca5207@mail.gmail.com>
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
> >
> > Hello,
> >
> > This patchset adds stack protector support for x86_32.  The basics are
> > the same with x86_64 but there are some noticeable differences.
> >
> > * x86_32 uses %fs for percpu base.  %gs is unused by the kernel and
> >  managed lazily.  %gs is used for userland TLS and loading %gs with
> >  different value on kernel entry is known to cost quite a bit on some
> >  chips.
> >
> >  Lazy %gs handling is made optional and disabled if stack protector
> >  is enabled.  To do this, entry for %gs is added to pt_regs.  This
> >  adds one "pushl $0" to SAVE_ALL in entry_32.S when lazy %gs is on.
> >  However, no overhead is added to common exit path and error_code
> >  entry path shed a few instructions.  I don't think there will be
> >  noticeable overhead but then again it does add an instruction to a
> >  very hot path.  Would this be okay?
> >
> > * x86_32 doesn't support direct access to shadow part of %gs and
> >  there's no swapgs, so GDT entry should be built for stack canary.
> >
> >  GDT entry 28 is used for this.  The boot cpu one is setup from
> >  head_32.S.  Others while setting up percpu areas.
> >
> > * math_emu register access was completely broken.  Fixed.
> >
> > * x86_32 exception handlers take register frame verbatim as struct
> >  pt_regs.  With -fstack-protector, gcc copies pt_regs into the
> >  callee's stack frame to put it after the stack canary.  Of course it
> >  doesn't copy back (as the callee owns the argument) and any change
> >  made to pt_regs is lost on return.  This is currently worked around
> >  by adding -fno-stack-protector to any file containing such
> >  functions.  We really need to teach gcc about the calling
> >  convention.
> 
> I had a patch a while back that would convert those function to take a
> pointer to pt_regs instead of assuming that the struct was passed by
> value. [...]

Yes, that's the right solution. Getting a new call convention recognized
is a 3 years timeframe project for a whole team of hackers. Adding a
pointer is a 30 minutes project for one good kernel hacker ;)

> [...]  I'll take a stab at reworking it on top of this series.

Cool!

	Ingo
