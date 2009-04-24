Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDXL4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDXL4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 07:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZDXL41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:56:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42047 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZDXL40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:56:26 -0400
Date: Fri, 24 Apr 2009 12:55:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Sachin Sant <sachinp@in.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@redhat.com>, peterz@infradead.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: Next April 24 : BUG: lock held at task exit time!
In-Reply-To: <20090424175509.561c96ad.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0904241249180.20196@blonde.anvils>
References: <20090424150456.ff35e4ea.sfr@canb.auug.org.au> <49F1626D.6080102@in.ibm.com>
 <20090424175509.561c96ad.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Stephen Rothwell wrote:
> On Fri, 24 Apr 2009 12:25:41 +0530 Sachin Sant <sachinp@in.ibm.com> wrote:
> >
> > While booting today's next tree on a powerpc box [ power 6 blade]
> > observed the following :
> > 
> > khelper used greatest stack depth: 10176 bytes left
> > 
> > =====================================
> > [ BUG: lock held at task exit time! ]
> > -------------------------------------
> > khelper/21 is exiting with locks still held!
> > 2 locks held by khelper/21:
> >  #0:  (rcu_read_lock){.+.+.+}, at: [<c0000000001382fc>] 
> > .check_unsafe_exec+0x44/0x148
> >  #1:  (rcu_read_lock){.+.+.+}, at: [<c000000000138368>] 
> > .check_unsafe_exec+0xb0/0x148
> > 
> > stack backtrace:
> > Call Trace:
> > [c000000044483cf0] [c000000000011a54] .show_stack+0x6c/0x16c (unreliable)
> > [c000000044483da0] [c00000000009ae14] .debug_check_no_locks_held+0x98/0xb4
> > [c000000044483e20] [c000000000073b1c] .do_exit+0x758/0x7b0
> > [c000000044483f00] [c0000000000853d8] .____call_usermodehelper+0x170/0x174
> > [c000000044483f90] [c00000000002bd8c] .kernel_thread+0x54/0x70
> > net_namespace: 2000 bytes
> > 
> > Complete dmesg attached. Let me know if you need any other info. I will 
> > try yesterday's next
> > tree to check if this problem can be recreated.
> 
> Almost certainly commit 874a9e18f25c86dbc199ad32ddd9ca44d25290e8
> ("check_unsafe_exec: s/lock_task_sighand/rcu_read_lock/") which has a
> typo (two locks instead of lock/unlock) as pointed out by Hugh Dickins
> (<Pine.LNX.4.64.0904240526080.15735@blonde.anvils> on LKML).

Indeed, thanks for the headsup Stephen.  My own config gives, not
Sachin's message (or not still visibly on screen anyway), but an
outright panic.  Shame that leaked out into the big world, we'd
all have preferred a quiet fixup!  Here's a patch, which I'll
also send as reply to the relevant thread.

[PATCH] check_unsafe_exec: rcu_read_unlock

Fix typo in previous commit: second rcu_read_lock should be rcu_read_unlock.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.30-rc3-next-20090424/fs/exec.c	2009-04-24 12:23:43.000000000 +0100
+++ linux/fs/exec.c	2009-04-24 12:26:10.000000000 +0100
@@ -1043,7 +1043,7 @@ int check_unsafe_exec(struct linux_binpr
 		if (t->fs == p->fs)
 			n_fs++;
 	}
-	rcu_read_lock();
+	rcu_read_unlock();
 
 	if (p->fs->users > n_fs) {
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
