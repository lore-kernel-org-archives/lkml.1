Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYDMPSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYDMPSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 11:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYDMPSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 11:18:22 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34350 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYDMPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 11:18:22 -0400
Date: Sun, 13 Apr 2008 18:24:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
Message-ID: <20080413142401.GA532@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <20080329033542.BFF4526FA1D@magilla.localdomain> <20080329103929.GB359@tv-sign.ru> <20080329131019.GA472@tv-sign.ru> <20080404210033.F26CC26F8DC@magilla.localdomain> <20080405140656.GA109@tv-sign.ru> <20080409201555.7D23626F98D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409201555.7D23626F98D@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay!

On 04/09, Roland McGrath wrote:
>
> > Well, I was thinking about another thread (the new parent) sleeping in
> > do_wait(__WNOTHREAD)... not sure this really matters, though.
> 
> I'm pretty sure it doesn't matter in real life.  I doubt whoever uses
> __WNOTHREAD was relying on seeing some other thread's reparented
> children.  TBH, I don't care much about __WNOTHREAD and I don't know off
> hand of anything that actually uses it.

Agreed. I never understood why we need __WNOTHREAD. The same for
->pdeath_signal in its current "per-thread" form. I think it would be
very nice to kill them both (or send the ->pdeath_signal when the whole
process exits). Then we can place all childrens on one signal->children
list. But this is a bit off-topic for now.

> I've put the latest tweaked version of this same patch series at:
> 	http://people.redhat.com/roland/kernel-patches/ptrace-cleanup.mbox
> That adds a fourth patch that fixes the aforementioned bug case that the
> current canonical kernel gets wrong.  I think that fix also incidentally
> covered the init-ignores-SIGCHLD case, but I didn't test that and I'm
> not really positive.

I think the 4th patch has a small problem,

	reparent_zombie:

		if (p->exit_signal == -1 ||
		    (thread_group_empty(p) && ignoring_children(p->real_parent)))
			list_add(&p->ptrace_list, dead);

The 2nd case, "thread_group_empty(p) && ignoring_children", looks racy.
We didn't set ->exit_signal == -1, the new parent can call do_wait() and
release "p" as soon as we drop tasklist_lock, before ptrace_exit_finish().

> I'm working on a variant of the ptrace revamp where all ptrace'd tasks
> go on a list (whether natural children or not).  (This was my original
> intent, but then I thought it might be more complication and change that
> way.  Now it's seeming attractive again.)

Yes! I thought about this too. Actually, I was very sure that this is your
plan from the the very beginning ;)

Oleg.

