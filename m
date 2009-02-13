Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZBMKVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZBMKVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZBMKVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:21:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51606 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZBMKVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:21:02 -0500
Date: Fri, 13 Feb 2009 11:20:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, orenl@cs.columbia.edu,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Message-ID: <20090213102036.GA4608@elte.hu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu> <1234285547.30155.6.camel@nimitz> <20090211141434.dfa1d079.akpm@linux-foundation.org> <20090212091721.GB1888@elte.hu> <1234462283.30155.173.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234462283.30155.173.camel@nimitz>
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


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> > What is it good for right now, and what are the known weaknesses and
> > quirks you can think of. Declaring them upfront is a bonus - not talking
> > about them and us discovering them later at the patch integration stage
> > is a sure receipe for upstream grumpiness.
> 
> That's a fair enough point, and I do agree with you on it.
> 
> Right now, it is good for very little.  An app has to basically be
> either specifically designed to work, or be pretty puny in its
> capabilities.  Any fds that are open can only be restored if a simple
> open();lseek(); would have been sufficient to get it back into a good
> state.  The process must be single-threaded.  Shared memory, hugetlbfs,
> VM_NONLINEAR are not supported.  

That is OK as a starting point, as long as:

> > For example, one of the critical corner points: can an app programmatically 
> > determine whether it can support checkpoint/restart safely? Are there 
> > warnings/signals/helpers in place that make it a well-defined space, and
> > make the implementation of missing features directly actionable?
> > 
> > ( instead of: 'silent breakage' and a wishy-washy boundary between the
> >   working and non-working space. Without clear boundaries there's no
> >   clear dynamics that extends the 'working' space beyond the demo stage. )
> 
> Patch 12/14 is supposed to address this *concept*.  But, it hasn't been
> carried through so that it currently works.  My expectation was that we
> would go through and add things over time.  I'll go make sure I push it
> to the point that it actually works for at least the simple test
> programs that we have.
> 
> What I will probably do is something BKL-style.  Basically put a "this
> can't be checkpointed" marker over most everything I can think of and
> selectively remove it as we add features.  

An app really has to know whether it can reliably checkpoint+restart.

Otherwise it wont ever get past the toy stage and people will waste a
lot of time if their designed-for-checkpoints app accidentally runs
into some kernel feature or other side-effect that is not supported.

I personally wouldnt mind to sprinkle the kernel with markers, as long
as you can make it really cheap even with CONFIG_CHECKPOINT_RESTART=y.

Btw., i dont think it's all that much work, nor is it really intrusive:
have you thought of reusing all the existing security callbacks? You'd
have instant coverage of basically every system call and kernel
functionality that matters, and you could have a finegrained set of
policies.

The only drawback is that you have to enable CONFIG_SECURITY for it,
but in practice most distros enable that, so the callback overhead is
already there - you just have to enable it. (Also, some care has to
be taken to properly stack it to existing LSM modules, but that is
solvable too.)

Sidenote: CONFIG_CHECKPOINT_RESTART is IMO an uncomfortably long name,
i'd suggest to rename it to CONFIG_CHECKPOINTS or so. [the concept of a
checkpoint is good enough to mention - if there's a checkpoint then a
restart is logically implied.]

	Ingo
