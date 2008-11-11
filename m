Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbYKKL6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbYKKL6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbYKKL6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:58:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47131 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbYKKL6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:58:21 -0500
Date: Tue, 11 Nov 2008 13:58:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frank Mayhar <fmayhar@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, adobriyan@gmail.com,
       Doug Chapman <doug.chapman@hp.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] for account_group_exec_runtime(), make sure ->signal
	can't be freed under rq->lock
Message-ID: <20081111125844.GB3503@redhat.com>
References: <20081110143930.GA28275@redhat.com> <20081111103532.GA8869@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111103532.GA8869@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > The patch is ugly, but I don't see the better fix for now. Needs the
> > review from Peter/Ingo.
>
> this is indeed too ugly,

Agreed. It was "unless we find another fix for 2.6.28".

> Regarding this teardown bug. Stupid question: why cannot the signal
> structure live as long as the last user is around? It's a tiny amount
> of RAM.

Well, release_task()->__exit_signal() clears/frees ->signal exactly
because it doesn't (must not) have users any longer. And we have the
code which checks ->signal != NULL to know if the task was already
released or not.

Now scheduler wants to play with ->signal. We can change the code so
that we don't actually free it until the task does the last schedule.
Say, we can free it __from put_task_struct(). But this means we need
another counter in signal_struct (signal_struct->count can't work).
And, until we change the code which checks ->signal != NULL, we need
another pointer in task_struct.


Perhaps this makes sense regardless of this bug, but I don't think
this is 2.6.28 material anyway.

Oleg.

