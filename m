Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZBKKTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZBKKTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZBKKSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:18:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45451 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZBKKSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:18:54 -0500
Date: Wed, 11 Feb 2009 11:18:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Pass in pt_regs pointer for syscalls that
	need it
Message-ID: <20090211101846.GH20518@elte.hu>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com> <1234277507-4987-3-git-send-email-brgerst@gmail.com> <4992812B.1050800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4992812B.1050800@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Brian.
> 
> Brian Gerst wrote:
> > Some syscalls need to access the pt_regs structure, either to copy
> > user register state or to modifiy it.  This patch adds stubs to load
> > the address of the pt_regs struct into the %eax register, and changes
> > the syscalls to regparm(1) to receive the pt_regs pointer as the
> > first argument.
> 
> Heh... neat.  Just one question.
> 
> > -asmlinkage long sys_iopl(unsigned long regsp)
> > +ptregscall long sys_iopl(struct pt_regs *regs, unsigned int level)
> >  {
> > -	struct pt_regs *regs = (struct pt_regs *)&regsp;
> > -	unsigned int level = regs->bx;
> 
> Here and at other places where the function takes more than one
> arguments, wouldn't it be better to just take *regs and use other
> parameters from regs?  That way we won't have to worry about gcc
> corrupting register frame at all and I think it's cleaner that way.

Hm, gcc cannot corrupt register arguments only on-stack arguments - but
your suggestion nevertheless makes sense as an optimization. I'd suggest
this to be done as a separate patch though, both for regression analysis
reasons (easier to bisect - the patch is large enough already) and from
a size/performance analysis POV. (so we can see the benefits in isolation)

	Ingo
