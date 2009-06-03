Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZFCCSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZFCCSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbZFCCSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:18:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZFCCSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:18:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
In-Reply-To: Oleg Nesterov's message of  Tuesday, 2 June 2009 16:50:35 +0200 <20090602144951.GA12123@redhat.com>
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com>
	<20090525000750.GA2301@redhat.com>
	<4A1AC5A3.9000600@gmail.com>
	<20090525172033.GA12586@redhat.com>
	<4A1AE02D.5080701@gmail.com>
	<20090525225150.GA12362@redhat.com>
	<4A25211C.8050504@gmail.com>
	<20090602144951.GA12123@redhat.com>
X-Shopping-List: (1) Insolent inquisition mice
   (2) Impervious burrowing redeemers
   (3) Extemporaneous complicators
Message-Id: <20090603015215.85A78FC333@magilla.sf.frob.com>
Date: Tue,  2 Jun 2009 18:52:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Heh. In this case you have another (long-standing) issue, please note
> > > the "if (p->flags & PF_EXITING)" check in wants_signal().

Hmm.  wants_signal():

	if (p->flags & PF_EXITING)
		return 0;
	if (sig == SIGKILL)
		return 1;

Perhaps we should reverse the order of those two?

But also I'm now reminded that complete_signal() short-circuits for the
single-threaded case and never does the sig_fatal() case.

This means a single-threaded process will have SIGKILL in shared_pending
but not in its own pending so __fatal_signal_pending() will be false, no?  

I'm also now wondering if in some of our recent signals discussions we have
been assuming that SIGNAL_GROUP_EXIT is set when a fatal signal is pending.
We might be leaving some other unintended hole since that's not really true.

Probably we should just fiddle complete_signal() to do that stuff for the
single-threaded case too.  (That obviates the wants_signal change above.)

> Yes, if a thread exits with the pending signal, then of course interruptible
> wait doesn work.

Along the same lines of the recent core dump discussion, I think it would
be proper to fix this so TIF_SIGPENDING isn't left set (nor is newly set)
by a signal that won't affect it later.

> We can clear TIF_SIGPENDING, and we can change recalc_sigpending_xxx()
> to take PF_EXITING into account (or change their callers), but this
> needs changes. And I am not sure this will right.

I think we want recalc_sigpending_tsk to be consistent with wants_signal
and the other conditions controlling signal_wake_up calls.  But indeed we
need to think through any ramifications carefully.


Thanks,
Roland
