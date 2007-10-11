Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbXJKKfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbXJKKfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXJKKex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:34:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbXJKKew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:34:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core dump: remain dumpable
In-Reply-To: Oleg Nesterov's message of  Thursday, 11 October 2007 14:25:07 +0400 <20071011102507.GA101@tv-sign.ru>
References: <20071011062730.19F774D026B@magilla.localdomain>
	<20071011102507.GA101@tv-sign.ru>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20071011103446.89BCC4D03F7@magilla.localdomain>
Date: Thu, 11 Oct 2007 03:34:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Do we really need the new MMF_DUMP_STARTED flag? We are holding ->mmap_sem,
> can't we check "mm->core_waiters != 0" instead?

Yes, I think you're right.  I gave the old use of dumpable the benefit of
the doubt as being needed for synchronization, but that would be enough too.

> Hmm. Actually, do we need any check? If another thread (or CLONE_VM task)
> already started do_coredump(), we must see SIGNAL_GROUP_EXIT when we take
> ->mmap_sem. In that case coredump_wait() does nothing but returns -EAGAIN.

You're right again here.  I'm sure the old use predates this checking in
zap_threads, so it's understandable that something different was needed for
this synchronization before.

> > -	set_dumpable(mm, 0);
> 
> Looks like this change is all we need, no? The only problem is that we
> return -EAGAIN if we race with another thread (the current code returns 0),
> but nobody checks the returned value.

I concur.  It merits a comment at the coredump_wait call that this takes
care of all synchronization issues including races to enter do_coredump.


Thanks,
Roland
