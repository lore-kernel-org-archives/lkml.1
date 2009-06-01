Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZFAAWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZFAAWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbZFAAWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:22:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZFAAWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:22:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH? tracehook_report_clone: fix false positives
In-Reply-To: Oleg Nesterov's message of  Saturday, 30 May 2009 20:52:12 +0200 <20090530185212.GA10677@redhat.com>
References: <20090528113601.GA18725@redhat.com>
	<20090528114100.GA18744@redhat.com>
	<20090528212418.2F605FC2BD@magilla.sf.frob.com>
	<20090529122411.GC19812@redhat.com>
	<20090530185212.GA10677@redhat.com>
X-Windows: the art of incompetence.
Message-Id: <20090601002226.480CEFC3C7@magilla.sf.frob.com>
Date: Sun, 31 May 2009 17:22:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Firtsly, I don't understand CLONE_PTRACE check. Suppose that untraced
> task does clone(CLONE_PTRACE). In that case we create the untraced
> child (this is correct) but still we send SIGSTOP.
> 
> I do not really know if this bug or not, but this doesn't look right.
> At least this should be commented, imho. And, looking at 2.6.26, I think
> the behaviour was different before tracehooks.
> 
> So, I assume this is bug for now.

You're right.  CLONE_PTRACE when not traced will misbehave (not that anyone
ever uses it).  The old code just checked child->ptrace, and that is fine
to do again now.  I probably changed that thinking it had a race--which it
does--with asynchronous PTRACE_ATTACH after an untraced fork.  But that is
a harmless race as you explained.

ACK on the 2.6.30 patch attached.

> So, I am going to send the patch below. But this leads to another question:
> should not we move these sigaddset() + set_tsk_thread_flag() into
> ptrace_init_task() ?

It might make sense to consolidate them.  But note that ptrace_attach()
uses send_sig_info().  With SEND_SIG_FORCED, this does almost nothing more
than sigaddset() (i.e. no queue entry).  But it does do prepare_signal(),
which will clear any pending SIGCONTs.  It's possible that something in
userland manages to rely on that behavior for the asynchronous attach case
(unrelated to startup-time races).  It wouldn't hurt for the creation-time
case to use send_sig_info() too, though it would go through a bunch more
code to do nothing effectual but sigaddset() in the end.


Thanks,
Roland
