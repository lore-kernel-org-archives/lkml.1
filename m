Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZCRIBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZCRIBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZCRIBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:01:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZCRIBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:01:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       =?iso-8859-1?Q?G=E1bor?= Melis <mega@retes.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: SEGSEGV && uc_mcontext->ip (Was: Signal delivery order)
In-Reply-To: Oleg Nesterov's message of  Tuesday, 17 March 2009 05:13:37 +0100 <20090317041337.GA29740@redhat.com>
References: <200903141750.37238.mega@retes.hu>
	<200903152306.53031.mega@retes.hu>
	<20090316002833.GA17615@redhat.com>
	<200903160934.03700.mega@retes.hu>
	<20090316211316.GA6270@redhat.com>
	<49BED93B.1090700@nortel.com>
	<20090317041337.GA29740@redhat.com>
X-Zippy-Says: I've got to get these SNACK CAKES to NEWARK by DAWN!!
Message-Id: <20090318075901.4FA19FC3AB@magilla.sf.frob.com>
Date: Wed, 18 Mar 2009 00:59:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First of all, perhaps I missed somethings and this is solvable without
> kernel changes, but I can't see how.

It depends what kind of "solved" you mean.

Signals pending for the thread are always delivered before signals pending
for the process.  POSIX does not guarantee this to the application, but it
has always been so in Linux and it's fine enough to rely on that.  Truly
externally-generated and asynchronous signals go to the process, so it's
really only pthread_kill use within your own program that raises the issue.

Among signals pending for the thread, signals < SIGRTMIN are always
delivered before ones >= SIGRTMIN.  POSIX does not guarantee this to the
application, but it has always been so in Linux and it's fine enough to
rely on that.  The most sensible thing to use with pthread_kill is some
SIGRTMIN+n signal anyway, since they are never confused with any other use.
If your program is doing that, you don't have a problem.

So on the one hand it seems pretty reasonable to say it's "solved" by
accepting it when we say, "Welcome to Unix, these things should have
stopped surprising you in the 1980s."  It's a strange pitfall of how
everything fits together, granted.  But you do sort of have to make an
effort to do things screwily before you can fall into it.

All that said, it's actually probably a pretty easy hack to arrange that
the signal posted by force_sig_info is the first one dequeued in all but
the most utterly strange situations.


Thanks,
Roland
