Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbZBEBKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbZBEBKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZBEBKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:10:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbZBEBKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:10:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ptrace: simplify ptrace_exit()->ignoring_children()
	path
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 January 2009 05:29:17 +0100 <20090129042917.GA5108@redhat.com>
References: <20090129042917.GA5108@redhat.com>
X-Zippy-Says: UH-OH!!  I put on ``GREAT HEAD-ON TRAIN COLLISIONS of the 50's'' by
    mistake!!!
Message-Id: <20090205010951.648CCFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 17:09:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ignoring_children() takes parent->sighand->siglock and checks
> k_sigaction[SIGCHLD] atomically. But this buys nothing, we can't get
> the "really" wrong result even if we race with sigaction(SIGCHLD).
> If we read the "stale" sa_handler/sa_flags we can pretend it was
> changed right after the check.

Agreed.  There is no real synchronization anyway, since sigaction does not
cause reaping of zombies already extant (and POSIX says it does not).  All
that really matters is that ignoring_children() never have a false-negative
after sigaction has been called synchronously (i.e. earlier in the same
thread, or in another thread before intervening synchronization preceding
this thread's exit).

> Perhaps it makes sense to export this helper, do_notify_parent() can
> use it too.

It's now quite trivial.  Might as well make it a signal.h inline.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
