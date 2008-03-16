Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYCPWb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYCPWb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYCPWbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:31:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYCPWbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:31:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: it is fun to strace /sbin/init
In-Reply-To: Oleg Nesterov's message of  Sunday, 16 March 2008 18:54:55 +0300 <20080316155455.GA20848@tv-sign.ru>
References: <20080316155455.GA20848@tv-sign.ru>
X-Shopping-List: (1) Pink rectums
   (2) Nuclear explosion configurations
   (3) Diffident wine absorbers
Message-Id: <20080316223138.1029D26F995@magilla.localdomain>
Date: Sun, 16 Mar 2008 15:31:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ptracing of /sbin/init is not allowed. Of course, this is very dangerous, but
> may be useful. Introduce the kernel boot parameter to allow this.

Personally I wouldn't mind losing all the ptrace/signals special cases for
init.  (Just don't have a buggy init and expect not to crash, don't be root
and kill init, etc.)  So this is fine by me.  The conservative route of
changing it only with a boot option is the wise thing to do.

> Unless I missed something, ptrace_get_task_struct() is pointless. It does not
> need to check "pid == 1", ptrace_attach() does this. It doesn't need tasklist.

Agreed.  It's a hold-over from when there was more hair in there.

> It should be replaced with the generic find_get_task_by_vpid() which does not
> exist yet.

I didn't see enough other uses to really warrant it.  Most
find_task_by_vpid calls don't actually do get_task_struct.
Those that do want to do some other check inside rcu_read_lock
before deciding to bother with get_task_struct anyway.
So there is nothing wrong with ptrace just open-coding:

	rcu_read_lock();
	child = find_task_by_vpid(pid);
	if (child)
		get_task_struct(child);
	rcu_read_unlock();

We are on the way soon to having no arch callers of ptrace_get_task_struct
left, so only the two kernel/ptrace.c uses will survive.  (x86 and ia64
switchovers to arch_ptrace/compat_arch_ptrace are already in the pipeline,
and maybe s390 too.)  So let's worry about the cleanup removing this
function once those wither away.


Thanks,
Roland
