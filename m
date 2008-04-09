Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYDIUQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYDIUQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYDIUQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:16:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYDIUQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:16:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
In-Reply-To: Oleg Nesterov's message of  Saturday, 5 April 2008 18:06:56 +0400 <20080405140656.GA109@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
	<20080329033542.BFF4526FA1D@magilla.localdomain>
	<20080329103929.GB359@tv-sign.ru>
	<20080329131019.GA472@tv-sign.ru>
	<20080404210033.F26CC26F8DC@magilla.localdomain>
	<20080405140656.GA109@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080409201555.7D23626F98D@magilla.localdomain>
Date: Wed,  9 Apr 2008 13:15:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Heh. You are right, the current kernel has the same (minor) bug.
> I beleive it was introduced by b2b2cbc4b2a2f389442549399a993a8306420baf.

I have a regression test program for that (the one I sent you).
I've done a fix as a follow-on patch.

> However, now I think your patch adds a more serious problem, we can really
> leak a zombie. Suppose that that we are ->real_parent, the child was traced
> by us, it is zombie now, and the child is not a group leader. No matter who
> is the new parent, no matter what is the state of SIGCHLD, we must not reparent
> the child: nobody can release it except us. It is not traced any longer,
> its ->exit_signal == -1, eligible_child() doesn't like this.
> 
> No?

(Yes!)  Ah, thanks for that.  I wrote a regression test program for this
case that worked before and fails with my last version of the patch.
I've fixed my new code so it passes again.

> Well, I was thinking about another thread (the new parent) sleeping in
> do_wait(__WNOTHREAD)... not sure this really matters, though.

I'm pretty sure it doesn't matter in real life.  I doubt whoever uses
__WNOTHREAD was relying on seeing some other thread's reparented
children.  TBH, I don't care much about __WNOTHREAD and I don't know off
hand of anything that actually uses it.  OTOH, an extra wakeup on
wait_chldexit is always harmless.  And for pure anality, it seems proper
to maintain the invariant that do_wait() wakes up promptly whenever
interrupting and restarting it would complete without blocking.  But, we
don't get that wakeup now and noone has complained, so all in all, I'm
inclined to leave it as it is.

I've put the latest tweaked version of this same patch series at:
	http://people.redhat.com/roland/kernel-patches/ptrace-cleanup.mbox
That adds a fourth patch that fixes the aforementioned bug case that the
current canonical kernel gets wrong.  I think that fix also incidentally
covered the init-ignores-SIGCHLD case, but I didn't test that and I'm
not really positive.

I'm working on a variant of the ptrace revamp where all ptrace'd tasks
go on a list (whether natural children or not).  (This was my original
intent, but then I thought it might be more complication and change that
way.  Now it's seeming attractive again.)  I tend towards this approach
aesthetically because it makes ptrace bookkeeping more consistent across
all kinds of tracees.  For the cases we've been talking about, it means
ptrace_exit() would take care of zombies kept alive by ptrace uniformly
before we get to the reparent_thread loop.  This means the init case is
separate and needs a separate fix, but that kind of seems cleaner.  When
I get the variant patch working, we can see which one looks best.  I'd
like your opinion on that.


Thanks,
Roland
