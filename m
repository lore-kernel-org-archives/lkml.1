Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbZH0KTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbZH0KTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 06:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZH0KTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 06:19:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59586 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZH0KTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 06:19:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Aug 2009 19:17:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090827191725.9d943475.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
	<20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827093441.GA3451@redhat.com>
	<20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 18:43:03 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Can't get it. It seems reaped.
> ==
> [root@bluextal mmotm-2.6.31-Aug27]# kill -s 0 2990(CHILD's pid)
> bash: kill: (2990) - No such process
> 

I think I found something. rpc.statd did...

==
[pid  3372] rt_sigaction(SIGCHLD, {0x1, [CHLD], SA_RESTORER|SA_RESTART, 0x7f688fb52f90}, {SIG_DFL, [], 0}, 8) = 0
[pid  3372] rt_sigaction(SIGPIPE, {0x1, [PIPE], SA_RESTORER|SA_RESTART, 0x7f688fb52f90}, {SIG_DFL, [], 0}, 8) = 0
[pid  3372] unlink("/var/run/rpc.statd.pid") = 0
.....
[pid  3372] clone(Process 3373 attached
child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f68902a0780) = 3373
[pid  3372] wait4(3373, Process 3372 suspended
 <unfinished ...>
==

Then, SIG_IGN is set to SIGCHLD handler and children's p->exit_signal == -1.

In old bahaivor, parent, who calls wait, was waken up even if SIG_IGN.
Now, filtered, not wake up.

>From man.
==
 POSIX.1-2001  specifies  that  if the disposition of SIGCHLD is set to SIG_IGN or the SA_NOCLDWAIT
       flag is set for SIGCHLD (see sigaction(2)), then children that terminate do not become zombies and
       a  call  to  wait() or waitpid() will block until all children have terminated, and then fail with
       errno set to ECHILD.  (The original POSIX standard left the behavior of setting SIGCHLD to SIG_IGN
       unspecified.   Note  that  even  though the default disposition of SIGCHLD is "ignore", explicitly
       setting the disposition to SIG_IGN results in different treatment  of  zombie  process  children.)
==
I can't undestand what happens to a parent process which does
	1. set SIG_CHLD to SIG_IGN
	2. call waitpid()
	3. all children goes away.



Thanks,
-Kame

