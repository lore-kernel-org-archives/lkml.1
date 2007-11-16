Return-Path: <linux-kernel-owner+w=401wt.eu-S1765354AbXKPUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765354AbXKPUYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbXKPUYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:24:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXKPUYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:24:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Kees Cook <kees@ubuntu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] wait_task_stopped: tidy up the noreap case
In-Reply-To: Oleg Nesterov's message of  Friday, 16 November 2007 20:24:13 +0300 <20071116172413.GA7296@tv-sign.ru>
References: <20071116172413.GA7296@tv-sign.ru>
X-Shopping-List: (1) Uninteresting distenders
   (2) Frothy shrub infestations
   (3) Lesser-known yarns
Message-Id: <20071116202403.1CF0C26F8BA@magilla.localdomain>
Date: Fri, 16 Nov 2007 12:24:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is good, but not quite enough.  The original intent behind having the
test was never to return mismatched stale/fresh data.  (Not that it ever
really worked as intended.)  That is, it's fine if the task has woken up
and done other things while WNOWAIT reports it as stopped--that's stale
data, but it just means the waitid call happened "before" the resumption.
However, it should not report anything that could not possibly have been
true before the resumption.  i.e. a changed exit_code, which now means an
normal termination status or a death signal, not the stop signal.  This
also applies to the uid, in case the thread called setuid upon resuming
(and even to ptracedness, not that that one really matters).  (It doesn't
matter for rusage, since that's not really an exact change of state with
reliable ordering anyway.)

So the setting of uid and why should also move before read_unlock.
While you're at it, you could fix the status argument to wait_noreap_copyout.
It should be just exit_code, not the WIFSTOPPED bit format it does now.


Thanks,
Roland
