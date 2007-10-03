Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbXJCQIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbXJCQIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXJCQHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:07:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbXJCQHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:07:52 -0400
Date: Wed, 3 Oct 2007 18:07:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux
	2.6.23-rc9 and a heads-up for the 2.6.24 series..)
Message-ID: <20071003160743.GA22782@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <20071003084607.GC32218@elte.hu> <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org> <alpine.LFD.0.999.0710030835070.3579@woody.linux-foundation.org> <20071003154914.GA21690@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003154914.GA21690@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Your compiler generates
> > 
> > 	movl    -16(%ebp),%edx
> > 	movl    (%edx),%edi		/* this is _totally_ bogus! */
> > 	incl    %edx
> > 	movl    %edx,-16(%ebp)
> > 	movl    %edi,%ecx
> > 	testb   %cl,%cl
> > 	je      ...
> 
> ah, ok.
> 
> > while I get (gcc version 4.1.2 20070925 (Red Hat 4.1.2-28)):
> > 
> >         movl    -16(%ebp), %eax # p,
> >         movzbl  (%eax), %edi    #, c	/* not bogus! */
> >         movl    %edi, %edx      # c,
> >         testb   %dl, %dl        #
> >         je      .L64    #,
> >         incl    %eax    #
> >         movsbl  %dl,%ebx        #, D.12414
> >         movl    %eax, -16(%ebp) #, p
> > 
> > where the difference (apart from doing the increment differently and 
> > different register allocation) is that I have a "movzbl" (correct), 
> > while you have a "movl" (pure and utter crap).
> 
> i'll try with another compiler in a minute.

i just tried:

  gcc version 4.1.2 20070626 (Red Hat 4.1.2-13)

and indeed the crash is gone. So you are completely right, it's a 
compiler bug in 4.0.2 (it's vanilla gcc 4.0.2 built by me, not a distro 
compiler). It should not affect normal kernels too much this bug needs 
CONFIG_DEBUG_PAGEALLOC. (or it needs a _really_ unlucky allocation being 
at the far upper end of RAM - but those are usually taken up by 
boot-time allocations anyway).

i also just re-tried the other config as well - and crash is gone there 
too. (not surprisingly)

	Ingo
