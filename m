Return-Path: <linux-kernel-owner+w=401wt.eu-S1030782AbXDKD5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030782AbXDKD5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 23:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXDKD5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 23:57:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33422 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030782AbXDKD5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 23:57:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] make kernel threads invisible to /sbin/init
References: <20070410185133.GA104@tv-sign.ru>
Date: Tue, 10 Apr 2007 21:56:25 -0600
In-Reply-To: <20070410185133.GA104@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 10 Apr 2007 22:51:33 +0400")
Message-ID: <m1wt0jva1i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> 1. rename reparent_to_init() to reparent_kthread() and export it
>
> 2. use init_pid_ns.child_reaper instead of child_reaper(current)
>
> 3. set ->exit_signal = -1, so init can't see us and we don't use
>    it to reap the task.
>
> 4. add reparent_kthread() to kthread() and stopmachine()
>

If the goal is to hide from /sbin/init.  We don't need to touch
kernel/kthread.c or 
kernel/stop_machine.c

Their parents are already kernel threads.

Yes. There is a startup issue for kernel/kthread.c I just about have
a patch I can stand that addresses that issue.

For the kernel thread they all inherit signals with SIGCHLD set to
SIG_IGN, so there is child auto reaping in that form.  Adding
the ->exit_signal = -1 would be a bonus but is not required.

I am a little concerned with removing the knowledge of who our
real parent is as that may compromise debugging.  The reason
why kernel threads are visible in the first place.

I do support reparenting kernel threads that call daemonize,
and the modifications to reparent_kthread here look reasonable.

Eric
