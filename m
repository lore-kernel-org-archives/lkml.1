Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbXLIOUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbXLIOUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 09:20:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXLIOU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 09:20:27 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42451 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXLIOU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 09:20:26 -0500
Date: Sun, 9 Dec 2007 17:21:16 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] will_become_orphaned_pgrp: we have threads
Message-ID: <20071209142116.GB131@tv-sign.ru>
References: <20071208183800.GA9940@tv-sign.ru> <m11w9wpx03.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11w9wpx03.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > p->exit_state != 0 doesn't mean this process is dead, it may have sub-threads.
> >
> > However, the new "p->exit_state && thread_group_empty(p)" check is not correct
> > either, this is just the temporary hack. Perhaps we can just remove this check,
> > but I don't understand orphaned process groups magic. At all. However, I think
> > exit_notify() is obviously and completely wrong wrt this helper.
> 
> The problem that orphaned processes groups address is what happens if
> an entire process group is stopped, and there is not a process that
> can wake them up.
> 
> The rule for an unprivileged process sending a signal to a process
> group is that it must be in the same session as the process group.
> 
> The rule for sending a signal to a process group is that the signal sender
> must be in the same session.
> 
> So we are testing for a process group that does not have a living
> member with a parent outside of the process that can send the process
> group a signal.

Ah, thanks a lot Eric, I am _starting_ to understand this.

> Oleg what do you see wrong with checking p->exit_state &&
> thread_group_empty(p)?   Since non-leader threads all self reap
> that seems to be a valid test for an dead thread group.

There is a window when exit_notify() drops tasklist and before release_task().
Suppose the last (non-leader) thread exits. This means that entire group exits,
but thread_group_empty() is not true.

Oleg.

