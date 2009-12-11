Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZLKNmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZLKNmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbZLKNmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:42:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466AbZLKNmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:42:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091210004703.029784964@linutronix.de>
References: <20091210004703.029784964@linutronix.de> <20091210001308.247025548@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred() access
Date: Fri, 11 Dec 2009 13:41:19 +0000
Message-ID: <13109.1260538879@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> commit c69e8d9 (CRED: Use RCU to access another task's creds and to
> release a task's own creds) added non rcu_read_lock() protected access
> to task creds of the target task in set_prio_one().
> 
> The comment above the function says:
>  * - the caller must hold the RCU read lock
> 
> The calling code in sys_setpriority does read_lock(&tasklist_lock) but
> not rcu_read_lock(). This works only when CONFIG_TREE_PREEMPT_RCU=n.
> With CONFIG_TREE_PREEMPT_RCU=y the rcu_callbacks can run in the tick
> interrupt when they see no read side critical section.
> 
> There is another instance of __task_cred() in sys_setpriority() itself
> which is equally unprotected.
> 
> Wrap the whole code section into a rcu read side critical section to
> fix this quick and dirty.
> 
> Will be revisited in course of the read_lock(&tasklist_lock) -> rcu
> crusade.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: James Morris <jmorris@namei.org>
> Cc: linux-security-module@vger.kernel.org

Acked-by: David Howells <dhowells@redhat.com>
