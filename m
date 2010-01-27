Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393Ab0A0NQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0A0NQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174Ab0A0NQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:16:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:37699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab0A0NQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:16:15 -0500
Date: Wed, 27 Jan 2010 13:15:40 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100126181641.GA10460@redhat.com>
References: <20100126181641.GA10460@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep: Fix check_usage_backwards() error message
Message-ID: <tip-48d50674179981e41f432167b2441cec782d5484@git.kernel.org>
Git-Commit-ID: 48d50674179981e41f432167b2441cec782d5484
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jan 2010 13:15:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48d50674179981e41f432167b2441cec782d5484
Gitweb:     http://git.kernel.org/tip/48d50674179981e41f432167b2441cec782d5484
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 26 Jan 2010 19:16:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Jan 2010 08:34:02 +0100

lockdep: Fix check_usage_backwards() error message

Lockdep has found the real bug, but the output doesn't look right to me:

> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.33-rc5 #77
> ---------------------------------------------------------
> emacs/1609 just changed the state of lock:
>  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190
> but this lock took another, HARDIRQ-unsafe lock in the past:
>  (&(&sighand->siglock)->rlock){-.....}

"HARDIRQ-unsafe" and "this lock took another" looks wrong, afaics.

>   ... key      at: [<ffffffff81c054a4>] __key.46539+0x0/0x8
>   ... acquired at:
>    [<ffffffff81089af6>] __lock_acquire+0x1056/0x15a0
>    [<ffffffff8108a0df>] lock_acquire+0x9f/0x120
>    [<ffffffff81423012>] _raw_spin_lock_irqsave+0x52/0x90
>    [<ffffffff8127c1be>] __proc_set_tty+0x3e/0x150
>    [<ffffffff8127e01d>] tty_open+0x51d/0x5e0

The stack-trace shows that this lock (ctrl_lock) was taken under
->siglock (which is hopefully irq-safe).

This is a clear typo in check_usage_backwards() where we tell the print a
fancy routine we're forwards.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100126181641.GA10460@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 5feaddc..c62ec14 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2147,7 +2147,7 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 		return ret;
 
 	return print_irq_inversion_bug(curr, &root, target_entry,
-					this, 1, irqclass);
+					this, 0, irqclass);
 }
 
 void print_irqtrace_events(struct task_struct *curr)
