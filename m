Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbZE0Xhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbZE0Xhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZE0Xh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:37:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbZE0Xh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:37:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 00:41:40 +0200 <20090527224140.GC6770@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090527021131.4778BFC36B@magilla.sf.frob.com>
	<20090527224140.GC6770@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090527230700.11F2DFC2BD@magilla.sf.frob.com>
Date: Wed, 27 May 2009 16:07:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 		if (!exit_code)
> 			child->exit_code = exit_code;

The condition is wrong.  It's unconditional except in the "already killed"
case that ptrace_detach() is checking for.  It never depends on the value.
(You probably meant the inverse of this test.  But that's wrong too.
PTRACE_CONT,0 must clear the old signal and not deliver any signal.)

> 		if (child->exit_code == exit_code)
> 			return;

This makes no sense unless it's before setting it.

> 		if (lock_task_sighand(child, &flags)) {
> 			siginfo_t *info = child->last_siginfo;
[...]
> And ptrace_resume/ptrace_detach should use ptrace_set_exit_code()
> instead of child->exit_code = data.

Right.

> The disadvantage is, ptrace_notify() does not need this, we add the
> little pessimization...

It can check for !child->last_siginfo before lock_task_sighand().

> And. This change adds another dependency with arches which implement
> their own resume.

The current draft series is meant to assume arch issues are already dealt
with before this merges.  If we need to sequence this part of it later than
most of it, we can revisit that later before really preparing to merge it.

> So. Do you think this cleanup should be done before/with this series
> or we can do it later?

Whatever you think fits best.  Right now I just want to get the rough draft
of the series all the way to the end of the most substantive work.  Do that
however seems most efficacious now.  We can juggle the order again later to
ease the eventual merging.


Thanks,
Roland
