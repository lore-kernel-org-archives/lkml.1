Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXDKUUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXDKUUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965301AbXDKUUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:20:14 -0400
Received: from mail.screens.ru ([213.234.233.54]:34974 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965292AbXDKUUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:20:12 -0400
Date: Thu, 12 Apr 2007 00:19:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070411201957.GA195@tv-sign.ru>
References: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu> <m17iskz3i8.fsf@ebiederm.dsl.xmission.com> <20070410164441.GB104@tv-sign.ru> <461D3D3E.2060709@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461D3D3E.2060709@tmr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Bill Davidsen wrote:
>
> Oleg Nesterov wrote:
> >On 04/10, Eric W. Biederman wrote:
> >
> >>I'm trying to remember what the story is now.  There is a nasty
> >>race somewhere with reparenting, a threaded parent setting SIGCHLD to
> >>SIGIGN, and non-default signals that results in an zombie that no one
> >>can wait for and reap.  It requires being reparented twice to trigger.
> >
> >reparent_thread:
> >
> >	...
> >
> >        /* If we'd notified the old parent about this child's death,
> >         * also notify the new parent.
> >         */
> >        if (!traced && p->exit_state == EXIT_ZOMBIE &&
> >            p->exit_signal != -1 && thread_group_empty(p))
> >                do_notify_parent(p, p->exit_signal);
> >
> >We notified /sbin/init. If it ignores SIGCHLD, we should release the task.
> >We don't do this.
> >
> >The best fix I believe is to cleanup the 
> >forget_original_parent/reparent_thread
> >interaction and factor out this "exit_state == EXIT_ZOMBIE && exit_signal 
> >== -1"
> >checks.
> >
> As long as the original parent is preserved for getppid(). There are 
> programs out there which communicate between the parent and child with 
> signals, and if the original parent dies, it undesirable to have the 
> child getppid() and start sending signals to a program not expecting 
> them. Invites undefined behavior.

Sorry, can't understand.

If p->exit_signal == -1 after do_notify_parent() above, the task is completely
dead. Nobody can release it, we should do this (if EXIT_ZOMBIE). At this point
"p" was already re-parented, but this (and getppid) doesn't matter at all.

OK. Most likely you meant something else. Could you clarify?

Oleg.

