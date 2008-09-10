Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYIJQPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYIJQPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYIJQP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:15:26 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35340 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYIJQPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:15:25 -0400
Date: Wed, 10 Sep 2008 20:20:08 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
Message-ID: <20080910162008.GA401@tv-sign.ru>
References: <48C51439.7000706@linux.vnet.ibm.com> <20080909124302.GA139@tv-sign.ru> <48C7E3A9.3060602@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C7E3A9.3060602@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10, Pierre Morel wrote:
>
> Oleg Nesterov wrote:
> >
> >I still think this patch shouldn't change handle_signal().
> >
> >Once again. The signal handler for SIGSYS can first do
> >sys_ptrace(PTRACE_SELF_OFF) (which is filtered out), and then use any
> >other syscall, so this change is not needed, afaics.
> >
> Yes it can but what if the application forget to do it?
> It is a security so that the application do not bounce for ever.

The (buggy) task can be killed, this has nothing to do with security.

>From the security pov, this case doesn't differ from, say,

	void sigh(int sig)
	{
		kill(getpid(), sig);
	}

	void main(void)
	{
		signal(SIGSYS, sigh);
		kill(getpid(), SIGSYS);
	}

Or I missed something?

> >So, PTRACE_SELF_XXX disables the "normal" ptrace. Not sure this is good.
> >
> I think that having two tracing system one over the other may be
> quite difficult to handle.

Yes I see.

But... well, I think we need Roland's opinion. I must admit, I am a bit
sceptical about this patch ;) I mean, I don't really understand why it
is useful. We can do the same with fork() + ptrace(). Yes, in that
case we need an "extra" context switch for any traced syscall. But,
do you have any "real life" example to demonstrate that the user-space
solution sucks? We can even use CLONE_MM to speedup the context switch.

Pierre, don't get me wrong. I never used debuggers for myself, I will
be happy to know I am wrong. I just don't understand.


As for ->instrumentation. If you are going to remove PTS_INSTRUMENTED,
we need only one bit. We could use PF_PTS_SELF, but ->flags is already
"contended". Perhaps you can do something like

	--- include/linux/sched.h
	+++ include/linux/sched.h
	@@ -1088,6 +1088,7 @@ struct task_struct {
		/* ??? */
		unsigned int personality;
		unsigned did_exec:1;
	+	unsigned pts_self:1;
		pid_t pid;
		pid_t tgid;
	 

Both did_exec and pts_self can only be changed by current, so it is
safe to share the same word. This way we don't enlarge task_struct.

Oleg.

