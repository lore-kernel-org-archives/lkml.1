Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbXDIBHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbXDIBHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 21:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbXDIBHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 21:07:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46673 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbXDIBHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 21:07:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <20070408155337.GA126@tv-sign.ru>
	<m1lkh23kkb.fsf@ebiederm.dsl.xmission.com>
	<20070408165750.GA149@tv-sign.ru>
Date: Sun, 08 Apr 2007 19:05:29 -0600
In-Reply-To: <20070408165750.GA149@tv-sign.ru> (Oleg Nesterov's message of
	"Sun, 8 Apr 2007 20:57:50 +0400")
Message-ID: <m1d52e2w86.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/08, Eric W. Biederman wrote:
>
>> If we are going to have kernel only flags please use an additional
>> argument to do_fork and copy_process.
>
> Yes, we can do this. But we have a number of architectures which use
> sys_clone() to implement kernel_thread(). It would be nice to have an
> architecture neutral kernel_thread() implementation as you proposed.
> We should change all of them if we want to add a new parameter to
> do_fork().
>
> Perhaps it is better to add reparent_kthread() (next patch) to kthread()
> and forget about CLONE_KERNEL_THREAD.

Please. 

> Anyway, re-parenting to swapper breaks pstree, it doesn't show kernel
> threads. And if ->parent == /sbin/init, we can't remove us from ->children
> (unless we forbid sub-thread-of-init exec). So the only safe change is
> set ->exit_state = -1.

Yes.  We certainly need ->exit_state = -1.
Earlier I had forgotten about second the use of ->children to update
the parent pointer of processes when their parent exits.

There is a practical question how much we care about pstree being
confused (I assume it doesn't crash).  If this is just a confusion
issue then I say go for it.  PPID == 0 is a very legitimate way to say
the kernel is the parent process.

There are a few more cases where we are likely to get PPID == 0 in the
future and /sbin/init already has that now.  Plus there is a lot of
historic precedent.  The odd part is PPID = 0 having multiple
children.

If we decide maintaining a tree is important I would much rather put
init_task on the task_list so we can see it in /proc then go the other
way around.

I would like a confirmation that it PPID == 0 is what is confusing
pstree just to make certain we haven't half filled in some field
in init_task and are thus giving in correct /proc output.  But that is
all the double checking I would do.

>> Your current scheme also has the bad side that if user space supplied
>> a kernel flag it is hard to detect it and return -EINVAL.  Which
>> limits future expansion.  Silently dropping clone flags is a real
>> pain, if you are trying to detect if a new flag has been implemented.
>
> Yes. But that is what we are doing now. copy_process() just ignores
> unknown flags.

Agreed.  I fixed that in sys_unshare but I should really submit a
patch to do the same for sys_clone at some point.

When know flags aren't implemented we certainly return -EINVAL.

Given that this line of work looks to fix the race that messes allows
a threaded init to generate unkillable zombies I can probably find
some time in the next while to work on it.

Eric
