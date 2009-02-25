Return-Path: <linux-kernel-owner+w=401wt.eu-S1760453AbZBYTwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbZBYTwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbZBYTvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:51:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53195 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757381AbZBYTvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:51:54 -0500
Date: Wed, 25 Feb 2009 20:48:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
	interaction
Message-ID: <20090225194851.GA9139@redhat.com>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225193927.1ED25FC3DA@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Roland McGrath wrote:
>
> As I think I said before, I don't really know what the actual use case is
> for CLONE_PARENT without CLONE_THREAD.  So it's easy to approve changing
> its behavior, but I do vaguely worry about who expected what behavior before.

Me too ;)

Hopefully CC is wide enough...

> Just for readability, I would prefer that you just change the first line
> above that sets p->exit_signal initially.  i.e. (but with some comments):
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index a66fbde..f56793b 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1184,7 +1184,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	p->parent_exec_id = p->self_exec_id;
>
>  	/* ok, now we should be set up.. */
> -	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
> +	p->exit_signal = ((clone_flags & CLONE_THREAD) ? -1 :
> +			  (clone_flags & CLONE_PARENT) ?
> +			  current->group_leader->exit_signal :
> +			  (clone_flags & CSIGNAL));

Yes, I sent this patch to rhel list because it is most simple.

But afaics this is not exactly right.

The task T has ->exit_signal != SIGCHLD, say, SIGHUP. It does
clone(CLONE_PARENT), copy_process() sets ->exit_signal = SIGHUP.

T->parent exits, T is re-parented to /sbin/init, and its ->exit_signal
is changed to SIGCHLD.

copy_process() continues, takes tasklist, notices CLONE_PARENT and
sets ->real_parent = init. But child's ->exit_signal is still SIGHUP.

Oleg.

