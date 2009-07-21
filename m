Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZGUIIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZGUIIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 04:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZGUIIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 04:08:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:52130 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbZGUIIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 04:08:35 -0400
Subject: Re: Lockdep warning for sys_tee system call
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1248159597.3794.9.camel@queen>
References: <1248159597.3794.9.camel@queen>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Jul 2009 10:09:23 +0200
Message-Id: <1248163763.15751.11098.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 08:59 +0200, Eric Sesterhenn wrote:
> Hi,
> 
> On one of my systems I get the following lockdep warning, after
> running ./testcases/bin/tee01 from current LTP
> multiple times.
> 
> [ 2000.324359] =======================================================
> [ 2000.324658] [ INFO: possible circular locking dependency detected ]
> [ 2000.324804] 2.6.31-rc3 #10
> [ 2000.324916] -------------------------------------------------------
> [ 2000.325135] tee01/18578 is trying to acquire lock:
> [ 2000.325265]  (&sb->s_type->i_mutex_key#7/2){+.+...}, at: [<c01a5f5b>] pipe_double_lock+0x3b/0x80
> [ 2000.325843] 
> [ 2000.325846] but task is already holding lock:
> [ 2000.326124]  (&sb->s_type->i_mutex_key#7/1){+.+.+.}, at: [<c01a5f45>] pipe_double_lock+0x25/0x80
> [ 2000.326681] 
> [ 2000.326684] which lock already depends on the new lock.
> [ 2000.326689] 
> [ 2000.327062] 
> [ 2000.327066] the existing dependency chain (in reverse order) is:
> [ 2000.327354] 
> [ 2000.327357] -> #1 (&sb->s_type->i_mutex_key#7/1){+.+.+.}:
> [ 2000.327943]        [<c014e9ff>] __lock_acquire+0xbbf/0x1040
> [ 2000.328048]        [<c014eef4>] lock_acquire+0x74/0xa0
> [ 2000.328048]        [<c05ce891>] mutex_lock_nested+0x51/0x280
> [ 2000.328048]        [<c01a5f8c>] pipe_double_lock+0x6c/0x80
> [ 2000.328048]        [<c01bd1cf>] sys_tee+0x12f/0x2c0
> [ 2000.328048]        [<c010305b>] sysenter_do_call+0x12/0x32
> [ 2000.328048]        [<ffffffff>] 0xffffffff
> [ 2000.328048] 
> [ 2000.328048] -> #0 (&sb->s_type->i_mutex_key#7/2){+.+...}:
> [ 2000.328048]        [<c014eab0>] __lock_acquire+0xc70/0x1040
> [ 2000.328048]        [<c014eef4>] lock_acquire+0x74/0xa0
> [ 2000.328048]        [<c05ce891>] mutex_lock_nested+0x51/0x280
> [ 2000.328048]        [<c01a5f5b>] pipe_double_lock+0x3b/0x80
> [ 2000.328048]        [<c01bd1cf>] sys_tee+0x12f/0x2c0
> [ 2000.328048]        [<c010305b>] sysenter_do_call+0x12/0x32
> [ 2000.328048]        [<ffffffff>] 0xffffffff
> [ 2000.328048] 
> [ 2000.328048] other info that might help us debug this:
> [ 2000.328048] 
> [ 2000.328048] 1 lock held by tee01/18578:
> [ 2000.328048]  #0:  (&sb->s_type->i_mutex_key#7/1){+.+.+.}, at: [<c01a5f45>] pipe_double_lock+0x25/0x80
> [ 2000.328048] 
> [ 2000.328048] stack backtrace:
> [ 2000.328048] Pid: 18578, comm: tee01 Not tainted 2.6.31-rc3 #10
> [ 2000.328048] Call Trace:
> [ 2000.328048]  [<c05cd998>] ? printk+0x18/0x20
> [ 2000.328048]  [<c014d494>] print_circular_bug_tail+0x84/0xd0
> [ 2000.328048]  [<c014eab0>] __lock_acquire+0xc70/0x1040
> [ 2000.328048]  [<c014eef4>] lock_acquire+0x74/0xa0
> [ 2000.328048]  [<c01a5f5b>] ? pipe_double_lock+0x3b/0x80
> [ 2000.328048]  [<c05ce891>] mutex_lock_nested+0x51/0x280
> [ 2000.328048]  [<c01a5f5b>] ? pipe_double_lock+0x3b/0x80
> [ 2000.328048]  [<c01a5f5b>] pipe_double_lock+0x3b/0x80
> [ 2000.328048]  [<c01bd1cf>] sys_tee+0x12f/0x2c0
> [ 2000.328048]  [<c014dbbc>] ? trace_hardirqs_on_caller+0x12c/0x180
> [ 2000.328048]  [<c010305b>] sysenter_do_call+0x12/0x32

void pipe_double_lock(struct pipe_inode_info *pipe1,
		      struct pipe_inode_info *pipe2)
{
	BUG_ON(pipe1 == pipe2);

	if (pipe1 < pipe2) {
		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
	} else {
		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
	}
}

That's an obvious FAIL right there.

Miklos?

---
Subject: fs/pipe: rectify a lockdep annotation

The presumed use of the pipe_double_lock() routine is to lock 2 locks in
a deadlock free way by ordering the locks by their address. However it
fails to keep the specified lock classes in order and explicitly
annotates a deadlock.

Rectify this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/pipe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index f7dd21a..52c4151 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -68,8 +68,8 @@ void pipe_double_lock(struct pipe_inode_info *pipe1,
 		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
 		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
 	} else {
-		pipe_lock_nested(pipe2, I_MUTEX_CHILD);
-		pipe_lock_nested(pipe1, I_MUTEX_PARENT);
+		pipe_lock_nested(pipe2, I_MUTEX_PARENT);
+		pipe_lock_nested(pipe1, I_MUTEX_CHILD);
 	}
 }
 

