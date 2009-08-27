Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZH0Jiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZH0Jiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZH0Jiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbZH0Jiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:38:50 -0400
Date: Thu, 27 Aug 2009 11:34:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-ID: <20090827093441.GA3451@redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org> <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com> <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, KAMEZAWA Hiroyuki wrote:
>
> On Thu, 27 Aug 2009 14:44:53 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> >
> > In the newest mmotom, my S14nfslock hangs up. (x86-64/Fedora10)
> >
> > On Mon, 24 Aug 2009 16:28:30 -0700
> > akpm@linux-foundation.org wrote:
> >
> > > ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
> > > do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
> >
> > bisected. following 2 patches for filtering SIGCHLD cause hang (for my environ).
> >
> > > do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
> > > do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch

Confused. Which patch causes the hang? They should be applied in reverse order,

	do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
	do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch

> removed S14nfslockd from rc5.d and check it by strace
> ==
>  2712] fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> [pid  2712] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fc6f263c000
> [pid  2712] dup(6)                      = 7
> [pid  2712] write(6, "2712\n"..., 5)    = 5
> [pid  2712] close(6)                    = 0
> [pid  2712] munmap(0x7fc6f263c000, 4096) = 0
> [pid  2712] clone(Process 2713 attached
> child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fc6f2625780) = 2713
> [pid  2712] wait4(2713, Process 2712 suspended
>  <unfinished ...>
> ==
> When process 2713 exits, process 2712 don't wake up.

Hmm, very strange. How can I reproduce?

When the child (2713) exits and the parent hangs, could you send
me the content of /proc/parent_pid/status?

OK, suppose that due to the patch above we lost the notification.
But, wait4 returns -ECHILD, who reaped this child???

What does "$ ps CHILD_PID" say? /proc/child_pid/status please?

Oleg.

