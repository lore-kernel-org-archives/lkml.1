Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZGIVFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZGIVFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZGIVFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:05:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbZGIVE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:04:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
X-Fcc: ~/Mail/linus
Cc: liqin.chen@sunplusct.com, Christoph Hellwig <hch@infradead.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] score: add regsets support for score
In-Reply-To: Arnd Bergmann's message of  Thursday, 9 July 2009 17:08:54 +0200 <200907091708.54468.arnd@arndb.de>
References: <OF5282122C.261603C7-ON482575ED.003A86FA-482575ED.003C4AEE@sunplusct.com>
	<200907091708.54468.arnd@arndb.de>
X-Shopping-List: (1) Hot precarious holiday captors
   (2) Perilous promotions
   (3) Demonic paradox proportions
Message-Id: <20090709210356.B1FD96BA56@magilla.sf.frob.com>
Date: Thu,  9 Jul 2009 14:03:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The code you add looks ok to me, but it appears you forgot to hook
> it up to the ptrace logic. Some architectures use it only for
> PTRACE_{GET,SET}REGS, others also use it in PTRACE_{PEEK,POKE}USR,
> I'm not sure what the right approach is for new architectures.
> Should a new architecture actually implement both of those
> interfaces?

I would not recommend adding PTRACE_{PEEK,POKE}USR to an ABI that
doesn't have it already.  It only exists on other arch's for past
compatibility; it's the poorest interface for this.

If you are starting from scratch, then you should define your arch's
user_regset layouts so that everything is nicely represented in one
regset or another.  Then for ptrace, define a PTRACE_{GET,SET}REGS
that exactly matches your regset 0, plus a *FPREGS for your FP regset
or one each such pair of ptrace requests for each extra user_regset
you have (if any).  arch_ptrace in arch/x86/kernel/ptrace.c shows an
example where *REGS are implemented in this trivial way.

> > +       ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> > +                                 regs->regs,
> > +                                 offsetof(struct pt_regs, regs),
> > +                                 end_pos);

This looks odd to me.  The last two arguments here are offsets into
the userland ABI format defined by the user_regset layout.  Unless
offsetof(struct pt_regs, regs) is zero, then you need to precede
this call with one that fills in the initial stretch of the userland
format layout from its 0 up to offsetof(struct pt_regs, regs).  If
in fact offsetof(struct pt_regs, regs) is zero, then it would be far
less confusing to just write 0 there IMHO.  Using offsetof on
pt_regs at all here is very confusing to me unless pt_regs describes
the userland ABI layout (in which case the use here still doesn't
make sense).

If what's instead the case is that the userland ABI format matches
just the pt_regs.regs field and nothing more, then what you want is:

	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
				  regs->regs, 0, sizeof(regs->regs));

I gather that you then have some reserved zero-fill words at the end
of the userland format (preparation for future use I presume).  So it's:

	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
				  regs->regs, 0, sizeof(regs->regs));
	if (!ret)
		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
					       sizeof(regs->regs), -1);

Et voila.

But I may be misunderstanding what the intended userland ABI format is
here.  I'd advise you to make sure that everything that can affect
user-mode instructions (condition codes, etc.) is exposed via some
user_regset layouts, or else you'll eventually have userland debugger
folks coming back to have you cram them in somehow later (and it won't
wind up as pretty).


Thanks,
Roland
