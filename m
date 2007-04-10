Return-Path: <linux-kernel-owner+w=401wt.eu-S1031103AbXDJQoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031103AbXDJQoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031106AbXDJQoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:44:55 -0400
Received: from mail.screens.ru ([213.234.233.54]:54078 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031103AbXDJQoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:44:54 -0400
Date: Tue, 10 Apr 2007 20:44:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410164441.GB104@tv-sign.ru>
References: <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu> <m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Eric W. Biederman wrote:

> I'm trying to remember what the story is now.  There is a nasty
> race somewhere with reparenting, a threaded parent setting SIGCHLD to
> SIGIGN, and non-default signals that results in an zombie that no one
> can wait for and reap.  It requires being reparented twice to trigger.

reparent_thread:

	...

        /* If we'd notified the old parent about this child's death,
         * also notify the new parent.
         */
        if (!traced && p->exit_state == EXIT_ZOMBIE &&
            p->exit_signal != -1 && thread_group_empty(p))
                do_notify_parent(p, p->exit_signal);

We notified /sbin/init. If it ignores SIGCHLD, we should release the task.
We don't do this.

The best fix I believe is to cleanup the forget_original_parent/reparent_thread
interaction and factor out this "exit_state == EXIT_ZOMBIE && exit_signal == -1"
checks.

Oleg.

