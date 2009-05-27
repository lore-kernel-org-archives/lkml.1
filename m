Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbZE1AER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbZE1AER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZE1AEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:04:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbZE1AEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:04:04 -0400
Date: Thu, 28 May 2009 01:59:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
Message-ID: <20090527235936.GB12216@redhat.com>
References: <20090525000016.GA2239@redhat.com> <20090525215903.GA9113@redhat.com> <20090527021131.4778BFC36B@magilla.sf.frob.com> <20090527224140.GC6770@redhat.com> <20090527230700.11F2DFC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527230700.11F2DFC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Roland McGrath wrote:
>
> > 		if (!exit_code)
> > 			child->exit_code = exit_code;
>
> The condition is wrong.  It's unconditional except in the "already killed"
> case that ptrace_detach() is checking for.  It never depends on the value.
> (You probably meant the inverse of this test.  But that's wrong too.
> PTRACE_CONT,0 must clear the old signal and not deliver any signal.)

This is optimization. If exit_code == 0 we do not need to fixup
->last_siginfo. Note that we have another "child->exit_code = exit_code"
below in the slow path.

> > 		if (child->exit_code == exit_code)
> > 			return;
>
> This makes no sense unless it's before setting it.

This also covers the "exit_code == 0" case. If exit_code = 0 we have
already set child->exit_code, we can return.

> > The disadvantage is, ptrace_notify() does not need this, we add the
> > little pessimization...
>
> It can check for !child->last_siginfo before lock_task_sighand().

ptrace_stop() always sets ->last_siginfo != NULL.

> > And. This change adds another dependency with arches which implement
> > their own resume.
>
> The current draft series is meant to assume arch issues are already dealt
> with before this merges.  If we need to sequence this part of it later than
> most of it, we can revisit that later before really preparing to merge it.
>
> > So. Do you think this cleanup should be done before/with this series
> > or we can do it later?
>
> Whatever you think fits best.  Right now I just want to get the rough draft
> of the series all the way to the end of the most substantive work.  Do that
> however seems most efficacious now.  We can juggle the order again later to
> ease the eventual merging.

OK, lets do this change later ;)

Oleg.

