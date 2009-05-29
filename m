Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbZE2L5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbZE2L5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 07:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757677AbZE2L5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 07:57:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50501 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886AbZE2L5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 07:57:46 -0400
Date: Fri, 29 May 2009 13:53:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/12 v2] ptrace: introduce the empty "struct
	ptrace_context"
Message-ID: <20090529115306.GA19812@redhat.com>
References: <20090528113545.GA18691@redhat.com> <20090528211540.2A5BAFC2BD@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528211540.2A5BAFC2BD@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Roland McGrath wrote:
>
> > +	task_lock(tsk);
> > +	if (likely(!tsk->ptrace_ctx))
> > +		tsk->ptrace_ctx = ptrace_ctx;
> > +	else
> > +		kfree(ptrace_ctx);
> > +	task_unlock(tsk);
>
> I don't think it's kosher call kfree with task_lock() held.

Yes, it always makes sense to move as much as possible outside of
spin_lock/etc, but

> The kfree case is a very unlikely path,

Exactly, this kfree() "never" runs under task_lock(), but the code
looks a bit simpler and shorter.

> so it can be:
>
> 	task_lock(tsk);
> 	if (likely(!tsk->ptrace_ctx)) {
> 		tsk->ptrace_ctx = ptrace_ctx;
> 		task_unlock(tsk);
> 		return 0;
> 	}
>
> 	task_unlock(tsk);
> 	kfree(ptrace_ctx);

OK, will change.

Oleg.

